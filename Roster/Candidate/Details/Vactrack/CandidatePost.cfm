
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
  <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">

<TR>
	<TD class="labelit"><cf_tl id="Track no"></TD>
    <TD class="labelit"><cf_tl id="Mission"></TD>
	<TD class="labelit"><cf_tl id="Organization unit"></TD>
    <TD class="labelit"><cf_tl id="Functional title"></TD>
	<TD class="labelit"><cf_tl id="Grade"></TD>
</TR>
<tr><td colspan="5" height="1" class="linedotted"></td></tr>

<cfif searchresult.recordcount eq "0">

	<tr>
	<td colspan="5" align="center" class="regular"><b><cf_tl id="No records found"></b></td>
	</TR>

</cfif>

<cfoutput query="SearchResult">

<tr bgcolor="ffffff">
<TD class="labelit">
	<cfif #CLIENT.Submission# eq "Manual">
	<A HREF ="javascript:showdocument('#DocumentNo#')"><font color="0080C0">
	</cfif>#DocumentNo#</TD>
<TD class="labelit">#Mission#</TD>
<TD class="labelit">#OrganizationUnit#</TD>
<TD class="labelit">#FunctionalTitle#</TD>
<TD class="labelit">#PostGrade#</TD>
</TR>

</CFOUTPUT>

</TABLE>

</td>
</tr>

</table>
