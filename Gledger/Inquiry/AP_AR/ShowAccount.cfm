
<cfparam name="CLIENT.payables" default="">
<cfparam name="Form.Period" default="">

<cfquery name="Last"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     TransactionHeader WITH(NOLOCK)
	WHERE    Mission = '#url.mission#'
	AND      Journal IN (SELECT Journal FROM Journal WITH(NOLOCK) WHERE SystemJournal = 'Opening')
	ORDER BY AccountPeriod DESC
</cfquery>

<cfif Last.AccountPeriod eq "">
	
	<cfquery name="Last"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM   Period WITH(NOLOCK)
		WHERE   ActionStatus = '0'
		ORDER BY PeriodDateEnd 
	</cfquery>
	
</cfif>

<cfif url.mode eq "AP">   
	<cfset journalfilter = "'Payables'">
<cfelse>
    <cfset journalfilter = "'Receivables'">	
</cfif>	


<cfquery name="Accounts"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT     L.GLAccount, 	
			   R.Description,	
			   R.AccountType,
			   SUM(AmountDebit-AmountCredit) as Amount,	   			   
			   SUM(AmountBaseDebit-AmountBaseCredit) as AmountBase
			   
	FROM       TransactionLine L WITH(NOLOCK) INNER JOIN
			   TransactionHeader H  WITH(NOLOCK) ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo INNER JOIN 
			   Journal J  WITH(NOLOCK) ON J.Journal = H.Journal INNER JOIN 
			   Ref_Account R  WITH(NOLOCK) ON L.GLAccount = R.GLAccount
						   
	WHERE      H.Mission       = '#url.mission#' 		
	AND        H.ActionStatus IN ('0','1')
	AND        H.RecordStatus != '9'		
	AND        J.GLCategory    = 'Actuals'	
	AND        H.AccountPeriod = '#last.AccountPeriod#'	
	AND        L.GLAccount IN (SELECT GLAccount
	                           FROM   Ref_Account WITH(NOLOCK)
							   WHERE  Operational = 1
							   <cfif url.mode eq "AR">  
								AND        AccountClass       = 'Balance'
								AND        AccountType        = 'Debit'   
								AND        ((R.BankReconciliation = 1 AND R.AccountCategory IN ('Vendor','Neutral')) OR R.AccountCategory = 'Vendor')
							  <cfelse>	
								AND        AccountClass       = 'Balance'
								AND        AccountType        = 'Credit' 
								AND        AccountCategory    = 'Customer'
							  </cfif>)	
							   		
	GROUP BY   L.GLAccount,R.Description, R.AccountType				   
	ORDER BY   L.GLAccount,R.Description		
					 		   
</cfquery>		

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>
--->

<table width="97%" cellspacing="0" cellpadding="0" align="center" bgcolor="fafafa" class="navigation_table formpadding">

<tr><td colspan="4" height="20" class="labelmedium"><cf_tl id="Source of Running balance"><cfoutput>#Last.AccountPeriod#</cfoutput></td></tr>	

<tr class="labelmedium" bgcolor="f4f4f4">
    <td></td>
	<td style="padding-left:4px;border:1px solid silver"><cf_tl id="No"></td>
	<td style="padding-left:4px;border:1px solid silver"><cf_tl id="Account"></td>			
	<td style="padding-right:4px;border:1px solid silver" align="right"><cf_tl id="Base"></td>	
</tr>

<cfoutput query="Accounts">
	
	<tr class="navigation_row navigation_action line labelmedium" onclick="gldetail('#glaccount#')">
	    <td style="padding-left:4px;padding-top:4px">
		 <cf_img icon="select">
		</td>
	    <td width="25%" style="padding-left:4px">#GLAccount# [#left(accounttype,1)#]</td>
		<td width="45%" style="padding-left:4px">#Description#</td>		
		<!---	
		<td class="labelit" style="border:1px solid silver;padding-right:4px" align="right">#Currency# <cfif amountbase lt 0><font color="blue">(#numberformat(amount*-1,'__,__')#)</font><cfelse>#numberformat(amount,'__,__')#</cfif></td>			
		--->
		<td style="padding-right:4px" align="right"><cfif amountbase lt 0><font color="blue">(#numberformat(amountBase*-1,',.__')#)</font><cfelse>#numberformat(amountBase,',__.__')#</cfif></td>	
	</tr>

</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>

