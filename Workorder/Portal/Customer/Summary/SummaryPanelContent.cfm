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
<cfparam name="url.referenceDate" default="#dateFormat(now(),client.dateformatshow)#">

<cfquery name="WorkOrder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT    *
	FROM      WorkOrder W, ServiceItem S, Customer C
	WHERE     1=1 <!--- Customerid = '#url.customerid#' --->
	AND       W.ServiceItem = S.Code
	AND       W.CustomerId = C.CustomerId
	AND       W.WorkOrderId = '#url.workorderid#'
	AND       ActionStatus = '1'
	ORDER BY  C.CustomerName
</cfquery>	

<cfinvoke component     	= "Service.Process.WorkOrder.WorkOrderLineAction"  
	method           		= "getActions" 
	workOrderId      		= "#url.WorkOrderId#" 
	entryMode				= "Batch"
	getOnlyVisibleActions	= "1"
	date					= "#url.referenceDate#"
	returnvariable   		= "ActionsRandom">
	
<cfinvoke component     	= "Service.Process.WorkOrder.WorkOrderLineAction"  
	method           		= "getActions" 
	workOrderId      		= "#url.WorkOrderId#" 
	entryMode				= "Manual"
	getOnlyVisibleActions	= "0"
	date					= "#url.referenceDate#"
	returnvariable   		= "ActionsManual">		

<cfset color = "FAF9C0">
<cfset color = "">

<table width="100%" align="center">

<tr>
	<td width="100%" style="padding:5px" bgcolor="<cfoutput>#color#</cfoutput>">


<cfoutput>

	<table width="100%" cellspacing="2">
	
		<tr><td style="height:20;padding-left:5px" class="labelit" colspan="2">#workorder.OrderMemo#</b></td></tr>
		<tr><td colspan="2" class="line"></td></tr>		
		<tr><td colspan="2" height="100%">
		
			<table width="90%" height="100%" border="0" cellspacing="0" align="center">		
			
				<tr height="20">
				    <td class="labelit" width="50%">Activity</td>				   
					<td class="labelit" align="center" width="15%">
					<img src="#session.root#/images/Pending.gif" alt="" border="0">
					</td>
					<td class="labelit" align="center" width="15%">
					<img src="#session.root#/images/Check.gif" alt="" border="0">
					</td>
					<td class="labelit" align="center" width="20%">Total</td>
				</tr>
				
				<!--- ------------------------------------------------------------------ --->
				<!--- ------------------------PLANNED ACTIONS--------------------------- --->
				<!--- ------------------------------------------------------------------ --->
				
				<tr>
					<td style="height:20;padding-left:4px" colspan="4" class="line labelmedium"><b>Sample Actions</td>					
				</tr>
				
															
				<cfquery name="List" dbtype="query">
				    SELECT   ActionClass, ActionDescription, count(*) as Total
					FROM     ActionsRandom
					GROUP BY ActionClass, ActionDescription, ActionListingOrder
					ORDER BY ActionListingOrder
				</cfquery>	
				
				<cfif list.recordcount eq "0">
				
				<tr><td colspan="4" align="center" class="line labelit">None</td></tr>
				
				<cfelse>
				
					<cfloop query="list">
					
						<tr>
							<td style="padding-left:14px" class="line labelit">#ActionDescription#</td>
		
							<cfquery name="Pending" dbtype="query">
								    SELECT   count(*) as Total
									FROM     ActionsRandom
									WHERE    ActionClass = '#ActionClass#'					
									AND      Completed != 1
							</cfquery>						
												
							<td class="labelmedium line" align="center"><cfif Pending.total eq "">0<cfelse><font color="red">#Pending.total#</cfif></td>
							
							<cfquery name="Completed" dbtype="query">
								    SELECT   count(*) as Total
									FROM     ActionsRandom
									WHERE    ActionClass = '#ActionClass#'					
									AND      Completed = 1
							</cfquery>	
							
							<td class="labelmedium line" align="center"><b><font color="008000"><cfif completed.total eq "">0<cfelse>#Completed.Total#</cfif></font></td>										
							<td class="labelmedium line" align="center"><b>#Total#</td>
							
						</tr>				
					
					</cfloop>
				
				</cfif>
				
								
				<!--- ------------------------------------------------------------------ --->
				<!--- ------------------------MANUAL ACTIONS---------------------------- --->
				<!--- ------------------------------------------------------------------ --->
				
				<tr>
					<td style="height:20;padding-left:4px" colspan="4" class="line labelmedium"><b>Requested</td>					
				</tr>
				
				<cfquery name="List" dbtype="query">
				    SELECT   ActionClass, ActionDescription, count(*) as Total
					FROM     ActionsManual
					GROUP BY ActionClass, ActionDescription, ActionListingOrder
					ORDER BY ActionListingOrder
				</cfquery>	
												
				<cfif list.recordcount eq "0">
				
				<tr><td colspan="4" align="center" class="line labelit">None</td></tr>
				
				<cfelse>
				
					<cfloop query="list">
					
						<tr>
							<td style="padding-left:14px" class="line labelit">#ActionDescription#</td>
		
							<cfquery name="Pending" dbtype="query">
								    SELECT   count(*) as Total
									FROM     ActionsManual
									WHERE    ActionClass = '#ActionClass#'					
									AND      Completed != 1
							</cfquery>						
												
							<td class="labelmedium line" align="center"><cfif Pending.total eq "">0<cfelse><font color="red">#Pending.total#</cfif></td>
							
							<cfquery name="Completed" dbtype="query">
								    SELECT   count(*) as Total
									FROM     ActionsManual
									WHERE    ActionClass = '#ActionClass#'					
									AND      Completed = 1
							</cfquery>
							
							<cfset vCompletedTotal = 0>
							<cfif Completed.recordCount gt 0>
								<cfset vCompletedTotal = Completed.Total>
							</cfif>
							
							<td class="labelmedium line" align="center"><b><font color="008000">#vCompletedTotal#</font></td>										
							<td class="labelmedium line" align="center"><b>#Total#</td>
							
						</tr>				
					
					</cfloop>
				
				</cfif>		
					
			
			</table>
			
			</td>
		</tr>
		
	</table>

</cfoutput>

</td></tr></table>

