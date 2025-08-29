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

<!--- Dev 15/12/2008 I removed submission code for checkboxes as this is saved on the fly --->

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