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
<cfparam name="url.stockorderid" default="">

<cfloop list="0,1,3" index="i">

	<cfswitch expression="#i#">
	
		<cfcase value="0">
		
		     <!--- set the query for pending --->
			 
			<cfsavecontent variable = "cStatusLine">
					T.RecordStatus != '9'	
					<!--- has NOT receipt recorded against any of its lines --->	
					AND 
					
					<cfif url.tasktype eq "Purchase">
					
						<!--- external deliveries through purchase --->
					
						T.StockorderId NOT IN (
							SELECT DISTINCT RT.StockOrderId
							FROM   RequestTask RT 
							       INNER JOIN Purchase.dbo.PurchaseLineReceipt PLR  ON PLR.WarehouseTaskId = RT.TaskId AND PLR.ActionStatus != '9'
							WHERE  RT.StockOrderId = T.StockOrderId					
							AND    RT.RequestId = T.RequestId
							AND    RT.TaskSerialNo = T.TaskSerialNo					
						)
						
					<cfelse>
					
						<!--- internal transfer deliveries, a negative will indicate issuing transaction to fullfill a taskorder --->
					
						NOT EXISTS
						(
							SELECT  RequestId
							FROM    ItemTransaction TR
							WHERE   TR.RequestId    = T.RequestId
							AND     TR.TaskSerialNo = T.TaskSerialNo
							AND     ActionStatus != '9'
							AND     TR.TransactionQuantity < 0
							AND     TR.TransactionType = '8'   <!--- corrected from IN ('1','8','6') --->		
						)
					
					</cfif>	
							
			</cfsavecontent>
		
		</cfcase>
		
		<cfcase value="1">
		<!--- Partial --->
			<cfsavecontent variable = "cStatusLine">
					T.RecordStatus != '9'
					<!--- has not receipt recorded against any of its lines --->	
					<cfif url.tasktype eq "Purchase">
					AND T.StockorderId IN
					(
						SELECT DISTINCT RT.StockOrderId
						FROM   RequestTask RT INNER JOIN Purchase.dbo.PurchaseLineReceipt PLR
						          ON PLR.WarehouseTaskId = RT.TaskId AND PLR.ActionStatus != '9'
						WHERE  RT.StockOrderId = T.StockOrderId	
						AND     RT.RequestId = T.RequestId
						AND     RT.TaskSerialNo = T.TaskSerialNo									
					)		
					</cfif>
									
					AND 
					(
						(
						SELECT  SUM(RT.TaskQuantity)
						FROM    RequestTask RT 
						WHERE   RT.StockOrderId = T.StockOrderId
						AND     RT.RecordStatus != '9'
						AND     RT.RequestId = T.RequestId
						AND     RT.TaskSerialNo = T.TaskSerialNo					
						)
						>
						(
						<cfif url.tasktype eq "Purchase">
							
							SELECT  SUM(PLR.ReceiptQuantity)
							FROM    RequestTask RT  INNER JOIN Purchase.dbo.PurchaseLineReceipt PLR 
							ON      PLR.WarehouseTaskId = RT.TaskId
							WHERE   RT.StockOrderId    = T.StockOrderId
							AND     PLR.ActionStatus  != '9'
							AND     RT.RequestId       = T.RequestId
							AND     RT.TaskSerialNo    = T.TaskSerialNo	
											
						<cfelse>
						
							SELECT  ISNULL(ABS(SUM(TransactionQuantity)),0)
							FROM    ItemTransaction TR
							WHERE   TR.RequestId    = T.RequestId
							AND     TR.TaskSerialNo = T.TaskSerialNo
							AND     ActionStatus != '9'
							AND     TR.TransactionQuantity < 0
							AND     TR.TransactionType = '8'   <!--- Hanno 17/5 corrected from IN ('1','8','6') --->					
							
						</cfif>	
						)
						
						<cfif url.tasktype eq "purchase">
						AND (
							SELECT  SUM(PLR.ReceiptQuantity)
							FROM    RequestTask RT  INNER JOIN Purchase.dbo.PurchaseLineReceipt PLR 
							ON      PLR.WarehouseTaskId = RT.TaskId
							WHERE   RT.StockOrderId = T.StockOrderId
							AND     PLR.ActionStatus != '9'
							AND     RT.RequestId = T.RequestId
							AND     RT.TaskSerialNo = T.TaskSerialNo							
							) <>0
						
						<cfelse>
						AND	(
						     SELECT  ISNULL(ABS(SUM(TransactionQuantity)),0)
							 FROM    ItemTransaction TR
							 WHERE   TR.RequestId    = T.RequestId
							 AND     TR.TaskSerialNo = T.TaskSerialNo
							 AND     ActionStatus != '9'
							 AND     TR.TransactionQuantity < 0
							 AND     TR.TransactionType = '8'   <!--- Hanno 17/5 corrected from IN ('1','8','6') --->		
							 ) <> 0												
							 
						</cfif>
						
					)						
					
			</cfsavecontent>
	
		</cfcase>		
	
		<cfcase value="3">
				
		    <!--- Completed --->
		
			<cfsavecontent variable = "cStatusLine">
			(
				T.RecordStatus = '3'
				OR
				(
					T.RecordStatus != '9'
					AND 
					
					(	
						(
						SELECT  SUM(RT.TaskQuantity)
						FROM    RequestTask RT 
						WHERE   RT.StockOrderId = T.StockOrderId
						AND     RT.RecordStatus != '9'
						AND     RT.RequestId = T.RequestId
						AND     RT.TaskSerialNo = T.TaskSerialNo
						)
						<=
						(
						<cfif url.tasktype eq "Purchase">
							SELECT  SUM(PLR.ReceiptQuantity)
							FROM    RequestTask RT  INNER JOIN Purchase.dbo.PurchaseLineReceipt PLR 
		        					ON PLR.WarehouseTaskId = RT.TaskId
							WHERE   RT.StockOrderId = T.StockOrderId
							AND     PLR.ActionStatus != '9'
							AND     RT.RequestId = T.RequestId
							AND     RT.TaskSerialNo = T.TaskSerialNo					
						<cfelse>
							SELECT  ISNULL(ABS(SUM(TransactionQuantity)),0)
							FROM    ItemTransaction TR
							WHERE   TR.RequestId    = T.RequestId
							AND     TR.TaskSerialNo = T.TaskSerialNo
							AND     ActionStatus != '9'
							AND     TR.TransactionQuantity < 0
							AND     TR.TransactionType = '8'   <!--- Hanno 17/5 corrected from IN ('1','8','6') --->														
						</cfif>	
						)
					)		
				)	
			)		
			</cfsavecontent>						
		</cfcase>		
	
	</cfswitch>
	
	<!--- update the task status --->
		
	<cfquery name="qSetStatus" 
	   datasource="AppsMaterials"
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		UPDATE   RequestTask 
		SET      DeliveryStatus = '#i#'
		FROM     RequestTask T 
		WHERE    T.StockOrderid IN (SELECT StockOrderId 
		                            FROM   TaskOrder 
									WHERE  StockOrderId = T.StockOrderId
									AND    Mission = '#URL.Mission#') 
		AND      T.DeliveryStatus != '#i#'
		<cfif url.stockorderid neq "">
		AND      T.StockorderId    = '#url.stockorderid#'
		</cfif>
		AND      T.TaskType        = '#url.tasktype#'
		AND      #PreserveSingleQuotes(cStatusLine)#			    
	</cfquery>			

</cfloop>
