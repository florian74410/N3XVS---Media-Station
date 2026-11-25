import json
import os
from pathlib import Path
import threading
from PySide6.QtCore import QObject, Signal, Slot, QTimer, QUrl
from services.library.scan import scan
from services.iptv.playlist import channels
from services.providers.launch import launch
from services.playback.player import play, local_player, EmbeddedEngine
from storage.catalog import Catalog

class Backend(QObject):
    message = Signal(str)
    discovered = Signal("QVariantList")
    browsed = Signal("QVariantList")
    changed = Signal()
    external = Signal(bool)
    controls = Signal(bool)
    scanned = Signal(str)

    def __init__(self):
        super().__init__()
        self.directory = Path(os.environ.get("XDG_DATA_HOME", Path.home()/".local/share"))/"nexus-media"
        mount = os.environ.get("NEXUS_DATA_MOUNT")
        self.storage_warning = ""
        if mount:
            from services.network.volumes import layout
            try:
                self.directory = layout(mount)["Databases"]/"nexus-media"
            except (OSError,ValueError):
                self.storage_warning = "Disque de données absent · catalogue local de secours · "
        self.catalog = Catalog(self.directory)
        self.providers = json.loads((Path(__file__).resolve().parents[1]/"config/providers.json").read_text())
        self.proc = self.profile = None
        self.playing_path = None
        self.saved_position = 0
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

    @Slot("QVariantMap",str,int)
    def browse(self, server, folder, offset):
        from services.dlna.content import browse
        from xml.etree.ElementTree import ParseError
        def worker():
            try:
                self.browsed.emit(browse(server,folder,max(0,offset)))
            except (ValueError,KeyError,OSError,ParseError) as exc:
                self.browsed.emit([])
                self.message.emit(str(exc))
        threading.Thread(target=worker,daemon=True).start()

    @Slot()
    def discover(self):
        from services.dlna.discovery import discover
        def worker():
            try:
                devices = discover()
                self.discovered.emit(devices)
                self.message.emit(f"{len(devices)} réponse(s) MediaServer sur le LAN")
            except OSError as exc:
                self.discovered.emit([])
                self.message.emit(str(exc))
        threading.Thread(target=worker, daemon=True).start()

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
        return self.storage_warning + f"{count} média(s) indexé(s)   ·   {source}"

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

    @Slot()
    def openVlc(self):
        import shutil
        import subprocess
        if self.proc:
            return
        exe = shutil.which("vlc")
        if not exe:
            self.message.emit("VLC absent · profil media")
            return
        try:
            self.proc = subprocess.Popen([exe,"--no-one-instance"])
            self.external.emit(True)
        except OSError as exc:
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
            self.proc = local_player(path,row[0]) if row else play(path)
            self.playing_path = path if row else None
            self.saved_position = row[0] if row else 0
            if isinstance(self.proc, EmbeddedEngine):
                self.controls.emit(True)
            else:
                self.external.emit(True)
        except (OSError, ValueError) as exc:
            self.message.emit(str(exc))

    @Slot()
    def pause(self):
        if isinstance(self.proc, EmbeddedEngine):
            self.proc.player.pause()

    @Slot()
    def stopLocal(self):
        if isinstance(self.proc, EmbeddedEngine):
            pos=self.proc.seconds()
            if pos>0:
                self.bookmark(self.playing_path,pos,False)
            self.proc.close()
            self.proc=None
            self.controls.emit(False)

    @Slot(str, float, bool)
    def bookmark(self, path, seconds, seen):
        with self.catalog.db:
            self.catalog.db.execute("UPDATE media SET position=max(0,?),seen=? WHERE path=?", (seconds, seen, path))
        self.changed.emit()

    def poll(self):
        if isinstance(self.proc, EmbeddedEngine):
            pos = self.proc.seconds()
            if pos > 0 and abs(pos-self.saved_position)>=5:
                self.bookmark(self.playing_path,pos,False)
                self.saved_position = pos
        if self.proc and self.proc.poll() is not None:
            code = self.proc.returncode
            if isinstance(self.proc, EmbeddedEngine):
                if self.proc.ended:
                    self.bookmark(self.playing_path,0,True)
                self.proc.close()
                self.controls.emit(False)
            self.proc = None
            if self.profile:
                self.profile.cleanup()
                self.profile = None
            self.external.emit(False)
            self.message.emit("Session externe terminée" if not code else f"Sortie externe {code}")
