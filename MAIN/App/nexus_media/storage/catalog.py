import json
from models.media import MediaItem
from pathlib import Path
import sqlite3

class Catalog:
    def __init__(self, directory):
        directory.mkdir(mode=0o700, parents=True, exist_ok=True)
        self.db = sqlite3.connect(directory / "catalog.sqlite3")
        self.db.row_factory = sqlite3.Row
        self.db.executescript("""
            PRAGMA journal_mode=WAL;
            CREATE TABLE IF NOT EXISTS media(path TEXT PRIMARY KEY, title TEXT,
              stamp INTEGER, duration REAL, codec TEXT, position REAL DEFAULT 0,
              seen INTEGER DEFAULT 0);
            CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY, value TEXT);
        """)

        if "watchlist" not in {row["name"] for row in self.db.execute("PRAGMA table_info(media)")}:
            with self.db:
                self.db.execute("ALTER TABLE media ADD COLUMN watchlist INTEGER DEFAULT 0")

    def get(self, key, default=None):
        row = self.db.execute("SELECT value FROM settings WHERE key=?", (key,)).fetchone()
        return json.loads(row[0]) if row else default

    def put(self, key, value):
        with self.db:
            self.db.execute("INSERT OR REPLACE INTO settings VALUES(?,?)", (key, json.dumps(value)))

    def page(self, term="", offset=0, watching=False):
        rows = self.db.execute("""
            SELECT * FROM media WHERE instr(lower(title),lower(?)) AND
            (?=0 OR (position>0 AND seen=0)) ORDER BY title,path LIMIT 48 OFFSET ?
        """, (term, watching, offset))
        return [dict(r) | MediaItem(Path(r["path"]),r["title"]).presentation() for r in rows]
