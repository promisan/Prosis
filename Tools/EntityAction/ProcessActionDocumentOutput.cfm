
<cfparam name="url.mode" default="print">
<cfparam name="url.id"   default="">

<cfquery name="Action" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 UPDATE OrganizationObjectAction 		
	 SET    ActionMemo = '#URL.content#' 
	 WHERE  ActionId = '#URL.ID#' 
</cfquery>
	