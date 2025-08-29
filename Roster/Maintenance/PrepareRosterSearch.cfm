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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="schedulelogid" default="0">

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Initialise tables">

<cf_droptable dbname="AppsSelection" full="1" tblname="stApplicantBase"> 
<cf_droptable dbname="AppsSelection" full="1" tblname="stApplicantOwner"> 
<cf_droptable dbname="AppsSelection" full="1" tblname="skApplicantOccGroup"> 

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "skApplicantBase">
	
<cfquery name="System" 
datasource="AppsSystem">
	SELECT * FROM Parameter
</cfquery>

<cfloop index="ads" from="1" to="100000" step="1"></cfloop>

<!--- extract in total --->
	
<cfquery name="Base" 
datasource="AppsSelection">
SELECT   S.PersonNo, 
         S.Source, 
		 B.ExperienceCategory AS Category, 
		 B.ExperienceId, 
		 B.ExperienceStart AS ExperienceStart, 
         B.ExperienceEnd AS ExperienceEnd, 
		 DATEDIFF(m, B.ExperienceStart, B.ExperienceEnd) AS Period,  
         RC.Parent, 
		 RC.ExperienceClass AS Class, 
		 RC.Description AS Classdescription, 
		 F.ExperienceFieldId as FieldId, 
		 R.Description, 
		 RC.OccupationalGroup, 
         Occ.Description AS OccupationGroupDescription, 
		 F.ExperienceLevel, 
		 R.Status, 
		 B.Created
INTO     stApplicantBase
FROM     ApplicantSubmission S INNER JOIN
         ApplicantBackground B      ON S.ApplicantNo = B.ApplicantNo INNER JOIN
         ApplicantBackgroundField F ON B.ApplicantNo = F.ApplicantNo AND B.ExperienceId = F.ExperienceId INNER JOIN
         Ref_Experience R           ON F.ExperienceFieldId = R.ExperienceFieldId INNER JOIN
         Ref_ExperienceClass RC     ON R.ExperienceClass = RC.ExperienceClass LEFT OUTER JOIN
         OccGroup Occ               ON RC.OccupationalGroup = Occ.OccupationalGroup
WHERE    B.Status < '9' AND R.Status = '1'
<!--- only enabled submission --->
AND      S.RecordStatus = '1'
AND      EXISTS
                (SELECT   'X' AS Expr1
                 FROM     ApplicantFunction
                 WHERE    ApplicantNo = S.ApplicantNo 				 
				 AND      Status IN
				 
                             (SELECT DISTINCT Status
                              FROM   Ref_StatusCode
                              WHERE  RosterAction = 1 
							  AND    Id = 'Fun' 
							  AND    Status <> '0' 
							  AND    Status <> '5')
				)
ORDER BY PersonNo, Source 
</cfquery>

<!--- extract by owner --->

<cfquery name="Base" 
datasource="AppsSelection">
SELECT   S.PersonNo, 
         S.Source, 
		 B.ExperienceCategory AS Category, 
		 B.ExperienceId, 
		 O.Owner,
		 B.ExperienceStart AS ExperienceStart, 
         B.ExperienceEnd AS ExperienceEnd, 
		 DATEDIFF(m, B.ExperienceStart, B.ExperienceEnd) AS Period,  
         RC.Parent, 
		 RC.ExperienceClass AS Class, 
		 RC.Description AS Classdescription, 
		 F.ExperienceFieldId as FieldId, 
		 R.Description, 
		 RC.OccupationalGroup, 
         Occ.Description AS OccupationGroupDescription, 
		 F.ExperienceLevel, 
		 R.Status, 
		 B.Created
INTO     stApplicantOwner
FROM     ApplicantSubmission S INNER JOIN
         ApplicantBackground B           ON S.ApplicantNo = B.ApplicantNo INNER JOIN
         ApplicantBackgroundField F      ON B.ApplicantNo = F.ApplicantNo AND B.ExperienceId = F.ExperienceId INNER JOIN
		 <!--- limitation --->
		 ApplicantBackgroundFieldOwner O ON O.ApplicantNo = F.ApplicantNo AND O.ExperienceId = F.ExperienceId AND O.ExperienceFieldId = F.ExperienceFieldId INNER JOIN
         Ref_Experience R                ON F.ExperienceFieldId = R.ExperienceFieldId INNER JOIN
         Ref_ExperienceClass RC          ON R.ExperienceClass = RC.ExperienceClass LEFT OUTER JOIN
         OccGroup Occ                    ON RC.OccupationalGroup = Occ.OccupationalGroup
WHERE    B.Status < '9' AND R.Status = '1'
<!--- only enabled submission --->
AND      S.RecordStatus = '1'
AND      EXISTS
                (SELECT   'X' AS Expr1
                 FROM     ApplicantFunction
                 WHERE    ApplicantNo = S.ApplicantNo 				 
				 AND      Status IN
				 
                             (SELECT DISTINCT Status
                              FROM   Ref_StatusCode
                              WHERE  RosterAction = 1 
							  AND    Id = 'Fun' 
							  AND    Status <> '0' 
							  AND    Status <> '5')
				)
				
ORDER BY PersonNo, Source 
</cfquery>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "skApplicantOccGroup">

