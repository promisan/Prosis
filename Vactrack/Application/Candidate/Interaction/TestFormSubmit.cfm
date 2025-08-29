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
<cf_screentop label="Candidate Test Form" html="No" jquery="Yes" scroll="Yes">

<cfparam name="url.actionsessionid" default="">

<cftransaction>

<cfquery name="getsession" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Organization.dbo.OrganizationObjectActionSession
		WHERE   ActionSessionId = '#url.actionsessionid#'
</cfquery>

<cfquery name="get" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Vacancy.dbo.DocumentCandidateReview
		WHERE   ReviewId = '#getsession.EntityReference#'
</cfquery>

<cfquery name="document" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    Document 
		WHERE   DocumentNo = '#get.documentno#'
</cfquery>

<cfquery name="Topic" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT        TopicId,
	              TopicPhrase, 
	              TopicSubject, 
				  TopicOrder					  
	FROM          Applicant.dbo.FunctionOrganizationTopic T INNER JOIN 
	              Applicant.dbo.FunctionOrganization O ON T.Functionid = O.FunctionId
	WHERE         DocumentNo = '#get.documentno#' 		
	AND           Operational = 1
	ORDER BY      TopicOrder			
</cfquery>
	
<cfloop query="Topic">

	<cfparam name="form.content_#currentrow#" default="">

	<cfquery name="getReviewCompetence" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT * 
			 FROM   DocumentCandidateReviewCompetence
			 WHERE  DocumentNo   = '#get.documentno#'
			 AND    PersonNo     = '#get.personNo#'
			 AND    ActionCode   = '#get.actionCode#'
			 AND    CompetenceId = '#TopicId#'
	</cfquery>
			
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
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  VALUES ('#get.documentno#',		  
					  '#get.personNo#',							 
					  '#get.actionCode#',
					  '#TopicId#',
					  'Topic',						  					  
					  '#session.acc#',
					  '#session.last#',		  
					  '#session.first#')
		</cfquery>	
			
	 </cfif>		

	<cfset val = evaluate("form.content_#currentrow#")>

	<cfif val neq "">
	
		<!--- MAYBE WE WANT TO KEEP A LOG OF THE SUBMISSION ?? --->
		
		<cfquery name="Content" 
			datasource="appsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE     DocumentCandidateReviewCompetence
				SET        CompetenceContent = '#val#'
				WHERE      DocumentNo        = '#get.documentno#' 
				AND        ActionCode        = '#get.actioncode#'	
				AND        PersonNo          = '#get.personno#'	
				AND        CompetenceId      = '#TopicId#'
		 </cfquery>

	</cfif>			

</cfloop>

<cfquery name="setsession" 
	 datasource="appsVacancy" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		UPDATE  Organization.dbo.OrganizationObjectActionSession
		SET     SessionActualEnd = getDate()
		WHERE   ActionSessionId = '#url.actionsessionid#'
</cfquery>

</cftransaction>

<cfoutput>
	<table width="100%" valign="center" align="center">
	<tr class="labelmedium">
		<td align="center" style="font-size:20px;padding-top:140px;color:blue">
		Thank you!<br><br>Your answers were submitted and received. <br>You will shortly receive an eMail with the submitted answers. <br>You may continue updating information until <b>#timeformat(getsession.sessionplanend,"HH:MM")#</b>.
		</td>
	</tr>
	<tr><td align="center" style="padding-top:50px">
		<table class="formspacing">
		<tr><td>	
		<input type="button" name="Submit" value="Continue" class="button10g" 
		    onclick="ptoken.location('#SESSION.root#/Tools/EntityAction/Session/ActionSessionContent.cfm?actionsessionid=#url.actionsessionid#')" style="width:200px;height:35px;font-size:20px">
		</td>
		<td>
		<input type="button" name="Close" value="Close" class="button10g" onclick="window.close()" style="width:200px;height:35px;font-size:20px">
		</td>
		</tr>	
		</table>
	</td></tr>
	</table>
</cfoutput>


