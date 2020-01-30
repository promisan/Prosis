
<!--- set salary days --->


<cfquery name="get" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT * FROM PersonEntitlement 
  WHERE    PersonNo      = '#url.id#' 
  AND      EntitlementId = '#url.id1#'
</cfquery> 

<cfif get.EntitlementSalaryDays eq "">
	
	<cfquery name="Schedule" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   UPDATE  PersonEntitlement
	  SET      EntitlementSalaryDays = '1'
	  WHERE    PersonNo      = '#url.id#' 
	  AND      EntitlementId = '#url.id1#' 
	</cfquery> 
	
	<cf_tl id="Net days"> 

<cfelse>

		
	<cfquery name="Schedule" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  UPDATE  PersonEntitlement
	  SET      EntitlementSalaryDays = NULL
	  WHERE    PersonNo      = '#url.id#' 
	  AND      EntitlementId = '#url.id1#' 
	</cfquery>  
	
	<cf_tl id="Default">


</cfif>