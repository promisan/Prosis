<cfset url.scope = "none">

<cfinclude template="SettlementViewHeader.cfm">

<cfif url.scope neq "none">
	<cfif url.scope eq "settlement" or url.scope eq "standalone">
		<cfform id="salesdetails" name="salesdetails" method="POST" style="height:98%">		
			<cfinclude template="SettlementViewBody.cfm">
		</cfform>
	<cfelse>	
		<cfinclude template="SettlementViewBody.cfm">
	</cfif>
</cfif>	

