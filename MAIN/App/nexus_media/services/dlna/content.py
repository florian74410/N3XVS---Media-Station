"""Read bounded UPnP device descriptions and ContentDirectory pages from the responding host."""
import http.client
from urllib.parse import urlsplit, urljoin
import xml.etree.ElementTree as ET

def same_server(url, host):
    p = urlsplit(url)
    if p.scheme not in ("http","https") or p.hostname != host or p.username or p.password:
        raise ValueError("Adresse UPnP différente du serveur découvert")
    return p

def request(url, host, body=None, headers=None):
    p = same_server(url,host)
    client = http.client.HTTPSConnection if p.scheme=="https" else http.client.HTTPConnection
    conn = client(host,p.port,timeout=2.5)
    try:
        conn.request("POST" if body else "GET",p.path+("?"+p.query if p.query else ""),body,headers or {})
        response = conn.getresponse()
        if response.status != 200:
            raise ValueError(f"Réponse UPnP {response.status}")
        return xml(response.read(1024*1024+1))
    finally:
        conn.close()

def xml(data):
    if len(data)>1024*1024 or b"<!DOCTYPE" in data.upper():
        raise ValueError("Document UPnP refusé")
    return ET.fromstring(data)

def describe(host,location):
    document=request(location,host)
    name=document.findtext(".//{*}friendlyName") or host
    for service in document.findall(".//{*}service"):
        kind=service.findtext("{*}serviceType","")
        if kind.startswith("urn:schemas-upnp-org:service:ContentDirectory:"):
            base=document.findtext("{*}URLBase") or location
            control=urljoin(base,service.findtext("{*}controlURL",""))
            same_server(control,host)
            return dict(title=name,host=host,control=control,kind=kind)
    raise ValueError("ContentDirectory absent")

def browse(server, object_id="0", offset=0):
    kind=server["kind"]
    element=ET.Element("{http://schemas.xmlsoap.org/soap/envelope/}Envelope")
    body=ET.SubElement(element,"{http://schemas.xmlsoap.org/soap/envelope/}Body")
    action=ET.SubElement(body,"{"+kind+"}Browse")
    for key,value in dict(ObjectID=object_id,BrowseFlag="BrowseDirectChildren",Filter="*",StartingIndex=str(offset),RequestedCount="48",SortCriteria="").items():
        ET.SubElement(action,key).text=value
    doc=request(server["control"],server["host"],ET.tostring(element,encoding="utf-8"),
                {"Content-Type":"text/xml; charset=utf-8","SOAPAction":f'"{kind}#Browse"'})
    result=xml(doc.findtext(".//{*}Result","").encode())
    entries=[]
    for node in list(result)[:48]:
        title=node.findtext("{*}title") or "Sans titre"
        if node.tag.endswith("}container"):
            entries.append(dict(title=title,folder=node.get("id")))
        else:
            for res in node.findall("{*}res"):
                try:
                    same_server(res.text or "",server["host"])
                except ValueError:
                    continue
                entries.append(dict(title=title,path=res.text))
                break
    return entries
