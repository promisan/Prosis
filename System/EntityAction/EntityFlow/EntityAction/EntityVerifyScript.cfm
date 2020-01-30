
<!--- verify script --->

<cfif form.conditionalias neq "" AND form.conditionscript neq "" AND len(form.conditionscript) gte 10>
	
	<cftry>
	
		 <cfset val = form.conditionscript>
	
		 <cfset key1   = "0">
		 <cfset key2   = "0">
		 <cfset key3   = "0">
		 <cfset key4   = "{00000000-0000-0000-0000-000000000000}">
		 <cfset action = "{00000000-0000-0000-0000-000000000000}">
		 <cfset object = "{00000000-0000-0000-0000-000000000000}">
				 
		 <cfset val = replaceNoCase("#val#", "@key1",   "#key1#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@key2",   "#key2#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@key3",   "#key3#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@key4",   "#key4#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@object", "#object#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@action", "#action#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@acc",    "#SESSION.acc#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@last",   "#SESSION.last#" , "ALL")>
		 <cfset val = replaceNoCase("#val#", "@first",  "#SESSION.first#" , "ALL")>
			
		 
		 <cfquery name="getEntity" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM Ref_Entity			
			WHERE  EntityCode       = '#Form.EntityCode#'
		</cfquery>
		
		<cfquery name="Check" 
		datasource="#Form.ConditionAlias#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			#preservesinglequotes(val)#
		</cfquery>
		
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_Entity
			SET    ConditionScript  = '#Form.ConditionScript#',
			       ConditionAlias   = '#Form.ConditionAlias#'
			WHERE  EntityCode       = '#Form.EntityCode#'
		</cfquery>
		
		<font color="408080">Validated and saved</font>
	
	<cfcatch>
	
		<font color="red">
		Invalid script: <cfoutput>#CFCatch.Message# - #CFCATCH.Detail#</cfoutput>
		</font>
	
	</cfcatch>
	
	</cftry>

<cfelse>
	
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Entity
		SET    ConditionScript  = ''
		WHERE  EntityCode       = '#Form.EntityCode#'
	</cfquery>

	<font color="red">No script defined, script was removed

</cfif>