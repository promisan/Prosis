
<!--- verification --->

<cfquery name="Journal"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  *
	FROM    Journal
	WHERE   Journal = '#URL.Journal#'  
</cfquery>	

<cfquery name="Check"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  *
	FROM    Ref_Account
	WHERE   GLAccount = '#URL.entryglaccount#'  
</cfquery>	

<cfif check.forceCurrency neq "">
  <cfset url.currency = Check.ForceCurrency>
</cfif>

<cfset err = 0>

<cfsavecontent variable="error">		
	
	<cfif not LSIsNumeric(URL.itemquantity) and url.TransactionType eq "item">
	  <tr><td class="labelmedium" style="padding:3px">Incorrect quantity entered : <cfoutput>#URL.itemquantity#</cfoutput></td></tr>
	  <cfset err = 1>
	</cfif>	
	
	<cfif not LSIsNumeric(URL.entryamount)>
	  <tr><td class="labelmedium" style="padding:3px">Incorrect amount entered : <cfoutput>#URL.entryamount#</cfoutput></td></tr>
	  <cfset err = 1>
	</cfif>	
	
	<cfif URL.entryGLAccount eq "">
	  <tr><td class="labelmedium" style="padding:3px">No Account defined</td></tr> 
	   <cfset err = 1>
	</cfif>
	
	<cfif check.ForceProgram eq "1" and URL.ProgramCode1 eq "">
     <tr><td class="labelmedium" style="padding:3px">No Program/Project selected</td></tr>  
	  <cfset err = 1>
	</cfif>
	
</cfsavecontent>

<cfif err eq 1>

    <script>
	 Prosis.busy('no')
	</script>
    
	<table width="100%" cellspacing="0" border="0" cellpadding="0" class="formpadding">
	<tr><td  class="labelmedium" style="padding:3px"><font color="FF0000"><b><cf_tl id="Attention">:</b> <cf_tl id="The following data entries error were detected">:</td></tr>	
      <cfoutput>#error#</cfoutput>	
	</table>
    <cfabort>
	
</cfif>
<cfset url.entryamount = replace(url.entryamount,',','',"ALL")>
<cfset url.itemquantity = replace(url.itemquantity,',','',"ALL")>

<cfset whsqty = replace(url.itemquantity,',','',"ALL")>
<cfset traamt = replace(url.entryamount,',','',"ALL")>

<cfset jrnamt = url.entryamount/url.jrnexc>
<cfset basamt = url.entryamount/url.basexc>

<cfif URL.entrydebitcredit is "Debit">
	  <cfset debit      = replace("#jrnamt#",",","","ALL")>
	  <cfset credit     = 0>
	  <cfset debitbase  = replace("#basamt#",",","","ALL")>
	  <cfset creditbase = 0>
<cfelse>
	  <cfset credit      = replace("#jrnamt#",",","","ALL")>
	  <cfset debit       = 0>
	  <cfset creditbase  = replace("#basamt#",",","","ALL")>
	  <cfset debitbase = 0>  
</cfif>

<cfif url.mode eq "edit">

	<cfquery name="Clear" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE 	FROM 	#SESSION.acc#GLedgerLine_#client.sessionNo#
	WHERE 	TransactionSerialNo = '#URL.serialNo#'
	</cfquery>
	
</cfif>

<cfquery name="Prior" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT MAX(TransactionSerialNo) as Last
	FROM   #SESSION.acc#GLedgerLine_#client.sessionNo#
</cfquery>

<cfset SerNo = 1>

<cfif URL.serialNo neq "" and url.mode eq "Edit">

    <cfset SerNo  = URL.serialNo>
	<cfset Jrnser = URL.JournalSerialNo>
	
<cfelse>	
		
	<cfoutput query = "Prior">
	  <cfif Last neq "">
	     <cfset SerNo = Last+1>
	  </cfif>	 
	</cfoutput>
	<cfset Jrnser = 0>

</cfif>

<cfquery name="Journ"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT  *
	FROM    Journal J
	WHERE   Journal = '#URL.Journal#' 
</cfquery>	

<cfset cat =  Journ.TransactionCategory>

<cfif URL.TaxCode is "00" or URL.Taxcode is "">
   
   <cfset TaxAccount = "">
   
