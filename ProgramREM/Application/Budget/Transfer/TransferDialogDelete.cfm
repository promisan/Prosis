
<cfquery name="Delete" 
     datasource="AppsQuery" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE FROM dbo.#SESSION.acc#BudgetTransfer_#client.sessionNo# 
	 WHERE SerialNo = '#URL.SerialNo#'
</cfquery>

<cfoutput>
<script>
	ptoken.navigate('TransferDialogLines.cfm?mission=#url.mission#&actionclass=#url.actionclass#&program=#url.program#&direction=#url.direction#&editionid=#url.editionid#&period=#url.period#&resource=#url.resource#','lines#url.direction#')
</script>
</cfoutput>
