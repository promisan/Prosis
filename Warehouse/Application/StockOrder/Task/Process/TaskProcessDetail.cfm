<cf_compression> 

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     RequestTask S
	WHERE    S.TaskId = '#url.taskid#'	
</cfquery>

<!--- ------------------------------- --->
<!--- taskorder notification details- --->
<!--- ------------------------------- --->

<cfquery name="action" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT    S.ShipToMode,
	          S.TaskQuantity,
	          T.*, 
			  		  
			 (SELECT  ISNULL(ABS(SUM(TransactionQuantity)),0)
              FROM    ItemTransaction TR
			  WHERE   TR.RequestId    = T.RequestId									
			  AND     TR.TaskSerialNo = T.TaskSerialNo			 
			  AND     ActionStatus != '9'
			  
			  <cfif get.ShipToMode eq "Deliver">
				AND     TR.TransactionQuantity < 0
			  <cfelse>
				AND     TR.TransactionQuantity > 0
			  </cfif>
				AND     TR.TransactionType IN ('1','6','8')
			  ) as PickedQuantity,			 						  
			  R.Description			  		  
			  
	FROM      RequestTask S,
	          RequestTaskAction T,
			  Ref_TaskOrderAction R
	WHERE     T.ActionCode   = R.Code
	AND       S.RequestId    = T.RequestId
	AND       S.TaskSerialNo = T.TaskSerialNo
	AND       S.TaskId       = '#url.taskid#'	
</cfquery>

<!--- ------------------------- --->
<!--- taskorder receipt details --->
<!--- ------------------------- --->

<cfquery name="detail" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT  I.TransactionId,
	        I.TransactionQuantity,
	        I.TransactionBatchNo,
			B.BatchReference,
			I.ActionStatus,
	        I.ItemPrecision,
			I.OfficerUserId, 
			I.OfficerLastName, 
			I.OfficerFirstName, 
			I.ItemNo,
			I.ItemCategory,
			I.TransactionDate,
			T.ShipToMode,
			I.Mission,
			T.StockOrderId,
			I.Created,
			'Receipt' as Mode
	FROM    RequestTask T INNER JOIN
            ItemTransaction I ON T.RequestId = I.RequestId AND T.TaskSerialNo = I.TaskSerialNo INNER JOIN
			WarehouseBatch B on B.BatchNo = I.TransactionBatchNo
	WHERE   T.TaskId = '#url.taskid#'
	<cfif get.ShipToMode eq "Deliver">
	AND     I.TransactionQuantity < 0
	<cfelse>
	AND     I.TransactionQuantity > 0
	</cfif>
	AND     I.TransactionType IN ('1','6','8')	
	
	<!--- removed to no longer show the cancelled ones
	
	UNION 
	
	SELECT  I.TransactionId,
	        I.TransactionQuantity,
	        I.TransactionBatchNo,
			B.BatchReference,
			I.ActionStatus,
	        I.ItemPrecision,
			I.OfficerUserId, 
			I.OfficerLastName, 
			I.OfficerFirstName, 
			I.ItemNo,
			I.ItemCategory,
			I.TransactionDate,
			T.ShipToMode,
			I.Mission,
			T.StockOrderId,
			I.Created,
			'Denied' as Mode
	FROM    RequestTask T INNER JOIN
            ItemTransactionDeny I ON T.RequestId = I.RequestId AND T.TaskSerialNo = I.TaskSerialNo INNER JOIN
			WarehouseBatch B on B.BatchNo = I.TransactionBatchNo
	WHERE   T.TaskId = '#url.taskid#'
	<cfif get.ShipToMode eq "Deliver">
	AND     I.TransactionQuantity < 0
	<cfelse>
	AND     I.TransactionQuantity > 0
	</cfif>
	AND     I.TransactionType IN ('1','6','8')
	
	--->
	
	ORDER BY I.Created	
	
</cfquery>

<cf_compression>

