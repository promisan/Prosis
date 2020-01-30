<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  title="Organization" 
			  scroll="Yes" 
			  layout="webapp" 
			  Label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="4"></td></tr>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Organizationcode" id="Organizationcode" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="OrganizationDescription" id="OrganizationDescription" value="" message="Please enter a description" required="Yes" size="30" maxlength="50"class="regularxl">
    </TD>
	</TR>

	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>
	
	<tr>	
	<td align="center" colspan="2"  valign="bottom">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>

