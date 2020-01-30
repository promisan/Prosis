<cfquery name="getClass" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ScheduleClass
		ORDER BY ListingOrder ASC
</cfquery>

<cfset vScheduleClass = url.selectedScheduleClass>

<cfif url.ScheduleId eq "">

	<cfquery name="getDefaultClass" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM   	WorkSchedule
			WHERE	Code = '#url.workSchedule#' 
	</cfquery>
	<cfset vScheduleClass = getDefaultClass.ScheduleClass>
	
</cfif>

<!-- <cfform name="dummy"> -->


<cfselect 
	name="ScheduleClass" 
	id="ScheduleClass" 
	query="getClass" 
	display="Description" 
	value="Code" 
	selected="#vScheduleClass#" 
	class="regularxl" 
	queryposition="below">
	<option value="">
</cfselect>

<!-- </cfform> -->