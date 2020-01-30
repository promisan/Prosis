<!--- Create Criteria string for query from data entered thru search form --->
<HTML>
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>"> 

<cf_PreventCache>

<cfquery name="SearchResult" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  FlowClass
</cfquery>

<HEAD>
</HEAD><body>

<SCRIPT LANGUAGE = "JavaScript">
function reloadForm(filter,page)
{
     window.location="RecordListing.cfm?Page=" + page;
}

function add()
{
          window.open("RecordAdd.cfm", "Add", "left=80, top=80, width= 350, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function edit(id)
{
          window.open("RecordEdit.cfm?ID1=" + id, "Edit", "left=80, top=80, width= 350, height= 200, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</SCRIPT>	

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
   <TD class="bannerXL"><b>&nbsp;Vacancy Type</b>
   </TD>
   <td align="right" class="banner">
  
<CF_DialogHeader 
MailSubject="Vacancy Types" 
MailTo="" 
MailAttachment="" 
ExcelFile=""> 

</td></tr> 	

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
<tr>

<TD bgcolor="#6688AA" height="30">&nbsp;
    <cfinclude template="../../../Tools/PageCount.cfm">
<select name="page" size="1" style="background: #C9D3DE;" onChange="javascript:reloadForm(this.value)">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
    </cfloop>	 
</SELECT>   	
</TD>
</tr>
<TR>

<td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" bgcolor="#ffffcf" rules="rows">

<tr bgcolor="#8EA4BB">
    <TD><font size="1" face="Tahoma" color="FFFFFF">&nbsp;Id</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Description</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Operational</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Entered</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Officer</font></TD>	
	
</TR>

<tr><td height="30" colspan="5" align="right" valign="middle">
<button onClick="javascript:add()"> Insert Record</button>&nbsp;</td></tr>

<CFOUTPUT query="SearchResult">
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffcf'))#">
<TD><font size="1" face="Tahoma" color="000000"><a href="javascript:edit('#ActionClass#')">&nbsp;#ActionClass#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#Description#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#Operational#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#DateFormat(Created, "#CLIENT.dateformatshow#")#</font></td>
<TD><font size="1" face="Tahoma" color="000000">#OfficerFirstName# #OfficerLastName#</font></TD>
</TR>
</CFOUTPUT>
</TABLE>

</td>

</TABLE>

</td>

</table>

<hr>
<p align="center">
<font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font> </p>

</form>

</BODY></HTML>