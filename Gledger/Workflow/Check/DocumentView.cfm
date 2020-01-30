

<!--- show the document --->

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    TransactionIssuedCheck
	WHERE   TransactionCheckId = '#actionid#'
</cfquery>

<cfoutput>
<table width="95%" align="right">
<tr class="labelmedium line" style="height:20px">
<td><cf_tl id="CheckNo">:</td><td style="font-size:16px">#Check.CheckNo#</td>
<td><cf_tl id="Payee">:</td><td style="font-size:16px">#Check.CheckPayee#</td>
<td><cf_tl id="Date">:</td><td style="font-size:16px">#dateformat(Check.CheckDate,client.dateformatshow)#</td>
</tr>
<tr class="labelmedium" style="height:20px">
    <td><cf_tl id="Amount">:</td><td colspan="3" style="font-size:16px">#Check.CheckAmountText# (#check.CheckAmount#)</td>
    <td><cf_tl id="Memo">:</td><td>#Check.CheckMemo#</td>
</tr>
</table>
</cfoutput>