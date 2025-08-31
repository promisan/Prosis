<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<script src="../../../Scripts/Graphics/graphEngine.js" type="text/javascript"></script>
<script src="../../../Scripts/Graphics/colorFunctions.js" type="text/javascript"></script>

<script>	

	function draw_rectangleTank()
	{
			var container = document.getElementById('graphcontainer');
			var wid = document.getElementById('width').value;
			var hei = document.getElementById('height').value;
			var col1 = document.getElementById('color1').value;
			var col2 = document.getElementById('color2').value;
			var borderwidth = parseInt(document.getElementById('borderwidth').value);
			var bordercolor = document.getElementById('bordercolor').value;
			var fillPercentage = document.getElementById('fillpercentage').value;
			var opacity = document.getElementById('opacity').value;
			var showstrap = document.getElementById('showstrap').value;
			var showfillmark = document.getElementById('showfillmark').value;
			var strapcolor = document.getElementById('strapcolor').value;
			var strapwidth = document.getElementById('strapwidth').value;
			var strapfillpercentage = document.getElementById('strapfillpercentage').value;
			var strapIcon = document.getElementById('strapicon').value;
			var fillIcon = document.getElementById('fillicon').value;
			var iconSize = document.getElementById('iconsize').value;
			var strapText1 = document.getElementById('straptext1').value;
			var strapText2 = document.getElementById('straptext2').value;
			var fillText1 = document.getElementById('filltext1').value;
			var fillText2 = document.getElementById('filltext2').value;
			var textSize = document.getElementById('textsize').value;
			var textColor = document.getElementById('textcolor').value;
			var pipeImage = document.getElementById('pipeimage').value;
			var pipesize = document.getElementById('pipesize').value;
			var showsubLevel = document.getElementById('showsublevel').value;
			var sublevelPercentage = document.getElementById('sublevelpercentage').value;
			var sublevelText1 = document.getElementById('subleveltext1').value;
			var sublevelText2 = document.getElementById('subleveltext2').value;
			var showMinimumLevel = document.getElementById('showminimumlevel').value;
			var minimumlevelPercentage = document.getElementById('minimumlevelpercentage').value;
			var minimumlevelText1 = document.getElementById('minimumleveltext1').value;
			var minimumlevelText2 = document.getElementById('minimumleveltext2').value;
			var showullage = document.getElementById('showullage').value;
			var ullagetext1 = document.getElementById('ullagetext1').value;
			var ullagetext2 = document.getElementById('ullagetext2').value;
			var movedown = pipesize;
			var moveright = 2*borderwidth;
						
			var paper = Raphael(container);
			
			//filled
			var vAttributes={}
			var lighterColor1 = ColorLuminance("#"+col1, 0.75);
			vAttributes["fill"] = "90-#" + lighterColor1 + "-#" + col1;
			vAttributes["fill-opacity"] = opacity;
			vAttributes["stroke"] = "#" + bordercolor;	
			vAttributes["stroke-width"] = parseInt(borderwidth);
			vAttributes["stroke-opacity"] = 0.5;	
			
			if (fillPercentage > 1) {fillPercentage = 1;}
			var clipY = hei*(1 - fillPercentage);
			var clipWidth = 2*wid + parseInt(borderwidth) + parseInt(strapwidth);
			var clipHeight = 2*hei + parseInt(borderwidth) + parseInt(strapwidth);	
			vAttributes["clip-rect"] = 0 + "," + (clipY + parseInt(movedown)) + "," + clipWidth + "," + clipHeight;
			var iFilled = paper.rect(borderwidth, 0, wid, hei).attr(vAttributes);			
			
			//perimeter
			vAttributes={}
			vAttributes["stroke"] = "#" + bordercolor;
			vAttributes["stroke-width"] = parseInt(borderwidth);
			vAttributes["stroke-opacity"] = 0.3;
			var iPerimeter = paper.rect(borderwidth, 0, wid, hei).attr(vAttributes);
			
			//pipe-in/out
			var iPipeIn = paper.image(pipeImage, (wid/2 + parseInt(borderwidth)) - pipesize/2, 0 + 2*parseInt(borderwidth), pipesize, pipesize);
			var iPipeOut = paper.image(pipeImage, (wid/2 + parseInt(borderwidth)) - pipesize/2, parseInt(hei) - 2*parseInt(borderwidth), pipesize, pipesize);
			
			if (showfillmark == "1")
			{	
				//fillImage						
				var initFillIconX = wid/2 - iconSize;
				var initFillIconY = clipY - parseInt(iconSize)/2;			
				var iFillImage = paper.image(fillIcon, initFillIconX, initFillIconY, parseInt(iconSize), parseInt(iconSize))
	
				//filltext			
				vAttributes={}
				vAttributes["fill"] = "#" + textColor;
				vAttributes["text-anchor"] = "end";
				vAttributes["font-size"] = textSize;
					
				var initFillTextX = initFillIconX - 2 - 2;
				var initFillTextY = initFillIconY + parseInt(iconSize) - textSize/2 - 2;
				var vFillText = fillText1;
				if (fillText2 != "") {vFillText = vFillText + "\n" + fillText2;}
				if (initFillTextY <= textSize) {initFillTextY = parseInt(textSize) + 2;}
				if (initFillTextY >= clipY) {initTextY = clipY - textSize;}
				var iFillText = paper.text(initFillTextX, initFillTextY, vFillText).attr(vAttributes);
				
				iFillImage.attr("translation", "0," + movedown);
				iFillText.attr("translation", "0," + movedown);	
				
				iFillImage.attr("translation", moveright + ",0");
				iFillText.attr("translation", moveright + ",0");
			}
			
			if (showsubLevel == "1")
			{
				//sublevel
				vAttributes={}
				vAttributes["stroke"] = "#" + strapcolor ;
				vAttributes["stroke-width"] = strapwidth;
				vAttributes["stroke-opacity"] = 0.3;
				vAttributes["stroke-dasharray"] = "-";
				
				var initSublevelX = 0;
				var initSublevelY =  hei*(1 - sublevelPercentage) + parseInt(borderwidth);
				var endSublevelX = parseInt(wid) + 2*parseInt(borderwidth);
				var endSublevelY = initSublevelY;
				
				var iSublevel = paper.path("M" + initSublevelX + " " + initSublevelY + "L" + endSublevelX + " " + endSublevelY).attr(vAttributes);
				
				//subleveltext			
				vAttributes={}
				vAttributes["fill"] = "#" + textColor;
				vAttributes["text-anchor"] = "end";
				vAttributes["font-weight"] = "bold";
				vAttributes["font-size"] = textSize;
				
				var initTextX = parseInt(wid) + parseInt(borderwidth);
				var initTextY = initSublevelY + parseInt(borderwidth)/2;
				var vSublevelText = sublevelText1;
				if (sublevelText2 != "") {vSublevelText = vSublevelText + "\n" + sublevelText2;}
				var iSublevelText = paper.text(initTextX, initTextY, vSublevelText).attr(vAttributes);					
				
				iSublevel.attr("translation", "0," + movedown);
				iSublevelText.attr("translation", "0," + movedown);
				
				iSublevel.attr("translation", moveright + ",0");
				iSublevelText.attr("translation", moveright + ",0");
							
			}
			
			if (showMinimumLevel == "1")
			{
				//sublevel
				vAttributes={}
				vAttributes["stroke"] = "#" + strapcolor ;
				vAttributes["stroke-width"] = strapwidth;
				vAttributes["stroke-opacity"] = 0.3;
				vAttributes["stroke-dasharray"] = "-";
				
				var initMinimumlevelX = 0;
				var initMinimumlevelY =  hei*(1 - minimumlevelPercentage) + parseInt(borderwidth);
				var endMinimumlevelX = parseInt(wid) + 2*parseInt(borderwidth);
				var endMinimumlevelY = initMinimumlevelY;
				
				var iMinimumlevel = paper.path("M" + initMinimumlevelX + " " + initMinimumlevelY + "L" + endMinimumlevelX + " " + endMinimumlevelY).attr(vAttributes);
				
				//minimumleveltext			
				vAttributes={}
				vAttributes["fill"] = "#" + textColor;
				vAttributes["text-anchor"] = "end";
				vAttributes["font-weight"] = "bold";
				vAttributes["font-size"] = textSize;
				
				var initMTextX = parseInt(wid) + parseInt(borderwidth);
				var initMTextY = initMinimumlevelY + parseInt(borderwidth)/2;
				var vMinimumlevelText = minimumlevelText1;
				if (minimumlevelText2 != "") {vMinimumlevelText = vMinimumlevelText + "\n" + minimumlevelText2;}
				var iMinimumlevelText = paper.text(initMTextX, initMTextY, vMinimumlevelText).attr(vAttributes);					
				
				iMinimumlevel.attr("translation", "0," + movedown);
				iMinimumlevelText.attr("translation", "0," + movedown);
				
				iMinimumlevel.attr("translation", moveright + ",0");
				iMinimumlevelText.attr("translation", moveright + ",0");
							
			}
			
			if (showstrap == "1")
			{
				//strap
				vAttributes={}
				vAttributes["stroke"] = "#" + strapcolor ;
				vAttributes["stroke-width"] = strapwidth;
				vAttributes["stroke-opacity"] = 0.5;
				
				var initStrapX = wid/2 + parseInt(borderwidth);
				var initStrapY =  0;
				var endStrapY = parseInt(hei);
				
				var iStrap = paper.path("M" + initStrapX + " " + initStrapY + "L" + initStrapX + " " + endStrapY).attr(vAttributes);
				
				//strapmark			
				vAttributes={}
				vAttributes["stroke"] = "#" + strapcolor ;
				vAttributes["stroke-width"] = parseInt(strapwidth) + 2;
				
				var initMarkX = initStrapX - 2*parseInt(strapwidth);
				var initMarkY = (hei*(1-strapfillpercentage));
				var endMarkX = initStrapX + 2*parseInt(strapwidth);			
				var iStrapMark = paper.path("M" + initMarkX + " " + initMarkY + "L" + endMarkX + " " + initMarkY).attr(vAttributes);
							
				var initIconX = endMarkX + 1;
				var initIconY = initMarkY - parseInt(iconSize)/2;			
				var iStrapImage = paper.image(strapIcon, initIconX, initIconY, parseInt(iconSize), parseInt(iconSize));
				
				//straptext			
				vAttributes={}
				vAttributes["fill"] = "#" + textColor;
				vAttributes["text-anchor"] = "start";
				vAttributes["font-size"] = textSize;
				
				var initTextX = initMarkX + 2*parseInt(iconSize) - 2;
				var initTextY = initMarkY + parseInt(iconSize)/2 - textSize/2 - 2;
				var vText = strapText1;
				if (strapText2 != "") {vText = vText + "\n" + strapText2;}
				if (initTextY <= textSize) {initTextY = parseInt(textSize) + 2;}
				if (initTextY >= endStrapY) {initTextY = initMarkY + parseInt(borderwidth);}
				var iStrapText = paper.text(initTextX, initTextY, vText).attr(vAttributes);
				
				iStrap.attr("translation", "0," + movedown);
				iStrapMark.attr("translation", "0," + movedown);
				iStrapImage.attr("translation", "0," + movedown);
				iStrapText.attr("translation", "0," + movedown);
				
				iStrap.attr("translation", moveright + ",0");
				iStrapMark.attr("translation", moveright + ",0");
				iStrapImage.attr("translation", moveright + ",0");
				iStrapText.attr("translation", moveright + ",0");
			}	
			
			if (showsubLevel == "1" && showullage == "1")
			{
				//ullage
				vAttributes={}
				vAttributes["stroke"] = "#" + strapcolor ;
				vAttributes["stroke-width"] = strapwidth;
				vAttributes["stroke-opacity"] = 0.5;
				vAttributes["stroke-dasharray"] = "-";
				
				var initUllageX = parseInt(wid) + parseInt(borderwidth) + 15;
				var initUllageY =  initSublevelY;
				var endUllageY = clipY;
				
				var iUllage = paper.path("M" + initUllageX + " " + initUllageY + "L" + initUllageX + " " + endUllageY).attr(vAttributes);
				
				//ullagemarks
				vAttributes={}
				vAttributes["stroke"] = "#" + strapcolor ;
				vAttributes["stroke-width"] = strapwidth;
				vAttributes["stroke-opacity"] = 0.5;
				
				var initMarkUllageX = initUllageX - 5;
				var initMarkUllageY = initUllageY;
				var endMarkUllageX = initMarkUllageX + 2*parseInt(strapwidth) + 5;		
				var iUllageMark = paper.path("M" + initMarkUllageX + " " + initMarkUllageY + "L" + endMarkUllageX + " " + initMarkUllageY).attr(vAttributes);
				
				var endMarkUllageY = endUllageY;
				var iUllageMark2 = paper.path("M" + initMarkUllageX + " " + endMarkUllageY + "L" + endMarkUllageX + " " + endMarkUllageY).attr(vAttributes);
				
				//ullagetext			
				vAttributes={}
				vAttributes["fill"] = "#" + textColor;
				vAttributes["text-anchor"] = "start";
				vAttributes["font-size"] = textSize;
				
				var initTextUllageX = initUllageX + 10;
				var initTextUllageY = initUllageY + ((endUllageY - initUllageY) / 2);
				var vTextUllage = ullagetext1;
				if (ullagetext2 != "") {vTextUllage = vTextUllage + "\n" + ullagetext2;}
				var iUllageText = paper.text(initTextUllageX, initTextUllageY, vTextUllage).attr(vAttributes);								
				
				iUllage.attr("translation", "0," + movedown);
				iUllageMark.attr("translation", "0," + movedown);
				iUllageMark2.attr("translation", "0," + movedown);
				iUllageText.attr("translation", "0," + movedown);
				
				iUllage.attr("translation", moveright + ",0");
				iUllageMark.attr("translation", moveright + ",0");
				iUllageMark2.attr("translation", moveright + ",0");
				iUllageText.attr("translation", moveright + ",0");
				
			}					
								
			iFilled.attr("translation", "0," + movedown);
			iPerimeter.attr("translation", "0," + movedown);			
			iPipeOut.attr("translation", "0," + movedown);		
			
			iPipeIn.attr("translation", moveright + ",0");
			iPipeOut.attr("translation", moveright + ",0");
			iFilled.attr("translation", moveright + ",0");
			iPerimeter.attr("translation", moveright + ",0");
									
	}
	
	window.onload = function () {draw_rectangleTank();}
	
