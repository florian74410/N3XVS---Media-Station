#!/usr/bin/env python3
from pathlib import Path
import os
import sys
import signal
import fcntl
import getpass
from PySide6.QtCore import QUrl, QTimer
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from core.backend import Backend

def main():
    state = Path(os.environ.get("XDG_STATE_HOME", Path.home()/".local/state"))/"n3xvs-media"
    state.mkdir(mode=0o700, parents=True, exist_ok=True)
    with (state/"instance.lock").open("a+") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return 0
        app = QGuiApplication(sys.argv)
        app.setApplicationName("NEXUS Multimedia")
        app.setQuitOnLastWindowClosed(False)
        backend = Backend()
        engine = QQmlApplicationEngine()
        ctx = engine.rootContext()
        ctx.setContextProperty("station", backend)
        ctx.setContextProperty("loginName",getpass.getuser())
        import json
        demo = json.loads((Path(__file__).parent/"data/demo.json").read_text())
        ctx.setContextProperty("demoItems", [dict(title=t, genre=g, art=QUrl.fromLocalFile(str(Path(__file__).resolve().parents[2]/f"Assets/Posters/landscape-{i}.jpg"))) for i,(t,g) in enumerate(demo)])
        city = Path(__file__).resolve().parents[2]/"Assets/Backgrounds/nexus-city.png"
        ctx.setContextProperty("cityUrl", QUrl.fromLocalFile(str(city)) if city.exists() else QUrl())
        engine.load(QUrl.fromLocalFile(str(Path(__file__).parent/"ui/Main.qml")))
        if not engine.rootObjects():
            return 1
        window = engine.rootObjects()[0]
        if os.environ.get("NEXUS_FULLSCREEN") == "1":
            window.showFullScreen()
        signal.signal(signal.SIGUSR1, lambda *_: (window.show(),window.raise_(),window.requestActivate()))
        signal.signal(signal.SIGTERM, lambda *_: app.quit())
        signal.signal(signal.SIGINT, lambda *_: app.quit())
        pid = state/"nexus.pid"
        pid.write_text(str(os.getpid()))
        try:
            return app.exec()
        finally:
            backend.close()
            pid.unlink(missing_ok=True)

if __name__ == "__main__":
    sys.exit(main())
