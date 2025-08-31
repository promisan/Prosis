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
<cfparam name="url.mission" 		default="">
<cfparam name="url.name" 			default="">

<cfquery name="getRootPortal" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
		SELECT     	*
		FROM       	#client.lanPrefix#Ref_ModuleControl	 
		WHERE		SystemModule = '#url.systemModule#'
		AND			FunctionClass = '#url.functionClass#'
		AND			FunctionName = '#url.name#'
</cfquery>

<cfform name="frmPortalHeader" action="RecordSubmit.cfm?id=#url.id#&mission=#url.mission#&class=#url.class#&systemmodule=#url.systemmodule#&functionclass=#url.functionclass#" method="POST" target="processportalheader">

	<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<tr><td height="10"></td></tr>		
		
		<tr>
			<td colspan="1" style="font-weight:200;font-size:28" class="labellarge"><cf_tl id="Definition"></td>
			<td align="right" valign="top">
				<cfif ((lcase(url.class) eq "main" or lcase(url.class) eq "mission") and url.id neq "") or lcase(url.class) eq "layout">
				<table>
				    <tr>
					<td class="labelmedium"><cf_tl id="Operational">:</td>
					<td>
						<input type="Checkbox" style="width:18px;height:18px" name="Operational" id="Operational" <cfif get.Operational eq "1" or url.id eq "">checked</cfif>>
					</td>
					
					<cfif (lcase(url.class) eq "main" or lcase(url.class) eq "mission") and url.id neq "" and lcase(SESSION.isAdministrator) eq "yes">
					<cfoutput>
						
						<td style="padding-left:4px">
							<div id="exportOptionsContainer" class="k-content">
       							<div id="exportMenuContainer">
									<ul id="exportOptionsMenu">
										<li>
						                    <span style="font-size:13px; font-style:italic;"><cf_tl id="Export"></span>
						                    <ul>
						                        <li>
						                            <div style="padding:10px; padding-left:25px; padding-right:25px;">
						                                <h3><cf_tl id="Export options"></h3>
														<table width="100%">
															<tr>
																<td align="center" style="cursor:pointer;">
																	<img 
																		src="#SESSION.root#/images/export.png" 
																		id="btnExport" 
																		name="btnExport" 
																		align="absmiddle" 
																		height="40" 
																		title="Generate export script" 
																		style="cursor:pointer;"
																		onclick="exportPortalDefinition('#get.functionName#');">
																</td>
																<td align="center" style="cursor:pointer; padding-left:20px;">
																	<img 
																		src="#SESSION.root#/images/duplicate2.png" 
																		id="btnClone" 
																		name="btnClone" 
																		align="absmiddle" 
																		height="40" 
																		title="Clone this portal" 
																		style="cursor:pointer;"
																		onclick="clonePortalDefinition('#get.functionName#');">
																</td>
															</tr>
															<tr>
																<td align="center" class="labelmedium" style="cursor:pointer; color:##808080;"><label for="btnExport"><cf_tl id="Export"></label></td>
																<td align="center" class="labelmedium" style="cursor:pointer; color:##808080; padding-left:20px;"><label for="btnClone"><cf_tl id="Clone"></label></td>
															</tr>
														</table>
						                            </div>
						                        </li>
						                    </ul>
						                </li>
									</ul>
								</div>
							</div>
						</td>
					
					</cfoutput>
					</cfif>		
							
					
					</tr>
				</table>
				</cfif>
			</td>
			
		</tr>
		
		<tr><td colspan="3" class="line"></td></tr>	
				
		<cfif ((lcase(url.class) eq "main" or lcase(url.class) eq "mission") and url.id neq "") or lcase(url.class) eq "layout">
		
			<cfoutput>					
				<input type="Hidden" name="FunctionName" id="FunctionName" value="#get.functionName#">
			</cfoutput>
			
		<cfelse>		
		
			<tr>
				<td style="padding-left:20px" width="15%" class="labelmedium"><cf_tl id="Code">:</td>
				<td>						
						
						<cfinput type="Text" 
							name="FunctionName" 
							required="Yes" 
							message="Please, enter a valid name."
						   	class="regularxl"
						   	size="50"
							value="#get.FunctionName#"
						   	maxlength="40">
							
				</td>
				<td align="right" valign="top">
					<table>
						<tr>
							<td  class="labelmedium"><cf_tl id="Operational">:</td>
							<td>
								<input style="width:18px;height:18px" type="Checkbox" name="Operational" id="Operational" <cfif get.Operational eq "1" or url.id eq "">checked</cfif>>
							</td>
						</tr>
					</table>
				</td>
			</tr>	
			
		</cfif>
		<cfoutput>
		<input type="Hidden" name="FunctionNameOld" id="FunctionNameOld" value="#get.functionName#">	
		</cfoutput>	
			
		<tr>
			<td valign="top" style="padding-left:20px" width="15%"  class="labelmedium"><cf_tl id="Name">:</td>
			<td>
				<table width="100%" align="center">
				
				<cfset vShowLanguageOperational = 0>
				<cfif lcase(url.class) eq "main" or lcase(url.class) eq "mission">
					<cfset vShowLanguageOperational = 1>
				</cfif>
										
				<cf_LanguageInput
					TableCode       		= "Ref_ModuleControl" 
					Mode            		= "Edit"
					Name            		= "FunctionMemo"
					Key1Value       		= "#vFunctionId#"
					Key2Value       		= "#url.mission#"
					Type            		= "Input"
					Required        		= "No"
					Message         		= "Please, enter a valid memo."
					MaxLength       		= "40"
					Size            		= "50"
					Class           		= "regularxl"
					Operational     		= "1"
					Label           		= "Yes"
					ShowLanguageOperational = "#vShowLanguageOperational#"
					EnforceDefault          = "0">
				
				<cfoutput>
					<input type="Hidden" name="ShowLanguageOperational" id="ShowLanguageOperational" value="#vShowLanguageOperational#">
				</cfoutput>	
				
				</table>
			</td>
			
		</tr>

		<cfif lcase(url.class) eq "process" or lcase(url.class) eq "menu">
			<tr>
				<td style="padding-left:20px"  class="labelmedium"><cf_tl id="Background">:</td>
				<td colspan="2">
					<cfinput type="Text" 
						name="FunctionBackground" 
						id="FunctionBackground"
					   	class="regularxl"
					   	size="30" 
						maxlength="80" 
						value="#get.FunctionBackground#">
				</td>
			</tr>
		<cfelse>
			<input type="hidden" name="FunctionBackground" id="FunctionBackground" value="#get.FunctionBackground#">
		</cfif>
		
		<cfif trim(lcase(url.systemmodule)) eq "pmobile">
		
			<!--- Default Values --->
			<cfif url.class eq "main">
				<input type="hidden" name="FunctionTarget" id="FunctionTarget" value="HTML5">
			<cfelse>
				<tr>
					<td style="padding-left:20px"  class="labelmedium"><cf_tl id="Parent">:</td>
					<td colspan="2">
						<cfinput type="Text" 
							name="FunctionTarget" 
							id="FunctionTarget"
						   	class="regularxl"
						   	size="20" 
							maxlength="40" 
							value="#get.FunctionTarget#">
					</td>
				</tr>
			</cfif>
			
			<cfoutput>
				<input type="hidden" name="MenuClass" id="MenuClass" value="#url.class#">
				<input type="hidden" name="AccessDataSource" id="AccessDataSource" value="">
			</cfoutput>
			
		<cfelse>
		
			<cfif lcase(url.class) eq "main" or lcase(url.class) eq "mission">
			<tr>
				<td style="padding-left:20px"  class="labelmedium"><cf_tl id="Mode">:</td>
				<td colspan="2">
					
						<select class="regularxl" name="FunctionTarget" id="FunctionTarget" onchange="javascript: toggleTarget();">			
							<option value="basic" <cfif get.FunctionTarget eq "basic">selected</cfif>>Basic</option>
							<option value="extended" <cfif get.FunctionTarget eq "extended">selected</cfif>>Extended</option>
							<option value="html5" <cfif get.FunctionTarget eq "html5">selected</cfif>>HTML5</option>
						</select>
					
				</td>
			</tr>
			</cfif>
			
			<cfif lcase(url.class) eq "main" or lcase(url.class) eq "mission">
			<tr id="trMenuClass">
				<td style="padding-left:20px"  class="labelmedium"><cf_tl id="Entity Sensitive">:</td>
				<td colspan="2">
					<select class="regularxl" name="MenuClass" id="MenuClass" onchange="javascript: toggleClass();">			
						<option value="Main" <cfif get.MenuClass eq "Main">selected</cfif>>No</option>
						<option value="Mission" <cfif get.MenuClass eq "Mission">selected</cfif>>Yes</option>
					</select>
				</td>
			</tr>	
			<tr id="trDatasource">
				<td style="padding-left:20px"  class="labelmedium"><cf_tl id="Entity datasource">:</td>
				<td colspan="2">						
					<cfobject action="create"
						type="java"
						class="coldfusion.server.ServiceFactory"
						name="factory">
					<!--- Get datasource service --->
					<cfset dsService=factory.getDataSourceService()>		
					<cfset dsNames = dsService.getNames()>
					<cfset ArraySort(dsnames, "textnocase")> 
								
					<select name="AccessDataSource" id="AccessDataSource" class="regularxl">						
						<option value="" <cfif get.AccessDataSource eq "">selected</cfif>></option>						
						<cfloop index="i" from="1" to="#ArrayLen(dsNames)#">
							<cfoutput>
								<option value="#dsNames[i]#" <cfif get.AccessDataSource eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
							</cfoutput>
						</cfloop>						
					</select>
				</td>
			</tr>
			<cfelse>
				<cfoutput>
					<input type="Hidden" name="AccessDataSource" id="AccessDataSource" value="">
					<input type="Hidden" name="MenuClass" id="MenuClass" value="#url.class#">
				</cfoutput>
			</cfif>
			
		</cfif>
		
		<cfset vPathRequired = "No">
		
		<!--- <cfif lcase(url.class) eq "layout" or lcase(url.class) eq "menu">
			<cfset vPathRequired = "Yes">
		</cfif> --->
		
		<tr>
			<td valign="top" style="padding-top:6px;padding-left:20px;width:20%" class="labelmedium"><cf_tl id="Landing Page">:</td>
			<td colspan="2">
				<table cellspacing="0" cellpadding="0">
					<tr>
						<td class="labelit"><cf_tl id="Directory">:</td>
						<td class="labelit"><cf_tl id="Template">:</td>
					</tr>
					
					<tr>
						<td style="padding-right:4px;" class="labelmedium">
							<cfif trim(lcase(url.systemmodule)) neq "pmobile" and (lcase(url.class) eq "layout" or lcase(url.class) eq "menu")>
					
								<cfset vDefaultDirectory = "Custom/Portal/#url.name#/">
								<cfif not DirectoryExists("#SESSION.rootpath##vDefaultDirectory#")>
									<cfdirectory action="create" directory="#SESSION.rootpath##vDefaultDirectory#">
								</cfif>
								
								<cfoutput>
									#vDefaultDirectory#
									<input type="Hidden" name="functionDirectory" id="functionDirectory" value="#vDefaultDirectory#">
								</cfoutput>
				
							<cfelse>
								<cfinput type="Text" 
									name="functionDirectory" 
									required="#vPathRequired#" 
									message="Please, enter a valid directory."
								   	class="regularxxl"
								   	size="50"
									value="#get.functionDirectory#"
								   	maxlength="80" 
									style="padding-right:2px;">
							</cfif>
						</td>
						<td style="padding-right:2px;">
							<table>
								<tr>
									<td style="padding-right:2px;">
										<cfinput type="Text" 
											name="functionPath" 
											required="#vPathRequired#"
											message="Please, enter a valid path." 
										   	class="regularxxl"
										   	size="20"
											value="#get.functionPath#"
											onblur= "ColdFusion.navigate('FileValidation.cfm?template='+document.getElementById('functionDirectory').value+this.value+'&container=pathValidationDiv&resultField=validatePath','pathValidationDiv')"
										   	maxlength="80">
									</td>
									<td valign="middle" align="left" width="50%">
									 	<cf_securediv id="pathValidationDiv" bind="url:FileValidation.cfm?template=#get.functionDirectory##get.functionPath#&container=pathValidationDiv&resultField=validatePath">				
									</td>
								</tr>
							</table>
						</td>
												
					</tr>
				</table>
				
			</td>
		</tr>
		
		<tr>	
			<td class="labelit" align="right" id="trConditionHeader"><cf_tl id="Condition">:</i></td>
			<td colspan="2" id="trCondition" style="padding-right:3px;">
				<cfinput type="Text" 
					name="functionCondition" 
					required="No" 
				   	class="regularxxl"
				   	size="55"
					value="#get.functionCondition#"
				   	maxlength="100">
			</td>
		</tr>
		
		<cfif lcase(url.class) eq "layout" and lcase(get.FunctionName) eq "logo" and lcase(getRootPortal.functionTarget) neq "html5">
		
		<tr>
			<td style="padding-left:20px" class="labelmedium"><cf_tl id="Size">:</td>
			<td colspan="2" class="labelmedium">
				<cf_tl id="Width">:
				<cfinput type="Text" 
					name="ScreenWidth" 
					required="Yes" 
					message="Please, enter a valid greater than 0 integer width." 
					validate="integer" 
					range="1,"
				   	class="regularxxl"
				   	size="1"
					value="#get.ScreenWidth#"
				   	maxlength="4" 
					style="text-align:right; padding-right:1px;">
				px. &nbsp;&nbsp; <cf_tl id="Height">:
				<cfinput type="Text" 
					name="ScreenHeight" 
					required="Yes" 
					message="Please, enter a valid greater than 0 integer height." 
					validate="integer" 
					range="1,"
				   	class="regularxxl"
				   	size="1"
					value="#get.ScreenHeight#"
				   	maxlength="4" 
					style="text-align:right; padding-right:1px;">
				px.
			</td>
		</tr>
		
		</cfif>
		
		<cfif lcase(url.class) eq "menu" or lcase(url.class) eq "process" or lcase(url.class) eq "function">
		<tr>
			<td class="labelmedium" style="padding-left:20px"><cf_tl id="Order">:</td>
			<td colspan="2">
				<cfinput type="Text" 
					name="MenuOrder" 
					required="Yes"
					message="Please, enter a valid numeric order." 
				   	class="regularxxl"
				   	size="1" 
					maxlength="3" 
					validate="integer"
					value="#get.menuOrder#" 
					style="text-align:center;">
			</td>
		</tr>
		<cfelse>
			<cfset vMenuOrder = 0>
			<cfif get.menuOrder neq "">
				<cfset vMenuOrder = get.menuOrder>
			</cfif>
			<cfoutput>
			<input type="Hidden" name="MenuOrder" id="MenuOrder" value="#vMenuOrder#">
			</cfoutput>
		</cfif>
		
		<cfif lcase(url.class) eq "process">
		<tr>
			<td class="labelmedium" style="padding-left:20px"><cf_tl id="Target">:</td>
			<td colspan="2" class="labelmedium">
				<label><input style="width:18px;height:18px" type="radio" name="FunctionTarget" id="FunctionTarget" value="right" <cfif get.FunctionTarget eq "right" or get.FunctionTarget eq "" or url.id eq "">checked</cfif>>Ajax</label>
				<label><input style="width:18px;height:18px" type="radio" name="FunctionTarget" id="FunctionTarget" value="iframe" <cfif get.FunctionTarget eq "iframe">checked</cfif>>iFrame</label>
			</td>
		</tr>
		<cfelseif lcase(url.class) neq "process" and lcase(url.class) neq "main" and lcase(url.class) neq "mission">
			<cfif trim(lcase(url.systemmodule)) neq "pmobile">
				<input type="Hidden" name="FunctionTarget" id="FunctionTarget" value="right">
			</cfif>
		</cfif>
	
		<cfif lcase(url.class) eq "main" or lcase(url.class) eq "mission" or lcase(url.class) eq "process">
		<tr>
		    <td style="padding-left:20px"  class="labelmedium"><cf_tl id="Browser">:</td>
			<td>
				<cfoutput>
				<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr>
						
						
						<td class="labelmedium"> 
							<label>
								<input style="width:18px;height:18px" type="radio" name="BrowserSupport" id="BrowserSupport" value="2" <cfif get.BrowserSupport eq "2" or url.id eq "">checked</cfif>>
								<img src="#SESSION.root#/Images/edge_icon.jpg" height="15" alt="Edge" border="0" align="absmiddle">Edge		
								&nbsp;<img src="#SESSION.root#/Images/chrome_icon.jpg" height="15" alt="Chrome" border="0" align="absmiddle">&nbsp;
								&nbsp;<img src="#SESSION.root#/Images/firefox_icon.gif" height="14" width="14" alt="Firefox (Mozilla)" border="0" align="absmiddle">&nbsp;50+							
								&nbsp;<img src="#SESSION.root#/Images/safari_icon.png" height="16" alt="Safari" border="0" align="absmiddle">&nbsp;
							</label>
						</td>		
						<td class="labelmedium">
						<label>
							<input style="width:18px;height:18px" type="radio" name="BrowserSupport" id="BrowserSupport" value="1" <cfif get.BrowserSupport eq "1">checked</cfif>>
							<img src="#SESSION.root#/Images/explorer_icon.gif" height="15" alt="Internet Explorer" border="0" align="absmiddle"> 11 only (deprecated)
						</label>
						</td>
					</tr>
				</table>
				</cfoutput>
			</td>
		</tr>
		<cfelse>
		<input type="Hidden" name="BrowserSupport" id="BrowserSupport" value="2">
		</cfif>
						
		<cfif lcase(url.class) eq "process">
		<tr>
			<td style="padding-left:20px" class="labelmedium"><cf_tl id="Enforce Reload">:</td>
			<td colspan="2">
				<input type="Checkbox" style="width:18px;height:18px" name="EnforceReload" id="EnforceReload" <cfif get.EnforceReload eq "1" or url.id eq "">checked</cfif>>
			</td>
		</tr>
		<cfelse>
			<cfoutput>
			<input type="Hidden" name="EnforceReload" id="EnforceReload" value="1">
			</cfoutput>
		</cfif>
		
		<cfif lcase(url.class) eq "process" or lcase(url.class) eq "main" or lcase(url.class) eq "mission" or (trim(lcase(url.systemmodule)) eq "pmobile" and lcase(url.class) eq "menu")>
		<tr>
		    <td style="padding-left:20px" class="labelmedium"><cf_tl id="Anonymous Access">:</td>
	    	<td colspan="2" class="labelmedium">
			
			<table>
			
				<tr>			   
		    	<td colspan="2" class="labelmedium">
				    <table><tr>
					<td><input type="radio" class="radiol" style="width:18px;height:18px" name="EnableAnonymous" id="EnableAnonymous" value="1" <cfif "1" eq get.EnableAnonymous>checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Yes</td>
					<td style="padding-left:8px"><input type="radio" class="radiol" style="width:18px;height:18px" name="EnableAnonymous" id="EnableAnonymous" value="0" <cfif "0" eq get.EnableAnonymous or url.id eq "">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">No</td>
					</tr></table>
				</td>
				</tr>	
			
			</table>
			
		</td>
		</tr>	
		<cfelse>
			<input type="Hidden" name="EnableAnonymous" id="EnableAnonymous" value="1">
		</cfif>
		
		<cfif lcase(url.class) eq "main" or lcase(url.class) eq "mission">
		<tr>
		    <td style="padding-left:20px" class="labelmedium"><cf_tl id="Manager email">:</td>
			<td>
				<cfoutput>
				
					<cfinput type="Text" 
						name="FunctionContact" 
						required="No"
						message="Please, enter a valid email or a list of emails separated by semicolons(;)." 
					   	class="regularxxl"
					   	size="40" 
						maxlength="80" 
						validate="regex" 
						pattern="^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+([ ]*[;.][ ]*(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5}){1,25})+)*$"
						value="#get.FunctionContact#">
						
				</cfoutput>
			</td>
		</tr>
		<cfelse>
			<input type="Hidden" name="FunctionContact" id="FunctionContact" value="">
		</cfif>
		
		<tr><td height="2"></td></tr>
		<tr>
			<td style="padding-left:20px" valign="top" class="labelmedium"><cf_tl id="Information">:</td>
			<td colspan="2">
				<cfoutput>
				<textarea name="functionInfo" style="padding:3px;font-size:13px;width:90%" rows="2" class="regular">#get.functionInfo#</textarea>	
				</cfoutput>		
			</td>
		</tr>
		<tr><td height="3"></td></tr>
		<tr><td class="line" colspan="3"></td></tr>
		<tr><td height="3"></td></tr>
		<tr>
			<td colspan="3" align="center">			
				<cfif (url.class eq "Main" or lcase(url.class) eq "mission") and url.id neq "" and lcase(SESSION.isAdministrator) eq "yes">
					<cfoutput>
						<cf_tl id="Remove" var="1">
						<cfinput type="Button" class="button10g" style="width:120;height:27;font-size:12px" name="delete" id="delete" value="#lt_text#" onclick="ask('#url.class#','#url.systemmodule#','#url.functionclass#');">
					</cfoutput>
				</cfif>
				<cf_tl id="Save" var="1">
				<cfinput type="Submit" class="button10g" style="width:120;height:27;font-size:12px" name="save" id="save" value="#lt_text#" onclick="return validateFileFields();">			
			</td>
		</tr>
		
	</table>

</cfform>

<table>
	<tr class="hide"><td><iframe name="processportalheader" id="processportalheader" frameborder="0"></iframe></td></tr>
</table>
