
<cfloop index="fld" list="#Attributes.Fields#" delimiters=",">

		<cftry>

		<cfquery name="Insert" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_EntityVariable
			(EntityCode, VariableName)
			VALUES ('#Attributes.EntityCode#', 
			       '#Attributes.Var#.#fld#')
		</cfquery>
			
		<cfcatch></cfcatch>

		</cftry>

</cfloop>