
<cfif url.id neq "">
	
	<cfquery name="Delete" 
	 datasource="appsMaterials">
	 DELETE FROM AssetItemLocation
	 WHERE  MovementId = '#URL.ID#'
	 AND    AssetId = '#URL.ID1#'
	</cfquery>
	
	<cfquery name="Delete" 
	 datasource="appsMaterials">
	 DELETE FROM AssetItemOrganization
	 WHERE  MovementId = '#URL.ID#'
	 AND    AssetId = '#URL.ID1#'
	</cfquery>

</cfif>

<cfquery name="ClearList" 
 datasource="appsQuery">
    DELETE FROM #SESSION.acc#AssetMove#URL.Table#
    WHERE AssetId = '#URL.ID1#'
</cfquery>

<!--- open screen again --->

<cfset url.movementid = url.id>
<cfinclude template="MovementItems.cfm">
