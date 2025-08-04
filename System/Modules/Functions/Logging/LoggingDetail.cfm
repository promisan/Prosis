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

<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	D.*
		FROM   	UserActionModuleDetail D
		WHERE  	D.ModuleActionId = '#url.ModuleActionId#'
		AND		lower(ltrim(rtrim(D.FieldName))) NOT IN ('save','update','delete','insert','cancel')
		ORDER BY FieldName ASC
</cfquery>

<cf_screentop height="100%" 
	  scroll="Yes" 
	  html="no" 
	  layout="webapp" 
	  label="#function.FunctionName# Logging Detail" 
	  option="#function.functionMemo#"
	  banner="yellow" 
	  bannerheight="60" 
	  user="no"
	  menuAccess="yes" 
	  systemfunctionid="#function.systemfunctionid#">

<cfset maxRows = 12>
<cfset vHeaders = 3>
<cfset vCols = ceiling(get.recordCount/maxRows)>

<cfset fontSize1 = 10>
<cfset fontSize2 = 11>

<cf_divScroll>

<div style="height:200px;width:75%;overflow:auto;border:1px dotted #C0C0C0;">
	<table width="100%" align="center">
		<tr><td height="5"></td></tr>
		<tr>
			<td>
				<table width="99%" align="center">
					<tr>
						<td>
							<table width="100%">
								<tr>
									<td valign="top" colspan="<cfoutput>#vHeaders#</cfoutput>" width="#<cfoutput>100/vCols</cfoutput>#%">
										<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
											<cfset cnt = 0>
											<cfoutput query="get">
											
												<cfset cnt = cnt + 1>
												
												<cfif cnt eq 1>
												
													<!--- HEADERS --->
													<tr>
														<td width="#(100/vHeaders)*0.15#%" style="font-size:#fontSize1#px;" align="center">No.</td>
														<td width="#(100/vHeaders)*0.3#%" style="font-size:#fontSize1#px;">Field</td>
														<td width="#(100/vHeaders)*0.55#%" style="font-size:#fontSize1#px; padding-left:5px;">Value</td>
													</tr>
													
													<!--- LINE PER GROUP --->
													<tr>
														<td colspan="#vHeaders#">
															<table width="100%" align="center">
																<tr>
																	<td style="width:1px;"></td>
																	<td width="98%" class="linedotted"></td>
																	<td style="width:1px;"></td>
																</tr>
															</table>
														</td>
													</tr>
													<tr><td height="2"></td></tr>
													
												</cfif>
												
												<!--- GROUPS OF maxRows ITEMS --->
												<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor=''" bgcolor="">
													<td style="font-size:#fontSize2#px;" align="center">#currentRow#</td>
													<td style="font-size:#fontSize2#px; color:808080; font-style:italic;">#lcase(FieldName)#:</td>
													<td style="font-size:#fontSize2#px; padding-left:5px;">
														<cfif fieldValue eq "">
															<i>[empty]</i>
														<cfelse>
															<!--- <label style="text-decoration:line-through;">#lcase(FieldValue)#</label> --->
															#lcase(FieldValue)#
														</cfif>
													</td>
												</tr>
												
												<cfif cnt eq maxRows>
													</table>
													</td>
													<td valign="top" colspan="#vHeaders#" width="#100/vCols#%">
													<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
													<cfset cnt = 0>
												</cfif>
												
											</cfoutput>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td height="5"></td></tr>
	</table>
</div>

</cf_divScroll>