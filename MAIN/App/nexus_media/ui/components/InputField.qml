import QtQuick
import QtQuick.Controls
import "../theme" as Design
TextField {
    implicitHeight: 42
    leftPadding: 14
    color: Design.Palette.ink
    placeholderTextColor: Design.Palette.muted
    background: Rectangle {radius:10; color:Design.Palette.panel; border.color:parent.activeFocus?Design.Palette.accent:Design.Palette.edge}
}
