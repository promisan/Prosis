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
<cf_tableround mode="solidcolor" color="#bgColor#">
	<table width="95%" height="100%">
		<tr>
			<td width="#iconTdWidth#" align="center" valign="middle">
				<img src    = "#SESSION.root#/Images/Logos/Warehouse/#iconName#"
					width  = "#iconWidth#"
				   	title   = "#elementName#" 
				   	border  = "0" 
				   	align   = "absmiddle">
			</td>
			<td valign="middle" style="padding-left:25px;">
			<cfdiv id="div#elementName#" bind="url:#link#">
			</td>
		</tr>
	</table>
</cf_tableround>
</cfoutput>