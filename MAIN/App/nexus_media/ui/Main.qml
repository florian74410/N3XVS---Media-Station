import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "components"
import "theme" as Design
ApplicationWindow {
    id: shell
    width: 1280; height: 800; visible: true; title: "NEXUS Multimedia"
    color: Design.Palette.canvas
    property string page: "Accueil"
    property string query: ""
    property int offset: 0
    property var rows: []
    property var watching: []
    property var dlnaServer: ({})
    property var dlnaTrail: ["0"]
    property var dlnaMedia: []
    property int dlnaOffset: 0
    function browseDlna(){discovering=true; station.browse(dlnaServer,dlnaTrail[dlnaTrail.length-1],dlnaOffset)}
    property var servers: []
    property bool discovering: false
    property var streams: []
    property var selected: ({})
    property string pending: ""
    property bool playerActive: false
    property string statusText: ""
    property string summary: ""
    property var sample: demoItems
    property var hero: sample[0]
    property bool collection: page==="Bibliothèque" || page==="Accueil"
    property bool showcase: page==="Streaming" || page==="Accueil"
    property var sections: ["Accueil","Streaming","TV Direct","Replays","Bibliothèque","DLNA","Applications"]
    function refresh(){rows=station.items(query,offset,false); watching=station.items("",0,true); summary=station.summary()}
    function openProvider(name){pending=name; consent.open()}
    onClosing: Qt.quit()
    Component.onCompleted: refresh()
    Connections {
        target: station
        function onMessage(msg){shell.statusText=msg}
        function onBrowsed(entries){shell.dlnaMedia=entries; shell.discovering=false}
        function onDiscovered(devices){shell.servers=devices; shell.discovering=false}
        function onChanged(){shell.refresh()}
        function onControls(active){shell.playerActive=active}
        function onExternal(away){shell.visible=!away; if(!away) shell.requestActivate()}
    }
    Image { anchors.fill: parent; source: cityUrl; fillMode: Image.PreserveAspectCrop; opacity: 0.45 }
    ColumnLayout {
        anchors.fill: parent; anchors.margins: width<800?16:28; spacing: 20
        RowLayout {
            Layout.fillWidth: true; spacing: 10
            Label { text: "N E X U S"; color: Design.Palette.ink; font.bold: true; font.pixelSize: 24 }
            Label { text: " / MEDIA STATION"; color: Design.Palette.accent; visible: shell.width>700; font.pixelSize: 12 }
            Item { Layout.fillWidth: true }
            NeonButton { text: "Paramètres"; onClicked: settings.open() }
        }
        RowLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; spacing: shell.width<760?14:28
            ColumnLayout {
                Layout.alignment: Qt.AlignTop; spacing: 9
                Repeater {
                    model: shell.sections
                    SideNavItem { required property string modelData; required property int index
                        Layout.preferredWidth: shell.width<780?52:148
                        compact: shell.width<780; name: modelData; symbol: ["⌂","▷","TV","↺","▤","◎","⊞"][index]; selected: shell.page===modelData
                        onClicked: {shell.page=modelData; shell.statusText=""; scroll.contentItem.contentY=0}
                    }
                }
            }
            ScrollView {
                id: scroll; Layout.fillWidth: true; Layout.fillHeight: true; clip: true; contentWidth: availableWidth
                Column {
                    width: scroll.availableWidth; spacing: 30
                    Label { text: shell.page; color: Design.Palette.ink; font.pixelSize: 31; font.bold: true }
                    Rectangle {
                        visible: shell.showcase; width: parent.width; height: shell.width<760?160:202; radius: 14; color: Design.Palette.panel; clip: true
                        Image { anchors.fill: parent; source: shell.hero.art; fillMode: Image.PreserveAspectCrop }
                        Rectangle { anchors.fill: parent; gradient: Gradient { orientation: Gradient.Horizontal; GradientStop { position: 0; color: "#ed0c182b" } GradientStop { position: 1; color: "#120d1420" } } }
                        Column { anchors.left: parent.left; anchors.leftMargin: 26; anchors.verticalCenter: parent.verticalCenter; spacing: 8
                            AppBadge { text: "SÉLECTION  /  DÉMO" }
                            Label { text: shell.hero.title; color: Design.Palette.ink; font.bold: true; font.pixelSize: shell.width<760?28:40 }
                            Label { text: shell.hero.genre+"   ·   Œuvre fictive"; color: Design.Palette.muted }
                        }
                    }
                    RowCarousel { visible: shell.showcase; width: parent.width; title: "À découvrir"; entries: shell.sample; demo: true; onChosen: item => shell.hero=item }
                    Column { visible: shell.collection; width: parent.width; spacing: 12
                        Label { text: shell.summary; color: Design.Palette.muted; width: parent.width; wrapMode: Text.Wrap }
                        Flow { width: parent.width; spacing: 10
                            NeonButton { text: "Choisir un dossier"; onClicked: folders.open() }
                            InputField { width: 180; placeholderText: "Filtrer par titre"; onTextChanged: {shell.query=text; shell.offset=0; shell.refresh()} }
                        }
                    }
                    RowCarousel { visible: shell.collection && shell.watching.length>0; width: parent.width; title: "À reprendre"; entries: shell.watching; onChosen: item=>{shell.selected=item; details.open()} }
                    RowCarousel { visible: shell.collection && shell.rows.length>0; width: parent.width; title: "Mes médias"; entries: shell.rows; onChosen: item=>{shell.selected=item; details.open()} }
                    Row { visible: shell.collection && (shell.offset>0 || shell.rows.length===48); spacing: 12
                        NeonButton { text: "Précédents"; enabled: shell.offset>0; onClicked: {shell.offset-=48; shell.refresh()} }
                        NeonButton { text: "Suivants"; enabled: shell.rows.length===48; onClicked: {shell.offset+=48; shell.refresh()} }
                    }
                    NeonButton { visible: shell.page==="Applications"; text: "Ouvrir VLC"; onClicked: station.openVlc() }
                    Flow { width: parent.width; spacing: 14; visible: ["TV Direct","Streaming","Replays","Applications"].includes(shell.page)
                        Repeater { model: shell.page==="TV Direct"?["Free TV"]:shell.page==="Replays"?["france.tv","ARTE","Free TV"]:["Netflix","Disney+","Prime Video","Apple TV","Free TV","france.tv","ARTE"]
                            NeonButton { required property string modelData; text: modelData; onClicked: shell.openProvider(modelData) }
                        }
                    }
                    NeonButton { visible: shell.page==="TV Direct"; text: "Importer une playlist M3U"; onClicked: playlists.open() }
                    RowCarousel { visible: shell.page==="TV Direct" && shell.streams.length>0; width: parent.width; title: "Chaînes importées"; entries: shell.streams; onChosen: item=>station.watch(item.path) }
                    NeonButton { visible: shell.page==="DLNA"; enabled: !shell.discovering; text: shell.discovering?"Recherche…":"Rechercher les serveurs"; onClicked: {shell.discovering=true; station.discover()} }
                    Repeater { model: shell.page==="DLNA"?shell.servers:[]; NeonButton { required property var modelData; text: modelData.title; enabled: !!modelData.control && !shell.discovering; onClicked: {shell.dlnaServer=modelData; shell.dlnaTrail=["0"]; shell.dlnaOffset=0; shell.browseDlna()} } }
                    RowCarousel { visible: shell.page==="DLNA" && shell.dlnaMedia.length>0; width: parent.width; title: shell.dlnaServer.title || "Serveur"; entries: shell.dlnaMedia
                        onChosen: item=>{if(shell.discovering)return; if(item.folder!==undefined){shell.dlnaTrail=shell.dlnaTrail.concat([item.folder]); shell.dlnaOffset=0; shell.browseDlna()}else station.watch(item.path)} }
                    Row { visible: shell.page==="DLNA" && !!shell.dlnaServer.control; spacing: 8; enabled: !shell.discovering
                        NeonButton {text:"Parent"; enabled:shell.dlnaTrail.length>1; onClicked:{shell.dlnaTrail=shell.dlnaTrail.slice(0,-1); shell.dlnaOffset=0; shell.browseDlna()}}
                        NeonButton {text:"‹"; enabled:shell.dlnaOffset>0; onClicked:{shell.dlnaOffset-=48; shell.browseDlna()}}
                        NeonButton {text:"›"; enabled:shell.dlnaMedia.length===48; onClicked:{shell.dlnaOffset+=48; shell.browseDlna()}}
                    }
                    Label { visible: shell.page==="DLNA"; text: "La recherche interroge les serveurs UPnP AV du réseau local. Les dossiers SMB et NFS déjà montés peuvent être ajoutés dans Bibliothèque."; width: parent.width; wrapMode: Text.Wrap; color: Design.Palette.muted }
                }
            }
        }
        Row { visible: shell.playerActive; spacing: 10
            NeonButton { text:"Pause / Reprendre"; onClicked:station.pause() }
            NeonButton { text:"Arrêter la lecture"; onClicked:station.stopLocal() }
        }
        Label { text: shell.statusText; visible: text.length>0; color: Design.Palette.accent; Layout.fillWidth: true; wrapMode: Text.Wrap }
    }
    FolderDialog { id: folders; onAccepted: station.index(selectedFolder) }
    FileDialog { id: playlists; nameFilters: ["Playlists (*.m3u *.m3u8)"]; onAccepted: shell.streams=station.playlist(selectedFile) }
    Modal { id: consent; title: "Ouvrir "+shell.pending; standardButtons: Dialog.Ok | Dialog.Cancel
        Label { text: "Ouvrir le site officiel dans une fenêtre privée Firefox ?\nLe service peut demander une connexion et un DRM compatible."; wrapMode: Text.Wrap; width: Math.min(375,shell.width-100) }
        onAccepted: station.provider(shell.pending)
    }
    Modal { id: settings; title: "Paramètres"; standardButtons: Dialog.Close
        Column { spacing: 12; NeonButton { text: shell.visibility===Window.FullScreen?"Mode fenêtré":"Plein écran"; onClicked: shell.visibility=shell.visibility===Window.FullScreen?Window.Windowed:Window.FullScreen }
            NeonButton { text: "Actualiser la bibliothèque"; onClicked: {station.rescan(); settings.close()} }
        }
    }
    Modal { id: details; title: shell.selected.title || ""; standardButtons: Dialog.Close
        Column { spacing: 10
            Label { text: (shell.selected.codec || "Codec inconnu")+"   ·   "+Math.round((shell.selected.duration||0)/60)+" min" }
            NeonButton { text: "Lire avec VLC"; onClicked: {details.close(); station.watch(shell.selected.path)} }
            SpinBox { id: minute; from: 0; to: Math.ceil((shell.selected.duration||0)/60); value: Math.floor((shell.selected.position||0)/60) }
            NeonButton { text: "Mémoriser la minute"; onClicked: {station.bookmark(shell.selected.path,minute.value*60,false); details.close()} }
            NeonButton { text: "Marquer comme vu"; onClicked: {station.bookmark(shell.selected.path,0,true); details.close()} }
        }
    }
}
