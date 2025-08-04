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

<cfquery name="Reference" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*
    FROM ApplicantReferenceExt A
    WHERE PersonNo = '#URL.ID#'
	AND Status < '9'
</cfquery>

<table id="ref" width="99%" border="0" cellspacing="0" cellpadding="0" align="center">

<TR height="20">
    <TD width="30%" class="labelit"><cf_tl id="Name"></TD>
    <TD width="35%" class="labelit"><cf_tl id="Organization"></TD>
    <TD width="15%" class="labelit"><cf_tl id="Telephone"></TD>
    <TD width="20%" class="labelit"><cf_tl id="eMail"></TD>
</TR>

<cfif Reference.recordcount eq "0">

<tr><td colspan="4" height="30" align="center"><b><cf_tl id="No records registered"></td></tr>

<cfelse>

	<cfoutput query="Reference">
	
	<tr><td colspan="4" class="linedotted"></td></tr>	
	<tr>
	<td width="30%" class="labelit">#FirstName# #LastName#</td>
	<td width="35%" class="labelit">#Organization#</td>
	<td width="15%" class="labelit">#TelephoneNo#</td>
	<td width="20%" class="labelit">#eMailAddress#</td>
	</tr>
	
	<tr>
	<td></td>
	<td colspan="3" class="labelit">#Address#</td>
	</tr>
	
	</cfoutput>
	
</cfif>	

</table>
</td>
</tr>



