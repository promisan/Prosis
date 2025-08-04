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
<cfparam name="URL.Scope"     default="standard"> 
<cfparam name="URL.Mission"   default="">
<cfparam name="URL.Warehouse" default="">

<cf_tl id="Stock Control" var="1">

<cfif url.scope eq "portal">
  
	<cf_screenTop border="0" 
		  height="100%" 
		  label="#lt_text# #URL.Mission#" 
		  html="no"
		  layout="webapp"	
		  banner="blue"	 
		  bannerforce="Yes"
		  jQuery="Yes"
		  validateSession="Yes"
		  busy="busy10.gif"
		  MenuAccess="No"
		  bannerheight="50"		
		  line="no"   
		  band="No" 
		  scroll="yes">
	  
<cfelse>
      
	<cf_screenTop border="0" 
		  height="100%" 
		  label="#lt_text# #URL.Mission#" 
		  html="no"
		  layout="webapp"	
		  banner="blue"
		  validatesession="Yes"
		  bannerforce="Yes"
		  jQuery="Yes"
		  busy="busy10.gif"		  
		  MenuAccess="Yes"
		  bannerheight="50"		
		  line="no"   
		  band="No" 
		  scroll="no">
  
</cfif> 

<cfajaximport tags="cfchart,cfform,cfdiv">
<cf_presentationScript>
	
<cfparam name="client.warehouseselected" default="">

<input type="hidden" name="optionselect" id="optionselect">	
<input type="hidden" name="mission" id="mission" value="<cfoutput>#URL.mission#</cfoutput>"> 

<cfif url.mission eq "">
		
	<cfquery name="Warehouse" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Warehouse
		  WHERE  Warehouse = '#URL.warehouse#' 
	</cfquery>
	
	<cfset url.mission = warehouse.mission>

<cfelse>
		
	<cfquery name="Warehouse" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Warehouse
		  WHERE  Mission = '#URL.Mission#'
	</cfquery>

</cfif>

<cfquery name="Parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfif Warehouse.recordcount eq "0">

	<cf_message message="Problem. No warehouse has been defined for this entity.">
	<cfabort>
	
</cfif>

<cfquery name="Param" 
 datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfinclude template="StockScript.cfm">

<cf_layoutscript>
		
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#" script="No">
	
	<cfif url.scope neq "portal">
	
		<cf_layoutArea size="50" position="header" name="theHeader">	
				
			<cf_tl id="Stock Control" var="1">
			<cf_ViewTopMenu label="#lt_text# #URL.Mission#" background="blue">
			
		</cf_layoutArea>
	
	</cfif>

	<cf_layoutarea position="left" name="leftmenu" maxsize="400" size="320" collapsible="true" splitter="true">
		<cf_divscroll style="width:100%">	
			<cfinclude template="StockMenu.cfm">
		</cf_divscroll>	
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="right">	
				
		<table width="99%" height="100%">			    
			<tr>											
				<td width="100%" height="100%" style="padding:4px;border:0px solid silver" valign="center" id="main" align="center">				   			
					<cfinclude template="../../../../Tools/Treeview/TreeViewInit.cfm">				
				</td>				
			</tr>
		</table>
		
					
	</cf_layoutarea>			
			
</cf_layout>

<cfparam name="client.stmenu" default="">	

<!---
 							
<cfif client.googleMAP eq "1">
			    
		<cftry>
		
			<cfhttp 
			    url     = "http://www.google.com" 
			    timeout = "10">
			</cfhttp>
	 
			<cfif trim(cfhttp.StatusCode) IS "200 OK">
							
				<cfajaximport tags="cfmap" 
				   params="#{googlemapkey='#client.googlemapid#'}#">  			
			   
			</cfif>
			   
		<cfcatch>
		Googlemaps not initialized
		</cfcatch>	   
		
		</cftry>	
			
</cfif> 

--->
