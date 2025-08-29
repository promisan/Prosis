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
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#DSA">

<cfquery name="Invoice" 
datasource="appsTravelClaim">
	SELECT Cost.ClaimEventId,
	       Cost.IndicatorCode,
		   Cost.CostLineNo,
	       Cost.InvoiceCurrency, 
		   Cost.InvoiceAmount, 
		   Cost.InvoiceDate,
		   Cost.PersonNo
	FROM   ClaimEventIndicatorCost Cost INNER JOIN
           ClaimEvent Event ON Cost.ClaimEventId = Event.ClaimEventId INNER JOIN
           Ref_Indicator R ON Cost.IndicatorCode = R.Code
    WHERE  R.Category    != 'Pointer'
	AND    R.ClaimCategory is not NULL
	AND    Event.ClaimId = '#URL.ClaimId#'  
</cfquery>

<cfloop query = "Invoice">

	<cfset curr     = InvoiceCurrency>
	<cfset amt      = InvoiceAmount>
	<cfset amtP     = InvoiceAmount>
	   			 
	 <cfif Curr eq Claim.PaymentCurrency>
		 
		 <!--- no further adjustments made at this point --->				 
		 <!--- USD - USD (payment) --->
		 
	 <cfelse>
	 
	        <!--- GTQ -> USD (payment) --->
	 
	 		<cfquery name="Exchange" 
			  datasource="AppsLedger">
			  SELECT   TOP 1 *
			  FROM     CurrencyExchange
			  WHERE    Currency         = '#curr#' 
			    AND    EffectiveDate   <= '#Invoice.InvoiceDate#' 
			  ORDER BY EffectiveDate DESC
			 </cfquery>
			 
			 <cfif Exchange.ExchangeRate neq "">
				 <cfset amtP = amtP/Exchange.ExchangeRate>
			 </cfif>	
			 
			
			 
			 <cfif Claim.PaymentCurrency neq "USD">
				 
				 	<!--- GTQ - USD - EUR (payment) --->
		 
			  		<cfquery name="Exchange" 
					  datasource="AppsLedger">
					  SELECT   TOP 1 *
					  FROM     CurrencyExchange    
					  WHERE    Currency         = '#Claim.PaymentCurrency#' 
					    AND    EffectiveDate   <= '#dateformat(Claim.ClaimDate,client.dateSQL)#'
					  ORDER BY EffectiveDate DESC
					 </cfquery>
					 
					 <cfif Exchange.ExchangeRate neq "">
						 <cfset amtP = amtP*Exchange.ExchangeRate>
					 </cfif>
					 				 
			 </cfif>
			 
			 
	 	 		  
	</cfif>
	
	 <cfquery name="Base" 
	  datasource="AppsLedger">
	  SELECT   TOP 1 *
	  FROM     CurrencyExchange
	  WHERE    Currency         = '#Claim.PaymentCurrency#' 
	    AND    EffectiveDate   <= '#dateformat(Claim.ClaimDate,client.dateSQL)#'
	  ORDER BY EffectiveDate DESC
	 </cfquery>
		
	<!--- update --->
	
	<cfquery name="Update" 
	datasource="appsTravelClaim">
	UPDATE ClaimEventIndicatorCost
	SET AmountPayment = '#amtP#'
	<cfif Base.ExchangeRate neq "">,ExchangeRate = '#Base.ExchangeRate#'</cfif>
	WHERE  ClaimEventId  = '#ClaimEventId#'  
	AND    IndicatorCode = '#IndicatorCode#'
	AND    CostLineNo    = '#CostLineNo#'
	</cfquery>
	
	</cfloop>

<!--- save the results in total --->

	<cfquery name="Last" 
	datasource="appsTravelClaim">
	SELECT max(ClaimLineNo) as ClaimLineNo
	FROM   ClaimLine
	WHERE  ClaimId = '#ClaimId#' 
	</cfquery>
	
	<cfquery name="Total" 
    datasource="appsTravelClaim">
	SELECT  I.ClaimCategory, 
	        EI.PersonNo, 
			SUM(EI.AmountPayment) AS AmountPayment
	FROM    ClaimEventIndicatorCost EI, 
            ClaimEvent Ev, 
            Ref_Indicator I
	WHERE   EI.ClaimEventId = Ev.ClaimEventId	
	AND     EI.IndicatorCode = I.Code	  
	AND     EI.IndicatorCode = I.Code 
	AND     ClaimId = '#ClaimId#'
	GROUP BY I.ClaimCategory, EI.PersonNo  
	</cfquery>
	
	<cfset last = '#Last.ClaimLineNo#'>
	
	<cfloop query="total">
	
	    <cfset person   = '#Total.PersonNo#'> 
	
		<cfset line = line + 1>
				
		<!--- define US amount for funding --->
		 		
			 <cfif "#Claim.PaymentCurrency#" eq "USD">
				 
				 	 <cfset currB = 1>
					 <cfset amtT = Total.AmountPayment>
							 
			 <cfelse>
					 
					 <cfquery name="Exchange" 
					  datasource="AppsLedger">
					  SELECT   TOP 1 *
					  FROM     CurrencyExchange
					  WHERE    Currency         = '#Claim.PaymentCurrency#' 
					    AND    EffectiveDate   <= getDate()
					  ORDER BY EffectiveDate DESC
					 </cfquery>
					 
					 <cfif Exchange.recordcount eq "0">
					      <cfset currB = 1>
						  <cfset amtT = Total.AmountPayment>
					 <cfelse>
					     <cfset currB = Exchange.ExchangeRate>
						  <cfset amtT = Total.AmountPayment/Exchange.ExchangeRate>
					 </cfif>					
				 			
			</cfif>
			
		<cfif Person eq "">
		    <cfset Person = '#ClaimRequest.PersonNo#'>
		</cfif>
		
		<cfif amtT neq "0" and amtT neq "">
	
		    <cfquery name="Invoice" 
		    datasource="appsTravelClaim">
			INSERT INTO ClaimLine
			  (ClaimId, 
			   ClaimLineNo, 
			   ClaimRequestId, 
			    ClaimCategory,
			   PersonNo,
			   ExpenditureDate,
			   Currency,
			   AmountClaim,
			   ExchangeRate,
			   AmountClaimBase,
			   OfficerUserId,
			   OfficerLastName,
			   OfficerFirstName)
			VALUES ('#URL.ClaimId#',
			       '#Line#',
				   '#Claim.ClaimRequestId#',
				   '#total.claimCategory#',
				   '#Person#',
				   '#dateFormat(now(), client.dateSQL)#',
				   '#Claim.PaymentCurrency#',
				   '#Total.AmountPayment#',
				   '#currB#',
				   '#amtT#',
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#')
			</cfquery>
		
		</cfif>	
				
	</cfloop>
	