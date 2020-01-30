
<!--- ItemWarehouseLocationTransaction --->

<cfquery name="types" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM   	Ref_TransactionType
	WHERE   TransactionType NOT IN ('1','7')
</cfquery>
	
<cfloop query="types">
		
	<cfquery name="insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO ItemWarehouseLocationTransaction (
					Warehouse,
					Location,
					ItemNo,
					UoM,
					TransactionType,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName )
			VALUES (
				'#url.warehouse#',
				'#url.location#',
				'#url.itemno#',
				'#url.uom#',
				'#TransactionType#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
			)
	</cfquery>

</cfloop>