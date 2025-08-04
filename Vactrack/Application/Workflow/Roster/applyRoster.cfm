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

<!--- apply to roster all candidates that were recommended 2 but not selected 2s  --->

<cfquery name="Document" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Vacancy.dbo.Document
	WHERE  DocumentNo  = '#Object.ObjectKeyValue1#'				
</cfquery>

<cfif document.functionId neq "">
	
	<cfquery name="Applicant" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Vacancy.dbo.DocumentCandidate
		WHERE  DocumentNo  = '#Object.ObjectKeyValue1#'		
		AND    Status = '2'
	</cfquery>
	
	<cfquery name="Bucket" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Applicant.dbo.FunctionOrganization
		WHERE  FunctionId  = '#document.FunctionId#'				
	</cfquery>
		
	<cfif bucket.recordcount eq "1" and Applicant.recordcount gte "1">
		
		<!--- record candidates --->
	
		<cftransaction>
	
			<cf_RosterActionNo ActionRemarks="Auto rostering" ActionCode="FUN" datasource="AppsOrganization"> 
	
			<cfloop query="Applicant">	
			
					<cfquery name="ApplicantSubmission" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    TOP 1 *
						FROM      Applicant.dbo.ApplicantSubmission
						WHERE     PersonNo          = '#PersonNo#'
						AND       SubmissionEdition = '#Bucket.SubmissionEdition#'
						ORDER BY  Created DESC
					</cfquery>
					
					<cfif ApplicantSubmission.recordcount eq "0">
					
						<cfquery name="ApplicantSubmission" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    TOP 1 *
							FROM      Applicant.dbo.ApplicantSubmission
							WHERE     PersonNo = '#PersonNo#'				
							ORDER BY  Created DESC
						</cfquery>			
					
					</cfif>
					
					<cfif ApplicantSubmission.recordcount gte "1">
				
						<cfquery name="Check" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Applicant.dbo.ApplicantFunction 
							WHERE  ApplicantNo = '#ApplicantSubmission.ApplicantNo#'
							AND    FunctionId =  '#document.FunctionId#'
						</cfquery>
						
						<cfif check.recordcount eq "0">
					        				
							<cfquery name="InsertFunction" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">					
								INSERT INTO Applicant.dbo.ApplicantFunction 
							         (ApplicantNo,
									 FunctionId,
									 Status,
									 StatusDate,
									 FunctionJustification, 						
									 OfficerUserId,
									 OfficerLastName,
									 OfficerFirstName)
								VALUES ('#ApplicantSubmission.ApplicantNo#', 
							      	  '#document.FunctionId#',
									  '3',
									  getdate(),
									  'Auto rostering', 						  
									  '#SESSION.acc#',
									  '#SESSION.last#',
									  '#SESSION.first#')
						    </cfquery>
						
						<cfelse>
						
							<cfquery name="UpdateFunction" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">					
								UPDATE Applicant.dbo.ApplicantFunction 
							    SET    Status = '3'
								WHERE  FunctionId = '#document.FunctionId#'
								AND    ApplicantNo = '#ApplicantSubmission.ApplicantNo#'
						    </cfquery>
						
						</cfif>
							  
						<cfquery name="UpdateFunctionStatusAction" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO  Applicant.dbo.ApplicantFunctionAction
								   (ApplicantNo,
								   FunctionId, 
								   RosterActionNo, 
								   FunctionJustification, 
								   Status)
							VALUES 
								   ('#ApplicantSubmission.ApplicantNo#',
								   '#document.FunctionId#',
								   #RosterActionNo#,
								   'Auto rostering', 
								   '3')
						</cfquery> 	  			
						
					</cfif>	
				
			</cfloop>
	
		</cftransaction>
	
	</cfif>

</cfif>	