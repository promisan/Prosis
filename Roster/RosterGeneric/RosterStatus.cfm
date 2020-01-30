	
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterStatus"> 	
 
<cfquery name="Dataset" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
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
						   
	INTO       #SESSION.acc#RosterStatus				  
									  
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
	WHERE   FO.SubmissionEdition IN
	                     (SELECT     SubmissionEdition
	                      FROM       Applicant.dbo.Ref_SubmissionEdition 
                             WHERE      Owner = '#Owner#') 
	AND     AF.Status NOT IN ('5', '9') 
	AND     SC.Id = 'FUN'		
		
</cfquery>

<cfset client.table1_ds = "#SESSION.acc#RosterStatus">
