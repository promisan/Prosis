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
<cfparam name="Form.selected"    default="">
<cfparam name="url.stockorderid" default="">
<cfparam name="url.warehouse"    default="">

<!--- check the delivery status --->
<cfinclude template = "TaskDeliveryStatus.cfm">

<!--- ------------------------------------------- --->
<!--- get the list of taskorder lines to be shown --->
<!--- ------------------------------------------- --->

<cfinvoke component  = "Service.Process.Materials.Taskorder"  
	method           = "TaskorderList" 
	mission          = "#url.mission#"
	warehouse        = "#url.warehouse#"
	tasktype         = "#url.tasktype#"
	stockorderid     = "#url.stockorderid#"
	selected         = "#form.selected#"
	returnvariable   = "gettask">	
			
<cfquery name="param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      Ref_ParameterMission
   WHERE     Mission = '#url.mission#'  
</cfquery>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding" align="center">
					
	<tr>	
				
		<td></td>		
		<td style="padding-left:4px" class="labelit"><cf_tl id="Ship To"></td>
		<td style="padding-left:4px" class="labelit"><cf_tl id="Contact"></td>
		<td style="padding-left:4px" class="labelit"><cf_tl id="Request"></td>	
		<td class="labelit"><cfif edit eq "1"><cf_tl id="Mode"></cfif></td>					
		<td class="labelit"><cf_tl id="Tasked on"></td>
		<td class="labelit"><cf_tl id="Officer"></td>	
		<td class="labelit"><cf_tl id="Item"></td>	
		<td class="labelit" align="center"><cf_tl id="UoM"></td>		
		<td class="labelit" align="center"><cf_tl id="Quantity"></td>					
		<cfif getTask.taskuom neq getTask.UoM>
		    <td class="labelit" align="center"><cf_tl id="UoM"></td>		
		    <td class="labelit" align="center"><cf_tl id="Tasked"></td>		
		<cfelse>
		    <td class="labelit" align="right"><cf_tl id="Received"></td>	
		    <td class="labelit" align="right"><cf_tl id="Balance"></td>					
		</cfif>		
		<td class="labelit"></td>			
	</tr>
	
	<tr><td class="linedotted" colspan="13"></td></tr>
				
	<cfif getTask.recordcount eq "0">
					
	<tr>
	   <td colspan="13" height="80" align="center" class="labelmedium cell"><i>
	   
		<cf_tl id = "There are no tasks pending to be processed or" class="message" var = "msg1">
		<cf_tl id = "its request approval status was reverted." class="message" var = "msg2">
		<cf_tl id = "Please contact your administrator." class="message" var = "msg3">		
				
		<cfoutput>
	     <font color="red">#msg1# #msg2# <br>#msg3#</font>
	    </cfoutput>
		
	   </td>
    </tr>
	
	</cfif>
	
	<cfif url.tasktype eq "Purchase">
	
	      <cfset group1 = "orgunitvendor">
		  <cfset group2 = "purchaseno">		  
		  
	<cfelse>
	
		 <cfset group1 = "sourcewarehouse">
		 <cfset group2 = "shiptomode">		 		 
	
	</cfif>
		
	<cfoutput query="GetTask" group="#group1#">
	
		<cfif edit eq "1">
		
			<cfif url.tasktype eq "purchase">
		
			<tr>
				<td colspan="13" class="labelit" style="padding:2px"><b>#vendor#</b></td>
			</tr>
						
			<cfelse>
						
			<!---
			
			<tr>
				<td colspan="8" style="padding-left:2px;padding-top:4px">
				<font face="Verdana" size="2"><b>#SourceWarehousename#</font>				
				</td>
			</tr>
			
			--->
			
			</cfif>
			
		
		</cfif>
		
		<cfoutput group="#group2#">					
				
			<cfoutput group="shiptodate">		
										   
				<tr>				
				
				<cfif url.tasktype eq "purchase">	
						
					<td colspan="13" class="labelit">
						<a href="javascript:ProcPOEdit('#purchaseno#')"><b>#PurchaseNo#</font></a>#dateformat(shiptodate,"DDDD : #CLIENT.DateFormatShow#")#			
					</td>
										
			    <cfelse>	
			
					<cfquery name="getMode" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   Ref_ShipToMode
						WHERE  Code = '#shiptomode#'
					</cfquery>					
							
				    <td colspan="13" bgcolor="fafafa" class="labelmedium" style="height:30;padding-left:6px;padding-top:1px;padding-bottom:1px">#getMode.Description# on: <b>#dateformat(shiptodate,"#CLIENT.DateFormatShow# DDDD")#</b></td>
											
			    </cfif>					
								
				</tr>
				
				<tr><td colspan="13" class="linedotted"></td></tr>
				
				<cfoutput group="RequestType">	
				
				<tr>	
				
					<td colspan="13" bgcolor="ffffdf" style="padding-left:10px" class="labelit">#RequestTypeName#</td>
				
				</tr>
																		
				<cfoutput>
													
					<tr class="navigation_row" style="padding-left:8px;padding:2px" id = "r#GetTask.RequestId#_#GetTask.TaskSerialNo#" class="<cfif GetTask.RecordStatus eq "3">highLight4 <cfelse>regular</cfif> cell">		
					
					<td class="navigation_action" 
					    style="height:23;padding-left:10px" 
						onclick="window.open('#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#Reference#&ID0=#Param.RequisitionTemplateMultiple#','_blank', 'left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no')">					
						<cf_img icon="print">
					</td>
					<td style="padding:2px;padding-left:9px" class="labelit">#WarehouseName#</td>	
					<td style="padding:2px" class="labelit">#Contact#</td>
					<td style="padding:2px" class="labelit">#Reference#</td>	
														
					<td style="padding:2px" class="labelit" id="f#taskid#_shiptomode">
			
					    <cfif edit eq "1">
			
							<cfif ShipToMode eq "Deliver">
							
								<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/taskViewShipToMode.cfm?taskid=#taskid#&mode=Collect','f#taskid#_shiptomode')">						
								<font color="0080C0">COLLECTION</font>
								</a>
								
							<cfelse>
							
								<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/taskViewShipToMode.cfm?taskid=#taskid#&mode=Deliver','f#taskid#_shiptomode')">												
								<font color="0080C0">DELIVERY</font>
								</a>
							
							</cfif>		
						
						</cfif>
							
			        </td>	
					
					<td style="padding:2px" class="labelit">#dateformat(TaskedOn,CLIENT.DateFormatShow)#</td>
					<td style="padding:2px" class="labelit">#TaskedBy#</td>					
					<td style="padding:2px" class="labelit">#ItemDescription#</td>
					<td style="padding-left:2px" class="labelit">#UoMDescription#</td>	
						
					<td style="padding:0px" class="labelit" align="right">						
						<cf_precision number="#itemPrecision#">						
						#numberformat(TaskQuantity,'#pformat#')#					
					</td>				
					
					<cfif taskuom neq uom>
										
					<td style="padding:2px" class="labelit" align="right" bgcolor="ffffaf" height="15">								
						#numberformat(TaskUoMQuantity,'#pformat#')#
					</td>
					
					<td class="labelit" style="padding-left:2px">								
								
					<cfquery name="GetUoM" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						  SELECT * 
						  FROM   ItemUoM
						  WHERE  ItemNo = '#ItemNo#'
						  AND    UoM    = '#taskuom#'
					 </cfquery> 
					 
					 #getUoM.UoMDescription#				
					
					</td>
					
					<cfelse>
					
					<td class="labelit" align="right">#numberformat(Receipt,'#pformat#')#</td>		
					
					</cfif>
					
					<cfset bal = TaskQuantity-Receipt>			
					
					<cfif bal gt 0 and recordstatus neq "3">
					
					<td align="right" bgcolor="FFFF00" style="width:80;padding-right:4px" class="labelit" id="balance#GetTask.TaskId#">									
						#numberformat(bal,'#pformat#')#					
					</td>
					
					<cfelse>
					
					<td align="right" bgcolor="lime" style="color:black;width:80;padding-right:4px" class="labelit" id="balance#GetTask.TaskId#">									
						#numberformat(bal,'#pformat#')#				
					</td>
										
					</cfif>
					
					<cfif StockOrderId eq "">
					
						<cfif stockordermode eq "0">
						
							<cfif bal lte "0">
							<td></td>					
							<cfelse>
							<td id="status#GetTask.TaskId#">
							<table width="100%">		
							<tr>		
							<td style="padding-left:8px;padding-right:8px;cursor:pointer" 
							    class="labelit" 						
								onclick="issueshipment('#GetTask.TaskId#','Issuance','ReceiptFuel','add')">
						 		<img src ="#Client.VirtualDir#/images/process.gif" alt="Process shipment" border="0">												
							</td>							
							</tr>
							</table>
							
							</td>	
							</cfif>
												
						<cfelse>
					
							<td style="padding-left:8px;;padding-right:8px;cursor:pointer" 
							    class="labelit" 
								id="d#GetTask.RequestId#_#GetTask.TaskSerialNo#" 
								onclick = "javascript:settasksplit('#GetTask.TaskId#')">
						 		<img src ="#Client.VirtualDir#/images/transfer2.gif" alt="Split the tasked quantity" border="0">												
							</td>	
						
						</cfif>							
					
					<cfelse>
					
						<td id="d#GetTask.RequestId#_#GetTask.TaskSerialNo#" style="width:40" class="labelit">
						
						<cfinvoke component = "Service.Access"  
						   method           = "WarehouseShipper" 
						   mission          = "#mission#"
						   warehouse        = "#url.warehouse#" 					 
						   returnvariable   = "accessShip">	
						 
						    <cfif accessShip eq "ALL">														
														
								<table align="right" cellspacing="0" cellpadding="0">
								
								<tr>
								<cfif GetTask.RecordStatus neq "3" 
								    and GetTask.DeliveryStatus neq "3" 
									and GetTask.PendingConfirmation eq "0">
																										
									<td style="padding-left:5px">
									
									  <input type="button" 
									     name="Close" 
										 value="Close" 
										 style="width:45;height:20" 
										 onclick="javascript:settaskreceived('#GetTask.RequestId#','#GetTask.TaskSerialNo#','#url.stockorderid#')">
									
									</td>
							
									<cfquery name="GetTransaction" 
											 datasource="AppsMaterials" 
											 username="#SESSION.login#" 
											 password="#SESSION.dbpw#">
											 	SELECT TOP 1 TransactionId
												FROM   ItemTransaction
												WHERE  RequestId='#GetTask.RequestId#' 
												AND    TaskSerialNo = '#GetTask.TaskSerialNo#'
									</cfquery>																								
									
									<cfif GetTransaction.recordcount eq 0 and GetTask.recordcount gt 1>
									
										<td style="padding-left:5px">
										
										 <input type="button" 
									     name="Delete" 
										 value="Delete" 
										 style="width:45;height:20" 
										 onclick="unlinkRequestTask('#GetTask.TaskId#','#url.scope#')">
										
										</td>
									</cfif>
									
								</cfif>
								</tr>
								</table>
							
							</cfif>
													
						</td>
					
					</cfif>
					
					<td class="regular" style="padding:0px">
					
					 <cfif edit eq "1" and stockordermode eq "1">
					 
						  <input type="checkbox" 
							   id="sel#taskid#" 
							   name="selected" 
							   value="'#taskid#'" 
							   onclick="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Task/Shipment/TaskAssignmentCheck.cfm?mission=#url.mission#&tasktype=#url.tasktype#','process','','','POST','taskplanning')">						
							   
					  </cfif>
					   
					</td>
					
				</tr>			
				
				<cfif GetTask.RecordStatus eq "3">
				
				<tr>
 				
				   <td colspan="13" style="padding-left:10px;padding-top:1px" class="labelit"><font color="red">Attention:</font> <font color="6688aa">This task was manually closed on <u>#dateformat(getTask.RecordStatusDate,client.dateformatshow)#</U> by <u>#getTask.RecordStatusOfficer#</u></td>
				
				</tr>		
				
				</cfif>		
				
								
				<cfif edit eq "0">
				
					<!--- show deliveries --->
											
					<cfif TaskType eq "Purchase" and SourceRequisitionNo neq "">		
					
							<tr><td></td><td colspan="12" style="padding:2px">																											
												 
						    <cfset url.mode   = "direct">
							<cfset url.box    = "box_#taskid#">
							<cfset url.rctid  = "">
							<cfset url.taskid = "#taskid#">
							<cfset url.reqno  = "#SourceRequisitionNo#">
							<cfset url.purchase = "#purchaseno#">
					
							<cfinclude template="../../../../../Procurement/Application/Receipt/ReceiptEntry/ReceiptDetail.cfm">	
							
							</td></tr>							
							
					<cfelse>
						
						<cfif PickedQuantity gt "0">
						
							<tr>
													
							<td colspan="13" style="padding-left:2px;padding-right:2px;border:1px solid silver" id="box#taskid#">							
							<cfset url.taskid = taskid>	
							<!--- added to show detail in template --->		
							<cfset url.actormode = "recipient">				
							<cfinclude template="../Process/TaskProcessDetail.cfm">
							
							</td>
														
							</tr>
							
						</cfif>
						
					</cfif>	
			 							
				</cfif>								
				
				</cfoutput>
				
				</cfoutput>
				
			</cfoutput>
										
		</cfoutput>
		
	</cfoutput>
							
</table>

<cfset AjaxOnLoad("doHighlight")>	