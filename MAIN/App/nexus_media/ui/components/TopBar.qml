import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../theme" as Design
RowLayout {
    property bool compact: false
    signal settingsRequested()
    signal usersRequested()
    signal accountsRequested()
    spacing: 10
    Label {text:"N E X U S"; color:Design.Palette.ink; font.bold:true; font.pixelSize:24}
    Label {visible:!compact; text:" / MEDIA STATION"; color:Design.Palette.accent; font.pixelSize:12}
    Item {Layout.fillWidth:true}
    OutlinedButton {visible:!compact; text:"Utilisateurs"; onClicked:parent.usersRequested()}
    OutlinedButton {visible:!compact; text:"Comptes"; onClicked:parent.accountsRequested()}
    NeonButton {text:"Paramètres"; onClicked:parent.settingsRequested()}
}
