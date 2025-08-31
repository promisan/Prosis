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
<cfparam name="url.redirect" default="1">

<cfquery name="clear" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	DELETE
	FROM 	ItemWarehouseLocationStrapping
	WHERE 	Warehouse = '#url.warehouse#'
	AND		Location = '#url.location#'
	AND		ItemNo = '#url.itemNo#'
	AND		UoM = '#url.uom#'
</cfquery>

<cfquery name="warehouseLocation" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT 	* 
	FROM 	WarehouseLocation
	WHERE 	Warehouse = '#url.warehouse#'
	AND		Location = '#url.location#'
</cfquery>

<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT 	* 
	FROM 	ItemWarehouseLocation
	WHERE 	Warehouse = '#url.warehouse#'
	AND		Location = '#url.location#'
	AND		ItemNo = '#url.itemNo#'
	AND		UoM = '#url.uom#'
</cfquery>

<cfloop from="0" to="#get.StrappingScale#" index="measurement" step="#get.StrappingIncrement#">

	<cftry>
		
		<cfquery name="insert" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		 		 	  
				 INSERT INTO ItemWarehouseLocationStrapping
				 	(
						Warehouse,
						Location,
						ItemNo,
						UoM,
						Measurement,
						Quantity,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				 VALUES
				 	(
						'#url.warehouse#',
						'#url.location#',
						'#url.itemNo#',
						'#url.uom#',
						#measurement#,
						0,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		
		<cfcatch></cfcatch>
	
	</cftry>

</cfloop>

<cfquery name="Strapping" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ItemWarehouseLocationStrapping
	WHERE 	Warehouse = '#url.warehouse#'
	AND		Location = '#url.location#'
	AND		ItemNo = '#url.itemNo#'
	AND		UoM = '#url.uom#'
</cfquery>

<cfset cntStrap = 1>
<cfloop query="Strapping">
	
	<cfif cntStrap eq Strapping.recordcount>
		<cfquery name="update" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			UPDATE 	ItemWarehouseLocationStrapping
			SET		Quantity = #get.HighestStock#
			WHERE 	Warehouse = '#url.warehouse#'
			AND		Location = '#url.location#'
			AND		ItemNo = '#url.itemNo#'
			AND		UoM = '#url.uom#'
			AND		Measurement = '#Strapping.Measurement#'
		</cfquery>
	</cfif>
	<cfset cntStrap = cntStrap + 1>
</cfloop>


<cfif url.redirect eq 1>
	<cfoutput>
		<script>
			ColdFusion.navigate('../LocationItemStrapping/Strapping.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#','contentbox2');
		</script>
	</cfoutput>
</cfif>