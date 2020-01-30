
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   PurchaseClause
WHERE  ClauseCode = '#URL.ClauseCode#' 
AND    PurchaseNo = '#URL.PurchaseNo#'
</cfquery>

<cfoutput query="Get">#ClauseText#</cfoutput>