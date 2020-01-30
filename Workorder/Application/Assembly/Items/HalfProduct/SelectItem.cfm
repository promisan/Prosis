
<!--- final production lines --->

<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrder
		WHERE   WorkorderId = '#url.WorkOrderId#'		
</cfquery>	 

<cfquery name="getItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item
		WHERE   ItemNo = '#url.ItemNo#'		
</cfquery>	 	

<!--- populate the items in the temp table as a basis --->

<cfquery name="Items" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *, (SELECT   ISNULL(SUM(T.TransactionQuantity), 0) AS Quantity
					FROM     ItemTransaction T 
					WHERE    T.ItemNo         = U.ItemNo 
					AND      T.TransactionUoM = U.UoM
					AND      T.Mission        = '#WorkOrder.Mission#') as OnHand
		FROM     ItemUoM U, ItemUoMMission M
		WHERE    U.ItemNo = M.ItemNo
		AND      U.UoM    = M.Uom
		AND      M.Mission = '#workorder.mission#'
		AND      U.Operational = 1	
		AND      M.Operational = 1
		AND      U.ItemNo = '#url.ItemNo#'		
</cfquery>	

<cfquery name="GetCurrency" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Currency
	WHERE	EnableProcurement = 1
	AND		Operational = 1
</cfquery>

<cfform name="frmFinalProduct" method="post" 
	  target="processFinalProduct" 
	  action="HalfProductEditSubmit.cfm?workorderid=#url.workOrderId#&workorderline=#url.workorderline#">
		
