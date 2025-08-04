var svg6present=false;
var svgpresent=false;

/*function initEmbedSVG()
{*/
  if(navigator.plugins)
  {
    for(i=0;i<navigator.plugins.length;i++) {
      var desc=navigator.plugins[i].description;
      if(desc.indexOf("SVG Viewer")!=-1)svgpresent=true;
      if(desc.indexOf("SVG Viewer 6.0")!=-1)svg6present=true;
    }
  }
//}

function embedSVG(nodeID, svgURI, width, height)
{
  if (document.getElementById) {

//<object data="anims/schaltung.svg" type="image/svg+xml" width="450" height="250"/>
	  if( svg6present ) {
		  var l=document.createElementNS("http://www.w3.org/1999/xhtml","object");
		  l.setAttribute("data", svgURI);
		  l.setAttribute("type", "image/svg+xml");
		  l.setAttribute("width", width);
		  l.setAttribute("height", height);
		  document.getElementById(nodeID).parentNode.appendChild(l);
	  }

//<span onclick="window.open('anims/schaltung.svg','_blank','innerWidth=450,innerheight=250,dependent=yes');" style="cursor:pointer">Zum Betrachten hier klicken!</span>
	  if( !svg6present && svgpresent ) {
		  var l=document.createElementNS("http://www.w3.org/1999/xhtml","span");
		  l.setAttribute("onclick", "window.open('"+svgURI+"','_blank','innerWidth="+width+",innerheight="+height+",dependent=yes');");
		  l.setAttribute("style", "cursor:pointer");
		  var spanText = document.createTextNode("Zum Betrachten hier klicken!");
		  l.appendChild(spanText);
		  document.getElementById(nodeID).parentNode.appendChild(l);
	  }

	  if( !svg6present && !svgpresent ) {
		  var l=document.createElementNS("http://www.w3.org/1999/xhtml","span");
		  var spanText = document.createTextNode("Zur Betrachtung wird SVG (vorzugsweise Version 6) benötigt! (");
		  var l2=document.createElementNS("http://www.w3.org/1999/xhtml","a");
		  l2.setAttribute("href", "http://www.adobe.com/svg/viewer/install/beta.html");
		  l2.setAttribute("target", "_new");
		  l2.appendChild(document.createTextNode("Adobe SVG Plugin 6.0 beta download"));
		  l.appendChild(spanText);
		  l.appendChild(l2);
		  l.appendChild(document.createTextNode(")"));
		  document.getElementById(nodeID).parentNode.appendChild(l);
	  }

  }
}