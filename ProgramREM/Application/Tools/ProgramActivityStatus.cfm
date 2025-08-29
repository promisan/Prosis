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
   <!--- define progress weight --->

   <!--- select project progress weight --->	
   
   <cfsavecontent variable="ProgramFilter">
   
      <cfoutput>
	
       ProgramCode = (SELECT TOP 1 PR.ProgramCode 
	                  FROM  Program PR, ProgramPeriod Pe
					  WHERE PR.ProgramCode  = Pe.ProgramCode
					  AND   PR.ProgramClass = 'Project'
					  AND   Pe.RecordStatus != '9'
					  AND   Pe.Period       = '#URL.Period#'
					  AND   PR.ProgramCode  = P.ProgramCode
					  AND   P.Mission       = '#URL.Mission#')		
					  
	  </cfoutput>			  
											
   </cfsavecontent>										
   
   <cfset DateFilter    = "O.ProgressStatusDate <= '#DateFormat(now(),CLIENT.DateSQL)#'">	
   
   <!--- determine completion status for each individual activity --->
      
   <cfinclude template="ProgramActivityPendingPrepare.cfm">
  
   <!--- Dev : generate rolled up data set project and subproject into a combine dataset --->
     
     
   <!--- ---------------------------- ---> 
   <!--- Pending : limit the contents --->
   <!--- ---------------------------- --->
      
   <cfsavecontent variable="rolledup">
		  
			<cfoutput>
     
			    SELECT    P.ProgramCode AS ProjectCode, PA.*
					
				FROM      Program.dbo.ProgramActivity PA, Program.dbo.Program P
				WHERE     P.ProgramCode  = PA.ProgramCode 		
				AND       P.ProgramClass  = 'Project'	
				AND       PA.ActivityPeriod   = '#url.period#'  <!--- to show only activities under this period, might not be correct --->
				AND       PA.RecordStatus    != '9'	
				AND       PA.ProgramCode IN (SELECT ProgramCode 
				                             FROM   Program.dbo.#per#
										     WHERE  ProgramCode = PA.ProgramCode 
										     AND    RecordStatus != '9') 		
				
				<!--- onclude also the parent action --->
					 
				UNION ALL
				
				SELECT    Pe.PeriodParentCode AS ProjectCode, PA.*
				FROM      Program.dbo.ProgramActivity PA, 	 
				          Program.dbo.Program P,
						  Program.dbo.ProgramPeriod Pe
				WHERE     P.ProgramCode  = PA.ProgramCode 		
				AND       P.ProgramCode  = Pe.ProgramCode
				AND       Pe.Period      = '#url.period#' <!--- added to detect the correct hierarchy --->
				AND       PA.ActivityPeriod   = '#url.period#'  <!--- to show only activities under this period, might not be correct --->
				AND       P.ProgramClass = 'Project'		
				AND       PA.RecordStatus != '9' 	
				AND       P.ProgramCode IN (SELECT ProgramCode 
				                            FROM   Program.dbo.#per# 
											WHERE  ProgramCode = P.ProgramCode 
											AND    RecordStatus != '9')
				
				<!--- parent project of a sub-project to show consolidated progress --->
				
				AND       EXISTS (SELECT    'X'
				                  FROM    Program.dbo.Program
			    	              WHERE   ProgramCode = Pe.PeriodParentCode
								  AND     ProgramClass = 'Project')
								
			</cfoutput>
			
	</cfsavecontent>
	         
   <!--- ------------------------ --->
   <!--- overall project activity --->
   <!--- ------------------------ --->
  			
	<cfsavecontent variable="aggregated">
	
		<cfoutput>
		SELECT    ProjectCode as ProgramCode, 
		          SUM(ActivityWeight) AS WeightActivityTotal			  		
		FROM      (#preservesinglequotes(rolledup)#) as D     
		GROUP BY  ProjectCode
		</cfoutput>
	
	</cfsavecontent>
	
	
   <!---	
   <cfoutput>2c.#now()#:#cfquery.executionTime#<br></cfoutput>
   --->
	
	<!--- --------------------------------------------------------------------------------- --->   	
	<!--- define project+subproject weight combined for activities that should have started --->
	<!--- --------------------------------------------------------------------------------- --->   	
	
			
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#BSCSummary#FileNo#">	
	
	<cfquery name="Consolidation"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT     '#URL.Mission#' as Mission,
			   '#URL.Period#'  as Period,	
	           ActAll.ProgramCode,
			   P.ProgramName,			 
			   P.ProgramWeight,
			   Pe.PeriodParentCode as ParentCode,
			   Pe.PeriodHierarchy  as ProgramHierarchy, 			   
			   ActAll.WeightActivityTotal, 
			   
			   ( SELECT WeightActivityStarted
			     FROM  (SELECT    ProjectCode as ProgramCode, 
				                  SUM(ActivityWeight) AS WeightActivityStarted
			            FROM      (#preservesinglequotes(rolledup)#) as B
			            WHERE     ActivityDateStart < getDate()
				        GROUP BY  ProjectCode) as STR 
				 WHERE ActAll.ProgramCode   = STR.ProgramCode		
				 
			   ) as  WeightActivityStarted,	 			   
			      
			   ( SELECT WeightActivityDue
			     FROM  (SELECT    ProjectCode as ProgramCode, 
				                  SUM(ActivityWeight) AS WeightActivityDue
			            FROM      (#preservesinglequotes(rolledup)#) as C
			            WHERE     ActivityDate < getDate()
				        GROUP BY  ProjectCode) as DUE 
				 WHERE ActAll.ProgramCode   = DUE.ProgramCode		
				 
			   ) as  WeightActivity,	 
			   			   
			   ( SELECT WeightActivityPending
			     FROM  (SELECT    ProjectCode as ProgramCode, 
				                  SUM(ActivityWeight) AS WeightActivityPending
			            FROM      (#preservesinglequotes(rolledup)#) as F	
			            WHERE     ActivityDate < getDate()
						AND       ActivityId IN (SELECT ActivityId FROM userQuery.dbo.#SESSION.acc#ActivityPending#FileNo#)	
				        GROUP BY  ProjectCode) as PEN 
				 WHERE ActAll.ProgramCode   = PEN.ProgramCode		
				 
			   ) as  WeightPending
			   
   	INTO       dbo.#SESSION.acc#BSCSummary#FileNo# 		   
	FROM       (#preservesinglequotes(aggregated)#) as ActAll 
	           INNER JOIN Program.dbo.Program P ON ActAll.ProgramCode = P.ProgramCode 	
			   INNER JOIN Program.dbo.ProgramPeriod Pe ON ActAll.ProgramCode = Pe.ProgramCode AND Pe.Period = '#url.period#'			   
			   
	ORDER BY   PeriodHierarchy
	</cfquery>	
	
	<!---	
    <cfoutput>2g.#now()#:#cfquery.executionTime#<br></cfoutput>
	--->
				
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Program#FileNo#">	
 
	