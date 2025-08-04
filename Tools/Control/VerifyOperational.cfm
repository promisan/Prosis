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

<!---verify is user is logged in  --->

<cfparam name="Attributes.DataSource"  default = "appsSystem">
<cfparam name="Attributes.Module"      default = "System">
<cfparam name="Attributes.Mission"     default = "">
<cfparam name="Attributes.CheckModule" default = "">

<cfif Attributes.CheckModule neq "">
     <cfset Attributes.Module = Attributes.CheckModule>
</cfif>

<cfparam name="Attributes.Warning" default = "No">

<cftry>

<cfquery name="SystemModule" 
	datasource="#Attributes.DataSource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   System.dbo.Ref_SystemModule
		WHERE  SystemModule = '#Attributes.Module#'
</cfquery>

<cfoutput>

<cfif SystemModule.Operational eq "0" OR SystemModule.recordcount eq "0">

  <cfset Caller.Operational = 0> 
  <cfset Caller.ModuleEnabled = 0>  
  
  <cfif Attributes.Warning eq "Yes">
  	<cf_message message = "Module:#SystemModule.Description# has not been enabled. Operation not allowed."
	  return = "no">
  </cfif>
  
<cfelse>  

	<cfif Attributes.mission neq "">	
			
		<cfquery name="SystemModule" 
		datasource="#Attributes.DataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Organization.dbo.Ref_MissionModule
			WHERE  SystemModule = '#Attributes.Module#'
			AND    Mission      = '#Attributes.Mission#'
		</cfquery>

		<cfif systemModule.recordcount eq "1">
		
		   <cfset Caller.ModuleEnabled = 1>
		   <cfset Caller.Operational   = 1>
		   
		<cfelse>
		
		 <cfset Caller.Operational = 0> 
		  <cfset Caller.ModuleEnabled = 0>   
				
		  <cfif Attributes.Warning eq "Yes">
		  	<cf_message message = "Module:#SystemModule.Description# has not been enabled. Operation not allowed." return = "no">
		  </cfif>
				
		</cfif>
	
	<cfelse>

	   <cfset Caller.ModuleEnabled = 1>
	   <cfset Caller.Operational = 1>
	   
	</cfif>   
  
</cfif>  

</cfoutput>  

<cfcatch>
	 <cfset Caller.Operational = 0> 
	  <cfset Caller.ModuleEnabled = 0>  
</cfcatch>

</cftry>

 
 