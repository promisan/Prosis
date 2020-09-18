
<cfquery name="Purchase" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")>
<cfset mid = oSecurity.gethash()>  

<cfif Purchase.TreeVendor neq "">
	
	<cfoutput>
	<script>
		window.location = "../../../System/Organization/Application/OrganizationView.cfm?systemfunctionid=#url.systemfunctionid#&mode=limited&mission=#Purchase.TreeVendor#&mid=#mid#"
	</script>
	</cfoutput>

<cfelse>

<cf_screentop html="Yes" label="Vendor organization" layout="webapp">

<table align="center"><tr><td class="labellarge" style="padding-top:40px">Problem : No tree set for vendor administration</td></tr></table>

</cfif>
