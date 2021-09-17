
<cfcomponent
displayname="Application"
output="true"
hint="Handle the application.">
 
		<!--- Set up the application. --->
		<cfset THIS.Name = "Prosis" />
		<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 180, 0 ) />
		<cfset THIS.SessionManagement = true />
		<cfset THIS.clientmanagement = false />
		<cfset THIS.SessionTimeout   = CreateTimeSpan(0,0,180,0)/>
		<cfset THIS.sessioncookie.httponly = true>
		 
		<cffunction
		name="OnRequestStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires at first part of page processing.">
		 
		<!--- Define arguments. --->
		<cfargument
		name="TargetPage"
		type="string"
		required="true"/>
				
		<!--- code to allow template to call if a user is an administrator for a function --->
		<cfset structAppend(url,createObject("component","Service.Authorization.Broker"))/>

		<cf_Control
			verifyMultipleLogon  = "1"
		    verifyAuthentication = "1"
			verifyCSRF           = "1"
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