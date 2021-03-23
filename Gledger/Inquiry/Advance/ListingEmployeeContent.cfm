
<cfoutput>

	<cfsavecontent variable="myquery">	
	
		SELECT *
		FROM (
			SELECT     P.PersonNo, 
				       P.IndexNo, 
					   P.LastName, 
					   P.FirstName, 
					   P.FullName,
					   P.Gender, 
					   P.Nationality, 
					   L.Currency, 
					   ROUND(SUM(L.AmountDebit), 2) AS Debit, 
			           ROUND(SUM(L.AmountCredit), 2) AS Credit, 
					   ROUND(SUM(L.AmountDebit) - SUM(L.AmountCredit), 2) AS Balance
			
			FROM       TransactionHeader AS H 
			           INNER JOIN TransactionLine AS L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo
					   INNER JOIN Employee.dbo.Person AS P ON H.ReferencePersonNo = P.PersonNo
					   			 
			WHERE      H.Mission = '#URL.Mission#' 
			AND        H.Journal IN           (SELECT  Journal
			                                   FROM    Journal
			                                   WHERE   SystemJournal = 'Advance') 
			
			AND        H.RecordStatus <> '9' 
			AND        H.ActionStatus <> '9'
			AND        H.ReferencePersonNo IN (SELECT     PersonNo
			                                   FROM       Employee.dbo.Person) 		
		
			AND        L.Currency = '#url.currency#'
			AND        L.GLAccount IN (SELECT  GLAccount 
			                           FROM    Ref_Account 
									   WHERE   AccountClass = 'Balance')
			AND        L.TransactionSerialNo = '0'
									   
			GROUP BY   P.PersonNo, 
			           P.IndexNo, 
					   P.FullName,
					   P.LastName, 
					   P.FirstName, 			 
					   P.Gender, 
					   P.Nationality, 
					   L.Currency		
			) as D
		WHERE 1=1	
		--condition
		
	
	</cfsavecontent>	
	
</cfoutput>				  

<cfset itm = "0">
				
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>

<cfset fields[itm] = {label    = "IndexNo",                    
					field      = "IndexNo",
					functionscript  = "EditPerson",
					functionfield   = "personno",
					search     = "text"}>

<cfset itm = itm+1>
					
<cfset fields[itm] = {label     = "Last name",                    
					field      = "FullName",
					width      = "90%", 
					filtermode = "1",
					search     = "text"}>					


<cfset itm = itm+1>
						
<cfset fields[itm] = {label    = "S", 					
					field      = "Gender",	
					column     = "common",				
					filtermode = "2",    
					search     = "text"}>		

<cfset itm = itm+1>
					
<cfset fields[itm] = {label      = "Nat.",    					
					field        = "Nationality",
					filtermode   = "2",					
					search       = "text"}>		

<!---					
<cfset fields[6] = {label      = "Account",    
					width      = "8%", 
					field      = "GLAccount",									
					search     = "text",
					filtermode = "2"}>						
					
--->		

			

<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "Issued",    
					width      = "160", 
					field      = "Debit",
					align      = "right",
					formatted  = "numberformat(Debit,',.__')"}>
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Offset",    
					width      = "160", 
					field      = "Credit",		
					align      = "right",			
					formatted  = "numberformat(Credit,',.__')"}>						
		

<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Balance",    
					width      = "160", 
					field      = "Balance",
					align      = "right",
					search     = "number",
					formatted  = "numberformat(Balance,',.__')"}>											

<cfset itm = itm+1>			
<cfset fields[itm] = {label      = "PersonNo",    
					width      = "1%", 
					Display    = "No",
					field      = "PersonNo"}>				
									
<cf_listing
    header         = "Finance"
    box            = "transaction"
	link           = "#SESSION.root#/GLedger/Inquiry/Advance/ListingEmployeeContent.cfm?mission=#url.mission#&currency=#url.currency#&area=#url.area#"
    html           = "No"
	show           = "40"
	datasource     = "AppsLedger"
	listquery      = "#myquery#"
	listkey        = "personNo"
	listorder      = "LastName"
	listorderdir   = "ASC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	filterShow     = "Yes"
	excelShow      = "Yes"
	drillmode      = "tab"
	drillargument  = "940;1000;false;false"	
	drilltemplate  = "Gledger/Application/lookup/AccountResult.cfm?mission=#url.mission#&currency=#url.currency#&account="
	drillkey       = "PersonNo">
	