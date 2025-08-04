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
<cfquery name="function" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_ModuleControl
		WHERE  	SystemFunctionId = (SELECT SystemFunctionId FROM UserActionModule WHERE ModuleActionId = '#url.ModuleActionId#')
</cfquery>

<cfquery name="getHeader" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	UserActionModule
		WHERE  	ModuleActionId = '#url.ModuleActionId#'
</cfquery>

<cfquery name="getLastHeader" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM	UserActionModule
		WHERE	ActionTimeStamp < '#getHeader.ActionTimeStamp#'
		AND		UPPER(ActionDescription) IN ('INSERT','UPDATE')
		ORDER BY ActionTimeStamp DESC
</cfquery>

<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	D.*
		FROM   	UserActionModuleDetail D
		WHERE  	D.ModuleActionId = '#url.ModuleActionId#'
		ORDER BY FieldName ASC
</cfquery>


<cfquery name="getLast" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	UserActionModuleDetail
		WHERE  	1=1
		<cfif getLastHeader.recordCount eq 0>
		AND		1=0
		<cfelse>
		AND		ModuleActionId = '#getLastHeader.ModuleActionId#'
		</cfif>
		ORDER BY FieldName ASC
</cfquery>

<cf_screentop height="100%" 
	  scroll="Yes" 
	  html="Yes" 
	  layout="webapp" 
	  label="#function.FunctionName# Logging Detail" 
	  option="#function.functionMemo#"
	  banner="yellow" 
	  bannerheight="60" 
	  user="no"
	  menuAccess="yes" 
	  systemfunctionid="#function.systemfunctionid#">

<cfset vCols = 2>
<cfif ucase(getHeader.ActionDescription) eq "UPDATE">
	<cfset vCols = 3>
</cfif>
	  
<table width="95%" align="center">
	<tr><td height="15"></td></tr>
	<tr>
		<td style="font-size:12px;" colspan="2">
			<cfoutput>
				<b>#ucase(getHeader.ActionDescription)#</b>: By [#get.officerUserId#] #get.officerFirstName# #get.officerLastName# @ #lsDateFormat(get.created,'#CLIENT.DateFormatShow#')# #lsTimeFormat(get.created,'hh:mm:ss tt')#
			</cfoutput>
		</td>
	</tr>
	<cfif ucase(getHeader.ActionDescription) eq "UPDATE">
	<tr><td height="3"></td></tr>
	<tr>
		<td style="font-size:12px;" colspan="2">
			<cfoutput>
				<b>LAST ACTION: #ucase(getLastHeader.ActionDescription)#</b> by [#getLast.officerUserId#] #getLast.officerFirstName# #getLast.officerLastName# @ #lsDateFormat(getLast.created,'#CLIENT.DateFormatShow#')# #lsTimeFormat(getLast.created,'hh:mm:ss tt')#
			</cfoutput>
		</td>
	</tr>
	</cfif>
	<tr><td height="8"></td></tr>
	<tr>
		<td>
			<table width="95%" cellpadding="0" align="center" class="formpadding">
				<tr>
					<td width="20%" style="font-style:italic;">Field</td>
					<td style="font-style:italic;">Value</td>
					<cfif ucase(getHeader.ActionDescription) eq "UPDATE">
					<td style="font-style:italic;">Last Value</td>
					</cfif>
				</tr>
				<tr><td colspan="<cfoutput>#vCols#</cfoutput>" class="line"></td></tr>
				<tr><td height="2"></td></tr>
			<cfoutput query="get">
				<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
					<td width="20%">#lcase(FieldName)#</td>
					<td>
						<cfif fieldValue eq "">
							[Empty]
						<cfelse>
							#lcase(FieldValue)#
						</cfif>
					</td>
					<cfif ucase(getHeader.ActionDescription) eq "UPDATE">
					<td>
						<cfquery name="qGetLast" dbtype="query">
							SELECT 	*
							FROM 	getLast
							WHERE	FieldName = '#FieldName#'
						</cfquery>
						
						<cfif qGetLast.recordCount eq 0>
							[Not recorded]
						<cfelse>
							#qGetLast.FieldValue#
						</cfif>
					</td>
					</cfif>
				</tr>
			</cfoutput>
			</table>
		</td>
	</tr>
</table>