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


<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="Budget"
             access="public"
             returntype="any"
             displayname="Budget Table">
		
		<cfargument name="ProgramCode"      type="string" required="false" default="">
		<cfargument name="Period"           type="string" required="true">
		<cfargument name="MandateNo"        type="string" required="true"  default="">
		<cfargument name="UnitHierarchy"    type="string" required="true"  default="">
		<cfargument name="ProgramHierarchy" type="string" required="true"  default="">		
		<cfargument name="EditionId"        type="string" required="true">
		<cfargument name="Fund"             type="string" required="false" default="">
		<cfargument name="Class"            type="string" required="false" default="">
		<cfargument name="ClassValue"       type="string" required="false" default="">
		<cfargument name="Resource"         type="string" required="false" default="">
		<cfargument name="Object"           type="string" required="false" default="">
		<cfargument name="ObjectParent"     type="string" required="false" default="0">
		<!--- added option to pass : request as the status --->
		<cfargument name="Status"           type="string" required="false" default="">	
		<cfargument name="Mode"             type="string" required="true"  default="Table">
		<cfargument name="Table"            type="string" required="false" default="#SESSION.acc#Allotment">			
		
	</cffunction>	
	
		
	<cffunction name="IMIS"
             access="public"
             returntype="any"
             displayname="Requisitions">
		
		<cfargument name="Mission"          type="string" required="true">	
		<cfargument name="MandateNo"        type="string" required="true"  default="">
		<cfargument name="EditionId"        type="string" required="true"  default="">
		<cfargument name="UnitMode"         type="string" required="true"  default="Program">	
		<cfargument name="UnitHierarchy"    type="string" required="true"  default="">	
		<cfargument name="Period"           type="string" required="true">	
		<cfargument name="ProgramCode"      type="string" required="false" default="">
		<cfargument name="ProgramHierarchy" type="string" required="false" default="">		
		<cfargument name="Fund"             type="string" required="false" default="">
		<cfargument name="Class"            type="string" required="false" default="">
		<cfargument name="ClassValue"       type="string" required="false" default="">
		<cfargument name="Resource"         type="string" required="false" default="">
		<cfargument name="Object"           type="string" required="false" default="">
		<cfargument name="Status"           type="string" required="false" default="cleared">
		<cfargument name="ObjectParent"     type="string" required="false" default="0">
		<cfargument name="Content"          type="string" required="true"  default="Sum">
		<cfargument name="Mode"             type="string" required="true"  default="Table">
		<cfargument name="Table"            type="string" required="false" default="#SESSION.acc#IMIS">
		
		<cfif mode eq "Table">
			<CF_DropTable dbName="AppsQuery" tblName="#table#">
		</cfif>
		
		<cfif mode eq "CreateView">
					
			<cfquery name="Drop"
				datasource="AppsPurchase"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[#table#]') 
				 and OBJECTPROPERTY(id, N'IsView') = 1)
			     drop view [dbo].[#table#]
			</cfquery>
					
		</cfif>
						
		<cfquery name="Program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Program 
			WHERE    ProgramCode = '#ProgramCode#' 	
		</cfquery>
		
		<cfquery name="getPeriod" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   P.*
			FROM     Ref_AllotmentEdition R, Ref_Period P 
			WHERE    R.Period = P.Period 	
			AND      R.EditionId = '#Editionid#'		
				
		</cfquery>
						
		<cfif url.mission eq "">
			 <cfset url.mission = program.mission>
		</cfif>
				
		<cfquery name="IMIS" 
			datasource="AppsPurchase"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
						
				<cfif Mode eq "CreateView">
				CREATE VIEW dbo.#table# AS	
				</cfif>
			
				SELECT  <cfif Mode eq "CreateView">
							TOP 1000
						</cfif>
						
						<cfif content eq "sum">				         
						  ROUND(SUM(curr_amt),2) AS ExpenditureAmount,
					    <cfelse>						 						 
						  ROUND(SUM(curr_amt),2) as ExpenditureAmount,
					    </cfif>
						
						(SELECT TOP 1 P.ProgramCode 
						 FROM   Program.dbo.Program P, Program.dbo.ProgramPeriod Pe
						 WHERE  P.ProgramCode = Pe.ProgramCode
						 AND    Pe.Period IN (
							                  SELECT PlanningPeriod 
                                              FROM   Organization.dbo.Ref_MissionPeriod 
			                                  WHERE  Mission = '#Mission#' 
											  <cfif period neq "">
			                                  AND    Period IN (#preservesingleQuotes(Period)#)
											  </cfif>
											  ) 						
						 AND    Pe.Reference = R.f_actv_id_code) as ProgramCode,		
						
						(SELECT TOP 1 PeriodHierarchy as ProgramHierarchy 
						 FROM   Program.dbo.Program P, Program.dbo.ProgramPeriod Pe
						 WHERE  P.ProgramCode = Pe.ProgramCode
						 AND    Pe.Period IN (
							                  SELECT PlanningPeriod 
                                              FROM   Organization.dbo.Ref_MissionPeriod 
			                                  WHERE  Mission = '#Mission#' 
											  <cfif period neq "">
			                                  AND    Period IN (#preservesingleQuotes(Period)#)
											  </cfif>
											  ) 						
						 AND    Pe.Reference = R.f_actv_id_code) as ProgramHierarchy,							
						 
						 Nova_Fund as Fund,
						 f_actv_id_code as Reference,
				         f_orgu_id_code as Service, 
						 f_objc_id_code as Class, 
						 f_objt_id_code as Object, 	
						 objc_descr,					 
						 Nova_Object as ObjectCode	
						 <cfif content neq "sum">		
						     ,f_glan_seq_num,
							 f_dorf_id_code,
							 part1_doc_id, 
							 f_dorf_id_code_2,
							 part1_doc_id_2,
							 primary_dorf_doc_descr,
							 postd_date,
							 postd_acct_prd								 
						 </cfif>
				
				<cfif Mode eq "Table">		  
						INTO      userquery.dbo.#table#
				</cfif>
								
				FROM     
				
				(   SELECT * FROM MergeData.dbo.IMP_stLedger_#Mission# AS I INNER JOIN
	                      stLedgerRouting AS R ON I.db_mdst_source = R.DutyStation 
						      AND I.f_fund_id_code = R.Fund 
							  AND I.f_orgu_id_code = R.OrgCode 
							  AND I.f_objc_id_code = R.ObjectClass 
							  AND I.f_objt_id_code = R.ObjectCode 
							  AND I.f_pgmm_id_code = R.PrgCode 
							  AND R.PrgCode != ''
							  AND R.Mission = '#Mission#'		
					 WHERE (I.f_glan_seq_num IN ('4510', '6210', '6310')) AND I.f_fund_id_code NOT IN ('ZCA','ZDA')		  		
							  
					UNION 
					
					SELECT * FROM MergeData.dbo.IMP_stLedger_#Mission# AS I INNER JOIN
	                      stLedgerRouting AS R ON I.db_mdst_source = R.DutyStation 
						      AND I.f_fund_id_code = R.Fund 
							  AND I.f_orgu_id_code = R.OrgCode 
							  AND I.f_objc_id_code = R.ObjectClass 
							  AND I.f_objt_id_code = R.ObjectCode 
							  AND R.PrgCode = '' <!--- blank --->
							  AND R.Mission = '#Mission#'	
					WHERE (I.f_glan_seq_num IN ('4510', '6210', '6310')) AND I.f_fund_id_code IN ('ZCA','ZDA')			  
							  
				) as R	  										  
				
				WHERE    1=1
				
				<cfif unitHierarchy neq "" and unithierarchy neq "undefined" and unitMode eq "Program">
				
				
				AND      f_actv_id_code IN 
				
							(SELECT Pe.Reference
							 FROM   Program.dbo.ProgramPeriod Pe
							 WHERE  Pe.Period IN (
										                  SELECT PlanningPeriod 
			                                              FROM   Organization.dbo.Ref_MissionPeriod 
						                                  WHERE  Mission = '#Mission#' 
														  <cfif period neq "">
						                                  AND    Period IN (#preservesingleQuotes(Period)#)
														  </cfif>
														  ) 						
							 AND    Pe.OrgUnit IN (SELECT OrgUnit 
							                       FROM   Organization.dbo.Organization							  
												   WHERE  Mission = '#mission#'
												   AND    HierarchyCode LIKE ('#unithierarchy#%') 
												  )  
							) 
							
							
							
				<cfelseif unitHierarchy neq "" and unithierarchy neq "undefined" and unitMode eq "Organization">
					
					<!---
								
				AND    f_orgu_id_code IN (SELECT OrgUnitCode
					                      FROM   Organization.dbo.Organization							  
										  WHERE  Mission = '#mission#'
										  AND    HierarchyCode LIKE ('#unithierarchy#%') 
										  )
										
					--->
						
				</cfif>		
												
				<cfif getPeriod._tsQueryCondition neq "">
					AND   (#preserveSingleQuotes(getPeriod._tsQueryCondition)#)					
				<cfelse>				
					AND   f_fnlp_fscl_yr IN (#preserveSingleQuotes(AccountPeriod)#) 
				</cfif>
											
				<cfif ProgramCode neq "">
				AND      f_actv_id_code = '#ProgramCode#'
				</cfif>				
				
				<cfif fund neq "">								
				AND      Nova_Fund = '#fund#'				
				</cfif>
				
				<cfif Object neq "">
																			
					<cfif Resource neq "">

					   AND     Nova_Object IN (SELECT Code FROM Program.dbo.Ref_Object WHERE Resource = '#Resource#')
					
					<cfelse>
					
							<cfif Object neq "">				
								
									AND  (
									      Nova_Object = '#Object#' OR 
									      Nova_Object IN (SELECT Code 
										                   FROM   Program.dbo.Ref_Object 
														   WHERE  ParentCode = '#Object#')
										  )
								
							<cfelse>
								
								<!--- only valid objects within this edition --->
							
								AND    Nova_Object IN (SELECT Code 
														FROM   Program.dbo.Ref_Object 
														WHERE  Code = L.ObjectCode
														<cfif url.editionid neq "">
														AND    ObjectUsage = (SELECT   TOP 1 V.ObjectUsage
																			  FROM     Program.dbo.Ref_AllotmentEdition E INNER JOIN
																	                   Program.dbo.Ref_AllotmentVersion V ON E.Version = V.Code
																			  WHERE    E.EditionId = '#editionid#')									    
																			  
													    </cfif>
														)
									
							</cfif>
								   
					</cfif>				
				
				</cfif>
																	
				GROUP BY Nova_Fund, Nova_Object, f_fund_id_code, f_actv_id_code, f_orgu_id_code, f_objc_id_code, f_objt_id_code, objc_descr
				
				<cfif content neq "sum">
					 ,f_glan_seq_num,
					 f_dorf_id_code,
					 part1_doc_id, 
					 f_dorf_id_code_2,
					 part1_doc_id_2,
					 primary_dorf_doc_descr,
					 postd_date,
					 postd_acct_prd				
				</cfif>
				
				ORDER BY Nova_Fund, Nova_Object, f_actv_id_code, f_orgu_id_code, f_objc_id_code, f_objt_id_code<cfif content neq "sum">, postd_acct_prd		</cfif>
							
		</cfquery>
					
		<cfif mode eq "View">
			
			<cfreturn IMIS>		
			
		<cfelseif mode eq "Table">
			
			<!---	
			<cfquery name="Index" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				CREATE  INDEX [ProgramInd] 
				   ON dbo.#table#([ProgramHierarchy],[Fund]) ON [PRIMARY]
			</cfquery>		
			--->
			
		</cfif>
				
	</cffunction>
	
</cfcomponent>	 