<!--
    Copyright © 2025 Promisan

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

<!--- submit session --->

<cfparam name="Form.Operational" default="0">
<cfparam name="Form.SessionIP"   default="">

<cfquery name="UserSession" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT    *
	FROM      OrganizationObjectActionSession
	WHERE     ActionId        = '#url.actionid#'
	AND       EntityReference = '#url.referenceId#'
	<cfif url.useraccount neq "">
	AND       UserAccount = '#url.useraccount#'
	</cfif>
</cfquery>

<cfquery name="Object" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT    OOA.ObjectId, 
	          OO.EntityCode, 
			  OO.Mission, 
			  OO.OrgUnit, 
			  OO.ActionPublishNo, 
			  R.ActionCode,
			  R.ActionDescription
	FROM      OrganizationObjectAction AS OOA INNER JOIN
	          OrganizationObject AS OO ON OOA.ObjectId = OO.ObjectId INNER JOIN
	          Ref_EntityActionPublish AS R ON OO.ActionPublishNo = R.ActionPublishNo AND OOA.ActionCode = R.ActionCode
	WHERE     OOA.ActionId = '#url.actionid#'
</cfquery>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.SessionPlanStart#">
<cfset STR = dateValue>
<cfset STR = DateAdd("h", "#Form.HourSessionPlanStart#", "#STR#")> 
<cfset STR = DateAdd("n", "#Form.MinuteSessionPlanStart#", "#STR#")>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.SessionPlanEnd#">
<cfset end = dateValue>	
<cfset end = DateAdd("h", "#Form.HourSessionPlanEnd#",   "#end#")> 
<cfset end = DateAdd("n", "#Form.MinuteSessionPlanEnd#", "#end#")>

<cfif UserSession.recordcount eq "1">

	<cfquery name="Update" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		UPDATE  OrganizationObjectActionSession
		SET     SessionPlanStart  = #str#, 
				SessionPlanEnd    = #end#, 				
				SessionIP         = '#form.sessionip#', 
				SessionPasscode   = '#form.passcode#',
				Operational       = '#form.Operational#'
		WHERE ActionSessionId = '#UserSession.ActionSessionId#'	
	</cfquery>

<cfelseif UserSession.recordcount eq "0">
	
	<cf_assignid>
	
	<cfquery name="AddSession" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">		
		
		INSERT INTO OrganizationObjectActionSession		
					(ActionSessionId, 
					 EntityCode, 
					 EntityReference, 
					 UserAccount,
					 ActionId, 
					 SessionDocumentId, 		 
					 SessionPlanStart, 
					 SessionPlanEnd, 		
					 SessionIP, 
					 SessionPasscode, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
					 		
		VALUES   ('#rowguid#',
				  '#Object.EntityCode#',
				  '#url.Referenceid#',
				  <cfif url.useraccount neq "">
				  '#url.useraccount#',
				  <cfelse>
				  NULL,
				  </cfif>	
				  '#url.actionid#',
				  '#form.documentId#',
				  #str#,
				  #end#,
				  '#form.SessionIP#',
				  '#form.Passcode#',
				  '#session.acc#',
				  '#session.last#',
				  '#session.first#')		
				  		  
	</cfquery>	
	
	<cfquery name="UserSession" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT    *
		FROM      OrganizationObjectActionSession
		WHERE     ActionId        = '#url.actionid#'
		AND       EntityReference = '#url.referenceId#'
		<cfif url.useraccount neq "">
		AND       UserAccount = '#url.useraccount#'
		</cfif>
	</cfquery>	  					 

</cfif>

<cfoutput>

	<script>	
	    _cf_loadingtexthtml='';
		<cfif url.useraccount neq "">
		ptoken.navigate('#session.root#/tools/entityaction/session/setsession.cfm?actionid=#Usersession.ActionId#&entityreference=#Usersession.entityreference#&useraccount=#url.useraccount#','session_#url.Referenceid#_#url.useraccount#')			
		<cfelse>
		ptoken.navigate('#session.root#/tools/entityaction/session/setsession.cfm?actionid=#Usersession.ActionId#&entityreference=#Usersession.entityreference#','session_#url.Referenceid#')	
		</cfif>
		ProsisUI.closeWindow('wfusersession')
	</script>

</cfoutput>

