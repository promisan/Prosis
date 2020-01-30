<HTML><HEAD>
	<TITLE>Reference Edit Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link href="../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">
  
<cfquery name="Get" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM ContingentUnit
WHERE Id = '#URL.ID1#'
</cfquery>

<script language="JavaScript">
function ask() {
	if (confirm("Do you want to remove this record ?")) {	
		return true 	
	}	
	return false	
}	
</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_dialogTop text="Edit">

<!--- edit form --->

<table width="92%">

    <cfoutput>
    <TR>
    <TD class="regular">Unit Id:</TD>
    <TD class="regular">
  	   <input type="text" name="UnitId" value="#get.Id#" size="10" maxlength="10" class="regular" readonly="yes">
    </TD>
	</TR>
	
	<tr><td colspan="2" height="10"></td></tr>   <!--- put blank line between two entry fields --->
	
    <TR>
    <TD class="regular">Unit Name:</TD>
    <TD class="regular">
		<textarea cols="50" rows="2" class="regular" name="UnitName">#get.Name#</textarea>
    </TD>
	</TR>		
	</cfoutput>
	
</table>

<hr>

<table width="100%">	
		
	<td align="right">
	<input class="button7" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button7" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button7" type="submit" name="Update" value=" Update ">
	</td>	
	
</TABLE>
	
</CFFORM>


</BODY></HTML>