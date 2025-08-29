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
<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray" 
			  title="Trigger Group" 			  
			  label="Trigger Group" 
			  line="no"
			  html="No"
			  jquery="yes" user="no">

<cfquery name="get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM   	Ref_PayrollTriggerGroup
	WHERE  	SalaryTrigger = '#URL.SalaryTrigger#'
	<cfif url.entitlementgroup neq "">
		AND 	EntitlementGroup = '#URL.EntitlementGroup#'
	<cfelse>
		AND		1=0
	</cfif>
</cfquery>

<table class="hide">
	<tr><td><iframe name="frmTriggerSubmit" id="frmTriggerSubmit"></iframe></td></tr>
</table>

<cfform name="frmTriggerGroup" action="#session.root#/payroll/maintenance/trigger/PayrollTriggerGroup/RecordSubmit.cfm?SalaryTrigger=#url.SalaryTrigger#&EntitlementGroup=#url.EntitlementGroup#" target="frmTriggerSubmit">
	<cfoutput>
		<table width="92%" align="center" class="formpadding formspacing">
			<tr><td height="10"></td></tr>
			<tr>
				<td class="labelmedium" width="20%"><cf_tl id="Code">:</td>
				<td class="labelmedium">
					<cfif url.entitlementgroup neq "">
						<input type="hidden" id="EntitlementGroup" name="EntitlementGroup" maxlength="10" size="10" value="#get.EntitlementGroup#" required="yes" class="regularxl">
						#EntitlementGroup#
					<cfelse>
						<input type="text" id="EntitlementGroup" name="EntitlementGroup" maxlength="10" size="10" value="#get.EntitlementGroup#" required="yes" class="regularxl">
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="labelmedium"><cf_tl id="Name">:</td>
				<td>
					<input type="text" id="EntitlementName" name="EntitlementName" maxlength="30" size="30" value="#get.EntitlementName#" class="regularxl">
				</td>
			</tr>
			<tr>
				<td class="labelmedium"><cf_tl id="Priority">:</td>
				<td>
					<select name="EntitlementPriority" id="EntitlementPriority" class="regularxl" required="yes">
						<option value="0" <cfif get.EntitlementPriority eq 0 OR get.EntitlementPriority eq ''>selected</cfif>> 0
						<option value="1" <cfif get.EntitlementPriority eq 1>selected</cfif>> 1
						<option value="2" <cfif get.EntitlementPriority eq 2>selected</cfif>> 2
						<option value="3" <cfif get.EntitlementPriority eq 3>selected</cfif>> 3
						<option value="4" <cfif get.EntitlementPriority eq 4>selected</cfif>> 4
						<option value="5" <cfif get.EntitlementPriority eq 5>selected</cfif>> 5
						<option value="6" <cfif get.EntitlementPriority eq 6>selected</cfif>> 6
						<option value="7" <cfif get.EntitlementPriority eq 7>selected</cfif>> 7
						<option value="8" <cfif get.EntitlementPriority eq 8>selected</cfif>> 8
						<option value="9" <cfif get.EntitlementPriority eq 9>selected</cfif>> 9
						<option value="10" <cfif get.EntitlementPriority eq 10>selected</cfif>> 10
					</select>
				</td>
			</tr>
			<tr>
				<td class="labelmedium"><cf_tl id="Mode">:</td>
				<td>
					<select name="ApplyMode" id="ApplyMode" class="regularxl" required="yes">
						<option value="None" <cfif get.ApplyMode eq 'None' OR get.ApplyMode eq ''>selected</cfif>> None
						<option value="DOB" <cfif get.ApplyMode eq 'DOB'>selected</cfif>> DOB
					</select>
				</td>
			</tr>
			<tr>
				<td class="labelmedium"><cf_tl id="Range">:</td>
				<td class="labelmedium">
					<cf_tl id="Please enter a valid integer lower range" var="1">
					<cfinput type="text" id="ApplyRangeFrom" name="ApplyRangeFrom" maxlength="3" size="2" validate="integer" style="text-align:center;" value="#get.ApplyRangeFrom#" required="yes" class="regularxl" message="#lt_text#">
					-
					<cf_tl id="Please enter a valid integer upper range" var="1">
					<cfinput type="text" id="ApplyRangeTo" name="ApplyRangeTo" maxlength="3" size="2" validate="integer" style="text-align:center;"  value="#get.ApplyRangeTo#" required="yes" class="regularxl" message="#lt_text#">
				</td>
			</tr>
			<tr>
				<td class="labelmedium"><cf_tl id="Order">:</td>
				<td>
					<cf_tl id="Please enter a valid integer order" var="1">
					<cfinput type="text" id="ListingOrder" name="ListingOrder" maxlength="3" size="2" validate="integer" style="text-align:center;" value="#get.ListingOrder#" required="yes" class="regularxl" message="#lt_text#">
				</td>
			</tr>
			<tr><td height="10"></td></tr>
			<tr><td colspan="2" class="line"></td></tr>
			<tr><td height="10"></td></tr>
			<tr>
				<td colspan="2" align="center">
					<cf_tl id="Save" var="1">
					<cfoutput>
						<input type="submit" name="btnSubmit" id="btnSubmit" value="#lt_text#" class="button10g">
					</cfoutput>
				</td>
			</tr>
		</table>
	</cfoutput>
</cfform>