
<cfquery name="qContributionDelete" 
	datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		UPDATE Contribution
		SET    ActionStatus = '9'
		WHERE  ContributionId = '#URL.ContributionId#'
</cfquery>

<script>

	window.close();
	opener.parent.right.history.go();
	
</script>