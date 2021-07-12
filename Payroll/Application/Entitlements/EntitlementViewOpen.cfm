
<!--- passtru template --->

<cfparam name="url.systemfunctionid" default="">

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfif URL.ID1 eq "Locate">

	<script language="JavaScript">		
	   window.location = 'EntitlementViewView.cfm?ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&systemfunctionid=#url.systemfunctionid#&mid=#mid#'
	</script>

<cfelse>

	<script language="JavaScript">	 
	   	window.location = 'EntitlementViewView.cfm?Mission=#URL.Mission#&ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid=#url.systemfunctionid#&mid=#mid#'						 
	</script>

</cfif>

</cfoutput>

