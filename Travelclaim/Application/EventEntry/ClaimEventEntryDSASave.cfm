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
	<proOwn>Dev van Pelt</proOwn>
	<proDes></proDes>
	<proCom></proCom>
	<proCM></proCM>
	<proInfo>
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	This template for saving the entries a user makes on the fly 
	for every click of the checkbox or dropdown box in the DSA screen at runtime
	It will replace the Submit method making the submit much faster 
	</td></tr>
	</table>
	</proInfo>

</cfsilent>

<cfquery name="Claim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM Claim R
    WHERE ClaimId = '#URL.ClaimId#'
</cfquery>

<cfquery name="Indicator" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Indicator
	WHERE   Code = '#url.Ind#'				 
</cfquery>	

<cfif Indicator.CheckExclusive eq "1">

	<cfquery name="Clear" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ClaimLineDateIndicator
	WHERE ClaimId  = '#URL.ClaimId#' 
	AND   PersonNo = '#URL.PersonNo#'
	AND   CalendarDate = '#url.date#'
	AND IndicatorCode IN (SELECT Code 
	                      FROM   Ref_Indicator 
						  WHERE  LineInterface = 'CheckBox' AND category = 'DSA')
	</cfquery>
	
</cfif>

<cfquery name="SetClaim" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Claim 
	SET ClaimAsIs = 0,
	    PointerClaimUpdated = getDate()
    WHERE ClaimId = '#URL.ClaimId#'
</cfquery>

<cfif Indicator.LineInterface eq "List">

	<!---
	 <cftry>
	 --->
						
	 <cfquery name="Update" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE ClaimLineDSA
		 SET LocationCode     = '#url.val#'
		 WHERE  ClaimId       = '#Url.claimid#' 
		 AND    PersonNo      = '#url.personno#'
		 AND    CalendarDate  = '#url.date#'
	 </cfquery>
	 
	 <!---
	 
	 <cfcatch></cfcatch>
			   
	 </cftry> 
	 --->
	 
</cfif>	 

<cfif url.val eq "" or url.val eq "false">
	
	<!--- day pointer --->
	<cfquery name="Clear" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM ClaimLineDateIndicator
	WHERE ClaimId  = '#URL.ClaimId#' 
	AND   PersonNo = '#URL.PersonNo#'
	AND   CalendarDate = '#url.date#'
	AND   IndicatorCode = '#url.ind#'
	</cfquery>
	
<cfelse>

	<cfif url.val eq "true">
	 <cfset val = "1">
	<cfelse>
	 <cfset val = url.val> 
	</cfif>

	<cftry>
	<!--- day pointer --->
	<cfquery name="Insert" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ClaimLineDateIndicator
	(ClaimId, PersonNo, CalendarDate, IndicatorCode, IndicatorValue, OfficerUserId, OfficerLastName, OfficerFirstName)
	VALUES
	('#URL.ClaimId#','#PersonNo#','#url.date#','#url.ind#','#val#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
	</cfquery>
	
	<cfcatch></cfcatch>
	</cftry>

</cfif>
