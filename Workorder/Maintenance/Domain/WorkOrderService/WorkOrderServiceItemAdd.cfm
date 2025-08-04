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
<cfset vScope = ListToArray(url.scope, '|')>
<cfset vServiceDomain = vScope[1]>
<cfset vReference = vScope[2]>

<cfquery name="GetItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemUoM
		WHERE 	ItemUoMId = '#url.ItemUoMId#'
</cfquery>

<cfif getItem.recordCount eq 1>

	<cfquery name="validate" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT 	*
			FROM	WorkOrderServiceItem
			WHERE	ServiceDomain = '#vServiceDomain#'
			AND		Reference = '#vReference#'
			AND		ItemNo = '#GetItem.ItemNo#'
			AND		UoM = '#GetItem.UoM#'
		
	</cfquery>
	
	<cfif validate.recordcount eq 0>

		<cfquery name="insertItem" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
				INSERT INTO WorkOrderServiceItem
					(
						ServiceDomain,
						Reference,
						ItemNo,
						UoM,
						Operational,
						OfficerUserId,
					 	OfficerLastName,
					 	OfficerFirstName
					)
				VALUES
					(
						'#vServiceDomain#',
						'#vReference#',
						'#GetItem.ItemNo#',
						'#GetItem.UoM#',
						1,
						'#SESSION.acc#',
			    	  	'#SESSION.last#',		  
				  	  	'#SESSION.first#'
					)
			
		</cfquery>
	
	</cfif>

</cfif>

<cfoutput>
	<script>
		ptoken.navigate('WorkOrderService/WorkOrderServiceItem.cfm?id1=#vServiceDomain#&id2=#vReference#','itemContainer');
	</script>
</cfoutput>

