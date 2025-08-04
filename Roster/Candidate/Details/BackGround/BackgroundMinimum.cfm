<!--
    Copyright © 2025 Promisan

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

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Parameter
</cfquery>

<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  DISTINCT A.*, S.Source
	FROM   ApplicantSubmission S, 
	       ApplicantBackground A
	WHERE S.PersonNo = '#URL.ID1#'	
	AND   S.Source IN ('#CLIENT.Submission#','#Parameter.PHPSource#','Manual')	   
	AND   S.ApplicantNo = A.ApplicantNo
	AND   A.Status IN ('0','1')
	AND   A.ExperienceCategory = '#Code#'
</cfquery>

<cfif Detail.recordcount lt "#CheckMinimum.MinimumRecords#">
	<cfoutput><tr><td height="16"><font color="FF0000"><b>&nbsp;-&nbsp;</b><cf_tl id="You must at least enter"> <b>#CheckMinimum.MinimumRecords#</b> #Code# records.</font></td></tr></cfoutput>
	<cfset st = 0>
</cfif>
