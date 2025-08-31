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
<cfset err = 0>

<cfsavecontent variable="error">			
	<cfif not LSIsNumeric(Form.Amount)>
	  <tr><td>- Incorrect amount entered : <cfoutput>#Form.amount#</cfoutput></td></tr>
	  <cfset err = 1>
	</cfif>	
	<cfif Form.GLAccount eq "">
	  <tr><td>- No Account defined</td></tr> 
	   <cfset err = 1>
	</cfif>
	<!---
	<cfif check.ForceProgram eq "1" and URL.ProgramCode1 eq "">
     <tr><td>- No Program/Project selected</td></tr>  
	  <cfset err = 1>
	</cfif>
	--->
</cfsavecontent>

<cfif err eq 1>
    
	<table width="100%" cellspacing="0" border="0" cellpadding="0" class="formpadding">
	<tr><td class="labelit"><font color="FF0000"><b><cf_tl id="Attention">:</b> <cf_tl id="The following data entries error were detected">:</td></tr>	
      <cfoutput>#error#</cfoutput>	
	</table>
    <cfabort>
	
</cfif>

<cfset amt = replace(form.amount,',','',"ALL")>
 
<cfquery name="PO"
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Purchase
		WHERE  PurchaseNo = '#URL.ID#'				
	</cfquery>	
	
<cfif PO.OrgUnitVendor neq "">
	
	<cfquery name="Purchase"
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT P.*, O.OrgUnitName as Beneficiary
		FROM   Purchase P, Organization.dbo.Organization O
		WHERE  P.OrgUnitVendor = O.OrgUnit
		AND    P.PurchaseNo = '#URL.ID#'				
	</cfquery>	
	
<cfelse>

	<cfquery name="Purchase"
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT P.*, O.FirstName+ ' '+O.LastName as Beneficiary
		FROM   Purchase P, 
		       Employee.dbo.Person O
		WHERE  P.PersonNo = O.PersonNo
		AND    P.PurchaseNo = '#URL.ID#'				
	</cfquery>	

</cfif>	
	
<!--- header --->
	 
<cfquery name="Parameter" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      Ref_ParameterMission
		WHERE     Mission = '#Purchase.Mission#'
</cfquery>
	
<cfquery name="Per" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       Organization.dbo.Ref_MissionPeriod
		WHERE      Mission = '#Purchase.Mission#'
		AND        Period  = '#Purchase.Period#'
</cfquery> 
			
<cfif Per.AccountPeriod neq "">
     <cfset accperiod = "#Per.AccountPeriod#">
<cfelse>
     <cfset accperiod = "#Parameter.CurrentAccountPeriod#">
</cfif>		

<cfquery name="accountperiod" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       Period
		WHERE      AccountPeriod  = '#accperiod#'
</cfquery> 

<cfif accountperiod.actionstatus eq "1">
		<!--- we take default --->
		<cfset accperiod = parameter.CurrentAccountPeriod>
</cfif>

<!--- check if Journal exists for invoice currency --->

<cfquery name="Issued" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Purchase.dbo.PurchaseLine
	WHERE   PurchaseNo = '#URL.ID#'
</cfquery>			

<cfquery name="Journal" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    J.*, JA.GLAccount as AssociatedGLAccount
	FROM      Journal  J
			  INNER JOIN JournalAccount JA
				ON J.Journal = JA.Journal AND JA.ListDefault = '1'
	WHERE     Mission       = '#Purchase.Mission#' 
	AND       SystemJournal = 'Advance'
	AND       Currency      = '#Form.Currency#' 
</cfquery>
		
<cfif Journal.recordcount eq "0">
			
	<!--- if not then journal for the PO currency --->
	
	<cfquery name="Journal" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT    J.*, JA.GLAccount as AssociatedGLAccount
		FROM      Journal J
				  INNER JOIN JournalAccount JA
					ON J.Journal = JA.Journal AND JA.ListDefault = '1'
		WHERE     Mission       = '#Purchase.Mission#' 
		AND       SystemJournal = 'Advance'      <!--- change to advance --->
		AND       Currency      = '#Issued.Currency#'  
	</cfquery> 

</cfif>

<cfif Journal.AssociatedGLAccount neq "">

	<cfset vAccount = Journal.AssociatedGLAccount>	
	
<cfelse>

	<cfoutput>
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td class="labelit">Account for Advance journal for currency: #Issued.Currency# has not been declared for #Purchase.Mission#. Operation not allowed.</td></tr>	
    </table>
	</cfoutput>
    <cfabort>		
	
