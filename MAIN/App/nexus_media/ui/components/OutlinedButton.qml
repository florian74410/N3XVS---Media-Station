import QtQuick
import "../theme" as Design
NeonButton {
    id: button
    background: Rectangle {radius:10; color:button.hovered?Design.Palette.panel:"transparent"; border.color:button.activeFocus?Design.Palette.accent:Design.Palette.edge}
}
