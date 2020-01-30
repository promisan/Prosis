
<!--- main entry from the left menu --->

<script>

	function setorgunit(fld,org) {	    
	    ptoken.navigate('setOrgUnit.cfm?field='+fld+'&orgunit='+org,'process')	
	}
</script>

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  Pe.OrgUnit, 
        Pe.PeriodParentCode, 
        Pe.ProgramId,
        P.ProgramClass
FROM    Organization.dbo.Organization O, 
        ProgramPeriod Pe,
        Program P
WHERE   Pe.ProgramCode   = '#URL.EditCode#'
AND     Pe.OrgUnit       = O.OrgUnit
AND     Pe.ProgramCode   = P.ProgramCode
AND     Pe.Period        = '#URL.Period#'
</cfquery>

<cfset url.parentcode = Program.PeriodParentCode>
<cfset url.parentunit = Program.OrgUnit>
<cfset url.id         = Program.ProgramId>
<cfset url.refresh    = "0">
<cfset url.header     = "0">

<cfif Program.ProgramClass eq "Program">

	<cfinclude template="ProgramEntry.cfm">
	
<cfelseif Program.ProgramClass eq "Component">

	<cfinclude template="ComponentEntry.cfm">
	
<cfelse>

	<cfinclude template="ProjectEntry.cfm">

</cfif>