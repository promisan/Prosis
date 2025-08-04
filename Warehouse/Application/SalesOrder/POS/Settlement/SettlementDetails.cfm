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
<cfparam name="url.mode" default="">
<cfparam name="url.scope" default="settlement">

<cfoutput>

<!--- <cfquery name="qMode" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   S.Mode
	FROM     Ref_Settlement S 
	WHERE    Operational  = '1'	
	<cfif url.code neq "">
		AND		 Mode = '#url.code#'
	</cfif>
</cfquery> --->
	
<cfswitch expression="#url.mode#">

	<cfcase value="Credit">
		<table width = "100%" cellpadding="0" cellspacing="0">
		<tr>
			<td width="2%"></td>
			<td colspan="2" style="padding-left:5px" align="left" class="labelit" valign="bottom"><cf_tl id="Credit Card Number"></td>
			<td colspan="2" style="padding-left:5px" align="center" class="labelit" valign="bottom"><cf_tl id="Expiry YY/MM"></td>				
		</tr>
		<tr>
			<td width="2%"></td>
			<td style="padding-left:10px" colspan="2" width="40%">
				<input type="text" id="CC_number" name="CC_number" style="width:220px;padding-right:3px" maxlength="20" class="regularxl" onfocus="setFocus(this,'no')">						
			</td>	
			<td colspan="2" width="40%" style="padding-left:10px">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td class="labelit" width="50%" align="right">
							<input type="text" id="exp_month_number" name="exp_month_number" size="1" maxlength="2" class="regularxl" style="text-align:center;width:36px" onfocus="setFocus(this,'no')">
							</td>
							<td class="labelit" style="padding-left:2px;padding-right:2px">/</td>
							<td width="50%" align="left" class="labelit">
							<input type="text" id="exp_year_number" name="exp_year_number" size="1" maxlength="2" class="regularxl" style="ext-align:center;width:36px" onfocus="setFocus(this,'no')">
							</td>
					</tr>						
				</table>					
			</td>			
		</tr>
		<tr><td height="4"></td></tr>
							
		<tr>
			<td colspan="7" align="center">
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td style="padding-left:10px" align="left" valign="bottom" class="labelit"><cf_tl id="Approval"></td>
				<td style="padding-left:10px" align="left" valign="bottom" class="labelit"><cf_tl id="Reference Number"></td>				
			</tr>
			<tr>
				<td style="padding-left:10px"><input type="text" id="approval_number"  name="approval_number"  size="8"  maxlength="8"  class="regularxl" onfocus="setFocus(this,'no')"></td>			
				<td style="padding-left:10px"><input type="text" id="reference_number" name="reference_number" size="14" maxlength="14" class="regularxl" onfocus="setFocus(this,'no')"></td>
			</tr>		
			</table>
		</tr>				
		<tr><td height="2" colspan="9" align="center"></td></tr>
		
		</table>
	</cfcase>
	
		

	<cfcase value="Check">
		<table width = "100%" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="7" align="center">
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td height="4"></td></tr>		
			<tr>
				<td width="3%"></td>
				<td colspan="2" height="20" align="left" valign="bottom" class="labelit"><cf_tl id="Bank Number"></td>
			</tr>		
			<tr>
				<td width="3%"></td>
				<td colspan="2" width="40%">
					<input type="text" id="bank_number" name="bank_number" style="width:320px;padding-right:3px" maxlength="25" class="regularxl" onfocus="javascript:setFocus(this,'no')">						
				</td>	
			</tr>			
			<tr>
				<td width="3%"></td>
				<td height="18" align="left" valign="bottom" class="labelit"><cf_tl id="Check Number"></td>
				<td height="18" align="left" valign="bottom" class="labelit"><cf_tl id="Approval Number"></td>				
			</tr>
			<tr>
				<td width="3%"></td>			
				<td><input type="text" id="reference_number" name="reference_number" size="20" maxlength="20" class="regularxl" onfocus="javascript:setFocus(this,'no')"></td>
				<td><input type="text" id="approval_number" name="approval_number" size="20" maxlength="20" class="regularxl" onfocus="javascript:setFocus(this,'no')"></td>							
			</tr>		
			</table>
		</tr>				
		<tr><td height="2" colspan="9" align="center"></td></tr>
		
		</table>
	</cfcase>	
	
	<cfcase value="Gift">
		<table width = "100%">
		<tr><td height="10" colspan="9" align="center"></td></tr>
		<tr>
			<td width="3%"></td>
			<td class="labelit"><cf_tl id="Gift Number">:</b></td>				
			<td>
				<input type="text" id="Gift_number" name="Gift_number" size="8" maxlength="16" class="regularxl" onfocus="javascript:setFocus(this,'no')">
			</td>
		</tr>
		<tr><td height="2" colspan="9" align="center"></td></tr>
		</table>
	</cfcase>
	
	<cfcase value="None">
	
		<table width = "100%">
		<tr><td height="10" colspan="9" align="center"></td></tr>		
		</table>	
	
	</cfcase>
	
</cfswitch>

</cfoutput>

<cfif url.scope neq "workflow" and url.scope neq "standalone">
	<cfset AjaxOnLoad("initSettlement")>
<cfelse>
	<script>
		initSettlement();
	</script>	
</cfif>	