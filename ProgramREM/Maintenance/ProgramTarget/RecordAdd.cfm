<HTML><HEAD>
	<TITLE>Reference Add Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">


<cf_PreventCache>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cf_dialogTop text="Add">

<!--- Entry form --->

<table width="90%">

    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regular">
    </TD>
	</TR>
	
</table>

<hr>

<table width="100%">	
		
	<td align="right">
	<input class="button7" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button7" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
</TABLE>

</CFFORM>


</BODY></HTML>