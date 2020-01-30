<cfquery name="Delete" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

			DELETE FROM Ref_ClaimTypeMission
			WHERE ClaimType = '#URL.ID1#'
			AND Mission = '#URL.Mission#'
</cfquery>

<cfset url.action = "view">
<cfinclude template="RecordMissionListingDetail.cfm">