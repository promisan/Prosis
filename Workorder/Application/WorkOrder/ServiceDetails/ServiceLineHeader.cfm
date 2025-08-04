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

<cfparam name="url.mode" default="view">
<cfparam name="form.personno" default="">
<cfparam name="form.assetid"  default="">

<cfquery name="Line" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderLine
	 WHERE   WorkOrderId     = '#url.workorderid#'	
	 AND     WorkOrderLine   = '#url.workorderline#'
</cfquery>

<cfquery name="DomainClass" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT   *					 
     FROM    Ref_ServiceItemDomainClass			 
	 WHERE   ServiceDomain   = '#Line.ServiceDomain#'
	 AND     Code            = '#Line.ServiceDomainClass#'		
</cfquery>

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId     = '#url.workorderid#'		
</cfquery>

<cfquery name="Item" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    ServiceItem
	 WHERE   Code   = '#workorder.serviceitem#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#item.servicedomain#'	
</cfquery>

<cfset prior = "">

<table width="100%">
			
		<tr><td colspan="2" style="padding:1px">
		
		<table width="100%" class="formpadding" style="background-color:f1f1f1">
		
				<TR class="labelmedium2">		   				  
							
					<td style="border:1px solid silver;padding-left:4px" height="18"><cf_tl id="Provider"></td>	
			        <td style="min-width:200px;border:1px solid silver;padding-left:4px" colspan="2"> <cf_tl id="Class"> </td>	
							
							
							<cfif item.enablePerson eq 1>
								<td style="border:1px solid silver;padding-left:4px" colspan="2"  width="20%"> <cf_tl id="Individual"></td>
							</cfif>
							
					<td style="border:1px solid silver;padding-left:4px"><cf_tl id="Effective"></td>
					<td style="border:1px solid silver;padding-left:4px"><cf_tl id="Expiration"></td>
							
					</TR>	
							
				<!--- current --->
				
				<cfquery name="Detail" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					SELECT   WO.*, 
					         P.IndexNo AS IndexNo, 
							 P.LastName AS LastName, 
							 P.FirstName AS FirstName,
							 P.Nationality,
							 P.Gender,
							 WS.Description				
							 
				     FROM    WorkOrderLine WO LEFT OUTER JOIN
					         Employee.dbo.Person P ON WO.PersonNo = P.PersonNo INNER JOIN
							 WorkOrderService WS ON WO.ServiceDomain = WS.ServiceDomain and WO.Reference = WS.Reference
							 
					 WHERE   WO.WorkOrderId     = '#url.workorderid#'
					 AND     WO.WorkorderLine   = '#url.workorderline#'
					 
				</cfquery>
				
				<cfif detail.ParentWorkOrderid neq "">
		
					 <cfquery name="Parent" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
								
						SELECT   WO.*, 
							    (SELECT CustomerName 
								  FROM Customer 
								  WHERE CustomerId = W.CustomerId) as CustomerName,
						         P.IndexNo AS IndexNo, 
								 P.LastName AS LastName, 
								 P.FirstName AS FirstName,
								 P.Nationality,
								 P.Gender										 
					     FROM    WorkOrder W 
					             INNER JOIN WorkOrderLine WO ON W.WorkOrderId = WO.WorkOrderId
					 	 	     LEFT OUTER JOIN Employee.dbo.Person P ON WO.PersonNo = P.PersonNo								 
						 WHERE   WO.WorkOrderId   = '#Detail.ParentWorkOrderId#'
						 AND     WO.WorkorderLine = '#Detail.ParentWorkOrderLine#'						
				 
					</cfquery>
										
					<cfoutput query="parent">
					
						<cfquery name="Workorder" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
				
							SELECT   P.Code,P.Description							 
						     FROM    WorkOrder WO INNER JOIN Serviceitem P ON WO.ServiceItem = P.Code							 
							 WHERE   WO.workorderid  = '#Parent.workorderid#'			 
						</cfquery>
										
					    <TR bgcolor="e4e4e4" class="labelmedium2">		   				  
							
							<td style="border:1px solid silver;padding-left:4px">
								<a href="javascript:editworkorderline('#workorderlineid#')">#CustomerName#</a>							
							</td>													
													
							<td colspan="2" style="min-width:300px;border:1px solid silver;padding-left:4px">
							<cfif domainclass.recordcount eq "1">
							#DomainClass.Description# [#DomainClass.PointerSale#|#DomainClass.PointerStock#]
							<cfelse>
							#Domain.Description#
							</cfif>
							</td>		
							
							
							<cfif item.enablePerson eq 1>																			
								<td width="20%" colspan="2" style="padding-left:4px">
								<table><tr><td class="labelit">
								<a href="javascript:EditPerson('#PersonNo#')">#FirstName# #LastName#</a>
								</td></tr>
								</table>
								</td>
							</cfif>																							
													
							<td width="10%" align="center" width="10%" style="border:1px solid silver;padding-left:4px">
							<cfif prior neq "" and prior gte DateEffective>
							<font color="FF0000">
							</cfif>
							#dateformat(DateEffective,CLIENT.DateFormatShow)#
							</td>							
							<td align="center" width="10%" style="border:1px solid silver;padding-left:4px" width="10%"><cfif dateexpiration neq "">#dateformat(DateExpiration,CLIENT.DateFormatShow)#<cfelse><cf_tl id="undefined"></cfif></td>
																														   
						</TR>	
												
						<cfset prior = parent.dateExpiration>
						
					</cfoutput>
				
				</cfif>				
						
				<cfoutput query="detail">
				
					<tr  class="line labelmedium">	
					
						<td width="10%" style="border:1px solid silver;padding-left:4px">
						
						   <cfquery name="customer" 
							datasource="AppsWorkOrder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">							
								SELECT   *											 
							    FROM    Customer
								WHERE   Customerid IN (SELECT CustomerId FROM Workorder WHERE WorkOrderId = '#workorderid#')												 
						   </cfquery>
							#customer.customername#
						
						</td>								
					    <td width="15%" style="min-width:300px;border:1px solid silver;padding-left:4px;background-color:ffffaf">					
						
							<table>
							<tr class="labelmedium2"> 							
							<td  style="min-width:200px;padding-left:1px;font-size:15px">
							<cfif domainclass.recordcount eq "1">
							#DomainClass.Description#&nbsp;[#DomainClass.PointerSale#|#DomainClass.PointerStock#]
							<cfelse>
							#Domain.Description#
							</cfif>
							</td>										
							<td style="min-width:200px;padding-left:4px;font-size:15px">
							<cf_stringtoformat value="#reference#" format="#domain.DisplayFormat#">	
							<font color="black">:&nbsp;#val#</font>												
							</td>
							</tr>							
							</table>
						
						</td>
													
						<td width="10%" style="border:1px solid silver;padding-left:4px"><cfif Operational eq "0"><font color="FF0000"><cf_tl id="Deactivated"></font><cfelse>#source#</cfif></td>
																								
						<cfif item.enablePerson eq 1>
							<td width="20%" colspan="2" style="border:1px solid silver;padding-left:4px">
							<table width="100%" cellspacing="0" cellpadding="0">
							<tr class="labelmedium">   								
								<cfif PersonNo neq "">
								<td><a href="javascript:EditPerson('#PersonNo#')"><font color="0080C0">#FirstName# #LastName#</font></a></td>							
								
								<cfquery name="User" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM UserNames 
									WHERE PersonNo = '#personNo#'
								</cfquery>
								
								<cfif User.recordcount gte "1">								
									<td align="right" style="padding-right:4px">
									<img style="cursor:pointer;height:22px"
									 onclick="ShowUser('#user.account#')"
									 src="#session.root#/images/user2.png" alt="" border="0">
									</td>								
								</cfif>											
								
								<cfelse>	
								<cftry>		
								<td>#_name#</td>
								<cfcatch></cfcatch>
								</cftry>
								</cfif>
							</tr>
							</table>
							</td>	
						</cfif>	
						
						<td align="center" width="10%" style="border:1px solid silver;padding-left:4px">
						<cfif prior neq "" and prior gte DateEffective></cfif>
							#dateformat(DateEffective,CLIENT.DateFormatShow)#
						</td>
						
						<td align="center" width="10%" style="border:1px solid silver;padding-left:4px">
							<cfif dateexpiration neq "">#dateformat(DateExpiration,CLIENT.DateFormatShow)#<cfelse><cf_tl id="ongoing"></cfif>
						</td>		
																											   
						
					</TR>	
					
					<cfset prior = detail.dateExpiration>
					
				</cfoutput>	
				
				<!--- check if this line was transferred --->
				
				 <cfquery name="Children" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
		
					SELECT   WO.*, 
					         (SELECT CustomerName 
							  FROM Customer 
							  WHERE CustomerId = W.CustomerId) as CustomerName,
					         P.IndexNo AS IndexNo, 
							 P.LastName AS LastName, 
							 P.FirstName AS FirstName,
							 P.Nationality,
							 P.Gender				
							 
				     FROM    WorkOrder W 
					         INNER JOIN WorkOrderLine WO ON W.WorkOrderId = WO.WorkOrderId
					 		 LEFT OUTER JOIN Employee.dbo.Person P ON WO.PersonNo = P.PersonNo
							 
					 WHERE   WO.ParentWorkOrderId   = '#url.workorderid#'
					 AND     WO.ParentWorkorderLine = '#url.workorderline#'					
			 
				</cfquery>
				
				<cfif children.recordcount gte "1">
				
				<cfquery name="Workorder" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
		
					SELECT   P.Code,P.Description							 
				     FROM    WorkOrder WO INNER JOIN Serviceitem P ON WO.ServiceItem = P.Code							 
					 WHERE   WO.workorderid  = '#Children.workorderid#'			 
				</cfquery>
													
					<tr class="labelit"><td align="center" height="18" bgcolor="red" colspan="11"><font color="FFFFFF"><b>Attention</b>: The above line is not the active line anymore and was transferred to below</font></td></tr>			
													    
					<cfoutput query="children">
					   
						<tr bgcolor="80FF80" height="22" class="labelmedium line">		   				  
							<td colspan="2" style="border:1px solid silver;padding-left:4px">
							<a href="javascript:editworkorderline('#workorderlineid#')">
							#CustomerName#
							<!---
							<cfif item.code neq workorder.code>TO: <font size="2" color="gray">#WorkOrder.Description#<cfelse><font size="2" face="Calibri" color="gray"><i><img src="#SESSION.root#/images/join.gif" alt="" border="0"> #dateformat(created, CLIENT.DateFormatShow)#</cfif></font></a></b>
							--->
							</td>
							
							<td width="10%" style="border:1px solid silver;padding-left:4px"><cfif Operational eq "0"><font color="FF0000"><cf_tl id="Deactivated"></font><cfelse>#source#</cfif></td>
							
							<td colspan="2" style="border:1px solid silver;padding-left:4px">
							
							<cfif item.enablePerson eq 1>							
							
								<a href="javascript:EditPerson('#PersonNo#')"><font color="0080C0">#FirstName# #LastName#</font></a>
																
							</cfif>	
							
							</td>	
							
							<td align="center" style="border:1px solid silver;padding-left:4px">
							<cfif prior neq "" and prior gte DateEffective>
							<font color="FF0000">
							</cfif>
							#dateformat(DateEffective,CLIENT.DateFormatShow)#
							</td>
														
							<td align="center" style="border:1px solid silver;padding-left:4px"><cfif dateexpiration neq "">#dateformat(DateExpiration,CLIENT.DateFormatShow)#<cfelse><cf_tl id="undefined"></cfif></td>
																																		   
						</TR>	
						
						<cfset prior = children.dateExpiration>
						
					</cfoutput>	
					
				</cfif>					
				
		</table>
		
		</td></tr>		
			
</table>