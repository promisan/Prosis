
<cfquery name="Warehouse" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM 	Warehouse
	WHERE 	Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT	P.*
	FROM	Program P 
	WHERE	P.Mission      = '#Warehouse.Mission#'
	AND		P.ProgramClass != 'Program'
</cfquery>

<cfloop query="get">

	<cfif isDefined("Form.prog_#programCode#")>
	
		<cftry>
			<cfquery name="insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO WarehouseProgram (
							Warehouse,
							ProgramCode,
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName ) 
					VALUES ('#url.warehouse#',
							'#ProgramCode#',
							1,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#' )
			</cfquery>
		<cfcatch></cfcatch>
		</cftry>
	
	<cfelse>
	
		<cftry>
			<cfquery name="delete" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE 
					FROM 	WarehouseProgram
					WHERE  	Warehouse = '#url.warehouse#'
					AND		ProgramCode = '#ProgramCode#'
			</cfquery>
		<cfcatch></cfcatch>
		</cftry>
			
	</cfif>
</cfloop>

<cfoutput>
	<script>
		parent.ProsisUI.closeWindow('mydialog'); 
		_cf_loadingtexthtml='';	
		parent.ptoken.navigate('Program/ProgramListing.cfm?warehouse=#url.warehouse#','contentbox2'); 
	</script>
</cfoutput>