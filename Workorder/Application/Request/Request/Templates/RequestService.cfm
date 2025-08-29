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
<cfset url.date   = "#dateformat(now(),CLIENT.DateFormatShow)#">
<cfparam name     = "url.workorderlineid" default="">
<cfparam name     = "url.param" default="">

<cfif url.requestid eq "" and url.workorderlineid neq "">

	 <cfquery name="Billing" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     WorkOrderLine WL INNER JOIN
	             WorkOrderLineBilling WLB ON WL.WorkOrderId = WLB.WorkOrderId AND WL.WorkOrderLine = WLB.WorkOrderLine
		WHERE    WorkOrderLineId = '#url.workorderlineid#'
		ORDER BY BillingEffective DESC
	</cfquery>	
		
	<cfif billing.recordcount eq "1">
			
		<cfset url.workorderid   = billing.workorderid>
		<cfset url.workorderline = billing.workorderline>		
		<cfset url.mode        = "workorder">
	
	<cfelse>
	
		<cfset url.mode        = "request">
	
	</cfif>

<cfelse>

	<cfset url.mode        = "request">

</cfif>

<table width="100%" cellspacing="0" cellpadding="0" align="center">

<tr><td>

	<table width="100%" cellspacing="0" cellpadding="0" align="center">
		
		 <!--- record the envisioned user --->
		 
		 <cfquery name="ServiceItem" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     ServiceItem
			WHERE    Code = '#url.serviceitem#'				
		</cfquery>	
		
		<cfif url.requestaction eq "">
		
			 <cfquery name="RequestType" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     Ref_RequestWorkflow
				WHERE    RequestType   = '#url.requestType#'		
				AND      ServiceDomain = '#serviceitem.servicedomain#'			
				AND      Operational = 1	
			</cfquery>	
			
		<cfelse>	
		
			 <cfquery name="RequestType" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_RequestWorkflow
				WHERE    RequestType   = '#url.requestType#'		
				AND      ServiceDomain = '#serviceitem.servicedomain#'		
				AND      RequestAction = '#url.requestaction#'
			</cfquery>	
		
		</cfif>
		
		<cfif RequestType.isAmendment eq "0">
		
		<tr>
			<td height="#ht#" width="5%" class="labelmedium">Assign&nbsp;Service&nbsp;to:</td>
			<td height="#ht#" width="95%">
												
				<cfset link = "getPerson.cfm?requestid=#url.requestid#&field=PersonNoUser">	
				
				<table cellspacing="0" cellpadding="0" width="100%">
					<tr>
					
					<cfif accessmode eq "Edit">
					
						<td width="20">
							
						   <cf_selectlookup
							    box        = "beneficiary"
								link       = "#link#"
								button     = "Yes"
								close      = "Yes"						
								icon       = "contract.gif"
								iconheight = "17"
								iconwidth  = "17"
								class      = "employee"
								des1       = "PersonNo">
								
						</td>	
						<td width="2"></td>		
						<td width="99%" class="labellarge"><cfdiv bind="url:#link#" id="beneficiary"/>					
						</td>
						
					<cfelse>
					
						<td class="labellarge">
						
							<cfquery name="Request" 
							datasource="AppsWorkorder" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   Request
								WHERE  RequestId = '#url.requestid#'	
							</cfquery>			
						
							<cfquery name="Person" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   Person
								WHERE  PersonNo = '#Request.PersonNoUser#'	
							</cfquery>	
							
							<cfoutput>				
							
							<a href="javascript:EditPerson('#Person.PersonNo#')">
							<font color="6688aa">#Person.FirstName#&nbsp;#Person.LastName#</font>
							</a>
							
							</cfoutput>
										
						</td>
									
					</cfif>			
					
					</tr>
				</table>
				
			</td>
		
		</tr>	
		
		</cfif>
		
		<!--- -------------------------------- ---> 
		<!--- request a service name/reference --->
		<!--- -------------------------------- ---> 
		
		<cfif RequestType.isAmendment eq "0" 
		  and RequestType.PointerReference eq "1">
		  	
		 <cfquery name="Serviceitem" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Serviceitem
			WHERE    Code = '#url.serviceitem#'		
		</cfquery>	
		
		 <cfquery name="Domain" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_ServiceitemDomain
			WHERE    Code = '#serviceitem.servicedomain#'			
		</cfquery>	
			
		<cfoutput>
		
		<tr><td height="2"></td></tr>
		
		<tr>
		
		  <td heighty="20" width="100">#Domain.Description# <font color="FF0000">*</font>:</td>
		  
		  <td>
		  
		  <table cellspacing="0" cellpadding="0"><tr><td>
		  
		   <cfquery name="Request" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     Request
			WHERE	<cfif url.requestid eq "">1=0<cfelse>Requestid = '#url.requestid#'</cfif>		
		   </cfquery>	
		   
		   <cfif domain.displayformat eq "">
		   	<cfset max = "20">
		   <cfelse>
		    <cfset val = replaceNoCase(domain.displayformat,"-","","ALL")> 
		    <cfset max = "#len(val)#">
		   </cfif>		
		   
			<input type  = "Text"
		       name      = "DomainReference" 
			   id        = "DomainReference"
		       required  = "Yes"           
		       size      = "#max#"
			   style     = "text-align:center;font:12px"
			   message   = "You must define a #Domain.Description# item #Domain.Description#"
			   value     = "#Request.domainreference#"
		       maxlength = "#max#">	
			   
			   </td>
			   <td>&nbsp;</td>
			   <td>			  		 
			   
			   <cfif url.requestid eq "">
			   	   <cfdiv bind="url:../Templates/ValidateReference.cfm?scope=#url.scope#&mission=#url.mission#&requestid=#url.requestid#&domain=#serviceitem.servicedomain#&reference={DomainReference}">  		   			
			   <cfelse>
				   <cfdiv bind="url:../Templates/ValidateReference.cfm?scope=#url.scope#&mission=#url.mission#&requestid=#url.requestid#&domain=#serviceitem.servicedomain#&reference={DomainReference}">  		   
			   </cfif>	   
			   
			  </td>
			  </tr>			   
			  
			 </table>	  
			      
		  </td>
		
		</tr>
		</cfoutput>	
		
		</cfif>
		
		<tr><td height="6"></td></tr>
		<tr>
		  <td colspan="2" align="center">
		  <cfinclude template="../../../WorkOrder/ServiceDetails/Billing/DetailBillingFormEntry.cfm">
		  </td>
	    </tr>
			
		<cfif url.param eq "hideasset">
		
			<cfset client.itemselect = "">
		
		<cfelseif RequestType.isAmendment eq "0">
					
			<tr><td colspan="2"><cfinclude template="RequestDevice.cfm"></td></tr>  
		
		 </cfif>
		  
	</table>

</td></tr>

<tr><td height="3"></td></tr>

</table>

