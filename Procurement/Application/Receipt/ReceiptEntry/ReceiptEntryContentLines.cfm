
<script>
	function setQty(q, r) {
	    try {
		$('#ReceiptQuantity_'+r).val(q);
		$('#ReceiptQuantity_'+r).trigger('onchange');
		} catch(e) {}
	}
</script>

<table width="98%" style="min-width:1000px"align="center" class="navigation_table">
	 
	 <tr class="labelmedium line fixrow">
	 <td height="20"></td>
	 <td></td>
	 <td width="38%"><cf_tl id="Item"></td>
	 <td></td>
	 <td style="min-width:80px"><cf_tl id="UoM"></td>
	 <td style="min-width:50px"><cf_tl id="Vol"></td>
	 <td style="min-width:30px"><cf_tl id="Cur"></td>
	 <td style="min-width:80px" align="right"><cf_tl id="Price"></td>
	 <td style="min-width:60px" align="right"><cf_tl id="Disc"></td>
	 <td style="min-width:60px" align="right"><cf_tl id="Qty"></td>
	 <td style="min-width:100px" align="right"><cf_tl id="Total"></td>
	 <td style="min-width:80px" align="right"><cf_tl id="Tax"></td>	
	 <td style="min-width:80px" align="center"><cf_tl id="H"></td>	 
			 
	 <cfquery name="TaskOrder" 
		 datasource="AppsMaterials"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">				 
		 SELECT    *
		 FROM       RequestTask 
		 WHERE      SourceRequisitionNo IN (SELECT RequisitionNo 
		                                    FROM   Purchase.dbo.PurchaseLine 
											WHERE  PurchaseNo = '#PO.PurchaseNo#')				
		 AND        TaskType = 'Purchase'
	 </cfquery>		
			 		 
	 <cfif PO.ParameterReceiptEntry eq "1" and Taskorder.recordcount eq "0">		 
	     
		 <td width="140" align="right" style="padding-left:30px"><cf_tl id="Status"></td> 
		 
	 <cfelse>
	 
	     <td align="right" width="100" align="right"><cf_tl id="Outst."></td>
		 <td align="right" width="100" align="right">		 
		 <cf_tl id="Quantity">		 
		 </td>
		 
	 </cfif>	 
	 </tr>
	
	 <cfset rw = 0>
	 
	 <cfoutput query="Purchase">		 
	    			   
		   <cfif DeliveryStatus eq "3">
			   <cfset ce = "regular">
			   <cfset cc = "hide">
		   <cfelse>
			   <cfset ce = "hide">
			   <cfset cc = "regular">
	  	   </cfif>
		   
		   <!--- check if there are any task orders for this line --->
		   
		   <cfquery name="getTaskOrder" 
			 datasource="AppsMaterials"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			 SELECT    P.TaskId, 
			           I.ItemDescription, 
					   U.UoMDescription, 
					   R.ItemNo, 
					   R.Reference,
					   T.Reference as TaskOrderReference,
					   R.UoM, 
					   U.ItemBarCode,
					   P.ShipToDate,
					   P.ShipToWarehouse,
					   P.ShipToLocation,
						   (SELECT WarehouseName 
						    FROM   Warehouse 
							WHERE  Warehouse = P.ShipToWarehouse) as ShipToWarehouseName,
					   P.ShipToLocation,
					   P.TaskQuantity,
					   P.StockOrderId,
					   P.SourceRequisitionNo,
					   
					   <!--- get any receipts already recorded against this line --->
					   
                       (SELECT   SUM(ReceiptWarehouse)
                        FROM     Purchase.dbo.PurchaseLineReceipt
   	                    WHERE    RequisitionNo = P.SourceRequisitionNo
						AND      WarehouseTaskId = P.TaskId
						AND      ActionStatus IN ('0','1','2')) AS TaskQuantityReceived, 
						
					   P.TaskCurrency, 
					   P.TaskPrice, 
					   P.TaskAmount, 
					   P.ExchangeRate, 
               		   P.TaskAmountBase
					   
			FROM       RequestTask P INNER JOIN
               		   Request R ON P.RequestId = R.RequestId INNER JOIN
					   TaskOrder T ON P.StockOrderId = T.StockOrderId INNER JOIN
					   RequestHeader H ON R.Reference = H.Reference AND R.Mission = H.Mission INNER JOIN
	                   Item I ON R.ItemNo = I.ItemNo INNER JOIN
       		           ItemUoM U ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM
					   
			WHERE      SourceRequisitionNo = '#Requisitionno#'
			
			AND        P.TaskType = 'Purchase'			
			<!--- was not cancelled (9) or overruled as completed explicitly (3) --->			
			AND        P.RecordStatus IN ('0','1')			
			<!--- only valid taskorders --->
			AND        H.ActionStatus IN ('2p','3','5') 			
			<!--- request line not cancelled --->			 
			AND        R.Status IN ('1','2','3') 				
			ORDER BY   ShipToDate
			
		   </cfquery>	
		   
		   <cfquery name="Clear" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			    DELETE FROM stPurchaseLineReceipt
			    WHERE  OfficerUserId = '#SESSION.acc#'
		   </cfquery>		
		   			   
		   <!--- ------------------------------------- --->
		   <!--- --show only pending taskorder lines-- --->
		   <!--- ------------------------------------- --->
		   
		   <cfquery name="TaskOrder" dbtype="query">				
					SELECT * 
					FROM   getTaskOrder
					WHERE  TaskQuantityReceived < TaskQuantity 
		   </cfquery>		 	 
		   
		   <!--- show only the pending taskorder --->
		   
		   <cfif taskorder.recordcount gte "1">
		   		
			  <!--- Show task order lines to be recorded --->
				
			   <tr class="labelmedium2 linedotted">			   
		       <td align="center"></td>				   
			   <td height="18" align="center" style="padding-left:3px;padding-right:6px">#CurrentRow#.</td>
			   <td>#OrderItem#</td>
			   <td>#OrderItemNo#</td>
			   <td>#OrderUoM#</td>
			   <td style="padding-left:4px">#OrderUoMVolume#</td>
			   <td>#Currency#</td>				   
			   <td style="min-width:100px" align="right">#NumberFormat(OrderPrice,",.__")#</td>
			   <td style="min-width:100px" align="right">#NumberFormat(OrderDiscount*100,"._")#%</td>
			   <td style="min-width:100px" align="right">#NumberFormat(OrderQuantity,",__")#</td>
			   <td style="min-width:100px" align="right">#NumberFormat(OrderAmount,',.__')#</td>
			   <td style="min-width:100px" align="right">#NumberFormat(OrderAmountTax,",.__")#</td>			   
			   <td align="center"></td>
			   
			   <td colspan="2" align="right" style="padding-right:4px">
			   
				   <cfif receiptquantity gt "0">
				  				   			 		 
						<img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
						id="prior#RequisitionNo#Exp" border="0" class="regular" 
						align="middle" style="cursor: pointer;" 					
						onClick="rctmore('prior#RequisitionNo#','#RequisitionNo#','show','prior')">
						
						<img src="#SESSION.root#/Images/icon_collapse.gif" 
						id="prior#RequisitionNo#Min" alt="" border="0" 					
						align="middle" class="hide" style="cursor: pointer;" 
						onClick="rctmore('prior#RequisitionNo#','#RequisitionNo#','hide','prior')">
									
				   </cfif>	
				   			   
			   </td>
			   
			   </tr>	
			   
		       <cfset rw = rw+1> 	
			   				  
			   <input type="hidden" name="RequisitionNo_#rw#" id="RequisitionNo_#rw#" value="#RequisitionNo#">  
			  	
				
			   <cfif ReceiptQuantity gte "0">
					 
				   <tr id="prior#RequisitionNo#">				
					<td colspan="15">
					    <cfdiv id="iprior#RequisitionNo#"/>						
					</td>
			       </tr>		
				 				 	 
			   </cfif>
			  			   
			   	   <cfset seldate = "">
				  										
				   <cfloop query="TaskOrder">
					   
					   <cfif shiptodate neq seldate>
					   
					   	<tr class="labelmedium">
						<td></td><td colspan="3" style="padding-left:1px"><font size="2" color="gray"><cf_tl id="Pending External Task Orders"></font> <b>#dateformat(shiptodate,"DDDD #CLIENT.DateFormatShow#")#</b></td>
						<cfif shiptowarehouse neq "">
						<td class="labelit" align="right" colspan="10">#ShipToWarehouseName#/#ShipToLocation#</td>							
						</cfif>
						</tr>
						<cfset seldate = shiptodate>
						<tr><td colspan="14" class="line"></td></tr>
												   
					   </cfif>		
					   							
					   <tr class="labelmedium2">
				   
				       <td align="center"></td>					   
					   <td style="padding-left:16p;padding-right:10px" align="center">#CurrentRow#.</td>
					   <td>#ItemDescription#</td>
					   <td width="100">					   
						    <a href="javascript:StockOrderEdit('#stockorderid#')">#TaskOrderReference#</a>			
							<cf_space spaces="20">		   		 
					   </td>
					   <td>#UoMDescription#</td>
					   <td>#OrderUoMVolume#</td>
					   <td>#TaskCurrency#</td>				   
					   <td align="right">#NumberFormat(TaskPrice,",.__")#</td>
					   <td align="right"></td>
					   <td align="right">#NumberFormat(TaskQuantity,",._")#</td>
					   <td align="right">#NumberFormat(TaskAmount,',.__')#</td>
					   <td align="right"></td>			   
					   <td align="center"></td>					  				  				   
					   <td align="right" height="19">
							
						   <cfif TaskQuantityReceived eq "">
						     <cfset out = TaskQuantity>
						   <cfelse>
						     <cfset out = TaskQuantity - TaskQuantityReceived>	 
						   </cfif>
						   
						   #NumberFormat(out,",._")#
							   
					   </td>
					   
					   <cfif out gt "0">
						   
					       <td align="right" style="padding-top:3px">
						   
						   <cf_img icon="add" 
						      onclick="ProcRcptLineEdit('','#SourceRequisitionNo#','entry','new','box_#taskid#','#taskid#')" 
						      tooltip="Record Task order receipt">						    
						 						 							 							   
						   </td>
						     								   
					   <cfelse>
						   
						   <td colspan="1" class="labelit" height="20" align="right"><cf_tl id="Completed"></td>	   
								
					   </cfif>
					   
					   </tr>					   
					  					   				   						   
					   <tr id="#taskid#">
					   <td></td>
					   <td></td>
					   <td colspan="12" id="box_#taskid#" onClick="taskmore('box_#taskid#','#taskid#','#SourceRequisitionNo#','show','entry')">	
					    																	   		   
						    <cfset url.mode     = "entry">
							<cfset url.box      = "box_#taskid#">
							<cfset url.rctid    = "">
							<cfset url.taskid   = "#taskid#">
							<cfset url.reqno    = "#SourceRequisitionNo#">
							<cfinclude template = "ReceiptDetail.cfm">	
					   
					   </td>
					   </tr>						   
											
				</cfloop>
								   
		   <cfelse>
		   
		       <!--- no task order --->
			   
			     <cfinvoke component = "Service.Process.Procurement.PurchaseLine"  
							   method           = "getDeliveryStatus" 							   
							   RequisitionNo    = "#RequisitionNo#"
							   returnvariable   = "Delivery">		
		   
			   <tr class="navigation_row labelmedium2 linedotted" style="border-top:1px solid silver;<cfif Delivery.Status neq "3">height:26px</cfif>">
			   
				   <td align="center">				   
				  				   				   					 				   
					   <cfif PO.ParameterReceiptEntry eq "1" and DeliveryStatus neq "3">
					  					   												   												   
						   <img src="#SESSION.root#/Images/portal_min.png" alt="" 
								id="add#RequisitionNo#Exp" border="0" class="#ce#" height="14"
								align="middle" style="cursor: pointer;" 
								onClick="rctmore('add#RequisitionNo#','#RequisitionNo#','show','entry')">
									
						   <img src="#SESSION.root#/Images/portal_max.png" 
								id="add#RequisitionNo#Min" alt="" border="0" height="14"
								align="middle" class="#cc#" style="cursor: pointer;" 
								onClick="rctmore('add#RequisitionNo#','#RequisitionNo#','hide','entry')">
					   
					   </cfif>
					   				   
				   </td>				   
				   <td align="center" style="padding-right:7px;padding-left:3px">#CurrentRow#.</td>				   
				   				   			   
				   <cfif WarehouseItemNo neq "">
					  <td>
					   <a href="javascript:setitem('purchase','#requisitionno#','box_#requisitionno#_item','#WarehouseItemNo#','#warehouseUoM#')">
					   <span id="box_#requisitionno#_item">#OrderItem#</span></a></td>
					  <td><a href="javascript:setitem('purchase','#requisitionno#','box_#requisitionno#_item','#WarehouseItemNo#','#warehouseUoM#')">#OrderItemNo#</td>
				   <cfelse>
				      <td>#OrderItem# <cfif CaseNo neq "">(#CaseNo#)</cfif></td> 
					  <td>#OrderItemNo#</td>
				   </cfif>				   
				   	   
				   
				   <td>#OrderUoM#</td>
				   <td>#OrderUoMVolume#</td>
				   <td>#Currency#</td>				   
				   <td align="right">#NumberFormat(OrderPrice,",.__")#</td>
				   <td align="right">#NumberFormat(OrderDiscount*100,"._")#%</td>
				   <td align="right">#NumberFormat(OrderQuantity,",__")#</td>
				   <td align="right">#NumberFormat(OrderAmount,',.__')#</td>
				   <td align="right">#NumberFormat(OrderAmountTax,",.__")#</td>					   		   
				   <td align="center">
				   				   
					   <cfif receiptquantity gt "0">
				 		 
							<img src="#SESSION.root#/Images/arrowdown3.gif" alt="" 
								id="prior#RequisitionNo#Exp" border="0" class="regular" 
								align="middle" style="cursor: pointer;" 					
								onClick="rctmore('prior#RequisitionNo#','#RequisitionNo#','show','prior')">
							
							<img src="#SESSION.root#/Images/arrow_up1.gif" 
								id="prior#RequisitionNo#Min" alt="" border="0" 					
								align="middle" class="hide" style="cursor: pointer;" 
								onClick="rctmore('prior#RequisitionNo#','#RequisitionNo#','hide','prior')">
										
					   </cfif>		
				   
				   </td>				   			   
				   
				   <cfset rw = rw+1> 	
				   				  
				   <input type="hidden" name="RequisitionNo_#rw#" id="RequisitionNo_#rw#" value="#RequisitionNo#">  
				  																   
				   <cfif PO.ParameterReceiptEntry eq "1">
				   
				      <!--- manual dialog based entry of the receipt --->
				   
				       <td align="right" class="labelit" style="padding-right:4px <cfif DeliveryStatus eq "0">height:20</cfif>">						   
					 												    
						  <cfif Delivery.Status eq "0">
						      <cf_tl id="Pending">
						  </cfif>
						  
						  <cfif Delivery.Status eq "2">
						  
							  <table>
							  
								  <tr>
								  <td class="labelit"><cf_tl id="Partial"></td>
								  <td id="status_#requisitionno#" style="padding-left:6px">								  								  
								
								  <cfif Delivery.OrderValue gt "0">
								 								  					
									  <cfset val = Delivery.Value*100/Delivery.OrderValue>
																						  
									  <cfif val gte Delivery.Threshold>
									  	
										  <cf_UIToolTip tooltip="set the delivery status of this purchase to completed">
										  						  							  
										  <input type="checkbox" 
										      name="delivery#RequisitionNo#" 
											  value="3" 											  
											  onclick="ptoken.navigate('setDeliveryStatus.cfm?requisitionno=#requisitionno#&recordstatus=3','status_#requisitionno#')"
											  class="radiol">
											  
										   </cf_UIToolTip>
									  
									  </cfif>
									  
								  </cfif>	  
								  
								  </td>
								  
								  </tr>
							  </table>
						  
						  </cfif>
						  
						  <cfif Delivery.Status eq "3">

						  	<cfif RecordStatus eq "3">
							
							 <table cellspacing="0" cellpadding="0">
							  
							  <tr><td class="labelit"><cf_tl id="Completed">!</td>

								  <td id="status_#requisitionno#" style="padding-left:6px">		
																			
									<cfif getAdministrator("*") eq "1">	
										<cf_UIToolTip tooltip="reset the delivery status of this purchase to partial">
											  <input type = "checkbox" 
											      name    = "delivery#RequisitionNo#" 
												  value   = "1" 	
												  checked										  
												  onclick = "ptoken.navigate('setDeliveryStatus.cfm?requisitionno=#requisitionno#&recordstatus=1','status_#requisitionno#')"
												  class   = "radiol">												  
										 </cf_UIToolTip>
									</cfif>	 
									
								   </td>	
							
								</tr>
							
								</table>
							
							<cfelse>
							
								<cf_tl id="Completed">
								
							</cfif>								   
						  
						  </cfif>					 
						 				         
					   </td>
					   
				   <cfelse>
												   
					    <td align="right">
						
						   <cfif Delivery.Status eq "3">
						   
						   <table><tr><td align="right" 
						     class="labelit">
							 
						   <cfif ReceiptQuantity eq "">
						     <cfset out = OrderQuantity>
						   <cfelse>
						     <cfset out = OrderQuantity - ReceiptQuantity>	 
						   </cfif>
						   						  						
						   -- 
						 						   
						   </td></tr></table>
						   
						   <cfelse>
						   
						   <cfif ReceiptQuantity eq "">
						     <cfset out = OrderQuantity>
						   <cfelse>
						     <cfset out = OrderQuantity - ReceiptQuantity>	 
						   </cfif>
						  					  
						   <table><tr class="labelmedium"><td align="right">
						    <a href="javascript:setQty(#out#, '#rw#')" style="font-size:17px;cursor:pointer"><u>#NumberFormat(out,",.__")#</a></td></tr></table>
						   
						   </cfif>
						   
					   </td>
					   					   				   
					   <cfif out gt "0">					   			   
					   
					   	   <cfif RequestType neq "Warehouse">
						  
							   <input type="hidden" name="OrderQuantity_#rw#" id="OrderQuantity_#rw#" value="#OrderQuantity#">
							   <input type="hidden" name="Outstanding_#rw#"   id="Outstanding_#rw#"   value="#out#">
							  
							   <td align="right">
							  							   
								   <cfinput type="Text" 
									       class="regularxl amount enterastab" 
										   id="ReceiptQuantity_#rw#" 
										   name="ReceiptQuantity_#rw#" 
										   value="0" 
										   style="font-size:13px;padding-right:2px"								  
										   validate="float" 
										   required="No" 
										   size="6" 
										   maxlength="10">
									   
							   </td>
							   
						   <cfelse>
						   
							   	<td></td>	   
						   
						   </cfif>
						   
					   <cfelse>
					   
					 	   <td colspan="1" style="padding-right:4px" align="right"><font color="green"><cf_tl id="Completed"></font></td>	   
							
					   </cfif>
				   
				   </cfif>
				   
				  </tr>			
				  
				 <cfif Parameter.PurchaseTopic eq "1">				 
				 				 				 	
					  <cf_getRequisitionTopic RequisitionNo="#RequisitionNo#" show="No">
					  
					  <cfif requisition gte "1">
					  
					  <tr style="height:0px">
						  <td></td>
						  <td></td>
						  <td colspan="13">				 		
								<cf_getRequisitionTopic RequisitionNo="#RequisitionNo#" TopicsPerRow="3">
						  </td>
					  </tr>
					  
					  </cfif>		
				  
				  </cfif>
				  
				   <cfif ReceiptQuantity gte "0">
					 
				   <tr class="hide" id="prior#RequisitionNo#">				
					<td></td>
					<td></td>
					<td colspan="13">
					    <cfdiv id="iprior#RequisitionNo#"/>						
					</td>
			       </tr>		
				 				 	 
			   	   </cfif>				   				  						 			   
			  
				  <cfif RequestType eq "Warehouse" and PO.ParameterReceiptEntry eq "0" and out gt "0">
				  
				    <cfparam name="whsfound" default="0">
				  				  
				    <cfif whsfound eq "0"> 
				  
						<cfset whs = warehouse>	
												
						<cfquery name="getListWarehouse" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM   Warehouse
								WHERE  Mission = '#PO.Mission#'							
						</cfquery>
						
						<!--- define access --->
						
						<cfset whsaccesslist = "">
						
						<cfloop query="getListWarehouse">		
														 
						  <cfinvoke component="Service.Access"
							   Method="procRI"
							   MissionOrgUnitId="#MissionOrgUnitId#"
							   OrderClass="#PO.OrderClass#"
							   ReturnVariable="ReceiptAccess">	
							  							   
							   <cfif ReceiptAccess eq "EDIT" or ReceiptAccess eq "ALL">						   
								   <cfif whsaccesslist eq "">
								   	  <cfset whsaccesslist = "'#warehouse#'">
								   <cfelse>
								   	  <cfset whsaccesslist = "#whsaccesslist#,'#warehouse#'">
								   </cfif>
								   <cfif whs eq "">
								       <cfif WarehouseDefault>
										   	<cfset whs = Warehouse>
									   </cfif>	
								   </cfif>						   
							   </cfif> 				
						
						</cfloop>
						
						<cfset whsfound = 1>
					
					</cfif>
					
					<!--- define relevant warehouses for the item shipped --->
					
					<cfif WarehouseItemNo eq "">
					
						<cfset whslimitlist = "">
						
					<cfelse>
					
						<cfquery name="item" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						    SELECT *
						    FROM   Item
							WHERE  ItemNo = '#WarehouseItemNo#'								
						</cfquery>	
						
						<!--- determine if we can indeed receive this item into this warehouse based on the modeSetItem settings --->
						
						<cfquery name="Ware" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
																					    
								SELECT *
							    FROM   Warehouse
								WHERE  Mission = '#PO.Mission#'									
								AND    ModeSetItem = 'Always'
								
								UNION
								
								SELECT *
							    FROM   Warehouse
								WHERE  Mission = '#PO.Mission#'									
								AND    ModeSetItem = 'Category'						
								AND    Warehouse IN (SELECT Warehouse 
								                     FROM   WarehouseCategory 
													 WHERE  Category = '#item.category#'
													 AND    Operational = 1)	
													 
								UNION
								
								SELECT *
							    FROM   Warehouse W
								WHERE  Mission = '#PO.Mission#'	
								AND    ModeSetItem = 'Location'												
								AND    Warehouse IN (SELECT Warehouse 
								                     FROM   ItemWarehouseLocation 
													 WHERE  Warehouse = W.Warehouse
													 AND    ItemNo    = '#WarehouseItemNo#')										 									 												 
													 
						</cfquery>
												
						<cfset whslimitlist = quotedValueList(ware.Warehouse)>
												
					</cfif>
																				
					<!--- filtered list for access based on the RI --->
					
					<cfquery name="Ware" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   Warehouse
							WHERE  Mission = '#PO.Mission#'		
							AND    Operational = 1		
							<!--- wildcard limitation --->	
							AND    WarehouseClass IN (SELECT Code 
				                                      FROM   Ref_WarehouseClass
										              WHERE  ExternalReceipt = 1)			
							<!--- user has access --->						  
							<cfif whsaccesslist neq "">
							AND    Warehouse IN (#preservesingleQuotes(whsaccesslist)#)
							</cfif>
							<!--- limitation based on the item received --->
							<cfif whslimitlist neq "">
							AND    Warehouse IN (#preservesingleQuotes(whslimitlist)#)
							</cfif>							
					</cfquery>		
															
					<cfif ware.recordcount eq "0">
					
						<cfquery name="Ware" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM   Warehouse
								WHERE  Mission = '#PO.Mission#'		
								AND    Operational = 1					
								<cfif whsaccesslist neq "">
								AND    Warehouse IN (#preservesingleQuotes(whsaccesslist)#)
								</cfif>								
						</cfquery>		
										
					</cfif>									
											  
					<cfquery name="exists" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT *
					    FROM   ItemUoM
						WHERE  ItemNo = '#WarehouseItemNo#'								
					</cfquery>	
					
					<cfquery name="existsuom" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT *
					    FROM   ItemUoM
						WHERE  ItemNo = '#WarehouseItemNo#'
						AND    UoM    = '#WarehouseUoM#'				
					</cfquery>	
										  
					<cfif exists.recordcount eq "0">
					
					<tr>
					
					  <td colspan="2" bgcolor="white"></td>					  
					  <td colspan="14" class="labelmedium2" align="center">
					  <font color="FF0000">Problem : Requested classified item (#WarehouseItemNo#) no longer exists.</font>					  
					  </td>
					  
					</tr>  	
					
					<cfelseif existsuom.recordcount eq "0">
					
					<tr>
					
					  <td colspan="2" bgcolor="white"></td>					  
					  <td colspan="14" class="labelmedium2" align="center">
					  <font color="FF0000">Problem : Requested UOM (#WarehouseUoM#) no longer exists.</font>					  
					  </td>
					  
					</tr>  									  			
					
					<cfelse>
					
					<tr>
					
					  <td colspan="2" bgcolor="white"></td>
					  
					  <td colspan="14">
					  						  					  					  
						  <table height="100%" width="100%">
						  						 						  
						  <!--- hidden for now 
						  
						  <tr class="line labelmedium">
						      <td colspan="3" bgcolor="D3E9F8" style="height:100%;font-size:13px;font-weight:bold;padding:3px"><cf_tl id="Receipt"></td>						  
						      <td colspan="9" bgcolor="D9E0B1" style="height:100%;font-size:13px;font-weight:bold;border-left:1px solid silver;padding:3px;"><cf_tl id="Stock"></td>
						  </tr>
						  						  						  
						  <tr class="line labelit" style="height:10px">
						     <td style="padding-left:4px;background-color:D3E9F8"><cf_tl id="Quantity"></td>
							 <td style="padding-left:4px;background-color:D3E9F8"><cf_tl id="UoM"><cf_tl id="Receipt"></td>									 
							 <td style="background-color:D3E9F8;padding-left:5px;border-right:1px solid gray"><cf_tl id="Order Receipt"></td>							 							 							 							 
							 <cfif Param.LotManagement eq "1">
							 	<td style="padding-left:4px;background-color:D3E9F8;border-right:1px solid gray" colspan="2"><cf_tl id="Lot"></td>
							 </cfif>
							 <td style="padding-left:4px;background-color:D9E0B1"><cf_tl id="UoM"></td>						
							 <td style="padding-left:4px;background-color:D9E0B1"><cf_tl id="Multiplier"></td>
							 <td style="padding-left:4px;background-color:D9E0B1" align="center"><cf_tl id="Increase"></td>								 
							 <td colspan="2" style="padding-left:4px;border-left:1px solid gray;background-color:D9E0B1"><cf_tl id="Stock value price"></td>														 						 
							 <td style="padding-left:4px;border-left:1px solid gray;border-right:1px solid gray;background-color:D9E0B1"><cf_tl id="Stock in">#application.baseCurrency#</td>							 
							 <td style="padding-left:4px;background-color:D9E0B1"><cf_tl id="Destination"></td>						  
						  </tr>
						  
						  --->
						  						  
						  <tr bgcolor="F5F5F5">
						  						  							  						  								 						  
						     <td style="width:70px;height:26px;padding-left:4px">
							 
							 <input type="hidden" name="OrderQuantity_#rw#" id="OrderQuantity_#rw#" value="#OrderQuantity#">
						     <input type="hidden" name="Outstanding_#rw#"   id="Outstanding_#rw#"   value="#out#">
							 							 
							  <cfinput type  = "Text" 
							       class     = "regularxl amount enterastab" 
								   name      = "ReceiptQuantity_#rw#" 
								   id        = "ReceiptQuantity_#rw#"
								   value     = "0" 								   
								   onchange  = "setstockline('#rw#','#RequisitionNo#',document.getElementById('ReceiptQuantityUoM_#rw#').value,this.value,document.getElementById('WarehousePrice_#rw#').value,'quantity',document.getElementById('WarehouseItemUoM_#rw#').value,document.getElementById('WarehouseCurrency_#rw#').value)"
								   style     = "padding-right:2px;height:24px;width:100%"								  
								   validate  = "float" 
								   required  = "No" 
								   size      = "10" 
								   maxlength = "10">
							 
							 </td>
							 
							 <td style="padding-left:3px;width:140px">
							 
							 <!--- as per purchase or as per UoM of the item which is going to be received --->
							 
							 <cfquery name="UoMList" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT *
								    FROM   ItemUoM U
									WHERE  ItemNo = '#WarehouseItemNo#'				
									
								</cfquery>	
								
								<select name="ReceiptQuantityUoM_#rw#" 
								    style="width:100%;height:24px" 
									id="ReceiptQuantityUoM_#rw#" 
								    class="regularxl enterastab" 
									onchange="setstockline('#rw#','#RequisitionNo#',this.value,document.getElementById('ReceiptQuantity_#rw#').value,document.getElementById('WarehousePrice_#rw#').value,'quantity',document.getElementById('WarehouseItemUoM_#rw#').value,document.getElementById('WarehouseCurrency_#rw#').value)">
									
								    <option value="asis" selected><cf_tl id="as in order"></option>									
									<cfloop query="UoMList"><option value="#uoM#"><cf_tl id="stock">:&nbsp;#UoMDescription#</option></cfloop>
									
								</select>			
							 							 
							 </td>
							 
							 <td style="width:40" align="right"><cf_tl id="Qty">:</td>
							 
							 <td style="width:70;padding-left:5px;padding-right:5px;border-right:1px solid gray"> 				 				
									   
							 	<table width="100%">
								
								<tr>
								
									<td class="hide" id="boxorderprocess_#rw#"></td>
								
									<td align="right" style="background-color:e4e4e4;padding-right:3px;width:100%;height:23px;border:1px solid silver" 
									class="labelmedium" 
									id="boxordermultiplier_#rw#">
									
																											
									<input type  = "hidden"
									       	   name      = "ReceiptOrderMultiplier_#rw#"
				                               id        = "ReceiptOrderMultiplier_#rw#"											   
										       value     = "1"
											   class     = "regularxl"
											   size      = "15"
											   maxlength = "20">								
									
									</td>
								
								</tr>
								
								</table>						   
							 
							 <!--- order multiplier --->
							 
							 </td>		
							 
							 <td style="width:50" align="right"><cf_tl id="Vol">:</td>		
							 
							 <td style="width:70;padding-left:5px;padding-right:5px;border-right:1px solid gray"> 				 				
									   
							 	<table width="100%">
								
								<tr>
								
									<td align="right" style="padding-right:3px;width:100%;height:23px;" class="labelmedium" 
									id="boxvolume_#rw#">
																											
									<cfinput   name      = "ReceiptVolume_#rw#"
				                               id        = "ReceiptVolume_#rw#"											   
										       value     = ""
											   class     = "regularxl"
											   style     = "width:100%;text-align:right"
											   size      = "15"
											   maxlength = "20">								
									
									</td>
								
								</tr>
								
								</table>	
							 
							 </td>		
							
							 <cfif Param.LotManagement eq "1">
							 
							 	  <td style="padding-left:3px;width:50px"><cf_tl id="Lot"></td>	
							  								 
								  <td style="padding-left:3px;width:80px">
								  							  
							            <input type      = "text"
									       	   name      = "TransactionLot_#rw#"
				                               id        = "TransactionLot_#rw#"											   
										       value     = ""
											   class     = "regularxl"
											   onchange  = "ptoken.navigate('#session.root#/tools/process/stock/getLot.cfm?mission=#PO.mission#&transactionlot='+this.value,'TransactionLot_#rw#_content')"
										       size      = "10"
											   maxlength = "20"
										       style     = "height:24px;padding-top:1px;padding-right:2px">
											   
								  </td>
								  <td id="TransactionLot_#rw#_content" class="labelit" style="padding-left:3px;padding-right:3px;width:30;border-right:1px solid gray"></td>
							  
							  </cfif>							  
							 
							 <td align="left" style="width:100px;padding-left:6px;background-color:ffffaf">		
							 									 									
								<cfquery name="UoMList" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT *
								    FROM   ItemUoM U
									WHERE  ItemNo = '#WarehouseItemNo#'		
									AND    EXISTS (SELECT 'X' 
									               FROM   ItemUoMMission 
												   WHERE  ItemNo    = U.ItemNo
												   AND    UoM       = U.UoM
												   AND    Mission   = '#PO.Mission#'
												   AND    TransactionUoM is NULL)
									AND    Operational = 1		
								</cfquery>	
								
								<cfif UoMList.recordcount eq "0">
								
									<cfquery name="UoMList" 
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT *
									    FROM   ItemUoM
										WHERE  ItemNo = '#WarehouseItemNo#'													
									</cfquery>	
																
								</cfif>
								
								<input type="hidden" name="WarehouseItemNo_#rw#" value="#WarehouseItemNo#">
																
								<select name="WarehouseItemUoM_#rw#" id="WarehouseItemUoM_#rw#"
								onchange="setstockline('#rw#','#RequisitionNo#',document.getElementById('ReceiptQuantityUoM_#rw#').value,document.getElementById('ReceiptQuantity_#rw#').value,document.getElementById('WarehousePrice_#rw#').value,'quantity',this.value,document.getElementById('WarehouseCurrency_#rw#').value)"
								style="height:24px;width:100px" class="regularxl enterastab">
									<cfloop query="UoMList"><option value="#uoM#" <cfif UoM eq Purchase.WarehouseUoM>selected</cfif>>#UoMDescription#</option></cfloop>
									
										<cfquery name="getUoM" 
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										    SELECT *
										    FROM   ItemUoM
											WHERE  ItemNo = '#WarehouseItemNo#'		
											AND    UoM    = '#WarehouseUoM#' 											
										</cfquery>	
										
										<cfset basemultiplier = OrderMultiplier * getUoM.UoMMultiplier>
																				
										<cfquery name="checkUoM" 
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										    SELECT *
										    FROM   ItemUoM
											WHERE  ItemNo          = '#WarehouseItemNo#'		
											AND    UoMMultiplier   = '#BaseMultiplier#' 											
										</cfquery>	
										
										<cfif checkUoM.recordcount eq "0">
										
											<option value="as is">#OrderUoM#</option>
																													
										</cfif>																											
									
								</select>	
															 
							 </td>		
							 
							 <td style="padding-left:4px;width:70px;background-color:ffffaf"><cf_tl id="Multiplier"></td>
							 
							  <td style="padding-left:4px;width:70px;background-color:ffffaf" align="center">
							 	<table width="100%">
									<tr><td align="right" style="background-color:e4e4e4;padding-right:3px;width:100%;height:23px;border:1px solid silver" class="labelmedium" id="boxwarehousemultiplier_#rw#">
									
									</td></tr>
								</table>							 						   							 
							 </td>		
							 					 
							 <td style="padding-left:4px;width:80;background-color:ffffaf" align="right">
							 	<table width="100%">
									<tr><td align="right" style="background-color:e4e4e4;padding-right:3px;width:100%;height:23px;border:1px solid silver" class="labelmedium" id="boxwarehousequantity_#rw#"></td></tr>
								</table>							 
							 </td>		
							 
							 <td style="padding-left:4px;width:60px;background-color:ffffaf"><cf_tl id="Price">:</td>	    	
							 
							    <td style="padding-left:3px;width:60px;background-color:ffffaf">
								
								<!--- ptoken.navigate('setWarehousePrice.cfm?row=#rw#&requisitionno=#requisitionno#&currency='+this.value,'result')" --->
							  				  
							    <select name="WarehouseCurrency_#rw#" style="height:24px;width:100%" id="WarehouseCurrency_#rw#" class="regularxl enterastab" 
								    onchange="setstockline('#rw#','#RequisitionNo#',document.getElementById('ReceiptQuantityUoM_#rw#').value,document.getElementById('ReceiptQuantity_#rw#').value,document.getElementById('WarehousePrice_#rw#').value,'currency',document.getElementById('WarehouseItemUoM_#rw#').value,this.value)">
									<cfloop query="cur">
										<option value="#Currency#" <cfif purchase.currency eq currency>selected</cfif>>#Currency#</option>
									</cfloop>
								</select>
								
							  </td>			  
							  
						  
							  <td style="padding-left:3px;width:100;background-color:ffffaf">								  
							    										   
								   <!--- 2/4/2012 : Attention the value of the stock is expressed without tax, 
								   tax is paid in the invoice and then again paid over the increase value upon sale --->
								   
								   <cfset pd = OrderAmountBaseCost /(OrderQuantity*OrderMultiplier)>
								   
								   <cfif pd lte 0.01>								  								   
								       <cfset pd = NumberFormat(OrderAmountCost/(OrderQuantity*OrderMultiplier),',.______')>
								   <cfelse>
								   	   <cfset pd = NumberFormat(OrderAmountCost/(OrderQuantity*OrderMultiplier),',.___')>
								   </cfif>
								   								   
								   <input type  = "text"
							       	   name     = "WarehousePrice_#rw#"
		                               id       = "WarehousePrice_#rw#"
									   class    = "regularxl enterastab"
									   onchange = "setstockline('#rw#','#RequisitionNo#',document.getElementById('ReceiptQuantityUoM_#rw#').value,document.getElementById('ReceiptQuantity_#rw#').value,this.value,'price',document.getElementById('WarehouseItemUoM_#rw#').value,document.getElementById('WarehouseCurrency_#rw#').value)"
								       value    = "#pd#"								       
								       style    = "height:24px;width:100%;text-align:right;padding-top:2px;padding-right:2px">
							  </td>					  	  								  
								  							 							  
							  <td align="right" style="width:88px;padding:2px;background-color:ffffaf">
							  
								  <table width="100%">
								   <tr>
								     <td align="right" style="font-size:14px;background-color:eaeaea;padding-right:2px;height:23px;width:100%;border:1px solid silver" id="boxwarehousevalue_#rw#"></td>
								   </tr>
								  </table>
							  
							  </td> 
							  							  
							  <td align="right" height="24" style="min-width:70px;padding-left:4px;padding-right:5px;background-color:ffffaf">
							  
							   <cfif out gt "0">
								   <select name="Warehouse_#rw#" style="height:24px;width:100%" id="Warehouse_#rw#" class="regularxl">
									<cfloop query="ware">
										<option value="#Warehouse#" <cfif Warehouse eq whs>selected</cfif>>#WarehouseName#</option>
									</cfloop>
								  </select>
							  </cfif>
							  
							  </td>								 
						  	  
					</tr>				
										
					</table>
					
					</td>
					</tr>
					
					</cfif>
					
		  
		       </cfif>
			   
		 </cfif>	
		 		 						 			 
		 <cfif PO.ParameterReceiptEntry eq "1" and (DeliveryStatus lte "3" or RecordStatus eq "3")>
		 			  		 		  
	  		  <cfif recordstatus eq "3">			  
			  	<cfset cl = "hide">
			  <cfelse>			  
			  	<cfset cl = "regular">
			  </cfif>
	  
			  <tr id="add#RequisitionNo#" class="#cl#">			
			   				  
				<td colspan="14" style="padding-left:10px;padding-right:10px" id="iadd#RequisitionNo#">
																																																
					<cfset url.mode      =  "entry">
					<cfset url.box       =  "iadd#RequisitionNo#">
					<cfset url.rctid     =  "">
					<cfset url.taskid    =  "">
					<cfset url.reqno     =  "#RequisitionNo#">					
					<cfinclude template  =  "ReceiptDetail.cfm">	
														
				</td>
				
			  </tr>		
				  			 			 			 	 
		 </cfif>	
		 			   
	 </cfoutput>
	 
	 <cfoutput>
		 <input type="hidden" name="row" id="row" value="#rw#">
	 </cfoutput>
		 		  
 </table>