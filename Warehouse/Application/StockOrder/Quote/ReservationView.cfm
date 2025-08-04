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

<!--- requested view --->

<cfif url.mode eq "request">

<cfquery name="myRequest"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT        vw.Mission, 
	              vw.ActionStatus,
				  vw.RequestNo, 
				  vw.RequestClass, 
				  vw.CustomerId, 
				  C.CustomerName, 
				  C.CustomerSerialNo, 
				  vw.AddressId, 
				  vw.Warehouse, 
				  vw.ItemNo, 
				  vw.ItemClass, 
				  vw.ItemDescription, 
				  I.ItemPrecision,	
				  vw.ItemCategory, 
	              vw.TransactionUoM, 
				  vw.TransactionQuantity, 
				  vw.Source, 
				  vw.OfficerUserId, vw.OfficerLastName, vw.OfficerFirstName, vw.Created 
				  
	FROM          vwCustomerRequest AS vw LEFT OUTER JOIN
	              Customer AS C ON vw.CustomerId = C.CustomerId INNER JOIN
				  Item I ON vw.ItemNo = I.ItemNo
	WHERE         vw.ItemNo         = '#url.itemno#'
	<cfif url.uom neq "">
	AND           vw.TransactionUoM = '#url.Uom#'
	</cfif>
	AND           vw.Warehouse      = '#url.warehouse#'
	AND           vw.BatchNo IS NULL 
	AND           vw.RequestClass = 'QteReserve' 
	AND           vw.ActionStatus IN ('0','1')
				
	<!--- Hanno 10/9/2021 once the real workorder is reserved 
	    we need to reset the quote to release the request --->
	
</cfquery>

<table width="97%" align="center" class="navigation_table">

<tr class="labelmedium2 fixlengthlist">
   <td><cf_tl id="Request"></td> 
   <td><cf_tl id="Customer"></td>
   <td><cf_tl id="Officer"></td>
   <td><cf_tl id="Date"></td>
   <td align="right"><cf_tl id="Quantity"></td>   
</tr>

<tr class="labelmedium2"><td style="font-size:20px" colspan="5"><cf_tl id="Reservation"></td></tr>

<cfoutput query="myRequest">
	
	<tr class="labelmedium2 navigation_row line fixlengthlist">
	   <td style="padding-left:4px;padding-bottom:3px">

	   <!---
	   <a href="javascript:stockquote('#RequestNo#')">
	   --->
	    
	     <input type="button" class="button10g" style="border:1px solid silver;width:60px;height:23px" value="#RequestNo#"
							   onclick="window['fnCBDialogSaleClose'] = function(){ ProsisUI.closeWindow('quotationview') }; ptoken.navigate('#link#&action=insert&RequestNo=#RequestNo#','boxquote','fnCBDialogSaleClose','','POST','');" >
			   
	   </td> 
	   <td>#CustomerName#</td>
	   <td>#OfficerLastName#</td>
	   <td>#dateformat(Created, client.dateformatshow)#</td>
	   <cf_precision precision="#ItemPrecision#">	
	   <td style="text-align:right;padding-right:4px">#numberformat(transactionQuantity,'#pformat#')#</td>   
	</tr>

</cfoutput>

<tr><td></td></tr>

</table>

</cfif>

<cfset ajaxonload("doHighlight")>
<!--- reserved view --->