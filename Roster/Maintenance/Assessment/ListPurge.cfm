
<cfquery name="Delete" 
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_Assessment
		 WHERE AssessmentCategory = '#URL.Code#'
		 AND SkillCode = '#URL.skillcode#'
		 AND Owner = '#URL.Owner#'
</cfquery>

<cfset url.id2 = "">
<cfinclude template="List.cfm">

<cfoutput>
	<script>
		ColdFusion.navigate('RecordListingDelete.cfm?code=#url.code#','del_#url.code#')
	</script>
</cfoutput>

