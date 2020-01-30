
<cfquery name="Delete" 
	     datasource="appsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM UserAnnotation
		 WHERE Account = '#SESSION.acc#'
		 AND AnnotationId = '#URL.id2#'
</cfquery>

<cfset url.id2 = "">
 <cfinclude template="UserAnnotation.cfm">
