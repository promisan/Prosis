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
<cfparam name="url.workorderid" default="00000000-0000-0000-0000-000000000000" >

<!--- get the location of the item --->

<!--- warehouse + item is selected
	- service item
	- regular item
 which drives the stock on-hand by location
 show quantity by location
 if no stock present the default location for that warehouse.
--->

<!--- url.mode : determine if we can only take from valid locations --->

<cfquery name="Whs" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   *
		FROM     Warehouse	
		WHERE    Warehouse      = '#url.warehouse#' 		
</cfquery>

<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   *
		FROM     Item I, Ref_Category R	
		WHERE    I.Category = R.Category
		AND      I.Itemno = '#url.itemno#' 		
</cfquery>

<cfif get.StockControlmode eq "Individual" and (url.mode eq "sale" or url.mode eq "disposal" or url.mode eq "issue")>

	<table width="99%" cellspacing="0" cellpadding="0">
		<tr><td class="labelmedium" colspan="2"><font color="FF0000"><cf_tl id="Function not supported for indidual stock"></td></tr>		
	</table>
	
	<script>
	 document.getElementById('addline').className = 'hide'
	</script>
	
	<cfabort>		
	
<cfelse>

	<script>
	 document.getElementById('addline').className = 'regular'
	</script>

</cfif>

<!--- determine the lot mode --->

<cfquery name="Param" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT   *
		FROM     Ref_ParameterMission	
		WHERE    Mission = '#whs.mission#' 		
</cfquery>

<cfif param.LotManagement eq "0">	
	
	<cfquery name="Get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT   L.Location, 
			         L.Description,
					 L.StorageCode,	
					 (
					 SELECT SUM(TransactionQuantity)
					 FROM   ItemTransaction I
					 WHERE  I.Warehouse      = '#url.warehouse#' 
					 AND    I.Location       = L.Location
					 AND    I.ItemNo         = '#url.itemno#' 
					 AND    I.TransactionUoM = '#url.uom#'
					 ) as Stock				
			FROM     WarehouseLocation L INNER JOIN
			         ItemWarehouseLocation R ON R.Warehouse = L.Warehouse AND R.Location = L.Location  
			WHERE    R.Warehouse    = '#url.warehouse#' 
			AND      R.ItemNo       = '#url.itemno#' 
			AND      R.UoM          = '#url.uom#'
			AND      R.Operational = 1
			AND      L.Operational = 1
			GROUP BY L.Location, L.Description, L.StorageCode
	</cfquery>
	
	<cfquery name="ItemUoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT   *
			FROM     ItemUoMMission I
			WHERE    I.ItemNo   = '#url.itemno#' 	
			AND      I.UoM      = '#url.uom#' 
			AND      I.Mission  = '#whs.mission#'  
	</cfquery>
	
	<cfif ItemUoM.recordcount eq "0">
		
		<cfquery name="ItemUoM" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT   *
				FROM     ItemUoM I
				WHERE    I.ItemNo   = '#url.itemno#' 	
				AND      I.UoM      = '#url.uom#'   
		</cfquery>
	
	</cfif>
	
	<table width="99%" cellspacing="0" cellpadding="0">
	
	<cfoutput>
	
	<cfif get.recordcount eq "0">	
			
		<cfif url.mode neq "sale">
			
			<cfquery name="Loc" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT   *
				FROM     WarehouseLocation	
				WHERE    Warehouse   = '#url.warehouse#' 		
				AND      Location    = '#whs.locationreceipt#' 
			</cfquery>
		
			<tr>
			  <td></td>
			  <td></td>
			  <td>
			  <input type="hidden" name="location1" id="location1" value="#loc.location#">
			  <input type="text" name="location1_quantity" id="location1_quantity" value="1" class="regularxl" style="text-align:right" size="5" maxlength="6">	
			  </td>
			  <td align="right" style="padding-left:4px">#numberformat(itemuom.standardcost,",.__")#</td>
			  <td align="right" width="100" style="padding:left:4px">
			  
			    <input type="text" name="location1_sales" id="location1_sales"
					 style="text-align:right"
					 value = "#numberformat(itemuom.standardcost,'.__')#"
					 class="regularxl" 
					 size="6" 
					 maxlength="10">		
			
			  </td>
			
			</tr>	
			
			<input type="hidden" name="rows" id="rows" value="1">
			
			    <script>
				  document.getElementById("addline").className = "regular"
				</script>
			
			<cfelse>
			
				<tr><td align="center" height="30" class="labelit">
				     <font color="FF0000"><cf_tl id="Item is not available in this warehouse"></font>
					 </td>
				</tr>
				
				<script>
				  document.getElementById("addline").className = "hide"
				</script>
		
		</cfif>
	
	<cfelse>
	
		<tr class="labelmedium line fixlengthlist">
		  <td style="padding:2px"><cf_tl id="Location"></td>
		  <td style="padding:2px" align="right"><cf_tl id="On Hand"></td>
		  <td style="padding:2px" align="right"><cf_tl id="Quantity">&Delta;</td>	
		  <td style="padding:2px" align="right"><cf_tl id="Reference"></td>	  	
		  <td style="padding:2px" align="right"><cf_tl id="Cost Price"></td>	 	
		  <td style="padding:2px" align="right"><cf_tl id="Sales">/<cf_tl id="Charge"></td>	 	
		</tr>
		
		<cfloop query="Get">
		
			<tr class="labelmedium fixlengthlist">
			  <td style="padding:2px">#Location# #Description# <cfif storagecode neq "">(#StorageCode#)</cfif></td>
			  <td width="100" style="padding:2px" align="right"><cfif stock lt 0><font color="FF0000"></cfif>
			  	<cfif isNumeric(stock)>
				  	<cfif stock neq ceiling(stock)>
				  			#numberformat(stock,",.__")#
				  	<cfelse>
				  			#numberformat(stock,",")#
				  	</cfif>
				</cfif>
			  </td>
			  <td width="100" style="padding:2px" align="right">
			  <input type="hidden" name="location#currentrow#" id="location#currentrow#" value="#location#">
			  <input type="text" name="location#currentrow#_quantity" id="location#currentrow#_quantity" style="text-align:center" class="regularxl" size="5" maxlength="10">
			  </td>
			  <td align="right">
			  <input type="text" name="location#currentrow#_reference" id="location#currentrow#_reference" style="text-align:center" class="regularxl" size="8" maxlength="10">
			  </td>
			  <td align="right">
			  
			   <input type="text" name="location#currentrow#_prc" id="location#currentrow#_prc"
				 style="text-align:right" value = "#numberformat(itemuom.standardcost,",.__")#" class="regularxl" size="6" maxlength="10">		
			  			  
			  </td>
			  
			  <!--- obtain the sales price of the item defined --->
			  <cfset cur = application.basecurrency>	
			  
			  <cf_VerifyOperational Module="WorkOrder">
	
			  <cfif operational eq "1">
			
				  <cfquery name="Workorder" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						SELECT   *
						FROM     WorkOrder	
						WHERE    WorkOrderId = '#url.workorderid#' 							
				  </cfquery>
				
				  <cfif workorder.recordcount eq "1">
					  <cfset cur = workorder.currency>
				  </cfif>
				
			   </cfif>
			  
			  <cfinvoke component = "Service.Process.Materials.POS"  
				   method           = "getPrice" 
				   warehouse        = "#url.warehouse#" 			   			   			   
				   currency         = "#cur#"
				   ItemNo           = "#url.itemno#"
				   UoM              = "#url.uom#"
				   quantity         = "1"
				   returnvariable   = "sale">	
			  
			  <td align="right">		  
			    <input type="text" name="location#currentrow#_sales" id="location#currentrow#_sales"
				 style="text-align:right" value = "#numberformat(sale.price,'.__')#" class="regularxl" size="6" maxlength="10">			
			  </td>		
			</tr>
		
		</cfloop>	
		
		<input type="hidden" name="rows" id="rows" value="#get.recordcount#">
		
		<script>
		  document.getElementById("addline").className = "regular"
		</script>
	
	</cfif>
	
	</cfoutput>
	
	</table> 
	
