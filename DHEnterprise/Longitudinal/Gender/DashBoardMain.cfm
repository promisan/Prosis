<cfset thisTemplate ="Dashboardmain.cfm">
<cfinclude template = "determineMission.cfm">

<cfinclude template="Header.cfm">

<cf_mobileRow>

	<cfquery name="qCheck" 
		datasource="HubEnterprise">		 
			SELECT *
			FROM   NOVA.dbo.ProgramTarget
			WHERE  Department = '#URL.Mission#'
			
	</cfquery>		
	
	
	<cfif qCheck.recordcount neq 0>
		<!---- Hanno, this is overwritten as if we use GradeContract then G3 for DppaDPO vanishes,   ----->
		
		<cfset vMode = Session.Gender["Mode"]> 
		<cfif url.seconded eq "1" > <!--- GENDER PARITY ---->
			<cfset url.field    = "#getParams.GenderField#">
			<cfset url.order    = "#getParams.GenderField#Order">
			<cfset url.id       = "#getParams.GenderField#">
		<cfelse>		<!---- Current Composition    ------>
			<cfset url.field    = "#getParams.CurrentField#">
			<cfset url.order    = "#getParams.CurrentField#Order">
			<cfset url.id       = "#getParams.CurrentField#">
		</cfif>
		
		<cfset url.title    = "">
		<cfset url.division = "">
		<cfset url.column   = "gender">
		<cfset url.content  = "table">
		<cfset url.mode     = "target">
		
		<cfinclude template="doComparison.cfm">
		
	<cfelse>
	
		You must define targets first to see this chart!
		
	</cfif>				
	
</cf_mobileRow>

<cfset AjaxOnLoad("function() { $('##btnExportExcel').on('click', function() { Prosis.exportToExcel('mainTable'); }); }")>
	
