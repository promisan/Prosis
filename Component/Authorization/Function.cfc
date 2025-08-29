<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfcomponent>
		
	<!--- ---------------------------------------- --->
	<!--- -------- pass authorised functions------ --->
	<!--- ---------------------------------------- --->
	
	<cffunction name="AuthorisedFunctions" access="public" returntype="any">				
		
		<cfargument name = "Mode"           type = "string"  default = "string" required = "no"> 
		<cfargument name = "Overwrite"      type = "string"  default = "verify" required = "no">
		
		<cfargument name = "Mission"        type = "string"  default = "" required = "no">
		<cfargument name = "OrgUnit"        type = "string"  default = "" required = "no">
		<cfargument name = "Role"           type = "string"  default = "" required = "no">
		
		<cfargument name = "SystemModule"   type = "string"  default = "">
		<cfargument name = "FunctionClass" 	type = "string"  default = "">
		<cfargument name = "MenuClass" 		type = "string"  default = "">
		
		<cfargument name = "Except" 		type = "string"  default = "''">
		<cfargument name = "Anonymous" 		type = "string"  default = "" required = "no">
	
		<cfquery name="mySearchResult" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			
			   SELECT  *
			   FROM    Ref_ModuleControl
			   WHERE   SystemModule = #PreserveSingleQuotes(systemmodule)#
			   AND     FunctionClass IN (#PreserveSingleQuotes(functionclass)#)
			   AND     MenuClass     IN (#PreserveSingleQuotes(menuclass)#)
			   AND     Operational  = '1'
			   AND     FunctionName NOT IN (#PreserveSingleQuotes(except)#)
			   <cfif anonymous neq "">
			   AND     EnableAnonymous = '#anonymous#' 
			   </cfif>	
			   ORDER BY MenuClass, MenuOrder  				   	
			      			   
		</cfquery>				
		
	    <cfset listaccess = "">		
		
		<cfloop query="mySearchResult">
				
			<cfset access = "NONE">
			
			<cfif overwrite eq "enforce">
			
				<cfset access = "GRANTED">
			
			<cfelseif scriptname eq "orgaccess">
			 
			    <!--- define if user has access to org access functions --->
			
				<cfinvoke component="Service.Access"  
					  method="org" 
					  mission="#mission#"
					  returnvariable="access">
				 	  	  	  	  
			<cfelse>
											
				<!--- determine if the person has access to the role and
				     for the level as defined in the function itself --->	
																			
			    <cfinvoke component = "Service.Access"  
			     method             = "function"  
				 role               = "#role#"
				 mission            = "#mission#"
				 orgunit            = "#orgunit#"
				 SystemFunctionId   = "#SystemFunctionId#" 
				 returnvariable     = "access">	 	
								  	  		  
			</cfif>		
			
			<cfif access is "GRANTED" or access is "ALL" or access is "EDIT"> 
			
			    <cfif mode eq "string">
				
					<cfif listaccess eq "">
					    <cfset listaccess = "#systemfunctionid#">
					<cfelse>
					    <cfset listaccess = "#listaccess#,#systemfunctionid#">
					</cfif>	
				
				<cfelse>
				
					<cfif listaccess eq "">
					    <cfset listaccess = "'#systemfunctionid#'">
					<cfelse>
					    <cfset listaccess = "#listaccess#,'#systemfunctionid#'">
					</cfif>	
				
				</cfif>
			
			</cfif>
						
		</cfloop>
		
	<cfif mode eq "string">	
	
			<cfreturn listaccess>
			
	<cfelse>
		
		<cfquery name="SearchResult" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		 
			   SELECT   *
			   FROM     xl#Client.languageId#_Ref_ModuleControl
			   <cfif listaccess neq "" and listaccess neq "''">
			   WHERE    SystemFunctionId IN (#PreserveSingleQuotes(listaccess)#)
			   <cfelse>
			   WHERE   1=0
			   </cfif>
			   ORDER BY MenuClass, MenuOrder  
			   		
		</cfquery>
		
		<cfreturn SearchResult>
	
	</cfif>		
			
	</cffunction>	
	
</cfcomponent>	
	