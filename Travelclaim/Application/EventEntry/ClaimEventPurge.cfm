
<cfquery name="DeleteEvent" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimEvent
		 WHERE ClaimEventId = '#URL.EventID#'
</cfquery>

<cfquery name="DeleteDSA" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimLineDSA
		 WHERE ClaimId = '#URL.ID1#'
</cfquery>

<cfquery name="DeleteDSA" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimLineDateIndicator
		 WHERE ClaimId = '#URL.ID1#'
</cfquery>

<!--- correction hanno

<cfquery name="DeleteDSA" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM ClaimSection
		 WHERE ClaimId = '#URL.ID1#'
</cfquery>

--->

<cfoutput>
<script language="JavaScript">
    window.location = "ClaimEvent.cfm?reload=1&Code=0&Topic=legs&Section=CL02&Alias=AppsTravelClaim&Object=Claim&ClaimId=#url.id1#&id1="
</script>
</cfoutput>
  

