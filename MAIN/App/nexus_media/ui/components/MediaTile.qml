import QtQuick
import QtQuick.Controls

Item {
  id: card
  width: 206
  height: 285
  property string mediaTitle: "Film de démonstration"
  property string mediaYear: "2026"
  property string duration: "1 h 45 min"
  property string category: "Science-fiction"
  property string status: "Jamais vu"
  property string rating: "—"
  property color highlightColor: "#41b4ff"
  signal playRequested(string title)

  Rectangle {
    id: surface
    anchors.fill: parent
    color: "#d7081526"
    radius: 13
    border.width: mouse.containsMouse ? 2 : 1
    border.color: mouse.containsMouse ? "#69d2ff" : "#31577e"
  }
  Rectangle {
    x: 8; y: 8; width: parent.width - 16; height: 147; radius: 10
    gradient: Gradient {
      GradientStop { position: 0; color: "#18375b" }
      GradientStop { position: 1; color: "#09121d" }
    }
    Text {
      anchors.centerIn: parent
      text: card.category.toUpperCase()
      color: "#79c6fb"
      font.pixelSize: 15
      font.bold: true
      horizontalAlignment: Text.AlignHCenter
      width: parent.width - 20
      wrapMode: Text.WordWrap
    }
  }
  Column {
    x: 12; y: 164; width: parent.width - 24
    spacing: 7
    Text {
      text: card.mediaTitle
      color: "white"
      font.bold: true
      font.pixelSize: 14
      elide: Text.ElideRight
      width: parent.width
    }
    Text {
      text: card.mediaYear + " · " + card.duration
      color: "#b6c7da"
      font.pixelSize: 11
      elide: Text.ElideRight
      width: parent.width
    }
    Text { text: "★ " + card.rating + "/10"; color: "#ffcd5f"; font.pixelSize: 12 }
    Row {
      spacing: 7
      Rectangle {
        width: 9; height: 9; radius: 5
        color: card.status === "Jamais vu" ? "#25e583" : card.status === "En cours" ? "#ffcd45" : "#ff536b"
      }
      Text { text: card.status; font.pixelSize: 11; color: "#dfe9ff" }
    }
  }
  Rectangle {
    x: 12; y: parent.height - 37; width: parent.width - 24; height: 27
    radius: 14
    color: playMouse.containsMouse ? "#135a88" : "#083452"
    border.color: "#45baff"
    border.width: 1
    Text { anchors.centerIn: parent; text: "▶  À regarder"; color: "white"; font.pixelSize: 12; font.bold: true }
    MouseArea { id: playMouse; anchors.fill: parent; hoverEnabled: true; onClicked: card.playRequested(card.mediaTitle) }
  }
  MouseArea { id: mouse; anchors.fill: parent; hoverEnabled: true; acceptedButtons: Qt.NoButton }
}
