<!--- 
	IncidentSearchResults.cfm
	
	List incidents and allow user to pick one from list
--->

<!---
<cfset dateValue = "">
<CF_DateConvert Value="#URL.ID3#">
<cfset DOB = #dateValue#>

<CFSET #Criteria# = "LastName LIKE '%#URL.ID2#%' AND BirthDate = #DOB# AND Nationality = '#PreserveSingleQuotes(URL.ID4)#'">

--->
<!--- <cfoutput>#PreserveSingleQuotes(Criteria)#</cfoutput> ---> 

<!--- Query returning search results 
<cfquery name="SearchResult" 
datasource="WarehousePMSS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * 
    FROM Staff
    WHERE 
        #PreserveSingleQuotes(Criteria)#
		ORDER BY Staff.LastName, Staff.FirstName</cfquery>

--->
<cfquery name="SearchResult" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT I.*, D.Description AS sDecision
FROM Incident I LEFT OUTER JOIN Decision D ON I.Decision = D.Decision
ORDER BY I.OpenDate
</cfquery>

<!---
<SCRIPT LANGUAGE = "JavaScript">

function Selected(Ind)
{

	<CFOUTPUT>
	    var form = "#URL.ID#";
    	var field = "#URL.ID1#";
		eval("self.opener.document." + form + "." + field + ".value = Ind");			
		window.close();
	</CFOUTPUT>
}

</SCRIPT>
--->
<cf_dialogStaffing>

<HTML><HEAD>
    <TITLE>Incidents Selection</TITLE>
	<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">

</HEAD><body bgcolor="#BFDFFF">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

  <tr bgcolor="#002350">
	<td height="20" class="label">&nbsp;<b>Search Results</b></td>
  </tr>
  
  <tr>
  	<td>  
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

	<!-- Print column headers -->
	<TR bgcolor="#6688aa">
    <TD><font size="1" face="Tahoma" color="FFFFFF">&nbsp;</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Incident</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Mission</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Case No</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Opened On</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Closed On</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Req By</font></TD>
    <TD><font size="1" face="Tahoma" color="FFFFFF">Decision</font></TD>
	</TR>

	<!-- List incident records -->
	<CFOUTPUT query="SearchResult">
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
	<TD><font size="1" face="Tahoma" color="000000">
	<input type="button" class="button2" name="select" value="..." <!---onClick="javascript:Selected('#Incident#')"--->></TD>
	<TD><font size="1" face="Tahoma" color="000000">#Incident#</font></TD>
	<TD><font size="1" face="Tahoma" color="000000">#Mission#</font></TD>
	<TD><font size="1" face="Tahoma" color="000000">#MissionCaseNumber#</font></TD>
	<TD><font size="1" face="Tahoma" color="000000">#DateFormat(OpenDate, CLIENT.DateFormatShow)#</font></TD>
	<TD><font size="1" face="Tahoma" color="000000">#DateFormat(CloseDate, CLIENT.DateFormatShow)#</font></TD>
	<TD><font size="1" face="Tahoma" color="000000">#RequestedBy#</font></TD>
	<TD><font size="1" face="Tahoma" color="000000">#sDecision#</font></TD>
	</TR>
	</CFOUTPUT>
	</TABLE>
	</td>
  </tr>
</table>

<hr>

<input type="button" class="input.button1" name="Print" value="    Print    " onClick="window.print()">
<input type="button" class="input.button1" name="OK"    value="    Close    " onClick="window.close()">

</BODY></HTML>