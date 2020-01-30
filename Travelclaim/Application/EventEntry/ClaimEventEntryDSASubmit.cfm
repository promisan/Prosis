
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>"> 

<cf_NavigationReset
     Alias          = "AppsTravelClaim"
	 Object         = "Claim" 
	 Group          = "TravelClaim" 
	 Reset          = "Default"
	 Id             = "#URL.ClaimId#">

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM Claim R
    WHERE ClaimId = '#URL.ClaimId#'
</cfquery>

<cfquery name="SetClaim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Claim 
	SET    ClaimAsIs = 0,
	       PointerClaimUpdated = getDate()
    WHERE  ClaimId = '#URL.ClaimId#'
</cfquery>

<!--- overall claim pointers --->
<cfset fld          = "">	
<cfset claimsection = "'Subsistence'">	 
<cfinclude template = "ClaimEventEntryDSASubmitPointer.cfm">	

<!--- Hanno 15/12/2008 I removed submission code for checkboxes as this is saved on the fly --->

<cf_Navigation
	 Alias         = "AppsTravelClaim"
	 Object        = "Claim"
	 Group         = "TravelClaim" 
	 Section       = "#URL.Section#"
	 Id            = "#URL.ClaimId#"
	 BackEnable    = "0"
	 HomeEnable    = "0"
	 SetNext       = "1"
	 OpenDirect    = "1"
	 NextMode      = "1">	