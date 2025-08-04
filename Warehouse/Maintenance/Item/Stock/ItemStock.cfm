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
<cfquery name="ItemList" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

   SELECT *
   FROM (

	SELECT 	 W.WarehouseName AS WarehouseName, 
			 W.Mission AS Mission, 
			 IW.*, 
			 I.ItemPrecision,
			 I.ValuationCode,
			 U.UoMDescription,			 
			 U.ItemBarCode,
			  (
				SELECT TOP 1 StandardCost
				FROM   ItemUoMMission 
				WHERE  ItemNo         = U.ItemNo
				AND	   UoM            = U.UoM
				AND    Mission        = W.Mission				
			 ) as StandardCost,
			 
			  (
				SELECT ISNULL(ROUND(SUM(TransactionQuantity),5),0)
				FROM   ItemTransaction 
				WHERE  ItemNo         = I.ItemNo
				AND	   TransactionUoM = U.UoM
				AND    Mission        = W.Mission
				AND	   Warehouse      = W.Warehouse
				AND    WorkOrderId is not NULL 
			 ) as Reserved,
			 			 
			 (
				SELECT ISNULL(ROUND(SUM(TransactionQuantity),5),0)
				FROM   ItemTransaction 
				WHERE  ItemNo         = I.ItemNo
				AND	   TransactionUoM = U.UoM
				AND    Mission        = W.Mission
				AND	   Warehouse      = W.Warehouse
				AND    WorkOrderId is NULL 
			 ) as OnHand,
			 			 
			 (
				SELECT count(*) 
				FROM   ItemTransaction 
				WHERE  ItemNo         = I.ItemNo
				AND	   TransactionUoM = U.UoM
				AND    Mission        = W.Mission
				AND	   Warehouse      = W.Warehouse
				AND    TransactionType IN ('0','1')
			 ) as Receipts,		
			 
			  (
				SELECT sum(TransactionValue) 
				FROM   ItemTransaction 
				WHERE  ItemNo         = I.ItemNo
				AND	   TransactionUoM = U.UoM
				AND    Mission        = W.Mission
				AND	   Warehouse      = W.Warehouse
				AND    TransactionType IN ('0','1')
			 ) as ReceiptsValue,			 
						 
			 (
				SELECT count(*) 
				FROM   ItemTransaction 
				WHERE  ItemNo         = I.ItemNo
				AND	   TransactionUoM = U.UoM
				AND    Mission        = W.Mission
				AND	   Warehouse      = W.Warehouse
				AND    TransactionQuantity > 0
			 ) as RecordsIn,
			 
			  (
				SELECT count(*) 
				FROM   ItemTransaction 
				WHERE  ItemNo         = I.ItemNo
				AND	   TransactionUoM = U.UoM
				AND    Mission        = W.Mission
				AND	   Warehouse      = W.Warehouse
				AND    TransactionQuantity < 0
			 ) as RecordsOut,
			 
			  (
				SELECT ROUND(SUM(TransactionValue),2)
				FROM   ItemTransaction 
				WHERE  ItemNo         = I.ItemNo
				AND	   TransactionUoM = U.UoM
				AND    Mission        = W.Mission
				AND	   Warehouse      = W.Warehouse
				<!--- only real stock --->
				AND    WorkOrderId is NULL 
			 ) as Amount
			
	FROM     ItemWarehouse IW 
			 INNER JOIN Warehouse W 
				ON IW.Warehouse = W.Warehouse 
			 INNER JOIN ItemUoM U 
				ON IW.ItemNo = U.ItemNo 
				AND IW.UoM = U.UoM
			 INNER JOIN Item I
				ON IW.ItemNo = I.ItemNo
	WHERE     IW.ItemNo = '#URL.ID#' 
	<cfif url.mission neq "">
	and IW.Warehouse IN (SELECT Warehouse FROM Warehouse WHERE Mission = '#url.mission#')
	</cfif>
	
	) as XL
	
	WHERE     RecordsIn > 0  
	ORDER BY  Mission, Warehouse
	
</cfquery>
	
