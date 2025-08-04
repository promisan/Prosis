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

<!--- 

- define all active lines of THIS WORK for the period of the provision 
- and only if they also do not have a provision for this period
- then copy over for each line 

WorkOrderLineBilling
WorkOrderLineBillingDetail

--->

<cfquery name="get" 
  datasource="appsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   WorkOrderLineBilling
  WHERE  BillingId  = '#url.billingid#' 		  
</cfquery>		  

<cfquery name="List" 
		  datasource="appsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">

		SELECT WorkOrderId, WorkOrderLine
		FROM   WorkOrderLine AS T
		WHERE  WorkOrderId   = '#get.workorderid#'		
		AND    Operational = 1 
		AND    (DateExpiration IS NULL OR DateExpiration > GETDATE()) 
		AND    DateEffective < GETDATE() 
		AND    NOT EXISTS   (
		                    SELECT   'X'
		                    FROM     WorkOrderLineBilling
		                    WHERE    WorkOrderId   = T.WorkOrderId 
							AND      WorkOrderLine = T.WorkOrderLine 
							<cfif get.BillingExpiration neq "">
							AND      BillingEffective <= '#get.BillingExpiration#' 
							</cfif>
							AND      (BillingExpiration >= '#get.BillingEffective#' OR BillingExpiration IS NULL)
							)
</cfquery>				

<cfloop query="List">
	
	<cftransaction>
	
		<!--- insert WorkOderLineBilling --->
	
		<cfquery name="Insert1" 
		  datasource="appsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
		  INSERT INTO WorkOrderLineBilling
		  
		  	  ( WorkOrderId, 
			    WorkOrderLine, 
				BillingEffective, 
				ServiceDomain, 
				Reference, 
				BillingReference, 
				BillingName, 
				BillingAddress, 
				ReferenceNo, 
				OrgUnit, 
				PayerId, 
        	    BillingExpiration, 
				OfficerUserId, 
				OfficerLastName, 
				OfficerFirstName )
		  
		  SELECT '#workorderid#', 
			     '#workorderline#', 
				 BillingEffective, 
				 ServiceDomain, 
				 Reference, 
				 BillingReference, 
				 BillingName, 
				 BillingAddress, 
				 ReferenceNo, 
				 OrgUnit, 
				 PayerId, 
	             BillingExpiration, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName
				 		  
		  FROM   WorkOrderLineBilling
		  WHERE  WorkOrderId       = '#get.workorderid#'
		  AND    WorkOrderLine     = '#get.workorderline#'
		  AND    BillingEffective  = '#get.BillingEffective#'
		  
		</cfquery> 
		
		<!--- insert workorderLineBillingDetail --->
		
		<cfquery name="Insert1" 
		  datasource="appsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		
			 INSERT INTO WorkOrderLineBillingDetail (
			        WorkOrderId, 
					WorkOrderLine, 
					BillingEffective, 
					ServiceItem, 
					ServiceItemUnit, 
					Frequency, 
					BillingMode, 
					Charged, 
					QuantityCost, 
					Quantity, 
					Currency, 
	                Rate, 					
					Reference, 				
					Operational, 
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName
					)
					
			 SELECT '#workorderid#', 
				    '#workorderline#',
					BillingEffective, 
					ServiceItem, 
					ServiceItemUnit, 
					Frequency, 
					BillingMode, 
					Charged, 
					QuantityCost, 
					Quantity, 
					Currency, 
	                Rate, 					
					Reference, 				
					Operational, 
					OfficerUserId, 
					OfficerLastName, 
					OfficerFirstName 
			 
			 FROM   WorkOrderLineBillingDetail
			 WHERE  WorkOrderId       = '#get.workorderid#'
			 AND    WorkOrderLine     = '#get.workorderline#'
			 AND    BillingEffective  = '#get.BillingEffective#'		

		</cfquery> 		
				
			
	</cftransaction>

</cfloop>	