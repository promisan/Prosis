

<!--- process offset 

1.	loop through the amount and check if the amount is equal or smaller then the pending
2.	Create transaction(s) under the advance selected with cross reference.
3.	Apply the balances and Refresh the screen

--->

<cf_TransactionOutstanding 
	    journal="#url.journal#" 
	    journalserialNo="#url.journalserialNo#">

 <cfquery name="getAR"
   datasource="AppsLedger" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
     SELECT *
	 FROM   TransactionHeader
     WHERE  Journal = '#url.journal#'
	 AND    JournalSerialNo = '#url.JournalSerialNo#'	 
</cfquery>

<cfquery name="getARLine"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	     SELECT *
		 FROM   TransactionLine
	     WHERE  Journal = '#url.journal#'
		 AND    JournalSerialNo = '#url.JournalSerialNo#'	
		 AND    TransactionSerialNo = '0'
</cfquery>

<cfset amt = getAR.AmountOutstanding>

<cfset stop = "0">

<cfloop index="id" list="#Form.Advances#">
	
	<cfset offset = evaluate("Form.off_#left(id,8)#")>
	<cfset offset = replaceNoCase(offset,",","","ALL")> 	
	
	<cfif LSIsNumeric(offset) and offset gt 0> 
					
		<cf_TransactionOutstanding 
		      transactionid="#id#">
			
		<cfquery name="get"
		   datasource="AppsLedger" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		     SELECT *
			 FROM   TransactionHeader
		     WHERE  TransactionId = '#id#'	 
		</cfquery>	
		
		<cfset jou = get.Journal>
						
		<cfquery name="getJournal"
		   datasource="AppsLedger" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		     SELECT *
			 FROM   Journal
		     WHERE  Mission = '#get.Mission#'
			 AND    Currency = '#get.Currency#'
			 AND    SystemJournal = 'Offset'
		</cfquery>
		
		<!--- dedicated journal --->
		
		<cfif getJournal.recordcount eq "1">
		
			<cfset jou = getJournal.Journal>
					
		</cfif>
		
		<cfif getAR.currency neq get.currency>
		
			<!----
			<cf_exchangeRate currencyFrom = "#getAR.currency#" currencyTo = "#get.currency#">
			<cfset erate = exc>
			--->			
			<cfset exchange = evaluate("Form.exc_#left(id,8)#")>			
			<cfset exchange = replaceNoCase(exchange,",","","ALL")> 			
			<cfset erate = 1/exchange>
			
		<cfelse>
		
			<cfset erate = 1>   
			
		</cfif> 

		<cfset thisOutstanding 	= get.AmountOutstanding * erate>
		<cfset thisOutstanding 	= numberFormat(thisOutstanding, ',.__')>
		<cfset thisOutstanding  = replaceNoCase(thisOutstanding,",","","ALL")> 	

		<cfif thisOutstanding lt offset>		
			<cfset stop = "1">		
		</cfif>

		<cfoutput>
			offset:#offset#
			amt:#amt#
			stop:#stop#
			thisOutstanding:#thisOutstanding#
			get.AmountOutstanding: #get.AmountOutstanding#
		</cfoutput>

		<cfset amt 	= amt - offset>
		<cfset amt 	= numberFormat(amt, ',.__')>
		<cfset amt  = replaceNoCase(amt,",","","ALL")> 


		<cfif abs(amt) lt 0.00>
			<cfset stop = "1">				
		</cfif>	
		
	</cfif>		

</cfloop>

<cfif stop eq "1">

	<table>
	   <tr><td align="center" class="labelmedium"><font color="FF0000">You have selected incorrect amounts to be offsetted...</font></td></tr>
   </table>

