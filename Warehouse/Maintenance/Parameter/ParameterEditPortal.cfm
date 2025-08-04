<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="6"></td></tr>
	
	<TR class="labelmedium2">
    <td>Request Prefix/LastNo:</b></td>
    <TD>
 		<input type="text" class="regularxl" name="RequestPrefix"   id="RequestPrefix" value="#RequestPrefix#" size="6" maxlength="6" style="text-align: right;">
		<input type="text" class="regularxl" name="RequestSerialNo" id="RequestPrefix" value="#RequestSerialNo#" size="6" maxlength="6" style="text-align: right;">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <td width="200"><cf_UIToolTip tooltip="Define portal interface settings, external mode will show more information">Portal Interface Mode:</cf_UIToolTip></b></td>
    <TD width="70%">
	
		<table>
				<tr class="labelmedium2">
				<td style="padding-left:0px"><input type="radio" class="radiol" name="PortalInterfaceMode" id="PortalInterfaceMode" <cfif PortalInterfaceMode eq "Internal">checked</cfif> value="Internal"></td>
				<td style="padding-left:3px">Internal</td>
				<td style="padding-left:7px"><input type="radio" class="radiol" name="PortalInterfaceMode" id="PortlaInterfaceMode" <cfif PortalInterfaceMode eq "External">checked</cfif> value="External"></td>
				<td style="padding-left:3px">External</td>
				</tr>
		</table>	
			
    </td>
    </tr>		
	
	<TR class="labelmedium2">
    <td>Disable Double Supply Request:</b></td>
    <TD>
	
		<table>
				<tr class="labelmedium2">
				<td style="padding-left:0px"><input type="radio" class="radiol" name="DisableDoubleRequest" id="DisableDoubleRequest" <cfif DisableDoubleRequest eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:2px">Yes</td>
				<td style="padding-left:5px"><input type="radio" class="radiol" name="DisableDoubleRequest" id="DisableDoubleRequest" <cfif DisableDoubleRequest eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:2px">No</td>
				</tr>
		</table>	
		
    </td>
    </tr>
	
				
	<TR class="labelmedium2">
    <td><cf_UIToolTip tooltip="Allow users to receive items that were requested by another user which is employed in the same unit">Allow unit members to confirm delivery:</cf_UIToolTip></b></td>
    <TD>
	
		<table>
				<tr class="labelmedium2">
				<td style="padding-left:0px"><input type="radio" class="radiol" name="UnitConfirmation" id="UnitConfirmation" <cfif UnitConfirmation eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:2px">Yes</td>
				<td style="padding-left:5px"><input type="radio" class="radiol" name="UnitConfirmation" id="UnitConfirmation" <cfif UnitConfirmation eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:2px">No</td>
				</tr>
		</table>	
	
    </td>
    </tr>
	
		
	<TR class="labelmedium2">
    <td>Cart print Template:</b></td>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="RequisitionTemplate" value="#RequisitionTemplate#" message="Please enter a directory name" required="No" size="60" maxlength="60">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <td>Enable EDIT of Quantity by Reviewer/Processor:</b></td>
    <TD>
	<table>
				<tr class="labelmedium2">
				<td style="padding-left:0px"><input type="radio" class="radiol" name="EnableQuantityChange" id="EnableQuantityChange" <cfif EnableQuantityChange eq "1">checked</cfif> value="1"></td>
				<td style="padding-left:2px">Yes</td>
				<td style="padding-left:5px"><input type="radio" class="radiol" name="EnableQuantityChange" id="EnableQuantityChange" <cfif EnableQuantityChange eq "0">checked</cfif> value="0"></td>
				<td style="padding-left:2px">No</td>
				</tr>
		</table>	
    </td>
    </tr>	
	
	
	<TR>
    <td class="labelmedium2"><cf_UIToolTip tooltip="Allow users to see prices">Request Price:</cf_UIToolTip></b></td>
    <TD class="labelmedium2">
	<table>
				<tr class="labelmedium2">
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