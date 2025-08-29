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
<cfquery name="Portals" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	M.*
	    FROM 	#client.lanPrefix#Ref_ModuleControl M
	    WHERE 	M.SystemModule  = 'Selfservice'
		AND 	M.FunctionClass = 'Selfservice'
		AND		M.MenuClass in ('Mission','Main')
		AND		M.Operational = 1
		AND     M.FunctionName <> 'widgets'
		ORDER BY M.FunctionMemo ASC, M.FunctionName ASC
</cfquery>

<cfquery name="getAccesses" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 	SELECT	*
		FROM	UserModule
		WHERE	Account = '#url.id#'
</cfquery>

<cf_divscroll style="height:100%">

<table width="96%" align="center">
	
	<tr class="labelmedium2 fixrow">
		<td width="6%">
			<cfoutput>
			<img src="#SESSION.root#/Images/Logos/System/Portal.png" title="Portals" height="48" align="middle">
			</cfoutput>
		</td>
		<td valign="middle" style="font-size:20px"><cf_tl id="User Portal authorization"></td>
	</tr>
	<tr>
		<td colspan="2">
			<table width="89%" align="center" class="navigation_table">
				<cfoutput query="Portals">
					<tr class="line labelmedium2 navigation_row" style="height:35px">
						<td style="font-size:17px;padding-left:4px">
							#FunctionName#
						</td>
						<td style="font-size:17px;padding-left:4px">
							#FunctionMemo#
						</td>
						<td align="center">
						
							<cfquery name="qAccess" dbtype="query">
								SELECT 	*
								FROM	getAccesses
								WHERE	SystemFunctionId = '#SystemFunctionId#'
							</cfquery>
							
							<cfif qAccess.recordCount eq 0>
								<cfset vStatus = 9>
								<cfif EnableAnonymous eq 1>
									<cfset vStatus = 1>
								</cfif>
								<script>
									submitInitUserPortal('#url.id#', '#SystemFunctionId#', #vStatus#);
								</script>
							</cfif>
							
							<table>
							<tr class="labelmedium" style="height:20px"><td>
							<cfset formatId = replace(SystemFunctionId, "-", "", "ALL")>
							<input type="Radio" class="radiol" style="height:20px;width:20px" name="portal_#formatId#" id="portal_#formatId#" onclick="submitChange('#url.id#', '#SystemFunctionId#', 1);" <cfif qAccess.status eq 1 or (qAccess.recordCount eq 0 and vStatus eq 1)>checked</cfif>>
							</td>
							<td style="padding-left:3px">Yes</td>
							<td style="padding-left:13px"><input type="Radio" style="height:20px;width:20px" class="radiol" name="portal_#formatId#" id="portal_#formatId#" onclick="javascript: submitChange('#url.id#', '#SystemFunctionId#', 9);" <cfif qAccess.status eq 9 or (qAccess.recordCount eq 0 and vStatus eq 9)>checked</cfif>></td>
							<td style="padding-left:3px">No</td>
							</tr></table>
						</td>
					</tr>					
				</cfoutput>
			</table>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr class="hide">
		<td colspan="2" align="center" id="divUserPortalSubmit"></td>
	</tr>
</table>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>

