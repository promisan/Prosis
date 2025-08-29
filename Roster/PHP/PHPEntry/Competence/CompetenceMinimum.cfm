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
<cfquery name="Competence" 
datasource="AppsSelection" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
SELECT A.Created as LastUpdated, R.*
FROM ApplicantSubmission S, ApplicantCompetence A, Ref_Competence R
WHERE A.CompetenceId = R.CompetenceId
 AND S.ApplicantNo = A.ApplicantNo
 AND S.PersonNo = '#URL.ID1#'
 ORDER BY CompetenceCategory, ListingOrder
</cfquery>

<cfif #Competence.recordcount# lt "#CheckMinimum.MinimumRecords#">
	<cfoutput><tr><td height="16"><font color="FF0000"><b>&nbsp;-&nbsp;</b>You must at least enter <b>#CheckMinimum.MinimumRecords#</b> #Code# records.</font></td></tr></cfoutput>
	<cfset st = 0>
</cfif>
