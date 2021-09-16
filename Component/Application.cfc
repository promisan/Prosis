<cfcomponent
displayname="Application"
output="true"
hint="Handle the application.">
 
		<!--- Set up the application. --->
		<cfset THIS.Name                   = "Prosis" />
		<cfset THIS.ApplicationTimeout     = CreateTimeSpan( 0, 24, 180, 0 ) />
		<cfset THIS.SessionManagement      = true />
		<cfset THIS.clientmanagement       = true />	
		<cfset THIS.SessionTimeout         = CreateTimeSpan(0,24,180,0)/>
		<cfset THIS.sessioncookie.httponly = true>
		<cfset this.wschannels             = [{name="validatorchannel"}]>
				 
		<cffunction
			name="OnRequestStart"
			access="public"
			returntype="boolean"
			output="true"
			hint="Fires at first part of page processing.">
		 
			<!--- Define arguments. --->
			<cfargument	name="TargetPage" type="string"	required="true"/>
																								
			 		<cf_appInit>
										    
					<cfparam name="CLIENT.Timeout" default="40">
					<cfparam name="SESSION.authent" default="0">
					
					<cfif SESSION.authent eq "1">
						<cfset trackUser = "1">
					<cfelse>
					  	<cfset trackUser = "0"> 
					</cfif>
										
					<cf_Control 
						verifyMultipleLogon  = "0"
						verifyCSRF           = "0"
					    verifyAuthentication = "1"						
					    trackUser            = "#TrackUser#"
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
			<!--- --------------------------- --->

			 
		<!--- Return out. --->
		<cfreturn />
		</cffunction>
	
 
</cfcomponent>




