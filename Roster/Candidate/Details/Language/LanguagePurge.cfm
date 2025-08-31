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
<cfparam name="url.scope" default="Profile">

<TITLE>Update Experience</TITLE>

<cfquery name="DeleteExperience" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE ApplicantLanguage
	WHERE  LanguageId = '#URL.ID4#'   
	AND    ApplicantNo = '#URL.ID3#'
</cfquery>

<!---
<cfif url.entryScope eq "Backoffice">
	<cflocation url="../General.cfm?ID=#URL.ID#&ID2=#URL.ID2#&Topic=#URL.Topic#&source=#url.source#">		  
<cfelseif url.entryScope eq "Portal">
--->
	
	<cfquery name="get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ApplicantSubmission
		WHERE  ApplicantNo = '#url.id3#'
	</cfquery>
	
	<cfparam name="url.applicantno" default="0">
	<cfparam name="url.section" default="">
	<cfset url.id     = get.personno>
	<cfset url.source = get.Source>
	<cfset url.id4 = "">
	
    <cfinclude template="Language.cfm">

<!--- 		
</cfif>	
--->
