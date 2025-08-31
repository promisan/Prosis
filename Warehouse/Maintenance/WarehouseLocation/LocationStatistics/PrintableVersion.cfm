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

<div align="center" style="height:700px;overflow-y:scroll;">

	<cf_PrintTemplate 
		docType = ""
		meta = "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
		stylesheet = "Portal/Logon/BlueGreen/pkdb.css"
		bodyOnLoad = "document.getElementById('containerToPrint').innerHTML = window.opener.document.getElementById('#url.divToGet#').innerHTML;">
		
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
				<div align="center" style="font-size:22px; font-weight:bold;">#wl.mission# #wl.warehouseName#</div>
				<div align="center" style="font-size:15px; font-weight:bold;"><cfif url.location eq "">[All Locations]<cfelse>[#wl.location#] #wl.Description#</cfif></div>
				<div align="center" style="font-size:12px; font-weight:bold;">#dateFormat(now(),'#CLIENT.DateFormatShow#')# - #timeFormat(now(),'hh:mm:ss tt')#</div>
				</cfoutput>
				<br>
				<div align="center" id="containerToPrint" style="width:95%"></div>	
			</div>
	
	 </cf_PrintTemplate>
	 
</div>
 