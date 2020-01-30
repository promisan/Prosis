
<cfsilent>

	<proUsr>administrator</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
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
