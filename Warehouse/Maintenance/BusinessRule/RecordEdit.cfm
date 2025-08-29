<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.idmenu" default="">

<cfif url.id1 eq "">
	<cf_screentop height="100%" 
				  scroll="Yes" 
				  html="Yes" 
				  label="Add Business Rule" 
				  layout="webapp" 
				  banner="blue" 
				  menuAccess="Yes" 
				  systemfunctionid="#url.idmenu#"
				  jQuery = "Yes">
<cfelse>
	<cf_screentop height="100%" 
				  scroll="Yes" 
				  html="Yes" 
				  label="Edit Business Rule" 
				  layout="webapp" 
				  banner="yellow"
				  menuAccess="Yes" 
				  systemfunctionid="#url.idmenu#"
				  jQuery = "Yes">
</cfif>

<cf_ColorScript>

<cfquery name="Get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_BusinessRule
		WHERE 	<cfif url.id1 eq "">1 = 0<cfelse>Code = '#URL.ID1#'</cfif>
</cfquery>

<cfquery name="GetMissions" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	M.*,
				(SELECT Mission FROM Ref_MissionBusinessRule WHERE ValidationCode = '#url.id1#' and Mission = M.Mission) as Selected
		FROM 	Ref_ParameterMission M
</cfquery>

<script>

	function ask()
	{
		if (confirm("Do you want to remove this business rule?")) {
			return true;
		}
		return false;
	}
	
	function validateFields() {	
		var controlToValidate = document.getElementById('ValidationTemplate');	 
		var vReturn = false;
		
		var controlToValidate2 = document.getElementById('MessagePerson');
		var vReturn2 = false;
		
		var vMessage = '';
		
		if (controlToValidate.value != "")
		{
			if (document.getElementById('validatePath').value == 0) 
			{ 
				vMessage = vMessage + '[' + document.getElementById('ValidationPath').value + controlToValidate.value + '] not validated.\n';
				vReturn = false;
			}
			else
			{
				vReturn = true;
			}
		}
		else
		{
			vReturn = true;
		}
		
		if (controlToValidate2.value.length > 300)
		{
			vMessage = vMessage + 'Message must be 300 characters or less, current length is ' + controlToValidate2.value.length + '.\n';
			vReturn2 = false;
		}
		else
		{
			vReturn2 = true;
		}
		
		if (!vReturn || !vReturn2) { alert(vMessage); }
		
		return vReturn && vReturn2;
	}

</script>


<cfform action="RecordSubmit.cfm?id1=#url.id1#&idmenu=#url.idmenu#" method="POST" name="frmBusinessRule" onsubmit="return validateFields();">

