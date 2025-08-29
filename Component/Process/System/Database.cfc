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

    <cfproperty name="name" type="string">
    <cfset this.name = "Database utilities">
		
	<cffunction
	    name 	    = "getTableFields"
	    description = "Returns comma separated fields of a table (ignoring computed fields)"
	    displayName = "getTableFields"
	    returnType  = "string">
		
			 <cfargument name="DataSource"   required="yes" type="string">
			 <cfargument name="tableName"    required="yes" type="string">
			 <cfargument name="ignoreFields" required="no" type="string">
 			 <cfargument name="frameworkFields" required="no" type="string" default="No">
			 
			 <cfinvoke component = "Service.Process.System.UserController"  
	   			method           = "ValidateCFCAccess"
			   datasource        = "#DataSource#" 
			   sessionId         = "#session.sessionid#" 
			   account           = "#session.acc#">	
	   
			 <cfif frameworkFields eq "Yes">
			 
			 	<cfif len(ignoreFields) eq 0>
					<cfset ignoreFields = "'OfficerUserId','OfficerLastName','OfficerFirstName','Created'">
				<cfelse>
					<cfset ignoreFields = ignoreFields&",'OfficerUserId','OfficerLastName','OfficerFirstName','Created'">
				</cfif>
			 
			 </cfif>
			 
	         
			 <cfquery name="getFields" 
			 datasource="#DataSource#" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		
				SELECT C.Name
				FROM   syscolumns C	
					   INNER JOIN sysobjects T
					         ON C.id = T.id and T.xtype = 'u'
				WHERE T.name = '#tableName#'
				AND   C.name NOT IN(#PreserveSingleQuotes(ignoreFields)#)
				AND   C.iscomputed = 0
				ORDER BY c.colid
				
			</cfquery>
			 
			 <cfset fields = "">
			 
			 <cfloop query="getFields">
			 	<cfif fields eq "">
					<cfset fields = Name>
				<cfelse>
					<cfset fields = fields& "," & Name>
				</cfif>
			 </cfloop>
		
			<cfreturn fields>
		
	</cffunction>

</cfcomponent>			 