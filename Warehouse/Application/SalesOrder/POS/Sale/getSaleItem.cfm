<cfparam name="Form.SalesPersonNo" default="">

<cfoutput>
     
	<cfif form.customeridselect eq "" or form.customerinvoiceidselect eq "">
	
		<cf_tl id="Please select a valid customer and customer invoice before you add a product" class="message" var="vMessage">
		<script>
			alert('#vMessage#.');
		</script>		
	<!---	<cfabort> --->
		
	</cfif>
		
</cfoutput>

<cfquery name="WParameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    SaleLinesOrder, Mission
	FROM      Warehouse WITH (NOLOCK)  
	WHERE     Warehouse = '#url.Warehouse#' 
</cfquery>	

<cfquery name="MParameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission WITH (NOLOCK)
	WHERE  Mission = '#WParameter.Mission#'	
</cfquery>

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT I.ItemNo,I.UoM,I.ItemUoMId, L.TransactionLot
		FROM   ItemUoM I WITH (NOLOCK) INNER JOIN  ItemUoMMissionLot L WITH (NOLOCK)
					ON I.ItemNo   = L.ItemNo
					AND    I.UoM      = L.UoM
						INNER JOIN Item ITM WITH (NOLOCK)
					ON ITM.ItemNo = I.ItemNo 
		WHERE   		
		L.Mission  = '#WParameter.Mission#'
		AND    (L.ItemBarCode LIKE '#url.search#%' OR L.ItemBarCodeAlternate LIKE '#url.search#%' OR ITM.ItemNoExternal LIKE '%#URL.search#%')
		AND    I.ItemNo IN (SELECT ItemNo 
		                    FROM   Item WITH (NOLOCK) 
							WHERE  ItemNo = I.ItemNo AND Destination = 'Sale')

							 			 							   		      
</cfquery>


<!--- fin the item --->

<cfif get.recordcount eq "0">

	<cfquery name="get" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT    U.ItemNo,U.UoM, U.ItemUoMId
		FROM      ItemUoM U WITH (NOLOCK) INNER JOIN Item I WITH (NOLOCK)
					ON U.ItemNo = I.ItemNo
		WHERE     
			<cfif MParameter.EarmarkManagement eq "0">
				U.ItemBarCode LIKE '#url.search#%'  		 							   		  
					OR I.ItemNoExternal LIKE '%#URL.search#%'
			<cfelse>
				U.ItemBarCode 			= '#url.search#'  		 							   		  
					OR I.ItemNoExternal = '#URL.search#'
			</cfif>		    
	</cfquery>
	
	<!--- Added by Armin on April 4th 2019 ---->
	<cfif get.recordcount gt 1 and URL.search neq "">
		<cfquery name="get" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT    TOP  1 U.ItemNo,U.UoM, U.ItemUoMId
			FROM      ItemUoM U WITH (NOLOCK) INNER JOIN Item I WITH (NOLOCK)
						ON U.ItemNo = I.ItemNo
			WHERE
				<cfif MParameter.EarmarkManagement eq "0">     
					U.ItemBarCode LIKE '#url.search#%'  		 							   		  
						OR I.ItemNoExternal LIKE '%#URL.search#%'
				<cfelse>
					U.ItemBarCode 		    = '#url.search#'  		 							   		  
						OR I.ItemNoExternal = '#URL.search#'
				</cfif>		
			ORDER BY U.UoMMultiplier ASC			    
		</cfquery>		
	</cfif>	
	
	
	<cfset lot = "0">
	
<cfelse>

	<cfset lot = get.TransactionLot>	
	
</cfif>	

<cfoutput>

<cfif get.recordcount neq "1">

    <!--- check if possible the user has entered a sales person --->
	
	<cfquery name="getPerson" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT    *
		FROM      Person WITH (NOLOCK)
		WHERE     PersonNo LIKE '#url.search#%'  		 							   		      
	</cfquery>
	
	<cfif getPerson.recordcount eq "1">
	
	<!--- set the person instead to the last line --->
	
	<script>	
		   _cf_loadingtexthtml='';			   
			ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/Sale/applyPerson.cfm?warehouse=#url.warehouse#&customerid=#form.customeridselect#&customeridinvoice=#form.customerinvoiceidselect#&currency=#form.currency#&PersonNo=#getPerson.PersonNo#','salelines');
	</script>
	
	<table><tr><td class="labelmedium">#getPerson.FirstName# #getPerson.LastName#</td></tr></table>
	
	
	<cfelse>

    <table><tr><td class="labelmedium"><font color="FF0000"><cf_tl id="Not found"></font></td></tr></table>
	
	</cfif>
	
