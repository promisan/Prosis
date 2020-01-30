

<!--- perform a script --->

<cfquery name="Event" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ClaimEvent
	WHERE Code = '#URL.Code#'   
</cfquery>	

<cfif event.pointertransport eq "1">
 <cfset m = "hide">
<cfelse>
 <cfset m = "regular"> 
</cfif> 

<cfoutput>

<script>
	se = document.getElementsByName("#url.box#")
	count = 0
	while (se[count]) {
	   se[count].className = "#m#"
	   count++
	}
</script>

</cfoutput>