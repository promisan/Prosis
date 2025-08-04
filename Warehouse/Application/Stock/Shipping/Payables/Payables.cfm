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

<!--- 11/11/2011
1. This for the mode that the entity is charged for the issuances which are done by a warehouse on hehalf of the main entity ; 
2. so called EFMS outsourced mode as opposed to billing for tasked bulk deliveries 
--->

<cfset class = "warehouse">  <!--- will have to be set to [Issue] next week --->
	
<cfquery name= "getWarehouse" 
	datasource   = "AppsMaterials" 
	username     = "#SESSION.login#" 
	password     = "#SESSION.dbpw#">
	SELECT * 
	FROM   Warehouse 
	WHERE  Warehouse = '#url.warehouse#'
</cfquery>	
		  		  
<cfdiv style="height:100%" 
     bind="url:#SESSION.root#/Procurement/Application/Invoice/InvoiceView/InvoiceViewListing.cfm?mission=#url.mission#&missionorgunitid=#getWarehouse.missionOrgUnitId#&id1=SHP&invoiceclass=#class#">	
		
