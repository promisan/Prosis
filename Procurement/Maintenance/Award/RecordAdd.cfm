<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Award" 
			  label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="5"></td></tr>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="20" class="regularxl">
	</TD>
	</TR>
	
    <TR>
    <TD class="labelit">Description:</TD>
    <TD>
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="25" maxlength="50" class="regularxl">
	</TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="2">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="2">	
	
	<tr>
		<td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
		</td>
	</tr>
    
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">