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
	<cfquery name="user" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    System.dbo.UserNames
		WHERE   Account = '#URL.Account#'
	</cfquery>
	
	<cfif user.accounttype eq "Individual">
	
		<cfset acclist = "#url.account#">
	
	<cfelse>
	
		<!--- remove role --->
		<cfquery name="users" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  System.dbo.UserNamesGroup
			WHERE AccountGroup = '#URL.Account#'
			AND   Account IN (SELECT Account 
			                  FROM   System.dbo.UserNames 
							  WHERE  Disabled = 0)
		</cfquery>	
		
		<cfset acclist = "#valueList(users.account)#">
	
	</cfif>
	
	<cfloop index="itm" list="#acclist#">
		
			<!--- remove role --->
			<cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  OrganizationObjectActionAccess 
				WHERE UserAccount = '#itm#'
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
							  OfficerFirstName)
					  VALUES ('#itm#',
							  '#URL.ObjectId#',
					          '#ActionCode#',  
							  '#url.accesslevel#',
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
				</cfquery>	
			
			</cfif>	
	
	</cfloop>
	
</cfloop>	

<cfinclude template="ActionListingActor.cfm">

