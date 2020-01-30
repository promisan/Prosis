
<cfquery name="Verify" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_TriggerGroup
		WHERE 	TriggerGroup  = '#url.id1#' 
</cfquery>

<cfif verify.recordCount eq 1>

	<cfquery name="Update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE	Ref_TriggerGroup
			SET		Description = '#Form.Description#',
					ReviewerActionCodeOne = <cfif trim(Form.ReviewerActionCodeOne) neq ''>'#Form.ReviewerActionCodeOne#'<cfelse>NULL</cfif>,
					ReviewerActionCodeTwo = <cfif trim(Form.ReviewerActionCodeTwo) neq ''>'#Form.ReviewerActionCodeTwo#'<cfelse>NULL</cfif>
			WHERE 	TriggerGroup  = '#url.id1#' 
	</cfquery>

</cfif>

<script language="JavaScript">
     window.close()
	 opener.history.go()
</script>  
