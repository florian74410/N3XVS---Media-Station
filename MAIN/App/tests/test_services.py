import sys
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/"nexus_media"))
from services.library.scan import scan
from services.iptv.playlist import channels
from services.playback.player import play
from storage.catalog import Catalog

class Services(unittest.TestCase):
    def setUp(self):
        temp=tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        self.root=Path(temp.name)
        self.db=self.root/"state"

    def test_incremental_index_progress_and_filter(self):
        path=self.root/"Éclipse.mp4"
        path.touch()
        with patch("services.library.scan.metadata",return_value=(3600,"hevc")) as probe:
            self.assertEqual(scan(self.root,self.db),1)
            self.assertEqual(scan(self.root,self.db),0)
            probe.assert_called_once()
        catalog=Catalog(self.db)
        self.addCleanup(catalog.db.close)
        self.assertEqual(catalog.page("clipse")[0]["codec"],"hevc")
        self.assertEqual(catalog.page("aucun"),[])
        with catalog.db:
            catalog.db.execute("UPDATE media SET position=120")
        self.assertEqual(catalog.page(watching=True)[0]["position"],120)

    def test_missing_disk(self):
        with self.assertRaises(FileNotFoundError):
            scan(self.root/"débranché",self.db)

    def test_playlist(self):
        file=self.root/"tv.m3u"
        file.write_text("#EXTM3U\n#EXTINF:-1,Test\nrtsp://192.168.1.1/test\nfile:///etc/passwd\nhttps://name:pw@example.org/a\n")
        self.assertEqual(channels(file),[dict(title="Test",path="rtsp://192.168.1.1/test")])

    @patch("services.playback.player.shutil.which",return_value=None)
    def test_missing_player(self,_):
        with self.assertRaisesRegex(ValueError,"VLC absent"):
            play("/un film.mp4")
