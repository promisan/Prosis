
<!--- set the selected account --->

<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
	FROM   Organization
	WHERE  OrgUnit = '#URL.orgunit#'
</cfquery>

<cfoutput>
		
	<script>
		document.getElementById("orgunit1").value        = '#get.OrgUnit#'		
		document.getElementById("orgunitname1").value    = '#get.OrgUnitName#'
		document.getElementById("orgunitcode1").value    = '#get.OrgUnitCode#'
		document.getElementById("orgunitclass1").value   = '#get.OrgUnitClass#'
		document.getElementById("mission1").value        = '#get.Mission#'
		//  document.getElementById("mandateno").value      = '#get.MandateNo#'		
	</script>	

</cfoutput>