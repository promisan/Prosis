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

<!--- 
   Name : /Component/Process/Program.cfc
   Description : Execution procedures
   
   1.1.  Generate Budget Table 
   1.2.  Generate Preencumbrance Table
   1.3.  Generate Obligation Table
   1.4.  Generate Disbursement Table    
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="Budget"
             access="public"
             returntype="any"
             displayname="Budget Table">
		
		<cfargument name="ProgramCode"         type="string" required="false" default="">
		<cfargument name="ProgramActivity"     type="string" required="false" default="0">
		
		<cfargument name="PlanningPeriod"      type="string" required="false" default="">
		<cfargument name="Period"              type="string" required="true">
		
		<cfargument name="TransactionDate"     type="string" required="false" default="">
		<cfargument name="TransactionDateEnd"  type="string" required="false" default="">
		
		<cfargument name="MandateNo"           type="string" required="true"  default="">
		<cfargument name="UnitHierarchy"       type="string" required="true"  default="">
		<cfargument name="ProgramHierarchy"    type="string" required="true"  default="">		
		<cfargument name="EditionId"           type="string" required="true">	
				
		<cfargument name="Currency"            type="string" required="false" default="#application.baseCurrency#">	
		
		<cfargument name="Fund"                type="string" required="false" default="">
		<cfargument name="Class"               type="string" required="false" default="">
		<cfargument name="ClassValue"          type="string" required="false" default="">
		<cfargument name="Resource"            type="string" required="false" default="">
		<cfargument name="Object"              type="string" required="false" default="">
		<cfargument name="ObjectChildren"      type="string" required="false" default="0">
		<cfargument name="ObjectParent"        type="string" required="false" default="0">  <!--- 0 object, 1 pass return values on parent level only --->
		<!--- added option to pass : request as the status --->
		<cfargument name="Status"              type="string" required="false" default="">
		<cfargument name="Support"      	   type="string" required="true"  default="No">	
		<cfargument name="Mode"                type="string" required="true"  default="Table">
		<cfargument name="Table"               type="string" required="false" default="#SESSION.acc#Allotment">
		
		<cfif currency neq application.baseCurrency>		
			<CFSET BudgetAmount = "Amount">		
		<cfelse>		
			<cfset BudgetAmount = "AmountBase">			
		</cfif>
		
		<cfif TransactionDate neq "">
				<cfset dateValue = "">
				<CF_DateConvert Value="#TransactionDate#">
				<cfset DTE = dateValue>
			</cfif>
			
		<cfif TransactionDateEnd neq "">
				<cfset dateValue = "">
				<CF_DateConvert Value="#TransactionDateEnd#">
				<cfset DTEEnd = dateValue>
		</cfif>			
		
		<CF_DropTable dbName="AppsQuery" tblName="#table#">
		
		<cfquery name="Param" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_ParameterMission
			WHERE  Mission = '#Mission#'
		</cfquery>			
				
		<cfquery name="Edition" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_AllotmentEdition
			WHERE EditionId IN (#preservesinglequotes(EditionId)#) 
		</cfquery>
		
		<cfif QuotedValueList(Edition.Version) eq "">		
		
			<cfquery name="Version" 
			    datasource="AppsProgram" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_AllotmentVersion
				WHERE  Code IN ('0') 
			</cfquery>	
		
		<cfelse>		
			
			<cfquery name="Version" 
			    datasource="AppsProgram" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_AllotmentVersion
				WHERE  Code IN (#QuotedValueList(Edition.Version)#) 
			</cfquery>
		
		</cfif>		
				
		<!--- correction of the status to have logic --->
		
		<cfif status eq "">
		    <!--- let system determine the result --->
		    <cfset status = edition.AllocationEntryMode>
		<cfelseif status eq "0">
		   <!--- take both all proposed and cleared transactions --->
		<cfelseif status eq "1" and edition.AllocationEntryMode neq "2">   
		    <!--- take cleared transactions --->		
		<cfelseif status eq "1" and edition.AllocationEntryMode eq "2">
		    <!--- take directly entered allocation transactions from different table --->
		    <cfset status = "2">
		<cfelseif status eq "3" and edition.AllocationEntryMode neq "2">   
			<!--- takes approved if approproate transactions, added 4/6/2013  --->
		    <cfset status = "3">	
		</cfif>
		
		<cfquery name="MissionPeriod" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_MissionPeriod
			WHERE  Mission = '#Mission#'
			AND    Period  = '#Period#'
		</cfquery>	
		
		<cfif PlanningPeriod neq "">
		    <cfset period = PlanningPeriod>
		<cfelse>
			<cfset period = MissionPeriod.PlanningPeriod>
		</cfif>	
								
		<cfif status eq "request">		
				
			<!--- obtain a corrected query --->
								
			<cfinvoke component="Service.Process.Program.ProgramAllotment"  <!--- get access levels based on top Program--->
				Method         = "RequirementAdjusted"
				Mission        = "#mission#"
				ProgramCode    = "#ProgramCode#"
				Period         = "#Period#"	
				EditionId      = "#editionId#"
				Support		   = "#Support#" 
				Mode           = "table">				
					
		    <!--- check if diaz uses this in reports still --->

			<cftransaction isolation="read_uncommitted">

			<cfquery name="Funding" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    '#Mission#' as Mission, 
				          PAD.Fund,
						  <cfif ObjectParent eq "0">						  
				          PAD.ObjectCode, 
						  <cfelse>
						  OBJ.ParentCode as ObjectCode,
						  </cfif>
				          PA.ProgramCode,
						  <cfif ProgramActivity eq "1">
						  PAD.ActivityId,
						  </cfif>
						  <cfif Class eq "Category">
						  PAD.BudgetCategory,
						  </cfif>
						  
						  <!--- roll up changed 10/8/2015 Hanno --->						  
						  (SELECT PeriodHierarchy 
						   FROM   ProgramPeriod
						   WHERE  ProgramCode = Pa.ProgramCode
						   AND    Period = '#period#' ) as ProgramHierarchy,
					 						  						  
						   <!--- removed 
						  <cfif status eq "0">
						  PAD.Status,
						  </cfif>
						  --->
						  
						  SUM(PAD.RequestAmountBase*(ED.PercentageRelease/100)) AS Total 
				<cfif Mode eq "Table">		  
				INTO      userquery.dbo.#table#
				</cfif>
				FROM      ProgramPeriod Pe 
				          INNER JOIN ProgramAllotment PA ON Pe.ProgramCode = PA.ProgramCode AND Pe.Period = PA.Period
				          INNER JOIN UserQuery.dbo.#SESSION.acc#Requirement PAD ON PA.ProgramCode = PAD.ProgramCode AND PA.Period = PAD.Period AND PA.EditionId = PAD.EditionId
						  INNER JOIN Ref_AllotmentEditionFund ED ON ED.Fund = PAD.Fund AND ED.EditionId = PA.EditionId
						  <cfif ObjectParent eq "1">
						  INNER JOIN stObject OBJ ON OBJ.Code = PAD.ObjectCode 
						  </cfif>
				
				<!--- --- planning period-------------- --->			
				WHERE     PE.Period    = '#period#'
				
				<!--- edition of the budget to be shown --->
				AND       PA.EditionId IN (#preservesinglequotes(EditionId)#)
								
				<!--- ---valid unit selection filter--- --->						
				AND       Pe.OrgUnit IN (SELECT OrgUnit 
							            FROM    Organization.dbo.Organization
									    WHERE   Mission   = '#Mission#'
									    <cfif   MandateNo neq "">
										AND     MandateNo = '#MandateNo#'
										</cfif>									
										<cfif  unitHierarchy neq "" and unithierarchy neq "undefined">																			
										AND     HierarchyCode LIKE ('#unithierarchy#%')  
										</cfif>
									   )
								
				
				<cfif Class neq "" and ClassValue neq "">
				
					<cfif Class eq "Group">
					
						AND       EXISTS (SELECT 'X' 
				                          FROM   Program.dbo.ProgramGroup 
										  WHERE  ProgramCode = Pe.ProgramCode
										  AND    ProgramGroup = '#ClassValue#')
					
					<cfelse>
				
					    AND       PAD.BudgetCategory = '#ClassValue#'
											 
					</cfif>						 
				
				</cfif>		
				
				<!--- transaction selection date --->
					<cfif TransactionDate neq "">
						AND PAD.RequestDue >= #DTE#
					</cfif>

					<cfif TransactionDateEnd neq "">
						AND PAD.RequestDue <= #DTEEnd#
					</cfif>
				
				<cfif Version.ProgramClass neq "">
				
				AND       PA.ProgramCode IN (
                             SELECT ProgramCode 
                             FROM   Program.dbo.Program
							 WHERE  ProgramCode = PA.ProgramCode
							 AND    ProgramClass IN (#QuotedValueList(Version.ProgramClass)#)						 
							)
				
				</cfif>	
							
				<cfif ProgramHierarchy neq "">		
						
				AND       PA.ProgramCode IN (
				                             SELECT P.ProgramCode 
				                             FROM   Program.dbo.Program P, Program.dbo.ProgramPeriod Pe
											 WHERE  P.ProgramCode = Pe.ProgramCode
											 AND    Pe.Period     = '#period#'
											 AND    Pe.Status    != '9'											 
											 AND    Pe.PeriodHierarchy LIKE '#ProgramHierarchy#%'
											)	
											
				<cfelseif	ProgramCode neq "">				
				AND       PA.ProgramCode = '#ProgramCode#'														
				</cfif>
				
				<cfif Fund neq "">
				AND       PAD.Fund = '#Fund#'
				</cfif>
				
				<cfif Resource neq "">
				
				AND       PAD.ObjectCode IN (SELECT Code 
				                             FROM   Program.dbo.Ref_Object
											 WHERE  Resource = '#Resource#')
				<cfelseif Object neq "">
				
					<cfif ObjectChildren eq "0">
					AND   PAD.ObjectCode = '#Object#'
					<cfelse>
					AND  (
					      PAD.ObjectCode = '#Object#' OR 
					      PAD.ObjectCode IN (SELECT Code 
						                     FROM   Ref_Object 
											 WHERE  ParentCode = '#Object#'
									   )
						  )
					</cfif>
							 
				</cfif>
				
				AND       Pe.RecordStatus != '9'	
				
				AND       PAD.ActionStatus IN ('0','1')			
							
				<!--- incorrect 
								
				<cfif status eq "0">			
				
				<!--- Pending requirement P, cleared for allotment 0, allotted 1 (confirmed or not confirmed in the batch) 
				adjusted by Hanno to support a partial amount to be alloted --->				
				
				AND PAD.ActionStatus IN ('0','1') 
				<cfelseif status eq "1">
				AND PAD.ActionStatus = '1'
				</cfif>		
				
				--->	
							
				GROUP BY PAD.Fund, 
						 <cfif ObjectParent eq "0">						  
				         PAD.ObjectCode, 
						 <cfelse>
						 OBJ.ParentCode,
						 </cfif>				
				         PAD.ObjectCode, 
						 <cfif Class eq "Category">
						 PAD.BudgetCategory,
						 </cfif>
						 PA.ProgramCode,
						 <cfif ProgramActivity eq "1">
						 PAD.ActivityId,
						 </cfif>
						 PAD.ActionStatus, 
						 ED.PercentageRelease  
						 
			</cfquery>
			
			<!--- checking end --->
			
			</cftransaction>			
		
		<cfelse>
				 
			<cfif status eq "2">
			    <!--- take from allocation table --->
			    <cfset allocation = "1">				
			<cfelse>
				<cfset allocation = "0"> 				
			</cfif>

			<cftransaction isolation="read_uncommitted">
												
			<cfquery name="Funding" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    '#Mission#' as Mission, 
				          PAD.Fund,
				          <cfif ObjectParent eq "0">						  
				          PAD.ObjectCode, 
						  <cfelse>
						  OBJ.ParentCode as ObjectCode,
						  </cfif>
				          PA.ProgramCode,
						  
						   <!--- roll up changed 10/8/2015 Hanno --->
													   
						  (SELECT PeriodHierarchy 
						   FROM   ProgramPeriod
						   WHERE  ProgramCode = Pa.ProgramCode
						   AND    Period = '#period#' ) as ProgramHierarchy,
						   						   
						   <cfif allocation eq "0">
						        <!---
							  	<cfif status eq "">
								  PAD.Status,
								</cfif>
								--->
								SUM(PAD.#BudgetAmount#*(ED.PercentageRelease/100)) AS Total 
						   <cfelse>
							    '1' as Status,
							    SUM(PAD.Amount) AS Total 						   	  
						   </cfif>	  
						 
				<cfif Mode eq "Table">		  
				INTO      userquery.dbo.#table#
				</cfif>
				
				<cfif allocation eq "0">
				FROM      ProgramPeriod Pe 
				          INNER JOIN ProgramAllotment PA ON Pe.ProgramCode = PA.ProgramCode AND Pe.Period = PA.Period
				          INNER JOIN ProgramAllotmentDetail PAD ON PA.ProgramCode = PAD.ProgramCode AND PA.Period = PAD.Period AND PA.EditionId = PAD.EditionId
						  INNER JOIN Ref_AllotmentEditionFund ED ON ED.Fund = PAD.Fund AND ED.EditionId = PA.EditionId
						  <cfif ObjectParent eq "1">
						  INNER JOIN stObject OBJ ON OBJ.Code = PAD.ObjectCode
						  </cfif>
				<cfelse>
				FROM      ProgramPeriod Pe 
				          INNER JOIN ProgramAllotment PA ON Pe.ProgramCode = PA.ProgramCode AND Pe.Period = PA.Period
				          INNER JOIN ProgramAllotmentAllocation PAD ON PA.ProgramCode = PAD.ProgramCode AND PA.Period = PAD.Period AND PA.EditionId = PAD.EditionId
						  INNER JOIN Ref_AllotmentEditionFund ED ON ED.Fund = PAD.Fund AND ED.EditionId = PA.EditionId							
						  <cfif ObjectParent eq "1">
						  INNER JOIN stObject OBJ ON OBJ.Code = PAD.ObjectCode
						  </cfif>
				</cfif>		  
				
				<!--- planning period --->			
				WHERE     PE.Period    = '#period#'
				
				<!--- edition of the budget to be shown --->
				AND       PA.EditionId IN (#preservesinglequotes(EditionId)#)
				
				<cfif allocation eq "0">
				
					<!--- transaction selection date --->
					<cfif TransactionDate neq "">
						AND PAD.TransactionDate >= #DTE#
					</cfif>

					<cfif TransactionDateEnd neq "">
						AND PAD.TransactionDate <= #DTEEnd#
					</cfif>
								
				<cfelse>
				
					<!--- OICT pending to be applied requires table content review of ProgramAllotmentAllocation ---> 
				
				</cfif>
												
				<!--- valid unit selection filter --->						
				AND       Pe.OrgUnit IN (SELECT OrgUnit 
							            FROM   Organization.dbo.Organization
									    WHERE  Mission   = '#Mission#'
									    <cfif MandateNo neq "">
										AND    MandateNo = '#MandateNo#'
										</cfif>									
										<cfif unitHierarchy neq "" and unithierarchy neq "undefined">																		
										AND    HierarchyCode LIKE ('#unithierarchy#%')  
										</cfif>
									   )								
				
				
				<cfif Class neq "" and ClassValue neq "">
				
					<cfif Class eq "Group">
					
						AND       EXISTS  (SELECT 'X' 
		                                     FROM   Program.dbo.ProgramGroup 
											 WHERE  ProgramCode = PA.ProgramCode
									         AND    ProgramGroup = '#ClassValue#')
					
					<cfelse>
				
					    AND       EXISTS  (SELECT 'X' 
				                             FROM   Program.dbo.ProgramCategory 
											 WHERE  ProgramCode = PA.ProgramCode
									         AND    ProgramCategory = '#ClassValue#')
											 
					</cfif>						 
				
				</cfif>		

				<cfif Version.ProgramClass neq "">
				
				AND       PA.ProgramCode IN (
                             SELECT ProgramCode 
                             FROM   Program.dbo.Program
							 WHERE  ProgramCode = PA.ProgramCode
							 AND    ProgramClass IN (#QuotedValueList(Version.ProgramClass)#)
							)
				
				</cfif>		

				<cfif ProgramHierarchy neq "">
				
				AND       PA.ProgramCode IN (
				                             SELECT P.ProgramCode 
				                             FROM   Program.dbo.Program P, Program.dbo.ProgramPeriod Pe
											 WHERE  P.ProgramCode = Pe.ProgramCode
											 AND    Pe.Period = '#period#'
											 AND    Pe.Status != '9'
											 AND    Pe.PeriodHierarchy LIKE '#ProgramHierarchy#%'											
											)	
												
				<cfelseif ProgramCode neq "">
				
				AND       PA.ProgramCode = '#ProgramCode#'
																
				</cfif>
				
				<cfif Fund neq "">
				AND       PAD.Fund = '#Fund#'
				</cfif>
				
				<cfif Resource neq "">
				AND       PAD.ObjectCode IN (SELECT Code 
				                             FROM Program.dbo.Ref_Object
											 WHERE Resource = '#Resource#')
											 
				<cfelseif Object neq "">
				
					<cfif ObjectChildren eq "0">
					AND   PAD.ObjectCode = '#Object#'
					<cfelse>
					AND  (
					      PAD.ObjectCode = '#Object#' OR 
					      PAD.ObjectCode IN (SELECT Code 
						                     FROM   Ref_Object 
										     WHERE  ParentCode = '#Object#'
									   )
						  )
					</cfif>		
										 
				</cfif>
				
				AND       Pe.RecordStatus != '9'
					
				<cfif allocation eq "0">
				
					<cfif status eq "0">			
					AND PAD.Status IN ('P','0','1')
					
					<!--- exclude transfer transactions --->
					
					AND (ActionId NOT IN
                        	     (SELECT     ActionId
                            	  FROM       ProgramAllotmentAction
                               	  WHERE      ActionClass = 'Transfer') OR ActionId IS NULL)

					<!--- Begin validation of Budget approved --->
					
					<cfelseif status eq "3">
						AND  (
								((PAD.Status = '1') AND (PAD.ActionId IS NULL))
								
								OR
								
								((PAD.Status = '1') AND (PAD.ActionId IS NOT NULL) AND 
								
								 <!--- no workflow we take it regardless --->
								 
								 (PAD.ActionId NOT IN (
													 	SELECT OO.objectKeyValue4
														FROM   Organization.dbo.OrganizationObject OO
														WHERE  OO.ObjectKeyValue4 = PAD.ActionId
														<!---  INNER JOIN Organization.dbo.OrganizationObjectAction OA ON OO.ObjectId = OA.ObjectId --->
														AND    EntityCode = 'EntBudgetAction'
													 )
								))
								
								OR
								
								<!--- if the status of the action is 3 we take it as well --->
								
								( 
									PAD.Status = '1' AND PAD.ActionId IN ( SELECT ActionId 
																		   FROM   ProgramAllotmentAction PA
																		   WHERE  PA.ActionId = PAD.ActionId
																		   AND    Status = '3'
																		)
								)									
							)
							
							
							

					<!--- end validation of Budget approved --->
					
					
					<cfelse>
					AND PAD.Status = '1'
					</cfif>						
				
				
				</cfif>
				
				GROUP BY PAD.Fund, 
						 <cfif ObjectParent eq "0">						  
				         PAD.ObjectCode, 
						 <cfelse>
						 OBJ.ParentCode,
						 </cfif>				      
						 PA.ProgramCode,
						 
						 <!--- disabled on 12/9/2011 by hanno
						 <cfif allocation eq "0">
						 PAD.Status, 
						 </cfif>
						 --->
						 
						 ED.PercentageRelease  
						 
			</cfquery>
		
			</cftransaction>	
						
		</cfif>					
								
		<cfif mode eq "view">
			<cfreturn Funding>		
		<cfelse>
	
		<cfquery name="Index" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		CREATE  INDEX [ProgramInd] 
		   ON dbo.#table#([ProgramHierarchy],[Fund]) ON [PRIMARY] 
		</cfquery>	

		</cfif>
		
	</cffunction>		
	
	<!--- ------------------------------------- --->
	<!--- ----------- PRE ENCUMBRANCE---------- --->
	<!--- ------------------------------------- --->
		
	<cffunction name="Requisition"
             access="public"
             returntype="any"
             displayname="Requisitions">
		
		<cfargument name="Mission"          type="string" required="true">	
		<cfargument name="MandateNo"        type="string" required="true"  default="">
		<cfargument name="EditionId"        type="string" required="true"  default="">
		<!--- to be applied --->
		<cfargument name="TransactionDate"  type="string" required="false" default="">
		<cfargument name="TransactionDateEnd"  type="string" required="false" default="">
		<!--- ------------- --->
		
		<cfargument name="Period"           type="string" required="true">	
		<cfargument name="UnitHierarchy"    type="string" required="true"  default="">			
		<cfargument name="ProgramCode"      type="string" required="false" default="">
		<cfargument name="ProgramActivity"  type="string" required="false" default="0">
		<cfargument name="ProgramHierarchy" type="string" required="false" default="">		
		<cfargument name="Fund"             type="string" required="false" default="">
		<cfargument name="Currency"         type="string" required="false" default="#application.baseCurrency#">	
		<cfargument name="Class"            type="string" required="false" default="">
		<cfargument name="ClassValue"       type="string" required="false" default="">
		<cfargument name="Resource"         type="string" required="false" default="">
		<cfargument name="ObjectParent"     type="string" required="false" default="0">
		<cfargument name="Object"           type="string" required="false" default="">
		<cfargument name="ObjectChildren"   type="string" required="false" default="0">
		<cfargument name="Status"           type="string" required="false" default="cleared">		
		<cfargument name="Content"          type="string" required="true"  default="Sum">
		<cfargument name="Mode"             type="string" required="true"  default="Table">
		<cfargument name="Table"            type="string" required="false" default="#SESSION.acc#Requisition">
		
		 <cfquery name="Param" 
			     datasource="AppsProgram" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT     *
			     FROM       Ref_ParameterMission 
			     WHERE      Mission = '#Mission#'			 
		    </cfquery>  	
				
		<cfif status eq "planned" and Param.EnableForecast eq "1">
						
		    <cfif mode eq "view">
									
				<cfinvoke component = "Service.Process.Program.Execution"  
				   method             = "Disbursement" 
				   mission            = "#mission#"
				   mandateNo          = "#mandateno#"
				   editionid          = "#editionid#"
				   Currency           = "#currency#"
				   ProgramCode        = "#ProgramCode#"
				   ProgramHierarchy   = "#ProgramHierarchy#"  
				   ProgramActivity	  = "#ProgramActivity#"
				   Fund               = "#fund#"
				   Class              = "#Class#" 
				   ClassValue         = "#ClassValue#"
				   GLCategory         = "forecast"
				   unithierarchy      = "#unithierarchy#"
				   period             = "#Period#" 
				   Object             = "#object#"
				   ObjectChildren     = "#objectChildren#"
				   scope              = "Budget"
				   Content            = "#Content#"
				   TransactionSource  = "'ForecastSeries'"			     
				   mode               = "table"				  
				   table              = "#table#">	
				   
				   <cfquery name="Requisition" 
					datasource="AppsPurchase">				
					SELECT *
					FROM userquery.dbo.#table#
				  </cfquery>							   
				  
				  <cfreturn Requisition>	
				   
			<cfelse>
									
				<cfinvoke component = "Service.Process.Program.Execution"  
				   method             = "Disbursement" 
				   mission            = "#mission#"
				   mandateNo          = "#mandateno#"
				   editionid          = "#editionid#"
				   Currency           = "#currency#"
				   ProgramCode        = "#ProgramCode#"
				   ProgramHierarchy   = "#ProgramHierarchy#"  
				   Fund               = "#fund#"
				   Class              = "#Class#" 
				   ClassValue         = "#ClassValue#"
				   GLCategory         = "forecast"
				   unithierarchy      = "#unithierarchy#"
				   period             = "#Period#" 
				   Object             = "#object#"
				   ObjectChildren     = "#objectChildren#"
				   scope              = "Budget"
				   Content            = "#Content#"
				   TransactionSource  = "'ForecastSeries'"			     
				   mode               = "table"				  
				   table              = "#table#">				
			   
			</cfif>	   				
				 				
		<cfelse>
						
			<cfquery name="getPlanPeriod" 
			    datasource="AppsProgram" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">		
				SELECT   TOP 1 PlanningPeriod
				FROM     Organization.dbo.Ref_MissionPeriod
				WHERE    Mission = '#mission#'
				<cfif MandateNo neq "">
				AND      MandateNo = '#mandateno#'
				</cfif>
				<cfif Period neq "">
				AND   Period IN (#preservesingleQuotes(Period)#)   
				</cfif>
				ORDER BY MandateNo DESC
			</cfquery>
				
			
			<cfset planningperiod = getPlanPeriod.PlanningPeriod>
					
			<cfquery name="Edition" 
			    datasource="AppsProgram" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_AllotmentEdition
				WHERE  EditionId = '#EditionId#' 
			</cfquery>
			
			<!--- added to retrieve only the relevant programs for this version --->
			
			<cfquery name="Version" 
			    datasource="AppsProgram" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_AllotmentVersion
				WHERE  Code = '#Edition.Version#' 
			</cfquery>
			
			<cfif mode eq "Table">
				<CF_DropTable dbName="AppsQuery" tblName="#table#">
			</cfif>
			
			<cfif mode eq "CreateView">
						
				<cfquery name="Drop"
					datasource="AppsPurchase">
				      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[#table#]') 
					 and OBJECTPROPERTY(id, N'IsView') = 1)
				     drop view [dbo].[#table#]
				</cfquery>
						
			</cfif>
							
			<cfquery name="Parameter" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_ParameterMission
					WHERE  Mission = '#Mission#' 
			</cfquery>
			
			<cfif ProgramActivity eq "1">
			
				<cfsavecontent variable="LineFunding">
				
				        <!--- a view that has generated table on the activities to be funded --->
						
						<cfoutput>
							(SELECT    LF.RequisitionNo, 
							           LF.FundingId, 
									   LF.Fund, 
									   LF.ProgramPeriod, 
									   LF.ProgramCode, 
									   LA.ActivityId, 
									   LF.ObjectCode, 
									   CASE WHEN LA.Percentage IS NULL OR LA.Percentage = 0 THEN LF.Percentage ELSE LF.Percentage * LA.Percentage END AS Percentage
							FROM       Purchase.dbo.RequisitionLineFunding LF LEFT OUTER JOIN
					                   Purchase.dbo.RequisitionLineFundingActivity LA ON LF.RequisitionNo = LA.RequisitionNo AND LF.FundingId = LA.FundingId)	
						</cfoutput>
								   						
				</cfsavecontent>	
				
			<cfelse>
			
				<cfset LineFunding = "RequisitionLineFunding">
			
			</cfif>
			
			<cftransaction isolation="read_uncommitted">
			
			<cfquery name="Requisition" 
				datasource="AppsPurchase">
				
				<cfif Mode eq "CreateView">
				CREATE VIEW dbo.#table# AS	
				</cfif>
				
						
				SELECT  <cfif Mode eq "CreateView">
						TOP 1000
						</cfif>
						
						<cfif content eq "sum">
						
												
					          R.Mission,						  				  
							  SUM(L.Percentage * R.RequestAmountCurrency) AS ReservationAmount,
						  <cfelse>
						 					  
						  						  
							  M.Description as ItemMasterDescription,
							  R.*,						  
							  (L.Percentage * R.RequestAmountCurrency) AS ReservationAmount,
						  </cfif>
				          Fund,
						  ProgramCode,
						  
						  <!--- roll up changed 10/8/2015 Hanno --->
						  
						  (SELECT PeriodHierarchy 
						   FROM   Program.dbo.ProgramPeriod 
						   WHERE  ProgramCode = L.ProgramCode
						   AND    Period      = '#PlanningPeriod#') as ProgramHierarchy, 
						   
						   <cfif ProgramActivity eq "1">
						   ActivityId,
						   </cfif>
							   
						   <cfif ObjectParent eq "0">						  
					          L.ObjectCode 
						   <cfelse>
							  OBJ.ParentCode as ObjectCode
						   </cfif>	   
				         		  
						 
				<cfif Mode eq "Table">		  
				INTO      userquery.dbo.#table#
				</cfif>
					
				
				FROM      (
							SELECT *, 
								   CASE    RequestCurrency WHEN '#application.basecurrency#' THEN RequestAmountBase 
					                       				   WHEN '#Currency#' THEN RequestQuantity * RequestCurrencyPrice  															            
														   ELSE RequestAmountBase * (SELECT   TOP 1 ExchangeRate
																					 FROM     Accounting.dbo.CurrencyExchange V
																					 WHERE    V.Currency       = '#Currency#' <!--- requested currency --->
																					 AND      V.EffectiveDate <= L.RequestDate
																					 ORDER BY V.EffectiveDate DESC) 
								   END as RequestAmountCurrency 
				           FROM   RequisitionLine L
						   WHERE  Mission = '#mission#'
						   <cfif status eq "">			
						   AND    L.ActionStatus >= '2' AND L.ActionStatus < '2z'  								 
						   <cfelseif status eq "cleared">						
						   AND    L.ActionStatus IN ('2i','2k','2q')
						   <cfelseif status eq "planned">
							
							    <cfif Parameter.FundingByReviewer eq "1e">							
								AND     L.ActionStatus IN ('2f')									 
								<cfelse>							
								AND     L.ActionStatus IN ('2','2a','2b','2f')
								</cfif>		 
								
						   <cfelseif status eq "pipeline">
							
							    <cfif Parameter.FundingByReviewer eq "1e">							 
								<cfif   Param.EnableForecast eq "1">
								AND     L.ActionStatus IN ('1','1f','1p','2','2a','2b')
								<cfelse>
								AND     L.ActionStatus IN ('1f','1p','2','2a','2b') 
								</cfif>
								<cfelse>	
								<cfif   Param.EnableForecast eq "1">					
								AND     L.ActionStatus IN ('1','1f','1p')									
								<cfelse>
								AND     L.ActionStatus IN ('1f','1p')	
								</cfif>
								</cfif>
										 
						   <cfelseif status eq "formal">
								AND    L.ActionStatus IN ('2','2a','2b','2f','2i','2k','2q')				 	 
				  		   </cfif>			
						  					   
						   ) as R			
				
						  INNER JOIN #LineFunding# L ON R.RequisitionNo = L.RequisitionNo 
						  INNER JOIN ItemMaster M ON M.Code = R.ItemMaster
						  <cfif ObjectParent eq "1">
						  INNER JOIN Program.dbo.stObject OBJ ON OBJ.Code = L.ObjectCode
						  </cfif>
						  
				WHERE     1=1
				
				<cfif period eq "">
				<!---     select all periods for execution --->
				<cfelse>
				AND       L.ProgramPeriod IN (#preservesingleQuotes(Period)#) 
				</cfif>		
				
				<cfif Version.ProgramClass neq "">
								
				AND       L.ProgramCode IN (
		                        SELECT ProgramCode 
		                        FROM   Program.dbo.Program
								WHERE  ProgramCode = L.ProgramCode
								AND    ProgramClass= '#Version.ProgramClass#'
						  )
					
				</cfif>		
							
				<!--- org filter on the program execution --->
							
				AND       L.ProgramCode IN (SELECT DISTINCT ProgramCode
				                            FROM   Program.dbo.ProgramPeriod 
											WHERE  Period IN (
											                  SELECT PlanningPeriod 
	                                                          FROM   Organization.dbo.Ref_MissionPeriod 
							                                  WHERE  Mission = '#Mission#' 
															  <cfif period neq "">
							                                  AND    Period IN (#preservesingleQuotes(Period)#)
															  </cfif>
															  ) 	 
										
											AND    OrgUnit IN (SELECT OrgUnit 
											                   FROM   Organization.dbo.Organization
															   WHERE  Mission   = '#mission#'
															   <cfif MandateNo neq "">
															   AND    MandateNo = '#MandateNo#'
															   </cfif>
															   <cfif unitHierarchy neq "">
															   AND    HierarchyCode LIKE ('#unithierarchy#%')
															   </cfif>
															   )
											)														
							
				<cfif Class neq "" and ClassValue neq "">
				
					<cfif Class eq "Group">
					
						AND       L.ProgramCode IN (SELECT ProgramCode 
				                                    FROM   Program.dbo.ProgramGroup 
													WHERE  ProgramCode   = L.ProgramCode
											        AND    ProgramGroup  = '#ClassValue#')
					
					<cfelse>
				
					    AND       L.ProgramCode IN (SELECT ProgramCode 
				                                    FROM   Program.dbo.ProgramCategory 
													WHERE  ProgramCode     = L.ProgramCode
											        AND    ProgramCategory = '#ClassValue#')
											 
					</cfif>						 
				
				</cfif>			
				
				<cfif ProgramHierarchy neq "">
												
					AND    L.ProgramCode IN (SELECT ProgramCode 
					                         FROM   Program.dbo.ProgramPeriod
											 WHERE  Period = '#PlanningPeriod#' 
											 AND    PeriodHierarchy LIKE '#ProgramHierarchy#%')
											
				<cfelse>
				
					<cfif ProgramCode neq "">			
						AND   L.ProgramCode = '#ProgramCode#'
					<cfelse>			
						AND   L.ProgramCode IN (SELECT ProgramCode
						                        FROM   Program.dbo.Program 
												WHERE  Mission = '#mission#')
					</cfif>								
																					
				</cfif>
				
				<cfif Fund neq "">
					AND    L.Fund = '#Fund#'
				<cfelse>
					AND    L.Fund IN (SELECT Fund FROM Program.dbo.Ref_Fund)
				</cfif>
				
				<cfif Resource neq "">
				
				   AND     L.ObjectCode IN (SELECT Code FROM Program.dbo.Ref_Object WHERE Resource = '#Resource#')
				
				<cfelse>
				
					<cfif Object neq "">
					
						<cfif ObjectChildren eq "0">
							AND       L.ObjectCode = '#Object#'
						<cfelse>
							AND  (
							      L.ObjectCode = '#Object#' OR 
							      L.ObjectCode IN (SELECT Code 
								                   FROM   Program.dbo.Ref_Object 
												   WHERE  ParentCode = '#Object#')
								  )
						</cfif>			
						
					<cfelse>
						
						<!--- only valid objects within this edition --->
					
						AND    L.ObjectCode IN (SELECT Code 
												FROM   Program.dbo.Ref_Object 
												WHERE  Code = L.ObjectCode
												<cfif editionid neq "">
												AND    ObjectUsage = (SELECT   TOP 1 V.ObjectUsage
																	  FROM     Program.dbo.Ref_AllotmentEdition E INNER JOIN
															                   Program.dbo.Ref_AllotmentVersion V ON E.Version = V.Code
																	  WHERE    E.EditionId = '#editionid#')														  
											    </cfif>
												)
							
					</cfif>
							   
				</cfif>			
				
				
				<cfif content eq "sum">
				GROUP BY  R.Mission,
				          L.Fund,
						  L.ProgramCode,
						  <cfif ProgramActivity eq "1">
						  L.ActivityId,
						  </cfif> 
						  <cfif ObjectParent eq "0">						  
					      L.ObjectCode 
						  <cfelse>
						  OBJ.ParentCode
						  </cfif>		 
				<cfelse>
				ORDER BY Period,R.RequisitionNo
				</cfif>
			</cfquery>
			
			</cftransaction>
						
			<cfif mode eq "View">
				
				<cfreturn Requisition>		
				
			<cfelseif mode eq "Table">
					
				<cfquery name="Index" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					CREATE  INDEX [ProgramInd] 
					   ON dbo.#table#([ProgramHierarchy],[Fund]) ON [PRIMARY]
				</cfquery>		
				
			</cfif>
			
		</cfif>			
		
	</cffunction>
		
	<!--- ------------------------------------- --->
	<!--- ------------ OBLIGATION ------------- --->
	<!--- ------------------------------------- --->
	
	<cffunction name="Obligation"
             access="public"
             returntype="any"
             displayname="Obligation">
		
		<cfargument name="Mission"          type="string" required="true">	
		<cfargument name="MandateNo"        type="string" required="true"  default="">
		<cfargument name="EditionId"        type="string" required="true"  default="">
		<cfargument name="UnitHierarchy"    type="string" required="true"  default="">		
		<cfargument name="Period"           type="string" required="true">	
		
		<!--- to be applied --->
		<cfargument name="TransactionDate"  type="string" required="false" default="">
		<cfargument name="TransactionDateEnd"  type="string" required="false" default="">
		<!--- ------------- --->
		
		<cfargument name="ProgramCode"      type="string" required="false" default="">	
		<cfargument name="ProgramActivity"  type="string" required="false" default="0">
		<cfargument name="ProgramHierarchy" type="string" required="false" default="">	
		<cfargument name="Currency"         type="string" required="false" default="#application.baseCurrency#">	
		<cfargument name="Fund"             type="string" required="false" default="">
		<cfargument name="Class"            type="string" required="false" default="">
		<cfargument name="ClassValue"       type="string" required="false" default="">
		<cfargument name="Resource"         type="string" required="false" default="">		
		<cfargument name="ObjectParent"     type="string" required="false" default="0">
		<cfargument name="Object"           type="string" required="false" default="">
		<cfargument name="ObjectChildren"   type="string" required="false" default="0">
		<cfargument name="Scope"            type="string" required="true"  default="All">
		<cfargument name="Content"          type="string" required="true"  default="Sum">
		<cfargument name="Mode"             type="string" required="true"  default="Table">
		<cfargument name="Table"            type="string" required="false" default="#SESSION.acc#Obligation">
		
		<cfif currency eq application.baseCurrency>
		
			<cfset exc = "1">
						
		<cfelse>
				
			<!--- obtain the exchange rate for the budget currency as per last date of the period request 
			as obligations are future expenses --->
		
			<cfquery name="getPeriod" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		
				SELECT   *
				FROM     Ref_Period
				<cfif Period neq "">
				WHERE    Period IN (#preservesingleQuotes(Period)#)   
				</cfif>
				ORDER BY DateEffective DESC
			</cfquery>		
			
			<!--- we might want to obtain the average exchange rate of the period --->
		
			<cf_exchangeRate datasource = "appsProgram"
			      EffectiveStart  = "#dateformat(getPeriod.DateEffective,client.dateformatshow)#" 			            
				  EffectiveDate   = "#dateformat(getPeriod.DateExpiration,client.dateformatshow)#"						
				  CurrencyFrom    = "#application.baseCurrency#"
				  CurrencyTo      = "#Currency#"> 			
		
			<cfif exc eq "0">
				<cfset exc = "1">
			</cfif>
		
		</cfif>
		
		<cfquery name="getPlanPeriod" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		
			SELECT   TOP 1 PlanningPeriod
			FROM     Organization.dbo.Ref_MissionPeriod
			WHERE    Mission = '#mission#'
			<cfif MandateNo neq "">
			AND      MandateNo = '#mandateno#'
			</cfif>
			<cfif Period neq "">
			AND   Period IN (#preservesingleQuotes(Period)#)   
			</cfif>
			ORDER BY MandateNo DESC
		</cfquery>	
		
		<cfset planningperiod = getPlanPeriod.PlanningPeriod>
		
		<cfquery name="Edition" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_AllotmentEdition
			WHERE EditionId = '#EditionId#' 
		</cfquery>
		
		<cfquery name="Version" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_AllotmentVersion
			WHERE Code = '#Edition.Version#' 
		</cfquery>
		
		<cfif mode eq "Table">
			<CF_DropTable dbName="AppsQuery" tblName="#table#">
		</cfif>
		
		<cfif mode eq "CreateView">
					
			<cfquery name="Drop"
				datasource="AppsPurchase">
			      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[#table#]') 
				 and OBJECTPROPERTY(id, N'IsView') = 1)
			     drop view [dbo].[#table#]
			</cfquery>
					
		</cfif>
		
		<cfif ProgramActivity eq "1">
		
			<cfsavecontent variable="LineFunding">
			
			        <!--- a view that has generated table on the activities to be funded --->
					
					<cfoutput>
						(SELECT    LF.RequisitionNo, 
						           LF.FundingId, 
								   LF.Fund, 
								   LF.ProgramPeriod, 
								   LF.ProgramCode, 
								   LA.ActivityId, 
								   LF.ObjectCode, 
								   CASE WHEN LA.Percentage IS NULL OR LA.Percentage = 0 THEN LF.Percentage ELSE LF.Percentage * LA.Percentage END AS Percentage
						FROM       Purchase.dbo.RequisitionLineFunding LF LEFT OUTER JOIN
				                   Purchase.dbo.RequisitionLineFundingActivity LA ON LF.RequisitionNo = LA.RequisitionNo AND LF.FundingId = LA.FundingId)		
					</cfoutput>
							   						
			</cfsavecontent>	
			
		<cfelse>
		
			<cfset LineFunding = "RequisitionLineFunding">
		
		</cfif>
		
		<!--- create an execution table --->
				
		<!--- determine the mode of the matching for this mission, if the matching is
		   on the requisition line we are goiung to repopulate the temp table InvoicePurchaseFunding for that mission
		   
		   and the we use in the query 
		      the requisitionlinefunding for the unliquidated portion 
			  union
			  the new table for the liquidated portion   
		   
		--->   
		   
		 <cfquery name="Param" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM Ref_ParameterMission
			WHERE Mission = '#Mission#'			
		</cfquery>		
		
		<cfsavecontent variable="condition">
		
				<cfoutput>
				
			    <!--- ------------------ --->
				<!--- -----PERIOD------- --->
				<!--- ------------------ --->
				
				<cfif period eq "">
				<!---     select all periods for execution --->
				<cfelse>
				AND       L.ProgramPeriod IN (#preservesingleQuotes(Period)#) 
				</cfif>
								
				<!--- org filter on the program execution --->
			
				AND       L.ProgramCode IN (SELECT DISTINCT ProgramCode
				                            FROM   Program.dbo.ProgramPeriod 
											WHERE  ProgramCode = L.ProgramCode
											AND    Period IN (
										                  SELECT PlanningPeriod 
                                                          FROM   Organization.dbo.Ref_MissionPeriod 
						                                  WHERE  Mission = '#Mission#' 
														  <cfif period neq "">
						                                  AND    Period IN (#preservesingleQuotes(Period)#)
														  </cfif>
														  ) 	 
									
											AND    OrgUnit IN (SELECT OrgUnit 
											                   FROM   Organization.dbo.Organization
															   WHERE  Mission   = '#mission#'
															   <cfif MandateNo neq "">
															   AND    MandateNo = '#MandateNo#'
															   </cfif>
															   <cfif unitHierarchy neq "">
															   AND    HierarchyCode LIKE ('#unithierarchy#%')
															   </cfif>
															   	   )
										)				   
				
				
				<cfif Version.ProgramClass neq "">
				
				AND       L.ProgramCode IN (
	                        SELECT ProgramCode 
	                        FROM   Program.dbo.Program
							WHERE  ProgramCode = L.ProgramCode
							AND    ProgramClass= '#Version.ProgramClass#'
							)
					
				</cfif>								   
										   
				<!--- ------------------ --->
				<!--- -----GROUP-------- --->
				<!--- ------------------ --->						   
								
				<cfif Class neq "" and ClassValue neq "">
			
					<cfif Class eq "Group">
					
						AND       L.ProgramCode IN (SELECT ProgramCode 
				                             FROM   Program.dbo.ProgramGroup 
											 WHERE  ProgramCode = L.ProgramCode
											 AND    ProgramGroup = '#ClassValue#')
					
					<cfelse>
				
					    AND       L.ProgramCode IN (SELECT ProgramCode 
				                             FROM  Program.dbo.ProgramCategory 
											 WHERE ProgramCode = L.ProgramCode
											 AND   ProgramCategory = '#ClassValue#')
											 
					</cfif>						 
			
				</cfif>
				
				<!--- ------------------ --->
				<!--- -----PROGRAM------ --->
				<!--- ------------------ --->
												
				<cfif ProgramHierarchy neq "">		
													
				
				AND    L.ProgramCode IN (SELECT ProgramCode 
				                         FROM  Program.dbo.ProgramPeriod
										 WHERE Period = '#PlanningPeriod#' 
										 AND   PeriodHierarchy LIKE '#ProgramHierarchy#%')							
											
				<cfelse>
									
				  <cfif ProgramCode neq "">
					 AND      L.ProgramCode = '#ProgramCode#'
				 <cfelse>
					 AND      L.ProgramCode IN (SELECT ProgramCode 
					                            FROM   Program.dbo.Program 
												WHERE  Mission = '#mission#'
												AND    ProgramCode = L.ProgramCode)
				  </cfif>	
																				
				</cfif>
				
				<!--- ------------------ --->
				<!--- -------FUND------- --->
				<!--- ------------------ --->
				
				<cfif Fund neq "">
					AND       L.Fund = '#Fund#'
				<cfelse>
					AND       L.Fund IN (SELECT Fund 
					                     FROM   Program.dbo.Ref_Fund
										 WHERE  Fund = L.Fund)
				</cfif>
				
				<!--- ------------------ --->
				<!--- -------OBJECT----- --->
				<!--- ------------------ --->
				
				<cfif Resource neq "">
				
				   AND        L.ObjectCode IN (SELECT Code 
				                               FROM   Program.dbo.Ref_Object 
											   WHERE  Resource = '#Resource#')
				<cfelse>
				
					<cfif Object neq "">
					
						<cfif ObjectChildren eq "0">
							AND       L.ObjectCode = '#Object#'
							<cfelse>
							AND  (
							      L.ObjectCode = '#Object#' OR 
							      L.ObjectCode IN (SELECT Code 
								                   FROM   Program.dbo.Ref_Object 
												   WHERE  ParentCode = '#Object#')
								  )
						</cfif>			
					
					<cfelse>
											
							<!--- only valid objects within this edition --->
				
							AND    L.ObjectCode IN (SELECT Code 
												FROM   Program.dbo.Ref_Object 
												WHERE  Code = L.ObjectCode
												<cfif editionid neq "">
												AND    ObjectUsage = (
											                      SELECT   TOP 1 V.ObjectUsage
																  FROM     Program.dbo.Ref_AllotmentEdition E INNER JOIN
														                   Program.dbo.Ref_AllotmentVersion V ON E.Version = V.Code
																  WHERE    E.EditionId = '#editionid#'
																  )									    
										    </cfif>
											)
					
					</cfif>
					
				</cfif>	
													
				<!--- requisition is in purchase status --->												
				AND      R.ActionStatus   = '3' 
				
				<!--- line is not cancelled --->
				AND      P.ActionStatus  != '9'	
				
				<!--- purchase header is not cancelled --->
				AND      P.PurchaseNo NOT IN (SELECT PurchaseNo 
				                              FROM   Purchase 
											  WHERE  PurchaseNo = P.PurchaseNo 
											  AND    ActionStatus = '9')	
											  
				</cfoutput>							  				
				
		</cfsavecontent>
		
		<!--- matching of invoice is on the purchase level not on the lines 
		   or only unliquidated records are requested --->  
		   
		<cftransaction isolation="read_uncommitted">   
		
		<cfif Param.InvoiceRequisition eq "0" or scope eq "Unliquidated">		
		
			<cfquery name="Obligation" 
				datasource="AppsPurchase">
				
				<cfif Mode eq "CreateView">
				CREATE VIEW dbo.#table# AS	
				</cfif>
				
				SELECT  <cfif Mode eq "CreateView">
						TOP 1000
						</cfif>
				         <cfif content eq "sum">
				          
							  R.Mission,
							  
							  <cfif Scope eq "All">
		 
		                         <!--- unluidated + liquidaed = obligated --->
							 	 SUM((L.Percentage * P.OrderAmountBaseObligated)/#exc#) AS ObligationAmount,
		
							  <cfelse>
							  
							     <!--- unliquidated --->
							  	 SUM((L.Percentage * (P.OrderAmountBaseObligated-P.OrderAmountBaseLiquidated))/#exc#) AS ObligationAmount,
							  					  
							  </cfif>					  
						  
						 <cfelse>
						 
							  M.Description as ItemMasterDescription,
							  R.*,
							  
							  <cfif Scope eq "All">						  
							  	(L.Percentage * P.OrderAmountBaseObligated)/#exc# AS ObligationAmount,						  
							  <cfelse>						  
							  	(L.Percentage * (P.OrderAmountBaseObligated-P.OrderAmountBaseLiquidated))/#exc# AS ObligationAmount,						  
							  </cfif>
							  
							  P.PurchaseNo,
							  
						 </cfif>						 
						 
				         L.Fund,
						 
						 <cfif ObjectParent eq "0">						  
				          L.ObjectCode, 
					     <cfelse>
						  OBJ.ParentCode as ObjectCode,
					     </cfif>	 					   											
								
						 L.ProgramCode,
						 
						 <cfif ProgramActivity eq "1">
							 L.ActivityId,
						 </cfif>						 
						 
				 	     (SELECT PeriodHierarchy 
					      FROM   Program.dbo.ProgramPeriod					  
					      WHERE  ProgramCode = L.ProgramCode
						  AND    Period      = '#PlanningPeriod#') as ProgramHierarchy						  
						 
					<cfif Mode eq "Table">	
					INTO      userquery.dbo.#table#
					</cfif>	
				  
				    FROM      RequisitionLine R 
					          INNER JOIN #LineFunding# L ON R.RequisitionNo = L.RequisitionNo 
							  INNER JOIN  PurchaseLine P ON R.RequisitionNo = P.RequisitionNo INNER JOIN ItemMaster M ON M.Code = R.ItemMaster
							  <cfif ObjectParent eq "1">
							  INNER JOIN Program.dbo.stObject OBJ ON OBJ.Code = L.ObjectCode
							  </cfif>
							  
					WHERE     R.Mission        = '#Mission#'
					
					#preservesinglequotes(condition)#
					
					<cfif content eq "sum">
					GROUP BY  R.Mission,
					          L.Fund,
							  L.ProgramCode,
							  <CFIF ProgramActivity eq "1">
							  L.ActivityId,
							  </CFIF> 		
							  <cfif ObjectParent eq "0">						  
						      L.ObjectCode 
							  <cfelse>
							  OBJ.ParentCode
							  </cfif>		
							  					   
					<cfelse>
					ORDER BY  Period,R.RequisitionNo			
					</cfif>		
			</cfquery>
											
		<cfelse>	
			
			<!--- ---------------------------------------------------------------------------------------- --->		
			<!--- Approach is to join the 
			           unliquidated based on the requisition funding and 
					   liquidated portion based on the InvoicePurchasePosting table                        --->
			<!--- ---------------------------------------------------------------------------------------- --->		
					
			<cfquery name="Obligation" 
				datasource="AppsPurchase">
				
				<cfif Mode eq "CreateView">
				CREATE VIEW dbo.#table# AS	
				</cfif>				
				
				SELECT  <cfif Mode eq "CreateView">
						TOP 1000
						</cfif>
						
						Mission,							 
				        Fund,
						
		          		ObjectCode, 
						ProgramHierarchy,								
						ProgramCode, 
						
						<CFIF ProgramActivity eq "1">
						ActivityId,
						</CFIF> 		
						
				        <cfif content neq "sum">				          
							
							 RequisitionNo,
							 Reference,		
							 RequestDescription,					 						 			  
							 RequestType,
							 ItemMasterDescription,
							 Period,
							 RequestDate,												  							 							  
							 PurchaseNo,
							  
						 </cfif>		
						 
						SUM(ObligationAmount/#exc#) AS ObligationAmount	
						
				<cfif Mode eq "Table">	
					INTO     userquery.dbo.#table#
				</cfif>										
						 
				FROM 				
				
				<!--- -------------------- --->				
				<!--- BEGIN derrived table --->
				<!--- -------------------- --->
				
				(								
				
				<!--- --------------------- --->
				<!--- unliquidated portion- --->
				<!--- --------------------- --->				
				
				SELECT       <cfif content eq "sum">
					          
								 R.Mission,						  							  						    
							  	 SUM(L.Percentage * (P.OrderAmountBaseObligated-P.OrderAmountBaseLiquidated)) AS ObligationAmount,
								  	
							 <cfelse>
							 
								  M.Description as ItemMasterDescription,
								  R.RequisitionNo,
								  R.Mission,
								  R.Period,
								  R.Reference,		
								  R.RequestDescription,					 						 			  
								  R.RequestType,
								  R.RequestDate,						 						 			  
								  L.Percentage * (P.OrderAmountBaseObligated-P.OrderAmountBaseLiquidated) AS ObligationAmount,						  							 							  
								  P.PurchaseNo,
								  
							 </cfif>						 
							 
					         L.Fund,
							 
							 <cfif ObjectParent eq "0">						  
						          L.ObjectCode, 
							 <cfelse>
								  OBJ.ParentCode as ObjectCode,
							 </cfif>	   
			          		
							 L.ProgramCode,
							 
							 <cfif ProgramActivity eq "1">
							 L.ActivityId,
							 </cfif>
							 
							 (SELECT  PeriodHierarchy 
							   FROM   Program.dbo.ProgramPeriod 
							   WHERE  ProgramCode = L.ProgramCode
							   AND    Period      = '#PlanningPeriod#') as ProgramHierarchy									
							  						
				  
				    FROM     RequisitionLine R INNER JOIN
					         #LineFunding# L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
					         PurchaseLine P ON R.RequisitionNo = P.RequisitionNo INNER JOIN ItemMaster M ON M.Code = R.ItemMaster
							 <cfif ObjectParent eq "1">
							  INNER JOIN Program.dbo.stObject OBJ ON OBJ.Code = L.ObjectCode
						     </cfif>
							 
							  
					WHERE    R.Mission        = '#Mission#'					
					
					<!--- still in obligation status, otherwise we exclude any unliquidated amount, which is likely 0 already --->
								
					AND       P.PurchaseNo IN (SELECT PurchaseNo
					                           FROM   Purchase 
											   WHERE  PurchaseNo = P.PurchaseNo AND ObligationStatus = 1)	

							<!--- filter for funding selection --->	
							#preservesinglequotes(condition)#			
							<!--- ---------------------------- --->									  									
											
					<cfif content eq "sum">
					GROUP BY R.Mission,
					         L.Fund,
							 L.ProgramCode,		
							 <CFIF ProgramActivity eq "1">
							 L.ActivityId
							 </CFIF> 							 
							 <cfif ObjectParent eq "0">						  
						     L.ObjectCode 
							 <cfelse>
							 OBJ.ParentCode
							 </cfif>		
												
					</cfif>		
														
				UNION ALL
					
				<!--- -------------------- --->
				<!--- -liquidated portion- --->
				<!--- -------------------- --->							
					
				SELECT  <cfif Mode eq "CreateView">
						TOP 1000
						</cfif>
					    <cfif content eq "sum">
					          
							  R.Mission,						  							  						    
						  	  SUM(L.AmountPostedBase) AS ObligationAmount,
								  	
						<cfelse>
							 
							  M.Description as ItemMasterDescription,
							  R.RequisitionNo,
							  R.Mission,
							  R.Period,
							  R.Reference,		
							  R.RequestDescription,					 						 			  
							  R.RequestType,
							  R.RequestDate,								 						 			  
							  L.AmountPostedBase AS ObligationAmount,						  							 							  
							  P.PurchaseNo,
								  
						 </cfif>						 
							 
					         L.Fund,
			          		 <cfif ObjectParent eq "0">						  
						     L.ObjectCode, 
							 <cfelse>
							 OBJ.ParentCode as ObjectCode,
							 </cfif>	
							 
						     (SELECT PeriodHierarchy 
						      FROM   Program.dbo.ProgramPeriod 
						      WHERE  ProgramCode = L.ProgramCode
							  AND    Period = '#planningperiod#') as ProgramHierarchy,
									
							 L.ProgramCode 
									  
				    FROM     RequisitionLine R INNER JOIN
					         InvoicePurchasePosting L ON R.RequisitionNo = L.RequisitionNo INNER JOIN
					         PurchaseLine P ON R.RequisitionNo = P.RequisitionNo INNER JOIN ItemMaster M ON M.Code = R.ItemMaster
							 <cfif ObjectParent eq "1">
							  INNER JOIN Program.dbo.stObject OBJ ON OBJ.Code = L.ObjectCode
						     </cfif>
							  
					WHERE    R.Mission        = '#Mission#'		
					
					         <!--- filter for funding selection --->
		  					 #preservesinglequotes(condition)#				
					
					<cfif content eq "sum">
					GROUP BY  R.Mission,L.Fund,L.ProgramCode,
					         <cfif ObjectParent eq "0">						  
						      L.ObjectCode 
							 <cfelse>
							  OBJ.ParentCode
							 </cfif>		
										
					</cfif>		
					
				<!--- ------------------ --->				
				<!--- END derived table --->
				<!--- ------------------ --->		
					
				) as DerivedTable
														
				<cfif content eq "sum">
					
				GROUP BY  Mission,Fund,ProgramCode,ObjectCode,ProgramHierarchy	 			
					
				<cfelse>
					
				GROUP BY  Mission,
						  Fund,
						  ProgramCode,
						  ObjectCode,
						  Period,
						  ProgramHierarchy,	 
				          ItemMasterDescription, 
						  RequisitionNo, 
						  Reference, 
						  RequestDescription,
						  RequestType, 
						  RequestDate,						  							 							  
						  PurchaseNo
				         				
				</cfif>						
									
				<cfif content neq "sum">
					ORDER BY  Mission,Period,RequisitionNo			
				</cfif>					
					
			</cfquery>		
		
		</cfif>
		
		</cftransaction>
		
		<!---
		
		<cfoutput>O:#cfquery.executionTime#</cfoutput>
		
		--->
									
		<cfif mode eq "View">
			<cfreturn Obligation>		
		<cfelseif mode eq "Table">				
			<cfquery name="Index" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">

				CREATE  INDEX [ProgramInd] 
				   ON dbo.#table#([ProgramHierarchy],[Fund]) ON [PRIMARY]
			</cfquery>			
		</cfif>
		
	</cffunction>	
	
	<cffunction name="Disbursement"
             access="public"
             returntype="any"
             displayname="Disbursement">
		
			<cfargument name="Mission"             type="string" required="true">	
			<cfargument name="MandateNo"           type="string" required="true"  default="">
		    <cfargument name="UnitHierarchy"       type="string" required="true"  default="">		
			<cfargument name="EditionId"           type="string" required="true"  default="">
			
			<!--- to be applied --->
			<cfargument name="TransactionDate"     type="string" required="false" default="">
			<cfargument name="TransactionDateEnd"  type="string" required="false" default="">			
			<!--- ------------- --->
				
		
			<cfargument name="Period"              type="string" required="true">	
			<cfargument name="AccountPeriod"       type="string" required="false" default="">	
			
			<cfargument name="GLCategory"          type="string" required="false" default="Actuals">			
			<cfargument name="TransactionSource"   type="string" required="true"  default="'AccountSeries','ReconcileSeries'">	
			
			<cfargument name="ProgramCode"         type="string" required="false" default="">	
			<cfargument name="ProgramActivity"     type="string" required="false" default="0">
			<cfargument name="ProgramHierarchy"    type="string" required="false" default="">	
			<cfargument name="Currency"            type="string" required="false" default="#application.baseCurrency#">	
			<cfargument name="Fund"                type="string" required="false" default="">
			<cfargument name="Class"               type="string" required="false" default="">
		    <cfargument name="ClassValue"          type="string" required="false" default="">
			<cfargument name="Resource"            type="string" required="false" default="">
			<cfargument name="Scope"               type="string" required="false" default="">			
			<cfargument name="ObjectParent"        type="string" required="false" default="0">
			<cfargument name="Object"              type="string" required="false" default="">
			<cfargument name="ObjectChildren"      type="string" required="false" default="0">
			<cfargument name="Content"             type="string" required="true"  default="Sum">
			<cfargument name="Mode"                type="string" required="true"  default="Table">
			<cfargument name="Table"               type="string" required="false" default="#SESSION.acc#Invoice">
												
			<cfif TransactionDate neq "">
				<cfset dateValue = "">
				<CF_DateConvert Value="#TransactionDate#">
				<cfset DTE = dateValue>
			</cfif>	
	
			<cfif TransactionDateEnd neq "">
				<cfset dateValue = "">
				<CF_DateConvert Value="#TransactionDateEnd#">
				<cfset DTEEnd = dateValue>
			</cfif>		
					
			<cfif mode eq "CreateView">
					
				<cfquery name="Drop"
					datasource="AppsPurchase">
				      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[#table#]') 
					 and OBJECTPROPERTY(id, N'IsView') = 1)
				     drop view [dbo].[#table#]
				</cfquery>
					
			</cfif>
			
			<cfquery name="getPlanPeriod" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		
				SELECT   TOP 1 PlanningPeriod
				FROM     Organization.dbo.Ref_MissionPeriod
				WHERE    Mission = '#mission#'
				<cfif MandateNo neq "">
				AND      MandateNo = '#mandateno#'
				</cfif>
				<cfif Period neq "">
				AND      Period IN (#preservesingleQuotes(Period)#)   
				</cfif>
				ORDER BY MandateNo DESC
			</cfquery>	
		
			<cfset planningperiod = getPlanPeriod.PlanningPeriod>

			<cfquery name="Edition" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_AllotmentEdition
				WHERE  EditionId = '#EditionId#' 
			</cfquery>
		
			<cfquery name="Version" 
			    datasource="AppsProgram" 
				username="#SESSION.login#" 
		    	password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_AllotmentVersion
					WHERE  Code = '#Edition.Version#' 
			</cfquery>							
								
			<!--- Note : Financials contains the execution of the final stage = Posting of invoice or costs
			In order to show execution we need to extract Program, Fund, OE, Period
			
			TransactionLine.ProgramCode and TransactionLine.Fund have to be loaded through the source, there is no way around that. For direct entry we need to enable the enforce program 
			for the GLaccount.
			
			TransactionLine.Object of Expenditure  = optional and will bedetermined through the OE of the GL Account			
			TransactionLine.ProgramPeriod =  also optional and be replaced by the AccountingPeriod (through mission period based on the editions execution period 
			
			--->
			
			<cfif GLCategory eq "Forecast">		
				<cfset nme = "Reservation">		
			<cfelseif TransactionSource eq "'Obligation'">			
				<cfset nme = "Obligation">				
			<cfelse>			
				<cfset nme = "Invoice">				
			</cfif>
							
			<cfif mode eq "Table">				
				<CF_DropTable dbName="AppsQuery" tblName="#table#">
			</cfif>
			
			<cftransaction isolation="read_uncommitted">
						
			<cfquery name="Disbursement" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
											
				<cfif Mode eq "CreateView">
				CREATE VIEW dbo.#table# AS	
				</cfif>
				SELECT
				<cfif content eq "sum">
				
			          H.Mission,				  					  
					  H.ObjectCode,
					  H.Fund,
					  H.ProgramHierarchy,					
					  <cfif ProgramActivity eq "1">
						 H.ActivityId,
					  </cfif>
					  H.ProgramCode,
					  round(SUM(H.AmountBaseDebit - H.AmountBaseCredit),2) AS #nme#Amount	  
					  
				<cfelse>
				
					  H.*,		
					  H.ProgramPeriod AS Period,	 
					  (H.AmountDebit - H.AmountCredit) AS #nme#Currency,
					  (H.AmountBaseDebit - H.AmountBaseCredit) AS #nme#Amount
					  
				</cfif>					    
			         
				<cfif Mode eq "Table">			   
				INTO       userquery.dbo.#table#
				</cfif>
				
				FROM    (
				
				<!--- -------------------- --->				
				<!--- BEGIN derrived table --->
				<!--- -------------------- --->
				
				<!--- define a usable Object code, if the has an object code recorded we try to use it above the GL linkage --->
											
				SELECT  H.Journal, 
					        H.JournalSerialNo, 
							H.JournalTransactionNo, 
							H.JournalBatchNo, 
							H.JournalBatchDate,
							H.Mission, 
							H.Description, 
							H.TransactionSource, 
							H.TransactionDate, 
		                    H.ReferencePersonNo as PersonNo, 
							H.Reference, 
							H.ReferenceName, 
							H.ReferenceNo,
							H.AccountPeriod,
							H.ReferenceId,
							L.GLAccount,
					        L.Fund,
							L.ProgramCode,
							L.ActivityId,
							L.ContributionLineId,
							L.Memo,
							   (SELECT PeriodHierarchy 
					       		FROM   Program.dbo.ProgramPeriod
						        WHERE  ProgramCode = L.ProgramCode
								AND    Period      = '#PlanningPeriod#' ) as ProgramHierarchy,  <!--- to be validated --->
							L.ProgramPeriod,		
							L.Currency,															       
							L.AmountDebit,
							L.AmountCredit,
							
							<!--- if requested expression currency = journal currency then we take the journal amounts otherwise
							we take the base amounts --->
							
							CASE L.Currency WHEN '#application.basecurrency#' THEN L.AmountBaseDebit 
							                WHEN '#Currency#' THEN L.AmountDebit  															            
										    ELSE L.AmountBaseDebit * (SELECT TOP 1 ExchangeRate
																	 FROM   Accounting.dbo.CurrencyExchange V
																     WHERE  V.Currency       = '#Currency#' <!--- requested currency --->
																     AND    V.EffectiveDate <= H.TransactionDate
																	 ORDER BY V.EffectiveDate DESC) 
						    END as AmountBaseDebit,
										  
							CASE L.Currency WHEN '#application.basecurrency#' THEN L.AmountBaseCredit 
											WHEN '#Currency#' THEN L.AmountCredit  														            
										    ELSE L.AmountBaseCredit * (SELECT TOP 1 ExchangeRate
																	   FROM   Accounting.dbo.CurrencyExchange V
																       WHERE  V.Currency       = '#Currency#' 
																       AND    V.EffectiveDate <= H.TransactionDate
																	   ORDER BY V.EffectiveDate DESC) 
																	 
							END as AmountBaseCredit,			  													 															
							
							<cfif ObjectParent eq "0">
					        CASE L.ObjectCode 
							    WHEN NULL   THEN R.ObjectCode <!--- take the default OE from the GLaccount --->
								WHEN ''     THEN R.ObjectCode <!--- take the default OE from the GLaccount --->
								ELSE L.ObjectCode END as ObjectCode <!--- take the posted OE from the loading series --->
							<cfelse>
							CASE LO.Code 
							    WHEN NULL   THEN RO.ParentCode <!--- take the default OE from the GLaccount --->
								WHEN ''     THEN RO.ParentCode <!--- take the default OE from the GLaccount --->
								ELSE LO.ParentCode END as ObjectCode <!--- take the posted OE from the loading series --->
							</cfif>	
					
					FROM    Accounting.dbo.TransactionHeader H 
					        INNER JOIN Accounting.dbo.TransactionLine L ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo 
							INNER JOIN Accounting.dbo.Ref_Account     R ON L.GLAccount = R.GLAccount
							<cfif ObjectParent eq "1">
						    LEFT OUTER JOIN Program.dbo.stObject LO ON LO.Code = L.ObjectCode
							LEFT OUTER JOIN Program.dbo.stObject RO ON RO.Code = R.ObjectCode
						    </cfif>
							
					WHERE   EXISTS (SELECT 'X' 
				                     FROM   Accounting.dbo.Journal 
									 WHERE  Journal    = H.Journal										
									 AND    GLCategory = '#GLCategory#') 										
										
					AND     H.Mission = '#Mission#'			
					
					<!--- added cancelled transactions --->
					AND     (H.ActionStatus != '9' and H.RecordStatus != '9')												 							 
					
					<!--- added to improve performance --->
					
					<cfif ProgramHierarchy neq "" AND ProgramHierarchy neq "undefined">
			
					<!--- roll up --->			
					AND       L.ProgramCode IN (SELECT ProgramCode 
						                        FROM   Program.dbo.ProgramPeriod Pe
												WHERE  Pe.Period = '#PlanningPeriod#' 
												AND    Pe.PeriodHierarchy LIKE '#ProgramHierarchy#%')
												
					<cfelse>
					
						<cfif ProgramCode neq "">
							AND       L.ProgramCode = '#ProgramCode#' 
						<cfelse>
							AND       EXISTS (SELECT 'X' 
				                              FROM   Program.dbo.Program 
											  WHERE  ProgramCode = L.ProgramCode
											  AND    Mission   = '#mission#')
						</cfif>								
												
					</cfif>		
					
					<cfif Version.ProgramClass neq "">
				
					AND       EXISTS (
		                        SELECT 'X' 
		                        FROM   Program.dbo.Program
								WHERE  ProgramCode = L.ProgramCode
								AND    ProgramClass= '#Version.ProgramClass#'
								)
						
					</cfif>					
					
					<cfif TransactionDate neq "">
						AND L.TransactionDate >= #DTE#
					</cfif>
					
					<cfif TransactionDateEnd neq "">
						AND L.TransactionDate <= #DTEEnd#
					</cfif>					
										
					<cfif Fund neq "">
					AND    L.Fund = '#Fund#'
					<cfelse>
					AND    EXISTS (SELECT 'X' FROM Program.dbo.Ref_Fund WHERE Fund = L.Fund)
					</cfif>		
					
					AND (
				          ( 
							  
							  	<!--- always has a program period --->
							    H.TransactionSource = 'PurchaseSeries'					
								<cfif period neq "">
								AND       L.ProgramPeriod IN (#preservesingleQuotes(Period)#) 
								</cfif>		
								
							  )
							  
							  OR
							  
							  ( 
							  
							  	<!--- might not have a program period --->
								
							    H.TransactionSource = 'xPayrollSeries'	<!--- removed Hanno 26/10/2017 for STL --->
												
								<cfif period neq "" and accountperiod neq "">
									AND (L.ProgramPeriod IN (#preservesingleQuotes(Period)#) OR ((L.ProgramPeriod='' OR L.ProgramPeriod IS NULL) AND L.AccountPeriod IN (#preservesingleQuotes(AccountPeriod)#)))
								<cfelseif period neq "">
									AND L.ProgramPeriod IN (#preservesingleQuotes(Period)#)
								<cfelseif accountperiod neq "">
									AND L.AccountPeriod IN (#preservesingleQuotes(AccountPeriod)#) 								
								</cfif>			
								
							  )
							  
							  OR
							  
							  ( 
							   
							    <!--- 								
								we get information from the directly entered transactions 								
								default = 'AccountSeries','ReconcileSeries'								
								--->		
												
								
							    H.TransactionSource IN (#preserveSingleQuotes(TransactionSource)#)		
								
								<cfif period neq "" and accountperiod neq "">
									AND (L.ProgramPeriod IN (#preservesingleQuotes(Period)#) OR ((L.ProgramPeriod='' OR L.ProgramPeriod IS NULL) AND L.AccountPeriod IN (#preservesingleQuotes(AccountPeriod)#)))
								<cfelseif period neq "">
									AND L.ProgramPeriod IN (#preservesingleQuotes(Period)#)
								<cfelseif accountperiod neq "">
									AND  L.AccountPeriod IN (#preservesingleQuotes(AccountPeriod)#) 								
								</cfif>																										
							  )					
					   )						
								
				) as H
				
				<!--- ------------------ --->
				<!--- end derrived table --->
				<!--- ------------------ --->
												
				WHERE      1=1						 						  	  			
								
				<!--- 8/7 add a provision to show only if invoice is finished and has status = 1 
				also the unliquidated does the same to include status 0 and 9 --->
				
				AND       (
				
				           <!--- if invoice does not exisit in procurement we take it anyway --->
				
				           H.ReferenceId NOT IN (SELECT InvoiceId 
						                         FROM   Purchase.dbo.Invoice
												 WHERE  InvoiceId = H.ReferenceId ) 
						               OR 
									   
						   <!--- only cleared and processed invoices --->			   
									   
						   EXISTS (SELECT 'X'
			                       FROM   Purchase.dbo.Invoice 
								   WHERE  InvoiceId = H.ReferenceId 
								   AND    ActionStatus IN ('1','2') ) 
						  )								  
				
				<!--- org filter on the program execution --->
			
				AND       EXISTS   (SELECT 'X'
		                            FROM   Program.dbo.ProgramPeriod 
									WHERE  ProgramCode = H.ProgramCode
									AND    Period IN (
								                  SELECT PlanningPeriod 
                                                  FROM   Organization.dbo.Ref_MissionPeriod 
				                                  WHERE  Mission = '#Mission#' 
												   <cfif period neq "">
				                                  AND    Period IN (#preservesingleQuotes(Period)#)
												  </cfif>
												  ) 	 
									AND    RecordStatus != '9'
									AND    OrgUnit IN (
													   SELECT OrgUnit 
									                   FROM   Organization.dbo.Organization
													   WHERE  Mission   = '#mission#'
													   <cfif MandateNo neq "">
													   AND    MandateNo = '#MandateNo#'
													   </cfif>
													   <cfif unitHierarchy neq "">
													   AND    HierarchyCode LIKE ('#unithierarchy#%')
													   </cfif>
													  )
								)									
				
				
				<cfif Class neq "" and ClassValue neq "">
			
					<cfif Class eq "Group">
					
						AND       EXISTS (SELECT 'X' 
				                             FROM  Program.dbo.ProgramGroup 
											 WHERE ProgramCode = H.ProgramCode
											 AND   ProgramGroup = '#ClassValue#')
					
					<cfelse>
				
					    AND       EXISTS (SELECT 'X' 
				                             FROM   Program.dbo.ProgramCategory 
											 WHERE  ProgramCode = H.ProgramCode
											 AND    ProgramCategory = '#ClassValue#')
											 
					</cfif>						 
			
				</cfif>		
												
				<cfif Resource neq "">
				   AND        H.ObjectCode IN (SELECT Code 
				                               FROM   Program.dbo.Ref_Object 
											   WHERE  Resource = '#Resource#')
				<cfelse>
				
					<cfif Object neq "">
					
							<cfif ObjectParent eq "1">
							
							AND       H.ObjectCode = '#Object#'
							
							<cfelse>
											
								<cfif ObjectChildren eq "0">
								
								AND       H.ObjectCode = '#Object#'
								
								<cfelse>
													
								AND  (
							    	  H.ObjectCode = '#Object#' OR 
								      H.ObjectCode IN (SELECT Code 
									                   FROM   Program.dbo.Ref_Object 
													   WHERE  ParentCode = '#Object#')
								  )
								  
							   </cfif>	  
											  
							</cfif>	  
							
					<cfelse>			
								
						<!--- ensure valid object code and within the budget --->
						AND       H.ObjectCode IN (SELECT Code 
						                           FROM Program.dbo.Ref_Object
												    WHERE 1=1
												   <!---
												   <cfif scope eq "Budget">
												   WHERE Procurement = 1
												   <cfelseif scope eq "Outside">
												   WHERE Procurement = 0											   
												   </cfif>
												   --->
												   <cfif editionid neq "">
													AND  ObjectUsage = (SELECT   TOP 1 V.ObjectUsage
																		FROM     Program.dbo.Ref_AllotmentEdition E INNER JOIN
																                 Program.dbo.Ref_AllotmentVersion V ON E.Version = V.Code
																		WHERE    E.EditionId = '#editionid#')									    
												    </cfif>									   
											   )
											   
					</cfif>
					
				</cfif>	
										
				<cfif content eq "sum">
				GROUP BY   H.Mission,
				           H.Fund,
						   H.ProgramHierarchy,
						   H.ProgramCode,
						   <cfif ProgramActivity eq "1">
						   H.ActivityId,
						   </cfif>
						   H.ObjectCode 
				</cfif>		
					
		
				<cfif content neq "sum">
				ORDER BY   TransactionDate
				</cfif>
								
			</cfquery>	
	
			</cftransaction>
			
			<!---									
			<cfoutput>D:#cfquery.executionTime#</cfoutput>			
			--->
						
									
			<!--- pending make a query for non matching entries --->
			
			<cfif mode eq "View">
			
				<cfreturn Disbursement>		
				
			<cfelseif mode eq "Table">
				
				<cfquery name="Index" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					CREATE CLUSTERED INDEX [ProgramInd] 
					   ON dbo.#table#([ProgramHierarchy],[Fund]) ON [PRIMARY]
				</cfquery>					
				
			</cfif>

		</cffunction>
		
</cfcomponent>	 