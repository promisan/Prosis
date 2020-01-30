
<cfquery name="Verify" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_SlipGroup
		WHERE 	PrintGroup  = '#url.id1#' 
</cfquery>

<cfif verify.recordCount eq 1>

	<cfquery name="Update" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE	Ref_SlipGroup
			SET		Description = '#Form.Description#',
					PrintGroupOrder = '#Form.PrintGroupOrder#',
					NetPayment = '#Form.NetPayment#'
			WHERE 	PrintGroup  = '#url.id1#' 
	</cfquery>

</cfif>

<script language="JavaScript">
     window.close()
	 opener.history.go()
</script>  
