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
<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT  *
	FROM     userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc#
	WHERE    TransactionId = '#URL.Id#'
</cfquery>	
	
 <cfquery name="Item"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Item
		WHERE  ItemNo = '#get.ItemNo#'
 </cfquery>

 <cfquery name="getList"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT   '1' as Class, ItemNo, UnitOfMeasure as UoM
	FROM     userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc#
	WHERE    TransactionId = '#URL.Id#'
	UNION
	SELECT   '0' as Class, ItemNo, UoM
	FROM     ItemWarehouseLocation
	WHERE    Warehouse = '#url.warehouse#'
	AND      Location  = '#url.location#'	
	AND      Operational = 1
	AND      ItemNo NOT IN (SELECT ItemNo 
	                        FROM   userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc# 
							WHERE  TransactionId = '#URL.Id#')		
	AND      ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#item.Category#' and CategoryItem = '#item.CategoryItem#')				
									
	ORDER BY Class DESC
 </cfquery>
  
 <table class="formpadding">
 
 	 <cfset row = 0>
 
	 <cfoutput query="getList">
	 
	 	 <cfif get.location neq url.location or get.warehouse neq url.warehouse or class eq "0">
		 
		 <cfset row = row+1>
		
		 <cfquery name="getItem"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT I.ItemNo, I.ItemDescription, U.UoMDescription, U.UoM, ItemUoMId
			FROM   Item I, ItemUoM U
			WHERE  I.ItemNo  = U.ItemNo
			AND    U.UoM     = '#uom#'
			AND    I.ItemNo  = '#itemno#'
		</cfquery>	
		 	 
		 <tr>
		 	<td class="labelit">						
			    <input type="radio" 
			      onclick="trfsave('#url.id#',document.getElementById('transferwarehouse#url.id#').value,document.getElementById('transferlocation#url.id#').value,'','','',document.getElementById('transferquantity#url.id#').value,document.getElementById('transfermemo#url.id#').value,'#getItem.itemuomid#',document.getElementById('transaction#url.id#_date').value,document.getElementById('transaction#url.id#_hour').value,document.getElementById('transaction#url.id#_minute').value)"
			      id="itemuomid#url.id#" 
				  name="itemuomid#url.id#" 
				  value="#getItem.ItemUoMId#" <cfif row eq "1" or (ItemNo eq get.TransferItemNo and UoM eq get.TransferUoM)>checked</cfif>>
			</td>
			<td style="padding-left:5px" class="labelit">#getItem.ItemDescription# (#getItem.UoMDescription#)</td>			
		 </tr>
		 
		 <cfif row eq "1">
		 	 
			<script>
	 			trfsave('#url.id#',document.getElementById('transferwarehouse#url.id#').value,'#url.location#','','','',document.getElementById('transferquantity#url.id#').value,document.getElementById('transfermemo#url.id#').value,'#getItem.itemuomid#',document.getElementById('transaction#url.id#_date').value,document.getElementById('transaction#url.id#_hour').value,document.getElementById('transaction#url.id#_minute').value)
			</script>
	 
		  </cfif>
		 
		</cfif>
	 	 
	 </cfoutput>
	 
 </table>
	
	