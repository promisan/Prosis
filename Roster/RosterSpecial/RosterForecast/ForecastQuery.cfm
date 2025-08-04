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

<cfparam name="owner" default="sysadmin">

<!--- DB Actions to be completed ------ ---

- link demand (mission) and supply (edition) based on the owner  

- Link a position to a pointer so we know from which roster to draw : rapid !!!!!!!!!!!!!!!!!

- Redo GradeDeployment to PostGradeBudget : table.

--->

<!--- supply side 

- Check BudgetGrades that do NOT have an entry in GradeDeployment

buckets : A. number of posts that are occupied + 
          candidate on the roster NOT reflected in the occupied posts

A. Current occupation		  
--->

<cfset FileNo = round(Rand()*100)>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_Forecast1_#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_Forecast2_#FileNo#">

<cfquery name="SupplyOnBoard" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 		  
	    SELECT PA.PersonNo, 
		       Person.IndexNo, 
			   F.OccupationalGroup, 
			   P.FunctionNo, 
			   G.PostGradeBudget, 
			   A.OrganizationCode, 
			   '3' AS Status 
	    INTO   UserQuery.dbo.#SESSION.acc#_Forecast1_#FileNo#
	    FROM   Position P INNER JOIN
	           Ref_PostGrade G ON P.PostGrade = G.PostGrade 
			   <!---  INNER JOIN Applicant.dbo.Ref_GradeDeployment GD ON G.PostGradeBudget = GD.PostGradeBudget --->
			   INNER JOIN
	           Applicant.dbo.FunctionTitle F ON P.FunctionNo = F.FunctionNo INNER JOIN
	           Organization.dbo.Organization A ON P.OrgUnitOperational = A.OrgUnit INNER JOIN
	           PersonAssignment PA ON P.PositionNo = PA.PositionNo INNER JOIN
	           Person ON PA.PersonNo = Person.PersonNo
	
		WHERE     (P.Mission IN
		               (SELECT     Mission
		                FROM       Organization.dbo.Ref_Mission
		                WHERE      MissionOwner = '#owner#')) 
		
		<!--- ------------------------------- --->				
		<!--- --valid position at this moment --->	
		<!--- ------------------------------- --->			
		
		AND (P.DateEffective < GETDATE()) AND (P.DateExpiration >= GETDATE()) 
		
		<!--- ------------------------------- --->
		<!--- valid assignment at this moment --->
		<!--- ------------------------------- --->
			
		AND (PA.DateEffective < GETDATE()) AND (PA.DateExpiration >= GETDATE()) AND (PA.AssignmentStatus IN ('0', '1'))
		
		GROUP BY PA.PersonNo, Person.IndexNo, F.OccupationalGroup, P.FunctionNo, G.PostGradeBudget, A.OrganizationCode 
		ORDER BY PA.PersonNo, Person.IndexNo, F.OccupationalGroup, P.FunctionNo, G.PostGradeBudget
	
</cfquery>	

<!--- 
B. rostered but not currently deployed
--->

<cfquery name="SupplyInRosterNotOnboard" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 	
		
    SELECT A.PersonNo as CandidateNo, 
           A.EmployeeNo AS PersonNo, 
		   A.IndexNo AS IndexNo,
		   F.OccupationalGroup, 
           FO.FunctionNo, 
		   FO.SubmissionEdition, 
		   G.PostGradeBudget, 
		   FO.OrganizationCode, 
		   MAX(AF.Status) AS Status 
		   
	INTO   UserQuery.dbo.#SESSION.acc#_Forecast2_#FileNo#	   
			   
	FROM   ApplicantFunction AF INNER JOIN
           FunctionOrganization FO ON AF.FunctionId = FO.FunctionId INNER JOIN
           FunctionTitle F ON FO.FunctionNo = F.FunctionNo INNER JOIN
		   Ref_GradeDeployment G ON G.GradeDeployment = FO.GradeDeployment INNER JOIN
           ApplicantSubmission S ON AF.ApplicantNo = S.ApplicantNo INNER JOIN
           Applicant A ON S.PersonNo = A.PersonNo 
	   
	WHERE  AF.Status IN
                    (SELECT     Status
                      FROM      Ref_StatusCode
                     WHERE      ShowRoster = '1'
					   AND      Owner = '#owner#' 
					   AND      Id = 'FUN')
					
					
   AND    FO.SubmissionEdition IN
                    (SELECT     SubmissionEdition
                     FROM          Ref_SubmissionEdition
                     WHERE      Owner = 'SysAdmin') 

   <!--- not already on board --->
   					 
   AND    A.IndexNo NOT IN
             (SELECT     IndexNo
              FROM       UserQuery.dbo.#SESSION.acc#_Forecast1_#FileNo#
			  WHERE      IndexNo is not NULL
			 ) 

   AND    A.EmployeeNo NOT IN
             (SELECT     PersonNo
              FROM       UserQuery.dbo.#SESSION.acc#_Forecast1_#FileNo#
			 )     
	
   <!--- --------------------- --->	
   <!--- not recently selected --->
   <!--- --------------------- --->			 

   <!--- pending --->			          
									 
	GROUP BY A.PersonNo, 
			 A.EmployeeNo, 
	         A.IndexNo,
	         F.OccupationalGroup, 
			 FO.FunctionNo, 
			 FO.OrganizationCode, 
			 FO.SubmissionEdition, 
			 G.PostGradeBudget 
			 
</cfquery>	


<!--- demand side --->

