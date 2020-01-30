
<cf_param name="url.openas" default="view" type="string">
<cf_param name="url.mode" default="" type="string">
<cf_param name="url.id" default="" type="string">

<cfquery name="Att" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT    TOP 1 *
		 FROM      Attachment
		 WHERE     AttachmentId = '#url.id#'		
</cfquery>

<!--- cutt path --->
<cfif left(att.serverpath,9) eq "document/"> 
   <cfset path = mid(att.serverpath,10,len(att.serverpath))>
<cfelse>
  <cfset path = att.serverpath>   
</cfif>

<cfset docPath = replace(path,"/","\","ALL")>
<cfset docPath = replace(docPath,"|","\","ALL")> 
<cfset docPath = replace(docPath,"\\","\","ALL")> 

<cfset label = "#docpath#\#att.filename#">
<cfset label = replaceNoCase(label,"\\","\","ALL")> 

<cf_screentop label="Edit #label#" height="100%" scroll="No" layout="webapp" banner="yellow">

<cfoutput>

	<iframe src="FileEditContent.cfm?openas=#url.openas#&mode=#url.mode#&id=#url.id#"
	  width="100%" height="100%" frameborder="0">
	</iframe>

</cfoutput>

<cf_screenbottom layout="webapp">