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
<cfquery name="Objects"
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT	  O.*,
		          R.Description as ResourceName, 
		          R.ListingOrder as ResourceOrder,
		         <cfif url.entrymode eq "edition">
				 (SELECT ObjectCode      FROM Ref_AllotmentEditionFundObject WHERE EditionId = '#url.editionId#' AND Fund = '#url.fund#' AND ObjectCode = O.Code) as Selected,
				 (SELECT RequirementDate FROM Ref_AllotmentEditionFundObject WHERE EditionId = '#url.editionId#' AND Fund = '#url.fund#' AND ObjectCode = O.Code) as RequirementDate,
				 (SELECT RequirementEntryMode FROM Ref_AllotmentEditionFundObject WHERE EditionId = '#url.editionId#' AND Fund = '#url.fund#' AND ObjectCode = O.Code) as RequirementEntryMode
				
				 <cfelse>
			 	 (SELECT ObjectCode            FROM Ref_AllotmentEditionFundObject WHERE EditionId = '#url.editionId#' AND Fund = '#url.fund#' AND ObjectCode = O.Code) as EditionSelected,
				 (SELECT RequirementDate       FROM Ref_AllotmentEditionFundObject WHERE EditionId = '#url.editionId#' AND Fund = '#url.fund#' AND ObjectCode = O.Code) as EditionRequirementDate,			
				 (SELECT ObjectCode            FROM ProgramAllotmentObject WHERE ProgramCode = '#url.programcode#' and Period = '#url.period#' AND EditionId = '#url.editionId#' AND Fund = '#url.fund#' AND ObjectCode = O.Code) as Selected,
				 (SELECT RequirementDate       FROM ProgramAllotmentObject WHERE ProgramCode = '#url.programcode#' and Period = '#url.period#' AND EditionId = '#url.editionId#' AND Fund = '#url.fund#' AND ObjectCode = O.Code) as RequirementDate, 
				 (SELECT RequirementEntryMode FROM Ref_AllotmentEditionFundObject WHERE EditionId = '#url.editionId#' AND Fund = '#url.fund#' AND ObjectCode = O.Code) as RequirementEntryMode				
				 </cfif>
		FROM  	 Ref_Object O, Ref_Resource R
		WHERE  	 O.ObjectUsage = '#url.ObjectUsage#'
		AND      R.Code = O.Resource		
		AND      O.RequirementEnable IN ('1','2')				
		ORDER BY R.Listingorder, 
		         R.Description, O.HierarchyCode
</cfquery>