<cfelse>
	
	<cfquery name="TaxSel" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Ref_Tax 
		WHERE  TaxCode = '#URL.TaxCode#'
	</cfquery>
			
	<cfoutput query="TaxSel">
	
	    <cfif TaxCalculation is "Inclusive">
	
	      <cfset Taxdebit       = #debit# - (#debit# * 1/(1+(#Percentage#)))>
	      <cfset Taxcredit      = #credit# - (#credit# * 1/(1+(#Percentage#)))>
	      <cfset Taxdebitbase   = #debitbase# - (#debitbase# * 1/(1+(#Percentage#)))>
	      <cfset Taxcreditbase  = #creditbase# - (#creditbase# * 1/(1+(#Percentage#)))>
	      	 
		<cfelse>
	 
	      <cfset Taxdebit       = #debit#      * (#Percentage#)>
	      <cfset Taxcredit      = #credit#     * (#Percentage#)>
	      <cfset Taxdebitbase   = #debitbase#  * (#Percentage#)>
	      <cfset Taxcreditbase  = #creditbase# * (#Percentage#)>
	 
		</cfif>
	 
		<cfif cat neq "Receivables">
	 	    <cfset TaxAccount   = GLaccountPaid>
		<cfelse>
	 	    <cfset TaxAccount   = GLaccountReceived> 
		</cfif> 	 
		
		<cfif TaxRounding is 1>
		
		   <cfset TaxDebit      = Round(TaxDebit*100)/100>
		   <cfset TaxCredit     = Round(TaxCredit*100)/100>
		   <cfset TaxDebitBase  = Round(TaxDebitBase*100)/100>
		   <cfset TaxCreditBase = Round(TaxCreditBase*100)/100>		
		
		<cfelse>
		
		   <cfset TaxDebit      = Int(TaxDebit*100)/100>
		   <cfset TaxCredit     = Int(TaxCredit*100)/100>
		   <cfset TaxDebitBase  = Int(TaxDebitBase*100)/100>
		   <cfset TaxCreditBase = Int(TaxCreditBase*100)/100>				
		
		</cfif>
		
		<!--- correction in case of a markdown of the tax to complement the amount --->
		
		<cfif TaxCalculation is "Inclusive">
		 	      
	      <cfset debit          = debit      - Taxdebit>
	      <cfset credit         = credit     - Taxcredit>
	      <cfset debitbase      = debitbase  - Taxdebitbase>
	      <cfset creditbase     = creditbase - Taxcreditbase>	 		  
			 
		</cfif>
		
		<cfset debit          = Round(Debit*100)/100>
	    <cfset credit         = Round(Credit*100)/100>
	    <cfset debitbase      = Round(DebitBase*100)/100>
	    <cfset creditbase     = Round(CreditBase*100)/100>	 
			
	</cfoutput>

</cfif>

<cfquery name="HeaderSelect"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM #SESSION.acc#GledgerHeader_#client.sessionNo#
</cfquery>

<cfif url.programcode1 eq "">
   <cfset url.fund1 = "">
</cfif>

<cf_assignId>
		
<!--- regular entry --->

<cfparam name="URL.entryreference"     default="">
<cfparam name="URL.entryreferenceName" default="">

<cfif Check.AccountClass eq "Result">
	 
	<cfset dateValue = "">
	<cfif url.transactiondate neq "">
		<CF_DateConvert Value = "#url.transactiondate#">
	<cfelse>
		<CF_DateConvert Value = "#dateformat(now(),client.dateformatshow)#">
	</cfif>	
	<cfset STR = dateValue>

</cfif>

<cfquery name="Insert" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#
	   (Journal,
	   JournalSerialNo,
	   TransactionSerialNo, 
	   TransactionLineId, 
	   ParentLineId,
	   ReconciliationPointer,
	   GLAccount,
	   Memo,
	   OrgUnit,
	   ProgramCode,
	   ProgramCodeProvider,
	   ContributionLineId,
	   Fund,
	   ObjectCode,
	   AccountPeriod,
	   <cfif Check.AccountClass eq "Result">
	   TransactionDate,
	   </cfif>
	   TransactionType,
	   Reference, 
	   ReferenceName,
	   <cfif url.TransactionType eq "item">
	   Warehouse,
	   WarehouseItemNo,
	   WarehouseItemUoM,
	   WarehouseQuantity,	   
	   </cfif> 
	   TransactionCurrency,
	   TransactionAmount,
	   ExchangeRate,
	   Currency,	   	   
	   AmountDebit,
	   AmountCredit,
	   ExchangeRateBase,
	   AmountBaseDebit,
	   AmountBaseCredit,
	   TransactionTaxCode,    
	   ParentJournal,
	   ParentJournalSerialNo,	
	   ParentTransactionId,	  
	   Created)
	VALUES 
	   ('#URL.Journal#',
	   '#jrnser#',
	   '#SerNo#', 
	   '#rowguid#',
	   <cfif url.ParentLineId neq "">
	   '#url.ParentLineId#',
	   <cfelse>
	   NULL,
	   </cfif>
	   '0',
	   '#URL.entryglaccount#',
	   '#URL.memo#',
	   '#URL.OrgUnit1#',
	   
	   '#URL.ProgramCode1#',
	   '#URL.ProgramCode2#',
	     <cfif url.contributionLineId eq "">
	  NULL,
	  <cfelse>
	  '#URL.ContributionLineId#',
	  </cfif>
	   '#URL.Fund1#',
	   '#url.Object1#',
	   '#URL.AccountPeriod#',
	   
	   <cfif Check.AccountClass eq "Result">
	   #str#,
	   </cfif>
	  
	   '#URL.TransactionType#',
	   '#URL.entryreference#',
	   '#URL.entryreferenceName#',
	   <cfif url.TransactionType eq "item">
	   '#url.Warehouse#',
	   '#url.ItemNo#',
	   '#url.ItemUoM#',
	   '#url.ItemQuantity#',
	   </cfif>	  
	   '#URL.currency#',
	   '#NumberFormat(TraAmt,'.__')#',
	   '#URL.jrnexc#',
	   '#journ.currency#',
	   <cfif Journal.SystemJournal eq "ExchangeRate">
	   '0',
	   '0',
	   <cfelse>
	   '#debit#', 
	   '#credit#',
	   </cfif>
	   '#URL.basexc#', 
	   '#debitbase#',
	   '#creditbase#',
	   '#URL.TaxCode#',
	   
	   <cfif url.parenttransactionid neq "00000000-0000-0000-0000-000000000000" and url.parenttransactionid neq "">	
	   	   				   
			<cfquery name="get"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM TransactionHeader
				WHERE TransactionId = '#url.parenttransactionid#'
			</cfquery>
	   	     
	   '#get.Journal#','#get.JournalSerialNo#','#url.parenttransactionid#',
	   
	   <cfelse>
	   NULL,NULL,'{00000000-0000-0000-0000-000000000000}',
	   </cfif>
	  
	   getdate())
