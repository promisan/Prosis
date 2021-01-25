
<cfquery name="Header"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction# 
</cfquery>	

<!--- retrieve transaction --->

<cfparam name="url.mission"       default="">
<cfparam name="url.accountperiod" default="2010">

<table width="96%" class="formpadding">

<tr>
  <td style="padding-top:10px" class="labelmedium">This is a <b>preview</b> on how balance will be presented after this transaction is posted</td>
</tr>

<cfoutput>
<tr><td  class="labellarge">#url.accountPeriod#</td></tr>
</cfoutput>

<tr><td>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr class="line labelmedium2">
	<td colspan="2" style="padding:left:4px"><cf_tl id="Account"></td>
	<td colspan="2" bgcolor="ffffcf" align="center"><cf_tl id="Current Total"></td>
	<td colspan="2" align="center" bgcolor="EBF7FE"><cf_tl id="New Total"></td></tr>
</tr>

<tr class="line labelmedium2">
	<td style="padding:2px"></td>
	<td style="padding:2px"></td>
	<td style="padding:2px" align="right"><cf_space spaces="25"><cf_tl id="Debit"></td>
	<td style="padding:2px" align="right"><cf_space spaces="25"><cf_tl id="Credit"></td>
	<td style="padding:2px" align="right"><cf_space spaces="25"><cf_tl id="Debit"></td>
	<td style="padding:2px" align="right"><cf_space spaces="25"><cf_tl id="Credit"></td>
</tr>	

<cfquery name="Line"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   GLAccount, 
	         SUM(L.AmountBaseDebit) AS BaseDebit, 
			 SUM(L.AmountBaseCredit) AS BaseCredit
	FROM     #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# L
	GROUP BY GLAccount
</cfquery>	

<cfif line.recordcount eq "0">

<tr><td COLSPAN="6" align="center" height="30" class="labelmedium2"><cf_tl id="No transactions recorded"></td></tr>

</cfif>

<cfoutput query="Line">

<cfquery name="Account"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Account
	WHERE    GLAccount = '#GLAccount#'
</cfquery>	

<cfquery name="Curr"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   SUM(L.AmountBaseDebit)  AS BaseDebit, 
	         SUM(L.AmountBaseCredit) AS BaseCredit
	FROM     TransactionLine L INNER JOIN
	         TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
	WHERE    H.Mission       = '#url.mission#'
	AND      H.AccountPeriod = '#url.accountperiod#'        
	AND      H.ActionStatus != '9' 
	AND      H.RecordStatus != '9'
	AND      L.GLAccount     = '#GLAccount#'
	AND      H.TransactionId != '#Header.TransactionId#'
</cfquery>	

<tr class="labelmedium2 line">
   <td style="padding:2px;min-width:200px">#Account.GLAccount#</td>
   <td style="padding:2px">#Account.Description#</td>
   
   <cfif curr.basedebit eq "">
      <cfset currentdebit = 0>
   <cfelse>
      <cfset currentdebit = curr.basedebit>	  
   </cfif>
    <cfif curr.basecredit eq "">
      <cfset currentcredit = 0>
	 <cfelse>
      <cfset currentcredit = curr.basecredit>	    
   </cfif>
   
   <td style="padding:2px" align="right"><cfif Curr.BaseDebit gte Curr.BaseCredit>
          #numberFormat(currentdebit-currentcredit,",.__")#
       </cfif>
   </td>
   <td style="padding:2px" align="right">
	   <cfif Curr.BaseDebit lt Curr.BaseCredit>
          #numberFormat(currentcredit-currentdebit,",.__")#
       </cfif>
   </td>
   
   <cfset debit  = currentdebit+BaseDebit>
   <cfset credit = currentcredit+BaseCredit>
   
   <td style="padding:2px" align="right"><cfif Debit gte Credit>
          <font color="0080FF">#numberFormat(Debit-Credit,",.__")#
       </cfif>   
   </td>
   
   <td style="padding:2px" align="right"><cfif Debit lt Credit>
          <font color="0080FF">#numberFormat(Credit-Debit,",.__")#
       </cfif>   
   
   </td>
      
</tr>

</cfoutput>

</table>

</td></tr>

</table>