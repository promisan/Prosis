<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add" 
			  layout="webapp" 
			  scroll="Yes"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_PreventCache>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="93%" align="center" class="formpadding formspacing">

    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="text" name="SubPeriod" value="" message="Please enter a code" required="Yes" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Abbreviation:</TD>
    <TD>
  	   <input type="text" name="DescriptionShort" value="" size="6" maxlength="6" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="Text" name="DisplayOrder" value="0" message="Please enter a valid number" validate="integer" required="Yes" size="1" maxlength="1" class="regularxl">
    </TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>	
	<td colspan="2" align="center" height="30">	
		
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value="Submit">
	
	</td>	
	</tr>
	
</TABLE>

</CFFORM>
