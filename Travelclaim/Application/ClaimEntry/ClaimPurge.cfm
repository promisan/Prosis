
<cfquery name="DeleteEvent" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimEvent
		 WHERE ClaimEventId = '#URL.EventID#'
</cfquery>

<cflocation url="ClaimEventEntry.cfm?PersonNo=#URL.PersonNo#&ID1=#URL.ID1#&ID2=#URL.ID2#">		  

