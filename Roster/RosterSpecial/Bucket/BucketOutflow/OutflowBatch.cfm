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




