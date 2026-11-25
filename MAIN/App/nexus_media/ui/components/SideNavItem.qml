import QtQuick
NeonButton {
    required property string name
    required property string symbol
    property bool compact: false
    Accessible.name: name
    text: compact ? symbol : name
}
