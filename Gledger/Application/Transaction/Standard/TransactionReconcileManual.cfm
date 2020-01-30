
<!--- Select select reconciliation lines --->
<cfquery name="Reset"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  UPDATE   TransactionLine 
  SET      ReconciliationPointer = 1,
           ReconciliationPointerDate = getDate()
  WHERE    TransactionLineId IN (#preserveSingleQuotes(URL.sel)#) 
</cfquery>

<cfinclude template="TransactionDetailLines.cfm">

