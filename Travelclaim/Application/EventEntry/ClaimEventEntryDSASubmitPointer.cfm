 <!--- clear prior entries --->
 
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