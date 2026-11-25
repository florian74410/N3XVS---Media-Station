import shutil
import subprocess

def play(path, position=0):
    vlc = shutil.which("vlc")
    if not vlc:
        raise ValueError("VLC absent · installer le profil media")
    return subprocess.Popen([vlc, "--no-one-instance", "--play-and-exit", "--no-video-title-show",
                             f"--start-time={max(0, position)}", "--", path])

class EmbeddedEngine:
    """libVLC owns its video output window. Qt polls position on the GUI thread."""
    def __init__(self, path, position):
        import vlc
        self.vlc = vlc
        self.instance = vlc.Instance("--no-video-title-show")
        if not self.instance:
            raise OSError("libVLC indisponible")
        self.player = self.instance.media_player_new()
        media = self.instance.media_new_path(path)
        media.add_option(f"start-time={position}")
        self.player.set_media(media)
        media.release()
        self.returncode = None
        self.ended = False
        if self.player.play() == -1:
            self.close()
            raise OSError("Lecture refusée par libVLC")

    def seconds(self):
        return max(0,self.player.get_time()/1000)

    def poll(self):
        state = self.player.get_state()
        if state in (self.vlc.State.Ended,self.vlc.State.Error,self.vlc.State.Stopped):
            self.ended = state==self.vlc.State.Ended
            self.returncode = int(state==self.vlc.State.Error)
        return self.returncode

    def close(self):
        self.player.stop()
        self.player.release()
        self.instance.release()

def local_player(path, position):
    try:
        return EmbeddedEngine(path,position)
    except (ImportError, OSError, NameError, AttributeError):
        return play(path,position)
