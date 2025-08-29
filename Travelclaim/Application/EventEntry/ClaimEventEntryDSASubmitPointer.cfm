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
<cfquery name="Clean" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    DELETE FROM ClaimEventTripIndicator
    WHERE     ClaimTripId IN
                  (SELECT  Tr.ClaimTripId
                   FROM    ClaimEvent Ev INNER JOIN
                           ClaimEventTrip Tr ON Ev.ClaimEventId = Tr.ClaimEventId
                   WHERE   Ev.ClaimId = '#URL.ClaimId#')
	AND       IndicatorCode IN (SELECT Code 
	          	    	        FROM Ref_Indicator 
								WHERE Category IN (SELECT Code 
					                               FROM Ref_IndicatorCategory 
												   WHERE ClaimSection = #preserveSingleQuotes(ClaimSection)#)
								   OR Category = 'SameDay'
							   )  
												   
												   
											   
</cfquery>				
 
 <cfquery name="Trip" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 *
        FROM    ClaimEvent Ev INNER JOIN
                ClaimEventTrip Tr ON Ev.ClaimEventId = Tr.ClaimEventId
        WHERE   Ev.ClaimId = '#URL.ClaimId#'
 </cfquery>	
  
 <cfquery name="EventIndicator" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT *
    FROM   Ref_Indicator R
    WHERE  R.Category IN (SELECT Code 
	                      FROM Ref_IndicatorCategory 
						  WHERE ClaimSection = #preserveSingleQuotes(ClaimSection)#)
	  OR R.Category = 'SameDay'					  
 </cfquery>
	  	  
 <cfloop query="EventIndicator">
	  
    <cfparam name="Form.#fld##Code#" default=""> 
		  
	  <cfset ind    = Evaluate("Form.#fld##Code#")>
		  
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
			  VALUES ('#Trip.ClaimEventId#',
			          '#Trip.ClaimTripId#', 
			          '#Code#',
			          '1')
		  </cfquery>	
		  
	  </cfif>
		   
  </cfloop> 