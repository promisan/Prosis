
<!--- output locations --->

<cfset row = 0>

<cfparam name="form.LocationCode" default="""">

<cfoutput>
<cfloop index="loc" list="#Form.LocationCode#">

	<cfset row = row+1>

	<cfquery name="getName" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   Code,Name,
			         LocationCode,
					 L.Description,Continent,'' as LocationDefault
			FROM     Ref_PayrollLocation L, System.dbo.Ref_Nation N
			WHERE    L.LocationCountry = N.Code		
			AND      LocationCode = '#loc#'
		</cfquery>		
				
	<cfif row gt "1">;&nbsp;</cfif><cfoutput>#getName.Name# #getName.Description#</cfoutput>

</cfloop>
</cfoutput>
