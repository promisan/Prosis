<cfparam name="URL.Path" default="">
<cfparam name="URL.FileName" default="">


<cfquery name="GetText" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT top 1 *
    FROM ClassFunctionTemplate
	WHERE PathName = '#URL.Path#' and FileName='#URL.Filename#'
	
</cfquery>

<cfif #GetText.recordcount# neq "0">
	<cfoutput>#trim(GetText.TemplateFunction)#</cfoutput>
</cfif>

