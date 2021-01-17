
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%"
			  title="Background Contact" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Contact" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->
<cfform action="RecordSubmit.cfm" method="POST" name="dialog"><br>

<table width="95%" align="center" class="formpadding">

    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="25" maxlength="20" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Order:</TD>
    <TD>
  	  	<cfinput type="Text" name="ListingOrder" message="Please enter a numeric order" validate="integer" required="No" size="1" maxlength="3" class="regularxxl" style="text-align:center;">
    </TD>
	</TR>
	

	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr>	
	<td align="center" colspan="2"  valign="bottom">
    <input class="button10g" type="submit" name="Insert" value=" Save ">
	</td>	
	</tr>
	
</table>

</cfform>


