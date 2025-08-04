<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
							<td title="#customer.customername#" style="max-width:280px;padding-left:5px;font-size:18px" class="fixlength labelmedium">														
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
						AND      TransactionCategory = 'Receivables'	
						AND       ActionStatus IN ('1') and RecordStatus != '9'						   
						ORDER BY  Created DESC
						
				</cfquery>
				
			<cfif last.recordcount eq "0">
			
				<tr class="labelmedium">
					<td style="padding-top:42px;font-size:16px" align="center">
						<cf_tl id="First time Customer">
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