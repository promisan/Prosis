<cf_tl id = "This program is already associated." var = "msg">

<cfquery name="validate" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM 	WarehouseProgram
		WHERE 	Warehouse   = '#form.warehouse#'
		AND 	ProgramCode = '#form.programCode#'
</cfquery>

<cfif form.programCodeOld eq "">

	<cfif validate.recordCount eq 0>
	
		<cfquery name="insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO WarehouseProgram (
					Warehouse,
					ProgramCode,
					Operational,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName )
			VALUES (
					'#Form.Warehouse#',
					'#Form.ProgramCode#',
					#Form.Operational#,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#' )
		</cfquery>
		
		<cfoutput>
			<script>
			    _cf_loadingtexthtml='';	
				parent.ProsisUI.closeWindow('mydialog'); 
				parent.ptoken.navigate('Program/ProgramListing.cfm?warehouse=#form.warehouse#','contentbox2'); 
			</script>
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
			<script>
				alert('#msg#');
			</script>
		</cfoutput>
	
	</cfif>	

<cfelse>

	<cfif validate.recordCount gt 0>
	
		<cfquery name="update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE WarehouseProgram
			SET
				Operational = #Form.Operational#
			WHERE
				ProgramCode = '#Form.ProgramCodeOld#'
		</cfquery>
		
		<cfoutput>
			<script>
			    _cf_loadingtexthtml='';	
				parent.ProsisUI.closeWindow('mydialog'); 
				parent.ptoken.navigate('Program/ProgramListing.cfm?warehouse=#form.warehouse#','contentbox2'); 
			</script>
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
			<script>
				alert('#msg#');
			</script>
		</cfoutput>
	
	</cfif>

</cfif>