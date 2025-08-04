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

<cf_screentop height="100%" 
              label="Transfer Requirements" 
			  option="Move a budget requirement to a different program / project" 
			  banner="blue" 
			  scroll="Yes" 
			  margin="7"
			  user="Yes" 
			  html="Yes"
			  jquery="Yes"
			  layout="webapp"> 
			  
<cf_dialogREMProgram>

<script>

function validate() {
	document.formmove.onsubmit() 
	if( _CF_error_messages.length == 0 ) {       
	    Prosis.busy('yes')  	    
		ptoken.navigate('RequirementMoveSubmit.cfm','process','','','POST','formmove')
	 }   
}	 
</script>

	
<table width="100%" height="100%">

<cfif url.ids eq "">
			
		<tr><td height="8" align="center" class="labelmedium">No requirements selected</td></tr>
			
<cfelse>			

	<cfset row = 0>
	
		<cfoutput>
		
		<tr colspan="2" class="xhide"><td id="process"></td></tr>
		
		<tr>
		
			<!--- summary --->
						
			<td height="100%" style="border-right:1px solid silver;padding-left:10px;padding-right:10px" valign="top" width="100">
			
			<cf_space spaces="70">
			
			<table width="100%" cellspacing="0" cellpadding="0" align="center">
			
				<tr><td class="labelmedium" height="30" style="padding-left:5px"><cf_tl id="FROM"></td></tr>
								
				<tr><td id="programfrom" style="padding-left:10px;padding-right:10px">
				
					<cfset url.history = "No">
					<cfset url.summarymode = "Program">		
					<cfset url.editionid   = url.editionid>		
					<cfinclude template="../Request/RequestSummary.cfm">
				
				</td></tr>
				
					 <cfquery name="Edition" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT     *
						FROM       Ref_AllotmentEdition
						WHERE      EditionId = '#url.editionid#'	   
					</cfquery>
				
				<tr><td class="labelmedium" height="30" style="padding-left:5px;font-weight:200">
				
				<a title="View Budget Inquiry" href="javascript:AllotmentInquiry(document.getElementById('programcode').value,'','#url.Period#','budget','#edition.Version#')">
				<cf_tl id="TO Destination">
				</a></td></tr>
				<tr><td class="line"></td></tr>
				<tr><td id="programtarget"></td></tr>
			
			</table>
					
			</td>
		
			<!--- selection --->
		
		    <td valign="top" width="90%" >
						
			<cfform action="RequirementMoveSubmit.cfm" name="formmove" onsubmit="return false" method="POST" style="height:100%">
			
				<table width="96%" class="formpadding" align="center">
				
				<tr><td height="8"></td></tr>
				<tr class="line"><td style="font-size:18px;font-weight:200" colspan="7" class="labellarge"><cf_tl id="Selected Financial Requirements"></td></tr>
				<tr><td height="8"></td></tr>
													
				<cfloop index="id" list="#url.ids#">
				
				   <cfquery name="Req" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT     *
							FROM       ProgramAllotmentRequest
							WHERE      RequirementId = '#id#'	   
							AND        ProgramCode = '#url.ProgramCodeFrom#'
					</cfquery>
				
					<cfif req.recordcount eq "1">					
					
						<cfset row = row+1>
						
						<tr class="line labelmedium">
								<td class="cellcontent">#row#.<cf_space spaces="10"></td>
								
								<td><cf_space spaces="10">
								<input type="checkbox" id="requirementid" name="requirementid" value="#id#" checked>
								</td>					  
							 
								 <cfquery name="Edition" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT     *
									FROM       Ref_AllotmentEdition
									WHERE      EditionId = '#req.editionid#'	   
								</cfquery>
								
								<td style="padding-right:3px">#Req.RequestType#</td>
								<td style="padding-right:3px">#Req.RequestDescription#</td>		
								<td style="padding-right:3px">
								<cfif Req.PositionNo neq "">
								
								<cfquery name="getPosition" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT     *
									FROM       Ref_AllotmentEditionPosition
									WHERE      EditionId = '#req.editionid#'	   
									AND        PositionNo = '#Req.PositionNo#'
								</cfquery>
								
								#GetPosition.SourcePostNumber# #getPosition.FunctionDescription#
								
								</cfif>
								</td>				
								<td style="padding-right:3px">#Req.RequestQuantity#</td>
								
						        <td align="right"><cf_space spaces="40">#numberformat(Req.RequestAmountBase,",.__")#</td>
						</tr>
					
					</cfif>	
				
				</cfloop>
							
				
				<tr class="line"><td colspan="7" class="labelmedium" style="padding-top:10px;height:30px;font-size:18px;font-weight:200"><cf_tl id="Move to">:</td></tr>
				
				<tr>
				 <td></td>
				 <td height="25" class="labelmedium"><cf_tl id="Unit">:</td>
				 <td colspan="6" style="padding-left:3px">
				 
				 	 <cfquery name="Root" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT     DISTINCT O.*
							FROM       ProgramPeriod Pe, Organization.dbo.Organization O
							WHERE      Pe.Orgunit = O.OrgUnit
							AND        ProgramCode = '#url.ProgramCode#'
							AND        Period      = '#url.Period#'						
					   </cfquery>
					   
					   <cfinvoke component="Service.Access"  
						Method         = "budget"					
						Period         = "#url.period#"		
						EditionId      = "#req.editionid#" 		
						Mission        = "#edition.mission#"	
						Role           = "'BudgetManager'"
						ReturnVariable = "BudgetManagerAccess">		
						
										 
				       <cfquery name="Unit" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT     DISTINCT O.*
							FROM       ProgramPeriod Pe, Organization.dbo.Organization O
							WHERE      Pe.Orgunit = O.OrgUnit
							AND        Period = '#req.Period#'
							
							<!--- prevent move to a unit without requirements
							 	AND        ProgramCode IN (SELECT ProgramCode
							                               FROM   ProgramAllotment 
										     			   WHERE  EditionId = '#req.EditionId#'
												    	   AND    Period    = '#url.Period#'
													       AND    ProgramCode = Pe.ProgramCode) --->
														   
							<cfif BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL">
								<!--- nada --->
							<cfelse>							   
								AND        O.HierarchyRootUnit = '#root.HierarchyRootUnit#'
							</cfif>
							AND        O.Mission   = '#root.mission#'
							AND        O.MandateNo = '#root.MandateNo#'					   
													   
							ORDER BY HierarchyCode						   
					   </cfquery>
					   				   
					   <select name="orgunit" id="orgunit" class="regularxl">
						   <cfloop query="Unit">
						   <option value="#OrgUnit#" <cfif orgunit eq Root.Orgunit>selected</cfif>>#OrgUnitCode# #OrgUnitName#</option>
						   </cfloop>				   
					   </select>					
				 
				 </td>
				</tr>
				
				<tr>
				  <td></td>
				  <td class="labelmedium" style="padding-right:20px" height="25"><cf_tl id="Program">:</td>
				  <td colspan="6" style="padding-left:3px">
				      <cfdiv bind="url:RequirementMoveProgram.cfm?orgunit={orgunit}&period=#req.Period#&programcode=#url.programcode#&editionid=#url.editionid#" id="program">			  			  
				  </td>
				</tr>
				
				<!--- Period --->
				
				<tr><td></td>
				    <td class="labelmedium" height="25"><cf_tl id="Period">:</td>
					<td class="labelmedium" colspan="6" style="padding-left:3px">#Req.Period#
					<input type="hidden" name="Period" id="Period" value="#Req.Period#">
					</td>
				</tr>
				
				<tr class="hide"><td></td>
				    <td class="labelmedium"><cf_tl id="Edition">:</td>
					<td colspan="6">	
					<input type="hidden" name="ProgramCodeFrom" id="ProgramCodeFrom" value="#url.ProgramCodeFrom#">						
					<input type="hidden" name="EditionId" id="EditionId" value="#Req.EditionId#">
					</td>
				</tr>
							
				<tr>
				  <td></td>
				  <td class="labelmedium" height="25"><cf_tl id="Fund">:</td>
				  <td colspan="6" style="padding-left:3px">			  
								  
					<cfquery name="FundList" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      Ref_Fund	
						WHERE     Code IN (SELECT Fund 
						                   FROM   Ref_AllotmentEditionFund WHERE EditionId = '#req.editionid#')
					</cfquery>
					
					 <select name="Fund" id="Fund" class="regularxl">
					       <option value=""><cf_tl id="Existing fund"></option>
						   <cfloop query="FundList">
						   <option value="#Code#">#Code#</option>
						   </cfloop>				   
					   </select>					
				   
				  
				  </td>
				</tr>
							
				<tr><td class="line" colspan="7"></td></tr>
				
				<tr><td align="right" colspan="7" style="padding:6px">			
				<input type="submit" name="Submit" class="button10g" value="Submit" onclick="validate()">
				
				</td>
				</tr>	
									
			</table>
			
		</cfform>		
		
		</td>	
		
		</tr>
		
		</cfoutput>
		
</cfif>		

</table>

