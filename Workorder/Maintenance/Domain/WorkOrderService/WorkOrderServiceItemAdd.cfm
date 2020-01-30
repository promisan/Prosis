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

