
<!--- determine of the person is currently in the mode of the personalised schedule --->

<cf_verifyOnboard personNo = "#URL.ID#">

<cfset go = "1">

<cfif orgunit neq "">
	
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT  *
		FROM    Organization
		WHERE   OrgUnit = '#orgunit#'					
	</cfquery>

	<cfif check.workschema eq "1">
	
		<cfset go = "0">
	
	</cfif>

</cfif>

<cfquery name="ClearProvision" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   DELETE Employee.dbo.PersonWorkDetail
	   FROM Employee.dbo.PersonWorkDetail D 	 				   
	   WHERE  Source   = 'Overtime'
	   AND    NOT EXISTS (SELECT 'X'
	                      FROM PersonOvertime
						  WHERE PersonNo   = D.PersonNo
						  AND   OvertimeId = D.SourceId )					    			   
</cfquery>


<cfif go eq "0" and 1 eq 0>

	<table align="center">
	<tr class="labelmedium">
		<td style="font-weight:200;font-size:25px;padding-top:40" align="center"><cf_tl id="Sorry but your unit operates under a work schedule"></td>
	</tr>
	</table>

<cfelse>
	
	<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT  *
		FROM    PersonWorkSchedule
		WHERE   PersonNo = '#url.id#'		
		AND     Mission IN (SELECT  DISTINCT P.Mission
				    		FROM    PersonAssignment PA INNER JOIN
					    	        Position P ON PA.PositionNo = P.PositionNo
						    WHERE   PA.PersonNo = '#url.id#')							
						
	</cfquery>
	
	<cfif check.recordcount gte "1">
	
	    <cfinclude template="OvertimeEntrySchedule.cfm">
				
	<cfelse>
		<cfinclude template="OvertimeEntryStandard.cfm">
	</cfif>

</cfif>