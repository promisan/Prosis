
<cf_preventCache>

<cftransaction>

<cfquery name="Update" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ParameterMission
	SET ProgressTransactional          = '#Form.ProgressTransactional#',
		ProgressCompleted              = '#Form.ProgressCompleted#',
		ProgressApply                  = '#Form.ProgressApply#',
		OfficerUserId 	 			   = '#SESSION.ACC#',
		OfficerLastName  			   = '#SESSION.LAST#',
		OfficerFirstName 			   = '#SESSION.FIRST#',
		ProgressTemplate               = '#form.ProgressTemplate#',
		Created          			   =  getdate(),
		<cfif Form.DefaultProgressPeriod eq "">
	    DefaultProgressPeriod          =  NULL,
		<cfelse>
		DefaultProgressPeriod          = '#Form.DefaultProgressPeriod#',
	    </cfif>
		<cfif isDefined("Form.DefaultPeriodSub")>
		DefaultPeriodSub               = '#Form.DefaultPeriodSub#'
		<cfelse>
		DefaultPeriodSub               = null
		</cfif>
WHERE 	Mission                        = '#url.Mission#'
</cfquery>

</cftransaction>


<cfoutput>
	<script>
		ColdFusion.navigate("ParameterEditProgress.cfm?idmenu=#URL.IDMenu#&mission=#url.Mission#", "contentbox3");
	</script>
</cfoutput>