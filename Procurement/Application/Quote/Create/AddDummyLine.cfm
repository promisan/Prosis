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

<!--- steps
	
	2. Insert Line and funding
	3. Insert Quotation lines
	
--->

<cfquery name="Job" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT *
	  FROM Job
	  WHERE JobNo = '#URL.id1#'
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#Job.Mission#' 
</cfquery>

<cfparam name="URL.Mission" default="#Job.Mission#">
	
	
<cftry>
		
<cftransaction> 
						
		<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		
	    INSERT INTO RequisitionLine 
			 (RequisitionNo, 
			  Mission, 
			  Period, 
			  OrgUnit, 
			  PersonNo, 
			  Reference, 
			  ItemMaster, 
			  RequestDescription, 
			  RequestType, 
			  Warehouse, 
			  WarehouseItemNo, 
              WarehouseUoM, 
			  RequestDate, 			 
			  RequestPriority, 
			  RequestQuantity, 
			  QuantityUOM, 
			  RequestCurrency, 
			  RequestCurrencyPrice, 
              RequestCostPrice, 
			  RequestAmountBase, 
			  ActionStatus, 			  
			  JobNo, 			
			  WorkorderId, 
			  ParentRequisitionNo, 			  
              CommodityCode, 
			  SourceNo,
			  OfficerUserId, 
			  OfficerLastName, 
			  OfficerFirstName)
		
		SELECT   '#URL.ID#_1', 
		         Mission, 
				 Period, 
				 OrgUnit, 
				 PersonNo, 
				 Reference, 
				 ItemMaster, 
				 RequestDescription, 
				 'Warehouse', 
				 Warehouse, 
				 WarehouseItemNo, 
                 WarehouseUoM, 				
				 RequestDate, 
				 RequestPriority, 
				 '0', 
				 QuantityUOM, 
				 RequestCurrency, 
				 '0', 
                 '0', 
				 '0', 
				 '2k', 
				 JobNo, 
				 WorkorderId, 
				 '#URL.ID#', 					
                 CommodityCode, 
				 SourceNo,
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#'
		FROM     RequisitionLine
		WHERE    RequisitionNo = '#URL.ID#'
		
		</cfquery>
		
		<cfquery name="Insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    INSERT INTO RequisitionLineFunding 
			    (RequisitionNo, 
			     Fund, 
				 ProgramCode,
				 ObjectCode,
				 Percentage,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName, 
				 Created)
			SELECT  '#URL.ID#_1',
					Fund, 
				    ProgramCode,
				    ObjectCode,
				    Percentage,
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#', 
					getDate()
			FROM   RequisitionLineFunding 
			WHERE  RequisitionNo = '#URL.ID#'	
		</cfquery>
				
	<!--- 1. define entries in JobVendor --->
		
	<cfquery name="Vendor" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
		 FROM JobVendor
		 WHERE JobNo = '#URL.ID1#'
	</cfquery>
			
	<!--- 2. loop insert requisitionline in linequote for each vendor --->
			
	<cfloop query="Vendor">
				
				<cfquery name="Insert" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 INSERT INTO RequisitionLineQuote
						   (RequisitionNo, 
						    JobNo, 
						    OrgUnitVendor, 
						    VendorItemDescription, 
							QuoteZero,
						    QuoteTax, 
						    QuotationQuantity, 
						    QuotationUoM, 
						    Currency)
					 SELECT '#URL.id#_1', 
					        '#URL.id1#', 
							'#OrgUnitVendor#', 
							RequestDescription, 
							'1',
							'#Parameter.TaxDefault#', 
							'1', 
							QuantityUoM, 
							'#APPLICATION.BaseCurrency#'
					 FROM   RequisitionLine 
					 WHERE  RequisitionNo = '#url.id#' 
				</cfquery>
													
	</cfloop>
			
</cftransaction> 

<cfcatch></cfcatch>

</cftry>

<cfset url.sort = "Line">
<cfset url.workflow = "1">
<cfinclude template="../QuotationView/JobViewVendor.cfm">



