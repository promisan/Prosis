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
<cfparam name="Attributes.ReqNo"        default="">
<cfparam name="Attributes.Currency"     default="USD">
<cfparam name="Attributes.ErrorMessage" default="">
		
<cfset ReqNo = attributes.ReqNo>
<cfset Curr  = attributes.Currency>

<cfquery name="Check" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT DISTINCT Currency
	 FROM   PurchaseLineReceipt
	 WHERE  ActionStatus != '9'
	 AND    RequisitionNo = '#reqNo#'				 
</cfquery>	

<cfquery name="Param" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 
	 SELECT     *
	 FROM         PurchaseLine PL INNER JOIN
                  Purchase P ON PL.PurchaseNo = P.PurchaseNo INNER JOIN
                  Ref_OrderType R ON P.OrderType = R.Code
	 WHERE  RequisitionNo = '#reqNo#'				 
</cfquery>	

<cfset caller.purchaseValidate = "1">  <!--- passes --->

<cfif Param.ReceiptValueThreshold eq "">
	<cfset ratio = 1>
<cfelse>
	<cfset ratio = 1+(Param.ReceiptValueThreshold/100)>
</cfif>	

<!--- usual scenario, receipt currency = line currency and we have just one currency --->		
								
<cfif Check.recordcount eq "1" and Check.Currency eq Curr>		

		<!--- check if total value has been exceeded --->

		<cfquery name="MaxValue" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">			
			SELECT     ISNULL(SUM(OrderAmount),0)*#ratio# AS total
			FROM       PurchaseLine
			WHERE      PurchaseNo IN (SELECT DISTINCT PurchaseNo 
		                              FROM   PurchaseLine 
								      WHERE  RequisitionNo = '#reqno#'
								  )
		</cfquery>
		
		<cfquery name="ReceiptValue" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">			
			SELECT     ISNULL(SUM(ReceiptAmount),0) AS total
			FROM       PurchaseLineReceipt
			WHERE      ActionStatus != '9'
			AND        RequisitionNo IN  (SELECT RequisitionNo 
		                          	  FROM   PurchaseLine 
									  WHERE  PurchaseNo IN (SELECT DISTINCT PurchaseNo 
							            		            FROM   PurchaseLine 
															WHERE  RequisitionNo = '#reqno#'
														   )
									  ) 				  
		</cfquery>
																				
	   <cfif ReceiptValue.Total-MaxValue.Total gt 0.05>
	   
	       <cf_alert message = "#Attributes.ErrorMessage# #curr# #numberformat(maxvalue.total,'__,__.__')# - #numberformat(ReceiptValue.total,'__,__.__')#" return = "back">			   
		   <cfset caller.purchasevalidate = "0">									 
		   
	   </cfif>	 
																								
<cfelseif Check.recordcount gte "1" and Check.Currency neq Curr>	
		
	   <!--- different currency --->					
	   <!--- check if total value has been exceeded --->

	   <cfquery name="MaxValue" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">			
			SELECT     ISNULL(SUM(OrderAmountBase),0)*#ratio# AS total
			FROM       PurchaseLine
			WHERE      PurchaseNo IN (
			                          SELECT DISTINCT PurchaseNo 
		                              FROM   PurchaseLine 
								      WHERE  RequisitionNo = '#reqno#'
								      )
	   </cfquery>
		
	   <cfquery name="ReceiptValue" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">			
			SELECT     ISNULL(SUM(ReceiptAmountBase),0) AS total
			FROM       PurchaseLineReceipt
			WHERE      ActionStatus != '9'
			AND        RequisitionNo IN  (SELECT RequisitionNo 
		                          	      FROM   PurchaseLine 
									      WHERE  PurchaseNo IN (
										                        SELECT DISTINCT PurchaseNo 
							            		                FROM   PurchaseLine 
															    WHERE  RequisitionNo = '#reqno#'
														        )
									  ) 				  
	   </cfquery>							
												
	   <cfif ReceiptValue.Total - MaxValue.Total gt 0.05>
		
			<cf_alert message = "#Attributes.ErrorMessage# #APPLICATION.BaseCurrency# #numberformat(maxvalue.total,',__.__')# - #numberformat(ReceiptValue.total,'__,__.__')#." return = "back">						  
			<cfset caller.purchasevalidate = "0">		  
						 
		</cfif>	 
											
</cfif>		
						
