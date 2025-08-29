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
	
	<cffunction name    = "workexperience" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates work experience tagging" 
		    output      = "true">						

			<cfargument name="validationActionId"        type="string"  default="">
		    <cfargument name="objectKeyValue1"           type="string"  default="">
		    <cfargument name="objectKeyValue2"           type="string"  default="">
		    <cfargument name="objectKeyValue3"           type="string"  default="">
		   	<cfargument name="Target"          		     type="string"  default="">			 
			 
			<cfquery name="Check" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   ApplicantBackground AB
					WHERE  ApplicantNo = '#objectKeyValue1#'
					AND    ExperienceCategory = 'Employment' 
					AND NOT EXISTS (
						SELECT 'X' FROM ApplicantBackgroundField ABF INNER JOIN Ref_Experience E ON
								ABF.ExperienceFieldId = E.ExperienceFieldId INNER JOIN Ref_ExperienceClass EC ON
									E.ExperienceClass = EC.ExperienceClass
						WHERE AB.ExperienceId = ABF.ExperienceId
						AND  ABF.Status = 1
						AND  E.ExperienceClass IN (SELECT ExperienceClass
												   FROM   Ref_ExperienceClassOwner
												   WHERE  Owner ='#objectKeyValue3#')
						AND     EC.Candidate = 1 
						AND     EC.Parent = 'Experience'
					)
					AND     EXISTS
						(
							SELECT 'X' FROM ApplicantReviewBackground ARB 
							WHERE ARB.ExperienceId = AB.ExperienceId							
						)
 			</cfquery>			 
 			
			<cfif Check.recordcount neq 0>
			
				<cf_tl id="Work Experience" var="qLabel">	
				
				<cfset result.label        = "#qLabel#">
				<cfset result.name         = "WorkExperience">
				<cfset result.pass         = "No">

				<cfquery name="qApplicantSection" 
					datasource="appsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT Code
					FROM   Ref_ApplicantSection
					WHERE  TemplateTopicId = 'work'
				</cfquery>	

				<cfset h = 2>
				
				<cfsavecontent variable="memo">
    				<table width="100%" height="100%">
    					<tr><td class="labelit"><cf_tl id="Please tag your work experience">:
    					</td></tr>
						<cfloop query="Check">				
							<tr><td style="padding-left:7px">
																				
									<cfset vExperienceDescription =  Check.ExperienceDescription>
									<cfif len(vExperienceDescription) gt 35>
										<cfset h=h+1>
									</cfif>	
									
									<table>
									<tr class="labelit">
									<td>-</td>
									<td style="padding-left:5px">
										<a href="javascript:void(0);" 
										onclick="processvalidation('#validationactionid#','/Roster/Candidate/Details/Background/BackgroundEntry.cfm?owner=#objectKeyValue3#|id=#ExperienceId#');"><font color="0080C0">#vExperienceDescription#</font></a>
									</td>
									</tr>
									</table>
								
								</td>
							</tr>
							<cfset h = h + 2 >
						</cfloop>
    					
    				</table>	
				</cfsavecontent>
				
				<cfset result.passmemo     = memo>
				<cfset result.height       = h * 11 >
			<cfelse>
				<cfset result.label        = "Label">
				<cfset result.name         = "Reminder">
				<cfset result.pass         = "Ok">
				<cfset result.passmemo     = "This is reminder/action">				
			</cfif>
			
			<cfreturn result>				 	   						 				
	
	
	</cffunction>	


	<cffunction name    = "documents" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates the name of a candidate" 
		    output      = "true">	
					
			 <cfargument name="validationActionId"        type="string"  default="">
			 <cfargument name="objectKeyValue1"           type="string"  default="">
			 <cfargument name="objectKeyValue2"           type="string"  default="">
			 <cfargument name="objectKeyValue3"           type="string"  default="">
			 <cfargument name="Target"          		  type="string"  default="">
			 
			<cfquery name="qCheck" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
    				SELECT  DocumentType, Description
    				FROM    Employee.dbo.Ref_DocumentType T
    				WHERE   DocumentUsage in ('2','3')
    				AND NOT EXISTS
    				(
						SELECT 'X'
						FROM   ApplicantDocument
		   				WHERE  PersonNo = '#objectKeyValue2#'
		   				AND DocumentType = T.DocumentType
    				)
 			</cfquery>			 		 
						
			<cfif qCheck.recordcount neq 0>
				
				<cfquery name="qApplicantSection" 
					datasource="appsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT Code
					FROM   Ref_ApplicantSection
					WHERE  TemplateTopicId='documents'
				</cfquery>			
				
				<cf_tl id="Documents" var="qLabel">	
				
				<cfset result.label        = "#qLabel#">
				<cfset result.name         = "document">
				<cfset result.pass         = "No">
				
				<cfset h = 1>
				 
				<cfsavecontent variable="memo">
    				<table width="100%" height="100%">
    					<tr><td class="labelit"><cf_tl id="Please add the following">:</td></tr>
						<cfloop query="qCheck">				
							<tr><td class="labelit" style="padding-top:4px">									
									<table>
									<tr>
									<td>-</td>
									<td style="padding-left:5px;height:20px" class="labelmedium">
										<a href="javascript:void(0);" 
										onclick="processvalidation('#validationactionid#','/Roster/Candidate/Details/Document/DocumentEntry.cfm?owner=#objectKeyValue3#|applicantNo=#objectKeyValue1#|ID=#objectKeyValue2#|Section=#qApplicantSection.Code#|DocumentType=#qCheck.DocumentType#');"><font color="0080C0">#qCheck.Description#</font></a>
									</td>
									</tr>
									</table>									
								</td>
							</tr>
							<cfset h = h + 3>
						</cfloop>
    					
    				</table>	
				</cfsavecontent>
				
				<cfset result.passmemo     = memo>
				<cfset result.height       = h * 9 >
				
			<cfelse>
				<cfset result.label        = "Label">
				<cfset result.name         = "document">
				<cfset result.pass         = "Ok">
				<cfset result.passmemo     = "All good">				
			</cfif>
			
			<cfreturn result>	
	
	</cffunction>	

	<cffunction name    = "miscellaneous" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates miscellaneous information from the candidate" 
		    output      = "true">						

			 <cfargument name="objectKeyValue1"  type="string"  default="">
			 <cfargument name="objectKeyValue2"  type="string"  default="">
			 <cfargument name="Target"           type="string"  default="">
			 
			<cfquery name="Check" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT O.* 
				FROM Ref_TopicOwner O INNER JOIN Ref_Topic T ON T.Topic  = O.Topic
				WHERE EXISTS
				(
					SELECT 'x'
					FROM Ref_TopicList L
					WHERE L.Code = O.Topic
				)
				AND EXISTS 
				(
					SELECT 'X' from ApplicantSubmissionTopic
					WHERE Topic = O.Topic
					AND ApplicantNo = '#Arguments.objectKeyValue1#' 
				)
				AND O.Owner = 'EAD'
				AND T.Parent = 'Miscellaneous'
 			</cfquery>			 	
 			
						
			<cfif Check.recordcount eq 0>
				
				<cfset result.label        = "Sub-specialties">
				<cfset result.name         = "subspecialties">
				<cfset result.pass         = "No">
				
				<cfset h = 1>
				 
				<cfsavecontent variable="memo">
    				<table width='100%' height='100%'>
    					<tr><td class="labelit">Please note that you are missing sub-specialties</td></tr>
    				</table>	
				</cfsavecontent>
				
				<cfset result.passmemo     = memo>
				<cfset result.height       = h * 9 >
				
			<cfelse>
				<cfset result.label        = "Label">
				<cfset result.name         = "subspecialties">
				<cfset result.pass         = "Ok">
				<cfset result.passmemo     = "All good">				
			</cfif>
			
			<cfreturn result>			 
			 	   						 				
	
	
	</cffunction>


	
	<cffunction name    = "BackgroundCheck" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates the name of a candidate" 
		    output      = "true">	
					

			 <cfargument name="objectKeyValue1"           type="string"  default="">
			 
			<cfquery name="Check" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT COUNT(*) AS Total
					FROM   ApplicantBackground
		   			WHERE  ApplicantNo = '#objectKeyValue1#'
					AND    Status != '9'
 			</cfquery>			 		 
						
			<cfif Check.Total eq 0>
				<cfset result.label        = "Label">
				<cfset result.name         = "You have not record any background">
				<cfset result.pass         = "No">
				<cfset result.passmemo     = "This is reminder/action">
			<cfelse>
				<cfset result.label        = "Label">
				<cfset result.name         = "Your work experience is completed">
				<cfset result.pass         = "Ok">
				<cfset result.passmemo     = "This is reminder/action">				
			</cfif>
			
			<cfreturn result>			 
			 	   						 				
	
	
	</cffunction>	 	
	
	<cffunction name    = "ApplicantName" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates the name of a candidate" 
		    output      = "true">	
					
			 <cfargument name="SystemFunctionId"   type="string"  default="">	
			 <cfargument name="Owner"              type="string"  default="Attachment">	
			 <cfargument name="PersonNo"           type="string"  default="">		 
						
			<cfset result.label        = "Label">
			<cfset result.name         = "Name">
			<cfset result.pass         = "No">
			<cfset result.passmemo     = "This is reminder/action">
			
			<cfreturn result>			 
			 	   						 				
	</cffunction>	 	
		
	<cffunction name    = "ApplicantDOB" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates the name of a candidate" 
		    output      = "true">	
					
			 <cfargument name="SystemFunctionId"   type="string"  default="">	
			 <cfargument name="Owner"              type="string"  default="Attachment">	
			 <cfargument name="PersonNo"           type="string"  default="">		 
			
			<cfset result.label        = "Label">
			<cfset result.name         = "Name">
			<cfset result.pass         = "No">
			<cfset result.passmemo     = "This is reminder/action">
			
			<cfreturn result>		
			 	   
						
						 				
	</cffunction>	 	
	
	
	
	
	
	
	
					
		
</cfcomponent>	
