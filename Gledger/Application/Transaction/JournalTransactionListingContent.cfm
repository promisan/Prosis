
<cfoutput>
	
	<!--- pass the result to the script --->
	<cfsavecontent variable="myquery">				
				
			SELECT     L.Journal, 
			           L.JournalSerialNo, 
					   L.TransactionSerialNo, 
					   L.GLAccount, 
					   L.TransactionLineId, 
					   L.JournalTransactionNo, 
					   L.Memo, 
					   L.OrgUnit, 
					   L.OrgUnitProvider, 
					   L.Fund, 
					   L.ProgramCode, 
			           L.ProgramCodeProvider, 
					   L.ProgramPeriod, 
					   L.ObjectCode, 
					   C.Reference as ContributionReference,
					   L.ContributionLineId, 
					   L.AccountPeriod, 
					   L.TransactionDate, 
					   L.TransactionType, 
					   L.Reference as TransactionReference, 
					   Pe.Reference,
					   L.ReferenceName, 
					   L.ReferenceNo, 
			           L.ReferenceId, 
					   L.ReferenceIdParam, 
					   L.Warehouse, 
					   L.WarehouseItemNo, 
					   L.WarehouseItemUoM, 
					   L.WarehouseQuantity, 
					   L.TransactionCurrency, 
					   L.TransactionAmount, 
			           L.TransactionTaxCode, 
					   L.ExchangeRate, 
					   L.Currency, 
					   L.AmountDebit, 
					   L.AmountCredit, 
					   L.ExchangeRateBase, 
					   L.AmountBaseDebit, 
					   L.AmountBaseCredit, 
					   L.ParentJournal, 
			           L.ParentJournalSerialNo, L.OfficerUserId, L.OfficerLastName, L.OfficerFirstName, L.Created
				
			<!--- attention this is not correct as the period in ProgramPeriod = plan period and not the execution period
			so we need to link this first to MissionPeriod and then to PlanPeriod found there --->
					   
			FROM       TransactionLine AS L 
					   INNER JOIN TransactionHeader H ON H.Journal = L.Journal and H.JournalSerialNo = L.JournalSerialNo
					   LEFT OUTER JOIN Program.dbo.ProgramPeriod AS Pe ON L.ProgramPeriod = Pe.Period AND L.ProgramCode = Pe.ProgramCode
					   LEFT OUTER JOIN
                       Program.dbo.Contributionline AS C ON C.ContributionLineId = L.ContributionLineId
			
			WHERE     H.Journal       = '#url.journal#' 
			AND       H.AccountPeriod = '#url.period#'
			AND       H.ActionStatus != '9'
			AND       H.RecordStatus != '9'
		
	</cfsavecontent>

</cfoutput>
	
<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "No",                   
					field      = "JournalSerialNo",
					filtermode = "1",
					search     = "text"}>
		

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Date",                   
					field      = "TransactionDate",					
					formatted  = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search     = "date"}>		
							
								
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Account",                    
					field      = "GLAccount",
					filtermode = "2",
					labelfilter = "GL Account",
					search     = "text"}>
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "Fund", 					
					field      = "Fund",					
					filtermode = "2",    
					search     = "text"}>							
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label      = "Object", 					
					field      = "ObjectCode",					
					filtermode = "2",    
					search     = "text"}>						

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Program",                   
					field      = "Reference",	
					alias      = "Pe",
					filtermode = "2",	
					searchfield = "Reference",
					searchalias = "Pe",			
					search     = "text"}>						
									
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Period",  					
					field      = "ProgramPeriod",										
					filtermode = "2",				
					search     = "text"}>
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Donor",  					
					field       = "ContributionReference",	
					searchalias = "C",
					searchfield = "Reference",									
					filtermode  = "2",				
					search      = "text"}>
													
					
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Cur.",   					
					field      = "Currency",					
					labelfilter = "Currency"}>	
															
<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "Debit",  
					field      = "AmountDebit",
					<!--- search     = "number", --->
					aggregate  = "sum",
					align      = "right",
					formatted  = "numberformat(AmountDebit,',.__')"}>	
					
<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "Credit",  
					field      = "AmountCredit",
					<!--- search     = "number", ---> 
					aggregate  = "sum",
					align      = "right",
					formatted  = "numberformat(AmountCredit,',.__')"}>						
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Id",    					
					display    = "No",					
					field      = "TransactionLineId"}>		
	
	
<cftry>

<!---
<cf_wfpending entityCode="ProcInvoice"  
      table="#SESSION.acc#wfInvoice" mailfields="No" IncludeCompleted="No">							--->
							
<cf_listing
    header        = "lsTransaction"
    box           = "lsTransaction"
	link          = "#SESSION.root#/Gledger/Application/Transaction/JournalTransactionListingContent.cfm?#cgi.query_string#"
    html          = "No"
	show          = "42"
	datasource    = "AppsLedger"
	listquery     = "#myquery#"
	listkey       = "TransactionLineId"		
	listorder     = "JournalSerialNo"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	annotation    = "GLTransaction"
	drillmode     = "securewindow"
	drillargument = "1040;#client.widthfull#;false;false"	
	drilltemplate = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
	drillkey      = "TransactionLineId">
	
	<cfcatch>
	
	 <cf_message width="100%"
			height="80"
			message="An error has occurred retrieving your data <br>#CFCatch.Message# - #CFCATCH.Detail#" return="no">
	
	</cfcatch>		
	
</cftry>	