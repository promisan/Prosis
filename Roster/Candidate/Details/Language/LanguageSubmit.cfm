
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.MotherTongue" default="0">
<cfparam name="Form.Proficiency"  default="0">
<cfparam name="url.entryScope"    default="Backoffice">

<cfif URL.ID4 eq ""> 

	<cfinclude template="../SubmissionSubmit.cfm">

<cfelse>

 <cfquery name="Verify" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT ApplicantNo
		 FROM   ApplicantLanguage
		 WHERE  LanguageId   = '#URL.ID4#'
		 AND    ApplicantNo  = '#URL.ID3#'
	</cfquery>	
	<cfset appno = Verify.ApplicantNo>

</cfif>
 
<!--- edit background --->

<cfif Form.select eq "">

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
  VALUES ('#appNo#', 
          '#Form.Language#',
		  '0',
		  '#Form.Mothertongue#',
		  '#Form.Proficiency#',
		  '#Form.LevelRead#',
		  '#Form.LevelWrite#',
		  '#Form.LevelSpeak#',
		  '#Form.LevelUnderstand#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')
</cfquery>

<cfelse>

<cfquery name="InsertLanguage" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE    ApplicantLanguage
SET       MotherTongue      = '#Form.MotherTongue#',
		  Proficiency       = '#Form.Proficiency#',
		  LevelRead         = '#Form.LevelRead#', 
		  LevelWrite        = '#Form.LevelWrite#', 
		  LevelSpeak        = '#Form.LevelSpeak#', 
		  LevelUnderstand   = '#Form.LevelUnderstand#'
WHERE    ApplicantNo = '#AppNo#'
AND      LanguageId = '#URL.ID4#'  
</cfquery>

</cfif>

<!---

<cfif url.entryScope eq "Backoffice">

	<cflocation url="../General.cfm?source=#url.source#&ID=#PersonNo#&ID2=#URL.ID2#&Topic=#URL.Topic#" addtoken="No">		  
	
<cfelseif url.entryScope eq "Portal">

--->
	
	<cfquery name="get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ApplicantSubmission
		WHERE  ApplicantNo = '#appno#'
	</cfquery>
		
	<cfparam name="url.applicantno" default="0">
	<cfparam name="url.section" default="">
	<cfset url.source = get.Source>
	<cfset url.id = personno>
	<cfset url.id4 = "">
		
    <cfinclude template="Language.cfm">

<!---	
</cfif>
--->


