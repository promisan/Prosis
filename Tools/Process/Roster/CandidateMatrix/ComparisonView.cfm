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

<!--- ability to show candidates side by side --->

<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT PHPSource
  	FROM   Parameter
</cfquery>

<cfparam name="Attributes.HideTitle"          default="No">
<cfparam name="Attributes.HidePerson"         default="No">
<cfparam name="Attributes.HideLanguage"       default="No">
<cfparam name="Attributes.HideEducation"      default="No">
<cfparam name="Attributes.HideDetails"        default="No">
<cfparam name="Attributes.HideTopics"         default="Yes">
<cfparam name="Attributes.HideExperience"     default="No">
<cfparam name="Attributes.IDFunction"         default="">

<cfparam name="Attributes.Height"             default="400">
<cfparam name="Attributes.Attachment"         default="No">
<cfparam name="Attributes.DocumentNo"         default="">
<cfparam name="Attributes.ApplicantNo"        default="">
<cfparam name="Attributes.PersonNo"	          default="">
<cfparam name="Attributes.Owner"	          default="">
<cfparam name="Attributes.Source"	          default="">
<cfparam name="Attributes.RosterActionNo"     default="">
<cfparam name="Attributes.Layout"         	  default="Horizontal">
<cfparam name="Attributes.ExperienceStatus"   default="'0','1'">
<cfparam name="Attributes.ExperienceReviewed" default="No">

<!--- added by hanno 20/10/2021 to ensure in case of same submission record per same source no duplicated --->
<cfif attributes.applicantno neq "">
	<cfset ComparisonApplicantNo = attributes.applicantno>
</cfif>

<cf_dialogMail>

<!--- document also retrieves the bucket and requirements --->


<cfif attributes.applicantno neq "">

		<cfquery name="getCandidates" 
		     datasource="AppsSelection" 
		  	 username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   A.*, S.SubmissionEdition, S.Source AS SSource, S.SubmissionId
			 FROM     ApplicantSubmission S, Applicant.dbo.Applicant A
			 WHERE    S.PersonNo = A.PersonNo
			 AND      S.ApplicantNo = '#attributes.applicantno#'		 
		</cfquery>	
		
								
<cfelseif attributes.personNo neq "" and attributes.source neq "">		

	<cfquery name="getCandidates" 
	     datasource="AppsSelection" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   A.*, S.ApplicantNo, S.SubmissionEdition, S.Source AS SSource, S.SubmissionId
		 FROM     ApplicantSubmission S, Applicant.dbo.Applicant A
		 WHERE    S.PersonNo = A.PersonNo
		 AND      S.PersonNo = '#attributes.PersonNo#'		 
		 AND      S.Source   = '#attributes.Source#'
		 ORDER BY Created DESC
	</cfquery>	
			
	<cfset attributes.applicantNo = getCandidates.applicantNo>
		
<cfelseif attributes.personNo neq "" and attributes.owner neq "">	
	
	<!--- check if we have a default for this owner --->
	
	<cfquery name="PHPSource" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	  	SELECT DefaultPHPSource
	  	FROM   Ref_ParameterOwner
		WHERE  Owner = '#attributes.Owner#' 
	</cfquery>
	
	<cfif PHPSource.DefaultPHPSource neq "">		
		<cfset ssource = PHPSource.DefaultPHPSource>			
	<cfelse>		
		<cfset ssource = Parameter.PHPSource>	
	</cfif>
		
	<!--- you can have several so we take only the last one --->
		
	<cfquery name="getCandidates" 
	     datasource="AppsSelection" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   TOP 1 A.*, S.ApplicantNo, S.SubmissionEdition, S.Source AS SSource, S.SubmissionId
		 FROM     ApplicantSubmission S, Applicant.dbo.Applicant A
		 WHERE    S.PersonNo = A.PersonNo
		 AND      S.PersonNo = '#attributes.PersonNo#'		 
		 AND      S.Source   = '#SSource#' 
		 ORDER BY Created DESC
	</cfquery>	
	
	<cfif getCandidates.recordcount eq "0">
	
		<cfquery name="getCandidates" 
		     datasource="AppsSelection" 
		  	 username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   TOP 1 A.*, S.ApplicantNo, S.SubmissionEdition, S.Source AS SSource, S.SubmissionId
			 FROM     ApplicantSubmission S, Applicant.dbo.Applicant A
			 WHERE    S.PersonNo = A.PersonNo
			 AND      S.PersonNo = '#attributes.PersonNo#'		 		  
			 ORDER BY Created DESC
		</cfquery>	
		
	</cfif> 
				
	<cfset attributes.applicantNo = getCandidates.applicantNo>	
	
	
<cfelseif attributes.personNo neq "" and attributes.owner eq "">

    <!--- you can have several so we take only the last one --->

	<cfquery name="getCandidates" 
	     datasource="AppsSelection" 
	  	 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   TOP 1 A.*, S.ApplicantNo, S.SubmissionEdition, S.Source AS SSource, S.SubmissionId
		 FROM     ApplicantSubmission S, Applicant.dbo.Applicant A
		 WHERE    S.PersonNo = A.PersonNo
		 AND      S.PersonNo = '#attributes.PersonNo#'		 
		 AND      S.Source   = '#Parameter.PHPSource#'
		 ORDER BY Created DESC
	</cfquery>	
	
	<cfset attributes.applicantNo = getCandidates.applicantNo>
	
<cfelse>
	
	<!---	
				
	<cfelseif attributes.documentNo neq "">
		
		<cfquery name="getCandidates" 
		     datasource="AppsVacancy" 
		  	 username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT   A.*
			 FROM     DocumentCandidate DC, Applicant.dbo.Applicant A
			 WHERE    DC.PersonNo = A.PersonNo
			 AND      DC.DocumentNo = '#attributes.documentNo#'
			 AND      DC.Status >= '1'	
		</cfquery>	
		
	--->	
	
	<cfparam name="getCandidates.recordcount" default="0">
	

</cfif>

<cfset applicantNo = attributes.applicantNo>

<cfif getCandidates.recordcount eq "0">

<table style="width:100%;height:100%"><tr class="labelmedium2"><td align="center">No information could be found</td></tr></table>

<cfelse>


	<!--- Hanno we need to define at the minium the source for the edition/languahe --->
		
	<table style="width:100%;height:100%">
	
		<tr><td style="height:100%;padding:6px" align="center">
			
			<table width="100%" height="100%">			
						
				<!--- get the candidates --->
				
				<cfif Attributes.Layout eq "Vertical">
				
					<cfif attributes.documentNo neq "">
						<tr><td class="labelmedium" align="center">						
						<cfinclude template="ComparisonViewBucket.cfm">
						</td></tr>
					</cfif>
					
					<tr>
					<td style="padding:5px" align="center">
					
					<cfif attributes.applicantno neq "">		
						<cfset URL.ID = attributes.applicantno>
						<cfset URL.IDFunction = attributes.IDFunction>
						<cfinclude template="ComparisonViewVertical.cfm"> 
					</cfif>
								
					</td>
					
					</tr>
				
				<cfelse>
				
				    <tr>
					<td style="padding:5px;height:100%" align="center">
					
					<cfif attributes.applicantno neq "">		
						 <cfset URL.IDFunction = attributes.IDFunction>						 
						 <cfinclude template="ComparisonViewHorizontal.cfm"> 
					</cfif>			
					</td>
					
					</tr>
				
					<!--- ---------------- --->
					<!--- work in progress --->
					<!--- ---------------- --->
				
				</cfif>
			
			</table>
		
		</td></tr>
	
	</table>

</cfif>