import QtQuick
import QtQuick.Controls
AbstractButton {
    id:b
    property string glyph
    property string heading
    property string description
    property string detail
    Accessible.name:heading; hoverEnabled:true
    background:GlassPanel {highlighted:b.hovered||b.activeFocus}
    contentItem:Row {
        spacing:16; leftPadding:16
        GlassPanel {width:78; height:78; anchors.verticalCenter:parent.verticalCenter; Image {anchors.centerIn:parent; width:52;height:50;source:skinUrl+"nav-"+b.glyph+".png"}}
        Column {anchors.verticalCenter:parent.verticalCenter; spacing:6; width:parent.width-118
            Text {width:parent.width;text:b.heading;color:"white";font.bold:true;font.pixelSize:21;elide:Text.ElideRight}
            Text {width:parent.width;text:b.description;color:"#e0efff";font.pixelSize:15;elide:Text.ElideRight}
            Text {width:parent.width;text:b.detail;color:"#8bdfff";font.pixelSize:15;elide:Text.ElideRight}
        }
    }
}
