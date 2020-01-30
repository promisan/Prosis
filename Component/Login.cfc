<cfcomponent output="false">
  <cffunction name="check" access="remote">
	<cfset var local = StructNew()>
	<cfif SESSION.authent is "0">
		<cfset local.value = false>
	<cfelse>
		<cfset local.value = true>
	</cfif>	
	
	<cfreturn local.value>

  </cffunction>
</cfcomponent>