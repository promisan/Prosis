
<cfquery name="Init" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*
FROM   Ref_AccountReceipt G, Ref_Account A
WHERE G.Fund = '#URL.Fund#'
AND   G.ObjectCode = '#URL.ObjectCode#'
AND   G.GLAccount = A.GLAccount
</cfquery>

<cfoutput>
#Init.GLAccount# #Init.Description#
</cfoutput>