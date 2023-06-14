
<cfif url.mode eq "AD">
    <cf_ViewTopMenu background="gray" label="Financials #URL.Mission# Advances">
<cfelseif url.mode eq "AP">
	<cf_ViewTopMenu background="gray" label="Financials #URL.Mission# Accounts Payable">
<cfelse>
    <cf_ViewTopMenu background="gray" label="Financials #URL.Mission# Accounts Receivable">
</cfif>	

	  