
<!--- Query returning search results --->
<cfquery name="Delete" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM JobVendor
WHERE JobNo = '#URL.ID1#'
AND   OrgUnitVendor = '#URL.OrgUnit#'
</cfquery>

<cfinclude template="JobViewVendor.cfm">

<script>
   if (document.getElementById('fundingstatus')) {
	ColdFusion.navigate('JobFundingSufficient.cfm?id1=#url.id1#','fundingstatus')
	}
</script>


