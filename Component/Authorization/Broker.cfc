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
<cfcomponent
    output="false"
    hint="Prosis Global Functions">

	<!--- passes either the mission or the owner --->

	<cffunction name="getAdministrator"
	             access="public"
	             returntype="boolean"
	             displayname="defines if the user is an administrator">
		
			<cfargument name="Mission"    type="string"  required="false"   default="">	
			<cfargument name="Owner"      type="string"  required="false"   default="">	
			
			
			<cfparam name="SESSION.isAdministrator"      default="No">
			<cfparam name="SESSION.isLocalAdministrator" default="No">
			<cfparam name="SESSION.isOwnerAdministrator" default="No">
					
			<cfset isAdministrator = 0>
			
					
			<cfif SESSION.isAdministrator eq "Yes">
			
				<cfset isAdministrator = 1>
				
			<cfelseif Mission eq "*" and SESSION.isLocalAdministrator neq "No">	
			
				<!--- any mission and tree role manager --->
			
				<cfset isAdministrator = 1>
				
			<cfelseif Mission neq "" and findNoCase(mission,SESSION.isLocalAdministrator)>	
			
				<cfset isAdministrator = 1>
				
			<cfelseif Owner neq "" and findNoCase(owner,SESSION.isOwnerAdministrator)>	
			
				<cfset isAdministrator = 1>	
					
			</cfif>
			
			<cfreturn isAdministrator>
			
	</cffunction>		 

</cfcomponent>