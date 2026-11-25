import QtQuick
import QtQuick.Controls
Button {
    id: b
    property bool selected:false
    property bool pill:false
    property int labelSize:16
    hoverEnabled:true; implicitHeight:44
    leftPadding:6; rightPadding:6
    contentItem: Text { text:b.text; textFormat:Text.PlainText; font.pixelSize:b.labelSize; font.weight:Font.DemiBold; color:"white"; horizontalAlignment:Text.AlignHCenter; verticalAlignment:Text.AlignVCenter; elide:Text.ElideRight }
    background: Item {
        BorderImage {anchors.fill:parent; source:skinUrl+(b.selected?"active":b.pill?"cta":"button")+".png"; border.left:12; border.right:12; border.top:9; border.bottom:9}
        Rectangle {anchors.fill:parent; radius:b.pill?height/2:10; color:b.hovered?"#234ac9ff":"transparent"; border.color:b.activeFocus?"white":"transparent"}
    }
}
