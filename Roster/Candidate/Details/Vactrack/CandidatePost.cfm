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

<cfinclude template="../../../../Vactrack/Application/Document/Dialog.cfm">

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM DocumentCandidate VC, Document V
	WHERE VC.PersonNo = '#URL.ID#' 
	AND V.DocumentNo = VC.DocumentNo
	<cfif URL.Topic eq "selected">
	AND VC.Status IN ('2s','3')
	</cfif>
	ORDER BY VC.Created DESC 
    </cfquery>

<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
 
  <tr>
  <td width="100%" colspan="1" align="center">
  <table border="0" width="100%" class="formpadding">

<TR class="labelmedium2 fixlengthlist line">
	<TD><cf_tl id="Track no"></TD>
    <TD><cf_tl id="Mission"></TD>
	<TD><cf_tl id="Organization unit"></TD>
    <TD><cf_tl id="Functional title"></TD>
	<TD><cf_tl id="Grade"></TD>
</TR>

<cfif searchresult.recordcount eq "0">

	<tr>
	<td colspan="5" align="center" class="regular"><b><cf_tl id="No records found"></b></td>
	</TR>

</cfif>

<cfoutput query="SearchResult">

<tr class="labelmedium2 fixlengthlist line">
<TD>
	<cfif #CLIENT.Submission# eq "Manual">
	<A HREF ="javascript:showdocument('#DocumentNo#')"></cfif>#DocumentNo#</TD>
<TD>#Mission#</TD>
<TD>#OrganizationUnit#</TD>
<TD>#FunctionalTitle#</TD>
<TD>#PostGrade#</TD>
</TR>

</CFOUTPUT>

</TABLE>

</td>
</tr>

</table>
