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
<cfoutput>

<cfparam name="HStart" default="00">
<cfparam name="HEnd"   default="99">

<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#Program#FileNo#">	
<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#ProgramPeriod#FileNo#">		

<!--- provision to set orgunit for activities --->
 
<cfquery name="VerifyUnit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    ProgramActivity
	SET       OrgUnit = PP.OrgUnit
	FROM      ProgramActivity PA, ProgramPeriod PP
	WHERE     PA.ProgramCode = PP.ProgramCode AND PA.ActivityPeriod = PP.Period 
	AND       PA.OrgUnit NOT IN
                          (SELECT  OrgUnit
                            FROM   Organization.dbo.Organization
							WHERE  OrgUnit = PA.OrgUnit)
</cfquery>			
  
<cfsavecontent variable="select">
	Pe.OrgUnitImplement, 
	Pe.OrgUnitRequest, 	
	Pe.Reference, 
	Pe.ProgramId,
	Pe.ReferenceBudget,
	Pe.ReferenceBudget1,
	Pe.ReferenceBudget2,
	Pe.ReferenceBudget3,
	Pe.ReferenceBudget4,
	Pe.ReferenceBudget5,
	Pe.ReferenceBudget6,	
	Pe.RecordStatus, 	
	Pe.Status, 
	Pe.OfficerUserId, 
	Pe.OfficerLastName, 
	Pe.OfficerFirstName, 
	Pe.Created
</cfsavecontent>

