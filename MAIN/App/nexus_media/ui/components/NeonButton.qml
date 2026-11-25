import QtQuick
import QtQuick.Controls
import "../theme" as Design
Button {
    id: b
    property bool selected: false
    hoverEnabled: true
    implicitHeight: 42
    leftPadding: 14
    rightPadding: 14
    contentItem: Text { text: b.text; font.pixelSize: 14; color: b.selected ? Design.Palette.accent : Design.Palette.ink; verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
    background: Rectangle { radius: 10; color: b.selected || b.hovered ? "#203a50" : Design.Palette.panel; border.color: b.activeFocus || b.selected ? Design.Palette.accent : Design.Palette.edge }
}
