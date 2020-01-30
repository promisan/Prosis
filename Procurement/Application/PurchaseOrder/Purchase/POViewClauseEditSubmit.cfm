
<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE PurchaseClause
SET ClauseName       = '#Form.ClauseName#', 
    ClauseText       = '#Form.ClauseText#',
	OfficerUserId    = '#SESSION.acc#',
	OfficerLastName  = '#SESSION.last#',
	OfficerFirstName = '#SESSION.first#',
	Created          = getdate()	
WHERE  ClauseCode = '#URL.ClauseCode#' 
AND    PurchaseNo = '#URL.PurchaseNo#'

</cfquery>

<cfoutput>
<script>

if ('#url.mode#' == 'view') {
	parent.opener.ColdFusion.navigate('POViewClauseView.cfm?PurchaseNo=#URL.PurchaseNo#&ClauseCode=#URL.ClauseCode#','cl#URL.ClauseCode#')										
	}
parent.window.close()

</script>
</cfoutput>
