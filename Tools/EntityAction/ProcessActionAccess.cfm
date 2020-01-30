
<cfparam name="URL.AccessLevel" default="1">

<cfif url.mode eq "Insert">
	
		<cfquery name="Action" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		     SELECT    *
			 FROM      Ref_EntityActionPublish
			 WHERE     ActionCode      = '#url.ActionCode#'
			 AND       ActionPublishNo = '#url.ActionPublishNo#' 
		</cfquery> 			
				
<cfelse>
		
		<cfquery name="Action" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		     SELECT    *
			 FROM      Ref_EntityActionPublish
			 WHERE     ActionAccess    = '#url.ActionCode#'
			 AND       ActionPublishNo = '#url.ActionPublishNo#' 
		</cfquery> 			
	
</cfif>	
	
<cfloop query="Action">
		
	<!--- remove role --->
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  OrganizationObjectActionAccess 
		WHERE UserAccount = '#URL.Account#'
		 AND  ObjectId    = '#URL.ObjectId#'
		 AND  ActionCode  = '#ActionCode#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
		
		<cfquery name="Insert" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO OrganizationObjectActionAccess 
			         (UserAccount,
					  ObjectId,
					  ActionCode,
					  AccessLevel,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,
					  Created)
			  VALUES ('#URL.Account#',
					  '#URL.ObjectId#',
			          '#ActionCode#',  
					  '#url.accesslevel#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#',
					  getDate())
		</cfquery>	
	
	</cfif>	
	
</cfloop>	

<cfinclude template="ActionListingActor.cfm">

