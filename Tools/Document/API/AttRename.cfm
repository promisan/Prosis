<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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