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
<cf_tl id="Workorder Finished Product Management" var="1">

<cf_screenTop height="100%" 
     title="#lt_text#  #URL.Mission#" 
     option="Record Shipment" 
	 border="0" 
     html="No" 
	 scroll="No" 
	 menuAccess="Yes" 
	 systemfunctionid="#url.idmenu#" 
	 jquery="Yes" 
	 validateSession="Yes">
   
<cfoutput>

<script language="JavaScript">

function clearrows(field, fieldNum) {
	  for (i = 1; i <= fieldNum; i++)	
	  document.getElementById(field+i).style.fontWeight='normal'
 }

function refreshTree() {
	 location.reload();
}

function reloadForm(per) { 
	 ColdFusion.navigate('ShipmentViewTree.cfm?mission=#URL.Mission#','treebox')
	 // &period='+per,'treebox')
}

function newshipment() {
    right.location = "../ShipmentEntry/LocateWorkOrderView.cfm?Mission=#URL.Mission#
	// &Period="+window.receipt.PeriodSelect.value
}

</script>

<cf_layoutScript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	 
<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	      type      = "Border"
          position  = "header"
          name      = "controltop">	
		 		 
		 <cfinclude template="ShippingMenu.cfm">
		 		 
	</cf_layoutarea>		 

	<cf_layoutarea 
          type        = "Border"
          position    = "left"
          name        = "treebox"
          size        = "270"
          collapsible = "true"
          splitter    = "true"
		  state       = "open"
          maxsize     = "400">
	
	    <cfinclude template="ShippingViewTree.cfm">
			
	</cf_layoutarea>

	<cf_layoutarea  type="Border" position="center" name="box" overflow="hidden" style="height:100%">

		<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
	        name="right"
    	    id="right"
        	width="100%"
	        height="100%"
    	    align="middle"
        	scrolling="no"
	        frameborder="0"></iframe>
							
	</cf_layoutarea>			
		
</cf_layout>		
		
</cfoutput>

