<cfquery name="delete" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM	Ref_ContributionClass
		WHERE 	Code = '#url.id1#'
</cfquery>

<script>
	ColdFusion.navigate('RecordListingDetail.cfm','detail');
</script>