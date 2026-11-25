"""Explicit storage paths on a previously mounted external volume."""
from pathlib import Path

def layout(mount):
    root = Path(mount).resolve(strict=True)
    if not root.is_mount():
        raise ValueError("Le disque configuré est absent ou non monté")
    return {name: root/name for name in ("Media","UserData","Databases","Backups")}
