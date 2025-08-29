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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Applicant Submission utilities">
	
	<cffunction
	    name 	    = "CopyApplicantBackground"
	    description = "Copies over ApplicantBackGroundNNN (education, work, training), ApplicantLanguage, ApplicantCompentenceNN, ApplicantMissionNN and ApplicantSubmisisonProfile/Topic"
	    displayName = "CopyApplicantBackground"
	    returnType  = "string">
		
			 <cfargument name="DataSource"      required="yes" type="string">
			 <cfargument name="ApplicantNoFrom" required="yes" type="string">
			 <cfargument name="ApplicantNoTo"   required="yes" type="string">
	         
			 <!--- Validate that both applicant numbers are valid --->
			 
 			 <cfquery name = "ValidateFrom" 
			 datasource    = "#Datasource#" 
			 username      = "#SESSION.login#" 
			 password	   = "#SESSION.dbpw#">
			 	SELECT *
				FROM   Applicant.dbo.ApplicantSubmission
				WHERE  ApplicantNo = '#ApplicantNoFrom#'
			 </cfquery>
			 
 			 <cfquery name = "ValidateTo" 
			 datasource	   = "#Datasource#" 
			 username      = "#SESSION.login#" 
			 password      = "#SESSION.dbpw#">
			 	SELECT *
				FROM   Applicant.dbo.ApplicantSubmission
				WHERE  ApplicantNo = '#ApplicantNoTo#'
			 </cfquery>
			 
			 <cfif ValidateFrom.RecordCount eq 1 and ValidateTo.RecordCount eq 1>
			 	
				<cftransaction>
				
			    <!--- ApplicantBackground --->

				<cfinvoke component = "Service.Process.System.Database"  
				   method           = "getTableFields" 
				   datasource	    = "#Datasource#"	  
				   tableName        = "ApplicantBackground"
				   ignoreFields		= "'ApplicantNo','ExperienceId','OfficerUserId','OfficerLastName','OfficerFirstName','Updated','Created'"
				   returnvariable   = "fields">	
				   
				 <cfquery name = "InsertApplicantBackground" 
				 datasource    = "#Datasource#" 
				 username      = "#SESSION.login#" 
				 password      = "#SESSION.dbpw#">
				 			 
				 	INSERT INTO Applicant.dbo.ApplicantBackground	(
						   ApplicantNo,
						   ExperienceId,
						   OfficerUserId,
						   OfficerLastName,
						   OfficerFirstName,
						   Updated,
						   Created,
						   #fields#  )
					  
					SELECT '#ApplicantNoTo#' AS ApplicantNo,
						   ExperienceId,
						   '#SESSION.Acc#',
						   '#SESSION.Last#',
						   '#SESSION.First#',
						   getdate() AS Updated,
						   getdate() AS Created,
						   #fields#
							
				    FROM   Applicant.dbo.ApplicantBackground
				    WHERE  ApplicantNo = '#ApplicantNoFrom#'
		  
				</cfquery>
		
				<!--- All following tables can be copied using the same mechanism, therefore, we put them in a loop --->								
								
				<cfset tableList = "ApplicantBackgroundClassTopic,ApplicantBackgroundDetail,ApplicantBackgroundField,ApplicantBackgroundFieldOwner">
				<cfset tableList = tableList & ",ApplicantLanguage,ApplicantCompetence,ApplicantMission,ApplicantSubmissionProfile,ApplicantSubmissionTopic">
				
				<cfloop index="table" list="#tableList#" delimiters=",">
				
					<cfinvoke component = "Service.Process.System.Database"  
					   method           = "getTableFields" 
					   datasource	    = "#Datasource#"	  
					   tableName        = "#table#"
					   ignoreFields		= "'ApplicantNo','OfficerUserId','OfficerLastName','OfficerFirstName','Created'"
					   returnvariable   = "fields">	
					   
					 <cfquery name = "InsertData" 
					 datasource    = "#Datasource#" 
					 username      = "#SESSION.login#" 
					 password      = "#SESSION.dbpw#">
					 			 
					 	INSERT INTO Applicant.dbo.#table#(
							   ApplicantNo,
							   OfficerUserId,
							   OfficerLastName,
							   OfficerFirstName,
							   Created,
							   #fields#)
						  
						SELECT '#ApplicantNoTo#' AS ApplicantNo,
							   '#SESSION.Acc#',
							   '#SESSION.Last#',
							   '#SESSION.First#',
							   getdate() AS Created,
							   #fields#
								
					    FROM   Applicant.dbo.#table#
					    WHERE  ApplicantNo = '#ApplicantNoFrom#'
			  
					</cfquery>
				
				</cfloop>
			 
			 	<!--- ApplicantCompetenceAction --->
				<cfinvoke component = "Service.Process.System.Database"  
				   method           = "getTableFields" 
				   datasource	    = "#Datasource#"	  
				   tableName        = "ApplicantCompetenceAction"
				   ignoreFields		= "'ApplicantNo'"
				   returnvariable   = "fields">	
				   
				 <cfquery name = "InsertApplicantCompetenceAction" 
				 datasource    = "#Datasource#" 
				 username      = "#SESSION.login#" 
				 password      = "#SESSION.dbpw#">
				 			 
				 	INSERT INTO Applicant.dbo.ApplicantCompetenceAction(
						   ApplicantNo,
						   #fields#)
					  
					SELECT '#ApplicantNoTo#' AS ApplicantNo,
						   #fields#
							
				    FROM   Applicant.dbo.ApplicantCompetenceAction
				    WHERE  ApplicantNo = '#ApplicantNoFrom#'
		  
				</cfquery>
				 
			 	<!--- Change RecordStatus of ApplicantSubmission for ApplicantNoFrom, because it is now superseded by ApplicantNoTo --->
				 <cfquery name = "UpdateRecordStatus" 
				 datasource    = "#Datasource#" 
				 username      = "#SESSION.login#" 
				 password      = "#SESSION.dbpw#">
				 			 
				    UPDATE Applicant.dbo.ApplicantSubmission
					SET    RecordStatus = '9'
				    WHERE  ApplicantNo = '#ApplicantNoFrom#'
		  
				</cfquery>
				
				</cftransaction>
			 
			 </cfif>
		
	</cffunction>
	
	<cffunction
	    name 	    = "SyncApplicantBackground"
	    description = "Copies over ApplicantReviewBackground, ApplicantBackGroundField in case a new record was received from Inspira with the same reference recordid"
	    displayName = "SyncApplicantBackground"
	    returnType  = "string">
					
						<cfargument name="PersonNo"      required="yes" type="string">
			
			<cfquery name="get" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT    ApplicantNo, ExperienceId, RecordId,
				                          (SELECT     COUNT(RecordId)
				                            FROM      ApplicantBackground
				                            WHERE     RecordId = B.RecordId) AS Other
				FROM      ApplicantBackground AS B
				WHERE     Status = '9' 
				AND       ApplicantNo IN (SELECT ApplicantNo FROM ApplicantSubmission WHERE PersonNo = '#PersonNo#') 
				AND       EXISTS (SELECT  'X' AS Expr1
				                  FROM    ApplicantBackgroundField AS Z
				                  WHERE   ApplicantNo = B.ApplicantNo 
								  AND     ExperienceId = B.ExperienceId)
				GROUP BY  ApplicantNo, ExperienceId, RecordId
				HAVING    (SELECT COUNT(RecordId)
				           FROM   ApplicantBackground 
				           WHERE  RecordId = B.RecordId) > 1
			
			</cfquery>		
			
			<cftransaction>
			
			<!--- loop through a list of background records that were overwritten --->
			
			<cfloop query="get">
			
				<!--- check on the associated review actions --->
				
				<cfquery name="checkreview" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					SELECT    *
					FROM      ApplicantReviewBackground
					WHERE     ExperienceId = '#ExperienceId#'				
				
				</cfquery>		
				
				<cfloop query="checkreview">
				
					<!--- get related background records --->
				
					<cfquery name="getBackground" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">						
						SELECT    ExperienceId
						FROM      ApplicantBackground B
						WHERE     ApplicantNo = '#get.ApplicantNo#' 
						AND       RecordId    = '#get.RecordId#'
						AND       ExperienceId NOT IN (SELECT ExperienceId 
						                               FROM   ApplicantReviewBackground
													   WHERE  PersonNo = '#PersonNo#'
													   AND    ReviewId = '#ReviewId#')   
						
						AND       Status != '9'				
					</cfquery>		
					
					<cfloop query="getBackground">
					
						<!--- inherit the related background to the review action --->
					
						<cfquery name="insert" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">						
							
							INSERT INTO ApplicantReviewBackground

									(PersonNo,ReviewId,ExperienceId)
								 
							VALUES ('#checkreview.PersonNo#',
									'#checkreview.reviewid#',
									'#experienceid#')						
									
						</cfquery>						
					
					</cfloop>
								
				</cfloop>			  
			
				<!--- check of the associated records has background details --->
						
				<cfquery name="check" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					SELECT    *
					FROM      ApplicantBackgroundField B
					WHERE     ApplicantNo = '#ApplicantNo#' 
					AND       EXISTS (SELECT  'X' AS Expr1
					                  FROM    ApplicantBackground AS Z
					                  WHERE   ApplicantNo = B.ApplicantNo 
									  AND     Status != '9'
									  AND     RecordId = '#RecordId#')				
				
				</cfquery>		
			
				<cfif check.recordcount eq "0">
				
					<!--- add records field and owner --->
					
					<cfquery name="target" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   ApplicantBackground
						WHERE  ApplicantNo = '#ApplicantNo#'
						AND    RecordId    = '#RecordId#'
						AND    Status     != '9'
					</cfquery>
					
					<cfloop query="Target">
					
						<cfquery name="insert" 
						 datasource="AppsSelection" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						
							INSERT INTO ApplicantBackgroundField
							
								   (ApplicantNo,
								    ExperienceId,
								    ExperienceFieldId,
								    ExperienceLevel,
								    Remarks,
								    Status,
								    OfficerUserId,
								    OfficerLastName,OfficerFirstName)
							 
							SELECT '#ApplicantNo#',
							       '#ExperienceId#',
								    ExperienceFieldId,
							 	    ExperienceLevel,
								    Remarks,
								    Status,
								    OfficerUserId,OfficerLastName,OfficerFirstName,Created
							 
							FROM    ApplicantBackgroundField
							WHERE   ApplicantNo  = '#get.ApplicantNo#'
							AND     ExperienceId = '#get.ExperienceId#'
							
						</cfquery>
						
						<cfquery name="insert" 
						 datasource="AppsSelection" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						
							INSERT INTO ApplicantBackgroundFieldOwner
							
	 							   (ApplicantNo,
								    ExperienceId,
								    ExperienceFieldId,
									ExperienceLevel,ReviewId
									ActionStatus,
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName)
							 
							SELECT  '#ApplicantNo#',
							        '#ExperienceId#'
							        ExperienceFieldId,
							        ExperienceLevel,
								    ReviewId
							        ActionStatus,
							        OfficerUserId,OfficerLastName,OfficerFirstName
								   
							FROM    ApplicantBackgroundFieldOwner
							WHERE   ApplicantNo  = '#get.ApplicantNo#'
							AND     ExperienceId = '#get.ExperienceId#'
							
						</cfquery>										
					
					</cfloop>			
			
				</cfif>			
			
			</cfloop>  	
			
			</cftransaction>
		
	</cffunction>	

</cfcomponent>			 
