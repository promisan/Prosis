
<cfquery name="Init" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_AccountReceipt
SET GLAccount = NULL
WHERE Fund = '#URL.Fund#'
AND ObjectCode = '#URL.ObjectCode#'
</cfquery>

<cfoutput>
<a href="javascript:selectaccount('#url.Fund#','#url.ObjectCode#')"><font color="FF0000">Click here to associate</a></font>
</cfoutput>