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
<cfparam name="url.default" default="0">

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ItemUoM	
	WHERE  ItemUoMId = '#url.ItemUomId#'			
</cfquery>	

<cfquery name="UoMList" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ItemUoM
	WHERE  ItemNo = '#get.ItemNo#'				
</cfquery>

<cfoutput>

<cfset chg = "setstockline('1','#url.reqno#',this.value,document.getElementById('receiptquantity').value,document.getElementById('warehouseprice').value,'quantityline','#get.UoM#',document.getElementById('warehousecurrency').value);">
	

<cfif url.default eq "1">	

	<input type="hidden" name="WarehouseReceiptUoMPrior" id="WarehouseReceiptUoMPrior" value="asis">
									
	<select name="WarehouseReceiptUoM" id="WarehouseReceiptUoM" class="regularxl enterastab" 
	  onchange="ptoken.navigate('#session.root#/procurement/application/receipt/ReceiptEntry/setReceiptPrice.cfm?requisitionno=#url.reqno#&receiptprice='+document.getElementById('receiptprice').value+'&prior='+document.getElementById('WarehouseReceiptUoMPrior').value+'&uom='+this.value,'process');#chg#">
	    <option value="asis" selected><cf_tl id="as in order"></option>		 
		<cfloop query="UoMList"><option value="#uoM#">#UoMDescription#</option></cfloop>
	</select>			

<cfelse>

	<input type="hidden" name="WarehouseReceiptUoMPrior" id="WarehouseReceiptUoMPrior" value="#url.uom#">
								
	<select name="WarehouseReceiptUoM" id="WarehouseReceiptUoM" class="regularxl enterastab"
	onchange="ptoken.navigate('#session.root#/procurement/application/receipt/ReceiptEntry/setReceiptPrice.cfm?requisitionno=#url.reqno#&receiptprice='+document.getElementById('receiptprice').value+'&prior='+document.getElementById('WarehouseReceiptUoMPrior').value+'&uom='+this.value,'process');#chg#">
	    <option value="asis" selected><cf_tl id="as in order"></option>		 
		<cfloop query="UoMList"><option value="#uoM#" <cfif UoM eq url.uom>selected</cfif>>#UoMDescription#</option></cfloop>
	</select>		

</cfif>

</cfoutput>