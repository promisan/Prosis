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
<cfquery name="PendingShipment" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT   O.OrgUnitName, 
             H.Contact, 
			 H.DateDue, 
			 H.Reference, 
			 R.RequestDate, 
			 R.ItemNo, 
			 I.ItemDescription, 
			 I.Category,
			 I.ItemPrecision,
			 I.ItemShipmentMode,
			 R.UoM, 
			 U.UoMDescription, 
			 R.RequestedQuantity, 
			 R.OriginalQuantity,
			 TR.ActionStatus,
             T.TaskQuantity, 			
			 T.ShipToDate, 
			 T.ShipToWarehouse, 
			 W.WarehouseName,
			 W.WarehouseClass,
			 W.MissionOrgUnitId,
			 
			 <!--- internal --->
			 
			 (SELECT WarehouseName 
			  FROM   Warehouse 
			  WHERE  Warehouse = T.SourceWarehouse) as SourceWarehouse,
			
			 <!--- external --->
			 
			 (SELECT OrgUnitName 
			  FROM   Purchase.dbo.PurchaseLine PL INNER JOIN Purchase.dbo.Purchase P ON PL.Purchaseno = P.PurchaseNo INNER JOIN Organization.dbo.Organization O ON P.Orgunitvendor = O.OrgUnit   
			  WHERE  RequisitionNo = T.SourceRequisitionNo) as SourceVendor,  
			
			 T.ShipToLocation,
			 T.TaskId,
			 T.RequestId,
			 T.TaskType,
			 T.ShipToMode,
			 SM.ModeShipmentEntry,
			 T.SourceRequisitionNo,
					
			 			
			 (SELECT  ISNULL(SUM(ReceiptWarehouse),0)
	          FROM    Purchase.dbo.PurchaseLineReceipt
			  WHERE   Warehousetaskid = T.TaskId													
			  AND     ActionStatus != '9') as ReceiptQuantity,	
			 
			 <!--- to determine pending for receipt based on the difference with the tasked quantiy unless
			   closed or completed etc. ---> 
			 (SELECT  ISNULL(SUM(TransactionQuantity),0)
              FROM    ItemTransaction S
			  WHERE   RequestId    = T.RequestId									
			  AND     TaskSerialNo = T.TaskSerialNo		
			  AND     TransactionQuantity > 0
			  <!---  removed as condition is below
			  AND     TransactionId IN (SELECT TransactionId 			  
			                            FROM   ItemTransactionShipping
										WHERE  TransactionId = S.TransactionId
										AND    ActionStatus = 1)										
										--->
			  AND     ActionStatus != '9') as TransactionQuantity,  	
			  
			 (SELECT  ISNULL(SUM(TransactionQuantity),0)
              FROM    ItemTransactionDeny S
			  WHERE   RequestId    = T.RequestId									
			  AND     TaskSerialNo = T.TaskSerialNo		
			  AND     TransactionQuantity > 0
			 ) as DeniedQuantity,  				  
					 
			 T.StockOrderId,		
			  
			 TR.Reference as TaskOrderReference,			
			 TR.Created as TaskedOn,
			 TR.OfficerLastName as TaskedBy
			 
	FROM     RequestHeader H INNER JOIN
             Request R ON H.Mission = R.Mission AND H.Reference = R.Reference INNER JOIN
             RequestTask T ON R.RequestId = T.RequestId LEFT OUTER JOIN
			 TaskOrder TR ON TR.StockOrderId = T.StockOrderId INNER JOIN
             Organization.dbo.Organization O ON H.OrgUnit = O.OrgUnit INNER JOIN
             ItemUoM U ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM INNER JOIN
             Item I ON R.ItemNo = I.ItemNo INNER JOIN
			 Warehouse W ON T.ShipToWarehouse = W.Warehouse INNER JOIN
             Ref_ShipToModeMission SM ON H.Mission = SM.Mission AND T.ShipToMode = SM.Code AND I.Category = SM.Category
			
	<!--- cleared --->	
	<!--- Dev I remove as completed determine lines
	WHERE        H.ActionStatus IN ('2p','3') 
	--->
	WHERE        H.ActionStatus IN ('2p','3','5')
	
	<!--- menu selection --->
	
	<cfif url.filter eq "Collect" or url.filter eq "Deliver">
	
	AND      T.ShipToMode = '#url.filter#' AND T.TaskType = 'Internal'
	
	<cfelseif url.filter eq "Purchase">
	
	AND      T.TaskType = 'Purchase'
	
	<cfelseif url.filter eq "Action">
	
	AND (
	
	      (ModeShipmentEntry = 1 AND 
		  
		     <!--- pending confirmations found --->
		     (SELECT  ISNULL(SUM(TransactionQuantity),0)
              FROM    ItemTransaction S
			  WHERE   RequestId    = T.RequestId									
			  AND     TaskSerialNo = T.TaskSerialNo		
			  AND     TransactionQuantity > 0			 
			  AND     ActionStatus = '0') > 0				  	  
		   )
		   
		  OR
		  (ModeShipmentEntry = 0 AND 
		  
		    <!--- tasklines that have not been fully received found --->
				
	        T.TaskQuantity >  (SELECT ISNULL(SUM(TransactionQuantity),0)*#diff#
	                             FROM    ItemTransaction S
				 			     WHERE   RequestId    = T.RequestId									
								 AND     TaskSerialNo = T.TaskSerialNo											
								 AND     TransactionQuantity > 0
								 AND     ActionStatus != '9')			  
		  )
		  
		)  
	    	
	</cfif>
	
	<!--- line not cancelled --->			 
	AND      R.Status IN ('1','2','3') 
	
	<!--- line assigned to an approved taskorder  --->
	AND      (
	          T.StockOrderId IN (SELECT StockOrderId FROM TaskOrder WHERE StockOrderId = T.StockOrderId and ActionStatus = '1')
			  OR 
	         (T.TaskType = 'Internal' AND T.ShipToMode = 'Collect') 
			  OR			  
			 (T.TaskType = 'Internal' AND T.ShipToMode = 'Deliver') 
			
			 )
	
	<!--- was not cancelled (9) or overrule as completed (3) --->
	AND      (
	            T.RecordStatus IN ('0','1')  OR 
	              
				  (
				  
				  	<!--- 20/6/2013 added 
					 ine manually shipped/closed but still pending confirmation for some other --->
				    T.RecordStatus = '3' AND T.RequestId IN (SELECT RequestId
					                                         FROM   ItemTransaction IT 
															 WHERE  IT.RequestId    = T.RequestId 
															 AND    IT.TaskSerialNo = T.TaskSerialNo
															 AND    IT.ActionStatus = 0)
										
				  )	
				  
			)	  
	
	<!--- only tasked lines, not the pickticket lines  --->	
	AND       R.RequestType IN ('Regular','TaskOrder')
		
	<!--- task line has NOT been fully receipt PLUS confirmed  --->
	AND      T.TaskQuantity >  (SELECT ISNULL(SUM(TransactionQuantity),0)*#diff#
	                             FROM    ItemTransaction S
				 			     WHERE   RequestId    = T.RequestId									
								 AND     TaskSerialNo = T.TaskSerialNo
								 <!--- confirmation --->
								 AND     ( TransactionId IN (SELECT TransactionId 
			                    					       FROM   ItemTransactionShipping
														   WHERE  TransactionId = S.TransactionId
														   AND    ActionStatus = 1) 	
														   
											OR ActionStatus = '1'	
											<!--- receipt from vendor have status 1 from the RI workflow --->													   
										  )						
								 AND     TransactionQuantity > 0
								 AND     ActionStatus != '9')
								 
								 
								 
	
		
	AND      R.Mission  = '#url.mission#' 
			
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->

	<cfelse>	 
	
	AND  						
				 T.ShipToWarehouse IN (
				 <!--- only if the user may indeed submit for the warehouse --->
				 #preservesinglequotes(facilityaccess)#	  
			     )
				   
	</cfif>		
									
	ORDER BY T.ShipToMode, T.ShipToWarehouse, T.ShipToDate, OrgUnitName, TR.Reference	
	
