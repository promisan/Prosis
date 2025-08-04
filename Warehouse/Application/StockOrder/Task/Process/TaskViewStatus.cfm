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

<!--- apply dynamic updated by running a query on the taskid --->

<cfquery name="getMission" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  	SELECT  *
		FROM    Request R
		WHERE   R.RequestId IN (
			                    SELECT RequestId 
			                    FROM   RequestTask
								WHERE  RequestId = R.RequestId
								AND    TaskId    = '#url.taskid#'
						       )					 
				
</cfquery>

<cfparam name="url.refresh" default="yes">

<cfif getMission.recordcount eq "1">
	<cfset mission = getMission.mission>
	<cfset refresh = url.refresh>
<cfelse>
    <cfset refresh = "No">	
	<cfset mission = "">
</cfif>

<cfquery name="param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      Ref_ParameterMission
   WHERE     Mission = '#mission#'  
</cfquery>

<cfif param.taskorderdifference eq "">
    <cfset diff = 1>
<cfelse>
	<cfset diff = (100+param.taskorderdifference)/100>
</cfif>	

<cfoutput>

<cfquery name="get" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  	SELECT   T.ShipToMode,
		         T.TaskType,
				 T.DeliveryStatus,
				 T.RecordStatusDate,
		         T.SourceRequisitionNo,
		         T.TaskQuantity,		
				 T.ShipToDate,
				 T.StockOrderId,
				 	 
				 (SELECT  ActionStatus
	              FROM    TaskOrder 
				  WHERE   StockOrderId  = T.StockorderId									
				  ) as StockOrderStatus, 
				 
				 (SELECT  ISNULL(SUM(ReceiptWarehouse),0)
	              FROM    Purchase.dbo.PurchaseLineReceipt
				  WHERE   Warehousetaskid = T.TaskId													
				  AND     ActionStatus != '9') as ReceiptQuantity,
				  
				 (SELECT  ISNULL(SUM(TransactionQuantity),0)
	              FROM    ItemTransaction S
				  WHERE   RequestId    = T.RequestId									
				  AND     TaskSerialNo = T.TaskSerialNo
				  AND     TransactionQuantity > 0
				  AND     ActionStatus != '9') as PickedQuantity			 
				  				  
		FROM     RequestTask T 
		
		WHERE    TaskId = '#url.taskid#'	
	</cfquery>
	
	<cfquery name="item" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">	  
	  SELECT    R.Warehouse, I.*
      FROM      RequestTask T INNER JOIN
                Request R ON T.RequestId = R.RequestId INNER JOIN
                Item I ON R.ItemNo = I.ItemNo
	  WHERE     T.TaskId = '#url.taskid#'
	</cfquery>	
		
<cf_precision precision="#item.ItemPrecision#">		

<cfif get.TaskType eq "Purchase">
				
	<cfif (get.ReceiptQuantity*diff) gte get.TaskQuantity>	
	
		<img src="#SESSION.root#/images/check_icon.gif" 							   								
			alt="Completed" border="0">
		
		<cfif get.DeliveryStatus neq "3" and get.RecordStatusDate eq "">
			
			<cfquery name="setStatus" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	  
				  UPDATE  RequestTask
				  SET     DeliveryStatus = '3'
				  WHERE   TaskId = '#url.taskid#'	  
			</cfquery>	
		
		</cfif>
						
	<cfelse>
	
		<cfif get.ReceiptQuantity eq "0"  and get.RecordStatusDate eq "">
		
		    <!--- pending --->
		  
		  	<cfquery name="setStatus" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	  
				  UPDATE  RequestTask
				  SET     DeliveryStatus = '0'
				  WHERE   TaskId = '#url.taskid#'	  
			</cfquery>			  
		  
		<cfelseif get.ReceiptQuantity gte "1"  and get.RecordStatusDate eq "">
			
			<!--- partial --->
			
			<cfquery name="setStatus" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	  
				  UPDATE  RequestTask
				  SET     DeliveryStatus = '1'
				  WHERE   TaskId = '#url.taskid#'	  
			</cfquery>	
		
		</cfif>	
		
		<img src="#SESSION.root#/images/add.png"
			width="16" height="16"
		    onclick="ProcRcptEntry('','#get.SourceRequisitionNo#','task','new','box_#url.taskid#','#url.taskid#')" 
			style="cursor:pointer" 
			align="absmiddle"
			alt="Record External Delivery" 
			border="0">		
				
	</cfif>			
	
	 <cfif get.ReceiptQuantity gt "0">
			<cfset pending = numberformat(get.TaskQuantity-get.ReceiptQuantity,pformat)>	
			<cfif pending lt 0>
				<cfset pending = 0>
			</cfif>
	 <cfelse>
			<cfset pending = numberformat(get.TaskQuantity,'#pformat#')>	
	 </cfif>		
	
