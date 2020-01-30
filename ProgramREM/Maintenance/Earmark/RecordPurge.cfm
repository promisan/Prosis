<cfquery name="delete" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM	Ref_Earmark
		WHERE 	Earmark = '#url.id1#'
</cfquery>

<script>
	ColdFusion.navigate('RecordListingDetail.cfm','detail');
</script>