
<cfquery name="Delete" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_TransportTrack
		 WHERE TrackingId = '#URL.id2#'
</cfquery>

<cfset url.id2 = "">
<cfinclude template="List.cfm">
