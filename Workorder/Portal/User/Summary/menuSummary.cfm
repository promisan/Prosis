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
<cfparam name="url.mission" default="OICT">


<cfoutput>

	<script language="JavaScript1.1">
		 	  
	function printme(service, trans) {
	    printWin = window.open("#SESSION.root#/workorder/Portal/User/Summary/SummaryData.cfm?scope=clearance&print=1&serviceitem="+service+'&transtype='+trans,"_blank","left=20, top=20, width=800, height=800, status=yes, toolbar=yes, scrollbars=yes, resizable=yes");
	    setTimeout('printWin.print()', 2000);
	  }		

	function DataDrill(obj,sitm, objy) {
	    ColdFusion.navigate('SummaryDataDetail.cfm?width=#url.width#&height=#url.height#&serviceItem='+sitm+'&transtype='+obj.value+'&yearstart='+objy.value,'container1')
	}
	
	function ChartData (sitm,swidth, syear) {
	    ColdFusion.navigate('SummaryChartData.cfm?width='+swidth+'&serviceItem='+sitm+'&year='+syear.value,'chartcontainer')
		
      }
	  
	</script>
	
</cfoutput>

<cf_screentop height="100%" html="No" scroll="no" jQuery="Yes" busy="busy10.gif">

<cf_LayoutScript>
<cfajaximport tags="cfdiv,cfchart">

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">		

     <cf_layoutarea 
          position="left"
          name="left"  
		  minsize="14%"
          maxsize="14%"  
		  size="14%"  
		  collapsible = "true" 
		  splitter="true"         
		  overflow = "auto"
		  togglerOpenIcon = "leftarrowgray.png"
		  togglerCloseIcon = "rightarrowgray.png">	
		  
		  <cfinclude template="SummaryLeft.cfm">
		  
	</cf_layoutarea>	
	
	<cf_layoutarea 
          position="center"
          name="centerbox"         
		  overflow = "auto"
		  minsize="86%"
          maxsize="86%"  
		  size="86%" 
		  style="border:0px">
			
			<cf_divScroll id="center" height="100%" width="100%" overflowx="auto">
		   		<cfset url.serviceitem = "">
		   		<cfinclude template="SummaryChart.cfm">
			</cf_divScroll>	
		  
	</cf_layoutarea>
			 
</cf_layout>

