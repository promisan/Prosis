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

<cfquery name="GetCategories" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT 
				WC.Category,
				R.Description, 
				R.TabOrder
		FROM	WarehouseCategory WC 
				INNER JOIN Warehouse W 
					ON WC.Warehouse = W.Warehouse 
				INNER JOIN Ref_Category R 
					ON WC.Category = R.Category
		WHERE	W.Mission = '#Form.Mission#'
		AND		R.Operational = 1
		ORDER BY R.TabOrder
</cfquery>

<cfloop query="GetCategories">
	
	<cfquery name="Update" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE Ref_ShipToModeMission
		 SET	EntityClass      = '#Evaluate("Form.EntityClass_#GetCategories.category#")#',
		 		ShipmentTemplate = <cfif trim(Evaluate("Form.ShipmentTemplate_#GetCategories.category#")) neq "">'#Evaluate("Form.ShipmentTemplate_#GetCategories.category#")#'<cfelse>null</cfif>,
				ModeShipmentEntry = '<cfif isDefined("Form.ModeShipmentEntry_#GetCategories.category#")>1<cfelse>0</cfif>'
		 WHERE 	Code   		     = '#Form.Code#'
		 AND	Mission          = '#Form.Mission#'
		 AND	Category		 = '#GetCategories.category#'
	</cfquery>
	
</cfloop>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                 action="Update" 
					 content="#Form#">

<cfoutput>
	<script>   
		ColdFusion.navigate('MissionListing.cfm?idmenu=#url.idmenu#&ID1=#Form.Code#', 'divMissions');
		ColdFusion.Window.hide('mydialog');
	</script>
</cfoutput>
	  
	
