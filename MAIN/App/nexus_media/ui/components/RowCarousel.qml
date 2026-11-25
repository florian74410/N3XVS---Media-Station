import QtQuick
import QtQuick.Controls
import "../theme" as Design
Column {
    id: carousel
    property string title
    property var entries: []
    property bool demo: false
    signal chosen(var item)
    spacing: 12
    Item {
        width: parent.width; height: 34
        Label { anchors.verticalCenter: parent.verticalCenter; text: carousel.title; font.pixelSize: 20; font.bold: true; color: Design.Palette.ink }
        Row {
            anchors.right: parent.right; spacing: 8
            NeonButton { text: "‹"; height: 32; enabled: view.currentIndex>0; onClicked: view.decrementCurrentIndex() }
            NeonButton { text: "›"; height: 32; enabled: view.currentIndex<view.count-1; onClicked: view.incrementCurrentIndex() }
        }
    }
    ListView {
        id: view; width: parent.width; height: 170; spacing: Design.Palette.gap; clip: true
        orientation: ListView.Horizontal; model: carousel.entries; boundsBehavior: Flickable.StopAtBounds
        keyNavigationEnabled: true
        onCurrentIndexChanged: if(currentIndex>=0) positionViewAtIndex(currentIndex,ListView.Contain)
        delegate: MediaTile {
            required property var modelData
            required property int index
            width: (view.width-(columns-1)*view.spacing)/columns
            readonly property int columns: Math.max(1,Math.min(6,Math.floor((view.width+24)/195)))
            height: view.height; demo: carousel.demo; itemData: modelData
            onClicked: {view.currentIndex=index; carousel.chosen(modelData)}
            Keys.onReturnPressed: clicked()
        }
    }
}
