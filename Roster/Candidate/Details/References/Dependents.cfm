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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<body leftmargin="0" topmargin="0" rightmargin="0" onLoad="window.focus()">


<!---- Pending Dev --->

<cfset cnt = 0>

<cfquery name="Relatives" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*
    FROM ApplicantRelative A
    WHERE PersonNo = '#URL.ID#'
	ORDER BY Relationship
</cfquery>

<table border="0" bordercolor="silver" cellpadding="0" cellspacing="0" width="100%" align="center">

<!---	
<TR>
    <TD class="top4N">&nbsp;Name</TD>
    <TD colspan="2" class="top4N">Organization</TD>
    <TD class="top4N">Relation</TD>
</TR>
--->

<cfif Relatives.recordcount eq "0">

	<cfset cnt = cnt + 15>
	<tr>
	<td colspan="8" align="center" class="regular"><b><cf_tl id="No records found"></b></td>
	</TR>

</cfif>

<cfoutput query="Relatives">
<cfset cnt = cnt + 15>
<tr>
<td valign="top" class="regular">&nbsp;#RelativeFirstName# #RelativeLastName#</td>
<td colspan="2" valign="top" class="regular">#Organization#</td>
<td valign="top" class="regular">#Relationship#</td>
</tr>
<tr><td colspan="4" bgcolor="silver"></td></tr>

</cfoutput>
</table>

<cfoutput>

	<script language="JavaScript">
	
	{
	frm  = parent.document.getElementById("irelatives");
	he = #cnt#;
	frm.height = he;
	}
	
	</script>

</cfoutput>

</BODY></HTML>
