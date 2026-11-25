import QtQuick
import QtQuick.Controls
import "../components"
Column {
    id: library
    required property var hub
    property string category:"Tous"
    readonly property bool demo:hub.totalMedia===0
    readonly property var films:demo?hub.sample.slice(5):hub.rows
    readonly property var filtered:category==="Tous"?films:films.filter(e=>e.category===category)
    spacing:11
    Grid {
        width:parent.width; columns:width<800?1:3; spacing:16
        SourcePanel {width:parent.columns===1?parent.width:(parent.width-32)*.355;height:116;glyph:"library";heading:"Bibliothèque locale";description:"Fichiers sur le Media Box (USB / Disque interne)";detail:hub.summary;onClicked:hub.chooseFolder()}
        SourcePanel {width:parent.columns===1?parent.width:(parent.width-32)*.33;height:116;glyph:"dlna";heading:"Serveurs DLNA";description:"Contenus multimédia sur votre réseau";detail:"Rechercher les serveurs   ›";onClicked:hub.scanLan()}
        GlassPanel {width:parent.columns===1?parent.width:(parent.width-32)*.315;height:116
            Column {anchors.fill:parent;anchors.margins:14;spacing:8
                Text {text:"◉   Serveurs DLNA découverts";font.bold:true;font.pixelSize:19;color:"white"}
                Rectangle {width:parent.width;height:1;color:"#35638a"}
                Text {text:hub.servers.length?hub.servers.slice(0,3).map(x=>"▤   "+x.title).join("   ·   "):hub.discovering?"Recherche en cours…":hub.lanChecked?"Aucun serveur détecté":"Aucune recherche effectuée";width:parent.width;color:"#c8e3fa";font.pixelSize:15;wrapMode:Text.Wrap;textFormat:Text.PlainText}
            }
        }
    }
    PosterRail {width:parent.width; heading:"Continuer le visionnage";columns:Math.max(1,Math.min(4,Math.floor(width/290)));cardHeight:183
        visible:demo || hub.watching.length>0; entries:demo?hub.sample.slice(0,4):hub.watching
        onChosen:e=>hub.inspect(e);onMoreRequested:hub.listTitles(heading,entries)}
    Item {width:parent.width;height:40
        SectionBar {anchors.fill:parent;title:"Films – Bibliothèque";symbol:"▤";onRequested:hub.listTitles(title,library.filtered)}
        Row {visible:library.demo && parent.width>790;anchors.centerIn:parent;spacing:1
            Repeater {model:["Tous","Films","Séries","Dossiers"];NeonButton {required property string modelData;width:100;height:30;pill:true;labelSize:14;text:modelData;selected:library.category===modelData;onClicked:{if(modelData==="Dossiers")hub.chooseFolder();else library.category=modelData}}}
        }
    }
    ListView {id:titles;width:parent.width;height:307;spacing:14;clip:true;orientation:ListView.Horizontal;model:library.filtered
        delegate:PosterCard {required property var modelData; width:Math.floor((titles.width-4-(countAcross-1)*titles.spacing)/countAcross);readonly property int countAcross:Math.max(1,Math.min(8,Math.floor((titles.width+14)/166))); height:300;y:3;portrait:true;entry:modelData;onClicked:hub.inspect(modelData)}
    }
    Flow {visible:!demo;width:parent.width;spacing:10
        InputField {placeholderText:"Filtrer par titre"; onTextChanged:{hub.query=text;hub.offset=0;hub.refresh()}}
        NeonButton {text:"À regarder";onClicked:hub.listTitles(text,hub.rows.filter(e=>e.watchlist))}
        NeonButton {visible:hub.offset>0;text:"Précédents";onClicked:{hub.offset-=48;hub.refresh()}}
        NeonButton {visible:hub.rows.length===48;text:"Suivants";onClicked:{hub.offset+=48;hub.refresh()}}
    }
}
