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
<!--- steps 
1.	submit the base values PersonNo (A) and removal PersonNo (B)
--->

<cfparam name="Form.Correct" default="#url.correct#">
<cfparam name="Form.Wrong"   default="#url.wrong#">

<!---
2.	Check if removal personNo is in DocumentCandiate, if so change PersonNo into A, 
but only for documentNo that do not have already an occurance with the base (A).
--->

<cftransaction>
	
	<cfquery name="Step1" 
	datasource="appsSelection"
	username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	UPDATE    Vacancy.dbo.DocumentCandidate
	SET       PersonNo = '#Form.Correct#'
	WHERE     PersonNo = '#Form.Wrong#' 
	AND       DocumentNo NOT IN
	          (SELECT     DocumentNo
	           FROM       Vacancy.dbo.DocumentCandidate
	           WHERE      PersonNo = '#Form.Correct#')
	</cfquery>		
	   
	<!---
	2b. RI will take care of related tables in vacancy
	--->
	<!---changing individual table, with no RI on personno, this table is not part of supertrack
	anymore--->
	
	<cfquery name="Step1_a1" 
	datasource="appsSelection" username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	UPDATE    Organization.dbo.OrganizationObject
	SET       ObjectKeyValue2 = '#Form.Correct#'
	WHERE     ObjectKeyValue2 = '#Form.Wrong#' 
	AND       EntityCode      = 'EntCandidate' 
	AND       ObjectKeyValue1 NOT IN
	          (SELECT     DocumentNo
	           FROM       Vacancy.dbo.DocumentCandidate
	           WHERE      PersonNo = '#Form.Correct#')
	</cfquery>	
	
	<cfquery name="Step1_a2" 
	datasource="appsSelection" username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	UPDATE    Organization.dbo.OrganizationObject
	SET       ObjectKeyValue2 = '#Form.Correct#'
	WHERE     ObjectKeyValue2 = '#Form.Wrong#' 
	AND       EntityCode      = 'EntCandidate' 
	AND       Operational     = 0
	AND       ObjectKeyValue1 IN
	          (SELECT     DocumentNo
	           FROM       Vacancy.dbo.DocumentCandidate
	           WHERE      PersonNo = '#Form.Correct#')
	</cfquery>			
		
	
	<cftry>
	
	<!--- UN old track, can be removed at some point --->
	
	<cfquery name="Step1_b" 
	datasource="appsSelection" username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	UPDATE    Vacancy.dbo.DocumentActionAction
	SET       PersonNo = '#Form.Correct#'
	WHERE     PersonNo = '#Form.Wrong#' 
	AND       DocumentNo NOT IN
	          (SELECT     DocumentNo
	           FROM       Vacancy.dbo.DocumentCandidate
	           WHERE      PersonNo = '#Form.Correct#')
	</cfquery>		
	
	<cfcatch></cfcatch>
	
	</cftry>
	
	<!---
	3.	Remove possible (pretty unlikely) remaining entries in DocumentCandidate for B 
	this will also delete WF at some point
	--->
	
	<cfquery name="Step3" 
	datasource="appsSelection" username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	DELETE FROM Vacancy.dbo.DocumentCandidate
	WHERE       PersonNo = '#Form.Wrong#' 
	</cfquery>		
	
	<!---
	4.	Check if removal personNo A is in ApplicantFunction 
	(determine applicantNo B through ApplicantSubmission for Edition = Galaxy for B), 
	if so change ApplicantFunction : ApplicantNo into Applicant A, 
	but only for FunctionId that do not have already an occurance with the Applicant (A).
	--->
	
	<cfquery name="Preferred" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    TOP 1 ApplicantNo
		FROM      ApplicantSubmission
		WHERE     PersonNo = '#Form.Correct#'
		ORDER BY  ApplicantNo DESC 
	</cfquery>	
	
	<!--- select the job buckets of the wrong candidate --->
	
	<cfquery name="Step4" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  AF.ApplicantNo, 
		        AF.FunctionId
		FROM    ApplicantSubmission S INNER JOIN
		        ApplicantFunction AF ON S.ApplicantNo = AF.ApplicantNo
		WHERE   S.PersonNo = '#Form.Wrong#'
	</cfquery>
				
		<cfloop query="step4">
		
			<!--- check if bucket exists for correct candidate --->
			
			<cfquery name="Check" 
			datasource="appsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  AF.ApplicantNo, 
				        AF.FunctionId
				FROM    ApplicantSubmission S INNER JOIN
				        ApplicantFunction AF ON S.ApplicantNo = AF.ApplicantNo
				WHERE   S.PersonNo = '#Form.Correct#'
				AND     AF.FunctionId = '#FunctionId#'
			</cfquery>
			
			<!--- if not exists, update applicant function --->
			
			<cfif check.recordcount eq "0">
		
				<cfquery name="Loop" 
				datasource="appsSelection" username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				UPDATE ApplicantFunction 
				SET    ApplicantNo = '#Preferred.applicantNo#'
				WHERE  ApplicantNo = '#ApplicantNo#'
				AND    FunctionId  = '#FunctionId#'
				</cfquery>
		
				<!---
				4b.	RI will take care of related tables under applicantFunction
				--->
			
			</cfif>
		
		</cfloop>
		
	<!--- remove remaining --->
	
	<cfquery name="Step8" 
	datasource="appsSelection" username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ApplicantFunctionTopic
	WHERE  ApplicantNo IN (SELECT ApplicantNo 
	                       FROM ApplicantSubmission 
						   WHERE Personno = '#Form.Wrong#') 
	</cfquery>		
	
	<cfquery name="Step8" 
	datasource="appsSelection" username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ApplicantFunction
	WHERE  ApplicantNo IN (SELECT ApplicantNo FROM ApplicantSubmission WHERE Personno = '#Form.Wrong#') 
	</cfquery>		
	
	<!---
	5.  change PersonNo in ApplicantMail
	--->
	
	<cfquery name="Step5" 
	datasource="appsSelection" username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	UPDATE    ApplicantMail
	SET       PersonNo = '#Form.Correct#'
	WHERE     PersonNo = '#Form.Wrong#' 
	</cfquery>	
	
	<!---
	5.  change PersonNo in Recruitment workflow
	--->	 
	
	<cfquery name="Step5b" 
	datasource="appsSelection" username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	UPDATE    Organization.dbo.OrganizationObject
	SET       PersonNo = '#Form.Correct#'
	WHERE     PersonNo = '#Form.Wrong#' 
	AND       PersonNo is not NULL
	AND EntityCode IN ('VacCandidate', 'EntCandidate')
	</cfquery>		  
	
	<!---
	6.  change personNo in RosterSearch result (but only if not existent for Search)
	--->
	
	<cftry>
	
		<cfquery name="Step6" 
		datasource="appsSelection" username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		UPDATE   RosterSearchResult
		SET      PersonNo = '#Form.Correct#'
		FROM     RosterSearchResult RS
		WHERE    PersonNo = '#Form.Wrong#' 
		AND      NOT EXISTS
		                   (SELECT    'X'
		                    FROM      RosterSearchResult RS2
		                    WHERE     RS2.PersonNo = '#Form.Correct#'
							AND       RS2.SearchId = RS.SearchId)
		</cfquery>		
	
		<cfcatch>	
		</cfcatch>
		
	</cftry>
	
	<!---
	8.  Remove Applicant wrong+PHP information through RI from the Database
	--->
	
	<cfquery name="Step7a" 
	datasource="appsSelection" username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT IndexNo
		FROM   Applicant A
		WHERE  PersonNo = '#Form.Wrong#'
		AND    A.IndexNo IN (SELECT IndexNo FROM Employee.dbo.Person WHERE IndexNo = A.IndexNo)	
	</cfquery>		
	
	<cfif Step7a.recordcount eq "1">
		
		<cfquery name="Step7b" 
		datasource="appsSelection" username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Applicant
			SET    IndexNo    = '#Step7a.IndexNo#'
			FROM   Applicant A
			WHERE  A.PersonNo   = '#Form.Correct#' 
			AND    A.IndexNo NOT IN (SELECT IndexNo FROM Employee.dbo.Person WHERE IndexNo = A.IndexNo)	
		</cfquery>	
	
	</cfif>

	<cfquery name="qUpdateAction"
			datasource="appsSelection" username="#SESSION.login#"
			password="#SESSION.dbpw#">
		UPDATE ApplicantAction
		SET PersonNo= '#Form.Correct#'
		WHERE  PersonNo = '#Form.Wrong#'
	</cfquery>


	<cfquery name="Step8" 
	datasource="appsSelection" username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Applicant
		WHERE  PersonNo = '#Form.Wrong#' 
	</cfquery>

	<!---- Below added by dev on Jan 21 2021 ---->
	<cfquery name="qCheckCustomer"
			datasource="appsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT * FROM Workorder.dbo.Customer
		WHERE PersonNo ='#FORM.Correct#'
	</cfquery>

	<cfif qCheckCustomer.recordcount neq 0>

		<cfquery name="qCheckCustomerWrong"
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   Workorder.dbo.Customer
					WHERE  PersonNo ='#FORM.Wrong#'
		</cfquery>

		<cfif qCheckCustomerWrong.recordcount neq 0>
			
			 <cfquery name="Step9"
				  datasource="appsSelection" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  UPDATE WorkOrder.dbo.WorkOrder
					  SET    CustomerId ='#qCheckCustomer.CustomerId#'
					  WHERE CustomerId ='#qCheckCustomerWrong.CustomerId#'
			</cfquery>
		</cfif>
	</cfif>
	
</cftransaction>

<!---
7.  Update Conversion to direct Galaxy account to the correct account 
so we make sure that tomorrow when we wake up PHP data is there for the new account (if needed).
--->

<cftry>
	
	<cfquery name="Step6" 
	datasource="appsSelection" 
	username="Dev"
	password="Dev">
		UPDATE    [nova-p-db-007].InspiraJO.dbo.CONVERSION
		SET       PersonNo    = '#Form.Correct#',
		          ApplicantNo = '#Step41.applicantNo#',
				  Preferred   = 0
		WHERE     PersonNo    = '#Form.Wrong#' 
	</cfquery>	
	
	<cfcatch></cfcatch>	

</cftry>

<cfoutput>
	
	<script>			   
	   ptoken.location('#SESSION.root#/Roster/Candidate/Details/PHPView.cfm?ID=#url.correct#&mode=Manual','parent')
	   parent.ProsisUI.closeWindow('mydialog',true)  	 
	</script>

</cfoutput>

