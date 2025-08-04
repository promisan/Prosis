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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Obtain Regular expression from nationality table">

	<cffunction name="Customer"
        access="public"
        returntype="string">
				
		<cfargument name="Scope"       type="string"  required="true" default="customer">	
		<cfargument name="ScopeId"     type="string"  required="true">	
		<cfargument name="DataSource"  type="string" default="appsMaterials" required="yes">	 	 				
		<cfargument name="Element"     type="string"  required="true">	 	
		
		<cfif scope eq "customer">
		
			<cfquery name="get" 
				datasource="#DataSource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Customer 						
				WHERE     CustomerId = '#scopeid#'
			</cfquery>
		
			<cfquery name="mission" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Organization.dbo.Ref_Mission 						
				WHERE     Mission = '#get.Mission#'
			</cfquery>	
			
		<cfelse>
		
			<cfquery name="mission" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Organization.dbo.Ref_Mission 						
				WHERE     Mission = '#scopeid#'
			</cfquery>	
		
		</cfif>	
		
		<cfif mission.countrycode neq "">
		
			<cfquery name="pattern" 
				datasource="appsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    * 
				FROM      Ref_NationPattern 						
				WHERE     Code = '#mission.countrycode#'
				AND       Element = '#element#'
			</cfquery>
								
			<cfif pattern.ElementPattern neq "">
				<cfset regex = pattern.ElementPattern>
				
			<cfelse>
				<cfset regex = "">		
			</cfif>
					
		<cfelse>
		
			<cfset regex = "">	
		
		</cfif>
		
		<cfreturn regex>		   	
				
	</cffunction>	
	

</cfcomponent>			 