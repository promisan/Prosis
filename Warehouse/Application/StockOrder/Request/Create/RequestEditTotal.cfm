
<cfquery name="Total" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT sum(RequestedAmount) as Total 		      
	FROM  Request L, RequestHeader H
	WHERE L.Mission   = H.Mission
	AND   L.Reference = H.Reference
	AND   H.RequestHeaderId  = '#url.requestheaderid#' 		
	AND   L.Status < '8'
</cfquery>

<cfoutput>
#NumberFormat(Total.Total,'__,____.__')#
</cfoutput>
