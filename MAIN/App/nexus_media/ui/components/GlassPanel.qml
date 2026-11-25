import QtQuick
Item {
    id: panel
    property real corner: 14
    property bool highlighted: false
    Rectangle { anchors.fill:parent; anchors.margins:-3; radius:panel.corner+3; color:"transparent"; border.width:3; border.color:panel.highlighted?"#604baaff":"#44429ee9" }
    Rectangle {
        anchors.fill:parent; radius:panel.corner
        border.color:panel.highlighted?"#9be6ff":"#63c0f7"
        gradient: Gradient {
            GradientStop {position:0; color:"#f0235883"}
            GradientStop {position:0.1; color:"#f1081b2e"}
            GradientStop {position:0.85; color:"#f205101e"}
            GradientStop {position:1; color:"#f01a3a56"}
        }
    }
}
