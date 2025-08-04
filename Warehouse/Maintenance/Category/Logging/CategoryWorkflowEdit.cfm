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
<cfquery name="get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_AssetActionCategoryWorkflow
		WHERE	ActionCategory = '#url.action#'
		AND		Category = '#url.category#'
		AND		Code = '#url.code#'
</cfquery>

<cf_tl id = "Logging Workflow" var = "vLabel">

<!---

<cfif url.code eq "">

	<cf_screentop height="100%" 
			  scroll="yes" 
			  layout="webapp" 
			  label="#vLabel#"
			  user="no">
			  
<cfelse>

	<cf_screentop height="100%" 
			  scroll="yes" 
			  layout="webapp" 
			  banner="yellow"
			  label="#vLabel#"
			  user="no">
			  
</cfif>

--->

<table class="hide">
<tr><td><iframe name="processCategoryWorkflow" id="processCategoryWorkflow" frameborder="0"></iframe></td></tr>
</table>

<cfform action="Logging/CategoryWorkflowSubmit.cfm?idmenu=#url.idmenu#&category=#url.category#&action=#url.action#&code=#url.code#" method="POST" name="categoryLogging" target="processCategoryWorkflow">
<table width="90%" align="center" class="formpadding">

	<tr><td height="5"></td></tr>
		<tr>
			<td style="height:25px" class="labelmedium" width="20%"><cf_tl id="Code">:</td>
			<td>
				<cfif url.code eq "">
					<cfinput type="Text" name="code" value="#get.code#" required="yes" maxlength="10" size="5" message="Please, enter a valid code." class="regularxl">
				<cfelse>
					<cfoutput>
						#get.code#
						<input type="Hidden" name="code" id="code" value="#get.code#">
					</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr>
			<td style="height:25px" class="labelmedium"><cf_tl id="Description">:</td>
			<td>
				<cfinput type="Text" name="description" value="#get.description#" required="no" maxlength="50" size="40" message="Please, enter a valid description." class="regularxl">
			</td>
		</tr>
		<tr>
			<td style="height:25px" class="labelmedium"><cf_tl id="Workflow">:</td>
			<td>
				<cfquery name="wf" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	*
						FROM 	Ref_EntityClass
						WHERE	EntityCode = 'AssObservation'
				</cfquery>
				<cfselect query="wf" display="EntityClassName" value="EntityClass" selected="#get.EntityClass#" name="EntityClass" required="no" queryposition="below" class="regularxl">
					<option value="">
				</cfselect>
			</td>
		</tr>
		<tr>
			<td style="height:25px" class="labelmedium"><cf_tl id="Operational">:</td>
			<td class="labelmedium">
				<input type="radio" class="rediol" name="Operational" id="Operational" value="1" <cfif get.Operational eq "1" or url.code eq "">checked</cfif>>Yes
				<input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif get.Operational eq "0">checked</cfif>>No
			</td>
		</tr>
		<tr><td colspan="2" align="center" height="6">
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td colspan="2" align="center" height="6">
		
		<tr>
			<td colspan="2" align="center" height="30">
				<input type="submit" class="button10g" name="Update" id="Update" value=" Save ">
			</td>
		</tr>
</table>
</cfform>