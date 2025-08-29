<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
					CASE WHEN E.ActionStatus = '1' THEN 'Completed' ELSE 'Pending' END as ActionStatusName,
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
		AND         E.Operational = 1
	
</cfquery>

<table width="100%" height="100%">
	<tr>
		<td valign="top">
			<cfinclude template="EventListingContent.cfm">
		</td>
	</tr>
</table>




