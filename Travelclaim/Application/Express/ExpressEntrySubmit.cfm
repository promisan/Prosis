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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html><head><title>Save Express</title></head>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<body>

<cf_wait flush="force">

<!--- payment information --->

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM  Claim 
	WHERE ClaimId = '#URL.ClaimId#' 
</cfquery>

<cfquery name="Parameter" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Parameter 	
</cfquery>

<cfquery name="EMail" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Claim
	SET   eMailAddress = '#Form.EMailAddress#', 
	      ClaimAsIs = 1,
		  PointerClaimFinal = '#Parameter.FinalClaimExpress#'	
    WHERE ClaimId = '#URL.ClaimId#'
</cfquery>

<!--- check user account --->
<cfquery name="UpdateUserAccount" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE UserNames
	SET eMailAddress = '#Form.EMailAddress#'
    WHERE Account = '#SESSION.acc#'
	AND  (eMailAddress is NULL or eMailAddress = '')
</cfquery>

<cfif Claim.ActionStatus eq "0">
  <!--- submit claim option --->
  <cfset status = "1">	
  <cfinclude template="../ClaimEntry/ClaimEntrySubmitData.cfm">
</cfif>

<!--- 

1. Clear current entries
2. Generate trip + dsa entitlements per day : ClaimEventInit.cfm
3. Generate other line amounts if Ref_ClaimCategory amount = "1"
4. Set status = "2", workflow

--->

<cftransaction>

<cfquery name="Claim" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT * 
		 FROM  Claim
		 WHERE ClaimId = '#URL.ClaimID#'
</cfquery>

<cf_wait text="Preparation">

<!--- 1. Clear current entries --->

<cfquery name="DeleteLine" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimLine
		 WHERE ClaimId = '#URL.ClaimID#'
</cfquery>

<!--- do not delete events here

<cfquery name="DeleteEvent" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimEvent
		 WHERE ClaimId = '#URL.ClaimID#'
</cfquery>

--->

<cfquery name="DeleteDSA" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimLineDSA
		 WHERE ClaimId = '#URL.ClaimID#'
</cfquery>

<cfquery name="DeleteDSA" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimLineDateIndicator
		 WHERE ClaimId = '#URL.ClaimID#'
</cfquery>

<cf_waitEnd>
<cf_wait text="Preparation 2">
<!--- 2. Generate trip entries --->

<!--- save entered values for mode and indicator --->

<cfquery name="UpdateEvent" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ClaimEventTrip
	SET EventCode = '#Form.EventCode#' 
	WHERE ClaimEventId IN (SELECT ClaimEventId 
	                       FROM ClaimEvent 
						   WHERE ClaimId = '#URL.ClaimId#')
</cfquery>

<cfquery name="ClearIndicators" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ClaimEventTripIndicator
	WHERE  ClaimEventId IN (SELECT ClaimEventId 
	                       FROM ClaimEvent 
						   WHERE ClaimId = '#URL.ClaimId#') 
</cfquery>

<!--- vehicle information --->

<cfif form.vehicle eq "1">

	<cfquery name="Trip" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     T.*
		FROM       ClaimEvent E, ClaimEventTrip T
		WHERE      ClaimId = '#URL.ClaimId#'
		AND        E.ClaimEventId = T.ClaimEventId 
		ORDER BY   LocationDate
	</cfquery>
			
	<cfloop query="trip">
	
	  <cfquery name="EventIndicator" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_Indicator
		  WHERE  Category = '#ClaimTripMode#'		  
		  ORDER BY Category, ListingOrder 
	  </cfquery>
	    		  
	  <cfset eventid = "#trip.ClaimEventId#">
	  <cfset tripid  = "#trip.ClaimTripId#">
	  <cfset row     = "#trip.CurrentRow#">
	  	  
	  <cfloop query="EventIndicator">
	  	    
	      <cfparam name="Form.#row#_#Code#" default=""> 
		  
		  <cfset ind    = Evaluate("Form.#row#_#Code#")>
		  
		  <cfif ind neq "">
	  
			  <cfquery name="InsertPointer" 
				  datasource="appsTravelClaim" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO  ClaimEventTripIndicator
				      (ClaimEventId,
					   ClaimTripId,
					   IndicatorCode,
					   IndicatorValue)
				  VALUES ('#eventid#',
				          '#tripid#',
				          '#Code#',
				          '1')
			  </cfquery>	
		 		  
		  </cfif>
		  		   
	  </cfloop> 
	
	</cfloop>

