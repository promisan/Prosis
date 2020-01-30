<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="mobileLogin"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="mobileLogin">
		
			<cfargument name="callback" type="string" required="false">
			<cfargument name="user" 	type="string" required="true" default="">
			<cfargument name="pwd" 		type="string" required="true" default="">
			<cfargument name="deviceId" type="string" required="true" default="">
			
			<cfinvoke component="Service.Access.MobileAccess"  
				Method       		= "Authenticate"
				Account      		= "#user#"
				Pwd			   		= "#pwd#"
				DeviceId			= "#deviceId#"
				returnvariable   	= "functionResult">
			
			<!--- wrap to JSONP --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & functionResult & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<cffunction name="mobileLogout"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="mobileLogout">
		
			<cfargument name="callback" 		type="string" required="false">
			<cfargument name="hostSessionId" 	type="string" required="true" default="">
		
			<cfinvoke component="Service.Access.MobileAccess"  
				Method       		= "LogOut"
				HostSessionId  		= "#hostSessionId#"
				returnvariable   	= "functionResult">
			
			<!--- wrap to JSONP --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & functionResult & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
	<cffunction name="mobileValidateSession"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="mobileValidateSession">
		
			<cfargument name="callback" 		type="string" required="false">
			<cfargument name="hostSessionId" 	type="string" required="true" default="">
		
			<cfinvoke component="Service.Access.MobileAccess"  
				Method       		= "Verify"
				HostSessionId  		= "#hostSessionId#"
				returnvariable   	= "functionResult">
			
			<!--- wrap to JSONP --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & functionResult & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
</cfcomponent>	