<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Database utilities">
	
	<cfinvoke component = "Service.Process.System.UserController"  
	   method           = "ValidateCFCAccess"
	   datasource       = "#DataSource#" 
	   sessionId        = "#session.sessionid#" 
	   account          = "#session.acc#">	
	
	<cffunction
	    name 	    = "getTableFields"
	    description = "Returns comma separated fields of a table (ignoring computed fields)"
	    displayName = "getTableFields"
	    returnType  = "string">
		
			 <cfargument name="DataSource"   required="yes" type="string">
			 <cfargument name="tableName"    required="yes" type="string">
			 <cfargument name="ignoreFields" required="no" type="string">
 			 <cfargument name="frameworkFields" required="no" type="string" default="No">
			 
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