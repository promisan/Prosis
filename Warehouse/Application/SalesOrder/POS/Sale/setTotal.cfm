<cfparam name="url.addressid"  default="00000000-0000-0000-0000-000000000000">

<!--- --------------------------------------------------------- --->
<!--- Ajax template template to update the totals in the screen --->
<!--- --------------------------------------------------------- --->

<cfquery name="getTotal"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT SUM((SchedulePrice - SalesPrice) * TransactionQuantity) AS Discount,
		       SUM(SalesAmount) AS Sales, 
		       SUM(SalesTax) AS Tax, 
			   SUM(SalesTotal) AS Total     

		FROM   Sale#URL.Warehouse# T
		WHERE  T.CustomerId      = '#url.customerid#'
		<cfif URL.addressId neq "00000000-0000-0000-0000-000000000000" AND URL.addressId neq "">
			AND T.AddressId = '#URL.addressId#'
		</cfif>			
				
</cfquery>

<cfquery name="getLines"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Sale#URL.Warehouse# T
		WHERE  T.CustomerId      = '#url.customerid#'
		<cfif URL.addressId neq "00000000-0000-0000-0000-000000000000"  AND URL.addressId neq "">
			AND T.AddressId = '#URL.addressId#'
		</cfif>			
</cfquery>

<!--- set the totals --->

<cfoutput>

<script language="JavaScript">

	<cfif getLines.recordcount eq "0">
		document.getElementById('tenderbutton').className = "hide"
	<cfelse>
	    document.getElementById('tenderbutton').className = "regular" 
	</cfif>
	
	<cfif getTotal.discount gte 0>
	    document.getElementById('discountbox').className =  'regular'
		document.getElementById('totaldiscount').innerHTML = '#numberformat(getTotal.Discount,'__,__.__')#'	
	<cfelse>
	    document.getElementById('discountbox').className =  'hide'
	    document.getElementById('totaldiscount').innerHTML = ''	
	</cfif>	
	document.getElementById('totalamount').innerHTML   = '#numberformat(getTotal.Sales,'__,__.__')#'
	document.getElementById('totaltax').innerHTML      = '#numberformat(getTotal.Tax,'__,__.__')#'
	document.getElementById('total').innerHTML         = '#numberformat(getTotal.Total,'__,__.__')#'

</script>

</cfoutput>