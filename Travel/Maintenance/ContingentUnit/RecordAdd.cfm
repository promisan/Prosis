<HTML><HEAD>
	<TITLE>Reference Add Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">


<cf_PreventCache>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_dialogTop text="Add">

<!--- Entry form --->

<table width="90%">

    <TR>
    <TD class="regular">Unit Code:</TD>
    <TD class="regular">
  	   <cfinput type="Text" name="UnitId" value="" message="Please enter the unit code" required="Yes" size="10" maxlength="10" class="regular">
    </TD>
	</TR>

	<tr><td colspan="2" height="10"></td></tr>   <!--- put blank line between two entry fields --->
	
    <TR>
    <TD class="regular">Unit Name:</TD>
    <TD class="regular">
		<textarea cols="50" rows="2" class="regular" name="UnitName"></textarea>
    </TD>
	</TR>
		
</table>

<hr>

<table width="100%">	
		
	<td align="right">
	<input class="input.button1" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="input.button1" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
</TABLE>

</CFFORM>


</BODY></HTML>