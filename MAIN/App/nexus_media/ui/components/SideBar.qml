import QtQuick
import QtQuick.Controls
GlassPanel {
    id: nav
    required property var hub
    property bool compact:false
    signal navigate(string name)
    height:links.height+20
    Column {id:links; y:10; width:parent.width
        Repeater {model:hub.sections
            AbstractButton {
                id: link
                required property string modelData
                required property int index
                width:links.width; height:Math.min(hub.page==="Bibliothèque"?64:59,Math.max(39,(nav.parent.height-nav.y-28)/8))
                hoverEnabled:true; Accessible.name:modelData
                background: Item {
                    BorderImage {anchors.fill:parent; visible:link.modelData===hub.page; source:skinUrl+"selection.png"; border.left:15; border.right:15; border.top:10; border.bottom:10}
                    Rectangle {visible:link.hovered||link.activeFocus; anchors.fill:parent; radius:11; color:"#254daaea"; border.color:"#87d5ff"}
                    Rectangle {visible:link.index<7; anchors.bottom:parent.bottom; x:14; width:parent.width-28; height:1; color:"#30577c"}
                }
                contentItem:Row {spacing:17; leftPadding:nav.compact?10:18
                    Image {anchors.verticalCenter:parent.verticalCenter; width:37;height:36;source:skinUrl+"nav-"+["home","netflix","disney","tv","replays","library","dlna","apps"][link.index]+".png"}
                    Text {visible:!nav.compact; anchors.verticalCenter:parent.verticalCenter; text:link.modelData; color:"white"; font.bold:true; font.pixelSize:20}
                }
                onClicked:nav.navigate(modelData)
            }
        }
    }
}
