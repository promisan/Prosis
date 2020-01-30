
<cf_compression>

<cfquery name="get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    ProgramPeriod
WHERE   ProgramId = '#url.id#'
</cfquery>

<cfif get.Status eq "1">

	<script>history.go()</script>

</cfif>
