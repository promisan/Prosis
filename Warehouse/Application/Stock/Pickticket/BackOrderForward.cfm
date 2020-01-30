<cfquery name="Update" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Request
		SET Warehouse = '#URL.Warehouse#', Status = '2'
		
		WHERE RequestId = '#URL.RequestId#'		
</cfquery>

<cfoutput>
<b><font color="0080FF">forwarded</b>
</cfoutput>