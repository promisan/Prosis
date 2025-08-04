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


<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- --------------------------------------- --->
<!--- correction 20/1/2015
the pre-obl amount was using the wrong period = planning periuod to be taken for filtering like line 418 --->
<!--- --------------------------------------- --->


<!--- End Prosis template framework --->

<!--- 1. supports general funding check and 
      2. specific budget check. specific budget check is triggered by editionid --->

<cfparam name="attributes.editionid" default="">
<cfparam name="attributes.role"      default="">

<!--- get the requistion --->

<cfquery name="req" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      RequisitionLine R
	WHERE     R.RequisitionNo = #preserveSingleQuotes(Attributes.requisitionNo)# 	
</cfquery>

<cfquery name="flow" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    R.EnableClearance, R.EnableFundingClear
	FROM      Ref_ParameterMissionEntryClass AS R INNER JOIN
	          ItemMaster AS I ON R.EntryClass = I.EntryClass
	WHERE     R.Mission = '#req.mission#' 
	AND       R.Period  = '#req.period#' 
	AND       I.Code    = '#req.ItemMaster#'
</cfquery>

<cfset revert = "">

<cfif attributes.editionid eq "">

	<cfset reqtbl = "Funding">
			
	<!--- define at which moment the funding will be taken into consideration at the submission stage unless disabled --->
	<!--- adjusted 30/6/2010 --->
		
	<cfset pre = "2">
		 
<cfelse>

	<cfset reqtbl = "Budget">
		
	<cfset editionid = attributes.editionid>	
	
	<!--- define expenditure periods --->
	<cfquery name="Allotment" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentEdition
	WHERE     EditionId = '#attributes.editionid#'
	</cfquery>
	
	<!--- define at which moment the funding will be taken into consideration after the review stage --->
	<cfset pre = "2">
	 	 
</cfif>

<cfset FA     = "yes">
<cfset FAMode = "">

<!--- define various parameters to be applied for the funding check --->

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#req.Mission#' 
</cfquery>
 
<cfquery name="Overwrite" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
 	    SELECT  *
		FROM     Ref_ParameterMissionEntryClass
		WHERE    Mission = '#req.Mission#' 
		AND      Period  = '#req.Period#'
</cfquery>		

<cfif Overwrite.DisableFundingCheck eq "1" and attributes.editionid eq "">

    <!--- --------------------------------------- --->
    <!--- funding validation has been overwritten --->
	<!--- --------------------------------------- --->
		
	<cfset FA = "Yes">

