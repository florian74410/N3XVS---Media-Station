"""Index actual payload and retain each Debian source package copyright notice."""
import hashlib
import json
import subprocess
import sys
import tarfile
from pathlib import Path

root = Path(sys.argv[1])
(root / "licenses").mkdir(exist_ok=True)
rows = []
for p in sorted((root / "pool").glob("*.deb")):
    fmt = "${Package}|${Version}|${Architecture}|${source:Package}|${Depends}|${Pre-Depends}"
    fields = subprocess.check_output(["dpkg-deb", "-W", "--showformat=" + fmt, p], text=True).split("|")
    row = dict(zip(("package", "version", "architecture", "source", "depends", "pre_depends"), fields))
    row["sha256"] = hashlib.sha256(p.read_bytes()).hexdigest()
    with subprocess.Popen(["dpkg-deb", "--fsys-tarfile", p], stdout=subprocess.PIPE) as proc:
        with tarfile.open(fileobj=proc.stdout, mode="r|") as archive:
            for member in archive:
                if member.name.endswith("/copyright") and "/usr/share/doc/" in member.name and member.isfile():
                    dest = root / "licenses" / (fields[0] + ".txt")
                    dest.write_bytes(archive.extractfile(member).read())
                    row["license_notice"] = str(dest.relative_to(root))
                    continue
        proc.stdout.close()
    row.setdefault("license_notice", "voir copyright partagé du paquet source " + fields[3])
    rows.append(row)
(root / "manifest.json").write_text(json.dumps(dict(release="trixie", architecture="arm64", packages=rows), indent=2))
(root / "DEPENDENCIES-RESOLVED.txt").write_text("".join(f"{r['package']}:{r['architecture']}={r['version']}\n" for r in rows))
