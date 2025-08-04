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


<cfquery name="qThisSale" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    SELECT *
	    FROM  CustomerRequestLine
	    WHERE RequestNo = '#url.requestno#'		
</cfquery>	

<cfif qthisSale.recordcount gte "1">
	<cfset def = qThisSale.SalesDiscount>
<cfelse>
	<cfset def = "0">
</cfif>		

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT  *
		FROM   Warehouse
		WHERE  Warehouse = '#url.warehouse#'
</cfquery>

<cfoutput>

<select name="Discount" id="Discount" style="background-color:f1f1f1;font-size:16px;height:100%;width:100%;min-width:80px;border:0px;" class="regularXXL"
		onchange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applySaleHeader.cfm?field=discount&discount='+this.value+'&requestno='+document.getElementById('RequestNo').value+'&customeridinvoice='+document.getElementById('customerinvoiceidselect').value,'salelines','','','POST','saleform')">
				
		<cfloop index="dis" from="0" to="#get.SaleDiscount#" step="1">
			<option value="#dis#" <cfif def eq dis>selected</cfif>>#dis# %</option>
		</cfloop>
		
</select>	

</cfoutput>	

