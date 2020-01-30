	
	<cfquery name="Last" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
	    FROM ItemUoM
		WHERE ItemNo = '#Attributes.ItemNo#'
		AND    UoM LIKE '__'
		ORDER BY UoM DESC				
	</cfquery>
	
	<cfif Last.UoM neq "">							
		<cfset UoM = Last.UoM+1>
	<cfelse>
	    <cfset UoM = 1>
	</cfif>	
	<cfif UoM lt 10>
	     <cfset UoM = 10+UoM>
	</cfif>
			
	<CFSET Caller.UoM = UoM>		
