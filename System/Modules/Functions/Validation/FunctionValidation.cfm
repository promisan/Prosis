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
<cfquery name="qFunction" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM   	Ref_ModuleControl
		WHERE  	SystemFunctionId = '#URL.ID#'
</cfquery>

<cfquery name="qValidation" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	V.*,
				(SELECT ValidationCode FROM Ref_ModuleControlValidation WHERE SystemFunctionId = '#qFunction.SystemFunctionId#' AND ValidationCode = V.ValidationCode) as Selected
	    FROM   	Ref_Validation V
		WHERE  	V.SystemModule = '#qFunction.SystemModule#'
</cfquery>

<cfform name="frmValidation" method="POST" action="Validation/FunctionValidationSubmit.cfm?id=#URL.ID#" target="contentbox1">

	<table width="95%" align="center" class="navigation_table formpadding">
		
		<tr><td height="10"></td></tr>
		
		<tr class="labelmedium line">
			<td align="center"></td>
			<td><cf_tl id="Code"></td>
			<td><cf_tl id="Name"></td>
			<td><cf_tl id="Method"></td>
			<td align="center"><cf_tl id="Scope"></td>
		</tr>
		
		<cfoutput query="qValidation">
		
			<tr class="labelmedium navigation_row line">
				<td align="center" width="5%">
					<input 
						type="Checkbox" 
						name="vc_#ValidationCode#" 
						id="vc_#ValidationCode#" 
						class="radiol" 
						onclick="selectValidation(this,'.clsDetail_#validationCode#');" 
						<cfif validationCode eq Selected>checked</cfif>>
				</td>
				<td>#ValidationCode#</td>
				<td>#ValidationName#</td>
				<td>#ValidationMethod#</td>
				<td align="center">#ValidationScope#</td>
			</tr>
			<cfset vShow = "display:none;">
			<cfif validationCode eq Selected>
				<cfset vShow = "">
			</cfif>
			<tr class="clsDetail_#validationCode#" style="#vShow#">
				<td></td>
				<td colspan="4">
					<table width="100%" align="center">
						<cfquery name="get" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT 	*
							    FROM   	Ref_ModuleControlValidation
								WHERE  	SystemFunctionId = '#URL.ID#'
								AND		ValidationCode = '#ValidationCode#'
						</cfquery>
						<tr>
							<td>
								<table>
									<tr>
										<td class="labelit"><cf_tl id="Order">:</td>
										<td>
											<cf_tl id="Please enter a numeric order for" var="1">
											<cfinput 
												type="Text" 
												name="order_#validationCode#" 
												id="order_#validationCode#" 
												required="no" 
												message="#lt_text# #validationCode#" 
												value="#get.ListingOrder#" 
												class="regularxl" 
												size="2" 
												validate="integer" 
												style="text-align:center;">
										</td>
									</tr>
								</table>
							</td>
							<td>
								<table>
									<tr>
										<td class="labelit"><cf_tl id="Class">:</td>
										<td>
											<select class="regularxl" name="class_#validationCode#" id="class_#validationCode#">
												<option value="Alert" <cfif get.ValidationClass eq "Alert">selected</cfif>><cf_tl id="Alert">
												<option value="Stopper" <cfif get.ValidationClass eq "Stopper">selected</cfif>><cf_tl id="Stopper">
											</select>
										</td>
									</tr>
								</table>
							</td>
							<td>
								<table>
									<tr>
										<td class="labelit"><cf_tl id="Enabled entities">:</td>
										<td>
											<cfquery name="missionList" 
												datasource="AppsOrganization" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												   	SELECT 	M.*,
															(
																SELECT 	Mission
																FROM	System.dbo.Ref_ModuleControlValidationMission
																WHERE	SystemFunctionId = '#url.id#'
																AND		ValidationCode = '#ValidationCode#'
																AND		Mission = M.Mission	) as SelectedMission
													FROM 	Ref_Mission M
													WHERE	M.Mission IN (SELECT Mission FROM Ref_MissionModule WHERE SystemModule = '#qFunction.SystemModule#')
											</cfquery>
											<table width="100%">
												<tr>
													<cfset cnt = 0>
													<cfloop query="missionList">
														<td width="33%">
															<table>
																<tr>
																	<td style="padding-left:20px;"><input type="Checkbox" value="#Mission#" name="mission_#missionList.mission#_#qValidation.validationCode#" id="mission_#missionList.mission#_#qValidation.validationCode#" class="regularxl" <cfif mission eq selectedMission>checked</cfif>></td>
																	<td class="labelit" style="padding-left:5px;">#Mission#</td>
																</tr>
															</table>
														</td>
														<cfset cnt = cnt+1>
														<cfif cnt eq 8>
															<cfset cnt = 0>
															</tr>
															<tr>
														</cfif>
													</cfloop>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
		</cfoutput>
		
		<tr><td height="5"></td></tr>
		<tr>
			<td align="center" colspan="5">
				<cf_button2 type="submit" text="   Save   ">
			</td>
		</tr>
	</table>

</cfform>

<cfset AjaxOnLoad("doHighlight")> 