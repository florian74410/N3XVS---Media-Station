import QtQuick
import QtQuick.Controls
import "../components"
import "../theme" as Design
Column {
    required property var hub
    spacing: 30
    RowCarousel { visible: hub.page==="Streaming"; width:parent.width; title:"Films de démonstration"; entries:hub.sample.filter((entry,i)=>i%2===0); demo:true; onChosen:item=>hub.hero=item }
    RowCarousel { visible: hub.page==="Streaming"; width:parent.width; title:"Séries de démonstration"; entries:hub.sample.filter((entry,i)=>i%2===1); demo:true; onChosen:item=>hub.hero=item }
}
