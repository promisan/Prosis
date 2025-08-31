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
<cfparam name="Attributes.type"                 	default="circle">
<cfparam name="Attributes.width"                 	default="100">
<cfparam name="Attributes.height"                	default="100">
<cfparam name="Attributes.radius"                	default="100">
<cfparam name="Attributes.radiusHorizontal"      	default="150">
<cfparam name="Attributes.color1"                	default="223FA3">
<cfparam name="Attributes.color2"                	default="000">
<cfparam name="Attributes.backgroundcolor"       	default="transparent">
<cfparam name="Attributes.borderwidth"           	default="1">
<cfparam name="Attributes.bordercolor"           	default="000">
<cfparam name="Attributes.fillPercentage"        	default="1">
<cfparam name="Attributes.showtooltip"           	default="1">
<cfparam name="Attributes.tooltip"               	default="">
<cfparam name="Attributes.opacity"              	default="1">
<cfparam name="Attributes.showstrap"             	default="1">
<cfparam name="Attributes.showfillmark"          	default="1">
<cfparam name="Attributes.strapcolor"            	default="000">
<cfparam name="Attributes.strapwidth"            	default="1">
<cfparam name="Attributes.strapfillpercentage"   	default="1">
<cfparam name="Attributes.strapicon"             	default="left.png">
<cfparam name="Attributes.fillicon"              	default="right.png">
<cfparam name="Attributes.iconsize"              	default="20">
<cfparam name="Attributes.straptext1"            	default="">
<cfparam name="Attributes.straptext2"            	default="">
<cfparam name="Attributes.fillText1"             	default="">
<cfparam name="Attributes.fillText2"             	default="">
<cfparam name="Attributes.textsize"              	default="10">
<cfparam name="Attributes.textcolor"             	default="000">
<cfparam name="Attributes.pipesize"              	default="50">
<cfparam name="Attributes.pipeimage"             	default="pipe-out.png">
<cfparam name="Attributes.showsublevel"          	default="1">
<cfparam name="Attributes.sublevelPercentage"    	default="1">
<cfparam name="Attributes.sublevelText1"         	default="">
<cfparam name="Attributes.sublevelText2"         	default="">
<cfparam name="Attributes.showminimumlevel"         default="1">
<cfparam name="Attributes.minimumlevelPercentage"   default="1">
<cfparam name="Attributes.minimumlevelText1"        default="">
<cfparam name="Attributes.minimumlevelText2"        default="">
<cfparam name="Attributes.showullage"         	 	default="1">
<cfparam name="Attributes.ullagetext1"         	 	default="Ullage:">
<cfparam name="Attributes.ullagetext2"         	 	default="">

