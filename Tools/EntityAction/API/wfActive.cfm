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

<cfparam name="attributes.entitycode"      default="">
<cfparam name="attributes.datasource"      default="AppsOrganization">
<cfparam name="attributes.objectkeyvalue1" default="">
<cfparam name="attributes.objectkeyvalue2" default="">
<cfparam name="attributes.objectkeyvalue3" default="">
<cfparam name="attributes.objectkeyvalue4" default="">
<cfparam name="attributes.objectId"        default="">

<cfquery name="Check" 
	datasource="#attributes.datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
			FROM   Organization.dbo.OrganizationObject
			
			<cfif (attributes.ObjectId neq "" or attributes.objectkeyvalue4 neq "") and attributes.EntityCode eq "">
			WHERE 1 = 1
			<cfelse>
			WHERE  EntityCode = '#attributes.entitycode#' 
			</cfif>
						
			<cfif attributes.objectkeyvalue1 neq "">
			AND    ObjectKeyValue1 = '#attributes.objectkeyvalue1#'
			</cfif>
			<cfif attributes.objectkeyvalue2 neq "">
			AND    ObjectKeyValue2 = '#attributes.objectkeyvalue2#'
			</cfif>
			<cfif attributes.objectkeyvalue3 neq "">
			AND    ObjectKeyValue3 = '#attributes.objectkeyvalue3#'
			</cfif>
			<cfif attributes.objectkeyvalue4 neq "">
			AND    ObjectKeyValue4 = '#attributes.objectkeyvalue4#'
			</cfif>
			<cfif attributes.objectId neq "">
			AND    ObjectId = '#attributes.objectId#'
			</cfif>			
			AND  Operational = 1
			
</cfquery>

<cfif check.recordcount eq "0">

	<cfset status    = "closed">
	<cfset exist     = "0">
	<cfset wfexist   = "0">
	<cfset started   = "no">

<cfelse>

	<cfquery name="Last" 
		datasource="#attributes.datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   Organization.dbo.OrganizationObjectAction
			WHERE  ObjectId = '#check.Objectid#'
			ORDER BY ActionFlowOrder DESC				
	</cfquery>
		
	<cfset exist    = "1">
	<cfset wfexist  = "1">
	
	<cfif Last.ActionStatus eq "0">
	
		<cfset status = "open">
			
	<cfelse>
	
		<cfset status = "closed">
						
	</cfif>
	
	<cfquery name="First" 
		datasource="#attributes.datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   Organization.dbo.OrganizationObjectAction
			WHERE  ObjectId = '#check.Objectid#'
			ORDER BY ActionFlowOrder				
	</cfquery>
	
	<cfif First.ActionStatus eq "0">
	
		<cfset started = "no">
			
	<cfelse>
	
		<cfset started = "yes">
						
	</cfif>	

</cfif>

<cfif status eq "open">

	<!--- now also determine if the current user has access to the open step step --->	
	
	<cfquery name="Next" 
		datasource="#attributes.datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   Organization.dbo.OrganizationObjectAction
			WHERE  ObjectId = '#check.Objectid#'
			AND    ActionStatus = '0'
			ORDER BY ActionFlowOrder				
	</cfquery>
	
	 <cfinvoke component = "Service.Access"  
		method         =   "AccessEntity" 
		objectid       =   "#check.ObjectId#"
		actioncode     =   "#Next.ActionCode#" 
		mission        =   "#Check.mission#"
		orgunit        =   "#Check.OrgUnit#" 
		entitygroup    =   "#Check.EntityGroup#" 
		returnvariable =   "entityaccess"
		datasource     =   "#attributes.datasource#">	
		
<cfelse>

	<cfparam name="Next.ActionCode" default="">

	<cfset entityaccess = "NONE">		
	
</cfif>

<!--- ----  if the workflow exists -------------------- --->
<CFSET Caller.wfExist    = exist>
<CFSET Caller.wfObjectId = Check.ObjectId>
<!--- ----- the status of the workflow open/closed ---- --->
<CFSET Caller.wfStatus   = status>
<CFSET Caller.wfStarted  = started>
<!--- ----- the access to the open workflow ----------- --->
<CFSET Caller.wfPublish  = Check.ActionPublishNo>
<CFSET Caller.wfAction   = Next.ActionCode>
<CFSET Caller.wfAccess   = entityaccess>
