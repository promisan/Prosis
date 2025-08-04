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

<cfcomponent
displayname="Application"
output="true"
hint="Handle the application.">
 
		<!--- Set up the application. --->
		<cfset THIS.Name = "Prosis" />
		<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 24, 180, 0 ) />
		<cfset THIS.SessionManagement = true />
		<cfset THIS.clientmanagement = true />
		<cfset THIS.SessionTimeout   = CreateTimeSpan(0,24,180,0)/>
		<cfset THIS.sessioncookie.httponly = true>

	    <cffunction
	        name="OnSessionStart"
	        access="public"
	        returntype="void"
	        output="false"
	        hint="I fire when a session needs to be initialized.">
	        <!--- Return out. --->
	        <cfreturn />
	    </cffunction>
	 
	 
	    <cffunction
	        name="OnSessionEnd"
	        access="public"
	        returntype="void"
	        output="false"
	        hint="I fire when a session needs to be ended.">
	 
	        <!--- Define arguments. --->
	        <cfargument
	            name="Session"
	            type="struct"
	            required="true"
	            hint="I am the expired session scope."
	            />
	 
	        <!--- Return out. --->
	        <cfreturn />
	    </cffunction>
		 
		<cffunction name="OnRequestStart" access="public" returntype="boolean" output="true" hint="Fires at first part of page processing.">
		 
			<!--- Define arguments. --->
			<cfargument name="TargetPage" type="string"	required="true"/>
									 		
					<cfparam name="url.id" default="">
					
			 		<cf_appInit>
					    
					<cfparam name="CLIENT.Timeout" default="40">
					<cfparam name="SESSION.authent" default="0">
					
					<cfif SESSION.authent eq "1">
						<cfset trackUser = "1">
					<cfelse>
					  	<cfset trackUser = "0"> 
					</cfif>
					
					<!---kherrera(20181109): verifyCSRF should be change to 0 on UN instances due to troubles with the NET SCALER --->
					<cf_Control 
						verifyMultipleLogon  = "1"
					    verifyAuthentication = "0"
					    trackUser            = "#TrackUser#"
						verifyCSRF           = "1"
						errorHandling        = "1"
						sqlsyntax            = "1">
						
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




