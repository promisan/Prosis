<cfparam name="datasource" default="AppsMaterials">

<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">

		<cfquery name="Parameter" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Materials.dbo.Parameter			
		</cfquery>
							
		<cfset No = Parameter.ItemSerialNo+1>
		<cfif No lt 1000>
		     <cfset No = 1000+No>
		</cfif>
			
		<cfquery name="Update" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Materials.dbo.Parameter
			SET ItemSerialNo = '#No#'
		</cfquery>
		
		<!--- check if number is used --->
		
		<cfquery name="Check" 
		datasource="#datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Materials.dbo.Item
			WHERE  ItemNo = '#No#'					
		</cfquery>
		
		<cfif Check.recordcount eq "1">
		
			<cfquery name="Max" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 ItemNo as Last
			    FROM   Materials.dbo.Item
				ORDER BY CONVERT(bigint, ItemNo) DESC							
			</cfquery>
			
			<cfset No = Max.Last+1>
			
			<cfquery name="Update" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Materials.dbo.Parameter
				SET ItemSerialNo = '#No#'
			</cfquery>			
		
		</cfif>
			
</cflock>
