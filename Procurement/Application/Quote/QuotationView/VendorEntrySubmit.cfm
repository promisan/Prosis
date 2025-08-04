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

<cfquery name="Job" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * 
	FROM   Job 
	WHERE  JobNo ='#URL.JobNo#'
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#Job.Mission#' 
</cfquery>

<cfquery name="CheckZero" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM      RequisitionLine
WHERE     JobNo = '#URL.JobNo#'
AND       RequestAmountBase = 0
</cfquery>

<cfif CheckZero.recordcount gte "1">

	<script>
		alert("Problem, ensure that the requisition line has a defined value, right now it has a zero value.")
	</script>

<cfelse>	

	<cftransaction>
	
	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   JobVendor
	WHERE  JobNo = '#URL.JobNo#'
	AND    OrgUnitVendor = '#URL.OrgUnit#'
	</cfquery>
	
	<cfif Check.Recordcount eq "0">
	
		<cfquery name="Insert" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO JobVendor 
			(JobNo,OrgUnitVendor,OfficerUserId, OfficerLastName, OfficerFirstName)
		VALUES
			('#URL.JobNo#','#URL.OrgUnit#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
		</cfquery>		
						
		<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 INSERT INTO RequisitionLineQuote 
					   ( RequisitionNo, 
						 JobNo, 
						 OrgUnitVendor, 
						 VendorItemDescription, 
						 TaxIncluded,
						 TaxExemption,
						 QuoteTax, 
						 QuotationQuantity, 
						 QuotationUoM, 
						 Currency,
						 ExchangeRate,
						 
						 <cfif Parameter.EnableQuickQuote eq "1">
						 
						 	<cfif Parameter.TaxExemption eq "1">	
							
							  QuotePrice,
							  QuoteAmountCost,
							  QuoteAmountBaseCost, 						  
							  
							 <cfelse> 	
													 
							  QuotePrice,
							  QuoteAmountCost,
							  QuoteAmountBaseCost, 	
							  QuoteAmountTax,
							  QuoteAmountBaseTax,
							 					 
							 </cfif>
							 
							 Selected,				   
							  
						 </cfif>
						 
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				 SELECT  L.RequisitionNo, 
				         '#URL.JobNo#', 
					 	 '#URL.OrgUnit#', 
						 L.RequestDescription, 
						 '#Parameter.DefaultTaxIncluded#',
						 '#Parameter.TaxExemption#',
						 '#Parameter.TaxDefault#', 
						 L.RequestQuantity, 
						 L.QuantityUoM, 
						 RequestCurrency,	
						 (RequestCurrencyPrice*RequestQuantity)/RequestAmountBase,  <!--- exchange rate --->
						
						 <cfif Parameter.EnableQuickQuote eq "1">	
						
							<cfif Parameter.TaxExemption eq "1">										  
							
							  RequestCurrencyPrice,
							  RequestCurrencyPrice*RequestQuantity,
							  RequestAmountBase,									  
							  
							<cfelseif Parameter.DefaultTaxIncluded eq "1">
							
							  <!--- we have to split the tax out of the requisition price --->
							
							  RequestCurrencyPrice,
							  1 / (1+#Parameter.TaxDefault#) * (RequestCurrencyPrice*RequestQuantity),
							  1 / (1+#Parameter.TaxDefault#) * RequestAmountBase,	
							  #Parameter.TaxDefault# /(1+#Parameter.TaxDefault#) * (RequestCurrencyPrice*RequestQuantity),
							  #Parameter.TaxDefault# /(1+#Parameter.TaxDefault#) * (RequestCurrencyPrice*RequestQuantity) / ((RequestCurrencyPrice*RequestQuantity)/RequestAmountBase),
							 
							<cfelse>
							
							  RequestCurrencyPrice,
							  RequestCurrencyPrice*RequestQuantity,
							  RequestAmountBase,	
							  #Parameter.TaxDefault# *( RequestCurrencyPrice*RequestQuantity),
							  #Parameter.TaxDefault# *( RequestCurrencyPrice*RequestQuantity) / ((RequestCurrencyPrice*RequestQuantity)/RequestAmountBase),
							 
							</cfif>  
							
							'1',
						 
						 </cfif>
						
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
				 FROM  RequisitionLINE L
				 WHERE L.JobNo = '#URL.JobNo#'
				 <!--- does not have an occurance --->
				 AND   L.RequisitionNo NOT IN (SELECT RequisitionNo 
				                               FROM   RequisitionLineQuote 
											   WHERE  RequisitionNo = L.RequisitionNo
											   AND    OrgUnitVendor = '#URL.OrgUnit#') 
			</cfquery>
		
		<cfelse>
		
			<cfquery name="Update" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 UPDATE RequisitionLineQuote
			 SET    Selected = 0
			 WHERE  RequisitionNo IN (SELECT RequisitionNo 
			                         FROM    RequisitionLine 
									 WHERE   JobNo = '#URL.JobNo#') 
			</cfquery>							 
		
			<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 INSERT INTO RequisitionLineQuote 
				 
						 (RequisitionNo, 
						  JobNo, 
						  OrgUnitVendor, 
						  VendorItemDescription, 
						  TaxIncluded,
					      TaxExemption,
						  QuoteTax, 					  
						  QuotationQuantity, 
						  QuotationUoM, 
						  Currency,
						  ExchangeRate,
						  
						  <cfif Parameter.EnableQuickQuote eq "1">
						 
						 	<cfif Parameter.TaxExemption eq "1">	
							
							  QuotePrice,
							  QuoteAmountCost,
							  QuoteAmountBaseCost, 						  
							  
							 <cfelse> 	
													 
							  QuotePrice,
							  QuoteAmountCost,
							  QuoteAmountBaseCost, 	
							  QuoteAmountTax,
							  QuoteAmountBaseTax,
							 					 
							 </cfif>
							 
							 Selected,				   
							  
						 </cfif>						
						  
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
						  
				 SELECT  RequisitionNo, 
				         '#URL.JobNo#', 
						 '#URL.OrgUnit#', 
						 RequestDescription, 
						 '#Parameter.DefaultTaxIncluded#',
						 '#Parameter.TaxExemption#',
						 '#Parameter.TaxDefault#', 
						 RequestQuantity, 
						 QuantityUoM, 
						 RequestCurrency,						 
						 
						 (RequestCurrencyPrice*RequestQuantity)/RequestAmountBase,  <!--- exchange rate --->
						
						 <cfif Parameter.EnableQuickQuote eq "1">	
						
							<cfif Parameter.TaxExemption eq "1">										  
							
							  RequestCurrencyPrice,
							  RequestCurrencyPrice*RequestQuantity,
							  RequestAmountBase,									  
							  
							<cfelseif Parameter.DefaultTaxIncluded eq "1">
							
							  <!--- we have to split the tax out of the requisition price --->
							
							  RequestCurrencyPrice,
							  1 / (1+#Parameter.TaxDefault#) * (RequestCurrencyPrice*RequestQuantity),
							  1 / (1+#Parameter.TaxDefault#) * RequestAmountBase,	
							  #Parameter.TaxDefault# /(1+#Parameter.TaxDefault#) * (RequestCurrencyPrice*RequestQuantity),
							  #Parameter.TaxDefault# /(1+#Parameter.TaxDefault#) * (RequestCurrencyPrice*RequestQuantity) / ((RequestCurrencyPrice*RequestQuantity)/RequestAmountBase),
							 
							<cfelse>
							
							  RequestCurrencyPrice,
							  RequestCurrencyPrice*RequestQuantity,
							  RequestAmountBase,	
							  #Parameter.TaxDefault# *( RequestCurrencyPrice*RequestQuantity),
							  #Parameter.TaxDefault# *( RequestCurrencyPrice*RequestQuantity) / ((RequestCurrencyPrice*RequestQuantity)/RequestAmountBase),
							 
							</cfif>  
							
							'1',
						 
						 </cfif>						 
						 
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#'
				 FROM   RequisitionLine
				 WHERE  JobNo = '#URL.JobNo#'
				  <!--- does not have an occurance --->
				 AND   RequisitionNo NOT IN (SELECT RequisitionNo 
				                             FROM   RequisitionLineQuote 
											 WHERE  OrgUnitVendor = '#URL.OrgUnit#') 
			</cfquery>
			
	</cfif>	
	
	</cftransaction>

</cfif>

<cfoutput>

    <script>
		ColdFusion.navigate('#SESSION.root#/procurement/application/quote/quotationview/JobViewVendor.cfm?workflow=#url.workflow#&id1=#url.jobno#','dialog')
	</script>
	
</cfoutput>