<!--- ------------------------------------------------------ --->
<!--- 1. add to FunctionBucket if not already present ------ --->
<!--- ------------------------------------------------------ --->

<!--- ------------------------------------------------------ --->
<!--- 2. split demand per roster edition-------------------- --->
<!--- ------------------------------------------------------ --->

<!---
All active positions at this moment, expressed for the bucket level excl. edition
--->

<!--- ------------------------------------------------ --->
<!--- 3. solve the grade deployment verses post grade- --->
<!--- ------------------------------------------------ --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_ForecastDEMAND_FULL_#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_ForecastDEMAND_Revised_#FileNo#">

<cfquery name="DemandInPositions" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 		
	
	SELECT     F.OccupationalGroup, 
			   P.FunctionNo, 
			   G.PostGradeBudget, 
			   A.OrganizationCode, 
			   COUNT(*) AS Demand
			   
	INTO       UserQuery.dbo.#SESSION.acc#_ForecastDEMAND_FULL_#FileNo#			   
			   
	FROM       Position P INNER JOIN
	           Ref_PostGrade G ON P.PostGrade = G.PostGrade  INNER JOIN
	           Applicant.dbo.FunctionTitle F ON P.FunctionNo = F.FunctionNo INNER JOIN
	           Organization.dbo.Organization A ON P.OrgUnitOperational = A.OrgUnit
			   
	WHERE      P.Mission IN
	                (SELECT     Mission
	                 FROM       Organization.dbo.Ref_Mission
	                 WHERE      MissionOwner = '#owner#') 
	 AND       P.DateEffective < GETDATE()
	 AND       P.DateExpiration >= GETDATE()
	
	GROUP BY   F.OccupationalGroup, P.FunctionNo, G.PostGradeBudget, A.OrganizationCode
	ORDER BY   F.OccupationalGroup, P.FunctionNo, G.PostGradeBudget		

</cfquery>	

<cfquery name="DemandInPositions" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 		
	
	SELECT     F.OccupationalGroup, 
			   P.FunctionNo, 
			   G.PostGradeBudget, 
			   A.OrganizationCode, 
			   COUNT(*) AS Demand
			   
	INTO       UserQuery.dbo.#SESSION.acc#_ForecastDEMAND_Revised_#FileNo#			   
			   
	FROM       Position P INNER JOIN
	           Ref_PostGrade G ON P.PostGrade = G.PostGrade  INNER JOIN
	           Applicant.dbo.FunctionTitle F ON P.FunctionNo = F.FunctionNo INNER JOIN
	           Organization.dbo.Organization A ON P.OrgUnitOperational = A.OrgUnit
			   
	WHERE      P.Mission IN
	                (SELECT     Mission
	                 FROM       Organization.dbo.Ref_Mission
	                 WHERE      MissionOwner = '#owner#') 
					 
	 AND       P.DateEffective < GETDATE()
	 AND       P.DateExpiration >= GETDATE()
	 	 
	 AND       (
	 
	 			 <!--- --Incumbered positions----------- --->
				 
	             P.PositionNo IN (
			                    SELECT PA.PositionNo 
			                    FROM   PersonAssignment PA 
								WHERE  PA.DateEffective < GETDATE() 
								AND    PA.DateExpiration >= GETDATE()
								AND    PA.AssignmentStatus IN ('0', '1')
							   )	 
	             OR 
				 
				 <!--- Postions under recruitment track --->
				 
				 P.PositionNo IN (
				               SELECT PV.PositionNo
							   FROM   Vacancy.dbo.DocumentPost PV
							   WHERE  DocumentNo IN (SELECT DocumentNo 
							                         FROM   Vacancy.dbo.Document 
													 WHERE  Status = '0')
							   )	
							   
				<!--- ------------------------------------------------------------- --->			   
				<!--- pending is the carried over from a prior mandate of the track --->
				<!--- ------------------------------------------------------------- --->				   			               
				 
	          )
	 	
	GROUP BY   F.OccupationalGroup, P.FunctionNo, G.PostGradeBudget, A.OrganizationCode
	ORDER BY   F.OccupationalGroup, P.FunctionNo, G.PostGradeBudget		

</cfquery>	

<!---				

<!--- underlying transactional level by mission --->

SELECT     P.MissionOperational, 
           F.OccupationalGroup, 
		   P.FunctionNo, 
		   GD.GradeDeployment, 
		   A.OrganizationCode, 
		   COUNT(*) AS Demand
FROM       Position P INNER JOIN
           Ref_PostGrade G ON P.PostGrade = G.PostGrade INNER JOIN
           Applicant.dbo.Ref_GradeDeployment GD ON G.PostGradeBudget = GD.PostGradeBudget INNER JOIN
           Applicant.dbo.FunctionTitle F ON P.FunctionNo = F.FunctionNo INNER JOIN
           Organization.dbo.Organization A ON P.OrgUnitOperational = A.OrgUnit
WHERE      P.Mission IN
                (SELECT     Mission
                 FROM       Organization.dbo.Ref_Mission
                 WHERE      MissionOwner = '#owner#') 
 AND       P.DateEffective < GETDATE()
 AND       P.DateExpiration >= GETDATE()

GROUP BY   P.MissionOperational,F.OccupationalGroup, P.FunctionNo, GD.GradeDeployment, A.OrganizationCode
ORDER BY   P.MissionOperational,F.OccupationalGroup, P.FunctionNo, GD.GradeDeployment				

---> 

