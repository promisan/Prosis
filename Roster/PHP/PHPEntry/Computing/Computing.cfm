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
<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes">
	
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT S.PersonNo, S.Source
	FROM   Applicant A, 
	       ApplicantSubmission S
	WHERE  A.PersonNo = S.PersonNo
	AND    S.ApplicantNo = '#URL.ApplicantNo#'
</cfquery>

<cfquery name="Section" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     #CLIENT.LanPrefix#Ref_ApplicantSection
		WHERE    Code = '#URL.Section#' 
</cfquery>

<cfquery name="Check" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT COUNT(*) AS Total
	    FROM   ApplicantBackGround A
	    WHERE  ApplicantNo   = '#URL.ApplicantNo#'
		AND    Status        != '9'
		AND    ExperienceCategory = 'Miscellaneous'
</cfquery>

<cfset url.id    		= Get.PersonNo>
<cfset url.id2   		= "Miscellaneous">
<cfset url.entryScope 	= "Portal">
<cfset url.topic		= url.id2>
<cfset url.source 		= Get.Source>

<cfparam name="URL.Next" default="Default">

<table width="100%" height="100%">
	
	<tr>
		
		<td width="100%" height="100%" style="padding:15px" valign="top">
			<cfdiv id="computingbox">
				<cfinclude template="../../../Candidate/Details/Computing/Computing.cfm">
			</cfdiv>
		</td>
	</tr>
	
	<tr><td class="linedotted"></td></tr>
	<tr>
		<td>
		
		<cfset setNext = 1>
		
		<cfif Section.Obligatory eq 1>
			<cfif Check.recordcount eq 0>
			   <cfset setNext = 0>
			</cfif>
		</cfif>
	
		 <cf_Navigation
			 Alias         = "AppsSelection"
			 TableName     = "ApplicantSubmission"
			 Object        = "Applicant"
			 ObjectId      = "No"
			 Group         = "PHP"
			 Section       = "#URL.Section#"
			 SectionTable  = "Ref_ApplicantSection"
			 Id            = "#URL.ApplicantNo#"
			 BackEnable    = "1"
			 HomeEnable    = "1"
			 ResetEnable   = "0"
			 ResetDelete   = "0"	
			 ProcessEnable = "0"
			 NextEnable    = "1"
			 NextSubmit    = "0"
			 OpenDirect    = "0"
			 SetNext       = "#setNext#"
			 NextMode      = "#setNext#"
			 IconWidth 	  = "48"
			 IconHeight	  = "48">
			 
		</td>
	</tr>
		
</table>