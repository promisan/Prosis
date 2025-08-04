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

<!--- the base query contain ePas and various status info for that ePas 
for the made selection and INCLUDES the LAST person 
assignment during the period of the ePas itself --->

<cfparam name="url.orgunit"        default="">
<cfparam name="url.cstf"           default="">
<cfparam name="url.postclass"      default="">
<cfparam name="url.contractclass"  default="standard">
<cfparam name="url.category"       default="All">
<cfparam name="url.authorised"     default="">

<cfquery name="Mandate" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT   * 
		 FROM     Ref_Mandate 
		 WHERE    Mission = '#url.mission#' 
		 AND      DateEffective <= getDate()
		 ORDER BY DateExpiration DESC
	</cfquery>

<cfif url.orgunit neq "">

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Organization 
		 WHERE  OrgUnit = '#url.orgunit#' 
	</cfquery>
	
</cfif>

<cfquery name="Period" 
	     datasource="AppsEPAS" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT   * 
		 FROM     Ref_ContractPeriod 
		 WHERE    Code  = '#url.Period#' 		 
</cfquery>

<cfsavecontent variable="BaseQuery">

		<cfoutput>
			SELECT     C.PersonNo,
			          					   
				       (SELECT    TOP 1 PersonNo
							 FROM      ContractActor 
							 WHERE     ContractId   = C.ContractId 
							 AND       RoleFunction = 'FirstOfficer'
							 AND       ActionStatus = '1') as ReportingPersonNo,
								 
					   C.OrgUnit              as ContractOrgUnit,
					   C.OrgUnitName          as ContractOrgUnitName,
					   
					   E.PostGradeParent,					   					  
					   E.OrgUnit              as AssignmentOrgUnit,
					   E.OrgUnitName          as AssignmentOrgUnitName,
					   E.OrgUnitHierarchyCode as AssignmentOrgUnitHierarchy,
			           
			           (SELECT COUNT(DISTINCT ContractId)
		              	FROM   ContractSection
				        WHERE  ProcessStatus = '1'
						AND    ContractSection = 'P01'
				        AND    ContractId = C.ContractId) AS Initiated, 	   
						   
					    (SELECT COUNT(DISTINCT ContractId)
				         FROM   ContractActivity
				         WHERE  Operational = '1'
				         AND    ContractId = C.ContractId) AS WithActivities, 	
					
					    (SELECT COUNT(*)
	                     FROM   Contract
	                     WHERE  ContractId = C.ContractId 
						 AND    ActionStatus IN ('1','2','3')) AS Submit,
								   
						(SELECT COUNT(*)
	       		         FROM   Contract
	                     WHERE  ContractId = C.ContractId 
						 AND    ActionStatus IN ('2','3')) AS Cleared,		   			
                  						  
					   <cfloop index="itm" list="midterm,final">	   
						  
	                       (SELECT COUNT(DISTINCT ContractId)
	                        FROM   ContractEvaluation
	                        WHERE  ContractId = C.ContractId 
						    AND    ActionStatus = '2' 
							<cfif itm eq "midterm">
							AND    EvaluationType IN ('#itm#','final')
							<cfelse>
							AND    EvaluationType = '#itm#'
							</cfif>							
							
							) AS #itm#,
							
						</cfloop>	
						
						 (SELECT COUNT(DISTINCT ContractId)
				         FROM   Contract
				         WHERE  ActionStatus = '3'
				         AND    ContractId = C.ContractId) AS Complete, 	
                     
					 C.ContractId
					
              FROM   Contract AS C LEFT OUTER JOIN (
		   
		                 <!--- take the LAST entry of incumbecny for this person 
						 in the validity period of the PAS for staff which is onboard  --->
		   
					      SELECT A.*
					      FROM      
						  (  SELECT    PersonNo, MAX(AssignmentNo) AS AssignmentNo
                             FROM      Employee.dbo.vwAssignment
                             WHERE     Mission        = '#url.mission#' 
							 AND       AssignmentStatus IN ('0','1') 
							 AND       AssignmentType = 'Actual' 
							 AND       Incumbency     > 0 
							 <!--- only assignments valid for the ePas period itself. --->
							 AND       DateEffective  <= '#Period.PasPeriodEnd#' 
							 AND       DateExpiration >= '#Period.PasPeriodStart#' 							     
                             GROUP BY  PersonNo) AS D INNER JOIN
                         Employee.dbo.vwAssignment AS A ON A.PersonNo = D.PersonNo AND A.AssignmentNo = D.AssignmentNo) as E					   				    
					  
		             ON C.PersonNo = E.PersonNo 
					  
           WHERE     C.Operational = 1 
		   AND       C.ActionStatus IN ('0', '1', '2','3') 
		   
		   AND       C.Mission   = '#url.mission#'  
		   AND       C.Period    = '#url.period#'
		   
		    <cfif url.contractclass neq "">
			AND      C.ContractClass = '#url.contractclass#'
		   </cfif>		
		   					   
		   <cfif url.cstf neq "">
			AND      E.PostGradeParent = '#url.cstf#'
		   </cfif>					   
		  						
			<cfif url.authorised neq "">		
			AND      PositionNo IN (SELECT PositionNo 
			                        FROM   Employee.dbo.Position P 
									WHERE  PositionNo = E.PositionNo 
									AND    P.PostAuthorised = '#url.authorised#')
			</cfif>		
			
			<cfif url.postclass neq "">		
			AND      PostClass = '#url.postclass#'
			</cfif>
			
			<cfif url.category neq "all" and url.category neq "">
			AND      ContractClass = '#url.category#' 
			</cfif>
			
			<cfif url.orgunit neq "">
			
			AND      C.OrgUnit IN (SELECT OrgUnit 
			                       FROM   Organization.dbo.Organization
							       WHERE  Mission   = '#url.mission#'
								   AND    MandateNo = '#Mandate.MandateNo#'
								   AND    HierarchyCode LIKE ('#get.HierarchyCode#%')
								  )  
								  
			</cfif>
		</cfoutput>
		
	</cfsavecontent>