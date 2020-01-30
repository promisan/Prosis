
<cfparam name="url.openas" default="edit">
<cfparam name="url.id"     default="">

<cfquery name="Script" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_EntityDocument
	WHERE      DocumentId = '#url.id#'
</cfquery>

<cfset docPath = replaceNoCase("#SESSION.rootPath#\#script.documenttemplate#","|","\","ALL")> 

<cf_screentop label="Script file" option="path: <b>#script.documenttemplate#</b>" height="100%" scroll="No" layout="webapp" banner="gray">
	
	<cfoutput>
	
		<iframe src="#SESSION.root#/Tools/Document/FileContent.cfm?openas=#url.openas#&mode=edit&path=#docpath#&subdir=&name="
		  width="100%" height="100%" frameborder="0">
	    </iframe>
	
	</cfoutput>

<cf_screenbottom layout="webapp">