<cfif detail.recordcount gte "1" or action.recordcount gte "1">

	<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="navigation_table" style="border:0px solid gray">
	
	<cfoutput query="action">	
	
	<tr bgcolor="ffffcf">
		   
			<td width="20" align="center">								   
			   
			   <img src="#SESSION.root#/images/pointer.gif" border="0" style="cursor:pointer" alt="Print">					
			</td>
		    <td width="140" class="labelit">#Description#</td>
			<td width="120" style="padding-left:4px">
			<cfif PersonNo neq "">		
						
				<cfquery name="Person" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT   *
					FROM     Person
					WHERE    PersonNo = '#url.taskid#'	
				</cfquery>
				
				#Person.FirstName# #Person.LastName#
	
			
			</cfif>
			</td>
			
			<td width="120">#dateformat(datetimeplanning,CLIENT.DateFormatShow)# #timeformat(datetimeplanning, "HH:MM")# #OfficerLastName#</td>	
			<td colspan="2" style="padding:2px">
				<table width="100%" bgcolor="f4f4f4" style="padding:0px;border:1px dotted silver">
					<tr><td style="padding:2px" class="labelit">#ActionMemo#</td></tr>
				</table>
			</td>	
			<td height="20" align="right" style="padding-right:5px">
			
			      <!--- only the same user can make changes --->
			
				  <cfif (SESSION.acc eq officeruserid and PickedQuantity lt TaskQuantity) or 
				        (getAdministrator(detail.mission) eq "1")>
				  	
				      <table height="19" cellspacing="0" cellpadding="0" bgcolor="ffffbf" style="border:0px dotted silver">
					  <tr>
					  					  
					  <td style="padding-left:3px;padding-right:3px">					  
					  	<cf_img icon="edit" onclick="processtaskorder('#taskid#','#url.actormode#','action','edit','#taskactionid#')">						   
					  </td>
						 
					  <td style="border-left:1px dotted silver;padding-left:3px;padding-right:3px">  					  
					   <cf_img icon="delete" onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskFormActionDelete.cfm?taskactionid=#taskactionid#&taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')">					     					   
					  </td>
					  </tr>
					  </table> 
				  
				  </cfif>
					
			</td>
						
		</tr>
	
	</cfoutput>	
	
	<cfif detail.recordcount gte "1">
		
		<!--- -------------------------- --->
		<!--- show the receipts recorded --->
		<!--- -------------------------- --->
		
		<cfquery name="ReceiptMode" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT   ModeShipmentEntry
			FROM     Ref_ShipToModeMission
			WHERE    Mission  = '#Detail.mission#' 
			AND      Category = '#Detail.ItemCategory#'
			<cfif get.ShipToMode eq "Deliver">
			AND      Code = 'Deliver'
			<cfelse>
			AND      Code = 'Collect'
			</cfif>
		</cfquery>	
				
		<cfif url.actormode eq "provider">
			<cfif receiptMode.ModeShipmentEntry eq "1">		
				<cfset confirmation = "No">
			<cfelse>
				<cfset confirmation = "Yes">				
			</cfif>
		<cfelse>  <!--- recipient --->
			
			<cfif receiptMode.ModeShipmentEntry eq "1">
				<cfset confirmation = "Yes">
			<cfelse>
				<cfset confirmation = "No">				
			</cfif>
		</cfif>
			
		<cfoutput query="detail">	
				
			<cf_precision number="#itemPrecision#">	
									
			<cfif mode eq "denied">    
			    <cfset style   = "text-decoration: line-through;color:FF6464">
			    <cfset color   = "f4f4f4"> 
				<cfset fcolor  = "white">
			<cfelseif actionstatus eq "0">
			    <cfset style = "">
				<cfset color = "ffffcf">
				<cfset fcolor  = "black">
			<cfelse>
			    <cfset style = "">
				<cfset color = "B9FFB9">	
				<cfset fcolor  = "black">
			</cfif>
					
			<tr bgcolor="#color#" class="navigation_row">
			   
				<td width="20" class="linedotted" align="center" style="height:16;padding-left:4px">	
				
				    <cfif mode neq "denied">
					
						<cfquery name="getTemplate" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							SELECT  *
							FROM    Ref_ShipToModeMission
							WHERE   Mission  = '#Mission#'
							AND     Category = '#ItemCategory#'
							AND     Code     = '#get.ShipToMode#'		
						</cfquery>
						
						<cf_img icon="print" onclick="stockbatchprint('#StockOrderId#', '#getTemplate.ShipmentTemplate#')"> 
																					   
						<cfquery name="getItem" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							SELECT  *
							FROM    Item
							WHERE   ItemNo = '#ItemNo#'					
						</cfquery>   
						
						<cfif getItem.ItemShipmentMode eq "standard">
								<cfset mode = "process">
						<cfelse>
								<cfset mode = "view">
						</cfif>
						
					</cfif>	
						
				</td>
			    <td width="100" class="labelmedium linedotted" style="color:#fcolor#;#style#" ><a href="javascript:batch('#transactionBatchno#','#detail.mission#','#mode#')"><b><font color="#fcolor#">#TransactionBatchNo#</a></td>
				<td width="110" class="labelmedium linedotted" style="color:#fcolor#;padding-left:4px;#style#">#OfficerLastName#</td>
				<td width="160" class="labelmedium linedotted"  style="color:#fcolor#;padding-left:2px;#style#">#dateformat(transactiondate,CLIENT.DateFormatShow)# #timeformat(transactiondate, "HH:MM")#</td>	
				<td width="100" class="labelmedium linedotted" align="right"  style="color:#fcolor#;padding-left:2px;#style#">#BatchReference#</td>	
				<td class="labelmedium linedotted" style="color:#fcolor#;padding-left:16px;#style#"><i><font size="1" color="808080">Received quantity:</font></i> #numberformat(abs(transactionquantity),'#pformat#')#</td>	
				<td class="labelmedium linedotted" style="padding-left:4px;padding-right:4px;#style#" align="right">
								
					 <cfif actionstatus eq "0" and mode neq "denied">
					
						 <cfif confirmation eq "Yes">
						 			  
								 <table style="width:130;padding:2px;height:30" cellspacing="0" cellpadding="0">
								 <tr>						 
								 
									 <cfif getItem.ItemShipmentMode eq "fuel">
									 
										 <td bgcolor="yellow" align="center" style="cursor:pointer;border:1px solid gray;padding-left:3px;padding-right:3px;padding-top:1px;padding-bottom:1px"
										    onclick="processtaskorder('#taskid#','#url.actormode#','confirm','add','#transactionid#')">	
											<table cellspacing="" cellpadding="0" class="formpadding"><tr>
											<td>			 
										    <cf_tl id="Confirm"> <cf_tl id="Receipt"></td>
											<td style="padding-left:3px">				    
											 <img src="#SESSION.root#/images/pending.png" height="12" width="12" border="0" align="absmiddle">		
											 </td></tr></table>				 
										 </td>
									 
									 <cfelse>
									 
									 	 <td class="top3n" align="center" style="cursor:pointer;border:1px dotted silver;padding-left:3px;padding-right:3px;padding-top:1px;padding-bottom:1px"
										    onclick="batch('#transactionBatchno#','#detail.mission#','process','','receipt')">	
											<table cellspacing="0" cellpadding="0" class="formpadding">
												<tr><td>					 
										    		<cf_tl id="Confirm"> <cf_tl id="Receipt"></td><td style="padding-left:3px">			    
											 		<img src="#SESSION.root#/images/pending.png" height="12" width="12" border="0" align="absmiddle">		
											  		</td>
												</tr>
											</table>					 
										 </td>						 
									 
									 </cfif>
								 
								 </tr>
								 </table>
											 
						<cfelse>
						
							<!--- attention entry is on site so the destination is reversed in the dialog --->
							
							<table style="width:30" cellspacing="0" cellpadding="0">
								<tr>					
									<td colspan="2" style="padding-top:1px;padding-right:8px" align="right">																
									   <cf_img icon="delete" onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskFormReceiptDelete.cfm?batchno=#transactionbatchno#&taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')">													
									</td>				
								</tr>
							</table>
										 
						 </cfif>
					 
					 </cfif>
				 
				</td> 				 
									
			</tr>	
			
			<cfif mode neq "Denied">
					
				<cfquery name="Shipping" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT  *
					FROM    ItemTransactionShipping
					WHERE   TransactionId = '#transactionid#'		
					AND     ActionStatus = '1'			
				</cfquery>
				
				<cfif Shipping.recordcount eq "1">
					
				<tr bgcolor="98E8F3">
				   
					<td width="20" style="padding-left:4px" valign="top" align="center">				
						<img src="#SESSION.root#/images/join.gif" border="0" style="cursor:pointer">				
					</td>
				    <td width="100" class="labelit" style="padding-left:4px">Confirmation</td>
					<td width="120" class="labelit" style="padding-left:4px">#Shipping.ConfirmationFirstName# #Shipping.ConfirmationLastName#</td>
					<td width="120" class="labelit">#dateformat(Shipping.ConfirmationDate,CLIENT.DateFormatShow)# #timeformat(Shipping.ConfirmationDate, "HH:MM")#</td>	
					<td colspan="2" style="padding:3px">
								
					    <cfif Shipping.ConfirmationMemo neq "">
						<table width="100%" bgcolor="f4f4f4" style="padding:2px;border:1px dotted silver">
							<tr><td style="padding:2px">#Shipping.ConfirmationMemo#</td></tr>
						</table>
						</cfif>
					</td>	
					<td height="20" align="right" style="padding-right:5px">
					
						  <cfif SESSION.acc eq officeruserid>
					
					      <table height="19" cellspacing="0" cellpadding="0" style="border:0px dotted silver">
						  <tr> 
							 
						  <td style="border-left:1px dotted silver;padding-left:3px;padding-right:3px">  
						  
							  <cf_img icon="delete" 
							     tooltip="revert confirmation" onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskFormConfirmDelete.cfm?transactionid=#transactionid#&taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')">
						  			   
						  </td>
						  </tr>
						  </table> 
						  
						  </cfif>
							
					</td>
								
				</tr>
			
			</cfif>	
			
			</cfif>
						
		</cfoutput>	
		
	</cfif>
			
	</table>

</cfif>

