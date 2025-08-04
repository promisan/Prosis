<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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