<!--- locate candidates that applies for jobs out of reach --->

<cfquery name="DenialSet" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  FO.FunctionId, AF.ApplicantNo, FO.GradeDeployment, R.Owner, PG.PostGradeBudget AS CandidateLevel
FROM    FunctionOrganization FO INNER JOIN
        ApplicantFunction AF ON FO.FunctionId = AF.FunctionId INNER JOIN
        ApplicantSubmission [AS] ON AF.ApplicantNo = [AS].ApplicantNo INNER JOIN
        Applicant A ON [AS].PersonNo = A.PersonNo INNER JOIN
        Employee.dbo.Person P ON A.IndexNo = P.IndexNo INNER JOIN
        Employee.dbo.PersonContract PC ON P.PersonNo = PC.PersonNo INNER JOIN
        Ref_SubmissionEdition R ON FO.SubmissionEdition = R.SubmissionEdition INNER JOIN
        Employee.dbo.Ref_PostGrade PG ON PC.ContractLevel = PG.PostGrade INNER JOIN
        Ref_RosterLevelCondition ON R.Owner = Ref_RosterLevelCondition.Owner AND PG.PostGradeBudget = Ref_RosterLevelCondition.ContractLevel AND 
        FO.GradeDeployment = Ref_RosterLevelCondition.GradeDeployment
WHERE   (PC.DateEffective < GETDATE()) 
AND     (PC.DateExpiration > GETDATE() OR PC.DateExpiration is NULL)
AND      FO.FunctionId = '#URL.IDFunction#' 
AND      AF.Status != '9' 
</cfquery>

<!--- batch to deny candidate --->

<cfif #DenialSet.recordcount# gt "0">

	<cf_RosterActionNo 
     ActionCode="FUN" 
	 ActionRemarks="Automatic Denial"> 
	 
	 <!--- loop accross all entries here --->
	 
	 <cftransaction action="BEGIN">

     <cfloop query = "DenialSet">

		<!--- roster action line --->
		
		<cfquery name="UpdateFunctionStatusAction" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  ApplicantFunctionAction
		   (ApplicantNo,
		   FunctionId, 
		   RosterActionNo, 
		   Status)
		VALUES 
		   ('#ApplicantNo#',
		   '#URL.IDFunction#',
		   #RosterActionNo#,
		   '9')
		</cfquery> 
				
		<!--- now update the status --->
		
		<cfquery name="UpdateFunctionStatus" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE    ApplicantFunction 
		SET       Status                = '9',
		          StatusDate            = getDate(), 
		          RosterGroupMemo       = 'Roster denial level'
		WHERE     ApplicantNo           = '#ApplicantNo#'
		  AND     FunctionId            = '#URL.IDFunction#'     
		</cfquery>
							
     </cfloop>
		
     </cftransaction>

</cfif>
