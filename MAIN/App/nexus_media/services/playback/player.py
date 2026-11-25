import shutil
import subprocess

def play(path, position=0):
    vlc = shutil.which("vlc")
    if not vlc:
        raise ValueError("VLC absent · installer le profil media")
    return subprocess.Popen([vlc, "--no-one-instance", "--play-and-exit", "--no-video-title-show",
                             f"--start-time={max(0, position)}", "--", path])
