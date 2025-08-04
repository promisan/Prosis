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

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrder
	 WHERE   WorkOrderId     = '#url.workorderid#'		 
</cfquery>

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ParameterMission
	 WHERE   Mission         = '#workorder.mission#'		
</cfquery>

<cfquery name="Line" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderLine
	 WHERE   WorkOrderId     = '#url.workorderid#'	
	 AND     WorkOrderLine   = '#url.workorderline#'
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

	<cfform name="transfer_form">		
		
		<tr><td colspan="2">

		    <cfquery name="Detail" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT   WO.*, 
				         P.IndexNo AS IndexNo, 
						 P.LastName AS LastName, 
						 P.FirstName AS FirstName,
						 P.Nationality,
						 P.Gender				
						 
			     FROM    WorkOrderLine WO LEFT OUTER JOIN
				         Employee.dbo.Person P ON WO.PersonNo = P.PersonNo
						 
				 WHERE   WO.WorkOrderId     = '#url.workorderid#'
				 AND     WO.WorkorderLine   = '#url.workorderline#'
				 
			</cfquery>
			
			<table width="100%" cellspacing="2" cellpadding="2">
			
					<cfoutput query="detail">
						<TR>		   				  
							<td>Id:</td><td width="20%"><b><font size="3">#reference#</font></td>
							<td width="60"><cf_tl id="Effective">:</td><td width="10%"><b>#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
							<td width="60"><cf_tl id="Expiration">:</td><td width="10%">
							<cfif dateexpiration neq ""><b>#dateformat(DateExpiration,CLIENT.DateFormatShow)#<cfelse><cf_tl id="undefined"></cfif></td>
							<td><cf_tl id="Assigned"></td>
							<td width="25%"><a href="javascript:EditPerson('#PersonNo#')"><font color="0080C0"><b>#FirstName# #LastName#</b></font></a></td>
							<td>#Nationality#</td>
							<td>#IndexNo#</td>
							<td>
							<!--- --------------- --->
							<!--- asset item show --->
							<!--- --------------- --->
							</td>	 								   
						</TR>	
					</cfoutput>	
					
			</table>
		
		</td>
		</tr>
		
		<cfoutput>
						
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr><td class="labelmedium"><cf_tl id="Effective">:</td>
		    <td>
												 
			  <cf_intelliCalendarDate9
						FieldName="dateeffective" 
						class="regularxl"										
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#"		
						AllowBlank="False">	
		
		</td></tr>
				
		<tr><td class="labelmedium"><cf_tl id="Customer">:</td>
		    
			<td>
												
				<cfset link = "ServiceLineCustomer.cfm?workorderid=#URL.workorderid#&workorderline=#url.workorderline#">	
				
				<table cellspacing="0" cellpadding="0" width="96%">
					<tr>
					
					<td width="20">
						
					   <cf_selectlookup
					    box          = "customer"
						link         = "#link#"
						Title        = "Customer"
						button       = "Yes"
						close        = "Yes"		
						filter1      = "Mission"
						filter1value = "#Parameter.TreeCustomer#"						
						filter2value = "#Workorder.ServiceItem#"
						icon         = "contract.gif"
						class        = "customer"
						des1         = "Customerid">
							
					</td>	
					<td width="2"></td>				
					<td style="height:25px" width="99%"><cfdiv bind="url:#link#" id="customer"/></td>
										
					</tr>
				</table>
				
			</td>	
					
		</tr>
				
		<tr><td class="labelmedium"><cf_tl id="Person">:</td>
		    
			<td>
												
				<cfset link = "ServiceLinePerson.cfm?workorderline=#url.workorderline#&workorderid=#URL.workorderid#">	
				
				<table cellspacing="0" cellpadding="0" width="96%">
					<tr>
					<td width="20">
						
					   <cf_selectlookup
					    box        = "employee"
						link       = "#link#"
						button     = "Yes"
						close      = "Yes"						
						icon       = "contract.gif"
						class      = "employee"
						des1       = "PersonNo">
							
					</td>	
					<td width="2"></td>				
					<td width="99%"><cfdiv bind="url:#link#" id="employee"/></td>
					</tr>
				</table>
				
			</td>	
					
		</tr>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr><td colspan="2" id="processtransfer"></td></tr>					
		
		<tr><td align="center" colspan="2">
		
		   <table><tr><td>
		
			<input type="button" 
			       name="Back" 
                   id="Back"
				   Value="Back"
				   class="button10g" 
				   style="width:100;height:25"
				   onclick="ColdFusion.navigate('ServiceLineForm.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&mode=view','custom')")>
				   
			</td>
				   
		    <td>
				
			<input type="button" 
			       name="Edit" 
                   id="Edit"
				   Value="Transfer"
				   class="button10g" 
				   style="width:100;height:25"
				   onclick="ColdFusion.navigate('ServiceLineTransferSubmit.cfm?tabno=#url.tabno#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&mode=save','processtransfer','','','POST','transfer_form')")>
				   
				   </td></tr>
				   
		   </table>
		
		</td></tr>
		
		</cfoutput>
					
	</cfform>
	
	<cfset ajaxonload("doCalendar")>