<cfoutput>
	
	<cfset vTooltip = URLEncodedFormat("#Attributes.tooltip#")>	
	<cfset vText1 = URLEncodedFormat("#Attributes.straptext1#")>	
	<cfset vText2 = URLEncodedFormat("#Attributes.straptext2#")>
	<cfset vText3 = URLEncodedFormat("#Attributes.fillText1#")>	
	<cfset vText4 = URLEncodedFormat("#Attributes.fillText2#")>
	<cfset vText5 = URLEncodedFormat("#Attributes.sublevelText1#")>
	<cfset vText6 = URLEncodedFormat("#Attributes.sublevelText2#")>
	<cfset vText7 = URLEncodedFormat("#Attributes.minimumlevelText1#")>
	<cfset vText8 = URLEncodedFormat("#Attributes.minimumlevelText2#")>
	<cfset vWid = 0>
	<cfset vHei = 0>
	
	<cfif lcase(Attributes.type) eq "rectangle">
	
		<cfset vWid = Attributes.width + 8*Attributes.borderwidth>
		<cfif Attributes.showullage eq "1">
			<cfif len(Attributes.ullagetext1) gt len(Attributes.ullagetext2)>
				<cfset vWid = vWid + len(Attributes.ullagetext1)*5.5>
			<cfelse>
				<cfset vWid = vWid + len(Attributes.ullagetext2)*5.5>
			</cfif>
		</cfif>
		<cfset vWid = round(vWid)>
		<cfset vHei = Attributes.height + 2*Attributes.pipesize + 8*Attributes.borderwidth>
		
		<cfset link = "#SESSION.root#/Tools/StockTank/graphRectangleTank/iGraphRectangleTank.cfm?width=#Attributes.width#&height=#Attributes.height#&backgroundcolor=#Attributes.backgroundcolor#&color1=#Attributes.color1#&color2=#Attributes.color2#&borderwidth=#Attributes.borderwidth#&bordercolor=#Attributes.bordercolor#&fillPercentage=#Attributes.fillPercentage#&tooltip=#vTooltip#&opacity=#Attributes.opacity#&showstrap=#Attributes.showstrap#&showfillmark=#Attributes.showfillmark#&strapcolor=#Attributes.strapcolor#&strapwidth=#Attributes.strapwidth#&strapfillpercentage=#Attributes.strapfillpercentage#&strapicon=#Attributes.strapicon#&fillicon=#Attributes.fillicon#&iconsize=#Attributes.iconsize#&straptext1=#vText1#&straptext2=#vText2#&fillText1=#vText3#&fillText2=#vText4#&textsize=#Attributes.textsize#&textcolor=#Attributes.textcolor#&pipesize=#Attributes.pipesize#&pipeimage=#Attributes.pipeimage#&showsublevel=#Attributes.showsublevel#&sublevelPercentage=#Attributes.sublevelPercentage#&sublevelText1=#vText5#&sublevelText2=#vText6#&showminimumlevel=#Attributes.showminimumlevel#&minimumlevelPercentage=#Attributes.minimumlevelPercentage#&minimumlevelText1=#vText7#&minimumlevelText2=#vText8#&showullage=#Attributes.showullage#&ullagetext1=#Attributes.ullagetext1#&ullagetext2=#Attributes.ullagetext2#&showtooltip=#Attributes.showtooltip#">
		
	<cfelseif lcase(Attributes.type) eq "ellipse">
		
		<cfset vWid = Attributes.radiusHorizontal + 8*Attributes.borderwidth>
		<cfif Attributes.showullage eq "1">
			<cfif len(Attributes.ullagetext1) gt len(Attributes.ullagetext2)>
				<cfset vWid = vWid + len(Attributes.ullagetext1)*8.5>
			<cfelse>
				<cfset vWid = vWid + len(Attributes.ullagetext2)*8.5>
			</cfif>
		</cfif>
		<cfset vWid = round(vWid)>
		
		<cfset vHei = Attributes.radius + 2*Attributes.pipesize + 8*Attributes.borderwidth>
		
		<cfset link = "#SESSION.root#/Tools/StockTank/graphEllipseTank/iGraphEllipseTank.cfm?radius=#Attributes.radius/2#&radius2=#Attributes.radiusHorizontal/2#&wid=#vWid#&hei=#vHei#&color1=#Attributes.color1#&color2=#Attributes.color2#&backgroundcolor=#Attributes.backgroundcolor#&borderwidth=#Attributes.borderwidth#&bordercolor=#Attributes.bordercolor#&fillPercentage=#Attributes.fillPercentage#&tooltip=#vTooltip#&opacity=#Attributes.opacity#&showstrap=#Attributes.showstrap#&showfillmark=#Attributes.showfillmark#&strapcolor=#Attributes.strapcolor#&strapwidth=#Attributes.strapwidth#&strapfillpercentage=#Attributes.strapfillpercentage#&strapicon=#Attributes.strapicon#&fillicon=#Attributes.fillicon#&iconsize=#Attributes.iconsize#&straptext1=#vText1#&straptext2=#vText2#&fillText1=#vText3#&fillText2=#vText4#&textsize=#Attributes.textsize#&textcolor=#Attributes.textcolor#&pipesize=#Attributes.pipesize#&pipeimage=#Attributes.pipeimage#&showsublevel=#Attributes.showsublevel#&sublevelPercentage=#Attributes.sublevelPercentage#&sublevelText1=#vText5#&sublevelText2=#vText6#&showminimumlevel=#Attributes.showminimumlevel#&minimumlevelPercentage=#Attributes.minimumlevelPercentage#&minimumlevelText1=#vText7#&minimumlevelText2=#vText8#&showullage=#Attributes.showullage#&ullagetext1=#Attributes.ullagetext1#&ullagetext2=#Attributes.ullagetext2#&showtooltip=#Attributes.showtooltip#">
		
	</cfif>
					
	<iframe src="#link#"
		width="#vWid#" 
		height="#vHei#" 
		marginwidth="0" 
		marginheight="0" 
		frameborder="0" 
		scrolling="No" 
		align="middle" 
		AllowTransparency>
	</iframe>
	
</cfoutput>