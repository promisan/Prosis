
<cfquery name="Continuous" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT  A.*, O.Mission
	FROM    PersonAssignment A, 
	        Position P,
		    Organization.dbo.Organization O
	WHERE   P.OrgUnitOperational = O.OrgUnit
	  AND   A.PersonNo   = '#URL.ID#'
	  AND   O.Mission    = '#Position.Mission#'
	  AND   A.PositionNo = P.PositionNo
	  AND   A.AssignmentStatus < '8' 
    ORDER BY A.DateEffective 
</cfquery>

<cfset cstr = dateformat(Continuous.DateEffective,client.dateSQL)>
<cfset dte  = dateformat(Continuous.DateExpiration,client.dateSQL)>

<cfloop query="Continuous">

	<cfif DateEffective gt dte+1>
					
		<cfset cstr = DateEffective> 
	
	</cfif>

	<cfset dte = dateformat(DateExpiration,client.dateSQL)>

</cfloop>