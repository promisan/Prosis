<cfinclude template="Header.cfm">
<cfset thisTemplate ="DashboardAge.cfm">
<cfinclude template = "determineMission.cfm">
		
<cf_mobileRow>
	
	<cfset url.field="AgeCluster">
	<cfset url.order="AgeCluster">
	<cfset url.title="By Age bracket">
	<cfset url.content="table">
	<cfinclude template="doGraph.cfm">

	<cfif isDefined("doChart_gAgeCluster")>
		<cfset vThisFunction = evaluate("doChart_gAgeCluster")>
		<cfset AjaxOnLoad("function() { #vThisFunction# }")>
	</cfif>

</cf_mobileRow>

<cf_mobileRow>

	<cf_MobilePanel 
		bodyClass = "h-200"
		bodyStyle = "font-size:80%;"
		panelClass = "stats hgreen">
			
			<cf_mobilerow>
				<cf_mobileCell class="col-md-12">
					
					<cfset url.columnLabel = "Age Bracket">
					<cfset url.columnField = "AgeCluster">
					<cfset url.columnDescription = "AgeCluster">
					<cfset url.columnOrder = "AgeCluster">
					
					<cfset url.rowLabel = "Grade">
					
					<cfif url.seconded eq "1">
					   <cfset url.rowField 			= "#getParams.GenderField#">
					   <cfset url.rowDescription 	= "#getParams.GenderField#">
					   <cfset url.rowOrder 			= "#getParams.GenderField#Order">
					<cfelse>
					   <cfset url.rowField 			= "#getParams.CurrentField#">
					   <cfset url.rowDescription 	= "#getParams.CurrentField#">
					   <cfset url.rowOrder 			= "#getParams.CurrentField#Order">
					</cfif>
					
					<cfset url.queryCondition = "#vCondition#">
					<cfinclude template="CrossTable.cfm">
					
				</cf_mobileCell>
			</cf_mobilerow>
	</cf_MobilePanel>

</cf_mobileRow>

<cf_mobileRow>
	<cfset url.field="AgeCluster">
	<cfset url.order="AgeCluster">
	<cfset url.title = "#url.qunit#">
	<cfset url.division = "">
	<cfset url.id = "PersonGrade">
	<cfset url.column = "gender">
	
	<cfinclude template="doGraphMultiple.cfm">
	
	<cfif isDefined("doChart_g#URL.id#")>
		<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
		<cfset AjaxOnLoad("function() { #vThisFunction# }")>	
	</cfif>
	
</cf_mobileRow>