<cfparam name="full" default="1">
<cfparam name="OEnd" default="#HEnd#">
		
	<cfquery name="ProgramPeriod" 
	         datasource="AppsProgram" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
			 
			  <!--- this is a correct to show assigned programs --->
			 
	         SELECT  Pe.ProgramCode, 
			         Pe.Period, 					 
					 Pe.OrgUnit, 
					 'Unit' as Class
			 INTO    userQuery.dbo.tmp#SESSION.acc#Program#FileNo#		 
	         FROM    ProgramPeriod Pe 
			 WHERE   1=1
			 <cfif full eq "1">
			 AND     Pe.ProgramCode IN (SELECT ProgramCode 
			                            FROM   Program 
									    WHERE  ProgramScope = 'Unit'
										AND    ProgramCode  = Pe.ProgramCode) 
			 </cfif>		
			 
	         AND   Pe.Period = '#URL.Period#' 			 
							
			 AND    Pe.RecordStatus != '9'	
			 
			 <cfif HEnd neq "99">
			 AND     Pe.OrgUnit IN (SELECT O.OrgUnit 
			                        FROM   Organization.dbo.Organization O
									WHERE  O.Mission       = '#URL.Mission#'
								    AND    O.MandateNo     = '#URL.Mandate#'									
									AND    O.HierarchyCode >= '#HStart#' 
									AND    O.HierarchyCode < '#HEnd#')	
			 </cfif>								
			 
			 <cfif full eq "1">			
			 
			 	UNION 
			 
				 <!--- this is a correct to show global programs --->
				 
				 SELECT     Pe.ProgramCode, 
				            Pe.Period, 						 
							Man.OrgUnit,
							'Global' as Class		        	
				 				
		         FROM       ProgramPeriod Pe, 
				            Organization.dbo.Organization Org, 
							Organization.dbo.Organization Man
							  
		         WHERE      Pe.Period = '#URL.Period#' 
				 
				 AND 	    Pe.ProgramCode IN (SELECT ProgramCode 
				                               FROM   Program 
										       WHERE  ProgramScope = 'Global'
											   AND    ProgramCode  = Pe.ProgramCode) 
											   
				 AND        Pe.OrgUnit    = Org.OrgUnit	
				 AND        Org.MandateNo = Man.MandateNo 
				 AND        Org.Mission   = Man.Mission	
				 AND        Pe.RecordStatus != '9'
				 
							 
				 <cfif OEnd neq "99">
				
				 AND     Man.OrgUnit IN (SELECT O.OrgUnit 
			                        FROM   Organization.dbo.Organization O
									WHERE  O.Mission       = '#URL.Mission#'
								    AND    O.MandateNo     = '#URL.Mandate#'									
									AND    O.HierarchyCode >= '#HStart#' 
									AND    O.HierarchyCode < '#OEnd#')	
				 </cfif>					
				 					 			 	 
				 UNION 
				 
				 <!--- this is a correct to show parent programs --->
				 
				 SELECT    Pe.ProgramCode, 
				           Pe.Period, 					  
						   Par.OrgUnit, 
						   'Parent' as Class
						   				  
				 FROM      ProgramPeriod Pe INNER JOIN
		                   Organization.dbo.Organization Org ON Pe.OrgUnit = Org.OrgUnit INNER JOIN
		                   Organization.dbo.Organization Par ON Org.OrgUnitCode = Par.HierarchyRootUnit AND Org.Mission = Par.Mission AND 
		                   Org.MandateNo = Par.MandateNo INNER JOIN
		                   Program P ON Pe.ProgramCode = P.ProgramCode AND Pe.ProgramCode = P.ProgramCode
						   
				 WHERE     Pe.Period = '#URL.Period#' 
				 
				 AND       P.ProgramScope = 'Parent'
				 
				 AND       Pe.OrgUnit     = '#Root.OrgUnit#'
				 
				 AND       Pe.RecordStatus != '9'								
								 			 				 			 
				 UNION
										 
				 <!--- Select the Parent Program of the programs of this unit but only if the
				 program code does not exist yet in the above --->
				 
				 <!--- 31/10/2010 : change Next into Unit to prevent double counts --->
				 
				  SELECT DISTINCT Par.ProgramCode, 
				         '#URL.Period#' as Period, 					
						 Pe.OrgUnit, 
						 'Unit' as Class
						 
				  FROM   ProgramPeriod Pe INNER JOIN
	                     Program P ON Pe.ProgramCode = P.ProgramCode INNER JOIN
	                     Program Par ON Pe.PeriodParentCode = Par.ProgramCode
						 
				  WHERE  Par.ProgramScope = 'Unit' 
				  AND    P.ProgramScope   = 'Unit' 
				  
				  AND    Pe.ProgramCode NOT IN (SELECT ProgramCode 
				                                 FROM   ProgramPeriod 
												 WHERE  OrgUnit IN ( 
												                    SELECT O.OrgUnit 
											                        FROM   Organization.dbo.Organization O
																	WHERE  O.Mission       = '#URL.Mission#'
																    AND    O.MandateNo     = '#URL.Mandate#'									
																	AND    O.HierarchyCode >= '#HStart#' 
																	AND    O.HierarchyCode < '#OEnd#'
																	)	
												)
												 
				  AND    Pe.RecordStatus <> '9' 
				  AND    Pe.Period = '#URL.Period#' 
				  
				  <cfif HEnd neq "99">
				  AND    Pe.OrgUnit IN (SELECT O.OrgUnit 
				                        FROM   Organization.dbo.Organization O
										WHERE  O.Mission       = '#URL.Mission#'
									    AND    O.MandateNo     = '#URL.Mandate#'									
										AND    O.HierarchyCode >= '#HStart#' 
										AND    O.HierarchyCode < '#HEnd#')	
	 								
				 </cfif>	
			 							 		 		 
	         			 
			 </cfif>				 
			 				
	         ORDER BY ProgramCode, Period 
						 
	</cfquery>
	
	<!--- long query 
	<cfoutput>PE1:#cfquery.executionTime#<br></cfoutput>	
	--->	
			
	<!--- now add the additional fields --->
	
	<cfquery name="ProgramPeriod" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">		
			SELECT S.*,
			       Pe.PeriodHierarchy as ProgramHierarchy, 
				   P.ProgramName,
				   P.ProgramClass, 
				   P.ListingOrder, 
				   P.ProgramScope, 
				   P.Mission,
				   P.isServiceParent,
				   P.isProjectParent,
			       #select# 
			INTO   userQuery.dbo.tmp#SESSION.acc#ProgramPeriod#FileNo#		   
			FROM   userQuery.dbo.tmp#SESSION.acc#Program#FileNo# S,  
			       ProgramPeriod Pe,
				   Program P
			WHERE  S.ProgramCode = Pe.ProgramCode
			AND    S.Period      = Pe.Period
			AND    S.ProgramCode = P.ProgramCode 
	</cfquery>	
	
	<!---
	<cfoutput>PE2:#cfquery.executionTime#<br></cfoutput>	
	--->
		
	<CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#Program#FileNo#">		
	
<cfset per = "userQuery.dbo.tmp#SESSION.acc#ProgramPeriod#FileNo#">

</cfoutput>		  
		  	