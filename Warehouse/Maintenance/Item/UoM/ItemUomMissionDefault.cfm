
<cfquery name="qUoM" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ItemUoM
	WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<cfloop query="qUoM">

	<cfquery name="qCheck" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemUoMMission
		WHERE 	ItemNo  = '#URL.ID#'
		AND		UoM     = '#qUoM.UoM#'
		AND		Mission = '#Item.Mission#'
	</cfquery>

	<cfif qCheck.recordCount eq 0>
	
		<cfquery name="Insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ItemUoMMission
			      	(
					   ItemNo,
			           UoM,
			           Mission,
					   StandardCost,
			           Operational,
			           OfficerUserId,
			           OfficerLastName,
			           OfficerFirstName
					)
			     VALUES
			        (
					   '#URL.ID#',
			           '#qUoM.UoM#',
					   '#Item.Mission#',
					   0,
					   1,
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#'
				    )
			</cfquery>
			
	</cfif>
	
</cfloop>
