
<!--- define period from start to end (dates) --->

<cfquery name="Period"
 datasource="appsTravelClaim" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT  DISTINCT 
			MIN(ClaimTripDate) as Start,
    	    Max(ClaimTripDate) as Expiration 		    
	FROM    ClaimEvent Ev,
            ClaimEventTrip T, 
            ClaimEventPerson P
	WHERE   T.ClaimEventId = P.ClaimEventId
	AND     P.PersonNo = '#PersonNo#'
	AND     Ev.ClaimId = '#URL.ClaimId#'
	AND     Ev.ClaimEventId = T.ClaimEventId   
</cfquery>

