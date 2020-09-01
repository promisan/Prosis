
 	<cfif URL.PublishNo eq "">
		<cfset tbl = "Ref_EntityClassAction">
	<cfelse>
		<cfset tbl = "Ref_EntityActionPublish">
	</cfif>
	
	
	<cfif len(Form.ActionSpecification) gt 8000>
	 <cfset spec = left(Form.ActionSpecification,8000)>
	<cfelse>
	 <cfset spec = Form.ActionSpecification>
	</cfif>
		
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE #tbl#
	SET    ActionSpecification  = '#spec#'
	WHERE  ActionCode = '#URL.ActionCode#'
	 <cfif #tbl# eq "Ref_EntityActionPublish">
	       AND ActionPublishNo = '#URL.PublishNo#'
		 <cfelse>
		   AND EntityCode  = '#URL.EntityCode#' 
		   AND EntityClass = '#URL.EntityClass#'  
		 </cfif>
	 </cfquery>
	 
	 <!--- sync for all --->
	 	 
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_EntityClassAction
		SET ActionSpecification  = '#spec#'
		WHERE ActionCode         = '#URL.ActionCode#'
		AND (ActionSpecification is NULL)
	</cfquery>
	
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_EntityActionPublish
		SET ActionSpecification   = '#spec#'
		WHERE ActionCode          = '#URL.ActionCode#'
		AND (ActionSpecification is NULL)
	</cfquery>
	
	
	<cfinclude template="ActionStepMemo.cfm">