<cfelse>
		<cfset indexadvance=0>
		
		<cfloop index="id" list="#Form.Advances#">
		
		<cfset indexadvance	= indexadvance+1>
		<cfset postDate 	= evaluate("Form.postingdate_#indexadvance#")>
		
			<cfset amount   = evaluate("Form.amt_#left(id,8)#")>			
			<cfset amount   = replaceNoCase(amount,",","","ALL")> 
			
			<cfset amount = round(amount*100)/100>
			
			<cfset exchange = evaluate("Form.exc_#left(id,8)#")>			
			<cfset exchange = replaceNoCase(exchange,",","","ALL")> 
					
			<cfset offset   = evaluate("Form.off_#left(id,8)#")>			
			<cfset offset   = replaceNoCase(offset,",","","ALL")> 
			
			<cfset offset = round(offset*100)/100>
			
			<cfif LSIsNumeric(offset) and offset gt 0> 
					
				<cfquery name="getAdvance"
				   datasource="AppsLedger" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				     SELECT *
					 FROM   TransactionHeader
				     WHERE  TransactionId = '#id#'	  
				</cfquery>
				
				<cfquery name="getAdvanceLine"
				   datasource="AppsLedger" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				     SELECT *
					 FROM   TransactionLine
				     WHERE  Journal         = '#getAdvance.Journal#'	  
					 AND    JournalSerialNo = '#getAdvance.JournalSerialNo#'
					 AND    TransactionSerialNo = '0'
				</cfquery>
												
				<!--- create header --->
					
				<!--- create advance balance --->
					
				<!--- create invoice balance --->
											
				<cf_GledgerEntryHeader
					    DataSource            = "AppsLedger"
						Mission               = "#getAdvance.Mission#"
						OrgUnitOwner          = "#getAdvance.OrgUnitOwner#"
						Journal               = "#jou#" 
						Description           = "Offset AR with advance"										
						TransactionCategory   = "#getAdvance.TransactionCategory#"		
						TransactionDate       = "#postDate#"								
						DocumentDate       	  = "#postDate#"
						AccountPeriod      	  = "#year(postDate)#"
						MatchingRequired      = "0"		
						ActionStatus          = "0"			
						Reference             = "Offset"       
						ReferenceName         = "#getAdvance.ReferenceName#"
						ReferenceOrgUnit      = "#getAdvance.ReferenceOrgUnit#"										
						DocumentCurrency      = "#getAdvance.Currency#"					
						DocumentAmount        = "#amount#"
						AmountOutstanding     = "0">						
																																					 
						<cf_GledgerEntryLine
						    DataSource            = "AppsLedger"
							Lines                 = "1"							
							Journal               = "#jou#"
							JournalNo             = "#JournalTransactionNo#"	
							ParentJournal         = "#getAdvance.Journal#"
							ParentJournalSerialNo = "#getAdvance.JournalSerialNo#"	
							ParentLineId          = "#getAdvanceLine.TransactionLineId#"														
							Currency              = "#getAdvance.Currency#"
							TransactionDate       = "#postDate#"
																									
							TransactionSerialNo1  = "0"
							Class1                = "Debit"
							Reference1            = "Offset"       
							ReferenceName1        = "#getAdvance.ReferenceName#"
							Description1          = ""
							GLAccount1            = "#getAdvanceLine.GLAccount#"							
							TransactionType1      = "Standard"
							Amount1               = "#amount#">							
							
						<cf_GledgerEntryLine
						    DataSource            = "AppsLedger"
							Lines                 = "1"							
							Journal               = "#jou#"
							JournalNo             = "#JournalTransactionNo#"	
							ParentJournal         = "#getAR.Journal#"
							ParentJournalSerialNo = "#getAR.JournalSerialNo#"	
							ParentLineId          = "#getARLine.TransactionLineId#"											
							Currency              = "#getAdvance.Currency#"
							DocumentCurrency      = "#getAR.Currency#"
							ExchangeRate          = "#1/exchange#"
							AmountCurrency        = "#getAdvance.Currency#"	
							TransactionDate       = "#postDate#"
																									
							TransactionSerialNo1  = "0"
							Class1                = "Credit"
							Reference1            = "Offset AR"       
							ReferenceName1        = "#getAdvance.ReferenceName#"
							Description1          = ""
							GLAccount1            = "#getARLine.GLAccount#"							
							TransactionType1      = "Standard"							
							TransactionAmount1    = "#offset#"												
							Amount1               = "#amount#">																							
								
				<cf_TransactionOutstanding 
				    journal="#url.journal#" 
				    journalserialNo="#url.journalserialNo#">	
						
				<cf_TransactionOutstanding 
				    journal="#getAdvance.journal#" 
				    journalserialNo="#getAdvance.journalserialNo#">				
												
			</cfif>		
		
		</cfloop>
	
	    <script>
	
		   history.go()
	
	    </script>

</cfif>

