<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.mode" default="Request">
		
<cfif url.mode eq "request">
	
	<cfquery name="Cart" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   WarehouseCart C, Item I, ItemUoM U
	    WHERE  C.ItemNo = I.ItemNo 
		AND    C.UoM = U.UoM
		AND    I.ItemNo = U.ItemNo
		AND    C.UserAccount = '#SESSION.acc#'
		AND    (C.ShipToWarehouse is NULL or C.ShipToLocation is NULL) 
		ORDER BY Warehouse
	</cfquery>
		
	<cfset url.box = "reqmain">
	
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="6688AA">
	<tr><td style="padding-left:13px;padding-right:13px">
					
			 <cfinclude template="CartDetail.cfm">	
			
	</td></tr>
	<tr><td height="4"></td></tr>
	</table>
	
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="6688AA">
		<tr><td height="6" colspan="4"></td></tr>		
		<tr><td colspan="4" align="center">
		<cfif cart.recordcount neq "0">
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<cf_button id="Cancel" label="Cancel Cart" icon="Images/cancel.gif" iconheight="16" fontweight="normal" fontfamily="calibry" fontsize="12px" color="black" onClick="cancelcart()">
						</td>	
						<td width="10px"></td>						
						<td>
							<cf_button id="Continue" label="Continue" icon="Images/next.gif" iconheight="16" fontweight="normal" fontfamily="calibry" fontsize="12px" color="black" onClick="list('1')">
						</td>
						<td width="10px"></td>	
						<td>
							<cf_button id="Task" label="Checkout" icon="Images/Task.gif" iconheight="15" fontweight="normal" fontfamily="calibry" fontsize="12px" color="black" onClick="checkout()">	
						</td>
					</tr>
				</table>

		</cfif>
		<tr>
	</table>
	
	<script>		
	    se = document.getElementById('smenu1')
		if (se) {
		ColdFusion.navigate('Requester/CartStatus.cfm','smenu1') }
	</script>
	
<cfelse>
		
	<cfquery name="Cart" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   WarehouseCart C, Item I, ItemUoM U
	    WHERE  C.ItemNo = I.ItemNo 
		AND    C.UoM = U.UoM
		AND    I.ItemNo = U.ItemNo
		<!--- AND    C.UserAccount = '#SESSION.acc#' --->
		AND    C.ShipToWarehouse = '#url.ShipToWarehouse#'
		AND    C.ShipToLocation  = '#url.ShipToLocation#'
		AND    C.ItemNo          = '#url.ItemNo#'
		AND    C.UoM             = '#url.UoM#'  
	</cfquery>
	
	
	<cfif Cart.recordcount eq "0">
	
		<table align="center"><tr><td height="20" align="center" class="label">There are no records to show in this view</td></tr></table>
	
	<cfelse>
	
		<cfinclude template="CartDetail.cfm">	
	
	</cfif>
	
	<script>
	    se = document.getElementById('smenu1')
		if (se) {
		ColdFusion.navigate('Requester/CartStatus.cfm','smenu1') } 
	</script>

</cfif>

