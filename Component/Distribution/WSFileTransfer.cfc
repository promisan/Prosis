<cfcomponent output="false">
  <cffunction name="getFile" returntype="string" output="false" access="remote">
	<cfargument name="directory" type="string" required="yes">
	<cfargument name="file" type="string" required="yes">

	<cf_init>
	<cffile action = "read" 
	  file = "#SESSION.rootpath#\#directory#\#file#"
	  variable = "content">

        <cfreturn #content#>
  </cffunction>


</cfcomponent>