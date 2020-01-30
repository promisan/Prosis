
<cf_screentop label="Archive Result" height="100%" html="No">

<!--- Search form --->

<table width="90%" border="0" frame="hsides" cellspacing="0" cellpadding="0" align="center">
   
<tr><td colspan="1">

<cfform action="ResultArchiveSubmit.cfm?#cgi.query_string#" method="post" name="positionsearch1">
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <Td>&nbsp;</TD>
		
    <TR><td height="30"></td>
	<TD class="labelmedium" align="left">Name: <font color="FF0000">*)</font></b>
    </TD>
	<TD><cfoutput>
	    <cfinput type="Text" name="Description" required="Yes" message="Please enter a description" visible="Yes" enabled="Yes" size="40" maxlength="40" class="regularxl">
		<input type="hidden" name="SearchId" value="#URL.ID#" class="regular">
		</cfoutput>				
	</TD>
		
	</TR>	
	
    <TR><td height="30"></td>
	<TD class="labelmedium" align="left">Access:</b>
    </TD>
	<TD class="labelmedium">
	
	<input type="radio" class="radiol" name="Access" value="Personal" checked>Personal
	<input type="radio" class="radiol" name="Access" value="Personal" checked>Shared
	 	
				
	</TD>
		
	</TR>	
	
 	
	</TD></TR>
	
	<TR><TD>&nbsp;</TD></TR>
	
	<tr>
	<td colspan="4">
	
	<cfinclude template="ResultCriteria.cfm">
		
	</td></tr>
		
	</TABLE>
	
    </td></tr>
	
	<tr>
	<td align="center" style="padding-top:10px">
	<input type="reset" name="Reset" value="Reset" class="Button10g">
	<input type="submit" name="Submit" value="Archive" class="Button10g">
	</td></tr>
	
	
</table>	

</td>
</tr>

</CFFORM>

</table>

<cf_screenbottom html="No">
