
<!--- passtru template --->

<cfparam name="url.systemfunctionid" default="">

<cfoutput>

<cfif URL.ID1 eq "Locate">

	<script language="JavaScript">		
	   window.location="EntitlementViewView.cfm?ts="+new Date().getTime() + "&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&systemfunctionid=#url.systemfunctionid#"
	</script>

<cfelse>

	<script language="JavaScript">	 
	   	window.location="EntitlementViewView.cfm?ts="+new Date().getTime()+"&Mission=#URL.Mission#&ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid=#url.systemfunctionid#"						 
	</script>

</cfif>

</cfoutput>

