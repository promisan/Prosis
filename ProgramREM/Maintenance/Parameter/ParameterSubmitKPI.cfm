
<cf_preventCache>

<cftransaction>

	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ParameterMission
				SET IndicatorAuditWorkflow         = '#Form.IndicatorAuditWorkflow#',
					IndicatorLabelTarget           = '#Form.IndicatorLabelTarget#',
					ProgramColorTarget             = '#Form.ProgramColorTarget#',
					IndicatorLabelManual           = '#Form.IndicatorLabelManual#',
					ProgramColorActual             = '#Form.ProgramColorActual#',
					IndicatorOLAPTemplate          = '#Form.IndicatorOLAPTemplate#',
					OfficerUserId 	 			   = '#SESSION.ACC#',
					OfficerLastName  			   = '#SESSION.LAST#',
					OfficerFirstName 			   = '#SESSION.FIRST#',
					Created          			   =  getdate()					
			WHERE 	Mission                        = '#url.Mission#'
	</cfquery>

</cftransaction>


<cfoutput>
	<script>
		ColdFusion.navigate("ParameterEditKPI.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#", "contentbox5");
	</script>
</cfoutput>