</cfquery>

<!--- based on the ModeShipMentEntry and given the fact this is the recipient perspective
we do the following :

WHERE ModeShipMentEntry = 1, we show the actions that have a pending confirmation
WHERE ModeShipmentEntry = 0, we show the actions that have a pending quantity, to entered

--->

<!--- ------------------------------- --->
<!--- provision to hide/show the menu --->

<cfif url.filter eq "">
	
	<cfquery name="Menu" dbtype="query">
	 SELECT DISTINCT ShipToMode, TaskType
	 FROM  PendingShipment
	</cfquery>
				
	   <script language="JavaScript">
	   
		    se = document.getElementById("filtersub").length;
			
			if (se < 3) {
			
			<cfoutput query="Menu">	
				
				<cfif TaskType eq "Purchase" and ShipToMode eq "Deliver">
				$("##filtersub").append('<option value=Purchase><cf_tl id="Vendor"><cf_tl id="Delivery"></option>');						   
				<cfelseif TaskType eq "Internal" and ShipToMode eq "Deliver">
				$("##filtersub").append('<option value=#ShipToMode#><cf_tl id="Pending"><cf_tl id="Delivery"></option>');	
				<cfelseif TaskType eq "Internal" and ShipToMode eq "Collect">
				$("##filtersub").append('<option value=#ShipToMode#><cf_tl id="Pending"> <cf_tl id="Collection"></option>');	
				</cfif>
							 	
			</cfoutput>
			
			}
				
		</script>
							
	
