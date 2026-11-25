from pathlib import Path
from urllib.parse import urlsplit

def channels(file):
    p = Path(file)
    if not p.is_file() or p.stat().st_size > 4_000_000:
        raise ValueError("Playlist absente ou trop grande")
    title = ""
    result = []
    for line in p.read_text(encoding="utf-8-sig").splitlines():
        line = line.strip()
        if line.startswith("#EXTINF:"):
            title = line.partition(",")[2]
        elif line and not line.startswith("#"):
            url = urlsplit(line)
            if url.scheme in {"http", "https", "rtsp"} and url.hostname and not url.username and not any(c.isspace() for c in line):
                result.append(dict(title=title or url.hostname, path=line))
            title = ""
    return result
