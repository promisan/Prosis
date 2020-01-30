<cfsilent>
	 <proUsr>Joseph George</proUsr>
	  <proOwn>Joseph George</proOwn>
	 <proDes>Template for Return from Travel  </proDes>
	 <proCom>Changed it so that if no email address /record not found in system , pick up information from stperson table JG3 </proCom>
</cfsilent>
<cfobject action="create"
		type="java"
		class="coldfusion.server.ServiceFactory"
		name="factory">

<cfset dsService = factory.getDataSourceService()>
<cfset DataSources = dsService.getDatasources()>
<cfset DatabaseName = DataSources["appsTravelClaim"].URLMap.ConnectionProps.Database >
<cfset DatabaseServer = DataSources["appsTravelClaim"].URLMap.ConnectionProps.Host>

	<cfset db = "#DatabaseName#.dbo.">

<cfquery name="Param" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      #db#Parameter	
</cfquery>	

<cfquery name="Return" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
	    FROM     #db#ClaimRequestItinerary
		WHERE    ClaimRequestId = '#ClaimRequestId#'
		ORDER BY DateReturn DESC
	</cfquery>
	
	<table width="96%" border="0" cellspacing="1" cellpadding="2" align="center">
	<!---
	<cfset mailsubject = "Travel Claim REMINDER - TVRQ #DocumentNo# - #IndexNo# - #Return.FirstName# #Return.LastName#">
	--->
	<cfoutput>
	
	<tr><td>
	Our records show that you were due to return  on <b>#dateformat(Return.DateReturn, CLIENT.DateFormatShow)#</b> from the trip taken under Travel Request No <b>#DocumentNo#</b> .
	</td></tr>
		
	<tr><td>
	To expedite the processing of any outstanding entitlements or recoveries, kindly file your claim through the Travel Claim Portal as soon as possible.
	</td></tr>
	
	<tr><td>
	If the travel was cancelled , postponed or if the claim or  F10 has already been submitted, please contact your Executive Office.
	</td></tr>
	
	<tr><td><a href="#param.portalurl#?id=travelclaim">Click here to access the Travel Claim Portal</a></td></tr>
	
	</cfoutput>
	
	</table>
