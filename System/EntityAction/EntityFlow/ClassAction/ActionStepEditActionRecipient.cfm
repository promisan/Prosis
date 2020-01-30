<cf_compression>

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_EntityDocument
	WHERE EntityCode = '#URL.entityCode#'
	AND   DocumentType = 'mail'
	AND   DocumentCode = '#URL.documentCode#'
</cfquery>

<cfset url.documentid = Check.documentid>

<cfif Check.mailto eq "List">
	
	<cfinclude template="../../EntityObject/MailList/MailList.cfm">

</cfif>