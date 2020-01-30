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
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
select * from claim where actionstatus ='3'

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
	Something could have gone wrong with Merge Process
	</td>
	</tr>
	
	<tr><td><a href="#param.portalurl#?id=travelclaim">Click here to access the Travel Claim Portal</a></td></tr>
	
	</cfoutput>
	<cfoutput Query="EmailSent">
	<tr><td>
	TCP Documentno  #EmailSent.Documentno# </td>
	<td>PersonNo	#EmailSent.Personno#</td>
	<td>Firstname 	#EmailSent.OfficerFirstname#</td>
	<td>Officer Lastname #EmailSent.OfficerLastname#</td>
	</tr>
	</cfoutput>
	
	</table>
