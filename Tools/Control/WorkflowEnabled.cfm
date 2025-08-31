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
<cfparam name="Attributes.EntityCode"  default = "">
<cfparam name="Attributes.EntityClass" default = "">
<cfparam name="Attributes.Mission"     default = "">
<cfparam name="Attributes.datasource"  default = "appsOrganization">

<cfquery name="workflow" 
datasource="#Attributes.DataSource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Organization.dbo.Ref_EntityMission
	WHERE  EntityCode = '#attributes.EntityCode#'
	AND    Mission    = '#attributes.Mission#'
</cfquery>

<cfif workflow.WorkflowEnabled eq "1">

	<cfif Attributes.entityClass eq "">

		    <cfset Caller.WorkflowEnabled = 1>  
			
	<cfelse>
			
		<cfquery name="workflow" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization.dbo.Ref_EntityClassPublish
			WHERE  EntityCode    = '#attributes.EntityCode#'
			AND    EntityClass   = '#attributes.EntityClass#'
		</cfquery>
		
		<cfif workflow.recordcount eq "0">
		
			 <cfset Caller.WorkflowEnabled = 0> 
			 
		<cfelse>
		
			 <cfset Caller.WorkflowEnabled = 1> 	
			 		
		</cfif>
	
	</cfif>		
    
<cfelse>  

    <cfset Caller.WorkflowEnabled = 0> 
    
</cfif>  

 