</cfif>

<!--- save indicator --->
<cfquery name="trip" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     TOP 1 T.*
	FROM       ClaimEvent E, ClaimEventTrip T
	WHERE      ClaimId = '#URL.ClaimId#'
	AND        E.ClaimEventId = T.ClaimEventId 
	ORDER BY   EventDateEffective DESC 
</cfquery>
			
<cfquery name="EventIndicator" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT DISTINCT IndicatorCode
	  FROM   Ref_ClaimEventIndicator I, 
	         Ref_Indicator R
	  WHERE  I.IndicatorCode = R.Code
	  AND    R.Category = 'Additional'
</cfquery>
    		  
  <cfset eventid = "#trip.ClaimEventId#">
  <cfset tripid  = "#trip.ClaimTripId#">
  <cfset row = "#trip.CurrentRow#">
  	  
  <cfloop query="EventIndicator">
  	    
      <cfparam name="Form.#row#_#IndicatorCode#" default=""> 
	  <cfparam name="Form.#row#_#IndicatorCode#_other" default=""> 
	  		
	  <cfif Evaluate("Form.#row#_#IndicatorCode#_other") eq "">
	     <cfset ind    = Evaluate("Form.#row#_#IndicatorCode#")>
	  <cfelse>
	     <cfset ind    = Evaluate("Form.#row#_#IndicatorCode#_other")>
	  </cfif>		  
	  		  
	  <cfif ind eq "Yes">
	  	  
		  <cfquery name="InsertPointer" 
			  datasource="appsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO  ClaimEventTripIndicator
			      (ClaimEventId,
				   ClaimTripId,
				   IndicatorCode,
				   IndicatorValue)
			  VALUES ('#eventid#',
			          '#tripid#',
			          '#IndicatorCode#',
			          '#ind#')
		  </cfquery>	
		  
	  <cfelse>
	  
	  		<cfquery name="ClearPointer" 
			  datasource="appsTravelClaim" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  DELETE FROM ClaimEventIndicatorCost
			  WHERE ClaimEventId IN (SELECT ClaimEventId
			                         FROM ClaimEvent
									 WHERE ClaimId = '#URL.ClaimId#')	
			  AND IndicatorCode IN (SELECT code from Ref_Indicator WHERE category = 'Additional')
		    </cfquery>	
	  	  		 		  
	  </cfif>
		
</cfloop>

<cf_waitEnd>
<!--- 3. Generate trip entries --->
<cf_wait1 text="Preparation 3">

	<cfquery name="Event" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM ClaimEvent
		WHERE ClaimId = '#URL.ClaimId#' 
	</cfquery>	
	
	<!--- disabled because of calculation routine 14/3/2006 
	
	<cfquery name="InsertIndicator" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    INSERT INTO ClaimEventIndicator
		(ClaimEventId, IndicatorCode, IndicatorValue)
		SELECT DISTINCT 
		        '#Event.ClaimEventId#',
		        DefaultIndicatorCode,
			   '1'
		FROM   ClaimRequestLine C,
		       Ref_ClaimCategory R
		WHERE  C.ClaimCategory = R.Code
		AND    R.ClaimAmount = 1 
		AND    C.ClaimRequestId = '#Claim.ClaimRequestId#'
		AND    R.DefaultIndicatorCode IS NOT NULL
	</cfquery>	

	<!--- TRM --->
		
	<cfquery name="InsertLines" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    INSERT INTO ClaimEventIndicatorCost
		(ClaimEventId, 
		 IndicatorCode,
		 CostLineNo, 
		 InvoiceDate,
		 Description,
		 InvoiceCurrency,
		 InvoiceAmount)
		SELECT '#Event.ClaimEventId#',
		       R.DefaultIndicatorCode,
			   C.ClaimRequestLineNo, 
			   '#dateFormat(now(),client.dateSQL)#',
			   R.Description,
			   C.Currency, 
			   C.RequestAmount 
		FROM   ClaimRequestLine C,
		       Ref_ClaimCategory R
		WHERE  C.ClaimCategory = R.Code 
		AND    R.ClaimAmount = 1 
		AND    C.ClaimRequestId = '#Claim.ClaimRequestId#'  
		AND    R.DefaultIndicatorCode IS NOT NULL 
	</cfquery>	
	
	--->

<!--- 4. Calculate --->

</cftransaction>

<cf_waitEnd>
<cfset URL.Express = "1">
<cfinclude template="../Process/Calculation/Calculate.cfm">

</body>
</html>
