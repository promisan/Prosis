
<cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="6"></td></tr>
	
	<TR>
    <td class="labelmedium">Request Prefix/LastNo:</b></td>
    <TD class="labelmedium">
 		<input type="text" class="regularxl" name="RequestPrefix"   id="RequestPrefix" value="#RequestPrefix#" size="6" maxlength="6" style="text-align: right;">
		<input type="text" class="regularxl" name="RequestSerialNo" id="RequestPrefix" value="#RequestSerialNo#" size="6" maxlength="6" style="text-align: right;">
    </TD>
	</TR>
	
	<TR>
    <td class="labelmedium" width="200"><cf_UIToolTip tooltip="Define portal interface settings, external mode will show more information">Portal Interface Mode:</cf_UIToolTip></b></td>
    <TD class="labelmedium" width="70%">
	
		<table>
				<tr class="labelmedium">
				<td style="padding-left:0px"><input type="radio" class="radiol" name="PortalInterfaceMode" id="PortalInterfaceMode" <cfif PortalInterfaceMode eq "Internal">checked</cfif> value="Internal"></td>
				<td style="padding-left:3px">Internal</td>
				<td style="padding-left:7px"><input type="radio" class="radiol" name="PortalInterfaceMode" id="PortlaInterfaceMode" <cfif PortalInterfaceMode eq "External0">checked</cfif> value="External"></td>
				<td style="padding-left:3px">External</td>
				</tr>
		</table>	
			
    </td>
    </tr>		
	
	<TR>
    <td class="labelmedium">Disable Double Supply Request:</b></td>
    <TD class="labelmedium">
	
		<table>
				<tr class="labelmedium">
				<td style="padding-left:0px"><input type="radio" class="radiol" name="DisableDoubleRequest" id="DisableDoubleRequest" <cfif DisableDoubleRequest eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:2px">Yes</td>
				<td style="padding-left:5px"><input type="radio" class="radiol" name="DisableDoubleRequest" id="DisableDoubleRequest" <cfif DisableDoubleRequest eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:2px">No</td>
				</tr>
		</table>	
		
    </td>
    </tr>
	
				
	<TR>
    <td class="labelmedium"><cf_UIToolTip tooltip="Allow users to receive items that were requested by another user which is employed in the same unit">Allow unit members to confirm delivery:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
	
		<table>
				<tr class="labelmedium">
				<td style="padding-left:0px"><input type="radio" class="radiol" name="UnitConfirmation" id="UnitConfirmation" <cfif UnitConfirmation eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:2px">Yes</td>
				<td style="padding-left:5px"><input type="radio" class="radiol" name="UnitConfirmation" id="UnitConfirmation" <cfif UnitConfirmation eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:2px">No</td>
				</tr>
		</table>	
	
    </td>
    </tr>
	
		
	<TR>
    <td class="labelmedium">Cart print Template:</b></td>
    <TD class="labelmedium">
  	    <cfinput class="regularxl" type="Text" name="RequisitionTemplate" value="#RequisitionTemplate#" message="Please enter a directory name" required="No" size="60" maxlength="60">
    </TD>
	</TR>
	
	<TR>
    <td class="labelmedium">Enable EDIT of Quantity by Reviewer/Processor:</b></td>
    <TD class="labelmedium">
	<table>
				<tr class="labelmedium">
				<td style="padding-left:0px"><input type="radio" class="radiol" name="EnableQuantityChange" id="EnableQuantityChange" <cfif EnableQuantityChange eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:2px">Yes</td>
				<td style="padding-left:5px"><input type="radio" class="radiol" name="EnableQuantityChange" id="EnableQuantityChange" <cfif EnableQuantityChange eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:2px">No</td>
				</tr>
		</table>	
    </td>
    </tr>	
	
	
	<TR>
    <td class="labelmedium"><cf_UIToolTip tooltip="Allow users to see prices">Request Price:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
	<table>
				<tr class="labelmedium">
				<td style="padding-left:0px"><input type="radio" class="radiol" name="RequestEnablePrice" id="RequestEnablePrice" <cfif RequestEnablePrice eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:2px">Enabled</td>
				<td style="padding-left:5px"><input type="radio" class="radiol" name="RequestEnablePrice" id="RequestEnablePrice" <cfif RequestEnablePrice eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:2px">Disabled</td>
				</tr>
		</table>	
    </td>
    </tr>			
	
	
	
		
	<tr><td height="4"></td></tr>
		
	</table>
	
</cfoutput>	