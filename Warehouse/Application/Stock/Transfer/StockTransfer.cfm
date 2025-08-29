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
<cfparam name="url.mode" default="""">
<cfparam name="url.whs" default="">
<cfparam name="url.id" default="">
<cfparam name="url.warehouse" default="">
<cfif url.whs eq "">
	<cfset url.whs = url.warehouse>
</cfif>
<cfif url.warehouse eq "">
	<cfset url.warehouse = url.whs>
</cfif>

<cfif mode eq "delete">

	<cfquery name="Update"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE userTransaction.dbo.Transfer#URL.whs#_#SESSION.acc#
		SET    TransferQuantity  = NULL, 
		       TransferLocation  = NULL
		WHERE  TransactionId    = '#URL.Id#'
	</cfquery>
	
	<cfoutput>
	<script>
	document.getElementById('transfer#url.id#row').className = "hide"
	</script>
	</cfoutput>
	
	<cfabort>	

</cfif>

<cfif url.stockorderid neq "">

	<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    TaskOrder
		WHERE   StockOrderId = '#URL.StockOrderId#'
	</cfquery>	
	
	<cfquery name="loc"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    WarehouseLocation
		WHERE   Warehouse = '#get.Warehouse#'
		AND     Location  = '#get.Location#'
	</cfquery>		
	
</cfif>

<cfif url.mode eq "quick">

	<cfoutput>
	<input type  = "text"
     name        = "transferquantity#TransactionId#"
	 id          = "transferquantity#TransactionId#"
     value       = "#TransferQuantity#"
     size        = "8"
     style       = "height:100%;text-align:right;padding-right:3px;border:0px;border-left:1px solid silver;border-right:1px solid silver;background-color:ffffaf"
     onchange    = "trfsave('#TransactionId#',document.getElementById('warehouseto').value,document.getElementById('locationto').value,'','','',this.value,'','',document.getElementById('transaction_date').value,document.getElementById('transaction_hour').value,document.getElementById('transaction_minute').value)"
	 maxlength   = "10"
	 class       = "regularxl enterastab"> 
	 
	 </cfoutput>

<cfelse>
		
		<table width="100%" class="formpadding">
		
			<tr class="line">
			<td style="padding-left:30px;padding-right:60px">
						
			<table width="100%">
			
			<cfquery name="Transaction"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT  * 
					  FROM    userTransaction.dbo.Transfer#URL.Whs#_#SESSION.acc#
					  WHERE   TransactionId = '#URL.Id#'  
				</cfquery>	
											
				<table width="95%" align="center">
									
				<cfoutput>
						
				<!--- ---------------- --->
				<!--- -----Facility--- --->
				<!--- ---------------- --->
						
				<cfif url.stockorderid neq "">
				
					 <!--- defined by the embedded transaction --->			
					<input type="hidden" name="transferwarehouse#url.id#" id="transferwarehouse#url.id#" value="#get.warehouse#">
				
				<cfelse>
				
					<cfquery name="CheckEnableConversion"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT    *
					  FROM      ItemWarehouseLocationTransaction
					  WHERE     Warehouse = '#Transaction.Warehouse#' 
					  AND       Location  = '#Transaction.location#' 
					  AND       ItemNo    = '#Transaction.ItemNo#' 
					  AND       UoM       = '#Transaction.UnitOfMeasure#' 						 
					  AND       TransactionType = '6' 
					  AND       Operational     = '1'
			       </cfquery>		
				
				   <cfif url.stockorderid neq "" or CheckEnableConversion.recordcount eq "0">
				      <cfset conversion = "0">		
				   <cfelse>	
				      <cfset conversion = "1">
				   </cfif>		
					
					<tr class="labelmedium">
						<td width="40"></td>
						<td style="min-width:150px"><cf_tl id="Destination">:</td>
						
						<td style="width:100%">
												
						<table cellspacing="0" cellpadding="0">
						
							 <cfquery name="Warehouse"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT 	*
									FROM   	Warehouse W
									WHERE  	Mission   = '#Transaction.Mission#'	
									AND     (
									
									         Warehouse = '#URL.whs#' 
											 OR 
											 Warehouse IN (SELECT AssociationWarehouse
									                       FROM   WarehouseAssociation 
														   WHERE  Warehouse           = '#URL.whs#'
														   AND    AssociationType     = 'Transfer'
														   AND    AssociationWarehouse = W.Warehouse
														   )
																							
											)												
									
																							
							 </cfquery>	
							 
							 <cfquery name="WarehouseCat"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							 		SELECT 	Warehouse 
									FROM 	WarehouseCategory
									WHERE	Operational = 1
									AND		Category = (SELECT TOP 1 Category FROM Item WHERE ItemNo = '#Transaction.ItemNo#')
							</cfquery>
							
							<cfif transaction.TransferWarehouse eq "">
									<cfset getwhs = url.whs>
									<cfset getLoc = "">
									
							<cfelse>
									<cfset getwhs = transaction.TransferWarehouse>
									<cfset getLoc = transaction.TransferLocation>
									
							</cfif>
							
							<tr><td>
							
							<cfset loclink = "ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transfer/getLocation.cfm?loc=#url.loc#&conversion=#conversion#&whs=#url.whs#&id=#url.id#&transactionid=#Transaction.TransactionId#&warehouse='+this.value+'&location=#Transaction.Location#&selected=#transaction.transferlocation#','locationbox#url.id#')">
											
							 <select name  = "transferwarehouse#url.id#"
							    id         = "transferwarehouse#url.id#" 
								class      = "regularxl"
								style      = "width:200"
							    onchange   = "#loclink#;trfsave('#Transaction.TransactionId#',this.value,'','','','',document.getElementById('transferquantity#url.id#').value,document.getElementById('transfermemo#url.id#').value,document.getElementById('itemuomid#url.id#').value,document.getElementById('transaction#url.id#_date').value,document.getElementById('transaction#url.id#_hour').value,document.getElementById('transaction#url.id#_minute').value)">
							   
								   <cfloop query="Warehouse">
								   
								   		<cfif lcase(ModeSetItem) eq "category">
											
											<cfquery name="qWarehouseCat" dbtype="query">
												SELECT 	*
												FROM 	WarehouseCat
												WHERE	Warehouse = '#Warehouse#'
											</cfquery>
											
											<cfif qWarehouseCat.recordCount gt 0>
											
												<option value="#Warehouse#" <cfif Warehouse eq getwhs>selected</cfif>>#warehouse# #WarehouseName#</option>
												
											</cfif>
											
										<cfelse>
										
											<option value="#Warehouse#" <cfif Warehouse eq getwhs>selected</cfif>>#warehouse# #WarehouseName#</option>
											
										</cfif>
										
									</cfloop>
								
							 </select>	
							 
							 </td>
							 
							 
							 
							 <!--- ---------------- --->
							 <!--- Storage Location --->
							 <!--- ---------------- --->
														 
							 <cfif url.stockorderid neq "">
				
							    <!--- defined by the embedded transaction --->			
								<input type="hidden" name="transferlocation#url.id#" id="transferlocation#url.id#" value="#get.location#">
							
							<cfelse>
							
								<td width="65%" style="padding-left:3px" id="locationbox#url.id#">	
									
									<cfset url.conversion    = conversion>
									<cfset url.warehouse     = getwhs>
									<cfset url.location      = getloc>				
									<cfset url.selected      = transaction.transferlocation>
									<cfset url.transactionid = transaction.TransactionId>
														
									<cfinclude template="getLocation.cfm">								
													 
								</td>	
								
								<td style="padding-left:3px">
								
								 <input class="button10g" type="button" value="Inquiry" style="width:80px"
								 onclick="stockinquiry('#Transaction.ItemNo#',document.getElementById('transferwarehouse#url.id#').value,'#Transaction.UnitOfMeasure#','');">
								 							 
								 </td>							
							
							</cfif>		
							
						 </tr>
							 
						 </table> 	
						
						</td>	
											
						
						<td>
						
							<table width="100%">
							<tr style="padding-top:2px;padding-left:30px">
											    
								<cfoutput>			
								<td align="left" style="padding-left:4px;cursor:pointer" id="f#Transaction.TransactionId#" valign="top" 
								 onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transfer/StockTransfer.cfm?mode=delete&warehouse=#url.whs#&id=#url.id#','transfer#url.id#')">			
								 <cf_img icon="delete">								 		
								</td>			
								</cfoutput>
							
							</tr>
							</table>	
						
						</td>
					
					</tr>
					
				</cfif>		
				
				<tr><td style="height:3px"></td></tr>				
				
				<!--- ----------------------------------------- --->
				<!--- ---Receive as Item but ONLY if enabled--- --->
				<!--- ----------------------------------------- --->		
				
				<cfif url.stockorderid neq "" or CheckEnableConversion.recordcount eq "0">
				
				    <!--- defined by the embedded transaction and migration to another item is not supported here --->			
							
					<input type="hidden" name="itemuomid#url.id#"  id="itemuomid#url.id#"  value="">
						
				<cfelse>
				
					<tr class="labelmedium">
					<td width="40"></td>
					<td valign="top"><cf_tl id="Product">:</td>
					<td width="90%" id="itembox#url.id#">	
					
					    <!--- we show the items of the source and the items that are supported for this location selected --->		
						
					</td>
					
					</tr>
				
				</cfif>	
				
				<!--- ---------------- --->
				<!--- --- Quantity --- --->
				<!--- ---------------- --->
					
				<cfquery name="Category"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  *
					FROM    Ref_Category
					WHERE   Category = '#Transaction.Category#'
				</cfquery>		
				
				<cfif Category.DistributionMode eq "Meter">
				
					<!--- receipt / device --->
						
					<cfquery name="get" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT * 
					  FROM   Warehouse 
					  WHERE  Warehouse = '#url.whs#'
				    </cfquery>		
					
					<!--- receipt / device --->
						
					<cfquery name="param" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT * 
					  FROM   Ref_ParameterMission 
					  WHERE  Mission = '#get.Mission#'
				    </cfquery>		
					
					<!--- Fuel, determine if transfer is through a deviced --->		
					
					<cfquery name="Lookup" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   
						SELECT   DISTINCT AssetBarCode, Description
						FROM     AssetItem A
						WHERE    Mission = '#get.Mission#'
						AND      Operational = 1 
						<!--- receipt devicde--->
						AND      ItemNo IN  (SELECT  ItemNo
				                             FROM    Item
				                             WHERE   ItemNo = A.ItemNo 
											 AND     Category = '#param.ReceiptDevice#')
						<!--- is hold by the warehouse of the receipt --->	
								
						AND      AssetId IN (
						                   SELECT  AssetId
				                           FROM    AssetItemOrganization O
										   
										   <!--- all orgunit in different mandates --->
										   
					                       WHERE   OrgUnit IN  (SELECT OrgUnit
					                                            FROM   Organization.dbo.Organization
					                                            WHERE  MissionOrgUnitId IN (#QuotedValueList(get.MissionOrgUnitId)#))
											
										   <!--- only the last effective date for an item --->		
										   			   
										   AND     DateEffective  =   (SELECT  MAX(DateEffective)
					                                                   FROM    AssetItemOrganization
					                                                   WHERE   AssetId = A.AssetId) 
																	  
									 )	
									 
															  
																   
					</cfquery>	
					
					<cfset qty = Transaction.TransferQuantity>
					<cfif qty eq "">
						 <cfset qty = "0">
					</cfif>		
					
					 <cfif lookup.recordcount eq "0">	
					 
					    <!--- standard mode --->
				
						<tr class="labelmedium">
						<td width="40"></td>
						<td style="height:28px" width="70%"><font color="808080"><cf_tl id="Transfer Quantity">:</td>
						<td>
			
							<input type    = "text"
							     name      = "transferquantity#url.id#"
								 id        = "transferquantity#url.id#"
							     value     = "#qty#"
							     size      = "10"
							     style     = "text-align:right"
							     onchange  = "trfsave('#Transaction.TransactionId#',document.getElementById('transferwarehouse#url.id#').value,document.getElementById('transferlocation#url.id#').value,'','','',this.value,document.getElementById('transfermemo#url.id#').value,'',document.getElementById('transaction#url.id#_date').value,document.getElementById('transaction#url.id#_hour').value,document.getElementById('transaction#url.id#_minute').value)"
								 maxlength = "10"
								 class     = "regularxl"> 
						</td>	
						</tr>
					
					<cfelse>
						
						<tr class="labelmedium">
						<td width="40"></td>
						<td width="20%" style="padding-left:0px"><cf_tl id="Pump">:</td>
						<td width="70%">		
						
							   <table cellspacing="0" cellpadding="0">
							   <tr>			  
							   
						       <cfif lookup.recordcount gte "1">	
							   
							   		<td>	
										
									<select style="width:130" 
									  name     = "transfermeterselect#url.id#" 
									  id       = "transfermeterselect#url.id#"
									  onchange = "document.getElementById('transfermeter#url.id#').value=this.value;if (this.value == '') {document.getElementById('boxmeter#url.id#').className='regular'} else { document.getElementById('boxmeter#url.id#').className='hide'}"					  
									  style    = "text-align:right;>
										<option value="">Other:</option>
										<cfloop query="lookup">					
											<option value="#AssetBarCode#" <cfif Transaction.MeterName eq AssetBarCode>selected</cfif>><cfif AssetBarCode neq "">#AssetBarCode#<cfelse>#Description#</cfif></option>					
										</cfloop>											
									</select>		
									
									</td>		
									
									<td style="padding-left:4px"></td>		
									
							   </cfif>
							   			   
							   <td id="boxmeter#url.id#">	   
							   				   
								 <input type   = "text"
								     name      = "transfermeter#url.id#"
									 id        = "transfermeter#url.id#"
								     value     = "#Transaction.MeterName#"
								     size      = "8"
								     style     = "text-align:right;"
								     maxlength = "10"
									 class     = "regularxl">
										  
						 	   </td>
							   </tr>
							   </table>
							
								 
						</td>	
						</tr>	
					
						<tr class="labelmedium">
							<td width="40"></td>
							<td style="padding-left:20px"><cf_tl id="Initial">:</td>
							<td>
								
								<input type    = "text"
								     name      = "transferinitial#url.id#"
									 id        = "transferinitial#url.id#"
								     value     = "#Transaction.MeterInitial#"
								     size      = "8"
								     style     = "text-align:right;"
								     maxlength = "10"
									 onchange  = "ptoken.navigate('#SESSION.root#/warehouse/application/stock/transfer/setQuantity.cfm?transactionid=#transaction.transactionid#&field=transferquantity#url.id#&meter='+document.getElementById('transfermeter#url.id#').value+'&initial='+this.value+'&final='+document.getElementById('transferfinal#url.id#').value,'transferprocess')" 
									 class     = "regularxl">
									 
							</td>	
						</tr>	
					
						<tr class="labelmedium">
							<td width="40"></td>
							<td style="padding-left:20px"><cf_tl id="Final">:</td>
							<td>
								
								<input type    = "text"
								     name      = "transferfinal#url.id#"
									 id        = "transferfinal#url.id#"
								    value     = "#Transaction.MeterFinal#"
								     size      = "8"
								     style     = "text-align:right;"
								     maxlength = "10"
									 onchange  = "ptoken.navigate('#SESSION.root#/warehouse/application/stock/transfer/setQuantity.cfm?transactionid=#transaction.transactionid#&field=transferquantity#url.id#&meter='+document.getElementById('transfermeter#url.id#').value+'&initial='+document.getElementById('transferinitial#url.id#').value+'&final='+this.value,'transferprocess');" 				 
									 class     = "regularxl">
									 
							</td>	
						</tr>	
							
						<tr class="labelmedium">
							<td width="40"></td>
							<td class="labelmedium"><cf_tl id="Transfer Quantity">:</td>
							<td>
								
								<input type    = "text"
								     name      = "transferquantity#url.id#"
									 id        = "transferquantity#url.id#"
								     value     = "#qty#"
								     size      = "10"
									 readonly
								     style     = "text-align:right;"			    
									 maxlength = "10"
									 class     = "regularxl">
									 
							</td>	
						</tr>
					
					</cfif>
					
				<cfelse>
				
					<cfset qty = Transaction.TransferQuantity>
					<cfif qty eq "">
						 <cfset qty = "0">
					</cfif>		
				
					<!--- standard mode --->
				
					<tr class="labelmedium">
					<td width="40"></td>
					<td><cf_tl id="Quantity">:</td>
					<td>
						
						<input type    = "text"
						     name      = "transferquantity#url.id#"
							 id        = "transferquantity#url.id#"
						     value     = "#qty#"
						     size      = "10"
						     style     = "text-align:right;"
						     onchange  = "trfsave('#Transaction.TransactionId#',document.getElementById('transferwarehouse#url.id#').value,document.getElementById('transferlocation#url.id#').value,'','','',this.value,document.getElementById('transfermemo#url.id#').value,'',document.getElementById('transaction#url.id#_date').value,document.getElementById('transaction#url.id#_hour').value,document.getElementById('transaction#url.id#_minute').value)"
							 maxlength = "10"
							 class     = "regularxl">
							 
					</td>	
					</tr>
				
				</cfif>	
				
				<tr class="labelmedium">
					<td width="40"></td>
						<td><cf_tl id="Date/Time">:</td>
						<td>
						
						 <cf_getWarehouseTime warehouse="#url.whs#">
						
						 <cf_setCalendarDate
						      name     = "transaction#url.id#"     
							  id       = "transaction#url.id#"   
						      timeZone = "#tzcorrection#"     
						      font     = "14"
							  edit     = "Yes"
							  class    = "regularxl"				  
						      mode     = "datetime"> 
							  
						</td>				  
							  
				</tr>	
													
				<tr class="labelmedium">
				<td width="40"></td>
				<td><cf_tl id="Memo">:</td>
				<td>
				    
					<input type    = "text"
					     name      = "transfermemo#url.id#"
						 id        = "transfermemo#url.id#"
					     value     = "#Transaction.TransferMemo#"			  
					     style     = "width:290;text-align:left;font-size:13px;height:25"
					     onChange  = "trfsave('#Transaction.TransactionId#',document.getElementById('transferwarehouse#url.id#').value,document.getElementById('transferlocation#url.id#').value,'','','',document.getElementById('transferquantity#url.id#').value,this.value,'',document.getElementById('transaction#url.id#_date').value,document.getElementById('transaction#url.id#_hour').value,document.getElementById('transaction#url.id#_minute').value)"
						 maxlength = "100"
						 class     = "regularh">
						 
				</td>	
				</tr>
								
				</table>
			
			</td></tr>
			
			</cfoutput>	
			
			</table>
		
		</td></tr>
		</table>
		
</cfif>

<cfoutput>
<script>
	try { document.getElementById('transfer#url.id#row').className = 'regular'} catch(e) {}
</script>
</cfoutput>