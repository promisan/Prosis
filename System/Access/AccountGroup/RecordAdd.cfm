 
<cf_screentop height="100%" scroll="Yes" label="Add" layout="webapp"  menuAccess="Yes" systemfunctionid="#url.idmenu#">
 
<CFFORM action="GroupSubmit.cfm" method="post">

<!--- Entry form --->

<table width="92%" align="center">

	<tr>
		<td colspan="2" height="10"></td>
	</tr>

   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium">Id:</TD>
    <TD>
		<cfinput type="Text" class="regularxl" name="AccountGroup" message="Please enter an Group Code" required="Yes" size="15" maxlength="20">
	</TD>
	</TR>
	<tr><td height="2"></td></tr>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Name:&nbsp;</TD>
    <TD>
		<cfinput type="Text" class="regularxl" name="Description" message="Please enter description" required="Yes" size="30" maxlength="50">
	</TD>
	</TR>
	<tr><td height="2"></td></tr>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Interface:&nbsp;</TD>
    <TD class="labelmedium" style="height:25px"><input type="radio" name="UserInterface" id="UserInterface" value="HTML" checked>HTML
	    <input type="radio" name="UserInterface" id="UserInterface" value="Optional">Optional
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td height="3"></td></tr>
	
	<tr><td align="center" colspan="2">
	    <table><tr><td>
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		</td>
		<td>
		<input type="submit" name="Insert" id="Insert" class="button10g" value=" Submit ">
		</td></tr></table>
		</td>
	</tr>
	</table>	
	
</CFFORM>
