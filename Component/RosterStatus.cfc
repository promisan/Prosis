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
<!--- conditions
     valid interview and 
	 valid review status and
	 cleanred for the preroster status 
--->

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Roster Status">
	
	<!--- 1.0 GENERAL ACCESS TO A FUNCTION --->
	
	<cffunction access="public" name="RosterSet" output="true" returntype="string" displayname="Verify Function Access">
	
		<cfargument name="PersonNo"   type="string" default="0" required="yes">
	    <cfargument name="Owner"      type="string" default=""  required="yes">
		<cfargument name="Interview"  type="string" default="0" required="yes">
			
		<cfquery name="TriggerStatus" 
		  datasource="AppsSelection" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT    *
			FROM      Ref_StatusCode
			WHERE     Owner         = '#owner#' 
			AND       Id            = 'FUN' 
			AND       TriggerMethod = 'Roster'
		</cfquery>	
		
		<!--- check if we take interview status into consideration --->
		
		<cfset roster = "1">
						
		<cfif Interview eq "1">
					
			<!--- --------------- --->
			<!--- -- Interview -- --->
			<!--- --------------- --->
		
			<cfquery name="Last" 
			  datasource="AppsSelection" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  SELECT   TOP 1 *
				  FROM     ApplicantInterview
				  WHERE    PersonNo = '#PersonNo#'
				  ORDER BY Created DESC
			</cfquery>
			
			<cfif Last.InterviewStatus eq "1">
			
				<cfquery name="Interview" 
				  datasource="AppsSelection" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT  *
				    FROM    ApplicantInterview
				    WHERE   InterviewId = '#Last.InterviewId#'
				</cfquery>
				
				<cfif Interview.InterviewStatus eq "1">
				
				    <!--- --------------- --->
					<!--- Reference check --->
					<!--- --------------- --->
						
					<cfquery name="Reference" 
					  datasource="AppsSelection" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT     *
						FROM      Ref_ReviewClass
						WHERE     RosterCondition = '1'
					</cfquery>
					
					<cfloop query="Reference">
					
					      <cfquery name="Review" 
						  datasource="AppsSelection" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  SELECT  *
							  FROM    ApplicantReview
							  WHERE   PersonNo   = '#PersonNo#'
							  AND     ReviewCode = '#Code#'
							  AND     Owner      = '#owner#'
							  AND     Status     = '1'
						  </cfquery>
						  
						  <cfif Review.Recordcount eq "0">
						  
						  		<cfset roster = "0">
						  
						  </cfif>
						
					</cfloop>	
							
				</cfif>
				
			</cfif>	
			
		<cfelse>
		
			<!--- Reference check --->
				
			<cfquery name="Reference" 
			  datasource="AppsSelection" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_ReviewClass
				WHERE     RosterCondition = '1' 
			</cfquery>
					
			<cfloop query="Reference">
										
				  <cfquery name="Review" 
				  datasource="AppsSelection" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
						  SELECT  *
						  FROM    ApplicantReview
						  WHERE   PersonNo   = '#PersonNo#'
						  AND     ReviewCode = '#Code#'
						  AND     Owner      = '#owner#'
						  AND     Status     = '1'
				  </cfquery>
					  
				  <cfif Review.Recordcount eq "0">
					  
					    <!--- not a roster candidate --->
				  		<cfset roster = "0">
					  
				  </cfif>
						
			</cfloop>		
		
		</cfif>	
		
		<!--- now we make it a rostered candidate --->
									
		<cfif roster eq "1">
		
			<!--- we are going to apply the roster status now to all actions that are ready for it --->
			
			<cf_RosterActionNo 
			    ActionRemarks="Auto apply roster status" 
				ActionStatus="0"  <!--- we tag this as a searate action to be excluded in certain queries --->
				ActionCode="FUN">  
				
				<!--- Special scenario : ----------------------------------------------------- --->			
				<!--- restore in case there was a revoke of a prior denial which was automated --->
				<!--- ------------------------------------------------------------------------ --->				
							
				<cfquery name="PriorStatus" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT     F.ApplicantNo, 
					           F.FunctionId, 
							   
							   (SELECT    TOP 1 R.RosterActionNo 
							    FROM      ApplicantFunctionAction AF INNER JOIN
		                	              RosterAction R ON AF.RosterActionNo = R.RosterActionNo
								WHERE     R.ActionStatus = '1'
								AND       ApplicantNo = F.ApplicantNo
								AND       FunctionId  = F.FunctionId
								ORDER BY  R.RosterActionNo DESC
								) RosterActionPrior,
								
								(SELECT   TOP 1 R.RosterActionNo 
							     FROM     ApplicantFunctionAction R
								 WHERE    ApplicantNo = F.ApplicantNo
								 AND      FunctionId  = F.FunctionId
								 ORDER BY R.RosterActionNo DESC
								) RosterActionCurrent								
							   	  
					FROM       ApplicantFunction F

					WHERE      F.ApplicantNo IN ( SELECT     ApplicantNo
									              FROM       ApplicantSubmission
									              WHERE      PersonNo    = '#PersonNo#'
												  AND        ApplicantNo = F.ApplicantNo) 
													  
					AND        F.FunctionId IN  ( SELECT FunctionId 
					                              FROM   FunctionOrganization FO, Ref_SubmissionEdition SE
										          WHERE  FO.SubmissionEdition = SE.SubmissionEdition
												  AND    FO.FunctionId        = F.FunctionId
					                              AND    SE.Owner             = '#Owner#')				 
	
					<!--- current status = denied --->												 
					AND         F.Status = '9' 		
									
				</cfquery>
							
				<cfloop query="priorstatus">								
												
					<cfif RosterActionPrior neq RosterActionCurrent>				
																				
						<cfquery name="Revert_01" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO  ApplicantFunctionAction
								   (ApplicantNo,
								   FunctionId, 
								   RosterActionNo, 
								   Status,
								   StatusDate)
							SELECT A.ApplicantNo, 
							       A.FunctionId, 
								   '#RosterActionNo#', 
								   A.Status, 
								   A.StatusDate
							FROM   ApplicantFunctionAction A
							WHERE  A.ApplicantNo    = '#ApplicantNo#'
							AND    A.FunctionId     = '#FunctionId#'
							AND    A.RosterActionNo = '#RosterActionPrior#'
						</cfquery> 	
									
						<!--- update applicationfunction to prior status --->
						
						<cfquery name="Revert_02" 
						  datasource="AppsSelection" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							UPDATE ApplicantFunction 
							SET    Status = A.Status 
							FROM   ApplicantFunction F,
								   ApplicantFunctionAction A
							WHERE  A.ApplicantNo    = '#ApplicantNo#'
						    AND    A.FunctionId     = '#FunctionId#'
						    AND    A.RosterActionNo = '#RosterActionPrior#'
							AND    A.ApplicantNo    = F.ApplicantNo   
						    AND    A.FunctionId     = F.FunctionId    
						</cfquery>		
					
					</cfif>						
									
				</cfloop>	
									
				<!--- --------------------------------------------------------- --->			
				<!--- everything should be restored by now to the old situation --->
				<!--- --------------------------------------------------------- --->
				
				<!--- now check if we need to set records from prior roster to status 3 because if the confirmation --->
				
				<cftry>
					
					<cfquery name="RecordApplicantFunctionAction" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
	
						INSERT INTO  ApplicantFunctionAction
							   (ApplicantNo,
							   FunctionId, 
							   RosterActionNo, 
							   Status,
							   StatusDate)
	
						SELECT ApplicantNo, 
						       FunctionId, 
							   '#RosterActionNo#', 
							   '3',
							   StatusDate
							   
						FROM   ApplicantFunction S
						WHERE  ApplicantNo IN (SELECT   ApplicantNo
							                  FROM      ApplicantSubmission
							                  WHERE     PersonNo = '#PersonNo#'
											  AND       ApplicantNo = S.ApplicantNo) 
											  
						AND    FunctionId IN (SELECT    FunctionId 
						                      FROM      FunctionOrganization FO, Ref_SubmissionEdition SE
											  WHERE     FO.SubmissionEdition = SE.SubmissionEdition
											  AND       FO.FunctionId        = S.FunctionId
						                      AND       SE.Owner = '#Owner#')	
											  
						AND    Status = '#TriggerStatus.Status#'		<!--- 2f --->			  		 
						
					</cfquery> 	
				
				   <cfcatch></cfcatch>
				
				</cftry>
			
				<!--- update applicationfunction --->
				
				<cfquery name="Update" 
				  datasource="AppsSelection" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					UPDATE ApplicantFunction 
					SET    Status = '3' 
					WHERE  ApplicantNo IN (SELECT     ApplicantNo
						                   FROM       ApplicantSubmission
							               WHERE      PersonNo = '#PersonNo#') 
					AND    FunctionId IN (SELECT FunctionId 
				                     FROM   FunctionOrganization FO, Ref_SubmissionEdition SE
									 WHERE  FO.SubmissionEdition = SE.SubmissionEdition
				                     AND    SE.Owner = '#Owner#')	
					AND    Status = '#TriggerStatus.Status#'		
					<!---				 			 
			    	AND    Status IN (SELECT Status 
				                      FROM   Ref_StatusCode 
								      WHERE  Owner = '#Owner#' 
									  and    id = 'FUN')
				    --->
				</cfquery>		
				
		</cfif>
		
		<!--- send eMail --->
				
			<cfquery name="OwnerStep" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_StatusCode C, Ref_ParameterOwner R
				WHERE  C.Owner = '#Owner#'
				AND    Id      = 'Fun'
				AND    Status  = '3'
				AND    C.Owner = R.Owner
			</cfquery>
								
			<!--- send Action eMail automatically --->
								
			<cfif OwnerStep.MailConfirmation eq "INDIVIDUAL">
				
				    <!--- run query --->
					<cfquery name="App" 
					datasource="AppsSelection" 
					maxrows="1"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   A.*, 
						         S.ApplicantNo,
								 F.FunctionDescription AS FunctionTitle, 
								 FO.ReferenceNo, 
						         FO.DateEffective, 
								 FO.GradeDeployment AS Grade
						FROM     Applicant A, 
				                 ApplicantSubmission S,
							     ApplicantFunction AF,
							     FunctionOrganization FO,
							     FunctionTitle F,
							     ApplicationFunctionAction AA
						WHERE    A.PersonNo = S.PersonNo 
						AND      S.ApplicantNo = AF.ApplicantNo 
						AND      AF.FunctionId = FO.FunctionId 
						AND      FO.FunctionNo = F.FunctionNo
						AND      AF.ApplicantNo = AA.ApplicantNo
						AND      AF.FunctionId  = AF.FunctionId
						AND      AA.RosterActionNo = '#RosterActionNo#'	   
						AND      A.eMailAddress > ''
					</cfquery>
					
					<cfloop query="App">
					
						<!--- populate variable table for reference puposes --->
						
						<!---
						<cf_mailVariableAdd
						EntityCode = "EntRosterClearance"
						Var = "App"
						Fields = "#App.ColumnList#">
						--->
						
						<cfset subject = OwnerStep.MailSubject>
												
									
						<!--- send eMail --->
						<cfset body = ownerStep.MailText>
						
						<cfif app.gender eq "F">
							<cfset body = ReplaceNoCase("#body#", "@name", "Mrs. #firstname# #app.lastName#", "ALL")>
						<cfelse>
							<cfset body = ReplaceNoCase("#body#", "@name", "Mr. #firstname# #app.lastName#", "ALL")>
						</cfif>	
												
						<cfset body = ReplaceNoCase("#body#", "@effective", "#dateformat(DateEffective, CLIENT.DateFormatShow)#", "ALL")>
						
						<cfset exp  = dateformat("#now()#+#Ownerstep.rosterDays#", "#CLIENT.DateFormatShow#")>
						<cfset body = ReplaceNoCase("#body#", "@expiration", "#exp#", "ALL")>					
						<cfset body = ReplaceNoCase("#body#", "@grade", "#grade#", "ALL")>
						<cfset body = ReplaceNoCase("#body#", "@function", "#functiontitle#", "ALL")>
						<cfset body = ReplaceNoCase("#body#", "@RefNum", "#ReferenceNo#", "ALL")>					
						<cfset body = ReplaceNoCase("#body#", "@dob", "#dateformat(dob, CLIENT.DateFormatShow)#", "ALL")>
						<cfset body = ReplaceNoCase("#body#", "@officer", "#SESSION.first# #SESSION.last#", "ALL")>
						
						<cfif app.eMailAddress neq "" and OwnerStep.DefaultEMailAddress neq "">
			
							<cfif isValid("email", "#Candidate.eMailAddress#")>
							
							    <cfif isValid("email", "#client.email#")>
						
									<cf_MailSend
										class        = "Applicant"
										classId      = "#Candidate.PersonNo#"
										ApplicantNo  = "#Candidate.ApplicantNo#"
										FunctionId   = "#Candidate.FunctionId#"
										ReferenceId  = "#RosterActionNo#"
										TO           = "#Candidate.eMailAddress#"
										BCC          = "#client.email#"
										FROM         = "#OwnerStep.DefaultEMailAddress#"
										subject      = "#subject#"
										bodycontent  = "#body#"
										mailSend     = "Yes"
										saveMail     = "1">
									
								<cfelse>
								
									<cf_MailSend
										class        = "Applicant"
										classId      = "#Candidate.PersonNo#"
										ApplicantNo  = "#Candidate.ApplicantNo#"
										FunctionId   = "#Candidate.FunctionId#"
										ReferenceId  = "#RosterActionNo#"
										TO           = "#Candidate.eMailAddress#"	
										BCC          = "#client.email#"				
										FROM         = "#OwnerStep.DefaultEMailAddress#"
										subject      = "#subject#"
										bodycontent  = "#body#"
										mailSend     = "Yes"
										saveMail     = "1">				
								
								</cfif>	
								
							<cfelse>	
							
								<!--- just log the mail --->
							
								<cf_MailSend
									class        = "Applicant"
									classId      = "#Candidate.PersonNo#"
									ApplicantNo  = "#Candidate.ApplicantNo#"
									FunctionId   = "#Candidate.FunctionId#"
									ReferenceId  = "#RosterActionNo#"
									TO           = "NOT SENT:#Candidate.eMailAddress#"
									FROM         = "#OwnerStep.DefaultEMailAddress#"
									subject      = "#subject#"
									bodycontent  = "#body#"
									mailSend     = "No"
									saveMail     = "1">
							
							</cfif>
							
						<cfelse>
						
							<!--- just log the mail --->
						
							<cf_MailSend
								class        = "Applicant"
								classId      = "#Candidate.PersonNo#"
								ApplicantNo  = "#Candidate.ApplicantNo#"
								FunctionId   = "#Candidate.FunctionId#"
								ReferenceId  = "#RosterActionNo#"
								TO           = "NOT SENT:#Candidate.eMailAddress#"
								FROM         = "#OwnerStep.DefaultEMailAddress#"
								subject      = "#subject#"
								bodycontent  = "#body#"
								mailSend     = "No" <!--- log do not send --->
								saveMail     = "1">
						
						</cfif>
															
					</cfloop>
												
				</cfif>	
				
				<cfreturn roster>
		
	</cffunction>	
	
		
	
	<cffunction access="public" name="RosterDeny" output="true" returntype="string" displayname="Verify Function Access">
		<cfargument name="PersonNo" type="string" default="0" required="yes">
	    <cfargument name="Owner"    type="string" default="" required="yes">
		
		<!--- a deny will affect all settings for that person --->
		
		
			<!--- write an action --->
			
			<cfquery name="getStatus" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_StatusCode
				WHERE     Owner = '#Owner#' 
				AND       Id = 'FUN' 
				AND       PreRosterStatus = 1
			</cfquery>
			
			<cfif getStatus.recordcount eq "1">
			
				<cfquery name="get" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
					SELECT ApplicantNo, 
					       FunctionId
					FROM   ApplicantFunction
					WHERE  ApplicantNo IN
				                (SELECT     ApplicantNo
				                 FROM       ApplicantSubmission
				                 WHERE      PersonNo = '#PersonNo#') 
					AND    FunctionId IN (SELECT FunctionId 
					                      FROM   FunctionOrganization FO, Ref_SubmissionEdition SE
										  WHERE  FO.SubmissionEdition = SE.SubmissionEdition
					                      AND    SE.Owner = '#Owner#')			 
				    AND    Status = '3'  <!--- roster status --->
				</cfquery> 	
				
				<cfif get.recordcount gte "1">
			
					<cf_RosterActionNo 
				    ActionRemarks="Auto apply roster deny" 
					ActionCode="FUN"
					ActionStatus="0">  <!--- to be excluded in reverse actions --->
							
					<cfquery name="UpdateRosterAction" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO  ApplicantFunctionAction
							   (ApplicantNo,
							   FunctionId, 
							   RosterActionNo, 
							   Status)
						SELECT ApplicantNo, 
						       FunctionId, 
							   '#RosterActionNo#', 
							   '#getStatus.Status#'
						FROM   ApplicantFunction
						WHERE  ApplicantNo IN
					                (SELECT     ApplicantNo
					                 FROM       ApplicantSubmission
					                 WHERE      PersonNo = '#PersonNo#') 
						AND    FunctionId IN (SELECT FunctionId 
						                      FROM   FunctionOrganization FO, Ref_SubmissionEdition SE
											  WHERE  FO.SubmissionEdition = SE.SubmissionEdition
						                      AND    SE.Owner = '#Owner#')			 
					    AND    Status = '3'  <!--- roster status --->
					</cfquery> 	
				
				   <!--- update status applicationfunction --->
					<cfquery name="UpdateRosterStatus" 
					  datasource="AppsSelection" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						UPDATE ApplicantFunction 
						SET    Status = '#getStatus.Status#'
						WHERE  ApplicantNo IN
				                (SELECT     ApplicantNo
				                 FROM       ApplicantSubmission
				                 WHERE      PersonNo = '#PersonNo#') 
						AND    FunctionId IN (SELECT FunctionId 
					                     FROM   FunctionOrganization FO, Ref_SubmissionEdition SE
										 WHERE  FO.SubmissionEdition = SE.SubmissionEdition
					                     AND    SE.Owner = '#Owner#')				 
				    	AND    Status = '3'
					</cfquery>	
					
				</cfif>	
			
			</cfif>
		
	</cffunction>	

</cfcomponent>		

