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

<cfparam name="url.idmenu" default="">
<cfparam name="url.systemfunctionid" default="#url.idmenu#">

<cf_screenTop height="100%"              
	  html="No" 	
	  ValidateSession="Yes"
	  title="Stock Inquiry"		
	  MenuAccess="Yes"  
	  banner="gray"
	  border="0"
	  JQuery="yes">		
			  
<cf_informationscript>
<cf_listingscript>

<cfif client.googleMAP eq "1">
	<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">
</cfif>	
	 			  
<cf_layoutscript>		  	
		
<cfoutput>

<!--- warehouse view --->

<script language="JavaScript">

    function showstatus(mis) {
	     ColdFusion.navigate('WarehouseViewData.cfm?idmenu=#url.idmenu#&mission='+mis,'main')	
	}

	function showdetails(mis) {	    
	     ht = document.body.clientHeight - 67;		 
		 wt = document.body.clientWidth  - 179;
		 itm  = document.getElementById('itemnoselect').value;				 
		 uom  = document.getElementById('uomselect').value;				
		 mde  = document.getElementById('viewmode').value;		
			
		 if (uom != "") {
	     ColdFusion.navigate('WarehouseViewDetail.cfm?mode='+mde+'&mission='+mis+'+&itemno='+itm+'&uom='+uom+'&height='+ht+'&width='+wt,'main')
		 }
	}
	
	function showstock(mis) {
	   ColdFusion.navigate('WarehouseViewList.cfm?idmenu=#url.idmenu#&mission='+mis,'main')		
	}
	
	function showlisting(mis) {
	     ht = document.body.clientHeight - 73
		 wt = document.body.clientWidth  - 165
	     ColdFusion.navigate('WarehouseViewItem.cfm?mission='+mis,'item')
	}
	
	function warehouse(mis,whs) {			
	  	w = #CLIENT.width# - 60;
	  	h = #CLIENT.height# - 130;
 	  	ptoken.open("#SESSION.root#/Warehouse/Application/Stock/StockControl/StockView.cfm?mission="+mis+"&systemfunctionid=99999999-9999-9999-9999-999999999999&warehouse=" + whs,  "stc"+whs, "left=10, top=10, width=" + w + ", height= " + h + ", menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");		
	}
	
	function itemlocation(id) {
	  	w = #CLIENT.width# - 60;
	  	h = #CLIENT.height# - 130;
 	  	window.open("#SESSION.root#/Warehouse/Maintenance/WarehouseLocation/LocationItemUoM/ItemUoMEdit.cfm?drillid="+id,  "itemlocation", "left=10, top=10, width=" + w + ", height= " + h + ", menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes");			
	}
	
	function menuselect(opt) { 
	      var count=0;
		  var se  = document.getElementsByName('opt')	  	
		  while (se[count]) {    
		    se[count].className = "menuregular" 
		    count++;
		  }	
	      opt.className = "menuselected"	    
	 }
	
</script>

<style>

	tr.menuregular {
		background-color:transparent;
		height:18px;
		cursor:pointer;
	}
	
	tr.menuselected {
		background-color:##f8eebb;
		height:18px;
		cursor:pointer;
	}	

</style>
</cfoutput>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop">	
			
		<cf_tl id="Management Summary" var="1">
		
		<cfsavecontent variable="option">
		<cfquery name="MissionList" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT DISTINCT Mission 
			      FROM   Warehouse				  		 
		</cfquery>
		
		<select name="warehouse" id="warehouse" class="regularxl"        
        onChange="javascript:showlisting(this.value)">
				<cfoutput query="MissionList">
				<option value="#Mission#">#Mission#</option>
				</cfoutput>
		</select>	
		
		</cfsavecontent>		
		
		<cf_ViewTopMenu label="#lt_text#&nbsp;#option#" background="linesBlue">				
			 			  
	</cf_layoutarea>		
	  
	<cf_layoutarea 
	    position    = "left" 
		name        = "treebox" 
		maxsize     = "370" 		
		size        = "280" 
		minsize     = "280" 
		collapsible = "true" 
		splitter    = "true">
		
		<cfset url.mission = MissionList.Mission>	
				
		<table cellspacing="0" cellpadding="0" width="100%" height="100%" style="padding:0px;border:0px solid silver">
					
			<tr><td id="item" width="100%" height="100%" valign="top" bgcolor="white" valign="top">
			
			<cf_divscroll>
											
			<cfset url.mission = MissionList.Mission>		
			<cfinclude template="WarehouseViewItem.cfm">
			
			</cf_divscroll>
								
			</td></tr>	
						
		</table>	
	
	</cf_layoutarea>
	
	<cf_layoutarea position="center" name="box">
	
	  <table cellspacing="0" cellpadding="0" width="100%" height="100%" style="padding:4px;border:0px solid silver">
					
			<tr><td width="100%" height="100%" align="center" valign="middle" bgcolor="FFFFFF" id="main">
				
		         <cfinclude template="WarehouseViewList.cfm">	
							
			</td></tr>	
						
		</table>	
					
	</cf_layoutarea>			
		
</cf_layout>

<cf_screenbottom html="No" layout="Innerbox">
