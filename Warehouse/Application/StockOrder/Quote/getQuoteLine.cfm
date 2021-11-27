
<!--- quotelines --->

<cfparam name="url.action"     default="">
<cfparam name="url.customerid" default="00000000-0000-0000-0000-000000000000">
<cfset url.transactionlot = "0">
<cfset qty                = 1>
<cfset taxmode            = "Inclusive">

<cfif url.action eq "add">
		
	<!--- this template 
	1. adds a line to the list which it receives from the extended listing which has a form which passes
	2. refreshes the listing 
	--->
	
	<!--- lets add an option to select a quote no as well --->
	
	<!--- defined price --->	
			
	<cfinvoke component  = "Service.Process.Materials.POS"  
		   method            = "getPrice" 
		   priceschedule     = "#url.priceschedule#"
		   discount          = "0"
		   warehouse         = "#url.warehouse#" 
		   customerid        = "#url.customerid#"	   
		   currency          = "#url.Currency#"
		   ItemNo            = "#url.itemno#"
		   UoM               = "#url.uom#"
		   quantity          = "1"
		   returnvariable    = "sale">	
	   	
		<!--- DEFINE he location from where it is retrieved --->			
		<!--- --------------------------------------------- --->			
		
		<!--- transaction id --->
		<cf_assignid>
		
		<!--- check if item is already requested by the same customer, in that case we add  --->
			
		<cfquery name="get"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   vwCustomerRequest
			WHERE  RequestNo       = '#url.Requestno#'		
			AND    ItemNo          = '#url.itemno#'
			AND    TransactionUoM  = '#url.uom#'	
		</cfquery>
		
		<cfif get.recordcount eq "1">				
		     		
			<cfset qty = get.TransactionQuantity+qty>
					
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
			
			<cfset unitprice = amountsle / qty>
			
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
				WHERE  TransactionId       = '#get.transactionid#'		
			</cfquery>
						
		<cfelse>	
		 		
		    <cfquery name="getLines" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
					SELECT   *				
					FROM     CustomerRequestLine
					WHERE    RequestNo       = '#url.RequestNo#'				
			</cfquery>
							
			<cfquery name="InsertLine" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				INSERT INTO dbo.CustomerRequestLine ( 				   
						RequestNo,
						TransactionId, 
						TransactionType, 
						TransactionDate, 
						ItemNo, 
						ItemClass,
						ItemDescription, 
						ItemCategory, 											
			            TransactionUoM, 
						TransactionLot,
						TransactionQuantity,  					
						<!---
						-- CustomerIdInvoice,						
						--->
						PriceSchedule,
						SalesCurrency, 
						SchedulePrice,
						
						SalesPrice, 
						TaxCode,
						TaxPercentage, 
						TaxExemption, 
						TaxIncluded, 
						SalesUnitPrice,
						SalesAmount, 
						SalesTax, 			           
						PersonNo,						
						SalesPersonNo,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )  
								
				VALUES ('#url.requestNo#',
				        '#rowguid#',
					    '2',
					    getDate(),
					    '#url.itemno#', 
						'#sale.ItemClass#',
						'#sale.ItemDescription#', 
						'#sale.Category#',										
						'#url.uom#',     
						'#url.transactionlot#',       
						'#qty#',	
						<!---								
						'#url.CustomerIdInvoice#', 						
						--->
						'#sale.priceschedule#',
						'#url.currency#', 
						'#sale.scheduleprice#', 
						'#sale.price#', 
						'#sale.TaxCode#',
						'#sale.tax#', 
						'#sale.taxexemption#', 
						'#sale.inclusive#', 
						'#sale.pricenet#',
						'#sale.amount#', 
						'#sale.amounttax#', 			           
						'#client.PersonNo#',
						'#client.PersonNo#',
						<!---
						'#url.salespersonno#',
						--->
						'#session.acc#',
						'#session.last#',
						'#session.first#' )		  
						
				</cfquery>
				
	</cfif>	

<!--- add item --->

</cfif>

<cfquery name="getLines" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		SELECT   L.*, I.ItemNoExternal				
		FROM     CustomerRequestLine L INNER JOIN Item I ON L.ItemNo = I.ItemNo
		WHERE    RequestNo       = '#url.RequestNo#'	
		ORDER BY Created DESC			
</cfquery>

<cfquery name="warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Warehouse
	WHERE  Warehouse = (SELECT Warehouse FROM CustomerRequest WHERE RequestNo = '#url.requestno#')				
</cfquery>
	
<table style="height:100%;width:100%" class="navigation_table">

