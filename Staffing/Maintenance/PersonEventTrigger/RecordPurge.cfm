<cfquery name="CountRec" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT EventTrigger
		FROM PersonEvent
		WHERE EventTrigger  = '#url.id1#' 
</cfquery>

<cfif CountRec.recordCount gt 0>

	<script language="JavaScript">	
		alert("Code is in use. Operation aborted.")	
	</script>  

<cfelse>

<cfquery name="Delete" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_EventTrigger
		WHERE Code = '#url.id1#'
</cfquery>

</cfif>

<script language="JavaScript">
	 location.reload()
</script>