<cfelse>


	<cfif Parameter.FundingCheckPointer eq "1"  
	           and req.ActionStatus gte "2f" 
			   and attributes.editionid eq "">			   
			   <cfset FA = "ByPass">
						  
		<!--- do not check the funding of this is turned-off
		        after funding review stage introduced for SAT (Carolina) --->
		
	<cfelseif (Parameter.FundingByReviewer eq "2" or Parameter.FundingByReviewer eq "1e")
	           and
			   		 (req.ActionStatus eq "1" or req.reference eq "" 
			            or (req.ActionStatus eq "1f" or req.ActionStatus eq "1p") 
						or (flow.enableClearance eq "1" and req.ActionStatus eq "2")
					 ) 
			   
			   and attributes.editionid eq "">
			   <cfset FA = "ByPass">
			   
					  			   	 
	    <!--- do not performance a funding check if the requisition 
		           does not have the be funded before the funding stage --->
												
	<cfelse>	
		
		<!--- check only if funding check enabled (parameter) OR but always once internal budget check is requested --->
				    
		<cfif (Parameter.EnableFundingCheck gte "1" and Parameter.EnforceProgramBudget eq "1") 		   
			   or attributes.editionid neq "">				
			 			  		
			<!--- step 1 define amounts for period, fund, object and program for selected requisitions as the can be split funded --->
			<!--- looping for each line --->
			<!--- step 2 define budget for period, fund, object and program --->
			<!--- step 3 define requisition amount --->
			<!--- step 4 define obligation amount --->
			<!--- step 5 set status --->
			
			<cfset FA = "No">					
			
			<!--- retrieve the lines to be checked --->
									
			<cfquery name="CheckLines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    R.Mission,
						  <cfif reqtbl eq "Budget">	
				          R.Period as ProgramPeriod, 
						  <cfelse>
						  L.ProgramPeriod,
						  </cfif>
				          L.ProgramCode, 
						  L.Fund, 
						  L.ObjectCode, 
						  SUM(L.Percentage * R.RequestAmountBase) AS Amount
				FROM      RequisitionLine R INNER JOIN
				          RequisitionLine#reqtbl# L ON R.RequisitionNo = L.RequisitionNo
				WHERE     L.ProgramCode   != 'Default'
				AND       R.RequisitionNo = #preserveSingleQuotes(Attributes.requisitionNo)# 				
				GROUP BY R.Mission,
				         <cfif reqtbl eq "Budget">	
				         R.Period,
						 <cfelse>
						 L.ProgramPeriod,
						 </cfif>
						 L.ProgramCode,
						 L.Fund,
						 L.ObjectCode 				
			</cfquery>
						
			<!---
			<cfoutput>1. #cfquery.executiontime#</cfoutput>
			--->
			
			<!--- 7/7/2011 amendment : validation is ALWAYS performed on the parent level --->									
			<!--- step 1a Generate sum of requisition on the parent level for validation- --->
			
			<cfquery name="FundAccount" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT    R.Mission,
				          <cfif reqtbl eq "Budget">	
				          R.Period as ProgramPeriod, 
						  <cfelse>
						  L.ProgramPeriod,
						  </cfif>				         
				          L.ProgramCode, 
						  L.Fund, 
						  L.ObjectCode, 
						  SUM(L.Percentage * R.RequestAmountBase) AS Amount
				FROM      RequisitionLine R INNER JOIN
				          RequisitionLine#reqtbl# L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
						  Program.dbo.Ref_Object O ON L.ObjectCode = O.Code 
				WHERE     R.RequisitionNo = #preserveSingleQuotes(Attributes.requisitionNo)# 
				AND       L.ProgramCode   != 'Default'
				AND       (O.ParentCode is NULL or O.ParentCode NOT IN (SELECT Code 
				                                                        FROM   Program.dbo.Ref_Object))				       
				<cfif reqtbl eq "Budget">		<!--- CMP funding --->	
				AND       L.Status != '9'
				</cfif>
				GROUP BY  R.Mission,
				          <cfif reqtbl eq "Budget">	
				          R.Period,
						  <cfelse>
						  L.ProgramPeriod,
						  </cfif>
						  L.ProgramCode, 
						  L.Fund, 
						  L.ObjectCode 		
						  
				UNION
				
				SELECT    R.Mission,
				          <cfif reqtbl eq "Budget">	
				          R.Period as ProgramPeriod, 
						  <cfelse>
						  L.ProgramPeriod,
						  </cfif>		
				          L.ProgramCode, 
						  L.Fund, 
						  O.ParentCode as ObjectCode, 
						  SUM(L.Percentage * R.RequestAmountBase) AS Amount
				FROM      RequisitionLine R INNER JOIN
				          RequisitionLine#reqtbl# L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
						  Program.dbo.Ref_Object O ON L.ObjectCode = O.Code 
				WHERE     R.RequisitionNo = #preserveSingleQuotes(Attributes.requisitionNo)# 
				AND       L.ProgramCode   != 'Default'
				AND       O.ParentCode IN (SELECT Code FROM Program.dbo.Ref_Object)				     
				<cfif reqtbl eq "Budget">		<!--- CMP funding --->	
				AND       L.Status != '9'
				</cfif>
				GROUP BY  R.Mission,
				          <cfif reqtbl eq "Budget">	
				          R.Period,
						  <cfelse>
						  L.ProgramPeriod,
						  </cfif>
						  L.ProgramCode, 
						  L.Fund, 
						  O.ParentCode 		
						  		
			</cfquery>
													
			<!--- step1b rollup to the level of the parent for validation, maybe bypassed for CMP sometimes because of condition --->
						
			<cfif FundAccount.recordcount eq "0" and CheckLines.recordcount gte "1">
			        <!--- no funding lines, but it was funded --->					
					<cfset FA = "Yes">			
			</cfif>
			
			<cfset stop = "0">

			<cfset caller.bud = "">
							
	        <!--- looping through budget line --->		
			
			<cfset bal = 0>		
			<cfset amt = 0>			 
			<cfset bud = 0>			
			<cfset res = 0>			
			<cfset obl = 0>			
			<cfset dis = 0>		
												
			<cfloop query="FundAccount">
												
					<!--- determine if an alternate period should be taken for the budget --->				
					
					 <!--- step 1 edition --->
					<cfquery name="edition" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     Ref_MissionPeriod
						WHERE    Mission = '#req.Mission#'
						AND      Period  = '#ProgramPeriod#' 
					</cfquery>
										
					<cfif edition.planningPeriod neq "">
									
					   <!--- overrule --->					
					   <cfset planningperiod = edition.PlanningPeriod>
									   
					<cfelse>
									
					   <cfset planningperiod = req.Period>   
									
					</cfif>							
											
					<cfif reqtbl eq "Budget">
										
						<!--- value is preset from the request --->
						
					<cfelse>	
																	
						<cfset editionid = edition.editionid>
						<cfif edition.EditionIdAlternate neq "">
							<cfset editionid = "#editionid#,#edition.EditionIdAlternate#">
						</cfif>
						
						<!--- define expenditure periods --->
						<cfquery name="Allotment" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT    *
						FROM      Ref_AllotmentEdition
						WHERE     EditionId IN (#editionid#)
						</cfquery>
												
					</cfif>	
										
					<!--- added the condition to look at the cashflow --->
										
					<cfif Parameter.FundingClearRollup eq "2">
					
						<cfquery name="Org" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM   Organization 
							WHERE  OrgUnit = '#Req.OrgUnit#'
						</cfquery>							
						
						<cfif Org.ParentOrgunit eq "" or Org.Autonomous eq "1">		
						
							<cfset hier = org.hierarchyCode>
							
						<cfelse>	
						
							<cfset top = 0>
											
							<cfloop condition="#top# neq 1">
								
									<cfquery name="Org" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT * 
										FROM   Organization 
										WHERE  Mission     = '#org.Mission#' 
										AND    MandateNo   = '#org.MandateNo#'
										AND    OrgUnitCode = '#org.ParentOrgUnit#'
									</cfquery>	
									
									<cfif Org.ParentOrgunit eq "" or Org.Autonomous eq "1">								
																						
										<cfset hier  = org.hierarchyCode>
										<cfset top   = 1>
																		
									</cfif>
										
							  </cfloop>
							
						  </cfif>	  
						  						  
						  <cfquery name="getOrg" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM   Organization 
							WHERE  Mission     = '#org.Mission#' 
							AND    MandateNo   = '#org.MandateNo#'
							AND    (HierarchyCode LIKE '#hier#%' OR OrgUnit = '#Req.OrgUnit#')						
						  </cfquery>	
						  
						  <cfset hier = QuotedValueList(getOrg.OrgUnit)>	
						  
						  <cfif hier eq "">
						    <cfset hier = '0'>
						  </cfif>
						  						  										
					</cfif>
																	
																	
					<cfif Parameter.FundingCheckCleared eq "1" and Allotment.AllocationEntryMode eq "2">	
															
						<!--- step 2 budget --->
						
												
						<cfquery name="budget" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							SELECT  SUM(PAD.Amount) AS Amount
							
							FROM    ProgramAllotmentAllocation PAD
							        INNER JOIN Ref_AllotmentEditionFund ED 
									            ON  ED.Fund      = PAD.Fund 
												AND ED.EditionId = PAD.EditionId 	
							
							<!--- planning period to take budget from --->
							AND     PAD.Period      = '#planningperiod#'	
												
							<!--- --------------- edition ----------- --->					
							WHERE   PAD.EditionId IN (#editionid#) 
												
							<cfif Parameter.FundingClearRollup eq "0">
								AND     PAD.ProgramCode = '#ProgramCode#' 
							<cfelseif Parameter.FundingClearRollup eq "1">								
								AND     PAD.ProgramCode IN (SELECT ProgramCode 
								                            FROM   Program.dbo.ProgramPeriod 
															WHERE  Period  = '#PlanningPeriod#'
															AND    OrgUnit = '#Req.OrgUnit#')
							<cfelseif Parameter.FundingClearRollup eq "2">								
							    AND     PAD.ProgramCode IN (SELECT ProgramCode 
								                            FROM   Program.dbo.ProgramPeriod 
															WHERE  Period  = '#PlanningPeriod#'
															AND    OrgUnit IN (#preservesingleQuotes(hier)#)
															)
							</cfif>		
							
							<cfif Parameter.FundingClearResource eq "0">			
							
								AND    (
									      PAD.ObjectCode = '#ObjectCode#' OR 
									      PAD.ObjectCode IN (SELECT Code 
											                 FROM   Program.dbo.Ref_Object 
															 WHERE  ParentCode = '#ObjectCode#')
								       )
								   
							<cfelseif Parameter.FundingClearResource eq "1">
							
								AND    (
									     
									      PAD.ObjectCode IN (SELECT Code 
											                 FROM   Program.dbo.Ref_Object 
															 WHERE  Resource = (SELECT Resource 
															                    FROM Program.dbo.Ref_Object 
																				WHERE Code = '#ObjectCode#')
															) 
								       )
									   
							<cfelse>
							
								<!--- all objects within the program or unit scope --->		   
							
							</cfif>	   
								   
							AND  PAD.Fund = '#Fund#'		   
													
						</cfquery>	
						
											
					<cfelse>
											
						<!--- step 2 budget --->
						<cfquery name="budget" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							SELECT  SUM(PAD.AmountBase*(ED.PercentageRelease/100)) AS Amount
							
							FROM    ProgramAllotmentDetail PAD
							        INNER JOIN Ref_AllotmentEditionFund ED 
									            ON  ED.Fund      = PAD.Fund 
												AND ED.EditionId = PAD.EditionId 	
							
							<!--- planning period to take budget from --->
							AND     PAD.Period      = '#planningperiod#'	
												
							<!--- --------------- edition ----------- --->					
							WHERE   PAD.EditionId IN (#editionid#) 
							
							<cfif Parameter.FundingClearRollup eq "0">
								AND     PAD.ProgramCode = '#ProgramCode#' 
							<cfelseif Parameter.FundingClearRollup eq "1">								
								AND     PAD.ProgramCode IN (SELECT ProgramCode 
								                            FROM   Program.dbo.ProgramPeriod 
															WHERE  Period  = '#PlanningPeriod#'
															AND    OrgUnit = '#Req.OrgUnit#')
							<cfelse>								
							    AND     PAD.ProgramCode IN (
								                            SELECT ProgramCode 
								                            FROM   Program.dbo.ProgramPeriod 
															WHERE  Period  = '#PlanningPeriod#'
															AND    OrgUnit IN (#preservesingleQuotes(hier)#) 
														   )
							</cfif>		
								
														
							<cfif Parameter.FundingClearResource eq "0">				
							
								AND    (
									      PAD.ObjectCode = '#ObjectCode#' OR 
									      PAD.ObjectCode IN (SELECT Code 
											                 FROM   Program.dbo.Ref_Object 
															 WHERE  ParentCode = '#ObjectCode#')
								   )
								   
							<cfelseif Parameter.FundingClearResource eq "1">
							
								AND    (
									     
									      PAD.ObjectCode IN (SELECT Code 
											                 FROM   Program.dbo.Ref_Object 
															 WHERE  Resource = (SELECT Resource 
															                    FROM Program.dbo.Ref_Object 
																				WHERE Code = '#ObjectCode#')
															) 
								       )
									   
							<cfelse>
							
								<!--- all objects within the program or unit scope --->				   
							
							</cfif>	   	   
								   
							AND  PAD.Fund = '#Fund#'		   
											
							<cfif Parameter.FundingCheckCleared eq "1">
							AND    PAD.Status IN ('1')
							<cfelse>
							AND    PAD.Status IN ('0','1')
							</cfif>
						
						</cfquery>
						
					</cfif>	
															
					<!--- -------------------------------------------------------------- ---> 
					<!--- define execution periods that need to be funded by this budget --->
					<!--- -------------------------------------------------------------- --->
					
					<cfif attributes.editionid eq "">
						
						<!--- ------------ --->
						<!--- funding mode --->
						<!--- ------------ --->
							
						<cfquery name="Expenditure" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    DISTINCT Period
							FROM      Ref_MissionPeriod
							WHERE     Mission = '#Mission#'
							AND       EditionId IN (SELECT EditionId
													FROM   Ref_MissionPeriod
													WHERE  Mission = '#Mission#'
													AND    Period  = '#ProgramPeriod#') 
						</cfquery>
					
					<cfelse>
					
					    <!--- ----------- --->
						<!--- budget mode --->
						<!--- ----------- --->
					
						<cfquery name="Expenditure" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    DISTINCT Period
							FROM      Ref_MissionPeriod
							WHERE     Mission = '#Mission#'
							<cfif Allotment.Period neq "">
							AND       Period  = '#Allotment.Period#'
							</cfif>					
						</cfquery>
					
					</cfif>
					
					<cfset persel = "">
					
					<cfloop query="Expenditure">
					
					  <cfif persel eq "">
					     <cfset persel = "'#Period#'"> 
					  <cfelse>
					     <cfset persel = "#persel#,'#Period#'">
					  </cfif>
					  
					</cfloop>			
					
					<!--- ---------------------- --->					
					<!--- step 3 preencumberance --->
					<!--- ---------------------- --->
										
					<cfquery name="preencum" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT    SUM(L.Percentage * R.RequestAmountBase) AS Amount
				       FROM      RequisitionLine R INNER JOIN
				                 RequisitionLine#reqtbl# L ON R.RequisitionNo = L.RequisitionNo
				       WHERE     R.Mission     = '#Mission#'
					   
					   <cfif Parameter.FundingClearRollup eq "0">	
					   					   				    
					   AND      L.ProgramCode = '#ProgramCode#'    					   
					   
					   <cfelseif Parameter.FundingClearRollup eq "1">		
					   				  					   
					   AND      L.ProgramCode IN (SELECT ProgramCode 
						                          FROM   Program.dbo.ProgramPeriod 
												  WHERE  Period  = '#planningperiod#'  												  
												  <!--- 25/5/2010
												    technically the below is not correct if a unit belong to a different mandate it will not select properly, so
												    we need to filter based on the UnitMissionId
												  --->
												  AND    OrgUnit = '#Req.OrgUnit#'
												 )
												 
					   <cfelse>
					   
					    AND      L.ProgramCode IN (SELECT ProgramCode 
						                          FROM   Program.dbo.ProgramPeriod 
												  WHERE  Period  =  '#planningperiod#'  												  
												  <!--- 25/5/2010
												    technically the below is not correct if a unit belong to a different mandate it will not select properly, so
												    we need to filter based on the UnitMissionId
												  --->
												  AND     OrgUnit IN (#preservesingleQuotes(hier)#)
												 )					   
					   
					   							 
					   </cfif>
					   
					   <cfif reqtbl eq "Budget">
				        AND       R.Period IN (#preservesingleQuotes(persel)#)					   
					   <cfelse>
					    AND       L.ProgramPeriod IN (#preservesingleQuotes(persel)#)	
					   </cfif>							 
					   
					   <cfif Parameter.FundingClearResource eq "0">
					   
					   	  AND    (
						      	  L.ObjectCode = '#ObjectCode#' OR 
							      L.ObjectCode IN (SELECT  Code 
							      		            FROM   Program.dbo.Ref_Object 
													WHERE  ParentCode = '#ObjectCode#')
						       )
					   
					   <cfelseif Parameter.FundingClearResource eq "1">
					   
						   AND    (
										     
										      L.ObjectCode IN (SELECT Code 
												               FROM   Program.dbo.Ref_Object 
															   WHERE  Resource = (SELECT Resource 
																                    FROM Program.dbo.Ref_Object 
																					WHERE Code = '#ObjectCode#')
																) 
									       )
					   		   
					  			  							   
					   <cfelse>
					   					   
						   <!--- any object of expenditure --->					   
					   
					   </cfif>		 
					   
					   AND     L.Fund        = '#Fund#'
					   AND     L.Status      = '1'
				       AND     R.RequisitionNo != #preserveSingleQuotes(Attributes.requisitionNo)# 
					   
					   <!--- if approval step is enabled then we use 2b or 2a otherwise we use 2 --->
					   
					   <cfif Parameter.FundingByReviewer eq "1e">
					   
					    AND  (
					 							       
							 
							  (  R.ActionStatus IN ('2f','2i','2k','2q')
					                AND 
							     R.RequisitionNo IN (	
								    SELECT   R.RequisitionNo
									FROM     RequisitionLine AS R INNER JOIN
									         ItemMaster AS I ON R.ItemMaster = I.Code INNER JOIN
									         Ref_ParameterMissionEntryClass AS S ON S.Mission = R.Mission AND S.Period = R.Period AND I.EntryClass = S.EntryClass
									WHERE    1=1 <!--- S.EnableClearance = '1' and S.EnableBudgetReview = '0' --->
									AND      R.Mission = '#Mission#'
									AND      R.Period = '#planningperiod#' 
									<!---  AND      R.Period IN (#preservesingleQuotes(persel)#)  correction 20/1 --->
								    )							
							 )	
							 							  
							 							 
							) 
							
					   <cfelse>
					   
					   AND  (
					 					    
					        (  R.ActionStatus >= '2'
					                AND 
							   R.RequisitionNo IN (	
								    SELECT   R.RequisitionNo
									FROM     RequisitionLine AS R INNER JOIN
									         ItemMaster AS I ON R.ItemMaster = I.Code INNER JOIN
									         Ref_ParameterMissionEntryClass AS S ON S.Mission = R.Mission AND S.Period = R.Period AND I.EntryClass = S.EntryClass
									WHERE    S.EnableClearance = '0' 
									AND      R.Mission = '#Mission#'
									AND      R.Period = '#planningperiod#'  
								    )							
							 )	
							 
							 OR
							 
							  (  R.ActionStatus >= '2a'
					                AND 
							     R.RequisitionNo IN (	
								    SELECT   R.RequisitionNo
									FROM     RequisitionLine AS R INNER JOIN
									         ItemMaster AS I ON R.ItemMaster = I.Code INNER JOIN
									         Ref_ParameterMissionEntryClass AS S ON S.Mission = R.Mission AND S.Period = R.Period AND I.EntryClass = S.EntryClass
									WHERE    S.EnableClearance = '1' and S.EnableBudgetReview = '0'
									AND      R.Mission = '#Mission#'
									AND      R.Period = '#planningperiod#' 
								    )							
							 )	
							 
							  OR
							 
							  (  R.ActionStatus >= '2b'
					                AND 
							     R.RequisitionNo IN (	
								    SELECT   R.RequisitionNo
									FROM     RequisitionLine AS R INNER JOIN
									         ItemMaster AS I ON R.ItemMaster = I.Code INNER JOIN
									         Ref_ParameterMissionEntryClass AS S ON S.Mission = R.Mission AND S.Period = R.Period AND I.EntryClass = S.EntryClass
									WHERE    S.EnableClearance = '1' and S.EnableBudgetReview = '1'
									AND      R.Mission = '#Mission#'
									AND      R.Period = '#planningperiod#'
								    )							
							 )	
							 							 
							) 
							
						</cfif>	
					  		     
					    
					</cfquery>									
					
					 <cfquery name="Param" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   Ref_ParameterMission
						WHERE  Mission = '#Mission#'			
					</cfquery>		
					
					<cfsavecontent variable="condition">
					
						<cfoutput>
													
						   <cfif reqtbl eq "Budget">
					        AND       R.Period IN (#preservesingleQuotes(persel)#)					   
						   <cfelse>
						    AND       L.ProgramPeriod IN (#preservesingleQuotes(persel)#)	
						   </cfif>
						   				   
						   <cfif Parameter.FundingClearRollup eq "0">	
					   					   				    
						   AND      L.ProgramCode = '#ProgramCode#'    					   
						   
						   <cfelseif Parameter.FundingClearRollup eq "1">		
						   				  					   
						   AND      L.ProgramCode IN (SELECT ProgramCode 
							                          FROM   Program.dbo.ProgramPeriod 
													  WHERE  Period  = '#planningperiod#'  												  
													  <!--- 25/5/2010
													    technically the below is not correct if a unit belong to a different mandate it will not select properly, so
													    we need to filter based on the UnitMissionId
													  --->
													  AND    OrgUnit = '#Req.OrgUnit#'
													 )
													 
						   <cfelse>
						   
						    AND      L.ProgramCode IN (SELECT ProgramCode 
							                           FROM   Program.dbo.ProgramPeriod 
													   WHERE  Period  = '#planningperiod#'   												  
													  <!--- 25/5/2010
													    technically the below is not correct if a unit belong to a different mandate it will not select properly, so
													    we need to filter based on the UnitMissionId
													  --->
													   AND    OrgUnit IN (#preservesingleQuotes(hier)#)
													 )					   
						   
						   							 
						   </cfif>
						   
						   <cfif Parameter.FundingClearResource eq "0">
						   
						   	  AND    (
							      	  L.ObjectCode = '#ObjectCode#' OR 
								      L.ObjectCode IN (SELECT  Code 
								      		            FROM   Program.dbo.Ref_Object 
														WHERE  ParentCode = '#ObjectCode#')
							       )
						   
						   <cfelseif Parameter.FundingClearResource eq "1">
						   
							   AND    (
											     
											      L.ObjectCode IN (SELECT Code 
													               FROM   Program.dbo.Ref_Object 
																   WHERE  Resource = (SELECT Resource 
																	                    FROM Program.dbo.Ref_Object 
																						WHERE Code = '#ObjectCode#')
																	) 
										       )
						   		   
						  			  							   
						   <cfelse>
																   
							   <!--- any object of expenditure --->					   
						   
						   </cfif>		   						 				     
						 					   
						   AND       L.Fund        = '#Fund#'						  
					       AND       R.RequisitionNo != #preserveSingleQuotes(Attributes.requisitionNo)#
					       AND       R.ActionStatus = '3' AND (P.ActionStatus != '9')
													  										
														  
						</cfoutput>							  				
							
					</cfsavecontent>										
															
					<!--- Alternate budget mode or 	full mode mode --->
																	
					<cfif Parameter.FundingClearTransaction eq "0" or reqtbl eq "Budget">
										
						<!--- --------------------- --->
						<!--- --step 4 obligation-- --->
						<!--- --------------------- --->
						
						<cfif Param.InvoiceRequisition eq "0">		
						
						    <!--- this is the mode is the matching is done on the purchase level and not on the line,
							this has to be tuned in due course --->
						
							<cfquery name="obligation" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							   SELECT    SUM(L.Percentage * P.OrderAmountBaseObligated) AS Amount
						       FROM      RequisitionLine R INNER JOIN
						                 RequisitionLine#reqtbl# L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
						                 PurchaseLine P ON R.RequisitionNo = P.RequisitionNo
						       WHERE     R.Mission = '#Mission#'
							    AND      L.Status      = '1'
							   			 #preservesinglequotes(condition)#		
										 
							  <!--- purchase header is not cancelled --->
						       AND       P.PurchaseNo NOT IN (SELECT PurchaseNo 
							                              FROM   Purchase 
														  WHERE  PurchaseNo = P.PurchaseNo 
														  AND    ActionStatus = '9')						 							  
							</cfquery>
													
						<cfelse>
												
							<!--- ---------------------------------------------------------------------------------------- --->		
							<!--- Approach is to join the 
							           unliquidated based on the requisition funding and 
									   liquidated portion based on the InvoicePurchasePosting table                        --->
							<!--- ---------------------------------------------------------------------------------------- --->			
							
								<cfquery name="Obligation" 
								datasource="AppsPurchase" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">																				
								
								SELECT  SUM(ObligationAmount) AS Amount																										 
								FROM 								
																
								(								
								
									<!--- --------------------- --->
									<!--- unliquidated portion- --->
									<!--- --------------------- --->				
								
								    SELECT 	 SUM(L.Percentage * (P.OrderAmountBaseObligated-P.OrderAmountBaseLiquidated)) AS ObligationAmount									  
								    FROM     RequisitionLine R INNER JOIN
									         RequisitionLineFunding L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
									         PurchaseLine P ON R.RequisitionNo = P.RequisitionNo 
											  
									WHERE    R.Mission        = '#Mission#'																				
											 #preservesinglequotes(condition)#		
											 
									<!--- purchase header is not cancelled --->
						       		AND       P.PurchaseNo NOT IN (SELECT PurchaseNo 
							                              FROM   Purchase 
														  WHERE  PurchaseNo = P.PurchaseNo 
														  AND    ActionStatus = '9')			 	
																												
								    UNION ALL
									
									<!--- -------------------- --->
									<!--- -liquidated portion- --->
									<!--- -------------------- --->							
									
									SELECT  SUM(L.AmountPostedBase) AS ObligationAmount
																								  
								    FROM     RequisitionLine R INNER JOIN
									         InvoicePurchasePosting L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
									         PurchaseLine P ON R.RequisitionNo = P.RequisitionNo 
											  
									WHERE    R.Mission        = '#Mission#'		
									
									         <!--- filter for funding selection --->
						  					 #preservesinglequotes(condition)#				
									
								<!--- ------------------ --->				
								<!--- END derived table --->
								<!--- ------------------ --->		
									
								) as DerivedTable
																																		
							</cfquery>							
																				
						</cfif>
												
						<cfif Obligation.Amount neq "">
					        <cfset obl = obl+Obligation.Amount>					   
					    </cfif>
									
						
					<cfelse>
										
					    <!--- ---------------------- --->
						<!--- --step 4 unliquidated- --->
						<!--- ---------------------- --->
						
						<cfquery name="obligation" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   SELECT  SUM(L.Percentage * (P.OrderAmountBaseObligated-P.OrderAmountBaseLiquidated)) AS Amount
						  
					       FROM    RequisitionLine R INNER JOIN
					               RequisitionLine#reqtbl# L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
					               PurchaseLine P ON R.RequisitionNo = P.RequisitionNo
									 
					       WHERE   R.Mission = '#Mission#'
								   #preservesinglequotes(condition)#
						     
						</cfquery>
																						
						<cfif Obligation.Amount neq "">
					         <cfset obl = obl+Obligation.Amount>					    
					    </cfif>
						
						<!--- ---------------------- --->
						<!--- --step 5 disbursed---- --->
						<!--- ---------------------- --->						
						
						<cfquery name="Disbursement" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT SUM(L.AmountBaseDebit - L.AmountBaseCredit) AS Amount 								       
								FROM   TransactionLine L INNER JOIN
			                    	   TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo 
										
								WHERE  H.Mission = '#Mission#'	
								
								AND    H.Journal IN (SELECT Journal 
							                         FROM   Accounting.dbo.Journal 
												     WHERE  GLCategory = 'Actuals') 							
								
								<!--- program --->
						 						   				   
							    <cfif Parameter.FundingClearRollup eq "0">	
							   			   
								   AND       L.ProgramCode = '#ProgramCode#'    
							   
							    <cfelse>		
							   					   				  					   
								   AND       L.ProgramCode IN (SELECT ProgramCode 
									                           FROM   Program.dbo.ProgramPeriod 
															   WHERE  ProgramCode = L.ProgramCode
															   AND    Period      = '#planningperiod#'										  
															  <!--- 25/5/2010
															    technically the below is not correct if a unit belong to a different mandate it will not select properly, so
															    we need to filter based on the UnitMissionId
															  --->
															   AND    OrgUnit = '#Req.OrgUnit#'
															  )
							    </cfif>
							   
							    <!--- period --->					 					
							
						       AND   L.ProgramPeriod IN (#preservesingleQuotes(persel)#)	
							   
							   <!--- object --->
						   
							   <cfif Parameter.FundingClearResource eq "0">
							  
							   	  AND    (
								      	  L.ObjectCode = '#ObjectCode#' OR 
									      L.ObjectCode IN (SELECT  Code 
									      		            FROM   Program.dbo.Ref_Object 
															WHERE  ParentCode = '#ObjectCode#')
								         )
							   
							   <cfelseif Parameter.FundingClearResource eq "1">
							   
								   AND    (
												     
										      L.ObjectCode IN (SELECT Code 
												               FROM   Program.dbo.Ref_Object 
															   WHERE  Resource = (SELECT Resource 
																                    FROM Program.dbo.Ref_Object 
																					WHERE Code = '#ObjectCode#')
																) 
										  )							   		   
							  			  							   
							   <cfelse>
																   
								   <!--- any object of expenditure within the program --->					   
							   
							   </cfif>		   						 				     
						 		
								<!--- fund --->
											   
						   		AND       L.Fund        = '#Fund#'
						  
						        <!--- 8/7 add a provision to show only if invoice is finished and has status = 1 
								also the unliquidated does the same to include status 0 and 9 --->
								
								AND       (
								
								           H.ReferenceId NOT IN (SELECT InvoiceId 
										                         FROM   Purchase.dbo.Invoice
																 WHERE  InvoiceId = H.ReferenceId ) 
										               OR 
													   
										   H.ReferenceId IN (SELECT InvoiceId 
										                     FROM   Purchase.dbo.Invoice 
															 WHERE  InvoiceId = H.ReferenceId 
															 AND    ActionStatus != '0' ) 
										  )							      
																										  
						</cfquery>		
						
						<cfif Disbursement.Amount neq "">
					         <cfset dis = dis+Disbursement.Amount>					  
					    </cfif>			
											
					</cfif>	
					
					<cfif Budget.Amount neq "">
				         <cfset bud = bud+Budget.Amount>				  
				    </cfif>
					
					<cfif Preencum.Amount neq "">
				        <cfset res = res+Preencum.Amount>				    
				    </cfif>				   		 			
												 
					<!---- Check on -res from the below as it might giving issues for this mode Armin, 11-20-2019, no change --->							 
					<cfset bal = bud - res - obl - dis>

					 
					<cfset exp = res + obl + dis>		
					
					<cfset amt = amt+Amount>			 
			
			</cfloop>
						
			<cfset Caller.bud  = bud>
			<cfset Caller.res  = res>
			<cfset Caller.obl  = obl>
			<cfset Caller.inv  = dis>
			<cfset Caller.bal  = bal>
			<cfset Caller.tot  = res+obl+dis>	
			
			<cfset bal = bal + parameter.fundingchecktolerance>	
			
			
			 
			<!--- ----------------------------------------------- --->
			<!--- make judgement if request amount will be passed --->
			<!--- ----------------------------------------------- --->
			 							 						
			<cfif amt lte bal and stop eq "0">					
			   <cfset FA = "Yes">
			<cfelse>
			   <!--- loop as a portion of the requisition has no funding --->
			   <cfset stop = 1>	   
			</cfif>					
			
		<cfelse>
		
			<cfset bud = "">										
			
		</cfif>					
		
		<cfif Parameter.FundingClearResource eq "0">
			<cfset FAMode = "Object">
		<cfelseif Parameter.FundingClearResource eq "1">
			<cfset FAMode = "Resource">
		<cfelse>
			<cfset FAMode = "Program">
		</cfif>		
		
		<cfif Parameter.FundingClearRollup eq "1">
			<cfset FAMode = "#FAMode# / Unit">
		</cfif>
							
		<!--- take action on the negative funds by sending it back from certifier --->
	
		<cfif FA is "No" and 
		      attributes.role eq "ProcReqCertify" and 
			  Parameter.FundingCheckPointer eq "9">
		
		       <cfquery name="FlowSetting" 
		       datasource="AppsPurchase" 
		       username="#SESSION.login#" 
		       password="#SESSION.dbpw#">  
		         SELECT   S.*
		         FROM     RequisitionLine R INNER JOIN
		                  ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
		                  Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
		         WHERE    R.RequisitionNo = #preserveSingleQuotes(Attributes.requisitionNo)#
				 
		       </cfquery> 
		       
			   <!--- funding step is enabled --->
		       <cfif FlowSetting.EnableFundingClear eq "1">
		        
			        <cfif FlowSetting.EnableClearance eq "1">
			            <cfset setst = "2a">
			        <cfelse>
			            <cfset setst = "2"> 
			        </cfif> 
			        
			        <!---  1. update requisition lines --->
			        <cfquery name="Update" 
			             datasource="AppsPurchase" 
			             username="#SESSION.login#" 
			             password="#SESSION.dbpw#">
			             UPDATE RequisitionLine 
			             SET    ActionStatus = '#setst#' 
			             WHERE  RequisitionNo = #preserveSingleQuotes(Attributes.requisitionNo)#
			        </cfquery>
			        
			        <cfset revert = "Funding">
			       
			        <!---  2. enter action --->
			        <cfquery name="InsertAction" 
			             datasource="AppsPurchase" 
			             username="#SESSION.login#" 
			             password="#SESSION.dbpw#">
			             INSERT INTO RequisitionLineAction 
					          (RequisitionNo, 
					            ActionProcess,
					            ActionStatus, 
					            ActionDate,
					            ActionMemo,
					            OfficerUserId, 
					            OfficerLastName, 
					            OfficerFirstName) 
				          SELECT RequisitionNo, 
				                 '2i',
				                 '#setst#', 
				                 getDate(), 
				                 'Reverted because of insufficient funding', 
				                 '#SESSION.acc#', 
				                 '#SESSION.last#', 
				                 '#SESSION.first#'
				          FROM   RequisitionLine
				          WHERE  RequisitionNo = #preserveSingleQuotes(Attributes.requisitionNo)#
			        </cfquery> 					
		       
		       </cfif>
		       
		 </cfif>
		 
	</cfif>		 
	
</cfif>	

<cfset Caller.Funds        = FA>      <!--- funds available --->
<cfset Caller.FundsMode    = FAMode>  <!--- the way the validation was conducted, agregation etc --->
<cfset Caller.Revert       = Revert>