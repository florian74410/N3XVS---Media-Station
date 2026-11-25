import QtQuick
import QtQuick.Layouts
ColumnLayout {
    required property var hub
    signal navigate(string name)
    Layout.alignment: Qt.AlignTop; spacing: 9
    Repeater {
        model: hub.sections
        SideNavItem { required property string modelData; required property int index
            Layout.preferredWidth: hub.width<780?52:148
            compact: hub.width<780; name: modelData; symbol: ["⌂","▷","TV","↺","▤","◎","⊞"][index]; selected: hub.page===modelData
            onClicked: navigate(modelData)
        }
    }
}
