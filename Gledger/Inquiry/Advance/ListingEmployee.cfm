
<!--- 
1. define the selection date from the mandate
2. show people
--->

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" scroll="no"> 

<cf_ListingScript>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_Advance">	

<cf_dialogstaffing>

<cfquery name="DataSet" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     P.PersonNo, 
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
	INTO       userQuery.dbo.#SESSION.acc#_Advance		   
	FROM       TransactionHeader as H INNER JOIN TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo 
	           INNER JOIN Employee.dbo.PersonGLedger AS PL ON L.GLAccount = PL.GLAccount 
			   INNER JOIN Employee.dbo.Person AS P ON PL.PersonNo = P.PersonNo
	WHERE     (L.Currency = '#url.currency#') AND (PL.Area = '#url.area#') 
	AND        H.Mission = '#URL.Mission#'
	AND        H.Journal NOT IN (SELECT Journal FROM Journal WHERE SystemJournal = 'Opening')
    GROUP BY   P.PersonNo, 
	           P.IndexNo, 
			   P.LastName, 
			   P.FirstName, 
			   PL.GLAccount, 
			   P.Gender, 
			   P.Nationality, 
			   L.Currency		
</cfquery>
	
<cfinclude template="ListingEmployeeContent.cfm">
