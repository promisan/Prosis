<!--
    Copyright © 2025 Promisan B.V.

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
<!--- 
1. define the selection date from the mandate
2. show people
--->

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" scroll="no"> 

<cf_ListingScript>

<cf_dialogstaffing>

<!--- we adjusted this to no longer rely on a GLAccount per person, but use the PersonNo instead 

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_Advance">	

<cfquery name="DataSet" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    P.PersonNo, 
	          P.IndexNo, 
			  P.LastName, 
			  P.FirstName, 
			  PL.GLAccount, 
			  P.Gender, 
			  P.Nationality, 
			  L.Currency, 
			  ROUND(SUM(L.AmountDebit), 2) AS Debit, 
              ROUND(SUM(L.AmountCredit), 2) AS Credit, 
			  ROUND(SUM(L.AmountDebit) - SUM(L.AmountCredit), 2) AS Balance
	INTO      userQuery.dbo.#SESSION.acc#_Advance		   
	FROM      TransactionHeader as H INNER JOIN TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo 
	          INNER JOIN Employee.dbo.PersonGLedger AS PL ON L.GLAccount = PL.GLAccount 
			  INNER JOIN Employee.dbo.Person AS P ON PL.PersonNo = P.PersonNo
	WHERE     (L.Currency = '#url.currency#') AND (PL.Area = '#url.area#') 
	AND       H.Mission = '#URL.Mission#'
	AND       H.Journal NOT IN (SELECT Journal FROM Journal WHERE SystemJournal = 'Opening')
    GROUP BY  P.PersonNo, 
	          P.IndexNo, 
			  P.LastName, 
			  P.FirstName, 
			  PL.GLAccount, 
			  P.Gender, 
			  P.Nationality, 
			  L.Currency		
</cfquery>


SELECT     P.PersonNo, 
	       P.IndexNo, 
		   P.LastName, 
		   P.FirstName, 
		   P.Gender, 
		   P.Nationality, 
		   L.Currency, 
		   ROUND(SUM(L.AmountDebit), 2) AS Debit, 
           ROUND(SUM(L.AmountCredit), 2) AS Credit, 
		   ROUND(SUM(L.AmountDebit) - SUM(L.AmountCredit), 2) AS Balance

FROM       TransactionHeader AS H 
           INNER JOIN TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
		   INNER JOIN Employee.dbo.Person AS P ON H.ReferencePersonNo = P.PersonNo			 
WHERE      H.ReferencePersonNo IN (SELECT     PersonNo
                                   FROM       Employee.dbo.Person) 
AND        H.Journal IN           (SELECT  Journal
                                   FROM    Journal
                                   WHERE   SystemJournal = 'Advance') 
AND        H.Mission = '#URL.Mission#' 
AND        H.RecordStatus <> '9' 
AND        H.ActionStatus <> '9'
AND        L.Currency = '#url.currency#'
 GROUP BY  P.PersonNo, 
	          P.IndexNo, 
			  P.LastName, 
			  P.FirstName, 			 
			  P.Gender, 
			  P.Nationality, 
			  L.Currency		
			  
--->			  
	
<cfinclude template="ListingEmployeeContent.cfm">
