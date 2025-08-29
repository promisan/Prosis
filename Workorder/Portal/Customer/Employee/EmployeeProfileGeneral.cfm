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
<cfparam name="session.selectworkorderid" default="">

<!--- ---------------------------------------------------------- --->
<!--- we check if the person has potential access to this screen --->
<!--- ---------------------------------------------------------- --->

<cfquery name="Roles" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT    Role
	FROM      Ref_AuthorizationRole
	WHERE     SystemModule = 'workorder'	
</cfquery>

<!--- make a list of workorders to which this user has access --->

<cfinvoke  component = "Service.Access"  
    method           = "WorkorderAccessList" 
	mission          = "#url.mission#" 	  
	Role             = "#QuotedvalueList(roles.Role)#"
	returnvariable   = "AccessList">
		
<!--- ---------------------------------------------------------- --->
<!--- ------------------END OF ROLE DEFINITION------------------ --->
<!--- ---------------------------------------------------------- --->



<cfif accessList eq "">

	<table><tr><td align="center" class="labelit">You do not have access to this function</td></tr></table>

<cfelse>	
		   
	<cf_PortalDefaultValue 
			portalId  = "#url.id#" 
			key       = "WorkOrder"
			ResultVar = "defaultWO">	
	
	<cfif session.selectworkorderid neq "">
			
		<cfquery name="selCustomer" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
				SELECT 	CustomerId
				FROM	WorkOrder
				WHERE	WorkOrderId = '#session.selectworkorderid#'
				<!--- has access --->
				AND     WorkOrderId IN (#preserveSingleQuotes(AccessList)#)
		</cfquery>
		
		<cfif selcustomer.recordcount eq "0">
		
		   <cfquery name="selCustomer" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
				SELECT 	CustomerId
				FROM	WorkOrder
				WHERE	WorkOrderId IN (#preserveSingleQuotes(AccessList)#)
		   </cfquery>
				
		</cfif>
				
    <cfelse>
	
		  <cfquery name="selCustomer" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
				SELECT 	CustomerId
				FROM	WorkOrder
				WHERE	WorkOrderId IN (#preserveSingleQuotes(AccessList)#)
		   </cfquery>	
		
	</cfif>
	
	<cfoutput>
	
		<table cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" >
			<tr>
				<td style="padding-top:10px; padding-left:10px; padding-bottom:10px;padding-right:10px;" width="100%" height="100%">
					<table cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
			
						<tr>
							<td style="height:40px;padding-bottom:5px">
							
								<cf_PortalDefaultValue 
									portalId  = "#url.id#" 
									key       = "Date" 
									ResultVar = "defaultDate">
									
								<cfif defaultDate eq "">
									<cfset defaultDate = now()>
								</cfif>
								
								<cf_monthPicker 
									id="monthPicker"
									defaultYear = "#year(defaultDate)#"
									defaultMonth = "#month(defaultDate)#" 
									onSelect="selectEmployeeCriteria();">
								
								<input type="hidden" name="default_year" id="default_year" value="#year(defaultDate)#">	
								<input type="hidden" name="default_month" id="default_month" value="#month(defaultDate)#">
							</td>
						</tr>
						
						<!--- we allow selection of only customers to which we have access --->
														
						<cfquery name="customer" 
							datasource="appsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#"> 
								SELECT 	 *
								FROM	 Customer
								WHERE	 CustomerId IN (SELECT CustomerId 
								                        FROM   Workorder
														WHERE  WorkOrderId IN (#preserveSingleQuotes(AccessList)#))	
								ORDER BY CustomerName
						</cfquery>
						
						<cfif customer.recordcount eq "1">
						
							<input type="hidden" name="customer" id = "customer" value="#customer.customerid#">
						
						<cfelse>
						
							<tr>
								<td>										
													    								
									<select name = "customer" 
										id       = "customer"
										class    = "regularxl" 
										style    = "width:100%;font-size:21px;height:31px" 
										onchange = "selectEmployeeCriteria();">
										<cfloop query="customer">
											<option value="#CustomerId#" <cfif selCustomer.CustomerId eq customerId>selected</cfif>> #CustomerName# 
										</cfloop>								
									</select>														
									
								</td>
							</tr>
						
						</cfif>
						
						<tr>
							<td height="100%">
								<cfdiv style="height:100%;min-height:100%;" id="divEmployeeList"/> 								
							</td>
						</tr>
					</table>	
				</td>
			</tr>	
		</table>
		
	</cfoutput>

</cfif>

<script>
	Prosis.busy('no')
</script>