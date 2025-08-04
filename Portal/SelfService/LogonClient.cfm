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
<cfparam name="form.width"        	default="1280">
<cfparam name="form.height"       	default="1024">
<cfparam name="URL.ID"              default="">
<cfparam name="CLIENT.IndexNoName"  default="IndexNo">
<cfparam name="scope" 				default="prosis">

<cfif trim(session.acc) eq "anonymous">

	<cfset session.acc = "">
	<cfset session.authent = 0>
	
</cfif>

<cf_SessionInit 
	width   = "#FORM.width#"
	height  = "#FORM.height#"
	color   = "F4F4F4"
	welcome = "#URL.ID#">

<!--- ------------------------------ --->  
<!--- define support access for user --->
<!--- ------------------------------ --->  
   
<cfif SESSION.acc eq "administrator">
      <cfset SESSION.isAdministrator = "Yes">   
<cfelse>   
  <cfquery name="Support" 
   datasource="AppsOrganization">
   SELECT    UserAccount
   FROM      OrganizationAuthorization
   WHERE     Role        = 'Support'
   AND       UserAccount = '#SESSION.acc#'
  </cfquery> 
  
  <cfif Support.recordcount eq "1">
   <cfset SESSION.isAdministrator = "Yes"> 
  </cfif>
  
</cfif> 
      
<!--- ------------------------------ --->		
   <!--- --define LOCAL ADMIN access--- --->
   <!--- ------------------------------ --->		   
   
   <cfquery name="MissionSupport" 
		datasource="AppsOrganization">
		SELECT    DISTINCT Mission
		FROM      OrganizationAuthorization
		WHERE     Role        = 'OrgUnitManager'
		AND       UserAccount = '#SESSION.acc#'
		AND       AccessLevel IN ('3') <!--- only the support level --->				
   </cfquery>	
   
   <cfset SESSION.isLocalAdministrator = quotedvalueList(MissionSupport.Mission)>
   
   <cfif SESSION.isLocalAdministrator eq "">
	     <cfset SESSION.isLocalAdministrator = "No">		
   </cfif>
      
   <cfquery name="OwnerSupport" 
		datasource="AppsOrganization">
		SELECT    DISTINCT ClassParameter
		FROM      OrganizationAuthorization
		WHERE     UserAccount = '#SESSION.acc#'
		AND       Role = 'OrgUnitManager' AND AccessLevel IN ('3')		
		UNION
		SELECT    DISTINCT ClassParameter
		FROM      OrganizationAuthorization
		WHERE     UserAccount = '#SESSION.acc#'
		AND       Role = 'AdminRoster' AND AccessLevel IN ('2','3')	
   </cfquery>	  
	     
   <cfset SESSION.isOwnerAdministrator = quotedvalueList(OwnerSupport.ClassParameter)>
      
   <cfif SESSION.isOwnerAdministrator eq "">
	     <cfset SESSION.isOwerAdministrator = "No">		
   </cfif>


<cfparam name="client.googleMAP" default="0">
<!--- <cfset client.googleMAP   = "1"> --->

<cfif not isDefined("CLIENT.LANPREFIX")>
	<cfset CLIENT.LANPREFIX = "">
</cfif>