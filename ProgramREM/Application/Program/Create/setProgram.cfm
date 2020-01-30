
<!--- set the selected account --->

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT P.ProgramCode, 
			   P.ProgramName, 
			   P.ProgramClass, 
			   O.OrgUnitCode, 
			   O.OrgUnit, 
			   O.OrgUnitName, 
			   O.HierarchyCode
	    FROM   #CLIENT.LanPrefix#Program P, 
		       ProgramPeriod Pe,
			   Organization.dbo.Organization O
		WHERE P.ProgramCode   = Pe.ProgramCode
		AND   O.OrgUnit       = Pe.OrgUnit
		AND   ProgramId = '#url.programid#'
</cfquery>

<cfoutput>

<cfif url.orgunit neq "" and url.orgunit neq "undefined">

	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Organization
			WHERE  OrgUnit = '#url.programid#'
	</cfquery>
	
	<script>
	    document.getElementById("orgunit").value        = '#url.orgunit#';				
		document.getElementById("orgunitname").value    = '#org.orgunitname#';				
		document.getElementById("parentcode").value     = '#program.programcode#';				
		document.getElementById("parentcodename").value = '#program.programname#';			
	</script>	

<cfelse>

	<script>
    document.getElementById("orgunit").value        = '#program.orgunit#';				
	document.getElementById("orgunitname").value    = '#program.orgunitname#';				
	document.getElementById("parentcode").value     = '#program.programcode#';				
	document.getElementById("parentcodename").value = '#program.programname#';			
	</script>	


</cfif>

	

</cfoutput>