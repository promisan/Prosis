<cf_screentop html="no" jquery="yes">

<cfquery name="get" 
	datasource="AppsSystem">
		SELECT	*
		FROM	Ref_ModuleControl
		WHERE	SystemFunctionId = '#url.systemFunctionId#'
</cfquery>

<cfquery name="qLogoDark" 
	datasource="AppsSystem">
		SELECT 	*
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#get.FunctionName#'
		AND		MenuClass		= 'Layout'
		AND		FunctionName	= 'LogoDark'
		AND		Operational		= 1
</cfquery>

<cfoutput>

	<table width="96%" align="center">
		<cfset vImage = "#session.root#/images/noImageAvailable.png">
		<cfif qLogoDark.recordCount eq 1>
			<cfif trim(qLogoDark.functionDirectory) neq "" and trim(qLogoDark.FunctionPath) neq "">
				<cfset vImage = "#session.root#/#qLogoDark.functionDirectory##qLogoDark.FunctionPath#">
			</cfif>
		</cfif>
		<tr>
			<td align="center">
				<cf_tl id="Go to portal!" var="1">
				<a href="#session.root#/Portal/Selfservice/default.cfm?id=#get.FunctionName#" target="_blank" title="#lt_text#">
					<img src="#vImage#" style="height:120px; cursor:pointer;">
				</a>
			</td>
		</tr>
		<tr><td height="10"></td></tr>
		<tr>
			<td align="center" class="labelit" valign="top" style="padding-top:1px;">
				<table>
					<tr>
						<td align="center" class="labelit" style="font-size:18px;">
							<cfif trim(get.FunctionInfo) neq "">
								#get.FunctionInfo#
							<cfelse>
								#get.FunctionMemo#
							</cfif>
						</td>
						<cfif session.authent eq 1 and getAdministrator('*') eq 1>
						<td style="padding-left:5px; padding-top:3px;">
							<img src="#session.root#/images/configure.gif" style="cursor:pointer;" title="Open Configurations" onclick="showConfigurations('#get.SystemFunctionId#');">
						</td>
						</cfif>
					</tr>
				</table>
			</td>
		</tr>
		<cfif trim(get.FunctionContact) neq "">
		<tr>
			<td align="center" class="labelit" valign="top" style="padding-top:3px;">
				#get.FunctionContact#
			</td>
		</tr>
		</cfif>
	</table>

</cfoutput>