</cfif>

<!--- ------------------------------- --->



<cfquery name="Facility" dbtype="query">
	 SELECT DISTINCT WarehouseName
	 FROM  PendingShipment
</cfquery>

<cfoutput query="PendingShipment" group="shiptomode">
														
		<tr>
			<td colspan="13" class="labellarge" style="color:6688aa;height:35;font-size:20px">
			
				<cfquery name="getMode" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT * 
					  FROM   Ref_ShipToMode
					  WHERE  Code = '#ShipToMode#'
				</cfquery>
																															
				<i><cf_tl id="#getMode.Description#">				
				
			</td>
		</tr>		
		<tr><td colspan="13"class="linedotted"></td></tr>
		
		<!--- 
		
		<cfoutput group="shiptodate">
				
		<cfquery name="ReqList" dbtype="query">
		   		 SELECT DISTINCT Reference
				 FROM  PendingShipment
				 WHERE ShipToMode = '#shiptomode#'
				 AND   ShipToDate = '#dateformat(shiptodate,client.dateSQL)#'
		</cfquery>
		
		<cfquery name="wHSList" dbtype="query">
		   		 SELECT DISTINCT WarehouseName
				 FROM  PendingShipment
				 WHERE ShipToMode = '#shiptomode#'
				 AND   ShipToDate = '#dateformat(shiptodate,client.dateSQL)#'
		</cfquery>
										
		<tr class="clsRequest">
			<td colspan="12">
			<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
			<td width="200" style="padding-left:20px" class="labelmedium"><b>
			<cfif shiptodate gte now()-7>
			#dateformat(shiptodate,"DDDD")#			
			<cfelse>
			#dateformat(shiptodate,"DDDD MMM YY")#	
			</cfif>
			</td>
			<!---
			<td align="right" class="labelit"><b>#dateformat(shiptodate,CLIENT.DateFormatShow)#</td>
			--->
			</tr>
			</table>
			</td>
			<td class="creference hide">
			#preservesingleQuotes(reqList.Reference)# #preservesingleQuotes(wHSList.WarehouseName)#
			</td>
		</tr>
		
							
		<tr class="clsRequest"><td colspan="12" class="linedotted"></td>
			<td class="creference hide">
			#preservesingleQuotes(reqList.Reference)# #preservesingleQuotes(whsList.WarehouseName)#
			</td>
		 </tr>
		 
		 --->
											
		<cfoutput group="shiptowarehouse">			
		
			<cfif Facility.recordcount gt "1">
									
			<tr class="clsRequest"><td colspan="13" class="labelmedium creference" style="padding-left:20px">#WarehouseName#</td></tr>				
			<tr class="clsRequest"><td colspan="13" class="linedotted"></td></tr>
		
			</cfif>
							
			<cfoutput>
			
			<cfif (WarehouseClass eq "PGC" and RequestDate gte now()-60) or WarehouseClass neq "PGC">
											
			<cfif shiptodate lt now()>
			 <cfset color = "white">
			<cfelse>
			 <cfset color = "white"> 
			</cfif>
											
			<tr class="clsRequest navigation_row" bgcolor="#color#">
			
				<td style="padding-left:27px;padding-right:4px" class="label" bgcolor="white"></td>
				
				<td style="padding-left:3px;cursor:pointer" class="labelit creference navigation_action" onclick="mail2('0','#reference#')">
				   <font color="0080C0">#Reference#</font>
				</td>						
								
				<td style="padding-left:3px" class="labelit">#DateFormat(RequestDate,client.dateformatshow)#</td>
				<td style="padding-left:3px" class="labelit"><cfif len(Contact) gte "16">#left(Contact,15)#..<cfelse>#Contact#</cfif></td>
				
				<td style="padding-left:3px" class="labelit">#ItemDescription#</td>
				
				<cf_precision precision="#ItemPrecision#">		
				<td align="right" style="padding-left:3px;padding-right:4px" class="labelit">							
				  #numberformat(OriginalQuantity,'#pformat#')#							
				</td>
				<cf_precision precision="#ItemPrecision#">		
				<td align="right" style="padding-left:3px;padding-right:4px" class="labelit">							
				  #numberformat(TaskQuantity,'#pformat#')#							
				</td>
				
				<td align="center" class="labelit">
										
				  <cfif StockOrderId neq "">
				  
				    <!--- link has been disabled to limit access
				    <cfset jvlink = "try { ColdFusion.Window.destroy('dialogprocesstask',true)} catch(e){}; ColdFusion.Window.create('dialogprocesstask', '#TaskOrderReference#', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-140,resizable:true,closable:false,modal:true,center:true});ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Shipment/TaskView.cfm?actionstatus=1&stockorderid=#stockorderid#','dialogprocesstask')">		
					<a href="javascript:#jvlink#">
					<font color="0080C0">#TaskOrderReference#</font>
					</a>
					--->
					#TaskOrderReference#					
					
				  <cfelse>						  
				  
				    <font color="red"><cf_tl id="Not scheduled"></font>						  
					
				  </cfif>	
					
				</td>									
				
				<td style="padding-left:3px" class="labelit">
					
					<cfif TaskType eq "Purchase" and SourceRequisitionNo neq "">
					#SourceVendor#
					<cfelse>
						<cfif len(sourceWarehouse) gt "26">
						#left(sourcewarehouse,26)#..
						<cfelse>
						#SourceWarehouse#
						</cfif>
					</cfif>
					
				</td>
				
				<td style="padding-right:3px" class="labelit" align="center">#dateformat(shiptodate,client.dateformatshow)#</td>
								
				<td align="right" bgcolor="009FEC" class="labelit" id="pending_#taskid#" style="padding-left:5px;padding-right:5px;height:20;border-left:1px solid black;border-right:1px solid black;color:white">						
										
				 <cfif TaskType eq "Purchase" and SourceRequisitionNo neq "">
				
					 <cfif ReceiptQuantity gt "0">
					 #numberformat(TaskQuantity-ReceiptQuantity,'#pformat#')#	
					 <cfelse>
					 #numberformat(TaskQuantity,'#pformat#')#	
					 </cfif>																					 				
				 
				 <cfelse>
				 						 						 
				     <cfif TransactionQuantity gt "0">
					 #numberformat(TaskQuantity-TransactionQuantity,'#pformat#')#	
					 <cfelse>
					 #numberformat(TaskQuantity,'#pformat#')#	
					 </cfif>								 
				 
				 </cfif>
				 
				</td>
				
				<td align="right" style="padding-left:3px;padding-right:4px" class="labelit">#UoMDescription#</td>	
										
				<td bgcolor="white" style="width:60;padding-left:2px;" align="center" id="status#taskid#">
				
				    <cfif TaskType eq "Purchase" and SourceRequisitionNo neq "">
																			
					   <cfif ActionStatus eq "0">
					   
						   <img src="#SESSION.root#/images/pending.gif"
								width="13" height="13" align="absmiddle" alt="Pending Approval" border="0">
														   
					   <cfelseif ReceiptQuantity*diff gte TaskQuantity>	
					   
					       <!--- check if workflow is completed --->
						   
						   <cfquery name="receiptstatus" 
							  datasource="AppsPurchase" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  	SELECT  MIN(PR.ActionStatus) as Status
								FROM    PurchaseLineReceipt PR
								WHERE   PR.RequisitionNo = '#SourceRequisitionNo#'
							</cfquery>
							
							<cfif receiptstatus.Status eq "0">
							
								 <img src="#SESSION.root#/images/workinprogress.gif" height="15" width="15" 
								 	 alt="Pending confirmation" border="0" align="absmiddle">
							
							<cfelse>								   
					   
							   <img src="#SESSION.root#/images/check_icon.gif" alt="Completed" border="0" align="absmiddle">
								
							</cfif>	
					   
					   <cfelse>
					   										
							<cfquery name="POInfo" 
							  datasource="AppsPurchase" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  	SELECT  *
								FROM    Purchase P, PurchaseLine PL
								WHERE   P.PurchaseNo = PL.PurchaseNo	
								AND 	PL.RequisitionNo = '#SourceRequisitionNo#'
							</cfquery>
										   							   
							<cfinvoke component="Service.Access"
								   Method="procRI"
								   OrgUnit="#POInfo.OrgUnit#"
								   OrderClass="#POInfo.OrderClass#"
								   ReturnVariable="ReceiptAccess">												  				   

							<cfif ReceiptAccess eq "EDIT" or ReceiptAccess eq "ALL">	   						  
											
								<img src="#SESSION.root#/images/add.png"
									width="16" height="16"
									<cfif client.browser eq "Explorer">
										onclick="ProcRcptEntry('','#SourceRequisitionNo#','task','new','box_#taskid#','#taskid#')"
									<cfelse>
										onclick="alert('Please use Internet Explorer to process this action');"
									</cfif>
									style="cursor:pointer" 
									align="absmiddle"
									alt="Record External Delivery" 
									border="0">
								
							</cfif>
																							  
					  </cfif>	
					  
					  <img class="hide" name="refresh_box_#taskid#" 
							  id="refresh_box_#taskid#" border="0"
							  onclick="ColdFusion.navigate('#SESSION.root#/Procurement/Application/Receipt/ReceiptEntry/ReceiptDetail.cfm?rctid=&reqno=#SourceRequisitionNo#&mode=direct&taskid=#taskid#&box=box_#taskid#','box_#taskid#'); ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#taskid#&actormode=#url.actormode#','status#taskid#')">										  
							  								
					<cfelseif TaskType eq "Internal" and ShipToMode eq "Deliver" and StockOrderId neq "">
																			
					    <cfif (TransactionQuantity*diff) gte TaskQuantity>

							<img src="#SESSION.root#/images/check_icon.gif" 							   								
								alt="Completed" 
								border="0">
								
						<cfelse>	
						
							  <cfquery name="ReceiptMode" 
							  datasource="AppsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								SELECT   ModeShipmentEntry
								FROM     Ref_ShipToModeMission
								WHERE    Mission  = '#url.mission#' 										
								AND      Category = '#Category#'
								AND      Code     = 'Deliver'		
							</cfquery>	
							
							<!--- show only if the customer is going to enter the delivery --->
							
							<cfif receiptMode.ModeShipmentEntry eq "0">
						
							<cfinvoke component="Service.Access"
								   Method="procRI"
								   MissionOrgUnitId="#MissionOrgUnitId#"										 
								   ReturnVariable="ReceiptAccess">											   											   
								   
							<cfif ReceiptAccess eq "EDIT" or ReceiptAccess eq "ALL">	
							
								<cfif ItemShipmentMode eq "Fuel">	
									
									<cf_img icon="add"  onclick="processtaskorder('#taskid#','#url.actormode#','ReceiptFuel','add','')">
								
								<cfelse>
								
									<cf_img icon="add"  onclick="processtaskorder('#taskid#','#url.actormode#','ReceiptStandard','add','')">
								
								</cfif>
																												
							</cfif>
							
							<cfelse>
							
							 <img src="#SESSION.root#/images/workinprogress.gif" height="15" width="15" 
								 	 alt="Pending receipt registration by Contractor" border="0" align="absmiddle">
							
							</cfif>
								
						</cfif>		
						
					<cfelseif TaskType eq "Internal" and ShipToMode eq "Collect" and StockOrderId neq "">
																			
					    <cfif (TransactionQuantity*diff) gte TaskQuantity>

							<img src="#SESSION.root#/images/check_icon.gif" 							   								
								alt="Completed" 
								border="0">
								
						<cfelse>	
						
							  <cfquery name="ReceiptMode" 
							  datasource="AppsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								SELECT   ModeShipmentEntry
								FROM     Ref_ShipToModeMission
								WHERE    Mission   = '#url.mission#' 		
								AND      Category  = '#Category#'
								AND      Code      = 'Collect'		
							</cfquery>	
							
							<!--- show only if the customer is going to enter the delivery --->
							
							<cfif receiptMode.ModeShipmentEntry eq "0">
						
							<cfinvoke component="Service.Access"
								   Method="procRI"
								   MissionOrgUnitId="#MissionOrgUnitId#"										 
								   ReturnVariable="ReceiptAccess">											   											   
								   
							<cfif ReceiptAccess eq "EDIT" or ReceiptAccess eq "ALL">	
							
								<cfif ItemShipmentMode eq "Fuel">	
									
									<cf_img icon="add"  onclick="processtaskorder('#taskid#','#url.actormode#','ReceiptFuel','add','')">
								
								<cfelse>
								
									<cf_img icon="add"  onclick="processtaskorder('#taskid#','#url.actormode#','ReceiptStandard','add','')">
								
								</cfif>
																												
							</cfif>
							
							<cfelse>
														
							 <img src="#SESSION.root#/images/workinprogress.gif" height="15" width="15" 
								 	 alt="Pending receipt registration by Contractor" border="0" align="absmiddle">
							
							</cfif>
								
						</cfif>			
								
					<cfelse>
					
					      <cfif stockorderid neq "">
					
							<img src="#SESSION.root#/images/alert4.gif" 
							    onclick="processtaskorder('#taskid#','#url.actormode#','Action','add','')"
								width="14" height="14" 
								style="cursor:pointer" 
								align="absmiddle"
								alt="Notify" 
								border="0">			
								
						  </cfif>																
							
					</cfif>
					</td>
					
					<td class="hide creference">#WarehouseName#</td>
					
				</tr>	
								
				<tr class="hide clsRequest">
				    <td></td>
					<td colspan="11" height="1" class="linedotted"></td>
					<td class="hide creference">#Reference# #WarehouseName#</td>
				</tr>				
				
				<tr id="line#taskid#" style="height:0px" class="clsRequest">
				
					<td></td>	
					<td></td>						
						
					<cfif TaskType eq "Purchase" and SourceRequisitionNo neq "">																		
								
						<!--- ---------------------------------------------------------------- --->						 
						<!--- pending to be adjusted to ensure direct recording of the receipt --->
						<!--- ---------------------------------------------------------------- --->
						
						<td colspan="8" id="box_#taskid#">	
												 
					    <cfset url.mode     = "direct">  <!--- will hide the pricing --->
						<cfset url.box      = "box_#taskid#">
						<cfset url.rctid    = "">
						<cfset url.taskid   = "#taskid#">
						<cfset url.reqno    = "#SourceRequisitionNo#">
						
						<cfinclude template="../../../../../Procurement/Application/Receipt/ReceiptEntry/ReceiptDetail.cfm">								
						
						</td>
						
					<cfelse>					
												
						<td colspan="8" id="box#taskid#">	
						
						<!--- Possible warehouse transaction is to be confirmed by the Recipient --->
													
						<cfset url.taskid = taskid>							
						<cfinclude template="TaskProcessDetail.cfm">
						
						</td>																		
																		
					</cfif>								
					
					<td class="hide creference">#Reference# #WarehouseName#</td>
					
				</tr>						
				
				</cfif>	
			
			</cfoutput>									
						
		<!--- 				
		</cfoutput>
		--->
		
		</cfoutput>
		
		</cfoutput>