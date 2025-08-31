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
	
<cfoutput>

<cfset bal = get.TaskQuantity - get.PickedQuantity>
				
<cfif (get.PickedQuantity*diff) gte get.TaskQuantity>		
				   
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
	 
	 <script>
	  document.getElementById('balance#url.taskid#').innerHTML = "#numberformat(bal,'_,__._')#"
	 </script>
				
<cfelse>	

		<table width="100%">		
			<tr>		
			<td style="padding-left:8px;padding-right:8px;cursor:pointer" 
			    class="labelit" 						
				onclick="issueshipment('#url.TaskId#','Issuance','ReceiptFuel','add')">
					<img src ="#Client.VirtualDir#/images/process.gif" alt="Process shipment" border="0">												
			</td>							
			</tr>
		</table>
		
	 <script>
	  document.getElementById('balance#url.taskid#').innerHTML = "#numberformat(bal,'_,__._')#"
	 </script>	

</cfif>


</cfoutput>	

<!---
	
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
			
--->			