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

<cf_divscroll>

<table width="100%">
	
	<tr>	
		<td height="10" colspan="3" class="header" style="border-top:1px solid silver">
		
		<table width="100%" align="right" class="navigation_table">
						
			<tr><td class="labelmedium2" colspan="7" style="padding:4px">
			The purpose of the below mapping is to associate an execution period for an entity to 1. a staffing table period which holds the organizational structure, 2. a default GL Account period and 3. a Program plan period under which the planning for this execution period is recorded & the budget edition to hold it.								
			</td></tr>
			
			<tr><td class="labelmedium2" style="padding:4px" colspan="7"><font color="FF0000"><b><u>Important<u></b> : if the [staffing period] is an amendment for a period that already commenced, <u>YOU MUST check with Promisan representatives to verify if
			any datafix has to be applied to the Program/Project, Supply chain and/or Financials datastore</font></td></tr>
				
			<tr><td style="height:10px"></td></tr>								
			<tr class="line labelmedium2 fixlengthlist">
			<td>Entity</td>				
			<td>Staffing Period</td>						
			<td>Plan Period</td>	
			<td>Enf.Plan</td>		
			<td>Procurement Budget Execution Edition</td>
			<cfif Operational eq "1">
			<td>Ledger Per.</td>
			</cfif>
			<td>Def.</td>
			</tr>
															
			<cfoutput query="MissionSelect">
							
			<!--- check if this period is already used in program in that case
			you are not allowed to change anymore --->
			
			<cfquery name="Used" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   TOP 1 Period 
		    FROM     Program.dbo.ProgramPeriod 
			WHERE    Period = '#URL.ID1#'
			AND      OrgUnit IN (SELECT OrgUnit 
			                     FROM   organization.dbo.Organization 
								 WHERE  Mission = '#mission#')
			</cfquery>
			
			<cfquery name="Period" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT P.*, 
				       M.Description
				FROM   Ref_MissionPeriod P, 
				       Ref_Mandate M
				WHERE  P.Period    = '#URL.ID1#'
				AND    P.Mission   = '#Mission#'
				AND    M.Mission   = P.Mission
				AND    M.MandateNo = P.MandateNo					
			</cfquery>							
							
			<cfset ln = ln + 1>
			
			<input type="hidden" name="mission_#ln#" value="#Mission#">				
																				
			<tr class="fixlengthlist navigation_row <cfif currentrow neq recordcount>line</cfif> labelmedium2">
			   <td style="padding-left:3px">#Mission#</td>
			  				   
			   <cfif used.recordcount gte "1">
			   
				   <input type="hidden" name="mandate_#ln#" value="#Period.MandateNo#">
				   <td>#Period.MandateNo# (#Period.Description#)</td>
			   
			   <cfelse>
			   
			   	<td>
				   <cfquery name="Mandate" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_Mandate
						WHERE  Mission = '#Mission#'
				   </cfquery>
				   				  				 
				   <select name="mandate_#ln#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
					   <option value="">N/A</option>
					   <cfloop query="Mandate" >
					      <option value="#Mandate.MandateNo#" <cfif Period.MandateNo eq Mandate.MandateNo>selected</cfif>>#MandateNo# (#Description#)</option>
					   </cfloop>
				   </select>
				   
				   </td>
			   
			   </cfif>
			   
			   <!--- show only plan periods that have already one or more program or projects defined --->
			   				   				   		  
				   <cfquery name="PlanningList" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT DISTINCT Period
							FROM   ProgramPeriod
							WHERE  ProgramCode IN (SELECT ProgramCode
							                       FROM   Program 
												   WHERE  Mission = '#Mission#')
							AND    (
							       Period IN (SELECT Period 
							                  FROM   Ref_Period 
											  WHERE  isPlanningPeriod = 1)
									OR 										
									Period = '#Period.PlanningPeriod#'		  
									)
							UNION 
							
							SELECT Period
							FROM   Ref_Period
							WHERE  Period = '#url.id1#'  		
											  
					</cfquery>
					
					<cfif PlanningList.recordcount eq "0">
					
						<td colspan="3" title="Record at least one (1) program/project for #Mission#">
						 
					      <font color="black">Record at least one (1) program/project for #Mission#.</font>
						  
						</td>
																				
						 <input type="hidden" name="PlanningPeriod_#ln#" value="">
						 <input type="hidden" name="EditionId_#ln#"      value="">
						 <input type="hidden" name="isPlanPeriod_#ln#"   value="0">											 
					
					<cfelse>	
										
					   <td>								   		   		 
							
						   <select name="PlanningPeriod_#ln#" 
						          class="regularxl" 
								  style="border:0px;border-left:1px solid silver;border-right:1px solid silver"							         									  
								  onchange="ptoken.navigate('RecordEditEdition.cfm?ln=#ln#&mission=#mission#&prior=#period.editionid#&period='+this.value,'budget_#ln#')">							   
						  
						   <cfloop query="PlanningList">
						   <option value="#Period#" <cfif Period eq Period.PlanningPeriod or Period eq url.id1>selected</cfif>>#Period#</option>
						   
						   	<cfif Period eq Period.PlanningPeriod or Period eq url.id1>
								   <cfset per = period>
							</cfif>   
						   
						   </cfloop>
						   </select>	
						   						   
					   </td>
					   
					    <td>
						   <cfif get.isPlanningPeriod eq "1">
						   
						   		Yes
							   <input type="hidden" name="isPlanPeriod_#ln#" value="1">
						   
						   <cfelse>
						   							   
							   <select name="isPlanPeriod_#ln#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
						   		<option value="0" <cfif Period.isPlanPeriod eq "0">selected</cfif>>No</option>
							    <option value="1" <cfif Period.isPlanPeriod eq "1">selected</cfif>>Yes</option>			 
							   </select>	   
						   
						   </cfif>
					   </td>
						 		
					   <td id="budget_#ln#" style="padding-left:2px">
					   
						   <table>

						   <tr class="labelmedium2">
							   <td>
						   
							   <cfset url.mission = mission>
							   <cfset url.ln         = ln>
							   <cfset url.prior      = period.editionid>		
							   <cfset url.prioralt   = period.editionidAlternate>		
							   						 						 
							   <cfif Period.PlanningPeriod neq "">
								   <cfset url.period  = Period.PlanningPeriod>								      
							   <cfelse>
							       <cfset url.period  = url.id1>
							   </cfif>	   								  
							   
							   <cfinclude template="RecordEditEdition.cfm">								   
							   
							  </td></tr>
							  
							  <cfquery name="Check" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT *
									FROM   Ref_MissionPeriod
									WHERE  Mission = '#Mission#'
									AND    Period = '#Period.PlanningPeriod#'
								</cfquery>							
								
								<cfif Period.MandateNo neq check.MandateNo and Check.MandateNo neq "">
								
								<tr class="labelmedium2"><td colspan="2" align="center"><font color="FF8080">Invalid budget period.</font></td></tr>							
								
								</cfif>			
							  
							  
							  </table> 
						   			   
						</td>
						
					</cfif>				   			   
			 
			    <cfif Operational eq "1">
	
					<cfquery name="Per" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM Period
					</cfquery>
										  
					<td>
					  <select name="accountperiod_#ln#" class="regularxl" style="border:0px;border-left:1px solid silver;border-right:1px solid silver">
				       <option></option>
			     	   <cfloop query="Per">
			        	<option value="#AccountPeriod#" <cfif Period.AccountPeriod eq AccountPeriod>selected</cfif>>#Description#
						</option>
			         	</cfloop>
					  </select>
					
			  	 	</TD>
					
				</cfif>						  
			   
			   <td><input type="checkbox" class="radiol" name="default_#ln#" <cfif Period.DefaultPeriod eq "1">checked</cfif>></td>
			
			</tr>				
																									
			</cfoutput>
			
			<input type="hidden" name="lines" value="<cfoutput>#ln#</cfoutput>">
											
		</table>
	</td>
	</tr>
			
	<tr>
		<td colspan="3">		
		    <cf_dialogBottom option="edit">
		</td>
	</tr>		
			
</table>		

</cf_divscroll>	