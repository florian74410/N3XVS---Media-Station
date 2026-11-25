import QtQuick
import QtQuick.Controls
AbstractButton {
    id: tile
    required property var entry
    property bool portrait:false
    property bool shortCard:false
    property bool showAction:true
    property string actionText:"▷   À regarder"
    hoverEnabled:true; Accessible.name:entry.title
    background:GlassPanel {corner:12; highlighted:tile.hovered||tile.activeFocus}
    contentItem:Item {
        Image {
            id:poster; x:4; y:4
            width:tile.portrait?parent.width-8:Math.round(parent.width*(tile.shortCard?.33:.42))
            height:tile.portrait?Math.round(parent.height*.49):parent.height-8
            fillMode:Image.PreserveAspectCrop; source:tile.entry.art||""; clip:true
        }
        Column {
            x:tile.portrait?12:poster.width+13; y:tile.portrait?poster.height+10:13
            width:parent.width-x-9; spacing:tile.shortCard?5:7
            Text {width:parent.width; text:tile.entry.title; color:"white"; font.pixelSize:17; font.bold:true; maximumLineCount:2; wrapMode:Text.Wrap; elide:Text.ElideRight;textFormat:Text.PlainText}
            Text {width:parent.width; text:tile.entry.info || [tile.entry.year, tile.entry.duration?Math.round(tile.entry.duration/60)+" min":""].filter(Boolean).join("  ·  "); color:"#d2e3ee";font.pixelSize:15; elide:Text.ElideRight}
            Text {visible:!tile.shortCard && !!tile.entry.score; text:"★ "+(tile.entry.score||"")+" /10"; color:"#ffd15a"; font.pixelSize:17; font.bold:true}
            Text {visible:!tile.shortCard; text:tile.entry.seen?"●  Déjà vu":tile.entry.position?"●  En cours":"●  Jamais vu"; color:tile.entry.seen?"#ff646c":tile.entry.position?"#ffd448":"#6df643";font.pixelSize:14}
            Rectangle {visible:!!tile.entry.position; width:parent.width*.86; height:6; radius:3;color:"#38475b"; Rectangle{width:parent.width*Math.min(1,tile.entry.position/Math.max(1,tile.entry.duration||100));height:parent.height;radius:3;color:"#ffcc18"}}
        }
        NeonButton {visible:tile.showAction && !tile.shortCard; x:tile.portrait?12:poster.width+12; y:parent.height-height-10; width:parent.width-x-10; height:31; labelSize:14; pill:true;text:tile.actionText; onClicked:tile.clicked()}
    }
}
