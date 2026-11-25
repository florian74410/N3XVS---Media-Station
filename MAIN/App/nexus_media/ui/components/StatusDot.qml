import QtQuick
Rectangle {
    property bool seen: false
    property bool started: false
    width: 8; height: 8; radius: 4
    color: seen ? "#ff9198" : started ? "#f3cd78" : "#8fd5b4"
}
