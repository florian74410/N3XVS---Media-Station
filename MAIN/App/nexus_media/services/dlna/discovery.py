"""Receive MediaServer advertisements during one bounded local SSDP search."""
import socket
import time
from xml.etree.ElementTree import ParseError
from .content import describe

def discover(timeout=2.5):
    request = ("M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\n"
               'MAN: "ssdp:discover"\r\nMX: 1\r\n'
               "ST: urn:schemas-upnp-org:device:MediaServer:1\r\n\r\n").encode()
    found = {}
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        sock.setsockopt(socket.IPPROTO_IP,socket.IP_MULTICAST_TTL,1)
        sock.sendto(request,("239.255.255.250",1900))
        deadline=time.monotonic()+timeout
        while time.monotonic()<deadline and len(found)<64:
            sock.settimeout(max(.001,deadline-time.monotonic()))
            try:
                packet, (host, _) = sock.recvfrom(8192)
            except socket.timeout:
                break
            lines = packet.decode("latin-1").splitlines()
            if not lines or not lines[0].startswith("HTTP/1.1 200"):
                continue
            headers = dict((k.lower().strip(),v.strip()) for k,_,v in (x.partition(":") for x in lines[1:]))
            if "device:mediaserver:" in headers.get("st","").lower():
                found[host] = headers.get("location","")
    devices = []
    for host, location in list(found.items())[:6]:
        try:
            devices.append(describe(host,location))
        except (ValueError,OSError,ParseError):
            devices.append(dict(title=host+" · description indisponible",host=host))
    return devices
