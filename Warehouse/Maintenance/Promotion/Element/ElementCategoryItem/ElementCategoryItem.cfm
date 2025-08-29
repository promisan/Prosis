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
<cf_compression>

<cfif url.serial neq "">
	<cfset vCols = 1>
	<table width="100%" align="center">
		<tr><td height="10"></td></tr>
		<tr>
			<td class="labelmedium" colspan="<cfoutput>#vCols#</cfoutput>"><cf_tl id="Sale items that classify for discount"></td>
		</tr>
		<tr>
			<td colspan="<cfoutput>#vCols#</cfoutput>" class="line">
				<cfdiv id="divElementCategoryItemListing" bind="url:ElementCategoryItem/ElementCategoryItemEdit.cfm?idmenu=#url.idmenu#&promotionid=#url.promotionid#&serial=#url.serial#&category=&categoryItem=">
			</td>
		</tr>
	</table>
</cfif>