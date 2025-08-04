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


<cfif url.field eq "category">
	
	<cfquery name="Check" 
		  datasource="AppsTravelClaim" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   Ref_ClaimCategory	   
		   WHERE  Code   = '#URL.value#'			  	
	</cfquery>
	
	<script language="JavaScript">
		
		<cfoutput>
		
		if (#check.RequestDays# == "0") {
			   document.getElementById("trvlocbox").className  = "hide"	
			   document.getElementById("trvdatebox").className = "hide"	
			   // document.getElementById("trvdaysbox").className = "hide"	
			   document.getElementById("trvmodabox").className = "hide"	
			} else {
			   document.getElementById("trvlocbox").className  = "regular" 
			   document.getElementById("trvdatebox").className = "regular" 
			   // document.getElementById("trvdaysbox").className = "regular"	
			   document.getElementById("trvmodabox").className = "regular"	
			}	
			
		</cfoutput>
		
	</script>	
	
<cfelseif url.field eq "date">		

	<cfset Form.DateEffective  = Form.CostPeriod_Start>
	<cfset Form.DateExpiration = Form.CostPeriod_End>
	
	<cfquery name="First" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   RequisitionLineItinerary	   
		   WHERE  RequisitionNo = '#URL.ID#'			  	
		   AND    ItineraryLineNo = '1'
	</cfquery>
	
	<cfif Form.DateEffective neq ''>
	    <CF_DateConvert Value="#Form.DateEffective#">
		<cfset eff = dateValue>
		<cfif First.DateDeparture neq "" and eff lt First.DateDeparture>
			<CF_DateConvert Value="#dateformat(first.dateDeparture,client.dateformatshow)#">
			<cfset eff = datevalue>			
		</cfif>
	<cfelse>
	    <cfset EFF = "">
	</cfif>		
	
	<cfquery name="Last" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   RequisitionLineItinerary	   
		   WHERE  RequisitionNo = '#URL.ID#'			  	
		   AND    ItineraryLineNo = '99'
	</cfquery>	
	
	<cfif Form.DateExpiration neq ''>
	    <CF_DateConvert Value="#Form.DateExpiration#">
		<cfset exp = dateValue>		
		<cfif Last.dateArrival neq "" and exp gte Last.DateArrival>
			<CF_DateConvert Value="#dateformat(last.dateArrival-1,client.dateformatshow)#">
			<cfset exp = datevalue>			
		</cfif>		
	<cfelse>
	    <cfset EXP = "">
	</cfif>	
	
	<cfif EFF neq "" and EXP neq "">
		
	  <cfset days = dateDiff("d",eff,exp)+1>
	  <cfif days lt "0">
	  	<cfset days = "0">
	  </cfif>

	  <cfoutput>
		  <script language="JavaScript">	
			$("##quantity").val("#days#");		
			$("##quantity").change();
		  </script>	
	  </cfoutput>	
	  
	 </cfif> 
	
<cfelseif url.field eq "location">

		<cfquery name="Line" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  RequisitionLine
			WHERE RequisitionNo = '#URL.ID#'
		</cfquery>
		
		<cfquery name="Check" 
			  datasource="AppsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT    R.LocationCode, 
			           R.LocationCountry, R.LocationCity, R.Description, D.PostGrade, D.RatePointer, D.ClaimantType, D.DateExpiration, D.Currency, D.Amount, D.AmountBase, D.ClaimCategory, D.ServiceLocation
			  FROM      Ref_PayrollLocation AS R INNER JOIN Ref_ClaimRates AS D ON R.LocationCode = D.ServiceLocation
			  WHERE     D.ClaimCategory = 'DSA'
			  AND       R.LocationCode = '#url.value#'
			  ORDER BY D.DateEffective DESC
		</cfquery>		
		
		<cfparam name="url.percent" default="100">
		<cfparam name="url.attr1" default="">
		<cfparam name="url.attr2" default="">
		<cfparam name="url.quantity" default="1">
		
		<cfoutput>
		
		<cfif isvalid("numeric",url.quantity) and (isValid("numeric",url.attr2) or url.attr2 eq "")>
		
			<cf_exchangeRate CurrencyFrom="#url.attr1#" CurrencyTo="#Line.RequestCurrency#">
			
			<cfif attr2 eq "" and check.AmountBase neq "">
						
				<script>	

				  $('##currency').val('#application.BaseCurrency#');
				  document.getElementById("currencyrate").value  = "#numberformat(check.AmountBase,'.__')#"		
				  document.getElementById("rate").value  = "#numberformat((check.AmountBase)/exc,'.__')#"  
				  document.getElementById("amount").value  = "#numberformat((url.quantity*check.AmountBase*(url.percent/100))/exc,'.__')#"
				 
				</script>
			
			<cfelseif attr2 neq "">
			
				<script>	
				
				  $('##currency').val('#application.BaseCurrency#');
				  document.getElementById("currencyrate").value  = "#numberformat(url.attr2,'.__')#"	
				  document.getElementById("rate").value  = "#numberformat((url.attr2)/exc,'.__')#"	  
				  document.getElementById("amount").value  = "#numberformat((url.quantity*url.attr2*(url.percent/100))/exc,'.__')#"
				 
				</script>
			
			</cfif>
			
		<cfelse>
		
		<script>
			alert("Problem : #url.quantity# | #url.attr2#")
		</script>
		
		</cfif>	
		
		</cfoutput>
		  



</cfif>	
