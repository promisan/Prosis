<cfcomponent
displayname="Application"
output="true"
hint="Handle the application.">
 
		<!--- Set up the application. --->
		<cfset THIS.Name = "Prosis" />
		<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 30, 0 ) />
		<cfset THIS.SessionManagement = true />
		<cfset THIS.clientmanagement = true />
		<cfset THIS.SessionTimeout   = CreateTimeSpan(0,0,30,0)/>
		 
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











