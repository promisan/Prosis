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
<table width="100%" bgcolor="FFFFFF">

<cfparam name="url.systemfunctionid" default="">

<cfquery name="getWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Warehouse
		WHERE    Warehouse  = '#url.warehouse#'			
</cfquery>

<cfinvoke component = "Service.Access"  
     method             = "roleaccess"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 missionorgunitid   = "#getWarehouse.MissionOrgUnitId#"
	 Parameter          = "#url.SystemFunctionId#" 
	 AccessLevel        = "'2'"
	 returnvariable     = "access">	 


<cfif access eq "GRANTED">

<tr><td class="labellarge" style="padding-top:3px;padding-left:10px;padding-bottom:3px">Fund through Obligation</td></tr>

<tr><td height="40" style="padding-left:10px;padding-right:10px">
	<cfinclude template="PrepareInvoicePurchase.cfm">	
	</td>
</tr>

</cfif>

<tr><td style="padding-top:10px;padding-left:10px;padding-right:10px">
  
  <table width="100%" cellspacing="0" cellpadding="0">
  
  <tr><td class="labellarge" style="padding-top:3px;padding-bottom:3px">Billable Transactions </td>
    
  <td align="right" style="padding-right:10px;padding-top:3px;padding-bottom:3px"> in: 
  
          <!--- get the likely invoice currency --->
		  			
		  <cfset curr = APPLICATION.BaseCurrency>
			
  		  <cfquery name="getPrior" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     Invoice
				WHERE    OrgUnitVendor IN (SELECT OrgUnitVendor FROM Materials.dbo.WarehouseLocation WHERE Warehouse = '#url.warehouse#') 				
				ORDER BY Created DESC				
		  </cfquery> 	  
		  		  
		  <cfif getPrior.recordcount eq "1">
		  
			  <cfset curr = getPrior.DocumentCurrency>  
		     		
		  <cfelse>
		  
		     <cfquery name="getPrior" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     ItemVendorOffer
				WHERE    OrgUnitVendor IN (SELECT OrgUnitVendor FROM Materials.dbo.WarehouseLocation WHERE Warehouse = '#url.warehouse#')				
				ORDER BY Created DESC				
		     </cfquery>  
			 
			 <cfif getPrior.currency neq "">
			 	<cfset curr = getPrior.currency>
			 </cfif>	
		  		  
		  </cfif>
  
		  <cfquery name="getLookup" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Currency
				WHERE  Operational = 1				
		  </cfquery>
			
		  <cfoutput>									
		  <select name="currency" id="currency" class="regular" style="font:14px" onchange="ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/shipping/payables/create/setCurrency.cfm?salesid='+document.getElementById('salesid').value+'&currency='+this.value,'currencybox')">
			<cfloop query="getLookup">
			    <option value="#getLookup.currency#" <cfif curr eq currency>selected</cfif>>#getLookup.currency#</option>
			</cfloop>
		  </select>
		  </cfoutput>
  
  </td>
  <td class="hide" id="currencybox"></td>
  </tr>
  
  <tr><td class="linedotted" colspan="2"></td></tr>
  
  </table>
   
  </td>
  
</tr>

<tr><td height="100%" id="invoicepayabledetails" valign="top"  style="padding-left:10px;padding-right:10px">
	<cfinclude template="PrepareInvoiceDetail.cfm">
	<!--- detailed and selected transaction with option to record the price --->
</td>
</tr>

</table>

<cf_screenbottom layout="webapp">