
<!--- check account --->

<cfoutput>

<cfif url.detected eq url.account>

<img src="#session.root#/images/checkmark.png" alt="" border="0" height="24">

<cfelse>

	<cfquery name="Check" 
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM   UserNames
			WHERE  Account = '#url.account#' 			
	</cfquery>
		
	<cfif check.recordcount eq "0" and len(url.account) gte 5>
	
		<img src="#session.root#/images/checkmark.png" alt="" border="0" height="24">
		
	<cfelse>
	
		<img src="#session.root#/images/stop.png" alt="" border="0" height="24">
		
	</cfif>
		
</cfif>

</cfoutput>		 