</script>

<cfoutput>
<body style="background-color:#url.backgroundcolor#;">
	<cfset vWid = url.width + url.borderwidth>
	<cfset vHei = url.height + url.borderwidth>
	
	<input type="hidden" name="width" id="width" value="#vWid#">
	<input type="hidden" name="height" id="height" value="#vHei#">
	<input type="hidden" name="color1" id="color1" value="#url.color1#">
	<input type="hidden" name="color2" id="color2" value="#url.color2#">
	<input type="hidden" name="bordercolor" id="bordercolor" value="#url.bordercolor#">
	<input type="hidden" name="borderwidth" id="borderwidth" value="#url.borderwidth#">
	<input type="hidden" name="fillpercentage" id="fillpercentage" value="#url.fillPercentage#">
	<input type="hidden" name="opacity" id="opacity" value="#url.opacity#">
	<input type="hidden" name="showstrap" id="showstrap" value="#url.showstrap#">
	<input type="hidden" name="showfillmark" id="showfillmark" value="#url.showfillmark#">
	<input type="hidden" name="strapcolor" id="strapcolor" value="#url.strapcolor#">
	<input type="hidden" name="strapwidth" id="strapwidth" value="#url.strapwidth#">
	<input type="hidden" name="strapfillpercentage" id="strapfillpercentage" value="#url.strapfillpercentage#">
	<input type="hidden" name="strapicon" id="strapicon" value="#SESSION.root#/Images/#url.strapicon#">
	<input type="hidden" name="fillicon" id="fillicon" value="#SESSION.root#/Images/#url.fillicon#">
	<input type="hidden" name="iconsize" id="iconsize" value="#url.iconsize#">
	<input type="hidden" name="straptext1" id="straptext1" value="#url.straptext1#">
	<input type="hidden" name="straptext2" id="straptext2" value="#url.straptext2#">
	<input type="hidden" name="filltext1" id="filltext1" value="#url.fillText1#">
	<input type="hidden" name="filltext2" id="filltext2" value="#url.fillText2#">
	<input type="hidden" name="textsize" id="textsize" value="#url.textsize#">
	<input type="hidden" name="textcolor" id="textcolor" value="#url.textcolor#">
	<input type="hidden" name="pipeimage" id="pipeimage" value="#SESSION.root#/Images/#url.pipeimage#">
	<input type="hidden" name="pipesize" id="pipesize" value="#url.pipesize#">
	<input type="hidden" name="showsublevel" id="showsublevel" value="#url.showSublevel#">
	<input type="hidden" name="sublevelpercentage" id="sublevelpercentage" value="#url.sublevelPercentage#">
	<input type="hidden" name="subleveltext1" id="subleveltext1" value="#url.sublevelText1#">
	<input type="hidden" name="subleveltext2" id="subleveltext2" value="#url.sublevelText2#">
	<input type="hidden" name="showminimumlevel" id="showminimumlevel" value="#url.showminimumlevel#">
	<input type="hidden" name="minimumlevelpercentage" id="minimumlevelpercentage" value="#url.minimumlevelpercentage#">
	<input type="hidden" name="minimumleveltext1" id="minimumleveltext1" value="#url.minimumleveltext1#">
	<input type="hidden" name="minimumleveltext2" id="minimumleveltext2" value="#url.minimumleveltext2#">
	<input type="hidden" name="showullage" id="showullage" value="#url.showullage#">
	<input type="hidden" name="ullagetext1" id="ullagetext1" value="#url.ullagetext1#">
	<input type="hidden" name="ullagetext2" id="ullagetext2" value="#url.ullagetext2#">
	
	<cfset vWid = url.width + 3*url.borderwidth>
	<cfset vHei = url.height + 2*url.pipesize>
	
	<input type="hidden" name="wWidth" id="wWidth" value="#vWid#">
	
	<cfif url.showtooltip eq 1>
		<cf_UIToolTip sourcefortooltip="#url.tooltip#">
			<div align="center" id="graphcontainer" style="width:#2*vWid#; height:#vHei#;"></div>
		</cf_UIToolTip>
	<cfelse>
		<div align="center" id="graphcontainer" style="width:#2*vWid#; height:#vHei#;"></div>
	</cfif>
		
</body>
</cfoutput>