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
<cfset amt        = replace("#Form.discountamount#",",","","ALL")>

<cfif not LSIsNumeric(amt)>
	
	<script>
	    Prosis.busy('no')
	    alert('Incorrect discount amount')
	</script>	 		
	
	<cfabort>	
	
</cfif>

<cfquery name="get"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   TransactionHeader
		WHERE  Journal = '#url.journal#'
		AND    JournalSerialNo = '#url.journalserialno#'		
</cfquery>

<cfoutput>
<cf_tl id="Amounts exceeds the outstanding amount" var="mes">

<cfif amt gt get.AmountOutstanding>

	<script>
	    Prosis.busy('no')
	    alert('#mes#')
	</script>	 		
	
	<cfabort>	

</cfif>

</cfoutput>

<!--- create discount header which offset --->

<cf_GledgerEntryHeader
    Mission               = "#get.Mission#"
	DataSource            = "AppsLedger"
    OrgUnitOwner          = "#get.OrgUnitOwner#"
    Journal               = "#form.Journal#"						
	Description           = "#form.Description#"
	TransactionSource     = "AccountSeries"			
	AccountPeriod         = "#Form.AccountPeriod#"			 
	TransactionCategory   = "Receivables"
	MatchingRequired      = "0"
	ActionStatus          = "0"
	Workflow              = "Yes"
	ReferenceOrgUnit      = "#get.ReferenceOrgUnit#"  <!--- customer orgunit --->		
	Reference             = "Discount"       
	ReferenceName         = "#get.ReferenceName#"  <!--- customer name --->			
	ReferencePersonNo     = "#get.ReferencePersonNo#"  <!--- usually the person responsible for the sales workorder --->			
	ReferenceNo           = "#Form.reference#" <!--- order reference --->					
	DocumentCurrency      = "#get.DocumentCurrency#"
	TransactionDate       = "#Form.TransactionDate#"
	DocumentDate          = "#Form.TransactionDate#"
	DocumentAmount        = "#amt#"
	DocumentAmountVerbal  = "1"											
	ActionCode            = "Invoice"
	ActionReference1      = "#form.ActionReference2#"
	ActionReference2      = "#form.ActionReference1#">

<!--- create lines in the reverse --->
<cfset thisAmount = amt>
<cfset ratio = amt / get.amount>

<cfquery name="getlines"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   TransactionLine TL INNER JOIN
                         Ref_Account AS R ON TL.GLAccount = R.GLAccount
		WHERE  Journal         = '#url.journal#'
		AND    JournalSerialNo = '#url.journalserialno#'	
</cfquery>
<cfset serno = JournalTransactionno>

<cfquery name="getT"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   TransactionHeader
		WHERE  Journal         = '#url.journal#'
		AND    JournalSerialNo = '#url.journalserialno#'	
</cfquery>


<cfloop query="getLines">

	<cfif getT.TransactionCategory eq "Receivables">
			
	     <cfif AccountClass eq "Result" and form.GLAccount neq "">
		    <cfset gla = form.GLAccount>
		<cfelse>
			<cfset gla = glaccount>
		</cfif>
		
	<cfelse><!----- payable --->
		
		<cfif (getLines.reference eq  "Invoice" and getLines.AmountDEbit gt 0) or (getLines.reference eq "Receipt" and getLines.AmountDEbit gt 0)>
		    <cfset gla = form.GLAccount>
		<cfelse>
			<cfset gla = glaccount>
		</cfif>
		
	</cfif>

	<cfif amountDebit gt "0">
		
		<cfset amt = amountDebit * ratio>	
		<cfset class = "Credit">
	
	<cfelse>
	
		<cfset amt = AmountCredit * ratio>
		<cfset class = "Debit">
	
	</cfif>	

	<cfset thisCurr = getLines.Currency>
		
	<cfif TransactionSerialNo eq 0>
	
			<cf_GledgerEntryLine
				Lines                    = "1"
				DataSource               = "AppsOrganization"
			    Journal                  = "#Form.Journal#"
				JournalNo                = "#serno#"
				TransactionDate          = "#Form.TransactionDate#"
				AccountPeriod            = "#Form.AccountPeriod#"		
				Currency                 = "#Currency#"		
				ParentLineId			 = "#TransactionLineId#"
				
				TransactionSerialNo1     = "#TransactionSerialNo#"
				Class1                   = "#class#"
				Reference1               = "Receivable"       
				ReferenceName1           = "#get.ReferenceName#"  <!--- customer name --->
				Description1             = ""
				GLAccount1               = "#gla#"
				Fund1                    = "#Fund#"		
				Costcenter1              = "#OrgUnit#"
				ActivityId1              = "#ActivityId#"
				ObjectCode1              = "#ObjectCode#"
				ContributionLineId       = "#ContributionlineId#"
				ProgramCode1             = "#ProgramCode#"
				ProgramPeriod1           = "#ProgramPeriod#"		
				ParentJournal            = "#url.journal#"
				ParentJournalSerialNo    = "#url.JournalSerialNo#"			
				TransactionType1         = "#TransactionType#"
				Amount1                  = "#amt#">
				
			<cfelse>
			
				<cf_GledgerEntryLine
					Lines                    = "1"
					DataSource               = "AppsOrganization"
				    Journal                  = "#Form.Journal#"
					JournalNo                = "#serno#"
					TransactionDate          = "#Form.TransactionDate#"
					AccountPeriod            = "#Form.AccountPeriod#"		
					Currency                 = "#Currency#"		
					
					TransactionSerialNo1     = "#TransactionSerialNo#"
					Class1                   = "#class#"
					Reference1               = "Receivable"       
					ReferenceName1           = "#get.ReferenceName#"  <!--- customer name --->
					Description1             = ""
					GLAccount1               = "#gla#"
					Fund1                    = "#Fund#"		
					Costcenter1              = "#OrgUnit#"
					ActivityId1              = "#ActivityId#"
					ObjectCode1              = "#ObjectCode#"
					ContributionLineId       = "#ContributionlineId#"
					ProgramCode1             = "#ProgramCode#"
					ProgramPeriod1           = "#ProgramPeriod#"		
					ParentJournal            = "#url.journal#"
					ParentJournalSerialNo    = "#url.JournalSerialNo#"			
					TransactionType1         = "#TransactionType#"
					Amount1                  = "#amt#">

		</cfif>

		
</cfloop>


<!--- check the amount and apply the transaction in the reverse pro-rata with cross reference --->

<script>
    opener.history.go()
	window.close()
</script>