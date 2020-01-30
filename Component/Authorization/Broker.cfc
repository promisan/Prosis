<cfcomponent
    output="false"
    hint="Prosis Global Functions">

	<!--- passes either the mission or the owner --->
	
	<cffunction name="getAdministrator"
	             access="public"
	             returntype="boolean"
	             displayname="defines if the user is an administrator">
		
			<cfargument name="Mission"    type="string"  required="false"   default="">	
			<cfargument name="Owner"      type="string"  required="false"   default="">	
			
			
			<cfparam name="SESSION.isAdministrator"      default="No">
			<cfparam name="SESSION.isLocalAdministrator" default="No">
			<cfparam name="SESSION.isOwnerAdministrator" default="No">
					
			<cfset isAdministrator = 0>
			
					
			<cfif SESSION.isAdministrator eq "Yes">
			
				<cfset isAdministrator = 1>
				
			<cfelseif Mission eq "*" and SESSION.isLocalAdministrator neq "No">	
			
				<!--- any mission and tree role manager --->
			
				<cfset isAdministrator = 1>
				
			<cfelseif Mission neq "" and findNoCase(mission,SESSION.isLocalAdministrator)>	
			
				<cfset isAdministrator = 1>
				
			<cfelseif Owner neq "" and findNoCase(owner,SESSION.isOwnerAdministrator)>	
			
				<cfset isAdministrator = 1>	
					
			</cfif>
			
			<cfreturn isAdministrator>
			
	</cffunction>		 

</cfcomponent>