<cfelse>

	<!--- internal --->
	
	<cfif get.stockorderid eq "" or get.StockOrderStatus eq "0">
				
			 <img src="#SESSION.root#/images/workinprogress.gif" 
			     height="15" 
				 width="15" 
				 style="cursor:pointer" 
				 alt="Check status"
				 onclick="ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#url.taskid#&actormode=#url.actormode#','status#url.taskid#')"
			 	 alt="Pending confirmation" border="0" align="absmiddle">
				
	<cfelseif (get.PickedQuantity*diff) gte get.TaskQuantity>		
				   
		   <img src="#SESSION.root#/images/check_icon.gif" alt="Completed" border="0" align="absmiddle">
		   
		   <cfif get.DeliveryStatus neq "3" and get.RecordStatusDate eq "">
			
			<cfquery name="setStatus" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	  
				  UPDATE  RequestTask
				  SET     DeliveryStatus = '3'
				  WHERE   TaskId = '#url.taskid#'	  
			</cfquery>	
		
		 </cfif>
				
	<cfelse>
	
		  <cfif get.PickedQuantity eq "0"  and get.RecordStatusDate eq "">
		  
		  	<cfquery name="setStatus" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	  
				  UPDATE  RequestTask
				  SET     DeliveryStatus = '0'
				  WHERE   TaskId = '#url.taskid#'	  
			</cfquery>			  
		  
		  <cfelseif get.PickedQuantity gte "1"  and get.RecordStatusDate eq "">
			
			<cfquery name="setStatus" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">	  
				  UPDATE  RequestTask
				  SET     DeliveryStatus = '1'
				  WHERE   TaskId = '#url.taskid#'	  
			</cfquery>	
		
		  </cfif>
		
		  <cfif url.actormode eq "Recipient">
		  
		  		<cfquery name="ReceiptMode" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT   ModeShipmentEntry
						FROM     Ref_ShipToModeMission
						WHERE    Mission  = '#mission#' 
						AND      Category = '#Item.Category#'
						AND      Code = 'Deliver'
				</cfquery>	
			
				 <cfif ReceiptMode.ModeShipmentEntry eq "0">
				 
				    <!--- recipinent is recording --->			 	
				 
				 	<cfif item.itemshipmentmode eq "fuel">
										 							
						<img src="#SESSION.root#/images/add2.png" 
						    onclick="processtaskorder('#url.taskid#','#url.actormode#','receiptfuel','add','')" 
							style="cursor:pointer" 
							alt="Record Task order Fulfillment" 
							border="0">
							
					<cfelse>
					
						<img src="#SESSION.root#/images/add2.png" 
						    onclick="processtaskorder('#url.taskid#','#url.actormode#','receiptstandard','add','')" 
							style="cursor:pointer" 
							alt="Record Task order Fulfillment" 
							border="0">
					
					</cfif>		
						
				 <cfelse>
				 
				 	<img src="#SESSION.root#/images//alert4.gif" 
					    onclick="processtaskorder('#url.taskid#','#url.actormode#','action','add','')" 
						style="cursor:pointer" 
						height="12" width="12"
						alt="Notify Taskorder Fulfillment" 
						border="0">							 
				 
				 </cfif> 			
			
			<cfelse>
			
				<!--- provider mode --->
			
				<cfquery name="ReceiptMode" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT   ModeShipmentEntry
						FROM     Ref_ShipToModeMission
						WHERE    Mission  = '#mission#' 
						AND      Category = '#Item.Category#'
						AND      Code     = 'Collect'
				</cfquery>	
		
				  <cfif ReceiptMode.ModeShipmentEntry eq "1">
				 
				 	<cfif item.itemshipmentmode eq "fuel">
										 							
					<img src="#SESSION.root#/images/enter1.gif" 
					    onclick="processtaskorder('#url.taskid#','#url.actormode#','receiptfuel','add','')" 
						style="cursor:pointer" 
						alt="Record Task order Fulfillment" 
						border="0">
					
					<cfelse>
					
					<img src="#SESSION.root#/images/enter1.gif" 
					    onclick="processtaskorder('#url.taskid#','#url.actormode#','receiptstandard','add','')" 
						style="cursor:pointer" 
						alt="Record Task order Fulfillment" 
						border="0">					
					
					</cfif>							
						
				 <cfelse>
				 
				 	<img src="#SESSION.root#/images/alert4.gif" 
					    onclick="processtaskorder('#url.taskid#','#url.actormode#','action','add','')" 
						style="cursor:pointer" 
						height="12" width="12"
						alt="Notify Taskorder Fulfillment" 
						border="0">							 
				 
				 </cfif> 		
			 
			</cfif> 
		
	</cfif>
	
	<cfif get.PickedQuantity gt "0">
			
		<cfset pending = get.TaskQuantity-get.PickedQuantity>				
		<cfif pending lt 0>
			<cfset pending = 0>
		</cfif>
		<cfset pending = numberformat(pending,pformat)>				
		
	<cfelse>
	
		<cfset pending = numberformat(get.TaskQuantity,pformat)>	
		
	</cfif>
		
</cfif>	

<!--- ---------------------------------- --->
<!--- set the status of the request line --->
<!--- ---------------------------------- --->		

<cf_setRequestStatus requestid = "#getMission.RequestId#">
		
<script language="JavaScript">

	document.getElementById('pending_#url.taskid#').innerHTML = "#pending#"
	
	<cfif refresh eq "yes">
   
	    // refresh the tree of the process screen for the shipping warehouse 
		try { 
	    if (document.getElementById('tasktreerefresh')) {		
	      ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/View/StockOrderTreeTaskRefresh.cfm?mission=#mission#&warehouse=#item.warehouse#','tasktreerefresh')
	    } } catch(e) {}
		
		// refresh the calndare date content for the shipping warehouse 	
		try {			
	    if (document.getElementById('calendarday_#day(get.shiptodate)#')) {
	     // ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewDate.cfm?mission=#mission#&warehouse=#item.warehouse#&calendardate=#get.shiptodate#','calendarday_#day(get.shiptodate)#')
	    } } catch(e) {}
	
	</cfif>
	
	
</script>

</cfoutput>	