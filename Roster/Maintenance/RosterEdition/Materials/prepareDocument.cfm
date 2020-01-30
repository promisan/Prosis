
<!--- Retrieve the languages enabled for the interface (same as FT and JO) --->
<cfquery name="language"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  * 
	FROM    System.dbo.Ref_SystemLanguage
	WHERE 	LanguageCode!=''
	AND     Operational > 0
	ORDER   BY LanguageCode	
</cfquery>

<!----- Getting default values ----->
<cfquery name="qEdition"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ExerciseClass EX INNER JOIN Ref_SubmissionEdition S ON EX.ExcerciseClass = S.ExerciseClass
	WHERE   S.SubmissionEdition = '#url.submissionedition#'
</cfquery>


<cfif qEdition.PathPublishText neq "">
 
	<cfinclude template="../../../../Custom#qEdition.PathPublishText#EditionVerification.cfm">
					
	<cfif response neq "">
	    <cfoutput>
		<font color="FF0000">
			#response# <br> <br>
			Please go back to exercise positions and correct this problem.
		</font>
		</cfoutput>
		<cfabort>
	</cfif>			

</cfif>

<cfquery name="qJOs"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   Reference, COUNT(Reference) AS NoPosts
	FROM     Applicant.dbo.Ref_SubmissionEditionPosition
	WHERE    SubmissionEdition = '#url.submissionedition#'
	AND      RecordStatus = '1'
	AND      PublishMode  = '1'
	AND      Reference IS NOT NULL
	AND      Reference != ''
	GROUP BY Reference
</cfquery>

<!--- ------------------------------------------ --->
<!--- ---1. generate the content of the JO's---- --->
<!--- ------------------------------------------ --->

<cfset step = 1/(language.RecordCount * qJOs.RecordCount)-0.001>

<cfloop query="language">
	
	<cfset url.languagecode = language.languagecode>
	<cfset url.lcode        = language.code>

	<cfset strFileToZip=""> 	
	
	<cfif DirectoryExists("#SESSION.rootDocumentPath#/RosterEdition/#URL.SubmissionEdition#") eq "No">

		<cfdirectory 
		    directory = "#SESSION.rootDocumentPath#/RosterEdition/#URL.SubmissionEdition#"
			action 	  = "create"
	    	name 	  = "createDirectory">
	
	</cfif>

	
	<!--- generate content --->
	
	<cfinclude template="JobPosition.cfm">

	<cfset Session.message = "Generating #Language.LanguageName# package.">
	
	<cfif strFileToZip neq "">
	
			<cf_zip filelist     = "#strFileToZip#" 
				recursedirectory = "No" 
				savepath         = "No"
				output           = "#SESSION.rootDocumentPath#/RosterEdition/#URL.SubmissionEdition#/JO-#URL.lcode#.zip">	
				
	</cfif>	
	
	<!--- now we can remove it --->
	
	<cfif FileExists("#SESSION.rootDocumentPath#/RosterEdition/#URL.SubmissionEdition#/JO-#URL.lcode#.zip")>
		<cfloop list="#strFileToZip#" index="vFile">			
			<cfif fileexists(vFile)>
				<cffile action="delete" file="#vFile#">				
			</cfif>
		</cfloop>			
	</cfif>		
		
	<cfquery name="clear" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	DELETE FROM System.dbo.Attachment
		WHERE  ServerPath = 'RosterEdition/#url.submissionedition#/' 
		AND    FileName = 'JO-#URL.lcode#.zip'		
	</cfquery>	
	
	<!---
		
	<cfquery name="Attachment" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	INSERT INTO System.dbo.Attachment
			    (Server, 
				 ServerPath, 
				 FileName, 
				 FileStatus, 
				 Reference, 
				 AttachmentMemo,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
		VALUES ('document',
		        'RosterEdition/#url.submissionedition#/',
				'JO-#URL.lcode#.zip',
				'1',
				'#url.submissionedition#',
				'',
				'administrator',
				'Prosis',
				'Administrator')
	</cfquery>
	
	
	--->
		
</cfloop>

<cfset Session.status = 1>

<cfoutput>

	<script>
		ColdFusion.ProgressBar.stop('pBar') ;
		ColdFusion.ProgressBar.hide('pBar') ;
		ColdFusion.navigate('#client.root#/roster/maintenance/rosteredition/Materials/PublishDocument.cfm?submissionedition=#url.submissionedition#','documentscontent')
	</script>
	
</cfoutput>
