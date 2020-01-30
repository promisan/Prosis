
<cfquery name="Reset" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE #SESSION.acc#GLedgerLine_#client.sessionNo#
	SET GLAccount = '#url.contraglaccount#'
	WHERE  TransactionSerialNo = '0'
</cfquery>

<cfinclude template="TransactionDetailLines.cfm">







