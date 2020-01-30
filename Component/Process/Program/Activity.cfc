
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
	
	<cffunction name="ProjectActivityStatus"
             access="public"
             returntype="any"
             displayname="Project Progress Status">
		
		<cfargument name="Mission"             type="string" required="false" default="">
		<cfargument name="Period"              type="string" required="false" default="0">
		<cfargument name="Mode"                type="string" required="true"  default="Table">
		<cfargument name="Table"               type="string" required="false" default="#SESSION.acc#Allotment">
		
		<cfsavecontent variable="ProgramFilter">
   
	      <cfoutput>
		
	       ProgramCode = (SELECT TOP 1 PR.ProgramCode 
		                  FROM  Program PR, ProgramPeriod Pe
						  WHERE PR.ProgramCode  = Pe.ProgramCode
						  AND   PR.ProgramClass = 'Project'
						  AND   Pe.RecordStatus != '9'
						  AND   Pe.Period       = '#Period#'
						  AND   PR.ProgramCode  = P.ProgramCode
						  AND   P.Mission       = '#Mission#')		
						  
		  </cfoutput>			  
											
        </cfsavecontent>	
		
		
		<CF_DropTable dbName="AppsQuery" tblName="#table#">									
   
        <cfset DateFilter    = "O.ProgressStatusDate <= '#DateFormat(now(),CLIENT.DateSQL)#'">	
				
		<!---<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending#FileNo#"> --->
		
		<!--- ----------------------------------------------- --->  	   		
		<!--- retrieve the last progress report for an output --->
		<!--- ----------------------------------------------- --->
		
		<cfsavecontent variable="lastoutputreported">
		  
			    <cfoutput>
				 SELECT   P.Mission, 
						  O.OutputId, 
						  MAX(O.Created) AS LastSubmitted 				 
				 FROM     ProgramActivityProgress O, Program P
				 WHERE    P.ProgramCode = O.ProgramCode	
				 AND      P.#preserveSingleQuotes(ProgramFilter)#			
				 <cfif DateFilter neq "">
				 AND      #preserveSingleQuotes(DateFilter)# 
				 </cfif> 
				 <!--- valid progress report --->
				 AND      O.RecordStatus != '9'  
				
				 GROUP BY P.Mission,
				          O.OutputId 
				</cfoutput>		  
						
		</cfsavecontent>

		<!---
		<cfoutput>1.#now()#:#cfquery.executionTime#<br></cfoutput>
		--->
 
		<!--- retrieve all activities of which one of its defined output is not in the table completed for each last output report --->
		
		<cfsavecontent variable="incompleteactivities">
		
		<cfoutput>

			 SELECT DISTINCT 
			        O.ProgramCode,
					(SELECT PeriodParentCode
					 FROM   ProgramPeriod
					 WHERE  ProgramCode = P.ProgramCode
					 AND    Period      = '#period#') as ParentCode,			
					O.ActivityPeriod, 
					O.ActivityId, 
			        'Pending' AS Status, 
				    PA.ActivityDateStart, 
					PA.ActivityDate,
					PA.ActivityDescription,
					PA.ActivityWeight,
					PA.OrgUnit
			 <!---INTO   userQuery.dbo.#SESSION.acc#ActivityPending#FileNo#--->		
			 FROM   ProgramActivity PA INNER JOIN
			        Program P ON PA.ProgramCode = P.ProgramCode INNER JOIN
			        ProgramActivityOutput O ON PA.ProgramCode = O.ProgramCode AND PA.ActivityPeriod = O.ActivityPeriod AND PA.ActivityId = O.ActivityId 
			 WHERE  <!--- only valid projects --->	
			         PA.ProgramCode NOT IN  (SELECT  ProgramCode 
											 FROM    ProgramPeriod 
											 WHERE   ProgramCode = PA.ProgramCode
											 AND     Period      = PA.ActivityPeriod 
											 AND     RecordStatus = '9' ) 	  	 
			  AND   O.#preserveSingleQuotes(ProgramFilter)#	
			  
			  AND    PA.ActivityPeriod = '#period#' <!--- added to show only this periods activities --->
			 			 
			 <!--- ---------------------------------------------------------------- --->
			 <!--- ----- exclude activities that are reported as completed -------- --->
			 <!--- ---------------------------------------------------------------- --->
			 
			  AND   O.OutputId NOT IN (  
			  
							     <!--- contains output which completed based on its progress report --->
							   	
							     SELECT   Pr.OutputId 		
								 FROM     ProgramActivityProgress Pr,
								          (#preservesinglequotes(lastoutputreported)#) as Last 
								 WHERE    Pr.OutputId  = Last.OutputId 
						        	AND   Pr.Created   = Last.LastSubmitted
									<!--- get only the completed ones --->
								    AND   Pr.ProgressStatus = (SELECT DISTINCT ProgressCompleted 
									                           FROM   Ref_ParameterMission 
															   WHERE  Mission = Last.Mission) 
									<!--- excluded the diabled progress reports --->						   
								    AND   Pr.RecordStatus != '9' 		
			                        AND   Pr.ProgramCode     = O.ProgramCode
						            AND   Pr.ActivityPeriod  = O.ActivityPeriod
									AND   Pr.OutputId = O.OutputId
			
									)
							  
									   
									   
			  <!--- only valid acitivties --->					   
			  AND   PA.RecordStatus <> '9' 
			  <!--- only valid outputs --->				
			  AND   O.RecordStatus  <> '9'	
			  
		</cfoutput>
		
		</cfsavecontent>	  
		 			
		<!--- ---------------------------- ---> 
        <!--- Pending : limit the contents --->
        <!--- ---------------------------- --->
     		
		<cfsavecontent variable="rolledup">
		  
			<cfoutput>
		
		    SELECT    P.ProgramCode AS ProjectCode, PA.*
			
			<!---INTO 	  userQuery.dbo.#SESSION.acc#Activity#FileNo#--->
			
			FROM      ProgramActivity PA, Program P
			WHERE     P.ProgramCode  = PA.ProgramCode 		
			AND       P.ProgramClass  = 'Project'	
			AND       PA.ActivityPeriod   = '#period#'  <!--- to show only activities under this period, might not be correct --->
			AND       PA.RecordStatus    != '9'	
			AND       P.Mission          = '#mission#'
				
			<!--- onclude also the parent action --->
				 
			UNION ALL
			
			SELECT    Pe.PeriodParentCode AS ProjectCode, PA.*
			FROM      ProgramActivity PA, 	 
			          Program P,
					  ProgramPeriod Pe
			WHERE     P.ProgramCode  = PA.ProgramCode 		
			AND       P.ProgramCode  = Pe.ProgramCode
			AND       Pe.Period      = '#period#' <!--- added to detect the correct hierarchy --->
			AND       PA.ActivityPeriod   = '#period#'  <!--- to show only activities under this period, might not be correct --->
			AND       P.ProgramClass = 'Project'		
			AND       PA.RecordStatus != '9' 	
			AND       P.Mission        = '#mission#'
				
			<!--- parent project of a sub-project to show consolidated progress --->
			
			AND       EXISTS (SELECT    'X'
			                  FROM    Program
		    	              WHERE   ProgramCode = Pe.PeriodParentCode
							  AND     ProgramClass = 'Project')
			<!---ORDER BY ProjectCode--->
			
			</cfoutput>
		
	    </cfsavecontent>
		
		<cfsavecontent variable="aggregated">
	
			<cfoutput>
			SELECT    ProjectCode as ProgramCode, 
			          SUM(ActivityWeight) AS WeightActivityTotal			  		
			FROM      (#preservesinglequotes(rolledup)#) as D     
			GROUP BY  ProjectCode
			</cfoutput>
	
	   </cfsavecontent>
	   
	   <!---<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#BSCSummary#FileNo#">--->	
	 
	
		<cfquery name="Consolidation"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT     '#Mission#' as Mission,
				   '#Period#'  as Period,	
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
							AND       ActivityId IN (SELECT ActivityId FROM (#preservesinglequotes(incompleteactivities)#) as I)	
					        GROUP BY  ProjectCode) as PEN 
					 WHERE ActAll.ProgramCode   = PEN.ProgramCode		
					 
				   ) as  WeightPending
		<cfif mode eq "Table">	   
	   	<!---INTO       UserQuery.dbo.#SESSION.acc#BSCSummary#FileNo#--->
	   	INTO       UserQuery.dbo.#table# 		   
		</cfif>
		FROM       (#preservesinglequotes(aggregated)#) as ActAll 
		           INNER JOIN Program.dbo.Program P ON ActAll.ProgramCode = P.ProgramCode 	
				   INNER JOIN Program.dbo.ProgramPeriod Pe ON ActAll.ProgramCode = Pe.ProgramCode AND Pe.Period = '#period#'			   
				   
		ORDER BY   PeriodHierarchy
		</cfquery>	
	
    	<cfif mode eq "view">
			<cfreturn Consolidation>		
		<cfelse>
    	</cfif>
			
		</cffunction>
		
</cfcomponent>	 