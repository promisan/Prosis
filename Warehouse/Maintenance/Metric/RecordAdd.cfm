<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Metric" 
			  option="Add Metric" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cf_PreventCache>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="regular">Code:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="20" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">Description:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="regular">UoM:</TD>
    <TD class="regular">
  	   <cfinput type="text" name="MeasurementUoM" value="" message="Please enter a valid uom" required="No" size="10" maxlength="10" class="regular">
    </TD>
	</TR>
	
	<TR>
    <td>Measurement:</td>
    <TD>
		<select name="measurement" id="measurement">
			<option value="Cumulative">Cumulative
			<option value="Increment">Increment
		</select>
    </td>
    </tr>
	
	<TR>
    <td>Operational:</td>
    <TD>
		<input type="radio" name="operational" id="operational" value="1" checked>Yes
		<input type="radio" name="operational" id="operational" value="0">No		
    </td>
    </tr>
	
	
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
	
</table>

</cfform>

<cf_screenbottom layout="innerbox">