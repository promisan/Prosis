
<cfif url.mode eq "AP">
	<cf_ViewTopMenu background="gray" label="Financials #URL.Mission# Accounts Payable">
<cfelse>
    <cf_ViewTopMenu background="gray" label="Financials #URL.Mission# Accounts Receivable">
</cfif>	

	  