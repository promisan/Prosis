<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Settlement" 
			  option="Add Settlement"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cf_PreventCache>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="labelmedium">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="labelmedium">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Mode">:</TD>
    <TD class="labelmedium">
  	   <cfselect name="mode" id="mode" required="No">
	   		<option value=""></option>
			<option value="Cash">Cash</option>
			<option value="Credit">Credit</option>
			<option value="Check">Check</option>
			<option value="Gift">Gift</option>
	   </cfselect>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD class="labelmedium">
	   <input type="radio" name="Operational" value="1" checked> Yes&nbsp;
 	   <input type="radio" name="Operational" value="0" > No
    </TD>
	</TR>
	
	
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	<tr><td height="6"></td></tr>
	<tr>	
		
	<tr>
		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="  Save  ">	
	</td>	
	
	</tr>
		
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">