<tr><td style="height:100%;padding-bottom:3px">

	<cf_divscroll>
	
	<table style="width:97%" class="navigation_table">
	
	<cfoutput query="getLines">
	
	<tr class="line#transactionid#"><td style="height"></td></tr>
	<tr class="line#transactionid# labelmedium line navigation_row">
		<td colspan="4" style="padding-left:5px">
		<table width="100%">
		<tr class="fixlengthlist">
		   <td class="labelmedium">#ItemNoExternal# #ItemDescription#</td>
		   <td align="right" vaign="top" style="padding-top:3px;padding-right:3px;width:20px">
		   <cf_img icon="delete" onclick="javascript:deleteitem('#transactionid#')"></td>
		</tr>
		</table>
		</td>
	</tr>
	<tr class="line#transactionid# labelmedium2">	
	    
		<td style="width:20%" align="center">	
					
		  <cf_securediv id="box#transactionid#" bind="url:doStockCheck.cfm?id=#transactionid#">				  				
		  
		</td>	
		
		<td style="border:1px solid silver;width:100px;" align="right">
		
			<table style="width:100%">
			<tr class="labelmedium2">
			<td style="cursor:pointer;font-size:15px;min-width:35px;background-color:silver" align="center" onclick="setquote('#transactionid#','mutation','-1')">
			<input type="button" value="-" class="button10g" style="width:100%;height:100%">
			</td>
			
			<td align="center">
			<input type="text" id="qty#transactionid#" style="width:60px;text-align:center;border:0px" 
			  onchange="setquote('#transactionid#','mutation',this.value)" value="#numberformat(TransactionQuantity)#" class="regularxl">	
			</td>
			<td style="cursor:pointer;font-size:15px;min-width:35px;background-color:silver" align="center" onclick="setquote('#transactionid#','mutation','1')">
			<input type="button" value="+" class="button10g" style="width:100%;height:100%">
			</td>
			</tr>
			</table>
		
		</td>
		
		<cfif warehouse.ModeTax eq "exclusive">
		
			<td style="min-width:70px;border:1px solid silver;padding-right:3px" align="right">		
			<input type="text" id="prc#transactionid#" style="width:60px;text-align:right;padding-right:3px;border:0px" 
				  onchange="setquote('#transactionid#','price',this.value)" value="#numberformat(salesUnitPrice,',.__')#" class="regularxl">				
			</td>		
			<td style="min-width:90px;border:1px solid silver;padding-right:3px" id="value#transactionid#" align="right">#numberformat(salesAmount,',.__')#</td>
			
		<cfelse>
		
			<td style="min-width:70px;border:1px solid silver;padding-right:3px" align="right">		
			<input type="text" id="prc#transactionid#" style="width:60px;text-align:right;padding-right:3px;border:0px" 
				  onchange="setquote('#transactionid#','price',this.value)" value="#numberformat(salesPrice,',.__')#" class="regularxl">				
			</td>		
			<td style="min-width:90px;border:1px solid silver;padding-right:3px" id="value#transactionid#" align="right">#numberformat(salesTotal,',.__')#</td>
			
		</cfif>
		
	</tr>
	</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td>
</tr>

<tr><td style="padding-bottom:4px">
	
		<table style="width:100%">
		
		 <cfquery name="get" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
					SELECT   sum(SalesAmount) as Amount,
					         sum(SalesTax)    as Tax,
							 sum(SalesTotal)  as Total				
					FROM     CustomerRequestLine
					WHERE    RequestNo       = '#url.RequestNo#'						
		</cfquery>
		
		<cfoutput>
		
			<tr class="labelmedium2">
			    <td align="right" style="padding-right:10px" colspan="3"><cf_tl id="Amount"></td>
				<td align="right" id="qteamount" style="padding-right:4px;font-weight:bold;border:1px solid silver">#numberformat(get.Amount,',.__')#</td>
			</tr>
			<tr class="labelmedium2">
			    <td align="right" style="padding-right:10px" colspan="3"><cf_tl id="Tax"></td>
				<td align="right" id="qtetax" style="padding-right:4px;font-weight:bold;border:1px solid silver">#numberformat(get.Tax,',.__')#</td>
			</tr>
			<tr class="labelmedium2">
			    <td align="right" style="padding-right:10px" colspan="3"><cf_tl id="Total"></td>
				<td align="right" id="qtetotal" style="padding-right:4px;font-weight:bold;border:1px solid silver">#numberformat(get.Total,',.__')#</td>
			</tr>
		
		</cfoutput>
		
		</table>
	
	</td>
</tr>

</table>

<!--- refresh the schedule selector with the correct default value --->
<cfoutput>
	<script>		    
	     ptoken.navigate('getQuoteSchedule.cfm?requestNo=#url.requestNo#','priceschedule')
	</script>
</cfoutput>

<cfset ajaxonload("doHighlight")>