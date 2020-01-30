
<cfquery name="Check" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Job
	WHERE  Mission     = '#URL.Mission#' 
	 AND   CaseNo = '#URL.CaseNo#'
	 AND   JobNo  != '#URL.JobNo#'
</cfquery>

<cfoutput>

<cfif check.recordcount gte "1">

	&nbsp;&nbsp;<font color="FF0000">[#URL.CaseNo#] in use</font>

<cfelse>
	
	&nbsp;&nbsp;<img src="#SESSION.root#/Images/check_icon.gif" alt="" border="0">
	
</cfif>

</cfoutput>
