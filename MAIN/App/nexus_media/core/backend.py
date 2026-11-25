import json
import os
from pathlib import Path
import threading
from PySide6.QtCore import QObject, Signal, Slot, QTimer, QUrl
from services.library.scan import scan
from services.iptv.playlist import channels
from services.providers.launch import launch
from services.playback.player import play
from storage.catalog import Catalog

class Backend(QObject):
    message = Signal(str)
    changed = Signal()
    external = Signal(bool)
    scanned = Signal(str)

    def __init__(self):
        super().__init__()
        self.directory = Path(os.environ.get("XDG_DATA_HOME", Path.home()/".local/share"))/"nexus-media"
        self.catalog = Catalog(self.directory)
        self.providers = json.loads((Path(__file__).resolve().parents[1]/"config/providers.json").read_text())
        self.proc = self.profile = None
        self.busy = False
        self.scanned.connect(self.finished)
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.poll)
        self.timer.start(500)
        self.watcher = QTimer(self)
        self.watcher.timeout.connect(self.rescan)
        self.watcher.start(120000)

    @Slot()
    def rescan(self):
        root = self.catalog.get("root")
        if root and Path(root).is_dir() and not self.busy:
            self.index(QUrl.fromLocalFile(root))

    @Slot(QUrl)
    def index(self, url):
        root = url.toLocalFile()
        if self.busy or not Path(root).is_dir() or not root:
            return
        self.catalog.put("root", root)
        self.busy = True
        def worker():
            try:
                result = f"{scan(root, self.directory)} média(s) ajouté(s) ou actualisé(s)"
            except (OSError, ValueError, RuntimeError) as exc:
                result = str(exc)
            finally:
                self.scanned.emit(locals().get("result", "Échec du scan"))
        threading.Thread(target=worker, daemon=True).start()
        self.message.emit("Indexation en cours…")

    @Slot(str)
    def finished(self, msg):
        self.busy = False
        self.message.emit(msg)
        self.changed.emit()

    @Slot(str, int, bool, result="QVariantList")
    def items(self, term, offset, watching):
        return self.catalog.page(term, offset, watching)

    @Slot(result=str)
    def summary(self):
        count = self.catalog.db.execute("SELECT COUNT(*) FROM media").fetchone()[0]
        root = self.catalog.get("root")
        source = ("Source absente" if not Path(root).is_dir() else Path(root).name) if root else "Aucun dossier sélectionné"
        return f"{count} média(s) indexé(s)   ·   {source}"

    @Slot(QUrl, result="QVariantList")
    def playlist(self, url):
        try:
            result = channels(url.toLocalFile())
            self.message.emit(f"{len(result)} chaîne(s) importée(s) · disponibilité à tester en lecture")
            return result
        except (ValueError, OSError) as exc:
            self.message.emit(str(exc))
            return []

    @Slot(str)
    def provider(self, name):
        if self.proc or name not in self.providers:
            return
        try:
            self.proc, self.profile = launch(self.providers[name])
            self.external.emit(True)
        except (OSError, ValueError) as exc:
            self.message.emit(str(exc))

    @Slot(str)
    def watch(self, path):
        if self.proc:
            return
        try:
            row = self.catalog.db.execute("SELECT position FROM media WHERE path=?", (path,)).fetchone()
            if row and not Path(path).is_file():
                raise ValueError("Source absente · reconnecter le volume")
            if not row and not path.startswith(("http://","https://","rtsp://")):
                raise ValueError("Média inconnu")
            self.proc = play(path, row[0] if row else 0)
            self.external.emit(True)
        except (OSError, ValueError) as exc:
            self.message.emit(str(exc))

    @Slot(str, float, bool)
    def bookmark(self, path, seconds, seen):
        with self.catalog.db:
            self.catalog.db.execute("UPDATE media SET position=max(0,?),seen=? WHERE path=?", (seconds, seen, path))
        self.changed.emit()

    def poll(self):
        if self.proc and self.proc.poll() is not None:
            code = self.proc.returncode
            self.proc = None
            if self.profile:
                self.profile.cleanup()
                self.profile = None
            self.external.emit(False)
            self.message.emit("Session externe terminée" if not code else f"Sortie externe {code}")
