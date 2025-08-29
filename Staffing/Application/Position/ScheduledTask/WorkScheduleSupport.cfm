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
<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Position
		WHERE PositionNo = '#URL.PositionNo#'
	</cfquery>
					
	<cfquery name="WorkOrder" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    C.CustomerName, 
		          W.WorkOrderId, 
				  W.Reference, 
				  W.OrderDate, 
				  W.OrderMemo, 
				  R.Description,
				  (SELECT PositionNo 
				   FROM Employee.dbo.PositionWorkorder
				   WHERE PositionNo = '#URL.PositionNo#'
				   AND   WorkOrderId = W.WorkOrderId) as Selected
				   
		FROM      WorkOrder W INNER JOIN
	              Customer C ON W.CustomerId = C.CustomerId INNER JOIN
	              ServiceItem R ON W.ServiceItem = R.Code
		WHERE     W.Mission     = '#Position.Mission#' 
		AND       R.ServiceMode = 'Service'
		AND       W.WorkOrderId IN
	                    (SELECT   WorkOrderId
	                     FROM     WorkOrderImplementer
	                     WHERE    OrgUnit = '#Position.OrgUnitOperational#')
		AND       W.ActionStatus IN ('0','1')				 
	</cfquery>	
	
	<cfif workorder.recordcount gte "1">
	
		<form name="workorderform">
	
		<table width="100%" cellspacing="0" cellpadding="0">
		
		<tr class="hide"><td id="workorderbox"></td></tr>
		
		<tr>
		   <td class="labelit">Customer</td>	
		   <td class="labelit">WorkOrder</td>
		   <td class="labelit">Date</td>		  
		   <td class="labelit">Service</td>
		   <td class="labelit">Ena</td>
		   <td width="40%" class="labelit">Duties</td>
		</tr>   
		
		<tr><td colspan="6" class="linedotted"></td></tr>
		
			<cfoutput query="workorder">
			
			<tr>
			   <td valign="top" class="labelit">#customername#</td>
			   <td valign="top" class="labelit">#Reference#</td>
			   <td valign="top" class="labelit">#dateformat(OrderDate,client.dateformatshow)#</td>		  
			   <td valign="top" class="labelit">#Description#</td>
			   <td valign="top" class="labelit">
			       <input onclick="ColdFusion.navigate('#session.root#/Staffing/Application/Position/ScheduledTask/WorkScheduleSubmit.cfm?positionno=#url.positionno#&workorderid=#workorderid#','workorderbox','','','POST','workorderform')" 
			        type="checkbox" 
					class="radiol"
					id="workorderid_#left(workorderid,8)#" 
					name="workorderid_#left(workorderid,8)#" 
					value="#workorderid#" <cfif selected neq "">checked</cfif>>
					
				</td>
			   
			   <cfif selected neq "">
			   
				   <cfquery name="get" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT * FROM PositionWorkOrder
					   WHERE  PositionNo = '#URL.PositionNo#'
					   AND    WorkOrderId = '#workorderid#'
				   </cfquery>
			
			     <td valign="top">				 
				 		  <textarea onchange="ColdFusion.navigate('#session.root#/Staffing/Application/Position/ScheduledTask/WorkScheduleSubmit.cfm?positionno=#url.positionno#&workorderid=#workorderid#','workorderbox','','','POST','workorderform')"  id="workordermemo_#left(workorderid,8)#"
					name="workordermemo_#left(workorderid,8)#"  class="regular" totlength="500" style="padding:3px;font-size:12px;width:98%;height:47" onkeyup="return ismaxlength(this)">#get.Memo#</textarea>
						   
			   <cfelse>
			   
			     <td valign="top">
				 
				  <textarea onchange="ColdFusion.navigate('#session.root#/Staffing/Application/Position/ScheduledTask/WorkScheduleSubmit.cfm?positionno=#url.positionno#&workorderid=#workorderid#','workorderbox','','','POST','workorderform')"  id="workordermemo_#left(workorderid,8)#"
					name="workordermemo_#left(workorderid,8)#"  class="hide" totlength="500" style="padding:3px;font-size:12px;width:98%;height:47" onkeyup="return ismaxlength(this)"></textarea>
			
				</td>		  
			   
			   </cfif>
			   
			 </tr>			
			
			</cfoutput>
		
		</table>
		
		</form>
	
	</cfif>