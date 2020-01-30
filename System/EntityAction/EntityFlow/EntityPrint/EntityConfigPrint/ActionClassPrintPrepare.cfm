
<cfquery name="Entity" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Entity
	WHERE EntityCode = '#URL.EntityCode#'
</cfquery>

<cfquery name="Class" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClass
	WHERE EntityCode  = '#URL.EntityCode#'
	AND   EntityClass = '#URL.EntityClass#'	
</cfquery>

<cfquery name="Embed" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClass
	WHERE EntityCode = '#URL.EntityCode#'
	AND EmbeddedFlow = '1'
</cfquery>

<cfquery name="Dialog" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND DocumentType = 'Dialog'
	ORDER BY DocumentDescription
	</cfquery>
	
<cfquery name="Mail" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND   DocumentType = 'Mail'
	ORDER BY DocumentDescription
	</cfquery>	
	
<cfquery name="Script" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_EntityDocument
	WHERE EntityCode = '#URL.EntityCode#'
	AND   DocumentType = 'Script'
	ORDER BY DocumentDescription
	</cfquery>			

	