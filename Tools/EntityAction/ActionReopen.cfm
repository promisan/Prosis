
<cfparam name="url.ajaxid" default="">

<cfset ref = replace("#url.ref#","|","&","ALL")>

<cfquery name="Action" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	 SELECT *
	 FROM   OrganizationObjectAction 
	 WHERE  ActionId = '#URL.ID#'
</cfquery>

<cfif Action.recordcount eq "1">
	
	<cfquery name="Object" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   OrganizationObject 
	 WHERE  ObjectId = '#Action.ObjectId#'
	</cfquery>
	
	<cfset key1     = "#Object.ObjectKeyValue1#">
	<cfset key2     = "#Object.ObjectKeyValue2#">
	<cfset key3     = "#Object.ObjectKeyValue3#">
	<cfset key4     = "#Object.ObjectKeyValue4#">
	<cfset ObjectId = "#Object.ObjectId#">
	
	<!--- 1. perform the condition method for this step --->
	
	<!--- read from Ref_Entity and determine of the condition is met --->
	
	<!--- 2. if passed you can reset the step --->
	
	<cfquery name="Reset" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	UPDATE OrganizationObjectAction
		SET    ActionStatus = '0'
		WHERE  ActionId = '#URL.ID#'
	</cfquery>
	
	<cfquery name="Update" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO OrganizationObjectLog
		 (ObjectId,ActionMemo,ActionId,OfficerUserId,OfficerLastName,OfficerFirstName)
		 VALUES
		 ('#ObjectId#','Reopen step','#URL.ID#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')	 
	</cfquery>	
	
	<!--- 3. perform the due methods --->
	
	<cf_ProcessActionMethod
	    methodname       = "Due"
		ObjectId         = "#Object.ObjectId#"
		Location         = "Text"
		actionId         = "#URL.ID#"         
		actioncode       = "#Action.ActionCode#"
		actionpublishno  = "#Action.ActionPublishNo#">												
							
	<cf_ProcessActionMethod
	    methodname       = "Due"
		ObjectId         = "#Object.ObjectId#"
		actionId         = "#URL.ID#" 
		Location         = "File"
		actioncode       = "#Action.ActionCode#"
		actionpublishno  = "#Action.ActionPublishNo#">			
	
	<cfoutput>
	
	<cfif CGI.HTTPS eq "off">
		<cfset tpe = "http">
	<cfelse>	
		<cfset tpe = "https">
	</cfif>
	
	<cfif url.ajaxid eq "">
	
		<script language="JavaScript">
			window.location = "#tpe#://#CGI.HTTP_HOST##ref#"
		</script>
		
	<cfelse>
	
		<script language="JavaScript">	    
		    workflowreload('#url.ajaxid#')		
			try {
			clearInterval ( workflowrefresh_#left(objectid,8)# ) } catch(e) {}
		</script>
	
	</cfif>
		
	</cfoutput>

</cfif>

