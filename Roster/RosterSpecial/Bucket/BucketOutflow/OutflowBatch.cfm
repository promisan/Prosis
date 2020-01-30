

<!---  Base query


SELECT     AF.ApplicantNo, 
           AF.FunctionId, 
		   AF.Status AS CurrentStatus,
           (SELECT     MAX(R.ActionEffective) AS LastAction
             FROM          ApplicantFunctionAction A INNER JOIN
                                    RosterAction R ON A.RosterActionNo = R.RosterActionNo
             WHERE      A.ApplicantNo = AF.ApplicantNo AND A.FunctionId = AF.FunctionId) AS LastProcessed,
			 
           (SELECT     MAX(A.Created) AS LastShortlisted
             FROM          Vacancy.dbo.DocumentCandidate A
             WHERE      A.PersonNo = S.PersonNo) AS LastShortListed,
			 
           (SELECT     MAX(R.ActionEffective) AS LastAction
             FROM          ApplicantFunctionAction A INNER JOIN
                                    RosterAction R ON A.RosterActionNo = R.RosterActionNo
             WHERE      A.ApplicantNo = AF.ApplicantNo AND A.FunctionId = AF.FunctionId AND A.Status > '1' AND Status < '4') AS LastClearanceAction
			 
FROM         ApplicantFunction AF INNER JOIN
                      ApplicantSubmission S ON AF.ApplicantNo = S.ApplicantNo
WHERE     (AF.Status < '5')

--->

<!--- select and loop through buckets --->

<!--- 1. define a subset of statistical candidate information 
      2. loop through the buckets
	  	3. define rules that are valid loop through the rule for each bucket
		  4. Check which candidate match the rule 
		      i. update status / action and define if reapplication is possible in Portal
			  ii. send eMail optionally
--->




