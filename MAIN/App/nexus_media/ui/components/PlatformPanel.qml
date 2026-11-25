import QtQuick
GlassPanel {
    id: panel
    required property var hub
    Column {anchors.fill:parent;anchors.margins:14;spacing:8
        Text {text:"⊞   Applications et plateformes";color:"white";font.bold:true;font.pixelSize:21}
        Grid {width:parent.width;columns:2;spacing:8
            Repeater {model:["Free TV","Netflix","Disney+","Prime Video","Apple TV","VLC"]
                NeonButton {required property string modelData;width:(parent.width-8)/2;height:43;text:"▷    "+modelData;selected:modelData===hub.providerName;onClicked:modelData==="VLC"?station.openVlc():hub.openProvider(modelData)}
            }
        }
        Text {width:parent.width;text:"ⓘ   Ouverture du service officiel.";font.pixelSize:15;color:"#dcefff"}
    }
}
