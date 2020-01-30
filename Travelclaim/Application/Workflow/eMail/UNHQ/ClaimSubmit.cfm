<cfobject action="create"
		type="java"
		class="coldfusion.server.ServiceFactory"
		name="factory">

<cfset dsService = factory.getDataSourceService()>
<cfset DataSources = dsService.getDatasources()>
<cfset DatabaseName = DataSources["appsTravelClaim"].URLMap.ConnectionProps.Database >
<cfset DatabaseServer = DataSources["appsTravelClaim"].URLMap.ConnectionProps.Host>

	<cfset db = "#DatabaseName#.dbo.">
	

<cfquery name="Claim" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      #db#Claim C INNER JOIN #db#stPerson P ON C.PersonNo = P.PersonNo
	WHERE     C.ClaimId = '#Object.ObjectKeyValue4#' 
</cfquery>	
 

<cfquery name="Request" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      #db#ClaimRequest 
	WHERE     ClaimRequestId = '#Claim.ClaimRequestId#'
</cfquery>	

<cfset mailsubject = "Travel Claim SUBMISSION - TCP #Claim.DocumentNo# against TVRQ #Request.DocumentNo# - #Claim.IndexNo# - #Claim.FirstName# #Claim.LastName#">

<cfoutput>
<cfsavecontent variable="mailtext">
<!---
<cf_screentop label="Confirmation"> 
--->
	<table width="100%" cellspacing="2" cellpadding="2">
	
	<tr><td>
		This is to confirm receipt of your claim (TCP No:#Claim.DocumentNo#) against Travel Request No: #Request.DocumentNo#
	</td></tr>
	<cfif Object.EntityClass eq "ClaimAsIs">
		<tr><td>Your claim has been pre-cleared for approval in IMIS.</td></tr>	
	
<!--- Add logic that checks if Object.EntityClass eq " ClaimAccount"
If so, text: Your claim has been forwarded to Accounts for review.
--->
   
    <cfelseif Object.EntityClass eq "ClaimAccount">
	<tr><td>Your claim has been forwarded to Accounts for review.</td></tr>	
	<cfelse>
		<tr><td>Your claim has been forwarded to your EO for certification.</td></tr>

	</cfif>
	<tr><td>
	You will be notified by email upon approval of your claim in IMIS, or if any further action on your part is required.
	</td></tr>
	</table>
	<!---
<cf_screenbottom>	
--->

</cfsavecontent>
</cfoutput>

<!--- end of template --->
