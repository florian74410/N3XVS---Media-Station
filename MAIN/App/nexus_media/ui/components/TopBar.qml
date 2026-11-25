import QtQuick
import QtQuick.Controls
Item {
    id:bar
    property bool compact:false
    signal settingsRequested()
    signal usersRequested()
    signal accountsRequested()
    BrandLogo {width:bar.compact?225:426; height:parent.height}
    Row {anchors.right:parent.right; anchors.rightMargin:10; anchors.verticalCenter:parent.verticalCenter; spacing:10
        Repeater {
            model:["Paramètres","Utilisateurs","Comptes"]
            AbstractButton {id:control;required property string modelData;required property int index
                visible:index===0||!bar.compact; width:132;height:43;hoverEnabled:true;Accessible.name:modelData
                contentItem:Image {source:skinUrl+["settings","users","accounts"][control.index]+".png";fillMode:Image.PreserveAspectFit}
                background:Rectangle {radius:22;color:"transparent";border.color:control.activeFocus||control.hovered?"#97eaff":"transparent"}
                onClicked:{if(index===0)bar.settingsRequested();else if(index===1)bar.usersRequested();else bar.accountsRequested()}
            }
        }
    }
}
