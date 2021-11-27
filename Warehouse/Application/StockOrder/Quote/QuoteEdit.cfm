
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
	    $("tr.line#url.transactionid#").each(function() {$(this).remove();});
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
			
	<cfquery name="warehouse" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Warehouse
		WHERE  Warehouse = (SELECT Warehouse FROM CustomerRequest WHERE RequestNo = '#get.requestno#')				
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
	
	<cfset amounttot = amountsle + amounttax>

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
		<cfif warehouse.ModeTax eq "exclusive">
	    document.getElementById('value#transactionid#').innerHTML = "#numberformat(amountsle,',.__')#"        	   
		<cfelse>
		document.getElementById('value#transactionid#').innerHTML = "#numberformat(amounttot,',.__')#"    
		</cfif>
		document.getElementById('qteamount').innerHTML = "#numberformat(get.Amount,',.__')#"   	
		document.getElementById('qtetax').innerHTML    = "#numberformat(get.Tax,',.__')#" 
		document.getElementById('qtetotal').innerHTML  = "#numberformat(get.Total,',.__')#" 	
		ptoken.navigate('doStockCheck.cfm?id=#transactionid#','box#transactionid#')			
	</script>
	
	</cfoutput>
	
	</cfif>

</cfcase>

<cfcase value="price">

	<cfset transactionid = url.requestno>

    <cfset prc = url.val>
		
	<cfif LSIsNumeric(prc)>
	
	<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   CustomerRequestLine
		WHERE  TransactionId = '#transactionid#'					
	</cfquery>	
	
	<cfquery name="warehouse" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Warehouse
		WHERE  Warehouse = (SELECT Warehouse FROM CustomerRequest WHERE RequestNo = '#get.requestno#')				
	</cfquery>
		    			
	<cfset qty   = get.TransactionQuantity>
	<cfset tax   = get.TaxPercentage>
			
	<cfif get.TaxIncluded eq "0">
							   
		<cfset amountsle  = prc * qty>
		<cfset amounttax  = (tax * prc) * qty>	
			
	<cfelse>				
				
		<cfset amounttax  = ((tax/(1+tax))*prc)*qty>	
		<!--- <cfset amountsle = ((1/(1+tax))*price)*qty> --->
		<!--- changed way of calculating amountsle as otherwise sometimes we have .01 data loss ---->
		<cfset amountsle  = (prc * qty) - amounttax>	
		
	</cfif>
	
	<cfif prc neq "0">	
		<cfset unitprice = amountsle / qty>
	<cfelse>
		<cfset unitprice = 0>
	</cfif>
	
	<cfif get.TaxExemption eq "1">
	  <cfset amounttax = 0>
	</cfif>
	
	<cfset amounttot = amountsle + amounttax>
	
	<cfset saleprice = (amountsle+amounttax) / qty>

	<cfquery name="setLine"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE CustomerRequestLine 
			SET    SalesPrice          = '#saleprice#',
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
	    <cfif warehouse.ModeTax eq "exclusive">
		document.getElementById('prc#transactionid#').value = "#numberformat(unitprice,',.__')#"
	    document.getElementById('value#transactionid#').innerHTML = "#numberformat(amountsle,',.__')#"        	   
		<cfelse>
		document.getElementById('prc#transactionid#').value = "#numberformat(saleprice,',.__')#"
		document.getElementById('value#transactionid#').innerHTML = "#numberformat(amounttot,',.__')#"    
		</cfif>       	   
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


<cfcase value="remarks">

	<cfquery name="set"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE CustomerRequest
		SET   Remarks   = '#form.remarks#'
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
	
	<!--- refresh the quotes --->
	
	<cfoutput>
	<script>
	    ptoken.navigate('getQuoteLine.cfm?requestno=#url.RequestNo#&warehouse=#form.warehousequote#&action=view','boxlines') 		    	
	</script>
	</cfoutput>
		
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
