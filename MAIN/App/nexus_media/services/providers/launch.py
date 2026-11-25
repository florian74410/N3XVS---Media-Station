from pathlib import Path
import shutil
import subprocess
import tempfile

def launch(url):
    browser = shutil.which("firefox") or shutil.which("firefox-esr")
    if not browser:
        raise ValueError("Firefox externe introuvable")
    # Separate ephemeral profile owns its process and cannot reuse existing windows.
    profile = tempfile.TemporaryDirectory(prefix="nexus-browser-")
    try:
        proc = subprocess.Popen([browser, "--no-remote", "--profile", profile.name, "--private-window", url])
    except OSError:
        profile.cleanup()
        raise
    return proc, profile
