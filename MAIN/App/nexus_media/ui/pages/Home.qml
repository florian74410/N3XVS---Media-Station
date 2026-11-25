import QtQuick
import QtQuick.Controls
import "../components"
import "../theme" as Design
Column {
    required property var hub
    spacing: 30
    Rectangle {
        visible: hub.showcase; width: parent.width; height: hub.width<760?160:202; radius: 14; color: Design.Palette.panel; clip: true
        Image { anchors.fill: parent; source: hub.hero.art; fillMode: Image.PreserveAspectCrop }
        Rectangle { anchors.fill: parent; gradient: Gradient { orientation: Gradient.Horizontal; GradientStop { position: 0; color: "#ed0c182b" } GradientStop { position: 1; color: "#120d1420" } } }
        Column { anchors.left: parent.left; anchors.leftMargin: 26; anchors.verticalCenter: parent.verticalCenter; spacing: 8
            AppBadge { text: "SÉLECTION  /  DÉMO" }
            Label { text: hub.hero.title; color: Design.Palette.ink; font.bold: true; font.pixelSize: hub.width<760?28:40 }
            Label { text: hub.hero.genre+"   ·   Œuvre fictive"; color: Design.Palette.muted }
        }
    }
    RowCarousel { visible: hub.showcase; width: parent.width; title: "À découvrir"; entries: hub.sample; demo: true; onChosen: item => hub.hero=item }
}
