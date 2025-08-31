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
<cfoutput>

<cfinclude template="ActionStepPrintHeader.cfm">

<br>
	<table width="100%" align="center" cellspacing="" cellpadding="0" class="formpadding">
		<tr valign="top">
		<td><b>Action Code</b></td>
		<td><strong>Action Parent</strong></td>
		<td><strong>Description</strong></td>
		<td><strong>Reference</strong></td>
		<td><strong>Action Type</strong></td>
		<td><strong>Left Action</strong></td>
		<td><strong>Left Label</strong></td>
		<td><strong>Right Action</strong></td>
		<td><strong>Right Label</strong></td>
		</tr>
		
		<tr><td height="5" colspan="9" class="line"></td></tr>
	
		<cfloop query="GetAction">
		<tr valign="top">
			<td><b>#GetAction.ActionCode#</b></td>
			<td>#GetAction.ActionParent#</td>
			<td>#GetAction.ActionDescription#</td>
			<td>#GetAction.ActionReference#</td>
			<td>#GetAction.ActionType#</td>
			<cfif GetAction.ActionType eq "Decision">
				<td>#GetAction.ActionGoToYes#</td>
				<td>#GetAction.ActionGoToYesLabel#</td>
				<td>#GetAction.ActionGoToNo#</td>
				<td>#GetAction.ActionGoToNoLabel#</td>
			</cfif>
		</tr>
		</cfloop>
		
	</table>
	

</cfoutput>
