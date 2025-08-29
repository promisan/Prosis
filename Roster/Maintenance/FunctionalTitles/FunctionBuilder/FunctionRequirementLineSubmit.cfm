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
<cfoutput>
 		
	<cfquery name="Exist" 
	    datasource="AppsTravelClaim" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT * 
		FROM FunctionClaimEventIndicator
		WHERE ClaimEventId   IN (SELECT ClaimEventId 
		                           FROM ClaimEvent
								   WHERE ClaimId= '#URL.ClaimId#')
		AND IndicatorCode = '#URL.IndicatorCode#' 
	</cfquery>
			
	<cfif #Exist.recordCount# eq "0">
	
		<cfquery name="Exist" 
	    	datasource="AppsTravelClaim" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT * 
			FROM ClaimEvent
			WHERE ClaimId = '#URL.ClaimId#'
		</cfquery>
		
		<cfset ln = "1">
		
		<cfquery name="InsertIndicator" 
	 	  datasource="appsTravelClaim" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  INSERT INTO  ClaimEventIndicator
				      (ClaimEventId, 
					   IndicatorCode,
					   IndicatorValue, 
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName)
		  VALUES ('#Exist.ClaimEventId#',
		          '#URL.IndicatorCode#',
				  '1',
		          '#SESSION.acc#', 
				  '#SESSION.last#',
				  '#SESSION.first#')
		  </cfquery>
		  
	<cfelse>
	
		<cfquery name="Line" 
	    datasource="AppsTravelClaim" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT Max(CostLineNo) as CostLineNo
		FROM ClaimEventIndicatorCost
		WHERE ClaimEventId IN (SELECT ClaimEventId 
		                           FROM ClaimEvent
								   WHERE ClaimId= '#URL.ClaimId#')
		<!--- unique number						   
		AND IndicatorCode = '#URL.IndicatorCode#'
		--->
		</cfquery>
		
		<cfif #Line.CostLineNo# eq "">
		     <cfset ln = 1>
		<cfelse>
		     <cfset ln = #Line.CostLineNo#+1>
		</cfif>
			  
	</cfif>	
	
	<!--- add record --->
	
	 <CF_DateConvert Value="#Form.InvoiceDate#">
	  <cfset dte = #dateValue#>
	  
	  <cfif #URL.Id2# eq "New">
	
		<cfquery name="InsertCost" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO  ClaimEventIndicatorCost
					      (ClaimEventId, 
						   IndicatorCode,
						   CostLineNo,
						   PersonNo,
						   InvoiceNo,
						   InvoiceDate,
						   InvoiceCurrency,
						   InvoiceAmount,
						   Description)
			  VALUES ('#Exist.ClaimEventId#',
			          '#URL.IndicatorCode#',
					  '#ln#',
					  '#URL.PersonNo#',
					  '#Form.InvoiceNo#',
					   #dte#, 
					  '#Form.InvoiceCurrency#',
					  '#Form.InvoiceAmount#',
					  '#Form.Description#')
		 </cfquery>	
	 
	 <cfelse>
	 
	 	<cfquery name="UpdateCost" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ClaimEventIndicatorCost
			SET  InvoiceNo       = '#Form.InvoiceNo#',
			     InvoiceDate     = #dte#,
				 InvoiceCurrency = '#Form.InvoiceCurrency#',
				 InvoiceAmount   = '#Form.InvoiceAmount#',
				 Description     = '#Form.Description#' 
			WHERE ClaimEventId   = '#Exist.ClaimEventId#' 
			  AND IndicatorCode  = '#URL.IndicatorCode#' 
			  AND CostLineNo     = '#URL.ID2#'
		 </cfquery>	
	 
	 </cfif>
	
	<script>
		 window.location = "FunctionRequirementLine?claimid=#URL.ClaimID#&personNo=#URL.PersonNo#&indicatorcode=#URL.IndicatorCode#" 
	</script>	
	
</cfoutput>	 
 	

  
