import QtQuick
import QtQuick.Controls
Row {
    id: bar
    property string title
    property string symbol:"▷"
    property bool more:true
    signal requested()
    spacing:12; height:40
    Text {text:bar.symbol; color:"#ff505d"; font.pixelSize:30; anchors.verticalCenter:parent.verticalCenter}
    Text {id:heading; text:bar.title; font.bold:true; font.pixelSize:24; color:"white"; anchors.verticalCenter:parent.verticalCenter}
    Rectangle {
        anchors.verticalCenter:parent.verticalCenter; width:Math.max(0,bar.width-heading.width-(bar.more?154:73)); height:2
        gradient:Gradient {orientation:Gradient.Horizontal; GradientStop{position:0;color:"#f72c4f"} GradientStop{position:0.16;color:"#284461"} GradientStop{position:1;color:"transparent"}}
    }
    AbstractButton {visible:bar.more; height:parent.height; width:82; text:"Voir tout  ›"; onClicked:bar.requested()
        contentItem:Text {text:parent.text; color:parent.activeFocus?"white":"#8be4ff"; font.pixelSize:16; verticalAlignment:Text.AlignVCenter}}
}
