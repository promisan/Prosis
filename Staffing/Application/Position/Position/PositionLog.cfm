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


<!--- position log --->

<cfquery name="Log" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, (SELECT Description FROM Ref_VacancyActionClass WHERE Code = P.VacancyActionClass) as VacancyActionName
    FROM   PositionLog P
	WHERE  PositionNo = '#URL.PositionNo#'	
	ORDER BY SerialNo DESC
</cfquery>

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr><td height="8"></td></tr>
<tr class="line labelmedium fixlengthlist">
	<td><cf_tl id="Effective"></td>
	<td><cf_tl id="Expiration"></td>
	<td><cf_tl id="Location"></td>
	<td><cf_tl id="Title"></td>
	<td><cf_tl id="Class"></td>
	<td><cf_tl id="Type"></td>
	<td><cf_tl id="Grade"></td>
	<td><cf_tl id="Vacancy"></td>
	<td><cf_tl id="Authorised"></td>
	<td><cf_tl id="Overwrite Loan"></td>
	<td><cf_tl id="Officer"></td>
	<td><cf_tl id="Timestamp"></td>
</tr>

<cfif Log.recordcount eq "0">

<tr><td colspan="11" class="labelmedium" style="height:40" align="center"><font color="808080">There are no records to be shown in this view</font></td></tr>

</cfif>

<cfoutput query="Log">

<tr class="navigation_row line labelmedium fixlengthlist">
	<td style="padding-left:2px">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
	<td>#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
	<td>#LocationCode#</td>
	<td>#FunctionDescription#</td>
	<td>#PostClass#</td>
	<td>#PostType#</td>
	<td>#PostGrade#</td>
	<td>#VacancyActionName#</td>
	<td><cfif PostAuthorised eq "1">Yes<cfelse>No</cfif></td>
	<td><cfif DisableLoan eq "1">Yes<cfelse></cfif></td>
	<td>#OfficerLastName#</td>
	<td>#dateformat(Created,CLIENT.DateFormatShow)# #timeformat(Created,"HH:MM")#</td>
</tr>

</cfoutput>

</table>

<cfset ajaxOnLoad("doHighlight")>