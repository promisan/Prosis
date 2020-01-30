<cfcomponent
displayname="Application"
output="true"
hint="Handle the application.">

 
		<!--- Set up the application. --->
		<cfset THIS.Name = "Prosis" />
		<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 180, 0 ) />
		<cfset THIS.SessionManagement = true />
		<cfset THIS.clientmanagement = true />	
		<cfset THIS.SessionTimeout   = CreateTimeSpan(0,0,180,0)/>
		 
		 
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
		required="true"
		/>
		 		
			<cf_appInit>
			
			
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
		required="true"
		/>

		<!--- Include the requested page. --->
		<!---<cfinclude template="#ARGUMENTS.TargetPage#" />--->
		<!---<cf_minimize template="#ARGUMENTS.TargetPage#" />--->

		<cfsavecontent variable="vTheMainContent">
			<cfinclude template="#ARGUMENTS.TargetPage#">
		</cfsavecontent>

		<!--- reducing output --->
		<cfset vTheMainContent = replace(vTheMainContent,"	","","ALL")>
		<cfset vTheMainContent = replace(vTheMainContent,"#chr(13)#","","ALL")>
		<!--- <cfset vTheMainContent = replace(vTheMainContent,"&nbsp;","","ALL")>--->

		<!--- outputting --->
		<cfoutput>#preserveSingleQuotes(vTheMainContent)#</cfoutput>

		<!--- sending to file 
		<cfsilent>
			<cfoutput>
				<cf_logpoint filename="__logMinimized.txt">
					#preserveSingleQuotes(vTheMainContent)#
				</cf_logpoint>
			</cfoutput>
		</cfsilent> --->
		 
		<!--- Return out. --->
		<cfreturn />
		</cffunction>
		 
 
</cfcomponent>