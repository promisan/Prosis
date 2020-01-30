
<cf_preventCache>

<cftransaction>

	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ParameterMission
				SET EnableBudget                   = '#Form.EnableBudget#',
					ContributionAutoNumber		   = '#Form.ContributionAutoNumber#',
					ContributionPrefix			   = '#Form.ContributionPrefix#',
					ContributionSerialNo		   = '#Form.ContributionSerialNo#',
					<!---
					BudgetClearanceTriggerByPeriod = '#BudgetClearance#',
					--->
					EnableIndicator                = '#Form.EnableIndicator#',
					EnableDonor                    = '#Form.EnableDonor#',
					EnableEntry                    = '#Form.EnableEntry#',
					EnableGANTT                    = '#Form.EnableGANTT#',
					TextLevel0                     = '#Form.TextLevel0#',
					TextLevel1                     = '#Form.TextLevel1#',
					TextLevel2                     = '#Form.TextLevel2#',
					EnableProjectLevel1            = '#Form.EnableProjectLevel1#',
					OfficerUserId 	 			   = '#SESSION.ACC#',
					OfficerLastName  			   = '#SESSION.LAST#',
					OfficerFirstName 			   = '#SESSION.FIRST#',
					Created          			   =  getdate()					
			WHERE 	Mission                        = '#url.Mission#'
	</cfquery>

</cftransaction>

<cfoutput>
	<script>
		window.location = "ParameterEdit.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#";
	</script>
</cfoutput>