</cfquery>

<cfif TaxAccount neq "">

<!--- tax entry --->

	
   <cfset traamt = abs(taxdebit - taxcredit)>

   <cfquery name="Insert" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT INTO dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#
      (Journal,
      JournalSerialNo,
      TransactionSerialNo, 
	  TransactionLineId,
	  ReconciliationPointer,
      GLAccount,
      Memo,
      OrgUnit,
	  ProgramCode,
	  ProgramCodeProvider,
	  ContributionLineId,
      AccountPeriod,
	  <cfif Check.AccountClass eq "Result">
	  TransactionDate,
	  </cfif>
      TransactionType,
      Reference, 
	  ReferenceName,
      TransactionCurrency,
      TransactionAmount,
      ExchangeRate,
      Currency,
      AmountDebit,
      AmountCredit,
      ExchangeRateBase,
      AmountBaseDebit,
      AmountBaseCredit,
      TransactionTaxCode,	
	  ParentJournal,
	  ParentJournalSerialNo,	
	  ParentTransactionId,	
	  <!--- 
	  ParentTransactionId,  
	  <cfif HeaderSelect.ParentJournal neq "">	  	  
		  ParentJournal,
	      ParentJournalSerialNo,
	  </cfif>
	  --->
	  Created)
   VALUES 
      ('#URL.Journal#',
      '#jrnser#',
      '#SerNo#',
	  newid(),
	  '0',
      '#TaxAccount#',
      '#URL.memo#',
      '#URL.OrgUnit1#',
	  '#URL.ProgramCode1#',
	  '#URL.ProgramCode2#',
	  <cfif url.contributionLineId eq "">
	  NULL,
	  <cfelse>
	  '#URL.ContributionLineId#',
	  </cfif>
      '#URL.AccountPeriod#',
	  <cfif Check.AccountClass eq "Result">
	   #str#,
	  </cfif>	  
      '#URL.TransactionType#',
      '#URL.entryreference#',
	  '#URL.entryReferenceName#',
      '#URL.currency#',
      '#TraAmt#',
      '#URL.jrnexc#',
	  '#journ.currency#',
	   <cfif Journal.SystemJournal eq "ExchangeRate">
	   '0',
	   '0',
	   <cfelse>
      '#taxdebit#',
      '#taxcredit#',
	  </cfif>
      '#URL.basexc#',
      '#taxdebitbase#',
      '#taxcreditbase#',
      '#URL.TaxCode#',
	  
	  <cfif url.parenttransactionid neq "00000000-0000-0000-0000-000000000000" and url.parenttransactionid neq "">	 	   
				   
			<cfquery name="get"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM TransactionHeader
				WHERE TransactionId = '#url.parenttransactionid#'
			</cfquery>
	   	     
	   '#get.Journal#','#get.JournalSerialNo#','#url.parenttransactionid#',
	   
	   <cfelse>
	   NULL,NULL,'{00000000-0000-0000-0000-000000000000}',
	   </cfif>
	  
	  <!---
	  
	  '{00000000-0000-0000-0000-000000000000}',
	   <cfif HeaderSelect.ParentJournal neq "">	  	  
		  '#HeaderSelect.ParentJournal#',
		  '#HeaderSelect.ParentJournalSerialNo#',
	  </cfif>
	  --->
	  
	  getdate())
   </cfquery>

</cfif>


<cfinclude template="TransactionDetailLines.cfm">

<script>
    document.getElementById("entryamount").value = "";
	document.getElementById("entryamtjrn").value = "";
	document.getElementById("entryamtbase").value = "";
	Prosis.busy('no')
</script>