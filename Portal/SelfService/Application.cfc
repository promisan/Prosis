
<cfcomponent
displayname="Application"
output="true"
hint="Handle the application.">
 
		<!--- Set up the application. --->
		<cfset THIS.Name = "Prosis" />
		<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 24, 180, 0 ) />
		<cfset THIS.SessionManagement = true />
		<cfset THIS.clientmanagement = false />
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




