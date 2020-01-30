
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add" 
			  scroll="No" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
<!--- Entry form --->

<table width="95%" align="center">

    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="1" maxlength="1" class="regular">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30"class="regular">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
		
	
	<TR>
    <TD class="labelit">Color:</TD>
    <TD>
  	   <cfinput type="Text" name="InterfaceColor" value="transparent" message="Please enter a description" required="Yes" size="20" maxlength="20"class="regular">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
				
	<TR>
    <TD class="labelit">Hide in Roster:</TD>
    <TD>
	    <INPUT type="radio" name="RosterHide" value="0" checked> No
		<INPUT type="radio" name="RosterHide" value="1"> Yes
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	<tr><td height="1" class="linedotted" colspan="2"></td></tr>
	
	<tr>
	<td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>

