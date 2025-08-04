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
<!--- saving --->

<cfparam name="url.documentNo"   default="">
<cfparam name="url.personno"     default="">
<cfparam name="url.actionCode"   default="">
<cfparam name="url.competenceid" default="">

<cfif url.personno neq "" and url.competenceid neq "">
	
	<cfquery name="user" 
	     datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   UserNames
			 WHERE  Account = '#url.useraccount#'
			 
	</cfquery>
	
	<cfif url.documentno neq "">
		
		<cfquery name="getReview" 
		     datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   DocumentCandidateReview
			 WHERE  DocumentNo = '#url.documentno#'
			 AND    PersonNo   = '#url.personNo#'
			 AND    ActionCode = '#url.actionCode#'
		</cfquery>
		
		<cfif getReview.recordcount eq "0">
		
			<cfquery name="Insert" 
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO DocumentCandidateReview
						 (DocumentNo,
						  PersonNo,		  
						  ActionCode,							 
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#url.documentno#',		  
						  '#url.personNo#',							 
						  '#url.actionCode#',
						  '#user.account#',
						  '#user.lastname#',		  
						  '#user.firstname#')
			</cfquery>	
		
		</cfif>
		
		<cfquery name="getReviewCompetence" 
		     datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   DocumentCandidateReviewCompetence
			 WHERE  DocumentNo   = '#url.documentno#'
			 AND    PersonNo     = '#url.personNo#'
			 AND    ActionCode   = '#url.actionCode#'
			 AND    CompetenceId = '#url.CompetenceId#'
			 
		</cfquery>
		
		<cfset content = evaluate("Form.content_#url.itm#")>
		
		<cfif getReviewCompetence.recordcount eq "0">
		
			<cfquery name="Insert" 
				datasource="AppsVacancy" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO DocumentCandidateReviewCompetence
						 (DocumentNo,
						  PersonNo,		  
						  ActionCode,	
						  CompetenceId,		
						  CompetenceMode,	
						  CompetenceContent,			 
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				  VALUES ('#url.documentno#',		  
						  '#url.personNo#',							 
						  '#url.actionCode#',
						  '#url.competenceid#',
						  'Topic',
						  '#Content#',						  
						  '#user.account#',
						  '#user.lastname#',		  
						  '#user.firstname#')
			</cfquery>	
			
		<cfelse>
		
			<cfquery name="getReviewCompetence" 
		     datasource="AppsVacancy" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE DocumentCandidateReviewCompetence
				 SET    CompetenceContent = '#content#'
				 WHERE  DocumentNo   = '#url.documentno#'
				 AND    PersonNo     = '#url.personNo#'
				 AND    ActionCode   = '#url.actionCode#'
				 AND    CompetenceId = '#url.CompetenceId#'
		</cfquery>
					
		</cfif>			
		
	</cfif>	
	
</cfif>	
