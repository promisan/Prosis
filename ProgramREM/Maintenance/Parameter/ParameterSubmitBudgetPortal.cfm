
<cf_preventCache>

<cftransaction>

	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ParameterMission
				SET BudgetPortalPeriod             = '#Form.BudgetPortalPeriod#',
					BudgetPortalEdition            = '#Form.BudgetPortalEdition#',
					BudgetPortalMode               = '#Form.BudgetPortalMode#',
					BudgetAllotmentVerbose         = '#Form.BudgetAllotmentVerbose#',
					OfficerUserId 	 			   = '#SESSION.ACC#',
					OfficerLastName  			   = '#SESSION.LAST#',
					OfficerFirstName 			   = '#SESSION.FIRST#',
					Created          			   =  getdate()					
			WHERE 	Mission                        = '#url.Mission#'
	</cfquery>

</cftransaction>


<cfoutput>
	<script>
		ptoken.navigate("ParameterBudgetMenu.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#&selected=3", "contentbox5");
	</script>
</cfoutput>