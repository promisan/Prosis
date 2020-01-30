<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Add Job Group" 
			  label="Add Job Group" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="4"></td></tr>
	
	<tr><td colspan="2" class="labelit"><font color="808080">Job groups are a means to classify jobs. 
	Groups will also be used for workflow allowing to define different actors for each group although the workflow follows the same pattern (class)
	</font>
	</td></tr>
	
	<tr><td height="4"></td></tr>

	<!--- Field: Code--->
	 <TR>
	 <TD width="60%" class="labelit">Code:&nbsp;</TD>  
	 <TD class="labelit">
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regularxl">

	 </TD>
	 </TR>
	
	<!--- Field: Description --->
    <TR>
    <TD class="labelit">Description:&nbsp;</TD>
    <TD>
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50"
		class="regularxl">
				
    </TD>
	</TR>

	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	

	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
		</td>
	</tr>
	
</table>

</CFFORM>