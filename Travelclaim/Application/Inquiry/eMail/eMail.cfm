
<cfset mail = "#Claim.eMailAddress#">

<cfif Claim.eMailAddress eq "">

	<cfquery name="Address" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM  Claim 
		WHERE PersonNo = '#Claim.PersonNo#' 
		AND eMailAddress is not NULL
		ORDER BY DocumentNo DESC
	</cfquery>
	
	<cfif Address.recordcount eq "1">
	
		<cfset mail = "#Address.eMailAddress#">
		

	<cfelse>
			
		<cfset mail = "#client.eMail#">
			
	</cfif>
	
</cfif>	

<cfif mail eq "None">

	<cfset mail = "">

</cfif>
