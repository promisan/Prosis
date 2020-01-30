
<cfquery name="Lines"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    TransactionLine
	WHERE   Journal         = '#url.journal#' 
	AND     JournalSerialNo = '#url.journalserialNo#'
    AND     GLAccount      != '#url.glaccount#'
</cfquery>	

<!--- show other lines of that transaction --->

<table width="100%" cellspacing="0" cellpadding="0">
<cfoutput query="Lines">
	<tr>
		<td width="50" class="labelit">#currentrow#.</td>
		<td width="70%" class="labelit">#Reference# #Memo#</td>
		<td width="30" class="labelit">#currency#</td>
		<td width="100" class="labelit" align="right">#numberformat(amountDebit,"__,__.__")#</td>
		<td width="100" class="labelit" align="right">#numberformat(amountCredit,"__,__.__")#</td>
	</tr>
</cfoutput>	
</table>