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
	<cfparam name="Form.#cl#_reference_#id#" default="">
		
	<cfparam name="Form.#cl#_quantityIsstock_#id#" default="0">
	<cfset iss = evaluate("Form.#cl#_quantityIsStock_#id#")>
	
	<cfparam name="Form.#cl#_unitquantitystock_#id#" default="0">
	
	<cfset qty = evaluate("Form.#cl#_unitquantity_#id#")>
	
	<cfif iss eq "0">
		<cfset stk = evaluate("Form.#cl#_unitquantitystock_#id#")>
	<cfelse>
		<cfset stk = evaluate("Form.#cl#_unitquantity_#id#")>
	</cfif>	
		
	<cfset rte = evaluate("Form.#cl#_standardcost_#id#")>
	<cfset chg = evaluate("Form.#cl#_charged_#id#")>
	<cfset ref = evaluate("Form.#cl#_reference_#id#")>
	
	<cfset qty         = replace("#qty#",",","")>
	<cfset rte         = replace("#rte#",",","")>

	<!--- check if record exists --->
			
	<cfquery name="Exist" 
    datasource="appsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT  * 
	FROM    WorkOrderLineBillingDetail			
	WHERE   WorkOrderId      = '#check.workorderId#'
	AND     WorkOrderLine    = '#check.workorderline#'
	AND     BillingEffective = '#check.billingeffective#'		
	AND     ServiceItem      = '#workorder.serviceitem#'
	AND     ServiceItemUnit  = '#selected#'
   </cfquery>		   
	
	<cfif Exist.recordcount eq "0">
		
		<cfquery name="Insert" 
			  datasource="appsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				INSERT INTO WorkOrderLineBillingDetail
				( WorkOrderId, 
				  WorkOrderLine, 
				  BillingEffective, 			 
				  ServiceItem,
				  ServiceItemUnit,
				  Frequency,
				  BillingMode,
				  QuantityCost,
				  Quantity,
				  Currency,
				  Charged,
				  Rate,
				  Reference,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName)
				VALUES(
				<cfif url.billingid eq "">
				 '#url.workorderid#',
				 '#url.workorderline#',
				 #EFF#,
				<cfelse>
				 '#check.workorderId#',
                 '#check.workorderline#',
                 '#check.billingeffective#',				
				</cfif> 				 
				 '#workorder.serviceitem#',
				 '#selected#',
				 '#Frequency#',
				 '#BillMode#',
				 '#stk#',
				 '#qty#',
				 '#currency#',
				 '#chg#',
				 '#rte#',
				 '#ref#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')		
		</cfquery>		
	
	<cfelse>
		
		<cfquery name="Exist" 
	    datasource="appsWorkOrder" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
				
		    UPDATE  WorkOrderLineBillingDetail			
			SET     Frequency     =  '#Frequency#',
				    BillingMode   =  '#BillMode#',
				    Quantity      =  '#qty#',
					QuantityCost  =  '#stk#',  
			        Currency      =  '#currency#',
				    Charged       =  '#chg#',
				    Rate          =  '#rte#',		
					Reference     =  '#ref#',
					Operational   = 1	
			WHERE   BillingDetailId  = '#Exist.BillingDetailId#'			
	   </cfquery>	
	   
	</cfif>
	