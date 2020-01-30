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

<table width="95%" align="center">
	<tr>
		<td height="20"></td>
	</tr>
	<tr>
		<td width="6%">
			<cfoutput>
			<img src="#SESSION.root#/Images/Logos/System/Global.png" title="Portals" height="48" align="middle">
			</cfoutput>
		</td>
		<td valign="middle" class="labellarge"><cf_tl id="Selfservice User Portal Access"></font></td>
	</tr>
	<tr>
		<td colspan="2">
			<table width="85%" align="center" class="navigation_table">
				<cfoutput query="Portals">
					<tr bgcolor="FFFFFF" class="labelmedium linedotted navigation_row" style="height:20px">
						<td height="25" style="padding-left:4px">
							#FunctionName#
						</td>
						<td height="25" style="padding-left:4px">
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
							<input type="Radio" class="radiol" name="portal_#formatId#" id="portal_#formatId#" onclick="submitChange('#url.id#', '#SystemFunctionId#', 1);" <cfif qAccess.status eq 1 or (qAccess.recordCount eq 0 and vStatus eq 1)>checked</cfif>>
							</td>
							<td style="padding-left:3px">Yes</td>
							<td style="padding-left:13px"><input type="Radio" class="radiol" name="portal_#formatId#" id="portal_#formatId#" onclick="javascript: submitChange('#url.id#', '#SystemFunctionId#', 9);" <cfif qAccess.status eq 9 or (qAccess.recordCount eq 0 and vStatus eq 9)>checked</cfif>></td>
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
		<td colspan="2" align="center">
			<cfdiv id="divUserPortalSubmit" bind="url:UserPortalSubmit.cfm?id=">
		</td>
	</tr>
</table>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>

