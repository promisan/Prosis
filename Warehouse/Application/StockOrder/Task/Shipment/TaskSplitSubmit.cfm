
<cftransaction>

		
	<cfquery name="GetTask" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
	
			SELECT *
			FROM   RequestTask
			WHERE  TaskId = '#url.taskid#'
			 
	 </cfquery>
	 
	 <cfquery name="Request" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
	
			SELECT *
			FROM   Request
			WHERE  RequestId = '#GetTask.RequestId#'
			 
	 </cfquery>

	 <cfset quantity = GetTask.TaskQuantity>
	 <cfset uomQuantity = GetTask.TaskUoMQuantity>
	 
	 <cfset percentage1 = url.q1/quantity>
	 <cfset percentage2 = url.q2/quantity>
	 
	<cfquery name="Update" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
	
			UPDATE RequestTask
			SET    TaskQuantity = #url.q1#, TaskUoMQuantity = TaskUoMQuantity * #percentage1#
			WHERE  TaskId = '#url.taskid#'
			 
	 </cfquery>
	 

	 
 	<cfquery name="NextSerialNo" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	 
	 		SELECT MAX(TaskSerialNo) + 1 AS SerialNo
			FROM   RequestTask
			WHERE  RequestId = '#GetTask.RequestId#'
 
	</cfquery>
	
	<cfquery name="Update" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		
			INSERT INTO RequestTask(
				[RequestId]
		      ,TaskSerialNo 
		      ,[TaskType]
		      ,[TaskQuantity]
		      ,[TaskUoM]
		      ,[TaskUoMQuantity]
		      ,[TaskCurrency]
		      ,[TaskPrice]
		      ,[ExchangeRate]
		      ,[StockOrderId]
		      ,[SourceRequisitionNo]
		      ,[SourceWarehouse]
		      ,[SourceLocation]
		      ,[ShipToDate]
		      ,[ShipToMode]
		      ,[ShipToOrgUnit]
		      ,[ShipToWarehouse]
		      ,[ShipToLocation]
		      ,[DeliveryStatus]
		      ,[RecordStatus]
		      ,[RecordStatusDate]
		      ,[RecordStatusOfficer]
		      ,[OfficerUserId]
		      ,[OfficerLastName]
		      ,[OfficerFirstName]
			)
		
			SELECT [RequestId]
		      ,#NextSerialNo.SerialNo# AS TaskSerialNo 
		      ,[TaskType]
		      ,#url.q2# 
		      ,[TaskUoM]
		      , #uomQuantity# * #percentage2#
		      ,[TaskCurrency]
		      ,[TaskPrice]
		      ,[ExchangeRate]
		      ,[StockOrderId]
		      ,[SourceRequisitionNo]
		      ,[SourceWarehouse]
		      ,[SourceLocation]
		      ,[ShipToDate]
		      ,[ShipToMode]
		      ,[ShipToOrgUnit]
		      ,[ShipToWarehouse]
		      ,[ShipToLocation]
		      ,[DeliveryStatus]
		      ,[RecordStatus]
		      ,[RecordStatusDate]
		      ,[RecordStatusOfficer]
		      ,[OfficerUserId]
		      ,[OfficerLastName]
		      ,[OfficerFirstName]
		    FROM   RequestTask			  
			WHERE  TaskId = '#url.taskid#'
			 
	 </cfquery>
 
 </cftransaction>
 
 <table width="100%" height="100%" style="background-color:white;">
 	<tr>
		<td class="labellarge" align="center">
			Done!
		</td>
	</tr>
 </table>
 
 <cfoutput>
 
	 <script>
	 	showtaskpending('#Request.Mission#','#GetTask.TaskType#');
		ColdFusion.Window.destroy('dialogprocesstask');
	 </script>
 
 </cfoutput>