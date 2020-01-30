<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">
<cfparam name="URL.TableName" default="#session.acc#_#url.mission#_GeneralLedgerEvents">

<cf_screentop html="no" jQuery="yes">
<cf_listingscript>

<cf_dropTable 
	tblname="#URL.TableName#" 
	dbname="AppsQuery">

<cfquery name="getData" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT     	E.EventId,
					O.OrgUnitCode, 
					E.OrgUnit,
					E.Mission, 
					O.OrgUnitName,
					E.ActionStatus, 
					E.ActionCode, 
					R.Description,
					E.EventDate, 
					E.EventDescription, 
					E.OfficerUserId, 
					E.OfficerLastName, 
					E.OfficerFirstName, 
					E.Created
		INTO		UserQuery.dbo.#URL.TableName#
		FROM        Event AS E 
					INNER JOIN	Ref_Action AS R 
						ON E.ActionCode = R.Code 
					INNER JOIN	Organization.dbo.Organization AS O 
						ON 			E.OrgUnit = O.OrgUnit
		WHERE     	E.Mission       = '#url.mission#'
		AND       	E.AccountPeriod = '#url.Period#'
	
</cfquery>

<table width="100%" height="100%">
	<tr>
		<td valign="top">
			<cfinclude template="EventListingContent.cfm">
		</td>
	</tr>
</table>




