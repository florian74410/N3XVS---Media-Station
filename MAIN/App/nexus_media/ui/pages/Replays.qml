import QtQuick
import QtQuick.Controls
import "../components"
import "../theme" as Design
Column {
    required property var hub
    spacing: 30
    Flow {
        width:parent.width; spacing:14
        Repeater { model:["france.tv","ARTE","Free TV"]
            NeonButton { required property string modelData; text:modelData; onClicked:hub.openProvider(modelData) }
        }
    }
}
