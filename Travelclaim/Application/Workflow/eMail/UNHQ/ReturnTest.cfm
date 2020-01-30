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
<cfquery name="EmailSent" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

SELECT     B.documentno,B.Personno,b.orgunit,a.emaildate,PRSN.Fullname,A.emailaddress
FROM         #db#ClaimRequestMail A, #db#claimrequest B, #db#stperson PRSN
WHERE     (A.EMailDate <= getdate()) AND (A.EMailDate > dateadd(dd,-1,getdate()))
and A.claimrequestid = B.claimrequestid
and B.Personno = PRSN.personno

</cfquery>

<!---
<cfquery name="Return" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
	    FROM     #db#ClaimRequestItinerary
		WHERE    ClaimRequestId = '#ClaimRequestId#'
		ORDER BY DateReturn DESC
	</cfquery>
	--->
	<table width="96%" border="0" cellspacing="1" cellpadding="2" align="center">
	<!---
	<cfset mailsubject = "Travel Claim REMINDER - TVRQ #DocumentNo# - #IndexNo# - #Return.FirstName# #Return.LastName#">
	--->
	<cfoutput>
	
	<tr>
	  <td>
	Ensuring that Emails are getting sent from the E-mail Server
	</td>
	</tr>
	
	<tr><td><a href="#param.portalurl#?id=travelclaim">Click here to access the Travel Claim Portal</a></td></tr>
	
	</cfoutput>
	<cfoutput Query="EmailSent">
	<tr><td>
	TVRQ -Number #EmailSent.Documentno# </td>
	<td>Fullname 	#EmailSent.Fullname#</td>
	<td>Email Address #EmailSent.Emailaddress#</td>
	</tr>
	</cfoutput>
	
	</table>
