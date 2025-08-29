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
<cfsilent>

	<proUsr>administrator</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes></proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	Saving the values as define on the additional entry screen in case the user makes interactive changes to ensure consistency 
	1. Remarks
	2. email address
	3. adjust if user selects pointer additional travel advance = No, that no detailed records are stored, to keep consistency
	4. 
	</td></tr>
	</table>
	</proInfo>

</cfsilent>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>"> 

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM Claim R
    WHERE ClaimId = '#URL.ClaimId#'
</cfquery>

<cfif Len(Form.Remarks) gt 300>
    <cf_message message = "Sorry, you entered remarks that exceed the allowed size of 300 characters."
  	 return = "back">
	  <cfabort>
<cfelse>
     <cfset memo = "#Form.Remarks#">
</cfif>

<cf_wait1 Text="Saving your entries">


<cfset status = "1">	

<!--- saves the payment method --->
<cfinclude template="../ClaimEntry/ClaimEntrySubmitData.cfm">

<!--- eMail & remarks --->
<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Claim
	SET Remarks      = '#Form.Remarks#', 
	    eMailAddress = '#Form.EMailAddress#'
    WHERE ClaimId    = '#URL.ClaimId#'
</cfquery>

<!--- update eMail user account for future --->
<cfquery name="UpdateUserAccount" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE UserNames
	SET eMailAddress = '#Form.EMailAddress#'
    WHERE Account = '#SESSION.acc#'
	AND  (eMailAddress is NULL or eMailAddress = '')
</cfquery>

<!--- save the advance indicator --->

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

<cfquery name="Clear" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ClaimEventTripIndicator 
	WHERE IndicatorCode IN (SELECT Code FROM Ref_Indicator WHERE Category = 'Additional')
	AND   ClaimEventId IN (SELECT ClaimEventId 
	                       FROM ClaimEvent 
						   WHERE ClaimId = '#URL.ClaimId#') 
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
			  AND IndicatorCode IN (SELECT code 
			                        FROM Ref_Indicator 
									WHERE category = 'Additional')
		    </cfquery>	
	  	  
		 		  
	  </cfif>
		
</cfloop>

<!--- standard action to be included to determine if any section status would need to be reset as part of the submission action 
in this case it always reset the summary screen and final claim screen in case any change is made to the other screen. 
Reset = Default

Another example is for TCP : once you change Itinerary it needs to reset the Subsistence section in order to force users again 
ResetParent = CL02 Itinerary
--->


<cf_NavigationReset
     Alias         = "AppsTravelClaim"
	 Object        = "Claim" 
	 Group         = "TravelClaim" 
	 Reset         = "Default"
	 Id            = "#URL.ClaimId#">
	 
	
<!--- then update the navigation screen with default settings which means section is completed and hide the presentation of the button bar  --->

<cf_Navigation
	 Alias         = "AppsTravelClaim"
	 Object        = "Claim"
	 Group         = "TravelClaim" 
	 Section       = "#URL.Section#"
	 Id            = "#URL.ClaimId#"
	 OpenDirect    = "1"  <!--- attribute to ensure that the next section is included and loaded as part of this saving template --->
	 NextMode      = "1">

	 
	 	