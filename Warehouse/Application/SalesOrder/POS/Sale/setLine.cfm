
<!--- --------------------------------------------------------- --->
<!--- Ajax template template to update the line for changes --- --->
<!--- --------------------------------------------------------- --->

<cfquery name="get"
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Sale#URL.Warehouse# 
	WHERE  TransactionId = '#url.id#'		
</cfquery>

<cfquery name="qWarehouse"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Materials.dbo.Warehouse
		WHERE   Warehouse = '#URL.Warehouse#'
</cfquery>

<cfparam name="url.action"     default="">
<cfparam name="url.customerid" default="#get.Customerid#">
<cfparam name="url.addressid"  default="#get.AddressId#">

<cfoutput>

	<cfswitch expression="#url.action#">
		
		<cfcase value="delete">
			
			<cfquery name="getTotal"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM Sale#URL.Warehouse# 
					WHERE  TransactionId = '#url.id#'		
			</cfquery>
			
			
			
			<cfinclude template="SaleViewLines.cfm">
			
			<script language="JavaScript">				
	   			try { opener.applyfilter('1','','#url.customerid#') } catch(e) {}			
			</script>	
					
		</cfcase>
		
		<cfcase value="quantity">
		
			<cfif not isNumeric(url.value)>
			
			  <script>
			  	  <cf_tl id="invalid quantity" var="1" class="message">
				  alert("#lt_text#")
			  </script>
			  
			<cfelse>  
			
				<cfset qty   = url.value>
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
				
				<cfif get.taxExemption eq "1">
					<cfset amounttax = 0>
				</cfif>
							
				<!--- rounding --->
				<cfset amountsle  = round(amountsle*100)/100>
				<cfset amounttax  = round(amounttax*100)/100>
				
			
			    <cfquery name="setLine"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Sale#URL.Warehouse# 
						SET    TransactionQuantity = '#url.value#',
						       SalesAmount   = '#amountsle#',
							   SalesTax      = '#amounttax#'
						WHERE  TransactionId = '#url.id#'		
				</cfquery>
				
				<!--- apply promotions --->
									
				<cfinvoke component = "Service.Process.Materials.POS"  
				   method           = "applyPromotion" 
				   warehouse        = "#url.warehouse#" 
				   customerid       = "#url.customerid#">	
								
				<cfquery name="get"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   Sale#URL.Warehouse# 
					WHERE  TransactionId = '#url.id#'		
				</cfquery>
				
				<script language="JavaScript">				
				    document.getElementById('SalesPrice_#url.line#').value = '#numberformat(get.SalesPrice,',.__')#'
					document.getElementById('total_#url.line#').innerHTML = '#numberformat(get.SalesTotal,',.__')#'
					_cf_loadingtexthtml='';	
					ColdFusion.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Sale/getOnHand.cfm?action=#url.action#&line=#url.line#&warehouse=#url.warehouse#&id=#get.TransactionId#','onhand_#url.line#')
	
					<cfif qWarehouse.Beneficiary eq 1 and get.ItemClass eq "Service">
						ColdFusion.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Sale/getBeneficiary.cfm?crow=#url.line#&warehouse=#url.warehouse#&id=#get.TransactionId#&clines=#url.value#','Beneficiary_#url.line#')
					</cfif>
					
				</script>
						
			</cfif>
				
		</cfcase>
		
		<cfcase value="time">
		
			<cfset dateValue = "">
			<CF_DateConvert Value="#url.date#">
			<cfset dte = dateValue>
	
			<cfset dte = DateAdd("h", url.hour, dte)>
			<cfset dte = DateAdd("n", url.minute, dte)>
			
			 <cfquery name="setLine"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Sale#URL.Warehouse# 
						SET    TransactionDate = #dte#
						WHERE  TransactionId = '#url.id#'		
				</cfquery>		
		
		</cfcase>
		
		<cfcase value="reference">
		
		 <cfquery name="setLine"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE Sale#URL.Warehouse# 
						SET    TransactionReference = '#url.value#'
						WHERE  TransactionId = '#url.id#'		
				</cfquery>	
		
		</cfcase>
		
		<cfcase value="price">
		
			<cfif not isNumeric(url.value)>
			
			  <script>
				  alert("invalid price")
			  </script>
			  
			<cfelse>  
			
				<cfset qty   = get.TransactionQuantity>
				<cfset price = url.value>
			    <cfset tax   = get.TaxPercentage>
					
				<cfif get.TaxIncluded eq "0">
									   
					<cfset amountsle  = price * qty>
					<cfset amounttax  = (tax * price) * qty>	
					
				<cfelse>				
						
	
					<cfset amounttax  = ((tax/(1+tax))*price)*qty>
					<!--- <cfset amountsle = ((1/(1+tax))*price)*qty> --->
					<!---- changed way of calculating amountsle as otherwise sometimes we have .01 data loss ---->
					<cfset amountsle  = (price * qty) - amounttax>	
					
				</cfif>
				
				<cfif get.taxExemption eq "1">
					<cfset amounttax = 0>
				</cfif>
				
							
				<cfinvoke component  = "Service.Access" 
			      method         	 = "RoleAccess"				  	
				  role           	 = "'AdminFinancials'"		
				  returnvariable 	 = "changePriceRole">	
				  
				 <!--- If user has explicit access to change sales price, process it --->
				 <cfif changePriceRole eq "GRANTED">
				 
				 	  <cfquery name="setLine"
							datasource="AppsTransaction" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							UPDATE Sale#URL.Warehouse# 
							SET    SalesPrice    = '#url.value#',
							       SalesAmount   = '#amountsle#',
								   SalesTax      = '#amounttax#'
							WHERE  TransactionId = '#url.id#'		
						</cfquery>			
				
				<!--- Otherwise, check if access is within the threshold --->		
				<cfelse>
				 
				 	 <cfquery name="Threshold"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * FROM WarehouseCategory
						WHERE Warehouse = '#get.Warehouse#' 
						AND   Category = '#get.ItemCategory#'					
					</cfquery>
					
					<!--- rounding --->
					<cfset amountsle  = round(amountsle*100)/100>
					<cfset amounttax  = round(amounttax*100)/100>
								
					<cfset discountratio = (get.scheduleprice - price) / get.scheduleprice>
					<cfset discountratio = discountratio * 100>
								
					<cf_tl id="Discount threshold exceeded" var="1">
											
					<cfif Threshold.recordcount gt 0 and discountratio gte Threshold.ThresholdDiscount>
					
						<script>
							alert('#lt_text#.#discountratio# -#Threshold.ThresholdDiscount#')
							document.getElementById('SalesPrice_#url.line#').value = '#numberformat(get.SalesPrice,',.__')#'
						</script>
					
					<cfelse>
							
					    <cfquery name="setLine"
							datasource="AppsTransaction" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							UPDATE Sale#URL.Warehouse# 
							SET    SalesPrice    = '#url.value#',
							       SalesAmount   = '#amountsle#',
								   SalesTax      = '#amounttax#'
							WHERE  TransactionId = '#url.id#'		
						</cfquery>				
											  
					</cfif>
				 
				</cfif>
							
				<cfquery name="get"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   Sale#URL.Warehouse# 
						WHERE  TransactionId = '#url.id#'		
					</cfquery>
				
				<script language="JavaScript">
					document.getElementById('total_#url.line#').innerHTML = '#numberformat(get.SalesTotal,',.__')#'
					_cf_loadingtexthtml='';	
					// ColdFusion.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Sale/getOnHand.cfm?action=#url.action#&line=#url.line#&warehouse=#url.warehouse#&id=#get.TransactionId#','onhand_#url.line#')
				</script>
						
			</cfif>
				
		</cfcase>
	
	</cfswitch>

	<cfinclude template="setTotal.cfm">

</cfoutput>