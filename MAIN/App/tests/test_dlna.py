from http.server import BaseHTTPRequestHandler, HTTPServer
from threading import Thread
import sys
from pathlib import Path
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/"nexus_media"))
from services.dlna.content import describe, browse, same_server

class Device(BaseHTTPRequestHandler):
    def reply(self, body):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(body.encode())

    def do_GET(self):
        self.reply("<root><device><friendlyName>Salon test</friendlyName><serviceList><service><serviceType>urn:schemas-upnp-org:service:ContentDirectory:1</serviceType><controlURL>/browse</controlURL></service></serviceList></device></root>")

    def do_POST(self):
        self.rfile.read(int(self.headers["Content-Length"]))
        self.reply("<Envelope><Result>&lt;DIDL&gt;&lt;container xmlns='urn:test' id='films'&gt;&lt;title&gt;Films&lt;/title&gt;&lt;/container&gt;&lt;/DIDL&gt;</Result></Envelope>")

    def log_message(self,*args):
        pass

class DlnaTests(unittest.TestCase):
    def test_device_description_and_directory(self):
        with HTTPServer(("127.0.0.1",0),Device) as http:
            Thread(target=http.serve_forever,daemon=True).start()
            try:
                server=describe("127.0.0.1",f"http://127.0.0.1:{http.server_port}/device")
                self.assertEqual(server["title"],"Salon test")
                self.assertEqual(browse(server),[dict(title="Films",folder="films")])
            finally:
                http.shutdown()

    def test_other_host(self):
        with self.assertRaises(ValueError):
            same_server("https://example.org/stream","127.0.0.1")
