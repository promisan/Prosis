
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
		document.getElementById("orgunit").value        = '#get.OrgUnit#'		
		document.getElementById("orgunitname").value    = '#get.OrgUnitName#'
		document.getElementById("orgunitcode").value    = '#get.OrgUnitCode#'
		document.getElementById("orgunitclass").value   = '#get.OrgUnitClass#'
		document.getElementById("mission").value        = '#get.Mission#'
		document.getElementById("mandateno").value      = '#get.MandateNo#'		
	</script>	

</cfoutput>