</cfif>

<cfif Journal.recordcount eq "0">
	<cfoutput>
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td class="labelit">A Procurement Advance journal for currency: #Issued.Currency# has not been declared for #Purchase.Mission#. Operation not allowed.</td></tr>	
    </table>
	</cfoutput>
    <cfabort>
		
</cfif>  

<cfif PO.OrgUnitVendor neq "">
	<cfset org = Purchase.OrgUnit>
	<cfset per = "">
<cfelse>
    <cfset org = "">
	<cfset per = Purchase.PersonNo>
</cfif>	

<cfquery name="Lines" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		SELECT   H.Journal,
		         H.JournalSerialNo,
				 H.JournalTransactionNo, 
		         H.Description, 
				 H.Reference, 
				 H.TransactionId,
				 H.TransactionDate, 
				 TL.Currency, 
				 TL.AmountDebit, 
				 TL.AmountCredit, 
				 TL.GLAccount,
				 H.ReferenceName, 
				 H.ReferenceNo,
				 H.ActionStatus,
				 H.OfficerFirstName,
				 H.OfficerLastName
		FROM     TransactionHeader H INNER JOIN
		         TransactionLine TL ON H.Journal = TL.Journal AND H.JournalSerialNo = TL.JournalSerialNo
		WHERE    H.Reference            = 'Advance' 
		AND      H.ReferenceNo          = '#URL.ID#' 
		AND      TL.TransactionSerialNo != '0'
		ORDER BY H.TransactionDate
</cfquery>

<cfif Lines.recordcount eq "0">		
	
	<cftransaction>
							
	<cf_GledgerEntryHeader
		Mission               = "#Purchase.Mission#"
		OrgUnitOwner          = "#Purchase.OrgUnit#"
		Journal               = "#Journal.Journal#"
		JournalTransactionNo  = "#Purchase.PurchaseNo#"
		Description           = "#Form.ReferenceName#"
		TransactionSource     = "PurchaseSeries"
		TransactionSourceNo   = "#Purchase.PurchaseNo#"
		AccountPeriod         = "#accperiod#"
		TransactionCategory   = "Payables"
		MatchingRequired      = "1"
		ActionStatus          = "1"
		ReferenceOrgUnit      = "#org#"
		ReferencePersonNo     = "#per#"
		Reference             = "Advance"       
		ReferenceName         = "#Purchase.Beneficiary#"	
		ReferenceNo           = "#Form.ReferenceNo#"
		DocumentCurrency      = "#Form.Currency#"
		DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#"
		DocumentAmount        = "#Amt#"
		ParentJournal         = ""
		ParentJournalSerialNo = "">
				
	<!--- Lines - advance itself --->	 
					
	<cf_GledgerEntryLine
		Lines                 = "2"
	    Journal               = "#Journal.Journal#"
		JournalNo             = "#JournalSerialNo#"
		AccountPeriod         = "#accperiod#"
		ExchangeRate          = "1"
		Currency              = "#Form.Currency#"
		
		TransactionSerialNo1  = "1"
		Class1                = "Debit"
		Reference1            = "Advance"       
		ReferenceName1        = "#Form.ReferenceName#"
		Description1          = "#Form.Memo#"
		GLAccount1            = "#Form.GLAccount#"
		Costcenter1           = "#Purchase.OrgUnit#"
		ProgramCode1          = ""
		ProgramPeriod1        = ""		
		ReferenceNo1          = "#Purchase.PurchaseNo#"
		TransactionType1      = "Standard"
		Amount1               = "#amt#"		
		
		TransactionSerialNo2  = "0"		
		Class2                = "Credit"
		Reference2            = "Advance"       
		ReferenceName2        = "#Form.ReferenceName#"
		Description2          = "#Form.Memo#"
		GLAccount2            = "#vAccount#"
		Costcenter2           = "#Purchase.OrgUnit#"
		ProgramCode2          = ""
		ProgramPeriod2        = ""		
		ReferenceNo2          = "#Purchase.PurchaseNo#"
		TransactionType2      = "Standard"
		Amount2               = "#amt#">
	
	</cftransaction>
	
</cfif>
	
<cfoutput>	
<script language="JavaScript">
    parent.parent.ProsisUI.closeWindow('myadvance',true)
	parent.parent.requestadvancerefresh('#URL.ID#')
</script>	
</cfoutput>	