<!--- edit form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <TR>
    <TD class="regular" width="30%" height="23"><cf_tl id="Code">:</TD>
    <TD class="regular">
		<cfoutput>
			<cfif url.id1 eq "">
				<cfinput type="Text" name="Code" value="#get.Code#" required="Yes" message="Please, enter a valid code." maxlength="10" size="10">
			<cfelse>
				<b>#get.Code#</b>
			</cfif>
			<input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
		</cfoutput>
    </TD>
	</TR>
	
	<TR>
    <TD class="regular"><cf_tl id="Trigger Group">:</TD>
    <TD class="regular">
		
		<select name="TriggerGroup" id="TriggerGroup">
			<option value="Asset"         <cfif get.TriggerGroup eq "Asset">selected</cfif>><cf_tl id="Asset">
			<option value="Transaction"   <cfif get.TriggerGroup eq "Transaction">selected</cfif>><cf_tl id="Transaction">
			<option value="MeterReading"  <cfif get.TriggerGroup eq "MeterReading">selected</cfif>><cf_tl id="Mater Reading">
			<option value="ItemLocation"  <cfif get.TriggerGroup eq "ItemLocation">selected</cfif>><cf_tl id="Storage Location">
		</select>
		
    </TD>
	</TR>
	
	<TR>
    <TD class="regular"><cf_tl id="Class">:</TD>
    <TD class="regular">
		
		<select name="RuleClass" id="RuleClass">
			<option value="Alert" <cfif get.RuleClass eq "Alert">selected</cfif>><cf_tl id="Alert">
			<option value="Stopper" <cfif get.RuleClass eq "Stopper">selected</cfif>><cf_tl id="Stopper">
		</select>
		
    </TD>
	</TR>
	
	<TR>
    <TD class="regular"><cf_tl id="Description">:</TD>
    <TD class="regular">
		
		<cfinput type="Text" name="Description" value="#get.Description#" required="Yes" message="Please, enter a valid description." maxlength="100" size="50">
		
    </TD>
	</TR>
	
	<TR>
    <TD class="regular" valign="top"><cf_tl id="Message">:</TD>
    <TD class="regular">
		
		<cfoutput>
			<textarea name="MessagePerson" id="MessagePerson" rows="3" style="width:100%" class="regular" cols="60">#get.MessagePerson#</textarea>	
		</cfoutput>	
		
    </TD>
	</TR>
	
	<TR>
    <TD class="regular"><cf_tl id="Validation Path">:</TD>
    <TD class="regular">
		
		<cfinput type="Text" 
			name="ValidationPath" 
			required="yes" 
			message="Please, enter a valid validation path."
			class="regular"
			size="50"
			value="#get.ValidationPath#"
			maxlength="120">
		
    </TD>
	</TR>
	
	<TR>
    <TD class="regular"><cf_tl id="Validation Template">:</TD>
    <TD class="regular">
	
		<table>
			<tr>
				<td>
					<cfinput type="Text" 
						name="ValidationTemplate" 
						id="ValidationTemplate" 
						required="Yes"
						message="Please, enter a valid validation template." 
						class="regular"
						size="30"
						value="#get.ValidationTemplate#"
						onblur= "ColdFusion.navigate('FileValidation.cfm?template='+document.getElementById('ValidationPath').value+this.value+'&container=pathValidationDiv&resultField=validatePath','pathValidationDiv')"
						maxlength="30">
				</td>
				<td valign="middle" align="left">
				 	<cfdiv id="pathValidationDiv" bind="url:FileValidation.cfm?template=#get.ValidationPath##get.ValidationTemplate#&container=pathValidationDiv&resultField=validatePath">				
				</td>
			</tr>
		</table>
	</TR>
	
	<TR>
    <TD class="regular"><cf_tl id="Color">:</TD>
    <TD class="regular">

		<cf_color 	name="color" 
					value="#get.Color#"
					style="cursor: pointer; font-size: 0; border: 1px solid gray; height: 20; width: 20; ime-mode: disabled; layout-flow: vertical-ideographic;">					
		
    </TD>
	</TR>
	
	<tr>
		<td valign="top"><cf_tl id="Enabled for">:</td>
		<td>
			<table align="center" width="100%">
				<tr>
					<cfset colNum = 4>
					<cfset cntMissions = 0>
					<cfoutput query="GetMissions">
						<td>
							<label><input type="Checkbox" name="Mission_#Mission#" id="Mission_#Mission#" value="#Mission#" <cfif Selected eq Mission>checked</cfif>>#Mission#</label>
						</td>
						<cfset cntMissions = cntMissions + 1>
						<cfif cntMissions eq colNum>
							<cfset cntMissions = 0>
							</tr>
							<tr>
						</cfif>
					</cfoutput>
				</tr>
			</table>
		</td>
	</tr>
	
	<TR>
    <TD class="regular"><cf_tl id="Operational">:</TD>
    <TD class="regular">

		<input type="radio" name="Operational" id="Operational" <cfif get.Operational eq "1" or url.id1 eq "">checked</cfif> value="1">Yes
		<input type="radio" name="Operational" id="Operational" <cfif get.Operational eq "0">checked</cfif> value="0">No
		
    </TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	<tr><td height="4"></td></tr>
	<tr>	
	<td align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="  Cancel  " onClick="window.close()">
    <input class="button10g" type="submit" name="Update" id="Update" value="  Save  ">
	</td>	
	
</table>
	
</cfform>