<cfelse>

	<cfquery name="Get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			
			SELECT   L.Location, 
			         L.Description,
					 L.StorageCode,		
					
					 R.TransactionLot,
					 P.TransactionLotDate,
					 
					 SUM(TransactionQuantity) as Stock	
					 				
			FROM     ItemTransaction R INNER JOIN
                     WarehouseLocation L ON R.Warehouse = L.Warehouse AND R.Location = L.Location INNER JOIN
                     ProductionLot P ON R.Mission = P.Mission AND R.TransactionLot = P.TransactionLot
					 
			WHERE    R.Warehouse       = '#url.warehouse#' 
			AND      R.ItemNo          = '#url.itemno#' 
			AND      R.TransactionUoM  = '#url.uom#'
			AND      L.Operational     = 1
			
			GROUP BY R.TransactionLot,
					 P.TransactionLotDate,
					 L.Location, 
					 L.Description, 
					 L.StorageCode
					 
			<cfif url.mode eq "Initial">
			
			UNION
			
			SELECT   L.Location, 
			         L.Description,
					 L.StorageCode,
					 '0' as TransactionLot,
					 getDate() as TransactionLotDate,
					 0 as Stock			
					 					
			FROM     WarehouseLocation L INNER JOIN
			         ItemWarehouseLocation R ON R.Warehouse = L.Warehouse AND R.Location = L.Location  
			WHERE    R.Warehouse     = '#url.warehouse#' 
			AND      R.ItemNo        = '#url.itemno#' 
			AND      R.UoM           = '#url.uom#'				
			AND      R.Operational = 1
			GROUP BY L.Location, L.Description, L.StorageCode
			
			
			</cfif>		 
			
	</cfquery>
		
	<!--- only initial stock --->
	
	<cfif get.recordcount eq "0" and url.mode eq "Initial">
	
			
		<!--- item is not stored as transaction, so we check if it has preset locations recorded --->
	
		<cfquery name="Get" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT   L.Location, 
				         L.Description,
						 L.StorageCode,
						 0 as TransactionLot,
						 0 as Stock								
				FROM     WarehouseLocation L INNER JOIN
				         ItemWarehouseLocation R ON R.Warehouse = L.Warehouse AND R.Location = L.Location  
				WHERE    R.Warehouse     = '#url.warehouse#' 
				AND      R.ItemNo        = '#url.itemno#' 
				AND      R.UoM           = '#url.uom#'				
				AND      R.Operational = 1
				GROUP BY L.Location, L.Description, L.StorageCode
		</cfquery>
		
		<cfif get.recordcount eq "0">
		
			<!--- if still now found we pass the default location here to be recorded initially --->
		
			<cfquery name="Get" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT   L.Location, 
				         L.Description,
						 L.StorageCode,
						 0 as TransactionLot,
						 0 as Stock								
				FROM     Warehouse R, WarehouseLocation L 
				WHERE    R.Warehouse    = '#url.warehouse#' 
				AND      R.Warehouse = L.Warehouse
				AND      R.LocationReceipt = L.Location				
				GROUP BY L.Location, L.Description, L.StorageCode
			</cfquery>
					
		</cfif>
		
	</cfif>
		
	<cfquery name="ItemUoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT   *
			FROM     ItemUoMMission I
			WHERE    I.ItemNo   = '#url.itemno#' 	
			AND      I.UoM      = '#url.uom#' 
			AND      I.Mission  = '#whs.mission#'  
	</cfquery>
	
	<cfif ItemUoM.recordcount eq "0">
		
		<cfquery name="ItemUoM" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT   *
				FROM     ItemUoM I
				WHERE    I.ItemNo   = '#url.itemno#' 	
				AND      I.UoM      = '#url.uom#'   
		</cfquery>
	
	</cfif>
	
	<table width="99%" cellspacing="0" cellpadding="0">
	
		<cfif get.recordcount eq "0">
				
				<tr><td align="center" height="30" class="labelit">
				<font color="FF0000"><cf_tl id="Item is not available in this warehouse"></font></td>
				</tr>
				
				<script>
				  document.getElementById("addline").className = "hide"
				</script>
		
		<cfelse>
		
			<tr class="line labelmedium fixlengthlist">
			  <td><cf_tl id="Location"></td>
			  <td align="right"><cf_tl id="On Hand"></td>
			  <td align="right"><cf_tl id="Quantity">&Delta;</td>	 
			  <td align="right"><cf_tl id="Reference"></td>	  	
			  <td align="right"><cf_tl id="Est. Price"></td>	 	
			  <td align="right"><cf_tl id="Sales">/<cf_tl id="Charge"></td>	 	
			</tr>
							
			<cfoutput query="Get" group="TransactionLot">	
				
				<cfif transactionlot eq "0">
					<cfif url.mode neq "initial">
					<tr class="line fixlengthlist">
					<td colspan="6" style="height:30" class="labelmedium"><cf_tl id="No lot"></td>
					</tr>
					</cfif>
				<cfelse>
					<tr class="line fixlengthlist"><td colspan="6" class="labelmedium">
					<font color="0080C0">#TransactionLot#</font> <font size="2">[#dateformat(TransactionLotDate,client.dateformatshow)#]
					</td></tr>					
				</cfif>		
				
				<cfoutput>				
								
				<input type="hidden" name="location#currentrow#_lot" id="location#currentrow#_lot" value="#transactionlot#">				

				<input type="hidden" name="location#currentrow#"     id="location#currentrow#"     value="#location#">				
				
					<tr class="fixlengthlist">
					  <td style="padding:2px" class="labelit"><cfif transactionlot neq "0">&nbsp;&nbsp;&nbsp;</cfif>#Location# #Description# (#StorageCode#)</td>
					  <td width="100" style="padding:2px" align="right" class="labelit">
					  <cfif stock lt 0><font color="FF0000"></cfif>#numberformat(stock,"__,__")#
					  </td>
					  <td width="100" style="padding:2px" align="right">		
					  			  
						  <input type="text" 
						       name="location#currentrow#_quantity" 
							   id="location#currentrow#_quantity" 
							   style="text-align:center" 
							   class="regularxl" 
							   size="5" 
							   maxlength="10">
							   
					  </td>
					  <td width="100" style="padding:2px" align="right">	
					  <input type="text" name="location#currentrow#_reference" id="location#currentrow#_reference" style="text-align:center" class="regularxl" size="10" maxlength="15">
					  </td>
					  <td align="right">#numberformat(itemuom.standardcost,",.__")#</td>
					  
					  <td align="right">		  
					    <input type="text" name="location#currentrow#_sales" id="location#currentrow#_sales"
						 style="text-align:right" value = "#numberformat(itemuom.standardcost,'.__')#" class="regularxl" size="6" maxlength="10">			
					  </td>		
					  
					</tr>
				
				 </cfoutput>
						
			</cfoutput>	
						
			<cfoutput>
			
				<input type="hidden" name="rows" id="rows" value="#get.recordcount#">
				
				<script>
				  document.getElementById("addline").className = "regular"
				</script>
			
			</cfoutput>			
		
	</cfif>
	
</cfif>

	