
<!--- set status --->

<cfquery name="get" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    PersonMiscellaneous P, Ref_PayrollItem R
	WHERE   P.PayrollItem = R.PayrollItem	
	AND     CostId   = '#URL.ajaxid#'
</cfquery>

<cfif     get.Status eq "2"><font color="008000">Cleared
<cfelseif get.Status eq "3"><font color="008000">Cleared
<cfelseif get.Status eq "5"><font color="008000">Paid
<cfelse>Pending</cfif>
