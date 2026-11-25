import QtQuick
import QtQuick.Controls
import "../theme" as Design
AbstractButton {
    id: tile
    property var itemData: ({})
    property bool demo: false
    hoverEnabled: true
    background: Rectangle { color: Design.Palette.panel; radius: 12; border.color: tile.activeFocus || tile.hovered ? Design.Palette.accent : Design.Palette.edge }
    contentItem: Column {
        spacing: 7
        Item {
            width: parent.width; height: tile.height-70; clip: true
            Rectangle { anchors.fill: parent; color: "#203751"; radius: 10 }
            Image { anchors.fill: parent; source: tile.itemData.art || ""; fillMode: Image.PreserveAspectCrop; asynchronous: true }
            Text { anchors.centerIn: parent; visible: !tile.itemData.art; text: "▷"; color: Design.Palette.accent; font.pixelSize: 38 }
        }
        Text { x: 12; width: parent.width-24; elide: Text.ElideRight; text: tile.itemData.title || ""; color: Design.Palette.ink; font.bold: true; font.pixelSize: 16 }
        Text { x: 12; color: tile.demo ? Design.Palette.muted : (tile.itemData.seen ? "#ff9198" : tile.itemData.position ? "#f3cd78" : "#8fd5b4"); text: tile.demo ? "DÉMO  /  "+tile.itemData.genre : (tile.itemData.seen ? "●  Déjà vu" : tile.itemData.position ? "●  En cours" : "●  Jamais vu"); font.pixelSize: 12 }
    }
}
