<style>
.gray{
color:#666666;
}
</style>
<cfoutput>

<cfquery name="qWarehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Warehouse
	WHERE Warehouse = '#URL.warehouse#' 
</cfquery>	

<cfif url.customerid neq "00000000-0000-0000-0000-000000000000">

	<table width="93%" height="100%" align="center" class="formpadding clsNoPrint">
	
			<cfquery name="Customer" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
	                       SELECT    TOP 1 * 
	                       FROM      Customer C 
	                       WHERE     C.CustomerId = '#url.customerid#'                                                                                                                          
	                      		  
			</cfquery>
							    
			<tr class="line">
				<td style="height:32px;padding-top:9px">
					<table class="gray">
						<tr>						
							<td style="padding-left:5px;font-weight:200;font-size:18px" class="labelmedium">														
								<cfif url.customerid neq "00000000-0000-0000-0000-000000000000">
									<a href="javascript:editCustomer('#url.customerid#')">#Customer.CustomerName#</a>
								<cfelse>
									#Customer.CustomerName#
								</cfif>							
							</td>						
							
						</tr>
					</table>
				</td>
			</tr>
			
			<cfquery name="last" 
				  datasource="AppsLedger" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					    SELECT    TOP 3 *
						FROM      TransactionHeader
						WHERE     ReferenceId = '#url.customerid#'	  
						AND       TransactionSource = 'SalesSeries' 							   
						ORDER BY  Created DESC
				</cfquery>
				
			<cfif last.recordcount eq "0">
			
				<tr class="labelmedium">
					<td style="font-weight:200;padding-top:82px;font-size:16px" align="center">
						<i><cf_tl id="First time Customer"></i>
					</td>
				</tr>
			
			<cfelse>	
					
				<tr><td style="padding-top:5px" valign="top">
						<cfif qWarehouse.CustomerInformation eq "">
							<cfinclude template="getCustomerStats.cfm">
						<cfelse>
							<cfinclude template="../../../../../#qWarehouse.CustomerInformation#">
						</cfif>				
				</td></tr>
				
			</cfif>				
					
	</table>
	
</cfif>	

</cfoutput>