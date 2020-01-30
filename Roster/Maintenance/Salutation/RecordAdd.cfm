<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  title="Salutation" 
			  scroll="no" 
			  layout="webapp" 
			  label="Add Salutation" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <tr><td></td></tr>
	
    <TR>
    <TD class="labelmedium" width="25%">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Abbreviation:</TD>
    <TD>
  	   <cfinput type="Text" name="Abbreviation" value="" message="Please enter an abbreviation" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="" message="Please enter a ListingOrder" required="Yes" validate="integer" size="5" maxlength="3" class="regularxl">
    </TD>
	</TR>
	
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="3"></td></tr>
	
	<tr>
	<td align="center" colspan="2">
    <input class="button10g" type="submit" name="Insert" value=" Save ">
	</td>	
	
	</tr>
	
</table>

</cfform>

