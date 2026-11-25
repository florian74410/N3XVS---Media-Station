from dataclasses import dataclass
from pathlib import Path
import re

@dataclass(frozen=True)
class MediaItem:
    path: Path
    title: str

    def presentation(self):
        year = re.search(r"\b(?:19|20)\d{2}\b", self.title)
        art = ""
        for ext in (".jpg",".jpeg",".png",".webp"):
            candidate = self.path.with_suffix(ext)
            if candidate.is_file() and not candidate.is_symlink():
                art = candidate.as_uri()
                break
        return {"art":art,"year":year.group() if year else "","rating":None}
