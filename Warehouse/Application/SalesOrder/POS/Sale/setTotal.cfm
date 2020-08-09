<cfparam name="url.requestno"  default="0">

<!--- --------------------------------------------------------- --->
<!--- Ajax template template to update the totals in the screen --->
<!--- --------------------------------------------------------- --->

<cfquery name="getTotal"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT SUM((SchedulePrice - SalesPrice) * TransactionQuantity) AS Discount,
		       SUM(SalesAmount) AS Sales, 
		       SUM(SalesTax) AS Tax, 
			   SUM(SalesTotal) AS Total     

		FROM   CustomerRequestLine
		WHERE  RequestNo = '#url.requestNo#'
						
</cfquery>

<cfquery name="getLines"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   CustomerRequestLine
		WHERE  RequestNo = '#url.requestNo#'
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
		document.getElementById('totaldiscount').innerHTML = '#numberformat(getTotal.Discount,',.__')#'	
	<cfelse>
	    document.getElementById('discountbox').className =  'hide'
	    document.getElementById('totaldiscount').innerHTML = ''	
	</cfif>	
	document.getElementById('totalamount').innerHTML   = '#numberformat(getTotal.Sales,',.__')#'
	document.getElementById('totaltax').innerHTML      = '#numberformat(getTotal.Tax,',.__')#'
	document.getElementById('total').innerHTML         = '#numberformat(getTotal.Total,',.__')#'

</script>

</cfoutput>