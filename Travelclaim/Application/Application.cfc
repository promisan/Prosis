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
			verifyMultipleLogon  = "0"
		    verifyAuthentication = "1"
		    trackUser            = "1"
			errorHandling        = "1">
			
		<cfquery name="Parameter" 
		datasource="AppsInit">
			SELECT *
			FROM Parameter
			WHERE Hostname = '#CGI.HTTP_HOST#' 
		</cfquery>
		
		<cfset SESSION.rootpath = "#Parameter.ApplicationRootPath#">
		<cfset SESSION.root     = "#Parameter.ApplicationRoot#">
		
		<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">
		
		<cfparam name="URL.PersonNo" default="">
		<cfparam name="CLIENT.PersonNo" default="">
		
		<cfquery name="Parameter"
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *  
			FROM     Parameter 
		</cfquery>
		




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
		<cfinclude template="#ARGUMENTS.TargetPage#" />
		 
		<!--- Return out. --->
		<cfreturn />
		</cffunction>

 
</cfcomponent>

