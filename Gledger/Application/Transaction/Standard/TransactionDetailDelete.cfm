
<cfquery name="Delete" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM #SESSION.acc#GLedgerLine_#client.sessionNo#
	WHERE  TransactionSerialNo = '#URL.ID#'
</cfquery>

<cfinclude template="TransactionDetailLines.cfm">







