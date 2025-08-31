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
<cfoutput>
	
	<!--- pass the result to the script --->
	<cfsavecontent variable="myquery">		
			
	    SELECT *, TransactionDate
		FROM (		
				
			SELECT     L.Journal, 
			           L.JournalSerialNo, 
					   L.TransactionSerialNo, 
					   L.GLAccount+' '+R.Description as Account,
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
					   <!---
					   (SELECT Reference
					    FROM  Program.dbo.Contributionline Pe
						WHERE L.ProgramPeriod = Pe.Period AND L.ProgramCode = Pe.ProgramCode) as Contribution,										   
						--->
					   L.ContributionLineId, 
					   L.AccountPeriod, 
					   L.TransactionDate, 
					   L.TransactionType, 
					   L.Reference as TransactionReference, 
					   <!---
					   (SELECT Reference
					    FROM   Program.dbo.ProgramPeriod Pe
						WHERE  L.ProgramPeriod = Pe.Period AND L.ProgramCode = Pe.ProgramCode) as Reference,					   
						--->
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
					   INNER JOIN Ref_Account R ON L.GLAccount = R.GLAccount 
					   			
			WHERE     H.Journal       = '#url.journal#' 
			AND       H.AccountPeriod = '#url.period#'
			AND       H.ActionStatus != '9'
			AND       H.RecordStatus != '9'
			
			) as D
			
			WHERE 1=1 --condition
					
	</cfsavecontent>

</cfoutput>
	
<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "No",                   
					field      = "JournalSerialNo",
					filtermode = "2",
					search     = "text"}>
		

<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Date",                   
					field      = "TransactionDate",								
					column     = "month",	
					formatted  = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search     = "date"}>		
							
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Account",                    
					field      = "Account",
					filtermode = "2",
					labelfilter = "Account",
					search     = "text"}>	
													
	
				
<cfset itm = itm+1>					
<cfset fields[itm] = {label      = "Reference",                    
					field      = "TransactionReference",					
					labelfilter = "Reference",
					search     = "text"}>	

<!---										
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
--->

<!---					
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
					
--->						
						
<cfset itm = itm+1>								
<cfset fields[itm] = {label      = "Cur.",   					
					field      = "Currency",					
					labelfilter = "Currency"}>	
															
<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "Debit",  
					field      = "AmountDebit",
					<!--- search     = "number", --->
					aggregate  = "sum",
					width      = "30",
					align      = "right",
					formatted  = "numberformat(AmountDebit,',.__')"}>	
					
<cfset itm = itm+1>										
<cfset fields[itm] = {label      = "Credit",  
					field      = "AmountCredit",
					<!--- search     = "number", ---> 
					aggregate  = "sum",
					align      = "right",
					width      = "30",
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
    header        = "Line#url.journal#"
    box           = "Line#url.journal#"
	link          = "#SESSION.root#/Gledger/Application/Transaction/Listing/ListingLineContent.cfm?#cgi.query_string#"
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
	drillargument = "1030;#client.widthfull#;false;false"	
	drilltemplate = "Gledger/Application/Transaction/View/TransactionView.cfm?id="
	drillkey      = "TransactionLineId">
	
	<cfcatch>
	
	 <cf_message width="100%"
			height="80"
			message="An error has occurred retrieving your data <br>#CFCatch.Message# - #CFCATCH.Detail#" return="no">
	
	</cfcatch>		
	
</cftry>	