import QtQuick
import QtQuick.Controls
import "../components"
import "../theme" as Design
Column {
    required property var hub
    spacing: 30
    NeonButton { visible: hub.page==="Applications"; text: "Ouvrir VLC"; onClicked: station.openVlc() }
    Flow {
        width:parent.width; spacing:14
        Repeater { model:["Netflix","Disney+","Prime Video","Apple TV","Free TV","france.tv","ARTE"]
            NeonButton { required property string modelData; text:modelData; onClicked:hub.openProvider(modelData) }
        }
    }
}
