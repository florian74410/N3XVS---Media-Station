import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "components"
import "pages"
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
    function chooseFolder(){folders.open()}
    function choosePlaylist(){playlists.open()}
    function showDetails(item){selected=item; details.open()}
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
        TopBar {Layout.fillWidth:true; compact:shell.width<780
            onSettingsRequested:settings.open()
            onUsersRequested:users.open()
            onAccountsRequested:accounts.open()
        }
        RowLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; spacing: shell.width<760?14:28
            SideBar {hub:shell; onNavigate:name=>{shell.page=name; shell.statusText=""; scroll.contentItem.contentY=0}}
            ScrollView {
                id: scroll; Layout.fillWidth: true; Layout.fillHeight: true; clip: true; contentWidth: availableWidth
                Column {
                    width: scroll.availableWidth; spacing: 30
                    Label { text: shell.page; color: Design.Palette.ink; font.pixelSize: 31; font.bold: true }
                    Home {width:parent.width; hub:shell; visible:shell.showcase}
                    Apps {width:parent.width; hub:shell; visible:shell.page==="Streaming" || shell.page==="Applications"}
                    Streaming {width:parent.width; hub:shell; visible:shell.page==="Streaming"}
                    Library {width:parent.width; hub:shell; visible:shell.collection}
                    Replays {width:parent.width; hub:shell; visible:shell.page==="Replays"}
                    TV {width:parent.width; hub:shell; visible:shell.page==="TV Direct"}
                    DLNA {width:parent.width; hub:shell; visible:shell.page==="DLNA"}
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
    Modal {id:users; title:"Utilisateur local"
        Label {text:loginName+" · profil de cette session Linux"}
    }
    Modal {id:accounts; title:"Comptes de streaming"
        Column {spacing:10
            Label {width:280;wrapMode:Text.Wrap;text:"La connexion se fait sur le site officiel dans la fenêtre privée du service."}
            NeonButton {text:"Choisir une plateforme";onClicked:{accounts.close();shell.page="Applications"}}
        }
    }
    Modal { id: settings; title: "Paramètres"; standardButtons: Dialog.Close
        Column { spacing: 12; NeonButton { text: shell.visibility===Window.FullScreen?"Mode fenêtré":"Plein écran"; onClicked: shell.visibility=shell.visibility===Window.FullScreen?Window.Windowed:Window.FullScreen }
            NeonButton { visible:shell.width<780; text:"Utilisateur local"; onClicked:{settings.close();users.open()} }
            NeonButton { visible:shell.width<780; text:"Comptes de streaming"; onClicked:{settings.close();accounts.open()} }
            NeonButton { text: "Actualiser la bibliothèque"; onClicked: {station.rescan(); settings.close()} }
        }
    }
    Modal { id: details; title: shell.selected.title || ""; standardButtons: Dialog.Close
        Column { spacing: 10
            Label { text: (shell.selected.codec || "Codec inconnu")+"   ·   "+Math.round((shell.selected.duration||0)/60)+" min" }
            Label { text: "Année "+(shell.selected.year || "inconnue")+"   ·   Note non renseignée" }
            NeonButton { text: shell.selected.watchlist?"Retirer de À regarder":"Ajouter à À regarder"; onClicked:{station.toggleWatchlist(shell.selected.path); details.close()} }
            NeonButton { text: "Lire avec VLC"; onClicked: {details.close(); station.watch(shell.selected.path)} }
            SpinBox { id: minute; from: 0; to: Math.ceil((shell.selected.duration||0)/60); value: Math.floor((shell.selected.position||0)/60) }
            NeonButton { text: "Mémoriser la minute"; onClicked: {station.bookmark(shell.selected.path,minute.value*60,false); details.close()} }
            NeonButton { text: "Marquer comme vu"; onClicked: {station.bookmark(shell.selected.path,0,true); details.close()} }
        }
    }
}
