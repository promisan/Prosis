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
<cfparam name="url.mission" 		default="">
<cfparam name="url.class"   		default="Main">
<cfparam name="url.functionClass"   default="Selfservice">

<cfquery name="get" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       #client.lanPrefix#Ref_ModuleControl	 
	 WHERE		<cfif url.id neq "">SystemFunctionId = '#url.id#'<cfelse>1 = 0</cfif>
</cfquery>

<cfset vFunctionId = "00000000-0000-0000-0000-000000000000">
<cfif url.id neq "">
	<cfset vFunctionId = get.SystemFunctionId>
</cfif>

<cfset vTitleNew = "Portal"> 
<cfif lcase(url.systemmodule) eq "pmobile">
	<cfset vTitleNew = "Prosis Mobile"> 
</cfif>

<cfset passName = get.functionName>
<cfset passName = replace(passName, "'", "%27", "ALL")>

<cfquery name="get" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT     *
	 FROM       #client.lanPrefix#Ref_ModuleControl	 
	 WHERE		<cfif url.id neq "">SystemFunctionId = '#url.id#'<cfelse>1 = 0</cfif>
</cfquery>

<cf_divscroll>
	 
<cfinclude template="RecordEditHeader.cfm">

<cfif url.id neq "" and url.class eq "main">

	<cfset url.contextFunctionName = get.FunctionName>
	<cfinclude template="RecordSubmitDefaultValues.cfm">
	
	<table width="94%" align="center" id="tblDetail">
		<tr><td height="5"></td></tr>
			
		<tr><td height="1" colspan="3" class="line"></td></tr>
		
		<tr><td colspan="3" class="labelmedium" style="border-right:1px dotted silver" style="padding-left:6px"><cf_tl id="#vTitleNew# Configurations"></td>
		
		<td class="line" align="center" valign="middle">
				<table width="100%" align="center" cellspacing="0">
					<tr>
						<tr>											
							<td align="center" class="labelmedium" width="2%" title="Order" style="padding-right:5px;"><span class="labelheader" style="display:none;"><cf_tl id="Ord"></span></td>
							<td width="18%" class="labelmedium"><span class="labelheader" style="display:none;"><cf_tl id="Name"></span></td>
							<td class="labelmedium"><span class="labelheader" style="display:none;"><cf_tl id="Path"></span></td>
							<td class="labelmedium" width="20%"><span class="labelheader" style="display:none;"><cf_tl id="Condition"></span></td>
							<td align="right" width="30">
								<cfoutput>
									<img src="#SESSION.root#/images/expand.png" 
										title="show all details" 
										style="cursor:pointer;" 
										id="twistieHeader" 
										height="13" 
										align="absmiddle" 
										onclick="toggleAllDetails();">
								</cfoutput>
							</td>
						</tr>
					</tr>
				</table>
			</td>
		
		</tr>
				
		<cfset menulist = "Layout,Menu,Process,Function">
		<cfif trim(lcase(url.systemmodule)) eq "pmobile">
			<cfset menulist = "Menu,Function">
		</cfif>
	
		<cfloop index="MenuClass" list="#menulist#">
		
		<tr><td colspan="4" class="line"></td></tr>
		<tr>
			<td valign="middle" width="8%">
								
					<cfoutput>
						<td valign="top" style="padding-top:3px;padding-left:4px" class="labelmedium">#MenuClass#</td>
					</cfoutput>
							
			</td>
			
			<td valign="top" class="labelmedium" style="padding-top:3px;padding-left:4px">	
			
				<cfoutput>
							
					<cfif lcase(MenuClass) neq "layout">
						
						<a href="javascript: addportalline('','#get.FunctionName#','#MenuClass#','#url.systemmodule#','#url.functionClass#'); showDivDetail('#MenuClass#');" title="Click to add a new element">
							<cf_tl id="Add new">
						</a>
						
					</cfif>
				
				</cfoutput>
				
			</td>		
			
			<td valign="middle" style="border-left:1px dotted #C7C7C7;">
				<div id="<cfoutput>divInfo#MenuClass#</cfoutput>" class="clsInfo" title="click to show the details">
				<table width="100%" align="center" style="cursor:pointer;" onclick="javascript: toggleDivDetail('<cfoutput>#MenuClass#</cfoutput>');">
					<tr>
						<td class="labelmedium" style="padding-left:4px">
							<a href="javascript:">
								
								<cfif MenuClass eq "Layout">
									<cf_tl id="Visual elements for the portal.  Custom icons, graphics, logos, etc.">
								</cfif>
								
								<cfif MenuClass eq "Menu">
									<cfif lcase(url.functionClass) eq "pmobile">
										<cf_tl id="Main menu displayed on the left side of the application.">
									<cfelse>
										<cf_tl id="Public menu elements.  To be displayed when the user is not logged into the system.">
									</cfif>
								</cfif>
								
								<cfif MenuClass eq "Process">
									<cf_tl id="Private menu elements.  To be displayed when the user is logged into the system.">
								</cfif>
								
								<cfif MenuClass eq "Function">
									<cf_tl id="Functional elements to be used across the portal regardless the user status (logged or not).">
								</cfif>
								
							</a>
						</td>
					</tr>
				</table>
				</div>
				
				<div id="<cfoutput>div#MenuClass#</cfoutput>" class="clsDetail" style="display:none;">
				
				<table width="100%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">	
					<tr>					
						<td colspan="5" valign="top">			
							<table width="100%" cellspacing="0" cellpadding="0" align="center">				
								
								<cfquery name="getDetail" 
								     datasource="AppsSystem" 
								     username="#SESSION.login#" 
								     password="#SESSION.dbpw#">		 
									 SELECT     *
									 FROM       #client.lanPrefix#Ref_ModuleControl
									 WHERE		SystemModule  = '#url.systemmodule#'
									 AND		FunctionClass = '#get.FunctionName#'
									 AND		MenuClass     = '#MenuClass#'
									 ORDER BY   MenuClass, 
									            MenuOrder, 
												FunctionName
								</cfquery>
															
								<cfif getDetail.recordCount eq 0>
									<tr>
										<td align="center" colspan="5">								
										<font color="808080">
											<cfoutput>
											<cf_tl id="No lines recorded">.
											</cfoutput>
										</font>
										</td>
									</tr>
								</cfif>
								<cfoutput query="getDetail">
									<cfset vShowThisRow = false>
									<cfif ucase(get.functionTarget) eq "HTML5">
										
										<cfif menuClass eq "layout">
											<cfif FindNoCase("logo",functionName) neq 0>
												<cfset vShowThisRow = true>
											<cfelseif FindNoCase("icon",functionName) neq 0>
												<cfset vShowThisRow = true>
											</cfif>
										<cfelseif menuClass eq "function">
											<cfif functionName eq "BeforeLogout" 
												or functionName eq "CustomCSS" 
												or functionName eq "AutohideMenu"
												or functionName eq "Preferences"
												or functionName eq "InitShowMenu"
												or functionName eq "AutoIE8"
												or functionName eq "CustomInformation"
												or functionName eq "RequestAccess"
												or functionName eq "ForgotPassword"
												or functionName eq "LanguageTopMenu"
												or functionName eq "ShowPublicPreferences"
												or functionName eq "ShowPublicInformation"
												or functionName eq "PreferencesPassword"
												or functionName eq "Configurations"
												or functionName eq "PreferencesFeatures"
												or functionName eq "PreferencesAnnotations"
												or functionName eq "PreferencesLDAPMailbox"
												or functionName eq "InformationEntity"
												or functionName eq "ShowPrivateInformation"
												or functionName eq "ShowMenuInfo"
												or functionName eq "ShowSupportMenu"
												or functionName eq "OnLogin"
												or functionName eq "OnFinishPreparation"
												or functionName eq "ShowLanguageFlag"
												or functionName eq "ForgotUsername"
												or functionName eq "IconSet"
												or functionName eq "ShowLoginOnInit"
												or functionName eq "Clearances">
													<cfset vShowThisRow = true>
											</cfif>
											<cfif functionName eq "CustomLogin" and systemModule eq "PMobile">
												<cfset vShowThisRow = true>
											</cfif>
										<cfelse>
											<cfset vShowThisRow = true>
										</cfif>
										
									<cfelse>
										<cfset vShowThisRow = true>
									</cfif>

									<cfif vShowThisRow>
									
										<cfset vBGColor = "">
										<cfif operational eq 0>
											<cfset vBGColor = "##FFC4C5">
										</cfif>
															
										<tr class="navigation_row line labelmedium" bgcolor="#vBGColor#">	
											<td style="padding-left:5px;padding-right:8px" align="center" width="2%"><cfif lcase(MenuClass) neq "layout">#MenuOrder#</cfif></td>
											<td style="padding-right:3px" width="18%">#FunctionName#</td>
											<td style="padding-right:3px">
												<cfif trim(lcase(url.systemmodule)) eq "pmobile">
													<cfif trim(FunctionDirectory) eq "" and trim(FunctionPath) eq "">
														[ <cf_tl id="Submenu"> ]
													<cfelse>
														#FunctionDirectory##FunctionPath#
													</cfif>
												<cfelse>
													#FunctionDirectory##FunctionPath#
												</cfif>
											</td>
											
											<td align="center" width="35">
												<table width="100%" cellspacing="0" cellpadding="0" align="center">
													<tr>
														<td align="center" style="padding-top:1px">
														    <cf_img icon="edit" onClick="javascript: addportalline('#SystemFunctionId#','#get.FunctionName#','#MenuClass#','#url.systemmodule#','#url.functionClass#');">
															
														</td>
														<cfif lcase(MenuClass) neq "layout">
														<td align="center" style="padding-top:1px">
														     <cf_img icon="delete" onClick="if (confirm('Do you want to remove this record ?')) { purgeportalline('#SystemFunctionId#','#get.FunctionName#','#MenuClass#','#url.systemmodule#','#url.functionClass#'); }">													
														</td>
														</cfif>
													</tr>
												</table>
											</td>
										</tr>
										<cfif FunctionCondition neq "">
										
										<tr>
											<td></td>
											<td></td>
											<td colspan="2" class="labelmedium"><font color="808080">#FunctionCondition#</font></td>
										</tr>
										
										</cfif>
									</cfif>
								</cfoutput>
							</table>
						</td>
					</tr>
				</table>
				</div>
				
			</td>
		</tr>
		
		</cfloop>
		<tr><td height="5"></td></tr>
	</table>

</cfif>

</cf_divscroll>

<cfset AjaxOnLoad("toggleTarget")>
<cfset AjaxOnLoad("doHighlight")>
<cfset AjaxOnLoad("function(){ doKendoMenu('exportOptionsMenu'); }")>