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

<cfparam name="url.action" default="quantity">

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Request
		WHERE  RequestId    = '#URL.Id#'		
</cfquery>

<cfoutput>

<cf_compression>

<cfif url.action eq "quantity">
	
	    <cfset val  = replace("#url.val#",",","")>
	
		<cfif not LSIsNumeric(val)>	
		
		    <cfabort>
					
		<cfelseif val lte "0">
		
			<script>
				alert("Invalid quantity")
			</script>
			
			<cfquery name="get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  * 
				FROM    RequestTask				
				WHERE   RequestId    = '#URL.ID#'
				AND     TaskSerialNo = '#URL.serialNo#'
			</cfquery>	
									
			<script language="JavaScript">
			    document.getElementById('#url.serialno#_quantity').value = '#numberformat(get.TaskQuantity,'__,__')#'
			</script>
						
			<cfabort>
			
		
		<cfelse>
		
		<!--- added 12/8 reset 9 --->
		
		   <cfquery name="Check" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
	        DELETE FROM RequestTask
		    WHERE  RequestId = '#URL.Id#'
   		    <!--- only valid order lines --->
		    AND    RecordStatus = '9'	
		   </cfquery>
		
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    TaskQuantity = '#val#' 
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'
			</cfquery>	
			
			<cfquery name="getTask" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   RequestTask	
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'			
			</cfquery>		
			
			<cfquery name="UoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   ItemUoM 
				WHERE  ItemNo   = '#get.ItemNo#'
				AND    UoM      = '#getTask.TaskUoM#'
			</cfquery>	
			
			<cfif UoM.UoMMultiplier neq "0">
				<cfset qty = getTask.TaskQuantity / UoM.UoMMultiplier>
			<cfelse>
			    <cfset qty = getTask.TaskQuantity>
			</cfif>	
			
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    TaskUoMQuantity = '#qty#' 
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'
			</cfquery>		
			
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    TaskUoMQuantity = round(TaskUoMQuantity,2) 
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'
			</cfquery>								
			
			<cfoutput>
			
				<script>
					ColdFusion.navigate('setTaskQuantity.cfm?id=#url.id#&serialno=#url.serialno#','box_#url.serialno#_taskquantity')
				</script>
			
			</cfoutput>					
										
		</cfif>	
		
<cfelseif url.action eq "taskuom">

	        <cfset val  = replace("#url.val#",",","")>				
						
			<cfquery name="getTask" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
				FROM   RequestTask	
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'			
			</cfquery>		
			
			<cfquery name="UoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   ItemUoM 
				WHERE  ItemNo   = '#get.ItemNo#'
				AND    UoM      = '#val#'
			</cfquery>	
								
			<cfif UoM.UoMMultiplier neq "0">
				<cfset qty = getTask.TaskQuantity / UoM.UoMMultiplier>
			<cfelse>
			    <cfset qty = getTask.TaskQuantity>
			</cfif>	
			
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    TaskUoM     = '#val#', 
				       TaskUoMQuantity = '#qty#' 
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'
			</cfquery>		
			
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    TaskUoMQuantity = round(TaskUoMQuantity,2) 
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'
			</cfquery>						
			
			<cfoutput>
			
				<script>
					ColdFusion.navigate('setTaskQuantity.cfm?id=#url.id#&serialno=#url.serialno#','box_#url.serialno#_taskquantity')
				</script>
			
			</cfoutput>		
		
	
<cfelseif url.action eq "shiptodate">	
				
		<cfif url.val neq "">	
			   
		    <CF_DateConvert Value="#url.val#">			
			<cfset DTE = dateValue>
			
			<!--- if the date if more than 30 days in the future or in the past it might have been a conversion of the format --->
			
			<cfif dateDiff("D",  DTE,  now()) gte 10>
					
				<script>
				alert('Task delivery date lies in the past. Operation not allowed.')
				</script>	
				<cfabort>
				
			<cfelseif dateDiff("D",  DTE,  now()) lte -30>	
				
				<script>
				alert('Task delivery date lies to far into the future. Operation not allowed.')
				</script>	
				<cfabort>
							
			</cfif>		
			
		<cfelse>
		
		    <cfset DTE = 'NULL'>
			
		</cfif>				
					
		<cfif not IsDate(dte)>	
					 		   
		   <cfabort>
		
		<cfelse>
		
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    ShipToDate   = #dte# 
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'
			</cfquery>
						
		</cfif>	
		
		<cfoutput>
			
			<script>
				ColdFusion.navigate('setTaskPrice.cfm?id=#url.id#&serialno=#url.serialno#','#url.serialno#_taskvalue')
			</script>
			
		</cfoutput>
		
	
<cfelseif url.action eq "warehouse">	
	
			<cfset val  = replace("#url.val#",",","")>
					
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    SourceWarehouse  = '#val#' 
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'
			</cfquery>		
			
			<script language="JavaScript">			
			ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Tasking/TaskViewInternalDetail.cfm?requestid=#url.id#&serialno=#url.serialno#&taskedwarehouse=#val#','internaldetail')						
			</script>
		
<cfelseif url.action eq "shiptomode">	
	
			<cfset val  = replace("#url.val#",",","")>
					
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    ShipToMode   = '#val#' 
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'
			</cfquery>			
					
				
<cfelseif url.action eq "shiptowarehouse">	
	
			<cfset val  = replace("#url.val#",",","")>
					
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    ShipToWarehouse = '#val#' 
				WHERE  RequestId    = '#URL.ID#'
				AND    TaskSerialNo = '#URL.serialNo#'
			</cfquery>			
			
			<cfoutput>
			
				<script>
					ColdFusion.navigate('setTaskPrice.cfm?id=#url.id#&serialno=#url.serialno#','#url.serialno#_taskvalue')
				</script>
			
			</cfoutput>
			
