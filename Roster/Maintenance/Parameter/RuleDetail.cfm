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
<cfparam name="url.rule" default="">

<cfquery name="Rule"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Rule 
	WHERE  Code = '#url.rule#'
</cfquery>

<cfif Rule.RecordCount gt 0>

	<cfoutput query="Rule">
		<table width="80%" align="center">
			<tr> <td height="20px" colspan="2"></td> </tr>
			<tr class="labelit" valign="top">
				<td class="labelit">Message:</td>
				<td> #MessagePerson#</td>
			</tr>
			
			<tr class="labelit">
				<td class="labelit">Template:</td>
				<td>
					<a href="javascript:template('#ValidationPath##ValidationTemplate#')" style="color:##0080FF">#ValidationPath##ValidationTemplate#</a>
				</td>
			</tr>
			
			<tr class="labelit">
				<td class="labelit">Color</td>
				<td style="background-color:#color#">#Color#</td>
			</tr>
			<tr>
				<td colspan="2" height="20px"></td>
			</tr>
			<tr>
				<td class="linedotted" colspan="2"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input class="button10g" type="button" name="Select" value=" Select " onClick="submitRule('#url.owner#','#url.rule#','#url.level#','#url.from#','#url.to#');">
					<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="ProsisUI.closeWindow('RuleWindow');">
				</td>
			</tr>
		</table>
	</cfoutput>

<cfelse>
	
	<table width="80%" align="center">
			<tr> <td height="40px"></td> </tr>
			<tr>
			<td class="labelmedium"><i>You have not selected a rule for this transition of status.</i></td>
			</tr>
			<tr>
				<td colspan="2" height="40px"></td>
			</tr>
			<tr>
				<td class="linedotted" colspan="2"></td>
			</tr>
			<tr>
				<td align="center">
					<cfoutput>
					<input class="button10g" type="button" name="Select" value=" Select " onClick="submitRule('#url.owner#','#url.rule#','#url.level#','#url.from#','#url.to#');">
					<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="ProsisUI.closeWindow('RuleWindow');">
					</cfoutput>
				</td>
			</tr>
	</table>
	
</cfif>