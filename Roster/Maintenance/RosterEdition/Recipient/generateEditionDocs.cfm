
<cfquery name="language"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   L.* 
	FROM     System.dbo.Ref_SystemLanguage L
	WHERE    L.LanguageCode IN (
					SELECT LanguageCode
					FROM   Ref_SubmissionEditionProfile
					WHERE  SubmissionEdition = '#url.submissionedition#'
					AND    ActionId = '#url.actionid#'
					AND    ActionStatus = '1') <!--- ready to be sent --->
	ORDER BY L.LanguageCode	
</cfquery>

<cfquery name="qOrganization" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT  O.OrgUnit, O.OrgUnitName, O.OrgUnitNameShort
	FROM    Applicant.dbo.Ref_SubmissionEditionOrganization  SEP INNER JOIN
			Organization.dbo.Organization O ON SEP.OrgUnit = O.OrgUnit
	WHERE 	SEP.SubmissionEdition = '#URL.SubmissionEdition#'
	AND     SEP.Operational = 1	
	<!--- Parse and generate documents only if they WILL be sent to this Permanent Mission --->
	AND     EXISTS
	(
		SELECT 'X'
		FROM   Organization.dbo.OrganizationAddress OA 
			   INNER JOIN  System.dbo.Ref_Address A ON A.AddressId = OA.AddressId 
		WHERE  OA.OrgUnit = O.OrgUnit
	)
</cfquery>

<!--- --------------------------------------------------- --->
<!--- --generate the letter for each selected recipient-- --->
<!--- --------------------------------------------------- --->
	
<cfquery name="qDocuments" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT  DISTINCT SEP.TextAreaCode, T.Description
	FROM    Ref_SubmissionEditionProfile SEP INNER JOIN Ref_TextArea T ON SEP.TextAreaCode = T.Code AND T.TextAreaSection != 'Mail' 
	WHERE 	SEP.SubmissionEdition = '#URL.SubmissionEdition#'
	AND     SEP.LanguageCode      = '#language.languagecode#'
	AND     SEP.ActionId = '#url.actionid#'
	AND     SEP.ActionStatus = '1' <!--- ready to be sent ---> 	
</cfquery>	

<cfset step = 0.8/qOrganization.recordcount>

<cfloop query="qOrganization">

	<cfif not DirectoryExists("#SESSION.rootDocumentPath#/Broadcast/#vBroadcastId#/#qOrganization.OrgUnit#")>
	
		<cfdirectory action="CREATE" 
		   directory="#SESSION.rootDocumentPath#/Broadcast/#vBroadcastId#/#qOrganization.OrgUnit#">
		   
	</cfif>  	

	<cfset Session.Message = "Parsing document for " & qOrganization.OrgUnitName>
	<cfset Session.status = Session.status + step>
	
	

	<cfloop query="qDocuments">
		
		<cfloop query="language">		
		
			<cfquery name="qCheck" 
			   datasource="AppsSelection" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				SELECT  EditionNotes
				FROM    Applicant.dbo.Ref_SubmissionEditionProfile  
				WHERE 	SubmissionEdition = '#URL.SubmissionEdition#'
				AND     TextAreaCode      = '#qDocuments.TextAreaCode#'
				AND     LanguageCode      = '#language.languagecode#'
				AND     ActionId          = '#url.actionid#'				
				AND     ActionStatus	  = '1' <!--- ready to be sent --->
			</cfquery>			
			
			<cfif qCheck.recordcount neq 0 and Trim(qCheck.EditionNotes) neq "">
			
			
				<!--- generate for all the state members --->

				<cfset url.orgUnit      = qOrganization.orgUnit>
				<cfset url.orgUnitName  = qOrganization.OrgUnitName>
				<cfset url.OrgUnitNameShort	= qOrganization.OrgUnitNameShort>
				<cfset url.languagecode = language.languagecode>
				<cfset url.lcode        = language.code>
				<cfset url.description  = qDocuments.Description>
				
				<!--- retrieve the text from the database --->				
	 	 		<cfset vtext 			= replace(qCheck.EditionNotes,"script","disable","all")>
		 		<cfset vtext 			= replace(vtext,"iframe","disable","all")>
				
				<!--- we generate the letter  with the content as recorded in the database --->
				<cfinclude template = "../../../../Custom#qEdition.PathPublishText##qDocuments.TextAreaCode#_Letter.cfm">	
					
			</cfif>	
	
		</cfloop>	
		
	</cfloop>

</cfloop>		


<cfset Session.status = 0.9>