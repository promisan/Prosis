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
<!---  Name: /Component/Process/Program.cfc
       Description: Program procedures      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "ProgramRoutine">
	
	<cffunction name="CreateProgram"
             access="public"
             returntype="any"
             displayname="Program">
		
		<cfargument name="Mission"            type="string" required="true"  default="">	 
		<cfargument name="ProgramName"        type="string" required="true"  default="">
		<cfargument name="ServiceClass"       type="string" required="true">
		<cfargument name="ProgramDescription" type="string" required="false" default="#ProgramName#">
		<cfargument name="Period"             type="string" required="true"  default="">
		<cfargument name="OrgUnit"            type="string" required="true"  default="0">		
		<cfargument name="Reference"          type="string" required="false" default="">
		<cfargument name="ProgramClass"       type="string" required="true"  default="">
		<cfargument name="ProgramScope"       type="string" required="true"  default="Unit">
		<cfargument name="ParentCode"         type="string" required="false" default="">
				
		<cfquery name="Check" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT * 
				 FROM   Program
				 WHERE  Mission      = '#Mission#'
				 AND    ServiceClass = '#ServiceClass#'
				 AND    ProgramName  = '#ProgramName#'
				 AND    ProgramCode IN (SELECT ProgramCode 
				                        FROM   ProgramPeriod 
										WHERE  OrgUnit = '#orgunit#' 
								         AND   Period = '#Period#') 
		</cfquery>
		
		<cfif check.recordcount eq "0">			
		
			<!--- create record --->
		   
			<cfquery name="AssignNo" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     	UPDATE Parameter SET ProgramNo = ProgramNo+1 
			</cfquery>
			
			<cfquery name="LastNo" 
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     SELECT *
				     FROM Parameter
			</cfquery>
			 
			<cfquery name="Parameter" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT *
			     FROM Ref_ParameterMission
				 WHERE Mission = '#Mission#'
			</cfquery>
						
			<cfquery name="Org" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
		     FROM   Organization.dbo.Organization
			 WHERE  OrgUnit = '#OrgUnit#'
			</cfquery>
			
			<!--- assign a default reference --->
			
			<cfquery name="Count" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Program
				 WHERE  Mission      = '#Mission#'				 
				 AND    ProgramCode IN (SELECT ProgramCode 
				                        FROM   ProgramPeriod 
										WHERE  OrgUnit = '#orgunit#' 
								         AND   Period = '#Period#') 
		   </cfquery>
		   
		   <cfset cnt = count.recordcount>
		   
		   <cfif len(cnt) eq "1">
		        <cfset cnt = "00#cnt#">
		   <cfelseif len(cnt) eq "2">
		        <cfset cnt = "0#cnt#">	  			  
		   </cfif>
		   
		   <cfset ref = "">
		   			 
		   <cfif ProgramClass eq "Program">			 
				 <cfset cde = Parameter.ProgramPrefix&LastNo.ProgramNo>	
				 <cfif len(Org.OrgUnitNameShort) lte 10>
					 <cfset ref = "#Org.OrgUnitNameShort#-P-#cnt#">
				 </cfif>
		   <cfelse>			 
			 	 <cfset cde = Parameter.ComponentPrefix&LastNo.ProgramNo>	
				 <cfif len(Org.OrgUnitNameShort) lte 10>
				    <cfset ref = "#Org.OrgUnitNameShort#-S-#cnt#">		 
				 </cfif>
		   </cfif>			
			
		   <cfif reference neq "">			
				<cfset ref = reference>			
		   </cfif>									
	 	 	
			<cfquery name="InsertProgram" 
				     datasource="AppsProgram" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				      INSERT INTO Program
				 	        (Mission,
							 ServiceClass,
							 ProgramCode,
							 ProgramDescription,
							 ProgramName,	    	 
							 ProgramClass,			
							 ProgramAllotment,			 					 
							 ProgramScope,
							 ParentCode,	
							 EnforceAllotmentRequest,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				   	 VALUES ('#Mission#',
						      '#ServiceClass#',
				 	          '#cde#',
							  '#ProgramName#',
							  '#ProgramDescription#',
					    	  '#ProgramClass#',			
							  '1',	
							  '#ProgramScope#',
							  '#ParentCode#',
							  '1',
							  '#SESSION.acc#',
				   		 	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
		     </cfquery>		 
		 
		 <cfelse>
		 
		 	<cfset cde = check.programCode>
		 
		 </cfif>
		 
		 <cfquery name="Check" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT * 
				 FROM   ProgramPeriod
				 WHERE  ProgramCode = '#cde#'
				 AND    Period = '#Period#'
		</cfquery>
		
		<cfif Check.recordcount eq "0">
	
		     <cfquery name="InsertProgram" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO ProgramPeriod
			 	        (ProgramCode,
						 Period,			
						 OrgUnitImplement,			
						 OrgUnitRequest,
						 OrgUnit,
						 Reference,			
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
			   	 VALUES ( '#cde#',
						  '#Period#',			
						  '#OrgUnit#',
						  '#OrgUnit#',
						  '#OrgUnit#',			
						  '#ref#', 			 
						  '#SESSION.acc#',
			   		 	  '#SESSION.last#',
					  	  '#SESSION.first#')
			   </cfquery>
		   
		   </cfif>
		   
		   <cfreturn cde>		
		 
   </cffunction>
   
   <!--- routine to keep the requirement and the allotment databases in sync --->
   
   <cffunction name="SyncProgramBudget"
             access="public"
             returntype="any"
             displayname="Sync Budget Requirement and Allotment">			 
					
			<cfargument name="ProgramCode"        type="string" required="true"  default="">	 
			<cfargument name="Period"             type="string" required="true"  default="">
			<cfargument name="EditionId"          type="string" required="true"  default="">
			<cfargument name="ObjectCode"         type="string" required="false" default="">	
			<cfargument name="Mode"               type="string" required="false" default="All">
			
			<!--- obtain the exchange rate at the start of the period which is being budgetted 
			as this is the value as it likely would have turned into the financials --->
			
																
			<cfquery name="getProgram" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT     *
			     FROM       ProgramPeriod Pe, Program P
				 WHERE      P.ProgramCode  = Pe.ProgramCode
			     AND        Pe.ProgramCode = '#ProgramCode#'
				 AND        Pe.Period      = '#period#' 
			</cfquery>  	
						
			<cfquery name="Parameter" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT     *
			     FROM       Ref_ParameterMission
				 WHERE      Mission = '#getProgram.Mission#'			    
			</cfquery>  	
			
			<cfset cur = parameter.BudgetCurrency>
			
			<cfquery name="getPeriod" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT     *
			     FROM       Ref_Period
				 WHERE      Period = '#period#'			    
			</cfquery>  	
			
			<cf_exchangeRate 
			    DataSource    = "AppsProgram"
				CurrencyFrom  = "#cur#" 
				CurrencyTo    = "#Application.BaseCurrency#"
				EffectiveDate = "#dateformat(getPeriod.DateEffective,CLIENT.DateFormatShow)#">
						
			<cfif Exc eq "0" or Exc eq "">
				<cfset exc = 1>
			</cfif>								
			
			
			<cfquery name="setCorrection" 
			  datasource="AppsProgram" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				UPDATE  ProgramAllotmentRequest
				SET     ActionStatus = '1'
				WHERE   ProgramCode  = '#ProgramCode#' 
				AND     Period       = '#Period#' 
				AND     EditionId    = '#EditionId#' 
				AND     ActionStatus NOT IN ('0','1') 
				AND     RequirementId IN (
	                           SELECT RequirementId
	                           FROM   ProgramAllotmentDetailRequest P, ProgramAllotmentDetail D
							   WHERE  P.TransactionId = D.TransactionId 
							   AND    Status          = '1'
							   )
			</cfquery>		
			
				
		
			<!--- 2/12/2012 routine was adjusted to calculate also the Support allotment
			for the total of the requirement --->					
					
			<!--- this routine ensure that request and budget line are kept properly in sync 
			to a large extend without affected performance too much. --->
						
			<!--- ----------------------------------------------------------------------------------------- --->
			<!--- 2.  handle detail lines of which the underlying records do not total to the lines anymore --->
			<!--- ----------------------------------------------------------------------------------------- --->
			
			<cfquery name="Check" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT     P.Status, 
				 			P.SupportPercentage,
							P.SupportObjectCode,
							P.DueCalculation,
				            E.EntryMethod, 
							E.EditionClass,
							P.AmountRounding,
							BudgetEntryMode,
							<!--- count if there are any records here at this moment for allotment --->
							(SELECT count(*)
							 FROM   ProgramAllotmentDetail 
							 WHERE  ProgramCode = P.ProgramCode 
							 AND    EditionId = P.EditionId 
							 AND    Period = P.Period) as Counted
			     FROM       Ref_AllotmentEdition E, 
				            ProgramAllotment P
			     WHERE      P.EditionId   = '#EditionId#'	
				 AND        E.EditionId   = P.EditionId
				 AND        P.ProgramCode = '#ProgramCode#'
				 AND        P.Period      = '#period#' 
			</cfquery>  	
			
			<!--- ------------------------ --->
			<!--- added by hanno 17/9/2015 --->
			<!--- ------------------------ --->	
						
			<cfif Check.DueCalculation eq "1">
											
				<!--- now we apply the percentages to the fund and period --->
	
				<cfinvoke component = "Service.Process.Program.ProgramAllotment"  
				   method           = "RequirementDue" 
				   programcode      = "#ProgramCode#" 
				   editionid        = "#editionid#" 
				   period           = "#period#">	 
			   
			 </cfif>    		
					
			<cfif Check.BudgetEntryMode eq "1" or (getProgram.EnforceAllotmentRequest eq "1" AND Check.BudgetEntryMode eq "0")> 
			
			<!--- requirements are to be recorded for this program, then we process it --->
							
			<cfif Mode eq "All">
				
				<!--- ----------------------------------------------------------------------------------------- --->
				<!--- 3. sync requests to the budget detail table based on the edition mode ------------------- --->
				<!--- ----------------------------------------------------------------------------------------- --->
				
				<cfquery name="Object" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT Code
						FROM   Ref_Object
						WHERE 
						
						( Code IN (SELECT ObjectCode 
						                FROM ProgramAllotmentRequest
										WHERE     ProgramCode = '#ProgramCode#' 
										AND       Period      = '#Period#' 
										AND       EditionId   = '#EditionId#') 
										
						 OR 
						 
						 Code IN  (SELECT ObjectCode 
						                FROM ProgramAllotmentDetail
										WHERE     ProgramCode = '#ProgramCode#' 
										AND       Period      = '#Period#' 
										AND       EditionId   = '#EditionId#') 				
						)									
										
						<!--- is not used for now, to make a full check --->		
						<cfif ObjectCode neq "">
						AND       Code  = '#ObjectCode#' 
						</cfif>						
						
				</cfquery>		
				
				<cfloop query="Object">
					
					<!--- define total ROUNDED amount requested as specified in the requirements for this object as for
					the allotment we only apply rouneded amounts 
					
					Hanno : we adjust here to define the rounded RequestAmountBase AND the AmountBaseAllotment, so we have
					2 amount of which the difference will be recorded as P versus 0
					
					--->
					
					<cfquery name="RequestLines" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							SELECT    Fund 									
							FROM      ProgramAllotmentRequest
							WHERE     ProgramCode  = '#ProgramCode#' 
							AND       Period       = '#Period#' 
							AND       EditionId    = '#EditionId#' 
							AND       ObjectCode   = '#Code#'
							AND       ActionStatus != '9'  <!--- request is valid and not blocked --->
							GROUP BY  Fund
													
							UNION
							
							SELECT    Fund
							FROM      Ref_AllotmentEditionFund
							WHERE 	  EditionId    = '#EditionId#' 
							<!--- To ensure the both sides are covered for the comparison --->
							AND       Fund NOT IN (
							                       SELECT  Fund 
							                       FROM    ProgramAllotmentRequest	
										  		   WHERE   ProgramCode  = '#ProgramCode#' 
												   AND     Period       = '#Period#' 
												   AND     EditionId    = '#EditionId#' 
												   AND     ObjectCode   = '#Code#'
												   AND     ActionStatus = 1 	
												  )	
							GROUP BY  Fund
							
					</cfquery>						
						
					<cfset obj = code>	
					
					<cfif RequestLines.recordcount gte "1">
				
						<cfloop query="requestLines">
								
							<!--- ------------  Update the ProgramAllotmentDetail table ------------------ --->
							<!--- --Define total value in the budget allotment table for object and fund-- --->
							<!--- ------------------------------------------------------------------------ --->
							
							<cfquery name="Total" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
								SELECT    ISNULL(SUM(Amount-AmountRounded),0) AS Total
								FROM      ProgramAllotmentDetail D
								WHERE     ProgramCode = '#ProgramCode#' 
								AND       Period      = '#Period#' 
								AND       EditionId   = '#EditionId#' 
								AND       ObjectCode  = '#obj#' 
								AND       Fund        = '#Fund#'
								AND       Status  IN ('P','0','1') <!--- we compare here the amount which should match the released amount --->
																
								<!--- we compare the requirement records with the transactions that are 
										 a. NOT related to a transfer/amedmnent as this takes place in the allotment only 
										 b. NOT related to calculated support cost --->   
								 
								AND       (
								         	ActionId NOT IN (SELECT ActionId 
									          	             FROM   ProgramAllotmentAction 
															 WHERE  ActionClass IN ('Transfer','Amendment')
															 AND    ActionId = D.ActionId) OR ActionId is NULL																							
										  )
										   
								AND       TransactionType = 'Standard'		
								
								 
								
							</cfquery>									
							
							<cfset tot = total.total>
																				
							<cfquery name="TotalForAllotment" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
								SELECT     ISNULL(SUM(Amount-AmountRounded),0) AS Total
								FROM       ProgramAllotmentDetail D
								WHERE      ProgramCode = '#ProgramCode#' 
								AND        Period      = '#Period#' 
								AND        EditionId   = '#EditionId#' 
								AND        ObjectCode  = '#obj#' 
								AND        Fund        = '#Fund#'
								AND        Status  IN ('0','1') <!--- we compare here the amount which should match the released amount --->
								<!---
								AND        Status      <> '9'  <!--- we combine P,0 (= different in released amount) and 1 here --->
								--->
								
								<!--- we compare the requirement records with the transactions that are 
									 a. NOT related to a transfer/amedmnent as this takes place in the allotment only 
									 b. NOT related to calculated support cost --->
								 
								AND      (
								         	ActionId NOT IN (SELECT ActionId 
									          	             FROM   ProgramAllotmentAction 
															 WHERE  ActionClass IN ('Transfer','Amendment')
															 AND    ActionId = D.ActionId) 
											OR ActionId is NULL																							
										 )
										   
								AND      TransactionType = 'Standard'		   
								
							</cfquery>		
							
							<cfset alltot = totalForAllotment.total>
														
							<!--- reset if value = 0 --->
							
							<cfquery name="reset" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									
									UPDATE    ProgramAllotmentRequest
									SET       AmountBaseAllotment = RequestAmountBase										  															
									WHERE     ProgramCode         = '#ProgramCode#' 
									AND       Period              = '#Period#' 
									AND       EditionId           = '#EditionId#' 				
									AND       ObjectCode          = '#obj#'
									AND       Fund                = '#Fund#'  	
									AND       AmountBaseAllotment = 0
									AND       ActionStatus        = '1'  <!--- only confirmed requests, not the ones that are blocked 0 or cancelled 9 --->		
															
							</cfquery>	
																					
							<!--- defined the value of the requirement  --->
							
							<cfset req = " (CASE WHEN AmountBaseAllotment > RequestAmountBase THEN AmountBaseAllotment ELSE RequestAmountBase END) ">
							
							<!--- we do a precheck if we need to calculate here --->
										
							<cfquery name="Valid" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									
								SELECT    ISNULL(SUM(#req#),0)               as AmountRequested,		
										  ISNULL(SUM(AmountBaseAllotment*AmountBasePercentageDue),0) as AmountRelease	
										  																	  							
								FROM      ProgramAllotmentRequest S
								WHERE     ProgramCode   = '#ProgramCode#' 
								AND       Period        = '#Period#' 
								AND       EditionId     = '#EditionId#' 				
								AND       ObjectCode    = '#obj#'
								AND       Fund          = '#Fund#'  	
								AND       ActionStatus  = '1'  <!--- only confirmed requests, not the ones that are blocked 0 or cancelled 9 --->		
																
							</cfquery>								
							
							<!--- determine any possible missing request -> which is not reflected as allotment transactions --->
							
							<cfquery name="HasMissingAssociations" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    TOP 1 *
								FROM      ProgramAllotmentRequest S
								WHERE     ProgramCode   = '#ProgramCode#' 
								AND       Period        = '#Period#' 
								AND       EditionId     = '#EditionId#' 				
								AND       ObjectCode    = '#obj#'
								AND       Fund          = '#Fund#'  	
								AND       ActionStatus  = '1'       <!--- only confirmed requests --->	
								AND       S.RequirementId NOT IN   <!--- associated request      --->
						                          (
												    SELECT   RequirementId
				        		                    FROM     ProgramAllotmentDetailRequest
				                		            WHERE    RequirementId = S.RequirementId
												   )						
									
							</cfquery>	
							
							<!--- determine if there are any blocked request -> allotment transactions --->				
							
							<cfquery name="hasBlocked" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    TOP 1 *
								FROM      ProgramAllotmentRequest
								WHERE     ProgramCode  = '#ProgramCode#' 
								AND       Period       = '#Period#' 
								AND       EditionId    = '#EditionId#' 				
								AND       ObjectCode   = '#obj#'
								AND       Fund         = '#Fund#'
								AND       ActionStatus = '0'   <!--- blocked --->						
							</cfquery>	
							
							<!--- total allotment <> total requirement 
							    or missing associations 
								or if we determine one or more blcoked requests, then we do a full check --->			
							
																																
							<cfif  valid.amountRequested neq tot or
							       valid.AmountRelease   neq alltot or 
							       hasMissingAssociations.recordcount gte 1 or 
								   hasBlocked.recordcount gte 1>	
								   
								  
								   	
								  <!---	checking 10/01							  
								   	<cfoutput>#check.amountrounding#--#obj#:-#valid.amountRequested#-#tot# / #valid.AmountRelease#-#alltot# : #hasMissingAssociations.recordcount#|#hasBlocked.recordcount#<br></cfoutput>																			
								  --->	
								  													   							   
									   							  		    
								  <!--- status = 0, edition has never been cleared before and has a status = draft  --->
								  						  
								  <cfset diff = valid.AmountRelease - alltot>									  	
																	  							  			  			  		
								  <cfif Check.EntryMethod eq "Snapshot"> 
								  
								    <!---  <cfoutput>#fund#---#diff#----</cfoutput> --->
								  
								    <!--- update the clearance status --->
																	
									<cfquery name="ResetHeaderStatus" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										UPDATE     ProgramAllotment
										SET        Status      = '0'
										WHERE      ProgramCode = '#programCode#'	
										AND        Period      = '#period#'    
										AND        EditionId   = '#EditionId#'
									   </cfquery>
									   
									<!--- remove prior budget records --->   
																		
									<!--- ----------------------------------------------------------- --->
									<!--- deletes also ProgramAllotmentDetailRequest mapping records --->
									<!--- ---------------------------------------------------------- --->
									
								  	<cfquery name="RemovePrior" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											DELETE FROM ProgramAllotmentDetail
											WHERE       ProgramCode = '#programCode#'	
											AND         Period      = '#period#'    
											AND         EditionId   = '#EditionId#'
											AND         ObjectCode  = '#obj#'
										    AND         Fund        = '#Fund#'
											AND         ActionId is NULL 
									</cfquery>		
									
																
									
									<cf_assignid>
												
									<cfquery name="InsertAmount" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										
										INSERT INTO ProgramAllotmentDetail
												(TransactionId,
												 ProgramCode, 
												 Period,
												 EditionId,
												 TransactionDate, 
												 Currency,
												 Amount,
												 ExchangeRate,
												 AmountBase,
												 Fund,
												 ObjectCode,
												 OrgUnit,
												 Status,
												 OfficerUserId, 
												 OfficerLastName, 
												 OfficerFirstName)
										VALUES ('#rowguid#',    
										        '#ProgramCode#', 
										        '#Period#', 
										        '#Editionid#', 
												getDate(), 
												'#cur#',
												#releaseamt#,
												'#exc#',
												#round(releaseamt*100/exc)/100#,
												<!--- enter full amount as allotment was cleared --->
												'#Fund#',
												'#Object.Code#',
												'#getProgram.OrgUnit#',
												'0',   <!--- to be cleared --->
												'#SESSION.acc#', 
												'#SESSION.last#', 
												'#SESSION.first#') 
										  </cfquery> 
										  
										  <!--- ---------------------------------- --->
										  <!--- mapping records and update amounts --->
										  <!--- ---------------------------------- --->					  
										  
										  <cfquery name="InsertBudgetRequestValid" 
											datasource="AppsProgram" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											INSERT INTO ProgramAllotmentDetailRequest
												        (TransactionId, RequirementId,Amount)
											SELECT      '#rowguid#', RequirementId, AmountBaseAllotment*AmountBasePercentageDue  <!--- to be adjusted --->
											FROM        ProgramAllotmentRequest R
											WHERE       ProgramCode = '#ProgramCode#' 
											AND         Period      = '#Period#' 
											AND         EditionId   = '#EditionId#' 
											<!--- 16/11 : to be adjusted as we now have a situation that amounts will be incrementally alloted --->
											AND         RequirementId NOT IN (SELECT Requirementid 
											                                  FROM   ProgramAllotmentDetailRequest
																			  WHERE  RequirementId = R.RequirementId)
											AND         Fund        = '#Fund#'
											AND         ObjectCode  = '#obj#'   
											AND         ActionStatus = '1' <!--- exclude blocked and cancelled --->  			
										</cfquery>		
																					
								<cfelse>
																  
								  	<!--- transactional, means detail will be reflected one by one in lines to be approved once an edition is in place --->
								  						
									<!--- remove mapping records if the mapping refers to a transaction that is not cleared --->	
																
									<!--- check if the total of the source matches to the created allotment record
									and if this does not match we adjust the allotmnet amount, remove the actionid and reset the status = 0								
									--->	
									
									<cfquery name="ClearAnyMappingForPendingBudget" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">																									
					                         DELETE FROM ProgramAllotmentDetail
											 WHERE  ProgramCode = '#programCode#'	
											 AND    Period      = '#period#'    
											 AND    EditionId   = '#EditionId#'
										     AND    ObjectCode  = '#Obj#'
											 AND    Fund        = '#Fund#'		
											 AND    Status      IN ('P','0')	
											 
															
									</cfquery>		
									
									<!--- ---------------------------------------------------------------------------------- --->
									<!--- 1/2 re-determine which are the mapping records missing for the requirement records --->			
									<!--- ---------------------------------------------------------------------------------- --->
									
									<!--- req : if the allotment amout is bigger we take the allotment amount as the bases for posting --->
									
									<cfquery name="getRequirementsForAllotment" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">		
											
											SELECT  RequirementId,
											
													<!--- we should not round here but on the aggregated line 692 --->
													
													#req#                                       as AmountRequested,
													AmountBaseAllotment*AmountBasePercentageDue as AmountRelease,							
													
													(SELECT ISNULL(SUM(PADR.Amount),0)
													 FROM   ProgramAllotmentDetailRequest PADR, ProgramAllotmentDetail PAD 
													 WHERE  PADR.TransactionId = PAD.TransactionId
													 AND    PADR.RequirementId = R.RequirementId
													 AND    PAD.Status != '9') as AmountAllotted
													
											FROM    ProgramAllotmentRequest R
											
											WHERE   ProgramCode = '#programCode#'	
											AND     Period      = '#period#'    
											AND     EditionId   = '#EditionId#'
											AND     ObjectCode  = '#Obj#'
											AND     Fund        = '#Fund#'	
											AND     ActionStatus = 1 <!--- is valid requirement --->														
											  						
									</cfquery>		
									
									<!--- sum of the amount to have this on the allotment level --->
									
									<cfif getRequirementsForAllotment.recordcount gte "1">
									
									    <!--- now we aggregate and round the allotment ---> 
										<cfquery name="AllotmentToBeAdded" dbtype="query">	
											SELECT  SUM(AmountRequested)  as TotalRequested, 
											        SUM(AmountRelease)    as TotalRelease, 
												    SUM(AmountAllotted)   as TotalAllotted
											FROM    getRequirementsForAllotment							       
										</cfquery>		
										
										<cfset requested = 	Round(AllotmentToBeAdded.TotalRequested / check.amountrounding) * check.amountrounding>
										<cfset release   = 	Round(AllotmentToBeAdded.TotalRelease   / check.amountrounding) * check.amountrounding>
										<cfset allotted  = 	Round(AllotmentToBeAdded.TotalAllotted  / check.amountrounding) * check.amountrounding> 																							
										
										<cfset pending = release   - allotted> 	
										<cfset onhold  = requested - release> 																			
										
										<cfif pending neq "0" or onhold neq "0">																							
										
											   <cfset Allotment        = release   - allotted>									   	
											   <cfset PendingAllotment = requested - release>							   
																			 
										 	   <cf_assignid>												   
											   <cfset allotmentid = rowguid>
											   <cf_assignid>	
											   <cfset pendingid   = rowguid>									   
											   
											   <cfset no = "0">
											   
											   <cfloop index="id" list="#allotmentid#,#pendingid#">
											   
												   <cfset no = no+1>
												   
												   <cfif no eq "1">
												     <cfset amt = allotment>
													 <cfset st = "0">
												   <cfelse>
												     <cfset amt = PendingAllotment>	 
													 <cfset st = "P">
												   </cfif>
												   					
												   <cfquery name="InsertAmount" 
														datasource="AppsProgram" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
																												
														INSERT INTO ProgramAllotmentDetail
															(TransactionId,
															 ProgramCode, 
															 Period,
															 EditionId,							 
															 TransactionDate, 
															 Currency,
															 Amount,
															 ExchangeRate,
															 AmountBase,
															 Fund,
															 ObjectCode,
															 OrgUnit,
															 Status,
															 OfficerUserId, 
															 OfficerLastName, 
															 OfficerFirstName)
														VALUES ('#id#',
															    '#ProgramCode#', 
															    '#Period#', 
															    '#Editionid#', 							 
															    getDate(), 
															    '#cur#',
															    #amt#,
															   '#exc#',
																#round(amt*100/exc)/100#, <!--- enter full amount as allotment was cleared --->
															    '#Fund#',
															    '#obj#',
															    '#getProgram.OrgUnit#',
															    '#st#', 
															    '#SESSION.acc#', 
															    '#SESSION.last#', 
															    '#SESSION.first#')
																
																
													</cfquery>  
												
												</cfloop>
												
												<!--- 2/3 now we added the underlying details --->
																																																							
												<cfloop query="getRequirementsForAllotment">
												
													<cfset allotment = AmountRelease - AmountAllotted>	
													
													<cfif allotment neq "0">
												
														<cfquery name="InsertBudgetRequestMapping" 
														datasource="AppsProgram" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															INSERT INTO ProgramAllotmentDetailRequest
																(TransactionId, RequirementId,Amount)
															VALUES
															('#allotmentid#','#requirementid#','#allotment#')													
													   </cfquery>				
												   
												    </cfif>	
												   
												    <cfset pending = AmountRequested - AmountRelease>						
												   
												    <cfif pending neq "0">
												   										   
												       <cfquery name="InsertBudgetRequestMapping" 
														datasource="AppsProgram" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															INSERT INTO ProgramAllotmentDetailRequest
																(TransactionId,RequirementId,Amount)
															VALUES
															('#pendingid#','#requirementid#','#pending#')													
													   </cfquery>									   
												   
												    </cfif>
												
												</cfloop>		
																								
												<!--- 3/3 now we check for any rounding	differences to record --->
												
												<cfloop index="id" list="#allotmentid#,#pendingid#">
	
													 <cfquery name="checkamount" 
															datasource="AppsProgram" 
															username="#SESSION.login#" 
															password="#SESSION.dbpw#">
															SELECT     Amount,
														             (SELECT   ISNULL(SUM(Amount), 0)
														              FROM      ProgramAllotmentDetailRequest
														              WHERE     TransactionId = D.TransactionId) AS Requested
														    FROM         ProgramAllotmentDetail D
														    WHERE     (TransactionId = '#id#')
													 </cfquery>
													 
													 <cfset rnd = checkamount.Amount - checkamount.requested>
													 
													 <cfif abs(rnd) gte "1">
													 
													 	 <cfquery name="set" 
															datasource="AppsProgram" 
															username="#SESSION.login#" 
															password="#SESSION.dbpw#">
															UPDATE ProgramAllotmentDetail
															SET    AmountRounded = '#rnd#'													    
														    WHERE  TransactionId = '#id#'
													     </cfquery>
													 												 
													 </cfif>												 
													
												</cfloop>																	  
											
										</cfif>
											
								</cfif>
									
								<!--- ---------------------------------------------------------------- --->	
								<!--- 2/2 Provision for blocked record to be linked but for a 0 amount --->
								<!--- ---------------------------------------------------------------- --->		
															
								<cfquery name="PurgeMappingForBlocked" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">								
				                         DELETE ProgramAllotmentDetailRequest
										 FROM   ProgramAllotmentDetailRequest P
										 WHERE  1=1
										 <!--- requirement is blocked --->						  
										 AND    RequirementId IN (SELECT RequirementId 
										                          FROM   ProgramAllotmentRequest 
																  WHERE  ActionStatus = '0' 
																  AND    RequirementId = P.RequirementId)		
										<!--- allotment is cleared --->		
										AND    TransactionId IN (SELECT TransactionId 
										                          FROM   ProgramAllotmentDetail 
																  WHERE  Status = '1' 
																  AND    TransactionId = P.TransactionId)				  				 													
								</cfquery>		
														
								<cfquery name="blocked" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">			
									SELECT  SUM(RequestAmountBase) as Total
									FROM    ProgramAllotmentRequest R
									WHERE   RequirementId NOT IN (SELECT Requirementid 
									                              FROM   ProgramAllotmentDetailRequest
																  WHERE  RequirementId = R.RequirementId)
									AND     ProgramCode = '#programCode#'	
									AND     Period      = '#period#'    
									AND     EditionId   = '#EditionId#'
									AND     ObjectCode  = '#Obj#'
									AND     Fund        = '#Fund#'		
									AND     ActionStatus = 0 							  						
								</cfquery>			
															
								<cfif blocked.recordcount gte "1">			
								
										<cfquery name="CheckStatus" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">			
											SELECT  *
											FROM    ProgramAllotmentDetail
											WHERE   ProgramCode = '#programCode#'	
											AND     Period      = '#period#'    
											AND     EditionId   = '#EditionId#'
											AND     ObjectCode  = '#Obj#'
											AND     Fund        = '#Fund#'		
											AND     Status      = '0'						  						
									   </cfquery>				
								
									   <cfif checkStatus.recordcount gte "1">	
									   
									   	   <cfset id = checkStatus.transactionid>	  
									   
									   <cfelse>
									   
									   	   <!--- create a record --->									 
									   			 
									 	   <cf_assignid>
										   <cfset id = rowguid>
															
										   <cfquery name="InsertAmount" 
												datasource="AppsProgram" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												INSERT INTO ProgramAllotmentDetail
													(TransactionId,
													 ProgramCode, 
													 Period,
													 EditionId,							 
													 TransactionDate, 
													 Currency,
													 Amount,
													 ExchangeRate,
													 AmountBase,
													 Fund,
													 ObjectCode,
													 OrgUnit,
													 Status,
													 Remarks,
													 OfficerUserId, 
													 OfficerLastName, 
													 OfficerFirstName)
													 
												VALUES
													 
													 ('#id#',
													  '#ProgramCode#', 
													  '#Period#', 
													  '#Editionid#', 							 
													  getDate(), 
													  '#Cur#',
													  0,
													  '#exc#',
													  0,
													  '#Fund#',
													  '#obj#',
													  '#getProgram.OrgUnit#',
													  'P', 
													  'Blocked entries',
													  '#SESSION.acc#', 
													  '#SESSION.last#', 
													  '#SESSION.first#')													  
											</cfquery>
											
										</cfif>
										
										<cftry>					  
										  
											<cfquery name="InsertBudgetRequestMapping" 
												datasource="AppsProgram" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													INSERT INTO ProgramAllotmentDetailRequest (TransactionId,RequirementId,Amount)
													SELECT    '#id#',RequirementId,0
													FROM      ProgramAllotmentRequest R
													WHERE     1=1
													<!--- RequirementId NOT IN (SELECT Requirementid 
											                                        FROM   ProgramAllotmentDetailRequest
																					WHERE  RequirementId = R.RequirementId)
																					--->
													AND       ProgramCode = '#ProgramCode#' 
													AND       Period      = '#Period#' 
													AND       EditionId   = '#EditionId#' 
													AND       Fund        = '#Fund#'
													AND       ObjectCode  = '#obj#'
													AND       ActionStatus = '0'  			
											</cfquery>	 
										
										<cfcatch></cfcatch>
										
										</cftry>
									
									</cfif>									
																										  
								  </cfif>
									
							</cfif>
							
						</cfloop>	
					
					</cfif>
				
				</cfloop>
				
				</cfif>		
				
				<!--- cleansing of overcomplete records 8/5/2014 added by Hanno --->
				
				<cfquery name="InsertBudgetRequestMapping" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				
						DELETE  ProgramAllotmentDetailRequest
						FROM    ProgramAllotmentDetailRequest AS D
						WHERE   TransactionId IN (
                        			  SELECT   TransactionId
			                          FROM    ProgramAllotmentDetail
									  WHERE   ProgramCode = '#ProgramCode#'
									  AND     Period      = '#Period#' 
            			              AND     TransactionId = D.TransactionId 
									  AND     Status >= '1')
								       
						AND     Amount = 0						
				
				</cfquery>					
							
				<cfif Mode eq "All" or Mode eq "Support">
								
					<!--- added provision for overhead costs management --->
				
					<cfif check.supportPercentage gte "1" and check.SupportObjectCode neq "">					
					
						<cfquery name="ClearPending" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							DELETE FROM ProgramAllotmentDetail 								
							WHERE   ProgramCode     = '#programCode#'	
							AND     Period          = '#period#'    
							AND     EditionId       = '#EditionId#'							
							AND     TransactionType = 'Support'								
							AND     Status IN ('0','P')
						</cfquery>		
					
						<!--- here we define the ProgramAllotmentDetail.SupportCosts by fund, orgunit --->
						
						<cfquery name="getFund" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">			
							SELECT  DISTINCT Fund, OrgUnit
							FROM    ProgramAllotmentDetail						
							WHERE   ProgramCode  = '#programCode#'	
							AND     Period       = '#period#'    
							AND     EditionId    = '#EditionId#'	
							ORDER BY Fund,OrgUnit																										  						
						</cfquery>	
											
					<cfoutput query="getFund" group="Fund">	
						
							<cfoutput group="OrgUnit">	 <!--- added to generate transaction by orgunit --->
														
								<cfquery name="Requirement" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">			
									SELECT  ISNULL(SUM(Amount),0) as Total
									FROM    ProgramAllotmentDetail	R							
									WHERE   ProgramCode  = '#programCode#'	
									AND     Period       = '#period#'    
									AND     EditionId    = '#EditionId#'		
									AND     Fund         = '#Fund#'		
									AND     OrgUnit      = '#OrgUnit#'	
									<!--- total requirements --->				
									AND     Status IN ('0','1') 		
									AND     ObjectCode IN (SELECT Code 
									                       FROM   Ref_Object 
														   WHERE  Code = R.ObjectCode 
														   AND    SupportEnable = 1)
									AND     TransactionType != 'Support'					   
								</cfquery>	
			
								<!--- define the total support as needed --->					
								<cfset calcsupport = Requirement.Total * (check.supportPercentage/100)>
															
								<!--- support pending --->								
								
								<cfquery name="SupportPending" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">		
								    SELECT  ISNULL(SUM(Amount),0) as Total
									FROM    ProgramAllotmentDetail R								
									WHERE   ProgramCode     = '#programCode#'	
									AND     Period          = '#period#'    
									AND     EditionId       = '#EditionId#'	
									AND     Fund            = '#Fund#'		
									AND     OrgUnit         = '#OrgUnit#'														
									AND     TransactionType = 'Support'		
									AND     ObjectCode IN (SELECT Code 
									                       FROM   Ref_Object 
														   WHERE  Code = R.ObjectCode 
														   AND    SupportEnable = 1)	
									<!--- not cleared support amounts --->			  				
									AND     Status IN ('0','P') 													  						
								</cfquery>		
								
								<!--- support cleared --->								
								<cfquery name="SupportCleared" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">			
									SELECT  ISNULL(SUM(Amount),0) as Total
									FROM    ProgramAllotmentDetail R								
									WHERE   ProgramCode     = '#programCode#'	
									AND     Period          = '#period#'    
									AND     EditionId       = '#EditionId#'	
									AND     Fund            = '#Fund#'	
									AND     OrgUnit         = '#OrgUnit#'															
									AND     TransactionType = 'Support'									
									<!--- already cleared support amounts --->			  				
									AND     Status = '1' 		
								</cfquery>								
								
								<cfset diff = calcsupport  - (supportPending.Total + supportCleared.total)>																				
																										
								<cfif abs(round(diff)) gte "1">	
								
									<!--- we remove the pending so we just have one record for pending here --->
																									
									<cfset diff = calcsupport - supportCleared.total>	
																	
									<cf_assignid>
									
									<cfquery name="InsertAmount" 
											datasource="AppsProgram" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											INSERT INTO ProgramAllotmentDetail
												(TransactionId,
												 ProgramCode, 
												 Period,
												 EditionId,							 
												 TransactionDate, 
												 TransactionType,
												 Currency,
												 Amount,
												 ExchangeRate,
												 AmountBase,
												 Fund,
												 ObjectCode,
												 OrgUnit,
												 Status,
												 Remarks,
												 OfficerUserId, 
												 OfficerLastName, 
												 OfficerFirstName)
											VALUES
												 ('#rowguid#',
												  '#ProgramCode#', 
												  '#Period#', 
												  '#Editionid#', 							 
												  getDate(), 
												  'Support',
												  '#cur#',
												  '#round(diff)#',
												  '#exc#',
												  '#round(diff*100/exc)/100#',
												  '#Fund#',
												  '#check.SupportObjectCode#',
												  '#OrgUnit#',
												  '0', 
												  'Generated support entries',
												  '#SESSION.acc#', 
												  '#SESSION.last#', 
												  '#SESSION.first#')
									</cfquery>
									
								</cfif>
								
								<cfquery name="SupportInPipeline" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">		
								    SELECT  ISNULL(SUM(Amount),0) as Total
									FROM    ProgramAllotmentDetail R								
									WHERE   ProgramCode     = '#programCode#'	
									AND     Period          = '#period#'    
									AND     EditionId       = '#EditionId#'	
									AND     Fund            = '#Fund#'		
									AND     OrgUnit         = '#OrgUnit#'																							
									AND     ObjectCode IN (SELECT Code 
									                       FROM   Ref_Object 
														   WHERE  Code = R.ObjectCode 
														   AND    SupportEnable = 1)	
									<!--- not cleared support amounts --->			  				
									AND     Status = 'P' 	
									AND     TransactionType != 'Support'													  						
								</cfquery>
								
								<cfset pipesupport = SupportInPipeline.Total * (check.supportPercentage/100)>
								
								<cf_assignid>
									
									<cfquery name="InsertAmount" 
											datasource="AppsProgram" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											INSERT INTO ProgramAllotmentDetail
												(TransactionId,
												 ProgramCode, 
												 Period,
												 EditionId,							 
												 TransactionDate, 
												 TransactionType,
												 Currency,
												 Amount,
												 ExchangeRate,
												 AmountBase,
												 Fund,
												 ObjectCode,
												 OrgUnit,
												 Status,
												 Remarks,
												 OfficerUserId, 
												 OfficerLastName, 
												 OfficerFirstName)
											VALUES
												 ('#rowguid#',
												  '#ProgramCode#', 
												  '#Period#', 
												  '#Editionid#', 							 
												  getDate(), 
												  'Support',
												  '#cur#',
												  '#pipesupport#',
												  '#exc#',
												  '#round(pipesupport*100/exc)/100#',
												  '#Fund#',
												  '#check.SupportObjectCode#',
												  '#OrgUnit#',
												  'P', 
												  'Generated support entries',
												  '#SESSION.acc#', 
												  '#SESSION.last#', 
												  '#SESSION.first#')
									</cfquery>		
														
							</cfoutput>
						
						</cfoutput>
						
				</cfif>	
					
			</cfif>	
			
		</cfif>	
				
  </cffunction>
  		
</cfcomponent>	 