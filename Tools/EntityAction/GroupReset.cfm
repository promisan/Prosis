
<cfparam name="URL.EntityGroupNew" default="">
	
<cfquery name="doc" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE OrganizationObject 
	 SET EntityGroup = '#URL.EntityGroupNew#'
	 WHERE ObjectId = '#URL.ObjectID#'		
</cfquery>
	