<cfquery name="delete" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE
		FROM 	Ref_ApplicantSection
		WHERE 	Code = '#URL.ID#'
</cfquery>

<script>
     window.close();
	 opener.location.reload();
</script>  