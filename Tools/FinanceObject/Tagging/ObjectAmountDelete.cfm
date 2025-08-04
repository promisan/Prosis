<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
	





		

