import QtQuick
import "../components"
Column {
    id:catalog
    required property var hub
    spacing:6
    Grid {width:parent.width;columns:width<850?1:2;spacing:14
        HeroBanner {hub:catalog.hub;width:parent.columns===1?parent.width:(parent.width-14)*.705;height:245}
        PlatformPanel {hub:catalog.hub;width:parent.columns===1?parent.width:(parent.width-14)*.295;height:245}
    }
    PosterRail {width:parent.width;heading:"Tendances";icon:"♨";entries:[0,2,3,4,1].map(i=>hub.sample[i]);columns:Math.max(1,Math.min(5,Math.floor(width/249)));cardHeight:141;showAction:false;onChosen:e=>hub.inspect(e);onMoreRequested:hub.listTitles(heading,entries)}
    Grid {width:parent.width;columns:width<850?1:2;spacing:18
        Repeater {model:["Films","Séries"]
            PosterRail {required property string modelData;width:parent.columns===1?parent.width:(parent.width-18)/2;heading:modelData;icon:modelData==="Films"?"▤":"▣";entries:(modelData==="Films"?[6,5,7]:[8,11,12]).map(i=>hub.sample[i]);columns:Math.max(1,Math.min(3,Math.floor(width/210)));cardHeight:149;actionText:"▷  Voir la fiche";onChosen:e=>hub.inspect(e);onMoreRequested:hub.listTitles(heading,entries)}
        }
    }
    PosterRail {width:parent.width;heading:"À reprendre";icon:"◴";entries:[1,8,0].map(i=>hub.sample[i]);columns:Math.max(1,Math.min(3,Math.floor(width/315)));cardHeight:99;shortCard:true;onChosen:e=>hub.inspect(e);onMoreRequested:hub.listTitles(heading,entries)}
}
