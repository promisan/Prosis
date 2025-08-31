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
<cfquery name="getBatch" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT    * 
	FROM      WarehouseBatch
	WHERE     BatchNo IN (SELECT TransactionBatchNo
	                      FROM   ItemTransaction 
						  WHERE  TransactionId = '#url.actionid#')
</cfquery>	 
	  
<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT  R.Mission, R.ItemNo, T.*, WC.TaskOrderAttachmentEnforce,
		  
			 (SELECT  ISNULL(SUM(TransactionQuantity),0)
	          FROM    ItemTransaction S
			  WHERE   RequestId    = T.RequestId									
			  AND     TaskSerialNo = T.TaskSerialNo
			  AND     TransactionQuantity > 0
			  AND     ActionStatus != '9') as PickedQuantity		
			  				  
	FROM    RequestTask T
			INNER JOIN Request R
				ON T.RequestId = R.RequestId
			INNER JOIN Warehouse W
				ON T.SourceWarehouse = W.Warehouse
			INNER JOIN Ref_WarehouseClass WC
				ON W.WarehouseClass = WC.Code
	WHERE   TaskId      = '#url.taskid#'	
</cfquery>	
	
<cf_fileExist 
	DocumentPath="WhsBatch" 
	SubDirectory="#getBatch.BatchId#" 
	Filter=""> 
	
<cfif files eq "0" and (get.ShipToMode eq "Collect" or (get.ShipToMode eq "Deliver" and get.TaskOrderAttachmentEnforce eq 1))>

	<cf_alert message = "You must attach one or more receipt documents under [Attachments]"  return = "no">
	<cfabort>
	
</cfif> 

  	  
<cfquery name="check" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT  * 
	FROM    ItemTransactionShipping
	<cfif url.actionid neq "">
	WHERE   TransactionId = '#url.actionid#'	
	<cfelse>
	WHERE   1 = 0
	</cfif>
</cfquery>	

<cfset dateValue = "">
<CF_DateConvert Value="#Form.TransactionDate#">
<cfset dte = dateValue>

<cftransaction>
	
	<cfset dte = DateAdd("h","#form.Transaction_hour#", dte)>
	<cfset dte = DateAdd("n","#form.Transaction_minute#", dte)>
	
	<cfif check.recordcount eq "0">
		
		<cfquery name="Insert" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   INSERT INTO Materials.dbo.ItemTransactionShipping 
				(TransactionId, 	
				 ActionStatus,
				 ConfirmationDate,	
				 ConfirmationUserId,
				 ConfirmationLastName,
				 ConfirmationFirstName,
				 ConfirmationMemo,
				 OfficerUserid,
				 OfficerLastName,
				 OfficerFirstName)
		VALUES 	('#url.actionid#', 		
				 '1',
				 #dte#,
				 '#SESSION.acc#',
		         '#SESSION.last#',
				 '#SESSION.first#',
		         '#form.ActionMemo#',		
				 '#SESSION.acc#', 
				 '#SESSION.last#',
				 '#SESSION.first#')
		</cfquery>	
	
	<cfelse>
	
		<cfquery name="UpdateShipping" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			    UPDATE ItemTransactionShipping
				SET    ConfirmationDate      = #dte#,
				       ConfirmationUserId    = '#SESSION.acc#',
					   ConfirmationLastName  = '#SESSION.last#',
					   ConfirmationFirstName = '#SESSION.first#',
					   ConfirmationMemo      = '#form.ActionMemo#',
					   ActionStatus          = '1'
				WHERE  TransactionId         = '#url.actionid#'			
		</cfquery>	
	
	</cfif> 
	
	<!--- update the lines --->
	  	  
	<cfquery name="line" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT    * 
		FROM      ItemTransaction
		WHERE     TransactionId = '#url.actionid#'	
	</cfquery>	 
	
	<cfquery name="UpdateBatch"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE WarehouseBatch		
			SET    ActionStatus           = '1',
			       ActionOfficerDate      = #dte#,
			       ActionOfficerUserId    = '#SESSION.acc#',
				   ActionOfficerLastName  = '#SESSION.last#',
				   ActionOfficerFirstName = '#SESSION.first#'
			WHERE  BatchNo                = '#line.TransactionBatchNo#'
	</cfquery>
	
	<cfquery name="UpdateLines"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE ItemTransaction		
			SET    ActionStatus = '1'
			WHERE  TransactionBatchNo = '#line.TransactionBatchNo#'
	</cfquery>
		
	<!--- ------------------------ NOT CLEAR IF THIS MAKES SENSE--------------- --->			
	<!--- --------------------------- amendment ------------------------------- --->
	<!--- We also clear transactions with the stockorderid of this confirmation --->
	<!--- --------------------------------------------------------------------- --->
	
	<cfif get.StockOrderId neq "">
	
		<cfquery name="getBatch"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   WarehouseBatch						
				WHERE  StockOrderId  = '#get.StockOrderId#'
		</cfquery>
		
		<cfif getBatch.recordcount eq "1">
	
			<cfquery name="UpdateBatch"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE WarehouseBatch		
					SET    ActionStatus           = '1',
					       ActionOfficerDate      = #dte#,
					       ActionOfficerUserId    = '#SESSION.acc#',
						   ActionOfficerLastName  = '#SESSION.last#',
						   ActionOfficerFirstName = '#SESSION.first#'
					WHERE  BatchNo                = '#getBatch.BatchNo#'
			</cfquery>
			
			<cfquery name="UpdateLines"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE ItemTransaction		
					SET    ActionStatus = '1'
					WHERE  TransactionBatchNo = '#getBatch.BatchNo#'
			</cfquery>
			
		</cfif>
			
	</cfif>
	
	
	<!--- ---------------------------------- --->
	<!--- set the status of the request line --->
	<!--- ---------------------------------- --->
		
	<cf_setRequestStatus requestid = "#get.RequestId#">
	
</cftransaction>
 	
<cfoutput>

<script language="JavaScript">
  _cf_loadingtexthtml="";	
  try {		
  ColdFusion.Window.hide('dialogprocesstask')
  } catch(e) {}
  // refresh the content of the receipts
  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskProcessDetail.cfm?taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')
  // update the status in the view on the line level
  se = document.getElementById('status#url.taskid#')
  if (se) {
  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#url.taskid#&actormode=#url.actormode#','status#url.taskid#')
  } 
  _cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
</script>

</cfoutput>
