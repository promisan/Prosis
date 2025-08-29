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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfoutput>
	
	<cfquery name="SetClaim" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Claim 
		SET ClaimAsIs = 0, PointerClaimUpdated = getDate()
	    WHERE ClaimId = '#URL.ClaimId#'
	</cfquery>
	 		
	<cfquery name="Exist" 
	    datasource="AppsTravelClaim" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT * 
		FROM ClaimEventIndicator
		WHERE ClaimEventId   IN (SELECT ClaimEventId 
		                           FROM ClaimEvent
								   WHERE ClaimId= '#URL.ClaimId#')
		AND IndicatorCode = '#URL.IndicatorCode#' 
	</cfquery>
			
	<cfif Exist.recordCount eq "0">
	
		<cfquery name="Exist" 
	    	datasource="AppsTravelClaim" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT * 
			FROM ClaimEvent
			WHERE ClaimId = '#URL.ClaimId#'
		</cfquery>		
		
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
		  
	</cfif>	  
			
	<cfquery name="Line" 
	    datasource="AppsTravelClaim" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT Max(CostLineNo) as CostLineNo
		FROM ClaimEventIndicatorCost
		WHERE ClaimEventId IN (SELECT ClaimEventId 
		                           FROM ClaimEvent
								   WHERE ClaimId= '#URL.ClaimId#')		
	</cfquery>
		
	<cfif Line.CostLineNo eq "">
		  <cfset ln = 1>
	<cfelse>
		  <cfset ln = Line.CostLineNo+1>
	</cfif>
	
	<!--- add record --->
	
	 <cfoutput>
	
	 <CF_DateConvert Value="#Form.InvoiceDate#">
	  <cfset dte = dateValue>
	
	  <cfif dte+1 gte now()>
	    <script>
		alert("You may not enter today's date or a future date. Entered date : <cfoutput>#Form.InvoiceDate#</cfoutput>")
		ColdFusion.navigate('ClaimEventEntryIndicatorEntryDialog.cfm?title=#url.title#&editclaim=#url.editclaim#&claimid=#URL.ClaimID#&personNo=#URL.PersonNo#&indicatorcode=#URL.IndicatorCode#&id2=#url.id2#','costings')     		
		</script>
		<cfabort>
		
	  </cfif>
	  
	  <cfquery name="Departure" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     MIN(EventDateEffective) AS Date
		FROM         ClaimEvent
		WHERE ClaimId = '#URL.ClaimId#'
	  </cfquery>
	  
	   <cfif dte+365 lt Departure.Date>
	    <script>
			alert("You may not enter a date before the departure date. Entered date : <cfoutput>#Form.InvoiceDate#</cfoutput>")
			ColdFusion.navigate('ClaimEventEntryIndicatorEntryDialog.cfm?title=#url.title#&editclaim=#url.editclaim#&claimid=#URL.ClaimID#&personNo=#URL.PersonNo#&indicatorcode=#URL.IndicatorCode#&id2=#url.id2#','costings') 
    	</script>
		<cfabort>
		
	  </cfif>
	  
	  <cfset amt      = replace('#Form.InvoiceAmount#',',','',"ALL")>
	  
	  <cfif amt eq "0">
	   <script>
			alert("You entered an amount of 0.00. Please enter a positive (or negative) amount.")
			ColdFusion.navigate('ClaimEventEntryIndicatorEntryDialog.cfm?title=#url.title#&editclaim=#url.editclaim#&claimid=#URL.ClaimID#&personNo=#URL.PersonNo#&indicatorcode=#URL.IndicatorCode#&id2=#url.id2#','costings') 
    	</script>
		<cfabort>
	  
	  </cfif>
	  
	  </cfoutput>	
	  
	  
	  
	  <cfif URL.Id2 eq "New">
	
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
					  '#amt#',
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
				 InvoiceAmount   = '#amt#',
				 Description     = '#Form.Description#' 
			WHERE ClaimEventId   = '#Exist.ClaimEventId#' 
			  AND IndicatorCode  = '#URL.IndicatorCode#' 
			  AND CostLineNo     = '#URL.ID2#'
		 </cfquery>	
	 
	 </cfif>	 
	 	
	<SCRIPT LANGUAGE = "JavaScript">
	     ColdFusion.navigate('#SESSION.root#/travelclaim/application/evententry/ClaimEventEntryIndicatorEntryCostRecord.cfm?editclaim=#url.editclaim#&claimid=#URL.ClaimID#&personNo=#URL.PersonNo#&indicatorcode=#URL.IndicatorCode#','b#URL.PersonNo#_#URL.IndicatorCode#') 
		 <cfif url.id2 eq "new">
		  ColdFusion.navigate('#SESSION.root#/travelclaim/application/evententry/ClaimEventEntryIndicatorEntryDialog.cfm?title=#url.title#&editclaim=#url.editclaim#&claimid=#URL.ClaimID#&personNo=#URL.PersonNo#&indicatorcode=#URL.IndicatorCode#&id2=#url.id2#','costings')
		 <cfelse>
		  ColdFusion.Window.hide('costings') 
		 </cfif> 
	</script>	
	
</cfoutput>	 
 	

  
