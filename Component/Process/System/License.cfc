<cfcomponent>
    <cfproperty name="name" type="string">
    <cfset this.name = "System License controller">

	<cffunction name="getSerialNo"
        access="public"
        returntype="string">

		<cfargument name="Module"  type="string"  required="true">	 
		<cfargument name="Mission" type="string"  required="true" default="ALL">	 		
		<cfargument name="Year"    type="string"  required="true">	 				
		<cfargument name="Quarter"   type="string"  required="true">	 						
		
		   		<cfset key    = Module & "124EFCD" & Mission & "45778EE" & Year & "2232122" & Quarter>
				<cfset hash   = Hash(key, "SHA")>
				<cfreturn hash>	
	</cffunction>	

	
	<cffunction name = "getDatabaseLicense" returnType="string">
		<cfargument name="DatabaseServer" type="string" required="false" default="">
		<cfargument name="Year"           type="string"  required="true">	 				
		<cfargument name="Quarter"        type="string"  required="true">	 						

   		<cfset key    = DatabaseServer & "124EFCD" & Year & "2232122" & Quarter>
		<cfset hashkey = Hash(key, "SHA")>
		<cfreturn hashkey>		
	</cffunction>	

</cfcomponent>			 