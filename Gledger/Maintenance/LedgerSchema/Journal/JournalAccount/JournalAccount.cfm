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
<cfquery name="List" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	JA.*,
				A.Description as AccountDescription
	    FROM  	JournalAccount JA
				INNER JOIN Ref_Account A
					ON JA.GLAccount = A.GLAccount
		WHERE 	Journal= '#URL.ID1#'	
		ORDER BY ListOrder
</cfquery>

<table width="98%" align="center" class="navigation_table">
	<tr><td height="10"></td></tr>
	<tr class="labelmedium2">
		<td width="8%" align="center">
			<cfoutput>
				<a href="javascript:editJournalAccount('#url.id1#','')"><cf_tl id="Add"></a>
			</cfoutput>
		</td>
		<td width="6%" align="center"><cf_tl id="Order"></td>
		<td><cf_tl id="Account"></td>
		<td align="center"><cf_tl id="Default"></td>
		<td align="center"><cf_tl id="Mode"></td>
	</tr>	
	<tr><td colspan="5" class="line"></td></tr>	
	<cfoutput query="List">
		<tr class="labelmedium2 navigation_row line">
			<td align="center">
				<table>
					<tr>
						<td>
							<cf_img icon="edit" navigation="yes" onclick="editJournalAccount('#url.id1#','#GLAccount#');">
						</td>
						<td style="padding-top:2px;padding-left:8px;">
							<cf_img icon="delete" onclick="purgeJournalAccount('#url.id1#','#GLAccount#');">
						</td>
					</tr>
				</table>
			</td>
			<td align="center">#ListOrder#</td>
			<td>[#GLAccount#] #AccountDescription#</td>
			<td align="center"><cfif ListDefault eq 1><b><cf_tl id="Yes"></b><cfelse><cf_tl id="No"></cfif></td>
			<td align="center">#Mode#</td>
		</tr>
	</cfoutput>
	<tr><td id="myprocess"></td></tr>
</table>

<cfset AjaxOnLoad("doHighlight")>