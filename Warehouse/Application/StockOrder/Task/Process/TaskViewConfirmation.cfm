						
<cfparam name="url.actormode" default="Provider">
<cfparam name="url.shiptomode" default="">
		
<cfquery name="param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Ref_ParameterMission
	   WHERE     Mission = '#mission#'  
</cfquery>

<cfinvoke component = "Service.Process.Materials.Taskorder"  
	method           = "TaskorderList" 
	tasktype         = "Internal"
	mission          = "#url.mission#"
	warehouse        = "#url.warehouse#"	   	
	mode             = "Confirmation"
	shiptomode       = "#url.shiptomode#"
	stockorderid     = ""
	selected         = ""
	returnvariable   = "listing">		
	 									
<table width="99%" cellspacing="0" cellpadding="0" align="center" class="navigation_table formpadding">
	
	<cfset col = "12">
	
	<tr><td height="4"></td></tr>
	
	<tr>
	    <td width="20"></td>
		<td class="labelit" style="padding-left:0px;padding-right:6px"><cf_tl id="Product"></td>		
		<td class="labelit"><cf_tl id="Transfer"></td>
		<td class="labelit"><cf_tl id="Contact"></td>
		<td class="labelit"><cf_tl id="Request"></td>										
		<td class="labelit" colspan="2"><cf_tl id="Approval"></td>				
		<td class="labelit"><cf_tl id="Mode"></td>				
		<td class="labelit" align="right"><cf_tl id="Quantity"></td>	
		<td class="labelit" align="right"><cf_tl id="Pending"></td>				
		<td class="labelit" style="padding-left:7px"><cf_tl id="UoM"></td>
		<td></td>		
	</tr>
	<tr><td colspan="<cfoutput>#col#</cfoutput>" class="linedotted"></td></tr>
	<tr><td height="4"></td></tr>
	
	<cfif Listing.recordcount eq "0">
	
	<cfoutput>				
	<tr><td colspan="<cfoutput>#col#</cfoutput>" height="90" align="center" class="labelmedium"><font color="green"><b>There are no task-order receipts that are pending to be confirmed.</b></font></td></tr>
	</cfoutput>
	
	</cfif>
	
	<cfoutput query="Listing" group="shiptomode">
		
		<tr>
		<td colspan="8" height="25" class="labellarge">
																	
		<cfquery name="getmode" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Ref_ShipToMode
		   WHERE     Code = '#shiptomode#'  
		</cfquery>							
		
		<b><cf_tl id="#getMode.Description#">
					
		</td>
		</tr>
		
		<!---
		<cfoutput group="shiptodate">					
		
		<tr>
		<td colspan="7" height="25" style="padding-left:3px">
		<font face="Verdana" size="2"><b>#dateformat(shiptodate,CLIENT.DateFormatShow)#</font>				
		</td>
		</tr>
		<tr><td colspan="#col#" class="linedotted"></td></tr>
		--->
		
		<cfoutput group="taskorderreference">
		
		<cfif TaskorderReference neq "">
		
			<tr>
			<td colspan="7" style="padding-top:2px;padding-left:8px" class="labelit">
			
			<!--- <cfif shiptomode neq "collect"> --->			
			
				<cfset jvlink = "try { ColdFusion.Window.destroy('dialogprocesstask',true)} catch(e){}; ColdFusion.Window.create('dialogprocesstask', '#TaskOrderReference#', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-140,resizable:true,closable:false,modal:true,center:true});ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Shipment/TaskView.cfm?actionstatus=1&stockorderid=#stockorderid#','dialogprocesstask')">														
				
				<a href="javascript:#jvlink#" title="View workflow">
				<!--- print delivery order --->
				<!--- <img src="#SESSION.root#/images/print_small5.gif" alt="Print" border="0" width="13" height="11"> ---> 							
				<b><font color="0080C0">#TaskOrderReference#</font></b>		
				</a>
				
			<!--- <cfelse>
																
				<font face="Verdana" size="2">
				#TaskOrderReference# 							
				</font>		
			
			</cfif> --->
			
			</td>
			</tr>
			<tr><td colspan="#col#" class="linedotted"></td></tr>
			
		</cfif>
					
		<cfoutput>		
									
			<tr class="navigation_row" bgcolor="<cfif recordstatus eq '3'>f1f1f1<cfelseif TaskOrderReference eq ''>ffffff</cfif>">						
			
			<td style="padding-left:8px;padding:2px" class="labelit">
						
			<!--- 
			
				<cfif shiptomode eq "collect">
						
						<cfquery name="getTemplate" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							SELECT  *
							FROM    Ref_ShipToModeMission
							WHERE   Code = '#ShipToMode#'
							AND		Mission = '#Mission#'
						</cfquery>
						
						<cfset vTemplate = getTemplate.ShipmentTemplate>
						<cfset vTemplate = "Warehouse/Inquiry/Print/BulkTicket/BulkTicket.cfr">
						
						<img src="#SESSION.root#/images/print_small5.gif" 
						alt="Print" 
						title="Print"
						border="0" 
						width="13" 
						height="11" 
						style="cursor: pointer;"
						onclick="stockbatchprint('#StockOrderId#', '#vTemplate#')">
				</cfif> 
			
			--->
			
			</td>
			
			<td class="labelit" style="padding-left:7px;padding:2px">#ItemDescription#</td>
			<td class="labelit" style="padding:2px">#WarehouseName#</td>
			<td class="labelit" style="padding:2px">#Contact#</td>
			<td class="labelit" style="padding:2px" onclick="window.open('#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#Reference#&ID0=#Param.RequisitionTemplateMultiple#','_blank', 'left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no')">
			<a href="##"><font color="6688aa">#Reference#</a>
			</td>																							
			<td class="labelit" style="padding:2px" colspan="2">#TaskedBy# (#dateformat(TaskedOn,CLIENT.DateFormatShow)#)</td>						
			<td class="labelit" style="padding:2px" id="f#taskid#_shiptomode">
						
			<cfif PickedQuantityCount eq "0">
									
				<cfif ShipToMode eq "Deliver">
				
					<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/taskViewShipToMode.cfm?taskid=#taskid#&mode=Collect','f#taskid#_shiptomode')">						
					<font color="808080">Set: COLLECTION</font>
					</a>
					
				<cfelse>
				
					<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/taskViewShipToMode.cfm?taskid=#taskid#&mode=Deliver','f#taskid#_shiptomode')">												
					<font color="808080">Set: DELIVERY</font>
					</a>
				
				</cfif>		
			
						
			</cfif>	
				
			</td>	
			
			<cf_precision precision="#ItemPrecision#">		
								
			<td class="labelit" align="right" style="padding:2px">#numberformat(TaskQuantity,'#pformat#')#</td>
			
			<td class="labelit" align="right" id="pending_#taskid#" style="padding:2px"><font face="Verdana">
									 
			     <cfif PickedQuantity gt "0">
				 	<cfset pen = "#numberformat(TaskQuantity-PickedQuantity,'#pformat#')#">	
				 <cfelse>
				 	<cfset pen = "#numberformat(TaskQuantity,'#pformat#')#">
				 </cfif>								 
				 
				 <cfif pen lt "0">
				    <cfset pen = "0">
				 </cfif>							 
				 #pen#
			 						 
			</td>						
									
			<td class="labelit" style="padding-left:7px;padding:2px">#UoMDescription#</td>	
			<td class="labelit" style="padding-left:4px;padding:2px" id="status#taskid#" align="center">	
																
				<cfif PickedQuantity gte TaskQuantity>
					
						<img src="#SESSION.root#/images/check_icon.gif" alt="Completed" border="0">
							
				<cfelse>
					
					 <cfif ShipToMode eq "Collect">
					 
					   <cfif stockorderid eq "" or StockOrderStatus eq "0">
					   
					    <!--- disable if the taskorder is still in process --->								
						
							<img src="#SESSION.root#/images//workinprogress.gif" 									    										
								align="absmiddle"
								height="15"
								class="navigation_action"
								style="cursor:pointer"
								onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#taskid#&actormode=#actormode#','status#taskid#')"					 	
								alt="Pending taskorder preparation" 
								border="0">		
					   
					   <cfelse>
					   					   					   
						   	<cfif ItemShipmentMode eq "Fuel">					 			
										
								  <img src="#SESSION.root#/images/enter1.gif" 
								    onclick="processtaskorder('#taskid#','#actormode#','ReceiptFuel','add','')" 
									style="cursor:pointer" 
									class="navigation_action"
									alt="Record Task order fulfillment" 
									border="0">
								
							<cfelse>
							
								 <img src="#SESSION.root#/images/enter1.gif" 
								    onclick="processtaskorder('#taskid#','#actormode#','ReceiptStandard','add','')" 
									style="cursor:pointer" 
									class="navigation_action"
									alt="Record Task order fulfillment" 
									border="0">	
								
							</cfif>	
							
						</cfif>	
							
					 <cfelse>
					 
					    <cfif stockorderid eq "" or StockOrderStatus eq "0">
						
						   <!--- disable if the taskorder is still in process --->
						
							<img src="#SESSION.root#/images//workinprogress.gif" 									    										
								align="absmiddle"
								height="15"
								class="navigation_action"
								style="cursor:pointer"
								onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#taskid#&actormode=#actormode#','status#taskid#')"					 											
								alt="Pending taskorder preparation" 
								border="0">		
						
						<cfelse>				
					 
						 	<img src="#SESSION.root#/images//alert4.gif" 
							    onclick="processtaskorder('#taskid#','#actormode#','Action','add','')" 
								style="cursor:pointer" 
								class="navigation_action"
								height="14" height="14"
								alt="Notify Taskorder Execution" 
								border="0">		
								
						</cfif>							 
					 
					 </cfif> 		
							
				</cfif>					
											
			</td>
			
			</tr>		
			
			<tr>
				<td colspan="2"></td>
				<td colspan="10" id="box#taskid#" style="padding-right:19px">													
											
				<cfif PickedQuantityCount gte "0">
				
					<cfset url.taskid = taskid>							
					<cfinclude template="TaskProcessDetail.cfm">
				
				</cfif>
				
				</td>
				<td></td>
				
			</tr>	
			
		</cfoutput>		
		
		</cfoutput>
				
		<tr><td height="5"></td></tr>
					
	</cfoutput>
			
</table>

<cfset AjaxOnLoad("doHighlight")>
			
			