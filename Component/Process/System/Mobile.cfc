
<cfcomponent>

<cfproperty name="name" type="string">
<cfset this.name = "Execution Queries">
	
	<cffunction name="mobileProsisController"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="Prosis Mobile Controller">

		<!--- every mobile request except for the logon 
		   first hits on the component ProsisMobileController in which we validate the access based on the
		   passed ID to be checked from UserStatus, if not validated the return = No and logon screen
		   appears then this component passes the REQUEST and the USERACCOUNT
		   to the approproate cfc which passes the requested values based on the determine useraccount
		   and its access in no --->
	   
    </cffunction>   
	
	<cffunction name="getParametersByAppId"
        access="remote"
        returntype="any" 
		returnformat="plain" 
		output="No"
        displayname="getParametersByAppId">
		
			<cfargument name="callback" type="string" required="false">
			<cfargument name="appId" type="string" required="true" default="">
		
			<cfquery name="get"
				datasource="AppsSystem">
				    SELECT	P.Type,
							P.DataDomain,
							P.Name,
							P.Value
					FROM	Ref_ModuleControlParameter P
							INNER JOIN Ref_ModuleControl M
								ON P.SystemFunctionId = M.SystemFunctionId
					WHERE	M.Operational = 1
					AND		P.Operational = 1
					AND		M.SystemFunctionId = '#appId#'
					ORDER BY P.Type ASC, P.ListingOrder ASC
			</cfquery>
			
			<cfset data = serializeJSON(get,true)>
			
			<!--- wrap --->
		    <cfif structKeyExists(arguments, "callback")>
        		<cfset data = arguments.callback & "(" & data & ")">
		    </cfif>
		
			<cfreturn data>
		
	</cffunction>
	
</cfcomponent>	