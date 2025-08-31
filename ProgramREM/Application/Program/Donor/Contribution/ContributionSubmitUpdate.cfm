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

