import QtQuick
import QtQuick.Controls
import "../components"
import "../theme" as Design
Column {
    required property var hub
    spacing: 30
    NeonButton { text:"Free TV"; onClicked:hub.openProvider(text) }
    NeonButton { visible: hub.page==="TV Direct"; text: "Importer une playlist M3U"; onClicked: hub.choosePlaylist() }
    RowCarousel { visible: hub.page==="TV Direct" && hub.streams.length>0; width: parent.width; title: "Chaînes importées"; entries: hub.streams; onChosen: item=>station.watch(item.path) }
}
