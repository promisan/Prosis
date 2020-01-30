<CF_DateConvert Value="#Form.dateSubmitted#">
<cfset date     = dateValue>

<cftransaction>
	<cfquery name="qContributionAdd" 
	     datasource="AppsProgram" 
		 username="#SESSION.login#"
		 password="#SESSION.dbpw#">
			UPDATE Contribution
			SET    Reference         = '#Form.reference#',
				   Currency          = '#Form.Currency#',
				   Amount            = '#Form.Amount#',
				   PersonNo          = '#Form.PersonNo#',
				   Description       = '#Form.Description#',		   
			       EarMark           = '#Form.Earmark#',
				   ContributionClass = '#Form.ContributionClass#',
			       DateSubmitted     = #date#,
			       Contact           = '#Form.Contact#',
				   ContributionMemo  = '#Form.ContributionMemo#',
				   OrgUnitDonor		 = '#Form.OrgUnit#'
			WHERE  ContributionId    = '#URL.ContributionId#'
	</cfquery>

	<cfinclude template="ContributionCustomFieldsSubmit.cfm">
</cftransaction>

<cfset url.action = "view">
<cfinclude template="ContributionHeader.cfm">

