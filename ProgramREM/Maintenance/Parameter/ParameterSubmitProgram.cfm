
<cf_preventCache>

<cftransaction>

	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ParameterMission
				SET EnableObjective                = '#Form.EnableObjective#',
				    ObjectiveMode                  = '#Form.ObjectiveMode#',
					EnableJustification            = '#Form.EnableJustification#',
					JustificationMode              = '#Form.JustificationMode#',
					EnableRequirement              = '#Form.EnableRequirement#',
					RequirementMode                = '#Form.RequirementMode#',
					DefaultOpenProgram             = '#Form.DefaultOpenProgram#',
					ProgressMemoEnforce            = '#Form.ProgressMemoEnforce#',
					CarryOverMode                  = '#Form.CarryOverMode#',
					OutputInterface                = '#Form.OutputInterface#',
					OfficerUserId 	 			   = '#SESSION.ACC#',
					OfficerLastName  			   = '#SESSION.LAST#',
					OfficerFirstName 			   = '#SESSION.FIRST#',
					Created          			   =  getdate()					
			WHERE 	Mission                        = '#url.Mission#'
	</cfquery>

</cftransaction>

<cfoutput>
	<script>
		ptoken.navigate("ParameterEditProgram.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#", "contentbox2");
	</script>
</cfoutput>