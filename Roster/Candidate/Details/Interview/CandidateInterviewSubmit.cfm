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
<cfif Form.DateInterviewStart neq "">
	
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.DateInterviewStart#">
		<cfset STR = #dateValue#>
	
		<cfset ta = DateAdd("h", "#Form.HourInterviewStart#", "#STR#")> 
		<cfset ta = DateAdd("n", "#Form.MinuteInterviewStart#", "#ta#")>
		
		<cfset te = DateAdd("h", "#Form.HourInterviewEnd#", "#STR#")> 
		<cfset te = DateAdd("n", "#Form.MinuteInterviewEnd#", "#te#")>
	
		 <cfquery name="CandidateStatus" 
				datasource="appsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE ApplicantInterview
				SET    InterviewStatus     = '#Form.InterviewStatus#', 
				       InterviewMode       = '#Form.InterviewMode#', 
					   Owner               = '#Form.Owner#',
				       TsInterviewStart    = #ta#,
					   TsInterviewEnd      = #te# 
				WHERE  InterviewId = '#URL.InterviewId#'
		 </cfquery>	
		 
		<cfif Form.InterviewStatus eq "1">	
		
				<cfinvoke component = "Service.RosterStatus"  
				   method           = "RosterSet" 
				   personno         = "#URL.PersonNo#" 
				   owner            = "#Form.Owner#"
				   returnvariable   = "rosterstatus">	
			
			 <!---	moved to method   	
			 <cf_rosterStatus PersonNo= "#URL.PersonNo#" Owner = "#Form.Owner#">		
			 --->
			 
		</cfif>
		 
		 <!--- saving language --->
		 
		<cfquery name="Language" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	* 
			FROM 	Ref_Language
			WHERE 	LanguageClass = 'Official' 
		</cfquery>
		
		<cfloop query="Language">
				
			<cfparam name="Form.Select_#CurrentRow#" default="0">
			<cfset lan = #evaluate("Form.Select_#CurrentRow#")#>
			<cfif #lan# eq "1">
			
			<cfset lanid = "#Language.LanguageId#">
			
			 <cfquery name="Check" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE ApplicantLanguage
				SET 	Status = 1, 
						LevelRead = 1,
						LevelWrite = 1,
						LevelSpeak = 1,
						LevelUnderstand = 1
				FROM ApplicantLanguage A, ApplicantSubmission S
				WHERE S.ApplicantNo = A.ApplicantNo
				AND  S.PersonNo = '#URL.PersonNo#'
				AND  A.Languageid = '#Lanid#' 
			</cfquery>
								
			 <!--- adding language if not exists --->
					
			 <cfquery name="Check" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT ApplicantNo
				FROM ApplicantSubmission S
				WHERE S.PersonNo = '#URL.PersonNo#'  
			 </cfquery>
			 
			 <cfloop query="Check">
			 
			    <cftry>
			  						
				<cfquery name="InsertLanguage" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ApplicantLanguage 
				         (ApplicantNo,
						 LanguageId, 
						 Status,
						 Mothertongue,
						 Proficiency,
						 LevelRead,
						 LevelWrite,
						 LevelSpeak,
						 LevelUnderstand,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				  VALUES ('#Check.ApplicantNo#', 
				          '#LanId#',
						  '1','0','0','1','1','1','1',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
				</cfquery>
				
				<cfcatch></cfcatch>
				
				</cftry>
								
			   </cfloop>	
						
			<cfelse>
			
			 <cfquery name="Check" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE ApplicantLanguage
				SET Status = 0
				FROM ApplicantLanguage A, 
				     ApplicantSubmission S
				WHERE S.ApplicantNo = A.ApplicantNo
				AND  S.PersonNo = '#URL.PersonNo#'
				AND  A.Languageid = '#LanguageId#' 
			</cfquery>
			
			</cfif>
							
		</cfloop>
		
		 <!--- saving notes --->
					
		 <cf_ApplicantTextArea
			Table           = "ApplicantInterviewNotes" 
			Domain          = "#URL.Domain#"
			FieldOutput     = "InterviewNotes"
			Mode            = "save"
			Log             = "Yes"
			Key01           = "InterviewId"
			Key01Value      = "#URL.InterviewId#"
			Attribute01     = "PersonNo"
			Attribute01Value= "#URL.PersonNo#">
		
</cfif>	


<script>
	window.close()
	opener.history.go()
</script>	