<cfquery name="OccGroup" 
		datasource="AppsSelection">
		SELECT   DISTINCT PersonNo, 
		         OccupationalGroup, 
			     OccupationGroupDescription AS Description, 
			     SUM(Period) AS Period, 
			     COUNT(DISTINCT Created) AS Records
		INTO     skApplicantOccGroup
		FROM     stApplicantBase
		WHERE    OccupationalGroup IS NOT NULL
		GROUP BY PersonNo, OccupationalGroup, OccupationGroupDescription
		HAVING   SUM(Period) > 0
		ORDER BY PersonNo, OccupationalGroup  
</cfquery>

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "skApplicantKeyWord">
	
<cfquery name="Keyword" 
		datasource="AppsSelection">
		TRUNCATE Table skApplicantKeyword
</cfquery>			
	
<cfquery name="Keyword" 
		datasource="AppsSelection">
		INSERT INTO skApplicantKeyword
		(PersonNo, Category, Parent, Class, Classdescription, FieldId, Owner, Description, Period, Records) 
		SELECT   DISTINCT PersonNo, 
		         Category, 
			     Parent, 
			     Class, 
			     Classdescription, 
			     FieldId, 
				 'ANY',
			     Description, 
			     SUM(Period) AS Period, 
			     COUNT(DISTINCT Created) AS Records		
		FROM     stApplicantBase
		GROUP BY PersonNo, Category, Parent, Class, Classdescription, FieldId, Description 
</cfquery>

<cfquery name="Keyword" 
		datasource="AppsSelection">
		INSERT INTO skApplicantKeyword
		(PersonNo, Category, Parent, Class, Classdescription, FieldId, Owner, Description, Period, Records) 
		SELECT   DISTINCT PersonNo, 
		         Category, 
			     Parent, 
			     Class, 
			     Classdescription, 
			     FieldId, 
				 Owner,
			     Description, 
			     SUM(Period) AS Period, 
			     COUNT(DISTINCT Created) AS Records		
		FROM     stApplicantOwner
		GROUP BY PersonNo, Category, Parent, Class, Classdescription, FieldId, Description, Owner		
</cfquery>

<cf_droptable dbname="AppsSelection" full="1" tblname="stApplicantBase"> 
<cf_droptable dbname="AppsSelection" full="1" tblname="stApplicantOwner"> 

<cfquery name="Owners" 
		datasource="AppsSelection">
		SELECT * FROM Ref_ParameterOwner 
		WHERE Operational = 1
</cfquery>		

<cfif System.DatabaseAnalysis neq "">
				
	<cfloop query="Owners">
		
	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "Roster #Owner#">
		
		<!--- datasets --->
				
		<cf_droptable dbname="#System.DatabaseAnalysis#" full="1" tblname="skRoster#Owner#">
	
		<cfquery name="Roster" 
				datasource="#System.DatabaseAnalysis#">
				SELECT     A.PersonNo AS FactTableId,
						   O.Description AS OccGroup_dim, 
				           F.FunctionDescription AS Function_nme, 
						   A.Gender AS Gender_dim, 
						   FO.SubmissionEdition AS Edition_dim, 
				           SC.Status AS Status_dim, 
						   SC.Meaning AS Status_nme, 
						   FO.GradeDeployment AS Grade_dim, 
						   GD.ListingOrder as Grade_ord,
						   N.Continent AS Region_dim, 
						   N.Name AS Country_dim, 
				           A.MaritalStatus AS MaritalStatus_dim, 
						   A.PersonNo, 
						   A.IndexNo, 
						   A.LastName, 
						   A.FirstName,
						   A.MaidenName,
						   A.DOB, 
						   A.ApplicantClass, 
						   A.EmailAddress, 
						   A.SerialNo AS Candidate
						  
				INTO       dbo.skRoster#Owner#					  
				FROM       Applicant.dbo.FunctionOrganization AS FO INNER JOIN
			               Applicant.dbo.ApplicantFunction AS AF ON FO.FunctionId = AF.FunctionId INNER JOIN
			               Applicant.dbo.ApplicantSubmission AS S ON AF.ApplicantNo = S.ApplicantNo INNER JOIN
			               Applicant.dbo.Applicant AS A ON S.PersonNo = A.PersonNo INNER JOIN
			               System.dbo.Ref_Nation AS N ON A.Nationality = N.Code INNER JOIN
			               Applicant.dbo.FunctionTitle AS F ON FO.FunctionNo = F.FunctionNo INNER JOIN
			               Applicant.dbo.OccGroup AS O ON F.OccupationalGroup = O.OccupationalGroup INNER JOIN
			               Applicant.dbo.Ref_StatusCode AS SC ON AF.Status = SC.Status INNER JOIN
			               Applicant.dbo.Ref_SubmissionEdition AS SU ON FO.SubmissionEdition = SU.SubmissionEdition AND SC.Owner = SU.Owner INNER JOIN
		                   Applicant.dbo.Ref_GradeDeployment AS GD ON FO.GradeDeployment = GD.GradeDeployment
						   
				WHERE      FO.SubmissionEdition IN
				                     (SELECT     SubmissionEdition
				                      FROM       Applicant.dbo.Ref_SubmissionEdition AS Ref_SubmissionEdition_1
		                              WHERE      Owner = '#Owner#') 
				AND        AF.Status NOT IN ('5', '9') 
				AND        SC.Id = 'FUN'		
		</cfquery>	
		
	</cfloop>	
	
<cfelse>
	
<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Skipped the roster dataset">
	
</cfif>	

<cf_ScheduleLogInsert
   	ScheduleRunId  = "#schedulelogid#"
	Description    = "Completed">
	
	
<!---	
<cf_message message="Preparation completed">
--->

