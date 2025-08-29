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
<cfoutput>

<cfparam name="url.ServiceItem"  default="">

<table width="100%" cellspacing="0" cellpadding="0" align="right" bgcolor="c4e1ff">

		<cfquery name="getUsageLabel"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#"> 						  
			  SELECT   TOP 1 ISNULL(LabelCurrency,'$') as LabelCurrency				
			  FROM     ServiceItemUnit L INNER JOIN
					   Ref_UnitClass C ON L.UnitClass = C.Code	 	  	  
			  WHERE    ServiceItem = '#url.ServiceItem#'			
		</cfquery>		
   		
		<cfquery name="getAction"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#"> 		
			
			SELECT TOP 1 UsageActionClose
			FROM   ServiceItem 
			WHERE  UsageActionClose IS NOT NULL
			
			<cfif url.serviceItem neq "">
				AND Code = '#url.serviceitem#'
			</cfif>
		   
		</cfquery>	
			
	    <!--- ----------------approval portion------------------ --->
	    <!--- --this is charges table to be sent to the ledger-- --->
		<!--- -------------------------------------------------- --->
				
		<cfquery name="Submitted"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		   
				SELECT SUM(D.Amount) as Amount
				FROM   WorkOrderLine WL 
					   INNER JOIN WorkOrderLineDetail D ON WL.WorkOrderId = D.WorkOrderId AND WL.WorkOrderLine = D.WorkOrderLine
					 
					   INNER JOIN WorkOrderLineDetailCharge C 
									ON C.WorkOrderId      = D.WorkOrderId
									AND	C.WorkOrderLine   = D.WorkOrderLine
									AND C.ServiceItem     = D.ServiceItem
									AND C.ServiceItemUnit = D.ServiceItemUnit
									AND C.TransactionDate = D.TransactionDate
									AND C.Reference       = D.Reference
						
				WHERE WL.PersonNo = '#client.personno#'	

				<cfif url.serviceItem neq "">
   				AND   WL.WorkOrderId IN (SELECT WorkorderId 
		                     FROM   WorkOrder 
						     WHERE  ServiceItem = '#url.serviceitem#')				
				</cfif>
				
				AND   D.ServiceUsageSerialNo > (
				
						  SELECT ISNULL(MAX(SerialNo),0)
						  FROM   WorkOrderLineAction A 
						  WHERE  D.WorkOrderId   = A.WorkOrderId 
						  AND    D.WorkOrderLine = A.WorkOrderLine 						  
						  AND    A.DateTimePlanning < '01/01/#year(now())#'
						  AND    A.ActionStatus  != '9'
						  AND    A.ActionClass   = '#getAction.UsageActionClose#'							 
							)
						  
						  
				AND   D.ServiceUsageSerialNo <= (
				
						 SELECT ISNULL(MAX(SerialNo),0)
						  FROM   WorkOrderLineAction A 
						  WHERE  D.WorkOrderId   = A.WorkOrderId 
						  AND    D.WorkOrderLine = A.WorkOrderLine 						  					 
						  AND    A.ActionStatus  != '9'
						  AND    A.ActionClass   = '#getAction.UsageActionClose#'							 
						 )

				AND   C.Charged = '2'
				AND   WL.Operational = 1
				AND   D.ActionStatus != '9'
								
		</cfquery>
		
		<!---		
		<cfoutput>
			#cfquery.executiontime#
		</cfoutput>
		--->
		
		<cfparam name="submitted.amount" default="0">
	
		<cfquery name="Charged"
		   datasource="AppsPayroll"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		   SELECT  isnull(SUM(Amount),0) AS Amount
		   FROM    PersonMiscellaneous	   
		   WHERE   PersonNo = '#client.personno#'	
		   <cfif url.serviceItem neq "">
		   AND     PayrollItem IN ( SELECT TOP 1 PayrollItem
					                FROM   WorkOrder.dbo.ServiceItemUnit 
						            WHERE  ServiceItem = '#url.serviceitem#')
		   </cfif>							
		   AND     DateEffective >= '01/01/#year(now())#'	  	  
		</cfquery>				
		
		<tr>	
		   <td colspan="2">
		   		<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
					<tr>
					   <td height="18" id="itmyear" name="itmyear">
							<table cellpadding="0" cellspacing="0" width="100%">
								<tr>									
									<td width="70%" class="labelmedium">Approvals submitted in <b>#year(now())#</b>:</td>
									<td align="right" class="labelmedium" style="padding-right:4px"><font color="gray">#getUsageLabel.LabelCurrency# #numberformat(Submitted.Amount,"__,__.__")#</font></b></td>
								</tr>	
								<!---	
								<tr>									
									<td width="70%" class="labelit">Charged in <b>#year(now())#</b>:</td>
									<td align="right" class="labelit" style="padding-right:4px"><font color="gray">#getUsageLabel.LabelCurrency# #numberformat(Charged.Amount,"__,__.__")#</font></b></td>
								</tr>
								--->	
															
							</table>					   
					   
					   </td>
					   					
					</tr>
				</table>
		   </td>					
		</tr>
		
		<tr><td height="3"></td></tr>
					
		<cfquery name="PostingPrior"
		   datasource="AppsWorkOrder"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">

			SELECT    Month(DateEffective) as MonthTransaction, 
			          SUM(Amount) as Amount
			FROM      Payroll.dbo.PersonMiscellaneous 
			WHERE     PersonNo = '#client.personno#'
			<cfif url.serviceItem neq "">
			AND       PayrollItem IN ( SELECT TOP 1 PayrollItem
					  	               FROM   ServiceItemUnit 
						               WHERE  ServiceItem = '#url.serviceitem#')
		    </cfif>							   
									   
			AND       DateEffective >= '01/01/#year(now())#'						
			GROUP BY  Month(DateEffective) 
			ORDER BY  Month(DateEffective) 
					   
		</cfquery>	
		
		 <tr>		
			<td colspan="2" id="detailyear" name="detailyear">		
				<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">		
								
						<cfloop query="PostingPrior">
							<tr>				
			  						<td class="labelmedium" style="padding-left:20px"><font color="808080">#DateFormat(CreateDate(Year(Now()),MonthTransaction,1),"mmmm")#</td>
			  						<td class="labelmedium" align="right" style="padding-right:15px"><font color="gray">#getUsageLabel.LabelCurrency# #numberformat(Amount,"__,__.__")#</font></b></td>					
							</tr>
						</cfloop>						
				</table>
			</td>
		</tr>		  
						
		<tr><td colspan="2" style="border-top:1px dotted silver"></td></tr>
		
		<tr>
		<td colspan="2" id="applystatus">
			<cfinclude template="ChargesUsageDetailApprovalApplied.cfm">		
		</td>
		</tr>
				
</table>

</cfoutput>