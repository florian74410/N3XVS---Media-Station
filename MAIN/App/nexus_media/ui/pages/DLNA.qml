import QtQuick
import QtQuick.Controls
import "../components"
import "../theme" as Design
Column {
    required property var hub
    spacing: 30
    NeonButton { visible: hub.page==="DLNA"; enabled: !hub.discovering; text: hub.discovering?"Recherche…":"Rechercher les serveurs"; onClicked: {hub.discovering=true; station.discover()} }
    Repeater { model: hub.page==="DLNA"?hub.servers:[]; NeonButton { required property var modelData; text: modelData.title; enabled: !!modelData.control && !hub.discovering; onClicked: {hub.dlnaServer=modelData; hub.dlnaTrail=["0"]; hub.dlnaOffset=0; hub.browseDlna()} } }
    RowCarousel { visible: hub.page==="DLNA" && hub.dlnaMedia.length>0; width: parent.width; title: hub.dlnaServer.title || "Serveur"; entries: hub.dlnaMedia
        onChosen: item=>{if(hub.discovering)return; if(item.folder!==undefined){hub.dlnaTrail=hub.dlnaTrail.concat([item.folder]); hub.dlnaOffset=0; hub.browseDlna()}else station.watch(item.path)} }
    Row { visible: hub.page==="DLNA" && !!hub.dlnaServer.control; spacing: 8; enabled: !hub.discovering
        NeonButton {text:"Parent"; enabled:hub.dlnaTrail.length>1; onClicked:{hub.dlnaTrail=hub.dlnaTrail.slice(0,-1); hub.dlnaOffset=0; hub.browseDlna()}}
        NeonButton {text:"‹"; enabled:hub.dlnaOffset>0; onClicked:{hub.dlnaOffset-=48; hub.browseDlna()}}
        NeonButton {text:"›"; enabled:hub.dlnaMedia.length===48; onClicked:{hub.dlnaOffset+=48; hub.browseDlna()}}
    }
    Label { visible: hub.page==="DLNA"; text: "La recherche interroge les serveurs UPnP AV du réseau local. Les dossiers SMB et NFS déjà montés peuvent être ajoutés dans Bibliothèque."; width: parent.width; wrapMode: Text.Wrap; color: Design.Palette.muted }
}
