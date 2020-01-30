<cfquery name="delete" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM	Ref_TimeClass
		WHERE 	TimeClass = '#url.id1#'
</cfquery>

<script>
	ColdFusion.navigate('RecordListingDetail.cfm','detail');
</script>