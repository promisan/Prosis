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
<cfset wflink = "Materials/Application/Stock/Inspection/InspectionView.cfm?inspectionid=#url.ajaxid#">
				
<cfquery name="Inspection" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    WarehouseLocationInspection M
	WHERE   InspectionId     = '#url.ajaxid#'	
</cfquery>

<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Warehouse
	WHERE   Warehouse = '#Inspection.Warehouse#'	
</cfquery>
	
<cf_ActionListing 
    EntityCode       = "WhsInspection"
	EntityClass      = "#Inspection.EntityClass#"
	EntityGroup      = "" 
	EntityStatus     = ""
	Mission          = "#Warehouse.Mission#"	
	ObjectReference  = "#Warehouse.WarehouseName#"
	ObjectReference2 = "#Inspection.Reference#"	  
	ObjectKey4       = "#url.ajaxid#"
	Ajaxid           = "#url.ajaxid#"
	Show             = "Yes"
	ToolBar          = "No"
	ObjectURL        = "#wflink#"
	CompleteFirst    = "No"
	CompleteCurrent  = "No">

	



			