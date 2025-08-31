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
<cf_dialogmail>

<cf_screentop height="100%" scroll="no" html="No" jQuery="Yes">

<cf_param name="url.ApplicantNo" default="" 	type="String">	
<cf_param name="url.section" 	 default="" 	type="String">	
<cf_param name="url.code" 		 default="" 	type="String">	
<cf_param name="url.mission"	 default="" 	type="String">	
<cf_param name="url.owner"		 default="" 	type="String">	
<cf_param name="url.topic"		 default="" 	type="String">	

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

<cfinclude template="../NavigationCheck.cfm">

<cfset url.id = Get.PersonNo>

<cfif Section.Description eq "Work">
	<cfset url.id2 = "Employment">
<cfelse>
	<cfset url.id2 = "">	
</cfif>

<cfset url.entryScope  = "Portal">
<cfset url.source      = Get.Source>
<cfset url.topic       = url.id2>

<cfif Section.Obligatory eq "1">
	
	<cfquery name="Check" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
			SELECT COUNT(*) AS Total
			FROM   ApplicantBackground
   			WHERE  ApplicantNo = '#URL.ApplicantNo#'
			AND    Status != '9'
			AND    ExperienceCategory = '#URL.ID2#' 
		
	</cfquery>
	
</cfif>

<cfparam name="URL.Next" default="Default">


<table width="94%" height="100%" align="center">

	<tr><td height="10"></td></tr>
	
	<tr><td colspan="2" style="padding-left:14px"><cf_navigation_header1 toggle="Yes"></td></tr>	
	
	<tr>
		
		<td height="100%" width="100%" valign="top" style="padding-left:25px;padding-right:10px">
			
			<cf_divscroll id="backgroundbox">					
				<cfinclude template="../../../Candidate/Details/Background/Background.cfm">
			</cf_divscroll>
			
		</td>
	</tr>
	
	<tr><td class="linedotted"></td></tr>
	
	<tr>
		<td align="center" width="100%" style="height:35;padding-top:0px;">
			
			<cfinclude template="../NavigationSet.cfm">

			 <cf_Navigation
				 Alias         = "AppsSelection"
				 TableName     = "ApplicantSubmission"
				 Object        = "Applicant"
				 ObjectId      = "No"
				 Group         = "PHP"
				 Section       = "#URL.Section#"
				 SectionTable  = "Ref_ApplicantSection"
				 Id            = "#URL.ApplicantNo#"
				 BackEnable    = "#BackEnable#"
				 HomeEnable    = "0"
				 ResetEnable   = "0"
				 ResetDelete   = "0"	
				 ProcessEnable = "0"
				 NextEnable    = "#NextEnable#"
				 NextSubmit    = "0"
				 OpenDirect    = "0"
				 SetNext       = "#setNext#"
				 NextMode      = "#setNext#"
				 IconWidth 	  = "32"
				 IconHeight	  = "32">
			 
		</td>
	</tr>
		
</table>