<table width="100%" class="formspacing">

	<tr><td height="2"></td></tr>
	  	  
	<tr class="line">
	  	  
	   <td valign="top" class="labelit line"><cf_tl id="UoM"></td>
	   <td valign="top" class="labelit line"><cf_tl id="On Hand"><cf_space spaces="23"></td>
	   <td valign="top" class="labelit line"><cf_tl id="Memo">/<br><cf_tl id="Warehouse"></td>	   
	   <td valign="top" class="labelit line"><cf_tl id="Quantity">/<br><cf_tl id="Lot"></td>  
	   <td valign="top" class="labelit line" align="right"><cf_tl id="Price"><cfoutput>#workorder.Currency#</cfoutput></td>		  
	    <td></td>
	   <td></td>	   
	</tr>
			
	<cfoutput query="items">
		
		<cf_assignid>
		
		<cfset workorderitemid = rowguid>
		
		<cfquery name="check" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  * 
			FROM   userTransaction.dbo.FinalProduct_#session.acc#
			WHERE  WorkOrderId   = '#url.workorderid#'
			AND    WorkOrderLine = '#url.workorderline#'
			AND    ItemNo        = '#ItemNo#'
			AND    UoM           = '#UoM#'			
	    </cfquery>	
				
	    <cfif check.recordcount eq "0">
	
			<cfquery name="add" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    INSERT INTO userTransaction.dbo.FinalProduct_#session.acc#
					(WorkOrderId, WorkOrderLine,Category,ItemNo,UoM,WorkOrderItemId)					
					VALUES					
					(
					 '#url.workorderid#',
					 '#url.workorderline#',		
					 '#GetItem.Category#',
					 '#GetItem.ItemNo#',	
					 '#UoM#',								
					 '#rowguid#'
					 )
					
			</cfquery>
			
	    <cfelse>
	
			<cfquery name="update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE userTransaction.dbo.FinalProduct_#session.acc#
				SET    WorkOrderItemId = '#rowguid#'
				WHERE  WorkOrderId     = '#url.workorderid#'
				AND    WorkOrderLine   = '#url.workorderline#'
				AND    ItemNo          = '#GetItem.ItemNo#'
				AND    UoM             = '#UoM#'						
		    </cfquery>	
	
	    </cfif>
				
		<cfset price = "0">
		   
		    <!--- --------------------------------------- --->
			<!--- determining the price for this customer --->
						
			<cfquery name="getSchedule" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     CustomerSchedule
				WHERE    CustomerId = '#workorder.customerid#' 
				AND      Category   = '#getItem.Category#' 
				AND      DateEffective <= GETDATE()
				ORDER BY DateEffective DESC				
			</cfquery>	
						
			<cfif getSchedule.recordcount eq "0">
			
				<cfquery name="getSchedule" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   TOP 1 *
					FROM     CustomerSchedule
					WHERE    CustomerId = '#workorder.customerid#' 				
					AND      DateEffective <= GETDATE()
					ORDER BY DateEffective DESC 
				</cfquery>	
							
			</cfif>
														
			<cfif getSchedule.recordcount eq "0">			
						
				<cfset price = "0">
			
			<cfelse>
													
				<cfif getSchedule.PriceMode eq "L">

					<!--- get the last price for this item which is found --->
					
					<cfquery name="getLastPrice" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
												
						SELECT  W.*
						FROM    WorkOrderLineItem W, Materials.dbo.ItemUoM U
						WHERE   W.ItemNo = U.ItemNo
						AND     W.UoM    = U.UoM
						AND     U.ItemUoMId = '#ItemUoMId#'					
						AND     WorkOrderId IN (SELECT  WorkOrderId
					                            FROM    WorkOrder
	                			                WHERE   CustomerId = '#workorder.customerid#'
												AND     Currency   = '#workorder.currency#')
						<!--- not the current workorder --->						
						AND     WorkOrderId != 	'#workorder.workorderid#'
						ORDER BY W.Created DESC
					</cfquery>	
					
					<cfif getLastPrice.recordcount eq "0">
					
							<cfset price = "0.00">
							
					<cfelse>
					
							<cfset price = getLastPrice.SalePrice>
					
					</cfif>				
			
				<cfelse>												
										
					<cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "getPrice" 
					   mission          = "#workorder.mission#" 
					   customerid       = "#workorder.customerid#"
					   currency         = "#workorder.currency#"
					   ItemNo           = "#itemno#"
					   UoM              = "#uom#"
					   quantity         = "1"
					   returnvariable   = "sale">					   				
				
					<cfset price = sale.price>
													
			</cfif>			
			
		</cfif>			
		
		<cfquery name="setPrice" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE userTransaction.dbo.FinalProduct_#session.acc#
					SET    Price = '#price#', 
					       Class1ListValue = '#UoMDescription#',
						   ItemUoMIdFinalProduct = '#ItemUoMId#'
					WHERE  WorkOrderItemId = '#workorderitemid#'			
				</cfquery>				
		
	
		<tr>
		
		<td class="labelmedium" style="padding-right:4px">#UoMDescription#</td>
				
		<td align="right" class="labelmedium" style="padding-left:15px;padding-right:1px">
				
		<cfif onhand lt "0">
		
		<table height="23" width="100%"><tr><td style="padding-right:4px" align="right" bgcolor="red"><font color="FFFFFF">#OnHand#</td></tr></table>
		
		<cfelse>
		
		<table width="100%"><tr><td style="padding-right:4px" align="right">#OnHand#</td></tr></table>
		
		</cfif>
		
		</td>		
		
		<td>
		
			<input type="text" 
			   name="Memo" 
			   id="Memo_#workorderitemid#" 
			   value="" 
			   class="regularxl enterastab" 
			   maxlength="200" 
			   style="width:100%; padding-right:2px;"  
			   onchange="_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=memo&value='+this.value,'process')">
		
		</td>
				
		<td width="90" align="right">
		
		  <cf_tl id="Please, enter a valid numeric quantity greater than 0." var="1">
		  
		  <cfinput type="text" class="regularxl enterastab" 
		           name="quantity" 
				   id="quantity_#workorderitemid#" 
				   onchange="_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=quantity&value='+this.value,'process')" 
				   value="#check.Quantity#" 
				   required="true" 
				   message="#lt_text#" 				   
				   validate="float" 
				   range="0.00000000001," 
				   style="width:100%; text-align:right; padding-right:2px;">				
				   
		</td>		
				
		<td width="100" align="right">
		
			  <table cellspacing="0" cellpadding="0">
				  <tr>				  
				  <td>
					<cf_tl id="Please, enter a valid numeric price greater than 0." var="1">
					
					<cfinput type  = "text" 
						onchange   = "_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=price&value='+this.value,'process')" 				 
						class      = "regularxl enterastab" 
						name       = "price" 
						id         = "price_#workorderitemid#" 
						value      = "#numberformat(price,",.__")#" 
						required   = "true" 
						message    = "#lt_text#" 
						validate   = "float" 
						range      = "0.0000001," 
						style      = "width:100%; text-align:right; padding-right:2px;">	
								
				  </td>				 				  
				  </tr>			  
			  </table>

		</td>
		
		<td style="padding-left:3px;padding-top:0px;padding-right:4px">
		
			
		<input type="radio" class="radioL" name="selected" 
		   value="#workorderitemid#" 
		   onchange= "_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=asDefault&value='+this.value,'process')">		
		   		   
		</td>
		
		<td style="padding-top:1px;padding-right:1px" id="copy_#workorderitemid#">		
		<img src="#session.root#/images/copy.png" title="Inherit from selected line"
			onclick="ColdFusion.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=copy&value=#workorderitemid#','process');" style="cursor:pointer" alt="Copy" border="0">		
		</td>
			
		</tr>
		
		<tr>
			<td></td>
			<td></td>
			<td>
			
			<cfquery name="qWarehouse" 
				 datasource="AppsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">		 
					 SELECT    *
					 FROM      Warehouse
					 WHERE     Mission = '#workorder.mission#'		 		  
					 AND       Operational = 1
					 AND       SaleMode = '0'
					 AND       Distribution = '1'
				</cfquery>
				
				<cfif qWarehouse.recordcount eq "0">
				
					<cfquery name="qWarehouse" 
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">		 
						 SELECT    *
						 FROM      Warehouse
						 WHERE     Mission = '#workorder.mission#'		 		  
						 AND       Operational = 1			
					</cfquery>
				
				</cfif>
				
				<select name="warehouse" id= "warehouse_#workorderitemid#" 
				   onchange= "_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=warehouse&value='+this.value,'process')" 				 
				 class="regularxl">
				     <option value=""></option>
					<cfloop query="qWarehouse">
					    <option value="#warehouse#">#WarehouseName#</option>
					</cfloop>
				</select>
						
			
			</td>
			<td>
			<cfinput type  = "text" 
				onchange   = "_cf_loadingtexthtml='';ptoken.navigate('setItemValue.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&workorderitemid=#workorderitemid#&field=transactionlot&value='+this.value,'process')" 				 
				class      = "regularxl enterastab" 
				name       = "lot" 
				id         = "lot_#workorderitemid#" 
				value      = "" 
				required   = "true" 
				message    = "#lt_text#" 						
				style      = "width:100%; text-align:right; padding-right:2px;">
			
			</td>
		
		</tr>
		
	</cfoutput>
	
</table>

</cfform>

<script>
	Prosis.busy('no');
</script>