<cfelseif url.action eq "requisition">	

			<cfset val  = replace("#url.val#",",","")>
											
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    SourceRequisitionNo = '#val#', 
				       TaskType         = 'Purchase',		
					   RecordStatus     = '1',
					   SourceWarehouse  = NULL,   <!--- '#url.warehouse#', --->			  
					   SourceLocation   = NULL
				WHERE  RequestId        = '#URL.ID#'
				AND    TaskSerialNo     = '#URL.serialNo#'				
				
			</cfquery>
						
			<cfoutput>			
		
				<script>					   			
					 ColdFusion.navigate('setTaskPrice.cfm?id=#url.id#&serialno=#url.serialno#','#url.serialno#_taskvalue')
					 ColdFusion.navigate('getSource.cfm?id=#url.id#&serialno=#url.serialno#','box_#url.serialno#')
				</script>
			
			</cfoutput>			
		
<cfelseif url.action eq "location">	

			<cfquery name="getLocation" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   WarehouseLocation
				WHERE  StorageId = '#url.val#'				
			</cfquery>
			
																				
			<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequestTask
				SET    SourceRequisitionNo = NULL, 
				       SourceLocation      = '#getLocation.Location#',
					   SourceWarehouse     = '#getLocation.Warehouse#', 
				       TaskType            = 'Internal',
					   RecordStatus        = '1',
					   OfficerUserId       = '#SESSION.acc#',
					   OfficerLastName     = '#SESSION.last#',
					   OfficerFirstName    = '#SESSION.first#'
				WHERE  RequestId           = '#URL.ID#'
				AND    TaskSerialNo        = '#URL.serialNo#'
								
			</cfquery>
			
			<cfquery name="setLocation" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   WarehouseLocation
				WHERE  Warehouse = '#getLocation.Warehouse#'	
				AND    Distribution = 1
				AND    Operational = 1			
			</cfquery>
									
			<cfloop query="setLocation">	
						 			
				<cfif getLocation.Location eq Location>
							
					<script>		
					   try {		
					  document.getElementById('line_#location#').className = "highlight1"
					  } catch(e) {}
					</script>
				
				<cfelse>
				
					<script>	
					   try {			
					   document.getElementById('line_#location#').className = "regular"
					   } catch(e) {}
					</script>
				
				</cfif>
									
			</cfloop>
								
			<script>				
				// ColdFusion.navigate('setTaskPrice.cfm?id=#url.id#&serialno=#url.serialno#','#url.serialno#_taskvalue')				
				ColdFusion.navigate('getSource.cfm?id=#url.id#&serialno=#url.serialno#','box_#url.serialno#')
			</script>
			
			
			<cf_compression>
									
</cfif>

<!--- ------------------------------------------------------------------------------------------ --->
<!--- after the update determine if we can find a planned transaction values for this task order --->

<cfif url.action eq "quantity">

    <!--- determine if we need to create another taskorder line --->
	
	<cfquery name="Line" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   RequestTask	
			WHERE  RequestId    = '#URL.ID#'
			AND    TaskSerialNo = '#URL.serialNo#'
	</cfquery>
		
	<!--- check if new line to be created --->
	
	<cfquery name="Tasked" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT  MAX(TaskSerialNo) as Last, 
		        SUM(TaskQuantity) as Quantity
	    FROM    RequestTask
		WHERE   RequestId = '#URL.id#'
	</cfquery>
	
	<cfif Tasked.Quantity lt get.RequestedQuantity>
		
		<cfif tasked.last eq "">
		    <cfset ser = "1">
			<cfset qty = get.RequestedQuantity>
		<cfelse>
			<cfset ser = tasked.last + 1> 
			<cfset qty = get.RequestedQuantity-Tasked.Quantity>
		</cfif>
		
		<cfquery name="UoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   ItemUoM 
				WHERE  ItemNo   = '#get.ItemNo#'
				AND    UoM      = '#Line.TaskUoM#'
		</cfquery>	
								
		<cfif UoM.UoMMultiplier neq "0">
			<cfset tsk = qty / UoM.UoMMultiplier>
		<cfelse>
		    <cfset tsk = qty>
		</cfif>		
				
		<cfquery name="AddLine" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      INSERT INTO RequestTask
			       (RequestId,
				    TaskType,
					TaskSerialNo,
					TaskQuantity,
					TaskUoM,
					TaskUoMQuantity,
					TaskCurrency,
					TaskPrice,		
					SourceWarehouse,
					SourceLocation,			
					ShipToWarehouse,
					ShipToLocation,
					ShipToDate,
					ShipToMode,					
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
			  VALUES
				  ('#URL.id#',
				    <cfif Line.SourceLocation eq ""> 
				   'Purchase',
				   <cfelse>
				   'Internal',
				   </cfif>
				   '#ser#',
				   '#qty#',
				   '#Line.TaskUoM#',
				   '#tsk#',
				   '#line.taskcurrency#',
				   '#line.TaskPrice#',   
				   <cfif Line.SourceWarehouse neq "">	
				   '#Line.SourceWarehouse#',
				   <cfelse>
				   NULL,
				   </cfif>
				   <cfif Line.SourceLocation neq "">				  
				  	 '#Line.SourceLocation#',
				   <cfelse>				  
				   	  NULL,
				   </cfif>
				   '#line.ShipToWarehouse#',
				   '#Line.ShipToLocation#',
				   '#line.ShipToDate#',
				   '#Line.ShipToMode#',				 	   
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#')    
		</cfquery>
						
		<script>		    
			ColdFusion.navigate('TaskViewItem.cfm?RequestId=#url.id#&serialno=#url.serialno#','taskorder')
		</script>
	
	</cfif>
	
</cfif>

</cfoutput>