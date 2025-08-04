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
    FROM  stOffer VC, 
	      Document V
	WHERE VC.PersonNo = '#URL.ID#' 
	AND   V.DocumentNo = VC.DocumentNo
	<!--- AND   V.Status != '9' --->
	ORDER BY VC.EntryDate DESC 
    </cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
 
  <tr>
  <td width="100%" colspan="1">
  <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">

<TR>
	<TD><cf_tl id="Track no"></TD>
    <TD><cf_tl id="Mission"></TD>
	<TD><cf_tl id="Function"></TD>
	<TD><cf_tl id="Date"></TD>
    <TD><cf_tl id="Location"></TD>
	<TD><cf_tl id="Recruitment officer"></TD>
	<TD><cf_tl id="Declined"></TD>
</TR>
<tr><td colspan="7" height="1" bgcolor="silver"></td></tr>

<cfif searchresult.recordcount eq "0">

	<tr>
	<td colspan="7" align="center" class="regular"><b><cf_tl id="No records found"></b></td>
	</TR>

</cfif>

<cfoutput query="SearchResult">

<cfif #OfferRejected# eq "1">
<tr bgcolor="FCEEE9">
<cfelse>
<tr bgcolor="ffffff">
</cfif>

<TD>
<cfif #CLIENT.Submission# eq "Manual">
<A HREF ="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">
</cfif>#DocumentNo#</TD>
<TD>#Mission#</TD>
<TD>#FunctionalTitle#</TD>
<TD>#DateFormat(EntryDate,CLIENT.DateFormatShow)#</a></TD>
<TD>#RecruitmentCountry# #RecruitmentCity#</a></TD>
<TD>#EntryFirstName# #EntryLastName#</a></TD>
<td align="center">
<cfif #OfferRejected# eq "1">
<img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0">
</cfif>
</td>
</TR>
</CFOUTPUT>

</TABLE>

</td>

</table>
</BODY></HTML>