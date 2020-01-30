
<cfparam name="URL.EntityClassNew" default="">
<cfparam name="URL.Archive" default="0">
<cfparam name="url.ajaxid" default="">

<cfif CGI.HTTPS eq "off">
	<cfset tpe = "http">
<cfelse>	
	<cfset tpe = "https">
</cfif>

<cftransaction>

<!--- remove also flow for the children  --->

<cfif URL.EntityClassNew neq "">
	
	<!--- retrieve table --->
	
	<cfquery name="doc" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT O.ObjectId, 
	        R.EntityTableName, 
			R.EntityCode, 
			R.EntityClassField,
	        R.EntityKeyField1, O.ObjectKeyValue1, 
			R.EntityKeyField2, O.ObjectKeyValue2, 
			R.EntityKeyField3, O.ObjectKeyValue3, 
	        R.EntityKeyField4, O.ObjectKeyValue4
	 FROM   OrganizationObject O INNER JOIN
	        Ref_Entity R ON O.EntityCode = R.EntityCode
	 WHERE ObjectId = '#URL.ObjectID#'		
	</cfquery>
	
	<!--- update source table --->
	
	<cfif doc.entityClassField neq "">
				
		<cfquery name="Update" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE #doc.EntityTableName#
		 SET    #doc.EntityClassField# = '#URL.EntityClassNew#' 
		 WHERE 1=1 
		 <cfif doc.EntityKeyField1 neq "">
		 AND    #doc.EntityKeyField1# = '#doc.ObjectKeyValue1#'
		 </cfif>
		 <cfif doc.EntityKeyField2 neq "">
		 AND    #doc.EntityKeyField2# = '#doc.ObjectKeyValue2#'
		 </cfif>
		 <cfif doc.EntityKeyField3 neq "">
		 AND    #doc.EntityKeyField3# = '#doc.ObjectKeyValue3#'
		 </cfif>
		 <cfif doc.EntityKeyField4 neq "">
		 AND    #doc.EntityKeyField4# = '#doc.ObjectKeyValue4#'
		 </cfif> 
		</cfquery>		
		
	</cfif>	
			
	<cfquery name="Entity" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Ref_EntityClassPublish S, 
		          Ref_Entity E
		 WHERE    S.EntityCode     = '#Doc.EntityCode#' 
		 AND      S.EntityClass    = '#URL.EntityClassNew#' 		 
		 AND      E.EntityCode = S.EntityCode 
		 ORDER BY DateEffective DESC 
	</cfquery>

	<cfquery name="Update" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE OrganizationObject
	 SET    ActionPublishNo = '#Entity.ActionPublishNo#',
	        EntityClass     = '#URL.EntityClassNew#' 	         
	 WHERE  ObjectId        = '#URL.ObjectId#'
	</cfquery>
				
</cfif>

<cfif url.archive eq "0">
		
	<!--- ---------------------------------------------------------- ---> 
	<!--- 18/1/2008 NEW remove the in the workflow embedded subflows --->
	
	<cfquery name="ClearAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	DELETE FROM OrganizationObject
		WHERE ObjectKeyValue4 IN (SELECT ActionId
		                          FROM   OrganizationObjectAction 
								  WHERE  ObjectId = '#URL.ObjectId#'
								 )				
								 
										  	
	</cfquery>
		
	<cfquery name="get" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT * 
		FROM   OrganizationObject 
		WHERE  ObjectId = '#URL.ObjectId#' 
	</cfquery>
	
	<cfif get.recordcount eq "1">
		
		<cfquery name="Update" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 INSERT INTO OrganizationObjectLog
			 (ObjectId,ActionMemo,OfficerUserId,OfficerLastName,OfficerFirstName)
			 VALUES
			 ('#URL.ObjectId#','Reset','#SESSION.acc#','#SESSION.last#','#SESSION.first#')	 
		</cfquery>	
	
	</cfif>
	
	<!--- remove all action steps --->
	
	<cfquery name="ClearAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	DELETE FROM OrganizationObjectAction 
		WHERE  ObjectId = '#URL.ObjectId#' 
	</cfquery>
	
	<!--- remove action mail 
	
	<cfquery name="ClearAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	DELETE FROM OrganizationObjectActionMail
		WHERE  ObjectId = '#URL.ObjectId#' 
	</cfquery>
	
	--->
	
	<!--- ----------------------------------- --->
	<!--- remove reminder mails from exchange --->
	<!--- ----------------------------------- --->
	
	<cfquery name="getMails" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT * 
		FROM   OrganizationObjectMail
		WHERE  ObjectId = '#URL.ObjectId#' 
		AND    ExchangeId is not NULL
	</cfquery>
	
	<cfloop query="getMails">
	
		<cf_ExchangeTask
			account     = "#Account#"					
			action      = "delete"
			alias       = "AppsOrganization"
			uid         = "#exchangeid#">  	
			
	</cfloop>
	
	<cfquery name="ClearAction" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	DELETE FROM OrganizationObjectMail
		WHERE  ObjectId = '#URL.ObjectId#' 
	</cfquery>
	
	<!--- not sure, but I think this as embedded workflows in a workflow  --->
	
	<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	DELETE FROM OrganizationObject
		WHERE  ParentObjectId = '#URL.ObjectId#'
	</cfquery>
	
<cfelse>
		
	<!--- -------------------------------------- --->
	<!--- remove reminder mails from MS exchange --->
	<!--- -------------------------------------- --->
	
	<cfquery name="getMails" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT * 
		FROM   OrganizationObjectMail
		WHERE  ObjectId = '#URL.ObjectId#' 
		AND    ExchangeId is not NULL
	</cfquery>
	
	<cfloop query="getMails">
	
		<cf_ExchangeTask
			account     = "#Account#"					
			action      = "delete"
			alias       = "AppsOrganization"
			uid         = "#exchangeid#">  	
			
	</cfloop>
		
	<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	UPDATE OrganizationObject
		SET    Operational = 0
		WHERE  ObjectId = '#URL.ObjectId#'		
	</cfquery>
	
	<!--- ---------------------------------------------- --->
	<!--- this will now create a new object and elements --->
	<!--- ---------------------------------------------- --->

</cfif>	

</cftransaction>

<cfoutput>
<cfset ref = replace("#url.ref#","|","&","ALL")>

<cfif url.ajaxid eq "">

	<script language="JavaScript">        	   
		window.location = "#tpe#://#CGI.HTTP_HOST##ref#"
	</script>
	
<cfelse>

	 <script>		    
	     try {    		
	     workflowreload("#url.ajaxid#")		
		 clearInterval ( workflowrefresh_#left(url.objectid,8)# )		
		 } catch(e) {		   
		   window.location = "#tpe#://#CGI.HTTP_HOST##ref#"
		 }
	 </script>

</cfif>	
</cfoutput>

