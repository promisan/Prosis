<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  title="Event class" 
			  scroll="no" 
			  layout="webapp" 
			  label="Add Event class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10">
    </TD>
	</TR>

	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30">
    </TD>
	</TR>
	
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="3"></td></tr>

	
	<tr>
	<td align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td>	
	
	</tr>
	
</table>

</cfform>

