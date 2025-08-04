<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.mission" default="">
<cfparam name="url.country" default="">
<cfparam name="url.map"   default="true">


<cfajaximport tags="cfmap,cfwindow,cfdiv,cfform,cfchart,cfinput-datefield" params="#{googlemapkey='#client.googlemapid#'}#">
 
<cfoutput>

	<script language="JavaScript">	  

	function printme() {
		printWin = window.open("RateInquiryCenter.cfm?country="+document.getElementById('ctry').value+"&print=1&map="+document.getElementById('map').checked,"_blank","left=20, top=20, width=800, height=800, status=yes, toolbar=yes, scrollbars=yes, resizable=yes");	  
		setTimeout('printWin.print()', 2000);
	}
	    
	function countrytoggle (val) {
		ColdFusion.navigate("RateInquiryCenter.cfm?country="+val+"&map="+document.getElementById('map').checked,"center")
	}
	
	function doIt () {
		ColdFusion.navigate("RateInquiryCenter.cfm?country="+document.getElementById('ctry').value+"&map="+document.getElementById('map').checked,"center")
	}
	
	function carrier () {
		foo = document.getElementById('carrier').value;
		if (foo != "") {
		window.open(document.getElementById('carrier').value,'_blank')
		}
	}
	</script>	
</cfoutput>

<cf_screentop height="100%" html="No" scroll="no" jQuery="Yes" busy="busy10.gif">

<cf_LayoutScript>

<cfset attrib = {type="Border",name="RateInquiry",fitToWindow="Yes"}>	

<cf_layout
        type="Border"
        name="RateInquiry"
        attributeCollection="#attrib#">		

	<cf_layoutarea 
          position="left"
          name="left"
          minsize="290"
          maxsize="290"  
		  size="290" 
		  source="RateInquiryLeft.cfm"    
		  collapsible= "true"   
          splitter="true"
		  overflow="auto"
		  togglerOpenIcon = "leftarrowgray.png"
		  togglerCloseIcon = "rightarrowgray.png"/>
	
	<cf_layoutarea 
          position="center"
          name="centerbox"         
		  overflow = "auto">	
		  
		     <table width="100%" align="center">
			<tr><td id="center" align="center">
			 <cfinclude template="RateInquiryCenter.cfm">			
			</td></tr>
			</table>   		 	  
		 		 		  
	</cf_layoutarea>		
	 
</cf_layout>