<table width="98%" align="center" class="navigation_table formpadding">
	 
	<tr><td height="6"></td></tr>  
	
	<cfif ItemList.recordcount eq 0>
	
		<tr>
			<td class="labelmedium" align="center" style="font-size:20px;padding-top:20px">
				<cf_tl id="Stock level is 0 in all warehouses">.
			</td>
		</tr>
	
	<cfelse>
	
		<cfoutput query="ItemList" group="Mission">
		
			<tr><td class="labelmedium" colspan="6" height="25" style="font-size:24px;;padding-left:9px">#Mission#</td></tr>
			
			<cfif getAdministrator("#mission#") eq "1">
			
			<tr>
			
			<td colspan="13">
			
				<table width="100%">
				
					<cfquery name="get" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * FROM Ref_ParameterMission
					WHERE Mission = '#mission#'
					</cfquery>
				
					<tr class="line fixlengthlist">
					<td align="center" class="labellarge">		
					This item is valued under #ItemList.ValuationCode#. 
					    Recalculate #mission# stock and ledger transactions younger than #dateformat(get.RevaluationCutoff,client.dateformatshow)# using the below button.				
					</td>							
					</tr>						
						
					<tr class="fixlengthlist">
					<td align="center" class="labelmedium">		
					   <font color="0080C0"><cf_tl id="Attention"> : <cf_tl id="Uncheck the regular revaluation checkbox">, <cf_tl id="if you want to enforce values to reduce to the stock levels">.
					</td>							
					</tr>										
						
					<tr><td id="#mission#" align="center" style="padding:4px">
					
					<table><tr class="labelmedium">
					   
					   <td style="padding-right:5px">
					   		<cf_tl id="Standard Valuation">:
					   		<br><span style="font-size:10px; color:8C8C8C; font-style:italic;">(<cf_tl id="Uncheck to FORCE suspicious valuation">)</span>
					   	</td>
					   <td style="padding-right:10px">
					   <input type="checkbox" style="height:16px;height:16px" class="radiol" id="transferrevaluation" value="1" checked>
					   
					   </td>
					   
					   <td class="labelit">
					   	<cf_tl id="Revaluate stock" var="1">
						<input class="button10g" type="button" value="#lt_text#" name="Recalculate" style="width:300px" onClick="doReevaluate('#url.id#','#mission#','#url.mode#');">
					   </td>
					   </tr></table>
					</td></tr>
					
					<tr class="fixlengthlist"><td class="labelit" align="center"><font color="gray"><i>The process may take some time and will proceed even if you close the screen.</td></tr>
				
					
					
				</table>
			
			</td></tr>		
			
			</cfif>
			
			<tr class="labelmedium2 line fixlengthlist">
			<td width="10"></td>
			<td><cf_tl id="Warehouse"></td>
			<td><cf_tl id="UoM"></td>			
			<td><cf_tl id="Barcode"></td>
			<td align="center"><cf_tl id="Standard"></td>
			<td align="center"><cf_tl id="Receipts"></td>
			<td align="center"><cf_tl id="Value"></td>
			<td align="center"><cf_tl id="Movements"></td>
			<td align="center"><cf_tl id="Minimum"></td>
			<td align="center"><cf_tl id="Maximum"></td>
			<td align="center"><cf_tl id="Reserved"></td>
			<td align="center"><cf_tl id="On Hand"></td>
			<td align="center"><cf_tl id="Cost"></td>
			<td align="center"><cf_tl id="Value">#application.basecurrency#</td>
	    	</tr>		
			
			<cfoutput group="Warehouse">
			
				<tr class="labelmedium2 line">
					<td></td>
					<td colspan="12">#WarehouseName# (#warehouse#)</td>				
					
					<td align="right">
					
					<cfquery name="total" dbtype="query">
						SELECT SUM(Amount) as Amount
						FROM   ItemList
						WHERE  Warehouse = '#Warehouse#'
					</cfquery>
					
					<cfif Total.Amount eq "0">
					-
					<cfelse>
					#lsNumberFormat(Total.Amount,",.__")#
					</cfif>
					
					</td>
				</tr>
				
			<cfoutput>
				<tr class="labelmedium2 line navigation_row fixlengthlist">
					<td></td>
					<td></td>
					<td>#UoMDescription# (#uom#)</td>					
					<td>#ItemBarCode#</td>
					<td align="right" bgcolor="FDFEDE" style="border-left:1px solid gray;">#numberformat(StandardCost,",.__")#</td>
					<td align="right" bgcolor="e4e4e4" style="border-left:1px solid gray;">#Receipts#</td>
					<td align="right" bgcolor="e4e4e4" style="border-left:1px solid gray;">#numberformat(ReceiptsValue,",.__")#</td>					
					<td>
						<table width="100%" height="100%">
						<tr>
							<td width="50%" align="right" style="border-left:1px solid gray;">+ #RecordsIn#</td>
							<td width="50%" align="right" style="border-left:1px solid gray;">- #RecordsOut#</td>
						</tr>
						</table>
					</td>					
					<td align="right" style="border-left:1px solid gray;">#MinimumStock#</td>
					<td align="right" style="border-left:1px solid gray;">#MaximumStock#</td>
					
					<cfif Reserved neq "0">
					
						<cfset color="ffffaf">						
						<cfif Reserved lt 0>						
							<cfset color = "ff8080">
						</cfif>
						
						<td align="right" bgcolor="#color#" style="border-left:1px solid gray;">
							<cf_precision number="#ItemPrecision#">																														
							#lsNumberFormat(Reserved,pformat)#
						</td>
						
					<cfelse>
					
					<td align="right" style=";border-left:1px solid gray;">-</td>
					
					</cfif>
					
					<cfif OnHand neq "0" and Amount neq 0>
					
						<cfset color="DAF9FC">
						<cfif OnHand lt 0>
							<cfset color = "ff8080">
						</cfif>
						
						<td align="right" bgcolor="#color#" style="border-left:1px solid gray;">
							<cf_precision number="#ItemPrecision#">																														
							#lsNumberFormat(OnHand,pformat)#
						</td>
						
					<cfelse>
					
					<td align="right" style=";border-left:1px solid gray;">-</td>
					
					</cfif>
					
					<cfif Onhand neq "0">
						<cfset price = Amount/Onhand>
					<cfelse>
					    <cfset price = "0">
						<cfset ratio = "99">
					</cfif>	
					
					<cfif standardCost neq ""  and standardcost neq "0">
						<cfset ratio = price/StandardCost>
					<cfelse>
						<cfset ratio = "1">				
					</cfif>
					
					<cfif ratio lte 3 and ratio gte -3 and Onhand neq "0">					
					<td align="right" bgcolor="DEF8EF" style="border-left:1px solid gray">					 
						#lsNumberFormat(Price,",.__")#				 
					</td>
					<cfelse>
					<td align="right" style="border-left:1px solid gray">-</td>
					</cfif>	
					
					<td align="right" style="padding-right:15px;border-left:1px solid gray;">			
					    <cfif Amount eq "0">-<cfelse>#lsNumberFormat(Amount,",.__")#</cfif>								
					</td>
				</tr>
			</cfoutput>
			
			<tr><td height="5" id="__cbReevaluation"></td></tr>
			
			</cfoutput>	
			
		</cfoutput>
	
	</cfif>
	
</table>

<cfset ajaxonload("function() { doHighlight(); }")>