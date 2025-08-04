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

<cfparam name="url.id"  default="">
<cfparam name="url.id1" default="">

<cfif url.id eq "">
	
	<cfquery name="get" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   DocumentCandidate 
			WHERE  CandidateId   = '#URL.Ajaxid#'		
	</cfquery>
	
	<cfset url.id  = get.DocumentNo>
	<cfset url.id1 = get.Personno>

</cfif>
		
	<cfquery name="GetCandidateStatus" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DC.*, b.IndexNo
	    FROM   DocumentCandidate DC left outer join Applicant.dbo.Applicant b
			ON DC.PersonNo = b.PersonNo
		WHERE  DC.PersonNo   = '#URL.ID1#'
		AND    DC.DocumentNo = '#URL.ID#'
	</cfquery>
	
	<cfquery name="GetCandidate" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Applicant
		WHERE  PersonNo = '#URL.ID1#' 
	</cfquery>
	
	<cfquery name="Doc" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Document
		WHERE  DocumentNo = '#URL.ID#'
	</cfquery>
	
	<cfquery name="Position" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Position
		WHERE PositionNo = '#Doc.PositionNo#'
	</cfquery>
	
	<cfquery name="GetObjectClass" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Organization.dbo.OrganizationObject
		WHERE  ObjectKeyValue2  = '#URL.ID1#'
		AND    ObjectKeyValue1  = '#URL.ID#'
	</cfquery>
	
	<cfif GetCandidateStatus.EntityClass neq "">
	
		<cfset wfclass = GetCandidateStatus.EntityClass>
	
	<cfelse>
	
		<cfset wfclass = GetObjectClass.EntityClass>
	
	</cfif>
	
	<cfset link = "Vactrack/Application/Candidate/CandidateEdit.cfm?ID=#URL.ID#&ID1=#URL.ID1#">
			
	   <cfif GetCandidate.Gender eq "M">
	      <cfset Pre = "Mr.">
	   <cfelse>
	      <cfset Pre = "Mrs."> 
	   </cfif>
			   
	   <cfif (GetCandidateStatus.Status eq "2s" 
		       or GetCandidateStatus.Status eq "9" 
			   or GetCandidateStatus.Status eq "3")
		       and wfclass neq "">
			   					
				   <cf_ActionListing TableWidth  = "100%"
					    EntityCode       = "VacCandidate"
						EntityClass      = "#wfclass#"
						EntityGroup      = "#Doc.Owner#"
						EntityStatus     = ""
						Mission          = "#Doc.Mission#"
						OrgUnit          = "#Position.OrgUnitOperational#"
						PersonNo         = "#GetCandidate.PersonNo#"
						ObjectReference  = "#Pre# #GetCandidate.FirstName# #GetCandidate.LastName#"
						ObjectReference2 = "#Doc.Mission#, #Doc.PostGrade# - #Doc.FunctionalTitle#"
						AjaxId           = "#URL.ajaxId#"
						ObjectKey1       = "#URL.ID#"
						ObjectKey2       = "#URL.ID1#"
					  	ObjectURL        = "#link#"
						DocumentStatus   = "#Doc.Status#">
				
		<cfelse>
						
								
				<cfquery name="RevokeTrack" 
				 datasource="AppsVacancy" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 DELETE FROM Organization.dbo.OrganizationObject
					 WHERE  ObjectKeyValue1 = '#URL.ID#' 
					 AND    ObjectKeyValue2 = '#URL.ID1#'
					 AND    EntityCode = 'VacCandidate' 
					 AND    Operational  = 1 
				</cfquery>
		
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td class="labelmedium">						
				
				<b><font color="FF0000">Attention :</font> Workflow class has not been set. <cfoutput>Reference [#GetCandidateStatus.Status#]</cfoutput> Please initiate onboarding again.</b>
				
				<tr><td height="3"></td></tr>
				<tr><td class="linedotted" colspan="12"></td></tr>
				<tr><td height="3"></td></tr>
				
				</td></tr></table>	
				
		</cfif>	
