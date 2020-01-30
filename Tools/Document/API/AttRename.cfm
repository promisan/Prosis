
<cfparam name="attributes.select" default="/Applicant/"> 

<!--- defines the new value for the attachment --->
<cfparam name="attributes.filter" default="sysadmin"> 

<cfquery name="System" 
		datasource="AppsInit" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM      Parameter		
		WHERE HostName = '#CGI.HTTP_HOST#' 
</cfquery>

<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM         stAttachment
		WHERE     (FileAction = 'Save') 
		AND (ServerPath LIKE '%#attributes.select#%')
		AND FileName NOT LIKE '#attributes.filter#_%'
		
		<!---
		AND OfficerUserId IN ('dpanyim3','dpknymb77','eadnybk77','eadnybov77','eadnymm77')
		--->
</cfquery>

<cfoutput query="Check">

  <cfset srv    = replaceNoCase(System.DocumentRootPath,"\document","")>
  <cfset path   = replaceNoCase(ServerPath,  "/", "\" ,"ALL")> 
    
  <cfif FileExists("#srv#\#path##FileName#")>
  
	  <cffile 
	  	action="RENAME" 
		source="#srv#\#path#\#FileName#" 
	    destination="#attributes.filter##FileName#">
	 
	  <cfquery name="Update" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE   stAttachment
			SET      FileName = '#attributes.filter##FileName#'
			WHERE    AttachmentNo = #AttachmentNo#
	  </cfquery>
	  #currentrow#
	  <cfflush>
	  
  <cfelse>
  
      <!--- be carefull here
  	   <cfquery name="Delete" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM stAttachment			
			WHERE    AttachmentNo = #AttachmentNo#
	  </cfquery>
	  --->
	  #currentrow#
	  <cfflush>
  
  </cfif>

</cfoutput>		