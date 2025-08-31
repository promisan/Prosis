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
<cfcomponent displayname="Application" output="true" hint="Handle the application.">
 
		<!--- Set up the application. --->
		<cfset THIS.Name = "Prosis" />
		<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 180, 0 ) />
		<cfset THIS.SessionManagement = true />
		<cfset THIS.clientmanagement = true />
		<cfset This.loginstorage="Session"/>
		<cfset THIS.SessionTimeout   = CreateTimeSpan(0,0,180,0)/>
		<cfset THIS.sessioncookie.httponly = true>
		 
		<cffunction
		name="OnRequestStart"
		access="public"
		returntype="boolean"
		output="true"
		hint="Fires at first part of page processing.">
		 
		<!--- Define arguments. --->
		<cfargument	name="TargetPage" type="string"	required="true"/>
						 		
			<cf_appInit>
			<cfset vVerify = 1>
			<cfif FindNoCase("UserStats",Arguments.TargetPage) neq 0>
				<cfset vVerify = 0>
			</cfif>

			<cf_Control
					verifyMultipleLogon  = "1"
					verifyCSRF           = "1"
					verifyAuthentication = "#vVerify#" <!--- keep as 0 for scheduled tasks etc. --->
					trackUser            = "1"
					errorHandling        = "1">
<!--- Return out. --->
		<cfreturn true />
		</cffunction>
		 		 
		<cffunction
		name="OnRequest"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after pre page processing is complete.">
		 
		<!--- Define arguments. --->
		<cfargument
		name="TargetPage"
		type="string"
		required="true"/>
			 
		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />
		 
		<!--- Return out. --->
		<cfreturn />
		</cffunction>
 
</cfcomponent>









