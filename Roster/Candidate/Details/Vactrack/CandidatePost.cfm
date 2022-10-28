
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