<cfelse>
		
	<cfquery name="getItem" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT    *
			FROM      Item WITH (NOLOCK)
			WHERE     ItemNo = '#get.ItemNo#'  		 							   		      
	</cfquery>
	
	<cfquery name="getWCategory" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT    *
			FROM      WarehouseCategory WITH (NOLOCK)
			WHERE     Category = '#getItem.Category#' AND Warehouse = '#url.Warehouse#'
	</cfquery>
		
	<cfif getItem.itemClass eq "Bundle">
	
			<cfquery name="getBundle" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT   *
					FROM     ItemBOM WITH (NOLOCK)
					WHERE    ItemNo = '#get.ItemNo#'
					AND      DateEffective <= getdate()
					ORDER BY DateEffective DESC
			</cfquery>			

			<cfoutput>
				<script>	
					date   = document.getElementById('transaction_date');
					hour   = document.getElementById('Transaction_hour');
					minu   = document.getElementById('Transaction_minute');
					disc   = document.getElementById('Discount');
					sche   = document.getElementById('PriceSchedule');
																			   
					ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/Sale/addBundle.cfm?warehouse=#url.warehouse#&customerid=#form.customeridselect#&customeridinvoice=#form.customerinvoiceidselect#&currency=#form.currency#&SalesPersonNo=#form.SalesPersonNo#&BOMId=#getBundle.BOMId#&bundleItemNo=#get.itemNo#&lot=#lot#&priceschedule='+sche.value+'&discount='+disc.value+'&date='+date.value+'&hour='+hour.value+'&minu='+minu.value,'salelines');
				</script>
			</cfoutput>						

	<cfelse>

			<cfquery name="getStock" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT    SUM(TransactionQuantity) as OnHand
					FROM      ItemTransaction WITH (NOLOCK)
					WHERE     Mission = '#WParameter.Mission#' 
					AND       ItemNo          = '#get.ItemNo#'
					AND       TransactionUoM  = '#get.UoM#'   		
					AND       TransactionLot  = '#Lot#'   						   		      
			</cfquery>
		
			<cfif (getStock.OnHand lte "0" or getStock.OnHand eq "") and getItem.ItemClass neq "service" and getWCategory.Oversale eq 0> <!--- Check WarehouseCategory.Oversale too --->
			
				<table>
					<tr>
					<td class="labelit">
					<cfif len(getItem.ItemDescription) gt "30">
					#left(getItem.ItemDescription,30)#
					<cfelse>
					#getItem.ItemDescription#
					</cfif> <font color="FF0000">:<cf_tl id="Out-of-stock"></font>
					</td>
					</tr>
				</table>
			
			<cfelse>
			
		        <cfparam name="Form.SalesPersonNo" default="">	    
				
				<table width="100%">
					<tr class="labelmedium">
					<td><font color="green">
					<cfif len(getItem.ItemDescription) gt "44">
					#left(getItem.ItemDescription,44)#<cfelse>
					#getItem.ItemDescription#
					</cfif>
					</td>
					<td align="right" style="padding-left:4px"><img height="20" width="20" src="#SESSION.root#/images/checkmark.png" alt="" border="0"></td>		
					<td class="hide">	
					    <cf_tl id="Add Item" var="1">			
					    <input type="button" id= "posadditem" Value = "#lt_text#" class = "button10s">			
						<script>	
							date   = document.getElementById('transaction_date');
							hour   = document.getElementById('Transaction_hour');
							minu   = document.getElementById('Transaction_minute');
							disc   = document.getElementById('Discount');
							sche   = document.getElementById('PriceSchedule');
							
							if (document.getElementById('addressidselect'))	{
								addressid = document.getElementById('addressidselect').value;
							} else {								
							    addressid='00000000-0000-0000-0000-000000000000';
							}																			
							ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/Sale/addItem.cfm?warehouse=#url.warehouse#&customerid=#form.customeridselect#&customeridinvoice=#form.customerinvoiceidselect#&currency=#form.currency#&SalesPersonNo=#form.SalesPersonNo#&ItemUomId=#get.ItemUoMid#&Transactionlot=#lot#&priceschedule='+sche.value+'&discount='+disc.value+'&date='+date.value+'&hour='+hour.value+'&minu='+minu.value+'&addressid='+addressid,'salelines');
						</script>
					</td>					
					</tr>
				</table>
				
			</cfif>

			
	</cfif>	
	
	
</cfif>

</cfoutput>
