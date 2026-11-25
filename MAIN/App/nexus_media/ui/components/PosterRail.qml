import QtQuick
import QtQuick.Controls
Column {
    id: rail
    property var entries:[]
    property string heading
    property string icon:"▷"
    property bool portrait:false
    property bool shortCard:false
    property bool showAction:true
    property int columns:4
    property int cardHeight:160
    property string actionText:"▷   À regarder"
    signal chosen(var entry)
    signal moreRequested()
    spacing:5
    SectionBar {width:parent.width; title:rail.heading; symbol:rail.icon; onRequested:rail.moreRequested()}
    ListView {
        id: view; width:parent.width; height:rail.cardHeight+6; orientation:ListView.Horizontal
        spacing:14; model:rail.entries; clip:true; boundsBehavior:Flickable.StopAtBounds
        delegate:PosterCard {
            required property var modelData
            y:3; width:Math.floor((view.width-4-(rail.columns-1)*view.spacing)/rail.columns); height:rail.cardHeight
            entry:modelData; portrait:rail.portrait; showAction:rail.showAction; actionText:rail.actionText; shortCard:rail.shortCard
            onClicked:rail.chosen(modelData)
        }
        ScrollBar.horizontal:ScrollBar {policy:view.contentWidth>view.width?ScrollBar.AsNeeded:ScrollBar.AlwaysOff}
    }
}
