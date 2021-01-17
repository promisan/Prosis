<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
  			  scroll="Yes" 
			  layout="webapp" 			 
			  label="Warehouse class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="92%" align="center" class="formpadding formspacing">

	<tr><td style="height:5px"></td></tr>
	
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Order">:</TD>
    <TD>
  	   <cfinput style="text-align:center" type="text" name="ListingOrder" value="1" validate="integer" required="Yes" size="2" maxlength="2" class="regularxxl">
    </TD>
	</TR>
		
	<tr><td height="3"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr>
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Save ">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>




