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

<cfparam name="url.showPrint" default="0">
<cfparam name="url.divToGet" default="0">

<cfquery name="wl" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	WL.*,
				W.Mission,
				W.WarehouseName
		FROM	Warehouse W
				INNER JOIN WarehouseLocation WL
					ON WL.Warehouse = W.Warehouse 
		WHERE	WL.Warehouse = '#url.warehouse#'
		<cfif url.location neq "">
		AND		WL.Location = '#url.location#'
		</cfif>
</cfquery>

<!--- -------------------------------------------------------------------------------------- --->
<!--- temp measurement Hanno, 21/7/2012 this prevented an early print which was not complete --->
      <cf_screentop html="no" margin="4" height="95%" scroll="yes">
<!--- -------------------------------------------------------------------------------------- --->

	<cf_PrintTemplate 
		docType = ""
		meta = "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
		stylesheet = "Portal/Logon/BlueGreen/pkdb.css">
		
			<!--- dotted border to each group of data for the print --->
			<style>
				table.clsPrintable {
					border:1px dotted #C0C0C0;
					font-size:10px;
					height:100%;
					vertical-align:text-top;
				}
			</style>
		
			<div style="text-align:center;">
				<cfoutput>
				
					<div align="center" class="labellarge"><font size="2">#wl.mission#:</font><font size="6"> #wl.warehouseName#</div>
					<div align="center" class="labellarge" style="font-size:17px; font-weight:bold;"><cfif url.location eq ""><font size="2" color="808080">[All Locations]</font><cfelse>[#wl.location#] #wl.Description#</cfif></div>
					
					 <cf_getWarehouseTime warehouse="#url.warehouse#">
					 									
					<div align="center" style="font-size:13px;">#dateFormat(localtime,'#CLIENT.DateFormatShow#')# - #timeFormat(localtime,'hh:mm:ss tt')# <font size="2">(GMT #timezone#) </div>
					
					<div style="padding-top:9px;border-bottom:1px solid black"></div>
					
				</cfoutput>
				
				<br>
				<div align="center" id="pdfToPrint" style="width:95%">
				
					<cfset url.showPrint = "0">				
					<cfinclude template="../../Maintenance/Warehouse/Statistics/WarehouseStatistics.cfm">
				
				</div>	
			</div>
	
	 </cf_PrintTemplate>
	 
<cf_screenbottom layout="webapp">	 
	 
	 	
 