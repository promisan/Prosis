
<cf_preventCache>

<cftransaction>

	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ParameterMission
				SET EnableObjective                = '#Form.EnableObjective#',
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
		ColdFusion.navigate("ParameterEditProgram.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#", "contentbox2");
	</script>
</cfoutput>