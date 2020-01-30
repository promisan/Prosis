
<cfquery name="Amount" 
 datasource="AppsLedger"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   Currency,
          Sum(amount) as Amount
 FROM     FinancialObjectAmount OA
 WHERE    OA.Objectid = '#URL.ObjectId#'
 GROUP BY Currency
</cfquery>

<cfquery name="DeleteRecord" 
 datasource="AppsLedger"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 DELETE FROM FinancialObjectAmount
 WHERE Objectid = '#URL.ObjectId#'
 AND   SerialNo = '#URL.SerialNo#' 
</cfquery>

<cfquery name="Set" 
 datasource="AppsLedger"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 UPDATE FinancialObjectAmount
 SET    AmountManual = 0
 WHERE  Objectid = '#URL.ObjectId#' 
 AND    SerialNo < #URL.SerialNo#
</cfquery>

<cfquery name="Object" 
 datasource="AppsLedger"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM  FinancialObject
 WHERE Objectid = '#URL.ObjectId#' 
</cfquery>


 <cf_ObjectListing 
    TableWidth       = "100%"
    EntityCode       = "#Object.EntityCode#"
	ObjectReference  = "#Object.ObjectReference#"
	ObjectKey        = "#url.key#"
	Label            = "#URL.Lbl#"    
	Entry            = "#URL.mode#"
	Mission          = "#Object.Mission#"
	Amount           = "#Amount.Amount#" 
	Currency         = "#Amount.Currency#">
	





		

