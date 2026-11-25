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

class Handoff(unittest.TestCase):
    def test_external_exit_restores_gui(self):
        from unittest.mock import Mock
        from core.backend import Backend
        from PySide6.QtCore import QCoreApplication
        import os
        self.app=QCoreApplication.instance() or QCoreApplication([])
        with tempfile.TemporaryDirectory() as temp, patch.dict(os.environ,XDG_DATA_HOME=temp):
            backend=Backend()
            self.addCleanup(backend.catalog.db.close)
            changes=[]
            backend.external.connect(changes.append)
            proc=Mock(returncode=0)
            proc.poll.side_effect=[None,0]
            profile=Mock()
            with patch("core.backend.launch",return_value=(proc,profile)) as launcher:
                backend.provider("Netflix")
                backend.provider("Disney+")
                launcher.assert_called_once_with("https://www.netflix.com/")
                backend.poll()
                backend.poll()
            self.assertEqual(changes,[True,False])
            profile.cleanup.assert_called_once()
            backend.timer.stop()
            backend.watcher.stop()
