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
