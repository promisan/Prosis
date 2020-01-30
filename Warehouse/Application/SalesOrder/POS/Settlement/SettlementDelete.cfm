
<cfquery name="getCustomer"
 datasource="AppsTransaction" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT	* 
	 FROM	Settle#URL.Warehouse#_#SESSION.acc#
	 WHERE 	TransactionId  = '#url.transactionid#'
</cfquery>

<cfif getCustomer.recordCount gt 0>

	<cfif trim(getCustomer.customerid) neq "">

		<cftransaction>
			
			<cfquery name="qDelete"
			 datasource="AppsTransaction" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 DELETE Settle#URL.Warehouse#_#SESSION.acc#
				 WHERE TransactionId  = '#url.transactionid#'
			</cfquery>
			
			<cfquery name="get"
			 datasource="AppsTransaction" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT	  * 
				 FROM	  Settle#URL.Warehouse#_#SESSION.acc#
				 WHERE 	  CustomerId  = '#getCustomer.CustomerId#'
				 AND	  SettleAmount > 0
			</cfquery>
			
			<cfif get.recordcount eq 0>
			
				<cfquery name="qDelete"
				 datasource="AppsTransaction" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 DELETE Settle#URL.Warehouse#_#SESSION.acc#
					 WHERE  CustomerId    = '#getCustomer.CustomerId#'
					 AND    SettleAmount <= 0
				</cfquery>
				
			</cfif>
			
		
		</cftransaction>
	
	<cfelse>
	
		<cf_tl id="Error" var="vMesTitle">
		<cf_tl id="This transaction does not have a customer associated" var="vMessage">
		<cfoutput>
			<script>
				Prosis.notification.show('#vMesTitle#','#vMessage#','error',5000);
			</script>
		</cfoutput>

	</cfif>

<cfelse>

	<cf_tl id="Error" var="vMesTitle">
	<cf_tl id="This transaction does not exist anymore" var="vMessage">
	<cfoutput>
		<script>
			Prosis.notification.show('#vMesTitle#','#vMessage#','error',5000);
		</script>
	</cfoutput>

</cfif>
 
 
 <cfinclude template="SettlementLines.cfm">
 
 