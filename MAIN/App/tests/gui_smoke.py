"""Exercise the normal app on Qt's offscreen platform; optionally export captures."""
import argparse
from pathlib import Path
import sys
import tempfile
import os
from PySide6.QtCore import QTimer, Qt
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickWindow
from PySide6.QtTest import QTest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]/"nexus_media"))
import main

def run():
    parser = argparse.ArgumentParser()
    parser.add_argument("--captures", type=Path)
    args = parser.parse_args()
    app_main = QGuiApplication.exec
    errors = []
    def exercise():
        try:
            window = next(w for w in QGuiApplication.topLevelWindows() if isinstance(w,QQuickWindow) and w.title()=="NEXUS Multimedia")
            for width, height in [(1280,800),(1920,1080),(2560,1440),(640,480)]:
                window.resize(width,height)
                window.requestActivate()
                QTest.qWait(150)
                img = window.grabWindow()
                assert img.width()==width and img.height()==height
                if args.captures:
                    assert img.save(str(args.captures/f"nexus-{width}x{height}.png"))
            window.resize(1280,800)
            for page in window.property("sections").toVariant():
                window.setProperty("page",page)
                QTest.qWait(40)
            QTest.keyClick(window, Qt.Key.Key_Tab)
            QTest.keyClick(window, Qt.Key.Key_Return)
        except BaseException as exc:
            errors.append(exc)
        QGuiApplication.quit()
    def hook():
        QTimer.singleShot(100, exercise)
        return app_main()
    QGuiApplication.exec = staticmethod(hook)
    with tempfile.TemporaryDirectory() as tmp:
        os.environ.update(XDG_DATA_HOME=tmp,XDG_STATE_HOME=tmp,QT_QPA_PLATFORM="offscreen",QT_QUICK_BACKEND="software")
        assert main.main()==0
    if errors:
        raise errors[0]

if __name__=="__main__":
    run()
