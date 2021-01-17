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

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="92%" align="center" class="formpadding formspacing">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD><cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxxl"></TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD><cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxxl"></TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">UoM:</TD>
    <TD><cfinput type="text" name="MeasurementUoM" value="" message="Please enter a valid uom" required="No" size="10" maxlength="10" class="regularxxl"></TD>
	</TR>
	
	<TR>
    <td class="labelmedium2">Measurement:</td>
    <TD>
		<select name="measurement" id="measurement" class="regularxxl">
			<option value="Cumulative">Cumulative
			<option value="Increment">Increment
		</select>
    </td>
    </tr>
	
	<TR>
    <td>Operational:</td>
    <TD>
		<input type="radio" name="operational" id="operational" class="radiol" value="1" checked>Yes
		<input type="radio" name="operational" id="operational" class="radiol" value="0">No		
    </td>
    </tr>
		
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="6"></td></tr>	
		
	<tr>		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="  Save  ">	
	</td>		
	</tr>
	
</table>

</cfform>

<cf_screenbottom layout="innerbox">