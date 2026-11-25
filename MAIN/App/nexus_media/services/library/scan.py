import json
import os
from pathlib import Path
import shutil
import subprocess
from storage.catalog import Catalog

EXTENSIONS = {".mp4", ".mkv", ".avi", ".webm", ".mov", ".mp3", ".flac", ".m4v", ".ts"}

def metadata(path):
    if shutil.which("ffprobe"):
        try:
            raw = subprocess.check_output(["ffprobe", "-v", "error", "-protocol_whitelist", "file",
                "-show_entries", "stream=codec_name:format=duration", "-of", "json", str(path)],
                timeout=8, stderr=subprocess.DEVNULL)
            data = json.loads(raw)
            return float(data["format"].get("duration", 0)), next(iter(data["streams"]), {}).get("codec_name", "")
        except (OSError, ValueError, KeyError, subprocess.SubprocessError):
            pass
    return 0, ""

def scan(root, directory):
    root = Path(root).resolve(strict=True)
    if not root.is_dir():
        raise ValueError("Choisir un dossier")
    catalog = Catalog(directory)
    count = 0
    try:
        for folder, _, files in os.walk(root):
            for name in files:
                path = Path(folder, name)
                if path.suffix.lower() not in EXTENSIONS or path.is_symlink() or not path.is_file():
                    continue
                stamp = path.stat().st_mtime_ns
                key = str(path)
                old = catalog.db.execute("SELECT stamp FROM media WHERE path=?", (key,)).fetchone()
                if old and old[0] == stamp:
                    continue
                duration, codec = metadata(path)
                with catalog.db:
                    catalog.db.execute("""INSERT INTO media(path,title,stamp,duration,codec)
                        VALUES(?,?,?,?,?) ON CONFLICT(path) DO UPDATE SET
                        title=excluded.title, stamp=excluded.stamp, duration=excluded.duration,codec=excluded.codec""",
                        (key, path.stem, stamp, duration, codec))
                count += 1
        return count
    finally:
        catalog.db.close()
