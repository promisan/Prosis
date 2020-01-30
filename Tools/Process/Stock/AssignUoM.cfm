	
	<cfparam name="Attributes.UoMDescription" default="">
	<cfparam name="Attributes.datasource" default="appsMaterials">
	
	<cfquery name="Last" 
	datasource="#attributes.datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
	    FROM   Materials.dbo.ItemUoM
		WHERE  ItemNo = '#Attributes.ItemNo#' AND (IsNumeric(UoM) = 1)
		ORDER BY CAST(UoM AS INT) DESC				
	</cfquery>
	
	<cfif isNumeric(Last.UoM)>
	
		<cfif Last.UoM neq "">							
			<cfset UoM = Last.UoM+1>
		<cfelse>
		    <cfset UoM = 1>
		</cfif>	
		
		<cfif UoM lt 10>
		     <cfset UoM = 10+UoM>
		</cfif>
		
	<cfelse>
	
	    <cfset UoM = "10">
		
	</cfif>
	
	<CFSET Caller.UoM = UoM>		
