
<cfquery name="Total" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT sum(RequestedAmount) as Total FROM Request	
	WHERE  Status = '#URL.Status#'
	AND    Mission = '#URL.Mission#'
	AND    OfficerUserId = '#SESSION.acc#' 
</cfquery>

<cfoutput>
#NumberFormat(Total.Total,'__,____.__')#
</cfoutput>
