<!--- Create Criteria string for query from data entered thru search form --->

<CF_RegisterAction 
SystemFunctionId="0101" 
ActionClass="Search" 
ActionType="Submit" 
ActionReference="Search" 
ActionScript="">   

<cfif #URL.ID3# NEQ "">
	<cfset dateValue = "">
	<CF_DateConvert Value="#URL.ID3#">
	<cfset DOB = #dateValue#>
	<CFSET #Criteria# = "LastName LIKE '%#URL.ID2#%' AND BirthDate = #DOB# AND Nationality = '#PreserveSingleQuotes(URL.ID4)#'">
<cfelse>
	<CFSET #Criteria# = "LastName LIKE '%#URL.ID2#%' AND Nationality = '#PreserveSingleQuotes(URL.ID4)#'">
</cfif>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="WarehousePMSS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM Staff
    WHERE #PreserveSingleQuotes(Criteria)#
	ORDER BY Staff.LastName, Staff.FirstName
</cfquery>

<SCRIPT LANGUAGE = "JavaScript">
function Selected(idx, bday)
{

	<CFOUTPUT>
	    var form = "#URL.ID#";
    	var field = "#URL.ID1#";
		var field2 = "birthdate";
		eval("self.opener.document." + form + "." + field + ".value = idx");
//		document.forms.documentcandidateedit.birthdate.value = bday;		
//		if opener.document.birthdate == null {
//			alert("Here!");
//			eval("self.opener.document." + form + ".birthdate.value = bday")
//		}
		window.close();
	</CFOUTPUT>
}
</SCRIPT>

<cf_dialogStaffing>

<HTML><HEAD><TITLE>Person Search</TITLE></HEAD>
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">
<body>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
  <td height="20" class="label">&nbsp;<b>Result</b></td>
  </tr>
  
  <tr><td>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<TR bgcolor="#6688aa">
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">&nbsp;</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">IndexNo</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">LastName</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">FirstName</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">Nat.</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">Gender</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">DOB</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">EOD</font></TD>
</TR>

<CFOUTPUT query="SearchResult">
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
<!---TD><font size="1" face="Tahoma" color="000000">
<input type="button" class="button2" name="select" value="..." 
onClick="javascript:Selected('#IndexNo#')"--->  
<td class="regular">&nbsp;
    <a href ="javascript:Selected('#IndexNo#','#DateFormat(BirthDate, CLIENT.DateFormatShow)#')">
   	     <img src="#CLIENT.Root#/Images/button.jpg" alt="" name="img0_#IndexNo#"  width="14" height="14" border="0" align="middle">
    </a>&nbsp;
</TD>
<TD><font size="1" face="Tahoma" color="000000"><A HREF ="javascript:ShowPerson('#IndexNo#')">#IndexNo#</A></font></TD>
<TD><font size="1" face="Tahoma" color="000000">#LastName#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#FirstName#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#Nationality#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#Gender#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#DateFormat(BirthDate, CLIENT.DateFormatShow)#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#Dateformat(EODUN, CLIENT.DateFormatShow)#</font></TD>
</TR>
</CFOUTPUT>

</TABLE>

</tr></td>
</table>

<hr>

<input type="button" class="input.button1" name="Print" value="    Print    " onClick="window.print()">
<input type="button" class="input.button1" name="OK"    value="    Close    " onClick="window.close()">

</BODY></HTML>