
<cf_divscroll>

<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr>	
		<td height="10" colspan="3" class="header">
		
				<table width="100%" align="right" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
							
				<tr><td class="labelmedium" colspan="7">
				The purpose of the below important mapping function is to associate an execution period for a mission to a staffing table period which holds the organizational structure, a default GL Account period, a Program plan period under which the budget planning for this execution period is recorded and the edition that will hold the data.								
				</td></tr>
				
				<tr><td class="labelmedium" style="padding-top:3px" colspan="7"><font color="FF0000"><b><u>Important<u></b> : if the [staffing period] is amendment for a period that already commenced, <u>YOU MUST check with Promisan representatives to verify if
				any datafix has to be applied to the Program/Project, Supply chain and/or Financials datastore</font></td></tr>
												
				<tr class="line">
				<td style="height:35px" class="cellcontent">Entity</td>				
				<td class="cellcontent">Staffing Period</td>						
				<td class="cellcontent">Plan Period</td>	
				<td class="cellcontent">Enf.Plan</td>		
				<td class="cellcontent">Procurement Budget Execution Edition</td>
				<cfif Operational eq "1">
				<td class="cellcontent">Ledger Per.</td>
				</cfif>
				<td class="cellcontent">Def.</td>
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
																					
				<tr class="navigation_row line" style="height:40px">
				   <td style="padding-left:3px" class="labelmedium">#Mission#</td>
				  				   
				   <cfif used.recordcount gte "1">
				   
					   <input type="hidden" name="mandate_#ln#" value="#Period.MandateNo#">
					   <td class="labelmedium">#Period.MandateNo# (#Period.Description#)</td>
				   
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
					   				  				 
					   <select name="mandate_#ln#" style="width:130px" class="regularxl">
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
												  
						</cfquery>
						
						<cfif PlanningList.recordcount eq "0">
						
							<td colspan="3" class="labelit">
							 
						      <font color="black">Record at least one (1) program/project for #Mission# first under the plan period.</font>
							  
							</td>
																					
							 <input type="hidden" name="PlanningPeriod_#ln#" value="">
							 <input type="hidden" name="EditionId_#ln#" value="">
							 <input type="hidden" name="isPlanPeriod_#ln#" value="0">											 
						
						<cfelse>	
											
						   <td>								   		   		 
								
							   <select name="PlanningPeriod_#ln#" class="regularxl" 							         
									  style="width:70px" 
									  onchange="ptoken.navigate('RecordEditEdition.cfm?ln=#ln#&mission=#mission#&prior=#period.editionid#&period='+this.value,'budget_#ln#')">							   
							  
							   <cfloop query="PlanningList">
							   <option value="#Period#" <cfif Period eq Period.PlanningPeriod or Period eq url.id1>selected</cfif>>#Period#</option>
							   
							   	<cfif Period eq Period.PlanningPeriod or Period eq url.id1>
									   <cfset per = period>
								</cfif>   
							   
							   </cfloop>
							   </select>	
							   						   
						   </td>
						   
						    <td class="cellcontent">
							   <cfif get.isPlanningPeriod eq "1">
							   
							   		Yes
								   <input type="hidden" name="isPlanPeriod_#ln#" value="1">
							   
							   <cfelse>
							   							   
								   <select name="isPlanPeriod_#ln#" class="regularxl">
							   		<option value="0" <cfif Period.isPlanPeriod eq "0">selected</cfif>>No</option>
								    <option value="1" <cfif Period.isPlanPeriod eq "1">selected</cfif>>Yes</option>			 
								   </select>	   
							   
							   </cfif>
						   </td>
							 		
						   <td id="budget_#ln#" style="padding-left:2px">
						   
							   <table cellspacing="0" cellpadding="0">
							   <tr><td class="cellcontent">
							   
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
									
									<tr><td colspan="2" align="center" class="cellcontent"><font color="FF8080">Invalid budget period.</font></td></tr>							
									
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
						  <select name="accountperiod_#ln#" class="regularxl">
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
			</td></tr>
			
			<tr>
			<td colspan="3">		
			    <cf_dialogBottom option="edit">
			</td>
</tr>		
			
</table>		

</cf_divscroll>	