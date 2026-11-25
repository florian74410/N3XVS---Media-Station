"""X11 session supervisor. Exiting Openbox ends this session."""
import os
from pathlib import Path
import subprocess
import tempfile
import time

def supervise():
    root = Path(__file__).resolve().parents[3]
    packaging = Path(__file__).parent
    with tempfile.TemporaryDirectory(prefix="nexus-session-") as tmp:
        marker = Path(tmp)/"restore"
        binds = Path(tmp)/"xbindkeys"
        binds.write_text(f'"{packaging}/restore.sh"\n Control+n\n')
        env = dict(os.environ,NEXUS_FULLSCREEN="1",NEXUS_RESTORE_MARKER=str(marker))
        owned = []
        try:
            wm = subprocess.Popen(["openbox"],env=env)
            owned.append(wm)
            keys = subprocess.Popen(["xbindkeys","-n","-f",str(binds)],env=env)
            owned.append(keys)
            gui = None
            restart_at = time.monotonic()
            while wm.poll() is None:
                if marker.exists():
                    marker.unlink(missing_ok=True)
                    restart_at = time.monotonic()
                if gui and gui.poll() is not None:
                    owned.remove(gui)
                    restart_at = time.monotonic()+2 if gui.returncode else float("inf")
                    gui = None
                if gui is None and time.monotonic()>=restart_at:
                    gui = subprocess.Popen([root/"start.sh"],env=env)
                    owned.append(gui)
                time.sleep(.15)
        finally:
            for proc in reversed(owned):
                if proc.poll() is None:
                    proc.terminate()
            for proc in owned:
                try:
                    proc.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    pass

if __name__=="__main__":
    supervise()
