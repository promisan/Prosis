
<cfquery name="WH" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Warehouse
		WHERE  	Operational = 1
		AND		Distribution = 1
</cfquery>

<cfquery name="clear" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM   	Ref_RequestWorkflowWarehouse
		WHERE  	RequestType = '#url.type#'
		AND		RequestAction = '#url.action#'
</cfquery>

<cfloop query="WH">
	<cfif isDefined("Form.wh_#warehouse#")>
		
		<cfquery name="insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_RequestWorkflowWarehouse
					(
						RequestType,
						RequestAction,
						Warehouse,
						Operational,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.type#',
						'#url.action#',
						'#warehouse#',
						1,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
	
	<cfelse>
	
		<cfquery name="delete" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE 
				FROM 	Ref_RequestWorkflowWarehouse
				WHERE  	RequestType = '#url.type#'
				AND		RequestAction = '#url.action#'
				AND		Warehouse = '#warehouse#'
		</cfquery>
			
	</cfif>
</cfloop>