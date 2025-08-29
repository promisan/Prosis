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
<cfset ARCur = getAR.Currency >

<cfset stop = "0">

<cfloop index="id" list="#Form.Advances#">


	<cfset offset = evaluate("Form.Off_#left(id,8)#")>
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
		
		<!---pointing to the Exchange rate typed by the user in cased it was updated, otherwise will take the one System provided from the tool ------>
		<cfset exchange = evaluate("Form.exc_#left(id,8)#")>			
		<cfset exchange = replaceNoCase(exchange,",","","ALL")> 
		<cfset erate 	= 1/exchange>
		

		<!------
		<cfif getAR.currency neq get.currency>
			<cf_exchangeRate currencyFrom = "#getAR.currency#" currencyTo = "#get.currency#">
			<cfset erate1 = exc>
		<cfelse>
			<cfset erate1 = 1>   
		</cfif> 
		  ----->

		<cfset thisOutstanding = get.AmountOutstanding * erate>
		<cfset thisOutstanding = numberFormat(thisOutstanding, ',.__')>
		<cfset thisOutstanding = replaceNoCase(thisOutstanding,",","","ALL")>

		<cfif thisOutstanding lt offset>		
			<cfset stop = "1">		
		</cfif>
		
		<cfset amt = amt - offset>
			
		<cfif abs(amt) lt 0.00>		
			<cfset stop = "1">				
		</cfif>
		
	</cfif>		

</cfloop>

<cfif stop eq "1">

	<table>
	   <tr><td align="center" class="labelmedium"><font color="FF0000">You have selected incorrect amounts to be offsetted</font></td></tr>
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
				     WHERE  Journal = '#getAdvance.Journal#'	  
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
						Journal               = "#getAdvance.Journal#" 
						Description           = "Offset AP with advance"										
						TransactionCategory   = "#getAdvance.TransactionCategory#"	
						TransactionDate       = "#postDate#"								
						DocumentDate       	  = "#postDate#"									
						AccountPeriod      	  = "#year(postDate)#"
						MatchingRequired      = "0"		
						ActionStatus          = "0"			
						Reference             = "Offset"       
						ReferenceName         = "#getAdvance.ReferenceName#"
						ReferenceOrgUnit      = "#getAdvance.ReferenceOrgUnit#"										
						DocumentCurrency      = "#getAR.Currency#"	
						DocumentAmount        = "#offset#"
						AmountOutstanding     = "0">						
																																					 
							<cf_GledgerEntryLine
							    DataSource            = "AppsLedger"
								Lines                 = "1"							
								Journal               = "#getAdvance.Journal#"
								JournalNo             = "#JournalTransactionNo#"	
								ParentJournal         = "#getAdvance.Journal#"
								ParentJournalSerialNo = "#getAdvance.JournalSerialNo#"	
								ParentLineId          = "#getAdvanceLine.TransactionLineId#"														
								Currency			  = "#getAdvance.Currency#"
								DocumentCurrency      = "#getAdvance.Currency#"
								TransactionDate       = "#postDate#"
								BaseExchangeRate      = "#1/exchange#"
																										
								TransactionSerialNo1  = "0"
								Class1                = "Credit"
								Reference1            = "Offset"       
								ReferenceName1        = "#getAdvance.ReferenceName#"
								Description1          = ""
								GLAccount1            = "#getAdvanceLine.GLAccount#"							
								TransactionType1      = "Standard"
								Amount1               = "#offset#">							
								
							<cf_GledgerEntryLine
							    DataSource            = "AppsLedger"
								Lines                 = "1"							
								Journal               = "#getAdvance.Journal#"
								JournalNo             = "#JournalTransactionNo#"	
								ParentJournal         = "#getAR.Journal#"
								ParentJournalSerialNo = "#getAR.JournalSerialNo#"	
								ParentLineId          = "#getARLine.TransactionLineId#"											
								Currency			  = "#getAdvance.Currency#"
								DocumentCurrency      = "#getAR.Currency#"
								TransactionDate       = "#postDate#"
								BaseExchangeRate      = "#1/exchange#"
																										
								TransactionSerialNo1  = "0"
								Class1                = "Debit"
								Reference1            = "Offset AP"       
								ReferenceName1        = "#getAdvance.ReferenceName#"
								Description1          = ""
								GLAccount1            = "#getARLine.GLAccount#"							
								TransactionType1      = "Standard"
								Amount1               = "#offset#">	
								
													
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

