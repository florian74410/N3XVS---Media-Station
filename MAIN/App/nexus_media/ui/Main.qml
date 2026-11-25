import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"

ApplicationWindow {
  id: app
  visible: true
  width: 1366; height: 768
  minimumWidth: 630; minimumHeight: 420
  title: "N3XVS Multimedia — prototype 0.0.1"
  color: "#050b15"
  property int pageIndex: 0
  property var menuEntries: ["Accueil", "Netflix", "Disney+", "Free TV", "TV", "Replays", "Bibliothèque", "DLNA", "Applications"]
  property var platforms: ({
    "Netflix": "https://www.netflix.com/",
    "Disney+": "https://www.disneyplus.com/",
    "Free TV": "https://tv.free.fr/",
    "Prime Video": "https://www.primevideo.com/",
    "Apple TV": "https://tv.apple.com/fr/"
  })
  property string activePage: menuEntries[pageIndex]
  property var demoSets: ({
    "Accueil": [
      { label:"Continuer le visionnage", media:[
        {title:"Série de démonstration", genre:"Série", year:"2026", time:"42 min", status:"En cours"},
        {title:"Documentaire de démonstration", genre:"Documentaire", year:"2025", time:"58 min", status:"Déjà vu"},
        {title:"Film de démonstration", genre:"Film", year:"2024", time:"1 h 45", status:"Jamais vu"}
      ]},
      { label:"Science-fiction", media:[
        {title:"Voyage orbital", genre:"Science-fiction", year:"2025", time:"2 h 07", status:"Jamais vu"},
        {title:"Ville néon", genre:"Science-fiction", year:"2026", time:"1 h 35", status:"En cours"},
        {title:"Archives spatiales", genre:"Science-fiction", year:"2024", time:"1 h 50", status:"Déjà vu"}
      ]}
    ],
    "Netflix": [{label:"Catalogue illustratif — non connecté",media:[
      {title:"Exemple série",genre:"Série",year:"2026",time:"48 min",status:"En cours"},
      {title:"Exemple film",genre:"Film",year:"2025",time:"1 h 54",status:"Jamais vu"}
    ]}],
    "Disney+": [{label:"Catalogue illustratif — non connecté",media:[
      {title:"Exemple animation",genre:"Animation",year:"2025",time:"1 h 38",status:"Jamais vu"}
    ]}],
    "Free TV": [{label:"TV et replay — démonstration",media:[
      {title:"Chaîne exemple",genre:"Télévision",year:"2026",time:"Direct",status:"Jamais vu"}
    ]}],
    "TV": [{label:"Chaînes Freebox — démonstration",media:[
      {title:"France 2 (exemple)",genre:"RTSP / IPTV",year:"Direct",time:"HD",status:"Jamais vu"},
      {title:"Arte (exemple)",genre:"RTSP / IPTV",year:"Direct",time:"HD",status:"Jamais vu"}
    ]}],
    "Replays": [{label:"Programmes en replay — démonstration",media:[
      {title:"Replay exemple",genre:"Replay",year:"2026",time:"52 min",status:"Jamais vu"}
    ]}],
    "Bibliothèque": [
      {label:"Films locaux — démonstration", media:[
        {title:"Film sur HDD",genre:"Stockage USB",year:"2025",time:"1 h 47",status:"Jamais vu"},
        {title:"Film sur NAS",genre:"SMB / NFS",year:"2024",time:"2 h 12",status:"En cours"}
      ]},
      {label:"Séries locales — démonstration",media:[
        {title:"Série personnelle",genre:"Bibliothèque",year:"2025",time:"51 min",status:"Déjà vu"}
      ]}
    ],
    "DLNA": [{label:"Serveurs réseau — simulation, pas de scan réel",media:[
      {title:"NAS-Cinema",genre:"Serveur DLNA",year:"Local",time:"—",status:"Jamais vu"},
      {title:"Freebox Media",genre:"Serveur DLNA",year:"Local",time:"—",status:"Jamais vu"}
    ]}],
    "Applications": [{label:"Services officiels — raccourcis", media:[
      {title:"Prime Video",genre:"Lanceur Web",year:"—",time:"—",status:"Jamais vu"},
      {title:"Apple TV",genre:"Lanceur Web",year:"—",time:"—",status:"Jamais vu"}
    ]}]
  })
  property var currentSections: demoSets[activePage] || demoSets["Accueil"]
  function showMessage(t) { messageBox.text = t; messageBox.open(); }
  function openProvider(name) {
    var url = platforms[name]
    if (!url) { showMessage("Aucun lanceur officiel configuré pour " + name); return; }
    Qt.openUrlExternally(url)
  }
  Rectangle {
    anchors.fill: parent
    gradient: Gradient {
      GradientStop { position: 0; color: "#0d2340" }
      GradientStop { position: 1; color: "#020612" }
    }
  }
  Image {
    id: skyline
    anchors.fill: parent
    source: "../../../Assets/Backgrounds/nexus-city.png"
    fillMode: Image.PreserveAspectCrop
    opacity: status === Image.Ready ? 0.32 : 0
    asynchronous: true
    cache: true
  }
  Rectangle { anchors.fill: parent; color: "#9b030b18" }

  Rectangle {
    id: topbar
    x: 0; y: 0; width: parent.width; height: 72
    color: "#e3051224"
    border.color: "#274f7d"
    Row {
      anchors.left: parent.left; anchors.leftMargin: 24
      anchors.verticalCenter: parent.verticalCenter
      spacing: 10
      Text { text:"N3XVS"; font.pixelSize: 31; font.bold:true; color:"#9cddff" }
      Text { text:"Multimedia"; font.pixelSize:22; color:"white" }
    }
    Row {
      anchors.right: parent.right; anchors.rightMargin: 20
      anchors.verticalCenter: parent.verticalCenter
      spacing: 12
      Repeater {
        model: ["Paramètres","Utilisateurs","Comptes"]
        Rectangle {
          width: label.implicitWidth + 27; height: 35; radius:17
          color: btn.containsMouse ? "#214f7b" : "#111c33"
          border.color:"#4a8ebf"
          Text { id: label; text: modelData; anchors.centerIn: parent; font.pixelSize:12; color:"white" }
          MouseArea { id: btn; anchors.fill: parent; hoverEnabled:true; onClicked: app.showMessage(modelData + " : module à développer") }
        }
      }
    }
  }

  Row {
    x: 16; y: 89; width: parent.width - 30; height: parent.height - 104
    spacing: 24
    Rectangle {
      id: rail
      width: app.width < 900 ? 65 : 202
      height: parent.height; radius: 16
      color: "#ec061426"
      border.color:"#268cce"; border.width:1
      Column {
        anchors.left: parent.left; anchors.right: parent.right; anchors.top:parent.top
        anchors.margins: 10; spacing: 6
        Repeater {
          model: app.menuEntries
          Rectangle {
            width: rail.width - 20; height: 48; radius: 10
            color: app.pageIndex === index ? "#185a8d" : (hover.containsMouse ? "#15314f" : "transparent")
            border.width: app.pageIndex === index ? 1 : 0
            border.color: "#65ceff"
            Text {
              text: rail.width < 100 ? modelData.charAt(0) : modelData
              color: "white"
              anchors.verticalCenter: parent.verticalCenter
              x: rail.width < 100 ? 18 : 13
              font.pixelSize: rail.width < 100 ? 18 : 15
              font.bold: app.pageIndex === index
            }
            MouseArea { id: hover; anchors.fill: parent; hoverEnabled: true; onClicked: app.pageIndex = index }
          }
        }
      }
    }
    Flickable {
      id: scroll
      width: parent.width - rail.width - parent.spacing
      height: parent.height
      contentHeight: contentColumn.implicitHeight + 24
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
      Column {
        id: contentColumn
        width: scroll.width - 8
        spacing: 22
        Row {
          spacing: 12
          Text { text: app.activePage; color: "white"; font.pixelSize: app.width < 850 ? 24 : 36; font.bold:true }
          Text { text: "●"; font.pixelSize: 16; color:"#fa385a"; anchors.verticalCenter:parent.verticalCenter }
        }
        Text {
          text: "Version de démonstration · données simulées · aucune intégration DRM"
          font.pixelSize: 12; color:"#a5cae5"
        }
        Rectangle {
          width: parent.width; height: 104; radius: 14
          color: "#d20b1e37"; border.color:"#3379ad"
          Column {
            x: 18; y: 16; spacing: 9
            Text { text: app.activePage === "DLNA" ? "Découverte de serveurs à développer" : "Station multimédia modulaire et légère"; color:"white"; font.pixelSize:20; font.bold:true }
            Text { text: "HDD · USB · DLNA · IPTV · services officiels selon compatibilité"; color:"#add0e7"; font.pixelSize:13 }
          }
        }
        Repeater {
          model: app.currentSections
          Column {
            required property var modelData
            width: contentColumn.width
            spacing: 12
            Text { text: modelData.label; font.pixelSize: 22; font.bold:true; color:"white" }
            ListView {
              id: mediaRow
              width: contentColumn.width; height: 300
              orientation: ListView.Horizontal
              spacing: 22
              clip: true
              model: modelData.media
              delegate: MediaTile {
                mediaTitle: modelData.title
                category: modelData.genre
                mediaYear: modelData.year
                duration: modelData.time
                status: modelData.status
                onPlayRequested: function(title) { app.showMessage("Démo : " + title + "\nModule de lecture à intégrer avec VLC.") }
              }
              ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }
            }
          }
        }
        Rectangle {
          width: parent.width; height: 76; radius: 12
          color: "#d0081a32"; border.color: "#375e83"
          Row {
            anchors.centerIn:parent
            spacing: 13
            Repeater {
              model: ["Netflix","Disney+","Free TV","Prime Video","Apple TV"]
              Rectangle {
                width: Math.max(72, Math.min(120, (contentColumn.width - 80) / 5))
                height: 37; radius: 13
                color: linkHover.containsMouse ? "#245c8c" : "#0f2a46"; border.color:"#3ea9e4"
                Text { text: modelData; color:"white"; font.pixelSize: 11; anchors.centerIn:parent }
                MouseArea { id:linkHover; anchors.fill:parent; hoverEnabled:true; onClicked: app.openProvider(modelData) }
              }
            }
          }
        }
      }
    }
  }
  Dialog {
    id: messageBox
    title: "NEXUS — information"
    property alias text: msg.text
    modal: true
    anchors.centerIn: parent
    standardButtons: Dialog.Ok
    contentItem: Text {
      id: msg; text:""; color:"white"; wrapMode: Text.WordWrap; width: 320; padding: 15
    }
    background: Rectangle { radius: 12; color:"#0a1a2c"; border.color:"#60bdf5" }
  }
}
