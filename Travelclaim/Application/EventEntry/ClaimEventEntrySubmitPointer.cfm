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
 <cfparam name="tripid" default="">
 
 <cfif tripid neq "">
 
 	 <cfquery name="CheckEvent" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT     *
		 FROM       ClaimEventTrip T INNER JOIN
                    Ref_ClaimEvent E ON T.EventCode = E.Code
		 WHERE     (T.ClaimTripId = '#tripid#')
	 </cfquery>
	  
	 <cfquery name="EventIndicator" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_Indicator 
		  WHERE  Category IN (#preserveSingleQuotes(Category)#)	
	 </cfquery>
			  	  
	 <cfloop query="EventIndicator">
		  
	     <cfparam name="Form.#fld##Code#" default=""> 
			  
		 <cfset ind = Evaluate("Form.#fld##Code#")>
			  
		 <cfif ind neq "" 
		      or CheckEvent.PointerTransport eq "1">		  
		 
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
  
</cfif>  