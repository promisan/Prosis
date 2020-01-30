<cfparam name="url.contributionid" default="">

<cfquery name="qCheck"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Contribution
	WHERE  ContributionId = '#URL.ContributionId#'
</cfquery>

<cfif qCheck.recordcount eq 0>
	<cfinclude template="ContributionSubmitAdd.cfm">
<cfelse>
	<cfinclude template="ContributionSubmitUpdate.cfm">
</cfif>


