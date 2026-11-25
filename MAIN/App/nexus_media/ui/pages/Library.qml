import QtQuick
import QtQuick.Controls
import "../components"
import "../theme" as Design
Column {
    required property var hub
    spacing: 30
    Column { visible: hub.collection; width: parent.width; spacing: 12
        Label { text: hub.summary; color: Design.Palette.muted; width: parent.width; wrapMode: Text.Wrap }
        Flow { width: parent.width; spacing: 10
            NeonButton { text: "Choisir un dossier"; onClicked: hub.chooseFolder() }
            InputField { width: 180; placeholderText: "Filtrer par titre"; onTextChanged: {hub.query=text; hub.offset=0; hub.refresh()} }
        }
    }
    RowCarousel { visible: hub.collection && hub.watching.length>0; width: parent.width; title: "À reprendre"; entries: hub.watching; onChosen: item=>{hub.showDetails(item)} }
    RowCarousel { visible: hub.collection && hub.rows.length>0; width: parent.width; title: "Mes médias"; entries: hub.rows; onChosen: item=>{hub.showDetails(item)} }
    RowCarousel { visible: hub.collection && entries.length>0; width:parent.width; title:"À regarder sur cette page"; entries:hub.rows.filter(item=>!!item.watchlist); onChosen:item=>{hub.showDetails(item)} }
    Row { visible: hub.collection && (hub.offset>0 || hub.rows.length===48); spacing: 12
        NeonButton { text: "Précédents"; enabled: hub.offset>0; onClicked: {hub.offset-=48; hub.refresh()} }
        NeonButton { text: "Suivants"; enabled: hub.rows.length===48; onClicked: {hub.offset+=48; hub.refresh()} }
    }
}
