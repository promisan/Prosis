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
<cfparam name="Form.TransactionReference"  default="">
<cfparam name="Form.TransactionMemo"       default="">
<cfparam name="Form.TransactionQuantity"   default="0">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset eff = dateValue>
	
<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE   WorkOrderBaseLine 
			  SET  TransactionReference = '#Form.TransactionReference#', 				 
				   DateEffective        = #Eff#,
				   TransactionMemo      = '#Form.TransactionMemo#',
				   TransactionQuantity  = '#Form.TransactionQuantity#',
				   TransactionAmount    = '#Form.TransactionAmount#'	 
			 WHERE WorkOrderId   = '#URL.WorkOrderId#' 
			 AND   TransactionId  = '#URL.ID2#'
	    </cfquery>		
		
		<!--- workflow --->
								
		<cfquery name="workorder" 
		datasource="appsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  WorkOrder
			WHERE WorkOrderId = '#URL.WorkOrderId#'
		</cfquery>		
		
		<cfquery name="serviceitem" 
		datasource="appsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  ServiceItem
			WHERE Code = '#workorder.serviceitem#'
		</cfquery>
			
		<cfset link = "WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#url.WorkOrderId#&selected=servicelevel">			
				
		<cf_ActionListing 
			    EntityCode       = "WrkAgreement"
				EntityClass      = "Standard"
				EntityGroup      = ""
				EntityStatus     = ""
				Mission          = "#workorder.mission#"				
				ObjectReference  = "#Form.TransactionReference#"
				ObjectReference2 = "#serviceitem.description#" 			    
				ObjectKey4       = "#url.id2#"
				AjaxId           = "#url.id2#"
				ObjectURL        = "#link#"
				Reset            = "Limited"
				Show             = "No">	
				
		<cfset url.id2 = "">			
		<cfinclude template="ServiceLine.cfm">	
			
<cfelse>

				
		<cfquery name="Insert" 
		     datasource="AppsWorkOrder" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO WorkOrderBaseLine 
		         (WorkOrderId,
				 TransactionId,
				 TransactionReference,				
				 TransactionMemo,
				 DateEffective,				
				 TransactionQuantity,
				 TransactionAmount,
				 OfficerUserId,
				 OfficerLastname,
				 OfficerFirstName,
				 Created)
		      VALUES
			     ('#URL.WorkOrderId#',
			      '#form.TransactionId#',
				  '#Form.TransactionReference#',
				  '#Form.TransactionMemo#',				 
				  #eff#,								
				  '#Form.TransactionQuantity#',
				  '#Form.TransactionAmount#',	
		      	  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#',
				  getDate())
			</cfquery>
			
			<!--- workflow --->
								
			<cfquery name="workorder" 
			datasource="appsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  WorkOrder
				WHERE WorkOrderId = '#form.transactionid#'
			</cfquery>		
			
			<cfquery name="serviceitem" 
			datasource="appsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  ServiceItem
				WHERE Code = '#workorder.serviceitem#'
			</cfquery>
				
			<cfset link = "WorkOrder/Application/WorkOrder/WorkOrderView/WorkOrderView.cfm?workorderid=#workorder.WorkOrderId#&selected=servicelevel">			
					
			<cf_ActionListing 
				    EntityCode       = "WrkAgreement"
					EntityClass      = "Standard"
					EntityGroup      = ""
					EntityStatus     = ""
					Mission          = "#workorder.mission#"				
					ObjectReference  = "#Form.TransactionReference#"
					ObjectReference2 = "#serviceitem.description#" 			    
					ObjectKey4       = "#form.transactionid#"
					AjaxId           = "#form.transactionid#"
					ObjectURL        = "#link#"
					Reset            = "Limited"
					Show             = "No">							
			
			<cfset url.id2 = "">
			<cfinclude template="ServiceLine.cfm">	
		   	
</cfif>