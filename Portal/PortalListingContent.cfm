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