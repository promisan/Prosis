
<cfquery name="Amount" 
 datasource="AppsPurchase"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT *
 FROM  InvoiceFunding OA
 WHERE InvoiceId = '#URL.InvoiceId#'
 AND   FundingId = '#URL.FundingId#'
</cfquery>

<cfoutput>

	<input type="Text" 
	name="tagamount#URL.FundingId#" 
	id="tagamount#URL.FundingId#"
	value="#numberFormat(Amount.Amount,'__.__')#" 
	size="8" 
	style="text-align: right;" 
	class="regularh"
	onChange="ptoken.navigate('InvoiceMatchFundingSubmit.cfm?invoiceid=#url.invoiceid#&fundingid=#url.fundingid#&amount='+this.value,'funding')")>
		
</cfoutput>	


		

