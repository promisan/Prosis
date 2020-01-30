<!--- 
	IncidentSearchResults.cfm
	
	List incidents and allow user to pick one from list
--->
<HTML><HEAD><TITLE>Person Selection</TITLE></HEAD>

<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">

<body bgcolor="#BFDFFF">

<cfset vIncident = #URL.ID#>

<cfquery name="SearchResult" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT PersonNo, LastName, FirstName FROM PERSON ORDER BY LastName, FirstName
</cfquery>

<script language="JavaScript">
function CreateIncidentPersonRec(inc, pers)
{
	window.open("IncidentPersonSubmit.cfm?ID=" + inc + "&ID1=" + pers, "IndexWindow", "width=600, height=550, toolbar=yes, scrollbars=yes, resizable=no");
}
</script>	
		
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

  <tr bgcolor="#002350">
	<td height="20" class="label">&nbsp;<b>Person List</b></td>
  </tr>
  
  <tr>
  	<td>  
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

	<!-- Print column headers -->
	<TR bgcolor="#6688aa">
    <td><font size="1" face="Tahoma" color="FFFFFF">&nbsp;</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">PersonNo</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">Last Name</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">First Name</font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">&nbsp; </font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">&nbsp; </font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">&nbsp; </font></td>
    <td><font size="1" face="Tahoma" color="FFFFFF">&nbsp; </font></td>
	</TR>

	<!-- List incident records -->
	<CFOUTPUT query="SearchResult">
	<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
	<td><font size="1" face="Tahoma" color="000000">
	<input type="button" class="button2" name="select" value="..." onClick="javascript:CreateIncidentPersonRec(#vIncident#,'#PersonNo#')"></td>
	<td><font size="1" face="Tahoma" color="000000">#PersonNo#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#LastName#</font></td>
	<td><font size="1" face="Tahoma" color="000000">#FirstName#</font></td>
	<td><font size="1" face="Tahoma" color="000000"> </td>
	<td><font size="1" face="Tahoma" color="000000"> </td>
	<td><font size="1" face="Tahoma" color="000000"> </td>
	<td><font size="1" face="Tahoma" color="000000"> </td>
	</TR>
	</CFOUTPUT>
	</TABLE>
	</td>
  </tr>
</table>

<hr>

</BODY></HTML>