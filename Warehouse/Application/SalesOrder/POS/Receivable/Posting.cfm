
<cf_screentop height="100%" scroll="No" label="Receivable" html="Yes" close="ProsisUI.closeWindow('wsettle')" banner="gray" layout="webapp">

<table cellspacing="0" cellpadding="0" bgcolor="FFFFFF" style="height:100%;width:100%">

<tr><td style="height:100%;overflow:hidden">
		
<cfparam name="url.batchid"           default="">
<cfparam name="url.customerid"        default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.customeridinvoice" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.addressid" 		  default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.warehouse"         default="BCN000">

<cfquery name="getSale"
 datasource="AppsTransaction" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT    SalesCurrency, 
			  SUM(SalesTotal) as sTotal
	FROM      Sale#url.warehouse#
	WHERE     CustomerId = '#url.customerid#'
	AND       AddressId  = '#url.addressid#'
	GROUP BY  SalesCurrency
</cfquery> 

<cfset url.currency = getSale.SalesCurrency>

<cfset dateValue = "">
<CF_DateConvert Value="#url.td#">
<cfset DTE = dateValue>
	
<cfset dte = DateAdd("h","#url.th#", dte)>
<cfset dte = DateAdd("n","#url.tm#", dte)>

<cfinclude template="ZeroPriceValidation.cfm">
<cfinclude template="../Settlement/OversaleValidation.cfm">

<cfinvoke component = "Service.Process.Materials.POS"  
	   method             = "postTransaction" 
	   batchid            = "#url.batchid#"
	   warehouse          = "#url.warehouse#" 
	   customerid         = "#url.customerid#"
	   customeridinvoice  = "#url.customeridinvoice#"
	   addressid	      = "#url.addressid#"
	   currency           = "#url.Currency#"
	   transactiondate    = "#dte#"
	   Settlement         = "0"
	   Workflow           = "Yes"
	   cleanup            = "Yes"
	   returnvariable     = "batchid">		

<cfoutput>

<!--- get journal --->

<cfquery name="get" 
     datasource="appsLedger" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT    *
	     FROM      TransactionHeader
	     WHERE     TransactionSourceId  = '#batchid#'
		 AND       TransactionSource = 'SalesSeries'
</cfquery>

<cfif get.recordcount gte "1">
	
	<cfquery name="getWarehouse" 
  	datasource="AppsMaterials" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">
	    	SELECT  *
			FROM   Warehouse
			WHERE  Warehouse = '#url.warehouse#'
	</cfquery>
			
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>
		 	
	<cfif getWarehouse.SaleMode eq "1">		
		
		<iframe src="#session.root#/Gledger/Application/Transaction/View/TransactionViewDetail.cfm?embed=1&journal=#get.Journal#&JournalSerialNo=#get.JournalSerialNo#&mode=1&mid=#mid#" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>
		
	<cfelse>
	
		<cfquery name="getBatch" 
  		datasource="AppsMaterials" 
  		username="#SESSION.login#" 
  		password="#SESSION.dbpw#">
	    		SELECT  *
				FROM   WarehouseBatch
				WHERE  BatchId = '#batchid#'
		</cfquery>	
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td width="100%" align="center" style="font-family: Calibri; color: 808080; font-size:23px">
					#getBatch.BatchNo# <cf_tl id="has been created">
				</td>
			</tr>	
		</table>	
		<cfsilent>
		<cfinclude template="PostingNotification.cfm">
		</cfsilent>
		
	</cfif>		
	
	<script>
	    // refresh screen 
		ptoken.navigate("#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applyCustomer.cfm?warehouse=#url.warehouse#",'customerbox')	
	</script>	
		
<cfelse>

	Problem processing sale
	
</cfif>

</cfoutput>	  

</td></tr>
</table>

<cf_screenbottom layout="webapp">

 

	