<cfform name="frmFundObject" 
		action="FundObjectSubmit.cfm?systemfunctionid=#url.systemfunctionid#&period=#url.period#&editionId=#url.editionId#&objectUsage=#url.ObjectUsage#&fund=#url.fund#&entrymode=#url.entrymode#&programcode=#url.programcode#" 
		method="POST">
	
	<table width="98%" cellspacing="0" cellpadding="0" class="navigation_table">

		<tr class="line labelmedium">
			<td width="2%" align="center"></td>			
			<td style="padding-left:5px;"><cf_tl id="Code"></td>
			<td><cf_tl id="Description"></td>
			<td style="padding-left:7px;"><cf_tl id="Cut-off date"><cf_space spaces="50"></td>
			<cfif url.entrymode neq "program">
				<td style="padding-left:7px;"><cf_tl id="Entry"><cf_space spaces="6"></td>
			</cfif>
			<cfif url.entrymode eq "program">
			<td align="center" style="padding-left:3px;"><cf_tl id="Edition Default"></td>
			<cfelse>
			<td></td>
			</cfif>
		</tr>		
		
		<cfoutput query="Objects" group="ResourceOrder">
		
		<tr class="line">
			<td colspan="5" class="labellarge" style="height:40px">#ResourceName#</td>
		</tr>
		
		<cfoutput>
									
				<cfset vColor = "">
				<cfif code eq selected>
					<cfset vColor = "##ffffAf">
				</cfif>
				
				<cfset vCodeId = replace(Code," ","","ALL")>
				<cfset vCodeId = trim(vCodeId)>
				<cfset vCodeId = replace(vCodeId,'-','',"ALL")>
				
				<tr class="navigation_row line labelmedium">
					<td align="center" style="min-width:50px;padding-left:5px;background-color:#vColor#;height:32px">
									
						<input type="Checkbox" style="width:15px;height:15px"
						  class="radiol clsCBObject" 
						  name="cb_#trim(vCodeId)#" 
						  value="#vCodeId#" 
						  onclick="selectObject(this,'#vCodeId#');" 
						  id="cb_#vCodeId#" <cfif code eq selected>checked</cfif>>
						  
					</td>				
					<td style="height:20px;padding-left:5px; background-color:#vColor#;">#CodeDisplay#</td>
					<td style="background-color:#vColor#;">#Description#</td>
					
					<cfset vShowDate = "">						
					<cfif code neq selected>
						<cfset vShowDate = "display:none;">
					</cfif>
					
					<td>
						<table>
						<tr>
						<td style="background-color:#vColor#; padding-left:3px;#vShowDate#" class="clsReqDate_#vCodeId#">
						
							<table>
							<tr>
							<td>
													
							
							<cfif isValid("integer",Objects.RequirementDate)>		
							
								<cf_intelliCalendarDate9
									FieldName="RequirementDate_#vCodeId#"
									Message="Select a valid Requirement Date for #code#"
									class="regularxl"														
									Default=""
									AllowBlank="True">		
								
									<cfset per = Objects.RequirementDate>
								
							<cfelse>
							
								<cfset vDate = dateformat(Objects.RequirementDate, CLIENT.DateFormatShow)>
													
								<cf_intelliCalendarDate9
									FieldName="RequirementDate_#vCodeId#"
									Message="Select a valid Requirement Date for #code#"
									class="regularxl"														
									Default="#vDate#"
									AllowBlank="True">	
								
									<cfset per="">									
														
							</cfif>	
								
							</td>
							
							<cfif url.entrymode eq "program"> 
							
								<td style="padding-left:4px;padding-right:4px">- or -</td>
								<td>
								
								<select name="RequirementPercentage_#vCodeId#" id="RequirementPercentage_#vCodeId#" class="regularxl">
								<option value="">n/a</option>
								<cfloop index="itm" from="100" to="0" step="-1">
								<option value="#itm#" <cfif itm eq per>selected</cfif>>#itm#</option>
								</cfloop>
								</select>
														
								</td>
								<td style="padding-left:2px">%</td>
							
							</cfif>
							
							</tr>
							</table>								
																											
						</td>
						</tr>
						</table>
					</td>
					
					<cfif url.entrymode neq "program">
					
					<td style="background-color:#vColor#; padding-left:3px;#vShowDate#" class="clsReqDate_#vCodeId#">							
							
							<input type="checkbox" 
							  name="RequirementMode_#vCodeId#" value="0" <cfif RequirementEntryMode eq "1">checked</cfif>
							   class="regularxl radiol" 
							   Message="Disable requirement entry">
							
					</td>	
																	
					</cfif>		
					
					<cfif url.entrymode eq "program">
					
					    	<td align="center" bgcolor="D9FFD9" class="labelmedium" style="padding-left:3px;">
							<cfif Objects.EditionRequirementDate eq "">
							<cf_tl id="None">
							<cfelse>
							#dateformat(Objects.EditionRequirementDate, CLIENT.DateFormatShow)#
							</cfif>							
							</td>
							
					</cfif>
					
				</tr>
				
		</cfoutput>
		
		</cfoutput>
		
		<tr><td height="5"></td></tr>
					
		<tr class="hide">
			<td colspan="4" align="center" style="padding-bottom:5px">
				<cfoutput>					
					<input type="submit" style="width:200px;height:30px" name="btnSubmit" id="btnSubmit" value="#lt_text#">
				</cfoutput>
			</td>
		</tr>
		
		
		
	</table>
</cfform>

<cfset AjaxOnLoad("doHighlight")>
<cfset AjaxOnLoad("doCalendar")>