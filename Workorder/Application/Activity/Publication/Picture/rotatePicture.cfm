<cfquery name="att" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Attachment
		WHERE	AttachmentId = '#url.attachmentId#'
</cfquery>	

<cfset vFilePath = "#session.rootdocumentpath#/#att.serverPath#/#att.filename#">
<cfset vFilePath = trim(vFilePath)>
<cfset vFilePath = replace(vFilePath,"/","\","ALL")>

<cfimage 
    action = "rotate"
    angle  = "90"
    source = "#vFilePath#" 
	destination = "#vFilePath#"
	overwrite = "yes">
	
<cfif url.PublicationActionId neq "">

	<cfquery name="attpub" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	Attachment
			WHERE	AttachmentId = '#url.PublicationActionId#'
	</cfquery>
	
	<cfif attpub.recordCount gt 0>
	
		<cfset vFilePath = "#session.rootdocumentpath#/#attpub.serverPath#/#attpub.filename#">
		<cfset vFilePath = trim(vFilePath)>
		<cfset vFilePath = replace(vFilePath,"/","\","ALL")>
		
		<cfimage 
		    action = "rotate"
		    angle  = "90"
		    source = "#vFilePath#" 
			destination = "#vFilePath#"
			overwrite = "yes">
	
	</cfif>

</cfif>

<cf_tl id="Click to enlarge" var="vView">
<cfoutput>
	<img src="#session.rootdocument#/#att.serverPath#/#att.filename#?ts=#now()#" 
		style="max-width:300px; height:auto; cursor:pointer;" 
		title="#vView#" 
		onclick="viewPicture('#url.attachmentId#')">
</cfoutput>