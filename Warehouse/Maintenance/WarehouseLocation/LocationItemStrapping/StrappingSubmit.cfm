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

<cfquery name="getItem" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       ItemWarehouseLocation 
	 WHERE		Warehouse = '#url.warehouse#'
	 AND       	Location = '#url.location#'		
	 AND		ItemNo = '#url.itemNo#'
	 AND		UoM = '#url.UoM#'
</cfquery>

<cfset strapRelation = 0>
<cfif getItem.strappingIncrementMode eq "Capacity">
	<cfset strapRelation = getItem.highestStock>
</cfif>
<cfif getItem.strappingIncrementMode eq "Strapping">
	<cfset strapRelation = getItem.StrappingScale>
</cfif>

<cfloop from="0" to="#strapRelation#" index="measurement" step="#getItem.strappingIncrement#">

	<cfif isDefined("Form.Quantity#measurement#") and isDefined("Form.Measurement#measurement#")>

		<cfset vQuantity = replace(evaluate("Form.Quantity#measurement#"), ',', '', 'ALL')>
		<cfset vMeasurement = replace(evaluate("Form.Measurement#measurement#"), ',', '', 'ALL')>
		
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
							#vMeasurement#,
							#vQuantity#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
		
			<cfcatch></cfcatch>
		</cftry>
	
	</cfif>

</cfloop>

<cfoutput>
	<script>
		ColdFusion.Window.hide('StrappingEdit');
		ColdFusion.navigate('../LocationItemStrapping/Strapping.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#url.ItemNo#&uoM=#url.UoM#&showOpenST=1','contentbox2');		
	</script>
</cfoutput>