<cfquery name="delete" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM	Ref_WorkAction
		WHERE 	ActionClass = '#url.id1#'
</cfquery>

<script>
	ColdFusion.navigate('RecordListingDetail.cfm','detail');
</script>