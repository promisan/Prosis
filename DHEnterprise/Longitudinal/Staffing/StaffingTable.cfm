<cfset url.showDivision = "1">

<cfswitch expression="#url.id#">

	<cfcase value="Main">	
		<cfset vTemplate = "StaffingTableDetail.cfm">	
	</cfcase>

	<cfcase value="Grd">	
		<cfset vTemplate = "GradesTypes.cfm">	
	</cfcase>
	
	<cfcase value="Vac">	
		<cfset vTemplate = "Vacancy.cfm">	
	</cfcase>
	
	<cfcase value="App">	
		<cfset vTemplate = "Appointment.cfm">	
	</cfcase>
	
</cfswitch>

<cfif url.id neq "Main">
	<cfinclude template="Filters.cfm">
</cfif>

<div id="statsDetail">
	<cfinclude template="#vTemplate#">
</div>	
