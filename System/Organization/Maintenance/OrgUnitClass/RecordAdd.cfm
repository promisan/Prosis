
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
		      label="Add" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->


<table width="92%" class="formpadding" cellspacing="0" cellpadding="0" align="center">

    <tr><td></td></tr>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Icon:</TD>
    <TD>
  	   <cfinput type="text" name="ListingIcon" value="" tooltip="Please enter the name of a graphic icon" required="No" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>


</BODY></HTML>