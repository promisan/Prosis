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
<cfquery name="Claim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Claim
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>

<table width="98%" height="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="10"></td></tr>

<tr>
	<td valign="top" align="center">

	<cfoutput>
	
	<iframe src="../../../../Staffing/Application/Employee/Dependents/EmployeeDependent.cfm?action=claim&id=#claim.personno#" width="98%" height="98%" scrolling="no" frameborder="0"></iframe>
	</cfoutput> 

	</td>
</tr>

</table>