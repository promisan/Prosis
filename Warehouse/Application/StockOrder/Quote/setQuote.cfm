
<cfswitch expression="#url.action#">

<cfcase value="deleteline">

	<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   CustomerRequestLine
		WHERE  TransactionId = '#url.transactionid#'					
	</cfquery>

	<cfquery name="delete"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   CustomerRequestLine
		WHERE  TransactionId = '#url.transactionid#'					
	</cfquery>
				
	<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT   sum(SalesAmount) as Amount,
			         sum(SalesTax)    as Tax,
					 sum(SalesTotal)  as Total				
			FROM     CustomerRequestLine
			WHERE    RequestNo       = '#get.RequestNo#'						
	</cfquery>
		
	<!--- Set the total amount --->
	
	<cfoutput>
	
	<script>	      
	    $(".line#url.transactionid# tr").each(function() {$(this).remove();});
		document.getElementById('qteamount').innerHTML = "#numberformat(get.Amount,',.__')#"   	
		document.getElementById('qtetax').innerHTML    = "#numberformat(get.Tax,',.__')#" 
		document.getElementById('qtetotal').innerHTML  = "#numberformat(get.Total,',.__')#" 		
	</script>
	
	</cfoutput>
	<!--- remove line visually --->
				
</cfcase>


<cfcase value="mutation">

	<cfset transactionid = url.requestno>

    <cfset qty = url.val>
	
	<cfif LSIsNumeric(qty)>
	
	<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   CustomerRequestLine
		WHERE  TransactionId = '#transactionid#'					
	</cfquery>
	
	<cfif abs(qty) gte "2">
	     <cfset qty = qty>
	<cfelse>
	     <cfset qty = get.TransactionQuantity+qty>
	</cfif>
    			
	<cfset price = get.SalesPrice>
	<cfset tax   = get.TaxPercentage>
			
	<cfif get.TaxIncluded eq "0">
							   
		<cfset amountsle  = price * qty>
		<cfset amounttax  = (tax * price) * qty>	
			
	<cfelse>				
				
		<cfset amounttax  = ((tax/(1+tax))*price)*qty>	
		<!--- <cfset amountsle = ((1/(1+tax))*price)*qty> --->
		<!--- changed way of calculating amountsle as otherwise sometimes we have .01 data loss ---->
		<cfset amountsle  = (price * qty) - amounttax>	
		
	</cfif>
	
	<cfif qty neq "0">	
		<cfset unitprice = amountsle / qty>
	<cfelse>
		<cfset unitprice = 0>
	</cfif>
	
	<cfif get.TaxExemption eq "1">
	  <cfset amounttax = 0>
	</cfif>

	<cfquery name="setLine"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE CustomerRequestLine 
		SET    TransactionQuantity = #qty#,
			   SalesUnitPrice      = '#unitprice#',	
		       SalesAmount         = '#amountsle#',
			   SalesTax            = '#amounttax#'				   
		WHERE  TransactionId       = '#transactionid#'		
	</cfquery>
	
	<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT   sum(SalesAmount) as Amount,
			         sum(SalesTax)    as Tax,
					 sum(SalesTotal)  as Total				
			FROM     CustomerRequestLine
			WHERE    RequestNo       = '#get.RequestNo#'						
	</cfquery>
		
	<!--- Set the total amount --->
	
	<cfoutput>
	
	<script>	 
	    document.getElementById('qty#transactionid#').value = "#qty#"
	    document.getElementById('value#transactionid#').innerHTML = "#numberformat(amountsle,',.__')#"        	   
		document.getElementById('qteamount').innerHTML = "#numberformat(get.Amount,',.__')#"   	
		document.getElementById('qtetax').innerHTML    = "#numberformat(get.Tax,',.__')#" 
		document.getElementById('qtetotal').innerHTML  = "#numberformat(get.Total,',.__')#" 		
	</script>
	
	</cfoutput>
	
	</cfif>

</cfcase>


<cfcase value="class">

	<cfquery name="set"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE CustomerRequest
		SET   RequestClass = '#form.RequestClass#'
		WHERE RequestNo = '#url.requestno#'				
	</cfquery>
	
</cfcase>


<cfcase value="warehouse">

	<cfquery name="set"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE CustomerRequest
		SET   Warehouse = '#form.warehousequote#'
		WHERE RequestNo = '#url.requestno#'				
	</cfquery>
	
</cfcase>

<cfcase value="customer">

<!--- update also for NIT --->
<!--- RECALCULATE amount for schedule --->

</cfcase>

<cfcase value="Mail">

	<cfquery name="set"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE CustomerRequest
		SET   CustomerMail = '#form.customermail#'
		WHERE RequestNo = '#url.requestno#'				
	</cfquery>


<!--- update also --->

</cfcase>

</cfswitch>
