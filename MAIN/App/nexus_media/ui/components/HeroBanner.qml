import QtQuick
import QtQuick.Controls
GlassPanel {
    id:hero
    required property var hub
    property int slide:0
    readonly property var slides:[hub.sample[8],hub.sample[0],hub.sample[3],hub.sample[5]]
    readonly property var current:slides[slide]
    Image {x:parent.width*.255;y:3;width:parent.width-x-4;height:parent.height-6;fillMode:Image.PreserveAspectCrop;clip:true;source:hero.slide===0?skinUrl+"hero.png":hero.current.art}
    Rectangle {anchors.fill:parent;anchors.margins:3;radius:12;gradient:Gradient {orientation:Gradient.Horizontal;GradientStop{position:0;color:"#fc03101e"} GradientStop{position:.33;color:"#fa03101e"} GradientStop{position:.57;color:"#1003101e"} GradientStop{position:1;color:"transparent"}}}
    Column {x:width<330?38:62;y:13;width:parent.width*.55;spacing:7
        Text {text:hub.providerName.toUpperCase();color:"#ff3045";font.bold:true;font.pixelSize:18}
        Image {visible:hero.slide===0;source:skinUrl+"stranger-wordmark.png";width:187;height:68}
        Text {visible:hero.slide!==0;text:hero.current.title;color:"white";font.bold:true;font.pixelSize:31;width:parent.width;elide:Text.ElideRight}
        Text {text:hero.current.info+"     ★ "+hero.current.score+" /10";color:"#f4ebd4";font.pixelSize:16}
        Text {width:parent.width;text:hero.slide===0?"À Hawkins, un groupe d’amis fait face à des phénomènes surnaturels qui menacent leur ville…":"Sélection de la maquette de démonstration.";color:"white";wrapMode:Text.Wrap;maximumLineCount:2;elide:Text.ElideRight;font.pixelSize:15}
    }
    Row {x:parent.width<640?32:62;y:parent.height-57;spacing:12
        NeonButton {text:"▷   Ouvrir l’app officielle";selected:true;height:40;onClicked:hub.openProvider(hub.providerName)}
        NeonButton {text:"ⓘ   Voir la fiche";height:40;onClicked:hub.inspect(hero.current)}
    }
    Repeater {model:["‹","›"];AbstractButton {required property int index;required property string modelData;width:34;height:56;x:index?hero.width-width:0;anchors.verticalCenter:parent.verticalCenter;Accessible.name:index?"Suivant":"Précédent";contentItem:Text{text:modelData;color:"#a9e9ff";font.pixelSize:40;horizontalAlignment:Text.AlignHCenter} onClicked:hero.slide=(hero.slide+(index?1:3))%4}}
    Row {anchors.horizontalCenter:parent.horizontalCenter;anchors.bottom:parent.bottom;anchors.bottomMargin:9;spacing:8;Repeater{model:4;Rectangle{required property int index;width:9;height:9;radius:5;color:hero.slide===index?"#e9ffff":"#849baf"}}}
}
