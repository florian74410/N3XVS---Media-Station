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
    property string page: "Bibliothèque"
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
    property bool showcase: ["Netflix","Disney+","Streaming"].includes(page)
    readonly property string providerName:page==="Disney+"?"Disney+":"Netflix"
    property int totalMedia:0
    property bool lanChecked:false
    property var listed:[]
    property string listHeading:""
    property var sections: ["Accueil","Netflix","Disney+","TV","Replays","Bibliothèque","DLNA","Applications"]
    function inspect(entry){if(entry.demo){selected=entry;demoDetail.open()}else showDetails(entry)}
    function listTitles(name,items){listHeading=name;listed=items;allTitles.open()}
    function navigate(name){page=name;statusText="";scroll.contentItem.contentY=0}
    function scanLan(){navigate("DLNA");discovering=true;station.discover()}
    function chooseFolder(){folders.open()}
    function choosePlaylist(){playlists.open()}
    function showDetails(item){selected=item; details.open()}
    function refresh(){totalMedia=station.mediaCount(); rows=station.items(query,offset,false); watching=station.items("",0,true); summary=station.summary()}
    function openProvider(name){pending=name; consent.open()}
    onClosing: Qt.quit()
    Component.onCompleted: refresh()
    Connections {
        target: station
        function onMessage(msg){shell.statusText=msg}
        function onBrowsed(entries){shell.dlnaMedia=entries; shell.discovering=false}
        function onDiscovered(devices){shell.lanChecked=true; shell.servers=devices; shell.discovering=false}
        function onChanged(){shell.refresh()}
        function onControls(active){shell.playerActive=active}
        function onExternal(away){shell.visible=!away; if(!away) shell.requestActivate()}
    }
    Item {anchors.fill:parent;clip:true
        Image {width:parent.width;height:parent.height*1.42;y:-parent.height*.02;source:cityUrl;fillMode:Image.PreserveAspectCrop}
        Rectangle {anchors.fill:parent; gradient:Gradient {GradientStop{position:0;color:"#09031220"} GradientStop{position:.5;color:"#80010b16"} GradientStop{position:1;color:"#27030d18"}}}
    }
    Item {
        id:stage
        readonly property real factor:Math.min(1.6,Math.max(.83,shell.width/1672))
        readonly property bool narrow:width<980
        width:shell.width/factor; height:shell.height/factor; scale:factor; transformOrigin:Item.TopLeft
        Image {width:parent.width;height:185;source:skinUrl+"skyline.png"; opacity:.94}
        Rectangle {anchors.fill:parent;color:"#22000b19"}
        TopBar {id:top;width:parent.width;height:55;compact:stage.narrow
            onSettingsRequested:settings.open();onUsersRequested:users.open();onAccountsRequested:accounts.open()}
        SideBar {id:side;hub:shell;x:16;y:shell.showcase?96:104;width:stage.narrow?61:stage.width*(shell.showcase?.13:.136);compact:stage.narrow
            onNavigate:name=>shell.navigate(name)}
        ScrollView {
            id:scroll;x:side.x+side.width+(shell.showcase?19:25);y:top.height+3;width:stage.width-x-19;height:stage.height-y-10
            contentWidth:availableWidth;clip:true;ScrollBar.horizontal.policy:ScrollBar.AlwaysOff
            Column {width:scroll.availableWidth;spacing:6
                Row {height:shell.showcase?68:101;spacing:16
                    Image {anchors.verticalCenter:parent.verticalCenter;width:55;height:51;source:skinUrl+"nav-"+(shell.showcase?"netflix":shell.collection?"library":shell.page==="DLNA"?"dlna":shell.page==="TV"?"tv":"apps")+".png"}
                    Column {anchors.verticalCenter:parent.verticalCenter;spacing:3
                        Text {text:shell.showcase?"Catalogue streaming":shell.page==="Accueil"?"Bibliothèque":shell.page;font.bold:true;color:"white";font.pixelSize:shell.showcase?38:42}
                        Text {width:Math.max(180,scroll.availableWidth-85);elide:Text.ElideRight;color:"#e5f5ff";font.pixelSize:17
                            text:shell.showcase?"Catalogue de démonstration · Ouvrir "+shell.providerName+" via son site officiel.":shell.collection?"Vos contenus locaux et réseau, films, séries et médias"+(shell.totalMedia===0?"   ·   Démonstration":""):"Sources multimédia et services de votre station"}
                    }
                }
                Streaming {width:parent.width;hub:shell;visible:shell.showcase}
                Library {width:parent.width;hub:shell;visible:shell.collection}
                Apps {width:parent.width;hub:shell;visible:shell.page==="Applications"}
                Replays {width:parent.width;hub:shell;visible:shell.page==="Replays"}
                TV {width:parent.width;hub:shell;visible:shell.page==="TV" || shell.page==="TV Direct"}
                DLNA {width:parent.width;hub:shell;visible:shell.page==="DLNA"}
                Row {visible:shell.playerActive;spacing:10
                    NeonButton {text:"Pause / Reprendre";onClicked:station.pause()}
                    NeonButton {text:"Arrêter la lecture";onClicked:station.stopLocal()}}
            }
        }
    }
    Rectangle {visible:shell.statusText.length>0;anchors.bottom:parent.bottom;anchors.horizontalCenter:parent.horizontalCenter;color:"#ef041526";radius:9;border.color:"#68bbec";width:Math.min(parent.width-24,notice.implicitWidth+32);height:40
        Text {id:notice;anchors.centerIn:parent;text:shell.statusText;color:"white";textFormat:Text.PlainText}
        Timer {interval:4500;running:parent.visible;onTriggered:shell.statusText=""}
    }
    Modal {id:demoDetail;title:shell.selected.title||"Fiche";Column{spacing:12
        Image {source:shell.selected.art||"";width:160;height:160;fillMode:Image.PreserveAspectFit}
        Label {text:(shell.selected.info||"")+"    ★ "+(shell.selected.score||"")}
        Label {text:"Démonstration · disponibilité non vérifiée"}
        NeonButton {visible:shell.showcase;text:"Ouvrir "+shell.providerName;onClicked:{demoDetail.close();shell.openProvider(shell.providerName)}}}}
    Modal {id:allTitles;title:shell.listHeading;width:Math.min(shell.width-32,450)
        ListView {implicitHeight:Math.min(350,48*shell.listed.length);clip:true;model:shell.listed
            delegate:ItemDelegate{required property var modelData;width:ListView.view.width;text:modelData.title;onClicked:{allTitles.close();shell.inspect(modelData)}}}}
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
