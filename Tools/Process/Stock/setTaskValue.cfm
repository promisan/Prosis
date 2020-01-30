
<cfparam name="Attributes.Taskid"      default="">
<cfparam name="Attributes.RequestId"   default="">
<cfparam name="Attributes.SerialNo"    default="">
<cfparam name="Attributes.ValueDate"   default="">

<!--- ------------------------- --->
<!--- get the price if possible --->
<!--- ------------------------- --->	

<cfif attributes.taskid neq "">
			
	<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Request R, RequestTask T
		WHERE  T.Taskid        = '#Attributes.Taskid#'
		AND    R.RequestId     = T.RequestId		
	</cfquery>

<cfelse>
				
	<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Request R, RequestTask T
		WHERE  R.RequestId     = '#Attributes.RequestId#'
		AND    R.RequestId     = T.RequestId
		AND    T.TaskSerialNo  = '#Attributes.SerialNo#'
	</cfquery>

</cfif>


<cfif attributes.valueDate eq "">

	<CF_DateConvert Value="#DateFormat(get.ShipToDate,CLIENT.DateFormatShow)#">	
	<cfset valueDate  = dateValue>

<cfelse>

	<CF_DateConvert Value="#attributes.ValueDate#">	
	<cfset valueDate  = dateValue>

</cfif>

<cfquery name="getLoc" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Warehouse
	WHERE  Warehouse  = '#get.ShipToWarehouse#'			
</cfquery>

<cfquery name="getPur" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   PurchaseLine PL, Purchase P
	WHERE  P.PurchaseNo   = PL.PurchaseNo
	AND    RequisitionNo  = '#get.sourceRequisitionNo#'				
</cfquery>

<!--- now determine the expected price for the request based on the offer table and covert this to currenncy of the purchase order
and the calculate to the base currency as well in the record --->

<cfif get.SourceRequisitionNo neq "">

	<cfif getLoc.LocationId neq "">
		
		<cfquery name="GetPrice" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  TOP 1 *
			FROM    ItemVendorOffer
			WHERE   ItemNo         = '#get.ItemNo#'
			AND     UoM            = '#get.Uom#'
			AND     OrgUnitVendor  = '#getPur.OrgUnitVendor#' 
			AND     Mission        = '#getPur.Mission#'
			AND     LocationId     = '#getLoc.LocationId#'
			AND     DateEffective <= #valueDate#
			ORDER BY DateEffective DESC
		</cfquery>
		
		<cfif getPrice.recordcount eq "1">
		
			<cfif getPrice.TaxIncluded eq "1">
				<cfset price = getPrice.ItemPrice>
			<cfelse>
			    <cfset price = getPrice.ItemPrice+getPrice.ItemTax>
			</cfif>					
			
			<cfif getPrice.Currency eq APPLICATION.BaseCurrency>
			
			    <cfset exc = "1">
			
			<cfelse>
			
				<cf_exchangerate 
				    currencyfrom = "#getPrice.Currency#" 
					currencyto   = "#APPLICATION.BaseCurrency#">
								
			</cfif>
			
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    TaskCurrency     = '#getPrice.Currency#', 
				       TaskPrice        = '#price#',
					   ExchangeRate     = '#exc#'
				WHERE  Taskid           = '#get.TaskId#'				
			</cfquery>
							
		<cfelse>
		
			<!--- get the standard price per mission --->
		
			<cfquery name="GetPrice" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  TOP 1 *
				FROM    ItemUoMMission
				WHERE   ItemNo         = '#get.ItemNo#'
				AND     UoM            = '#get.Uom#'			
				AND     Mission        = '#getPur.Mission#'
			</cfquery>
			
			<cfif getPrice.standardcost gt "0">
			
				<cfquery name="Update" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE RequestTask
					SET    TaskCurrency     = '#APPLICATION.BaseCurrency#', 
					       TaskPrice        = '#getPrice.StandardCost#',
						   ExchangeRate     = '1'
					WHERE  Taskid           = '#get.TaskId#'		
				</cfquery>									
							
			<cfelse>
			
				<cfquery name="GetPrice" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  TOP 1 *
					FROM    ItemUoM
					WHERE   ItemNo         = '#get.ItemNo#'
					AND     UoM            = '#get.Uom#'						
				</cfquery>
				
				<cfquery name="Update" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE RequestTask
					SET    TaskCurrency     = '#APPLICATION.BaseCurrency#', 
					       TaskPrice        = '#getPrice.StandardCost#',
						   ExchangeRate     = '1'
					WHERE  Taskid           = '#get.TaskId#'		
				</cfquery>									
			
			</cfif>				
					
		</cfif>

	</cfif>	
	
</cfif>	
