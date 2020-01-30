
<cfcomponent>

<cfproperty name="name" type="string">
<cfset this.name = "Menu authorization">
	
<!--- 1.0 GENERAL ACCESS TO A FUNCTION --->
	
<cffunction access="public" name="MenuList" output="true" returntype="query" displayname="Create a list of menu items">
	
	<cfargument name="Module"         type="string" required="false" default="">
	<cfargument name="FunctionClass"  type="string" required="true"  default="">
	<cfargument name="MenuClass"      type="string" required="true"  default="">
	<cfargument name="Anonymous"      type="string" required="true"  default="">
	<cfargument name="Mission"        type="string" required="true"  default="">
	<cfargument name="OrgUnit"        type="string" required="true"  default="">
	<cfargument name="Mode"           type="string" required="true"  default="">
		
	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT *
		   FROM   xl#Client.languageId#_Ref_ModuleControl
		   WHERE  SystemModule = #PreserveSingleQuotes(module)#
		   	AND   FunctionClass in (#PreserveSingleQuotes(selection)#)
		   	AND   MenuClass     in (#PreserveSingleQuotes(menuclass)#)
		   	AND   Operational  = '1'	   	
			<cfif anonymous neq "">
			AND   EnableAnonymous = '#anonymous#' 
			</cfif>	
		   ORDER BY MenuClass, MenuOrder  
	</cfquery>
	
	<cfset listaccess = "">
	
	<cfoutput>
		<cfloop query="searchresult">
			<cfset access = "NONE">

			<cfif mode eq "enforce">

				<cfset access = "GRANTED">

			<cfelse>

				<!--- determine if the person has access to the role and for the level as defined in the function itself --->

				<cfinvoke component = "Service.Access"
				 method             = "function"
				 mission            = "#mission#"
				 orgunit            = "#orgunit#"
				 SystemFunctionId   = "#SystemFunctionId#"
				 returnvariable     = "access">

			</cfif>

			<cfif access is "GRANTED" or access is "ALL" or access is "EDIT">

				<cfif listaccess eq "">
					<cfset listaccess = "'#systemfunctionid#'">
				<cfelse>
					<cfset listaccess = "#listaccess#,'#systemfunctionid#'">
				</cfif>

			</cfif>
		</cfloop>
	</cfoutput>
		
	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT *
		   FROM   xl#Client.languageId#_Ref_ModuleControl
		   <cfif listaccess neq "">
		   WHERE  SystemFunctionId IN (#preservesingleQuotes(listaccess)#)
		   <cfelse>
		   WHERE  1=0
		   </cfif>
		   ORDER BY MenuClass, MenuOrder  
	</cfquery>
	
	<cfreturn SearchResult>
	 			
	</cffunction>		
	
</cfcomponent>			