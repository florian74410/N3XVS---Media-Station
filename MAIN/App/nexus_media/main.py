#!/usr/bin/env python3
"""Démonstrateur Qt Quick sans navigateur et sans action destructive."""
from pathlib import Path
import sys

try:
    from PySide6.QtCore import QUrl
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine
except ImportError as exc:
    print("PySide6 non disponible. Installer les paquets du profil core; voir installation.sh --check.", file=sys.stderr)
    raise SystemExit(2) from exc


def main() -> int:
    app = QGuiApplication(sys.argv)
    app.setApplicationName("N3XVS Multimedia")
    engine = QQmlApplicationEngine()
    qml = Path(__file__).resolve().parent / "ui" / "Main.qml"
    engine.load(QUrl.fromLocalFile(str(qml)))
    if not engine.rootObjects():
        print(f"Impossible de charger la GUI : {qml}", file=sys.stderr)
        return 1
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
