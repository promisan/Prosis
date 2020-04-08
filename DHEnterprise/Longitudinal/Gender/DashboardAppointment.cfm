<cfinclude template="Header.cfm">
<cfset thisTemplate ="DashboardAppointment.cfm">
<cfinclude template = "determineMission.cfm">
<cfif URL.showdivision eq "No">

	<cf_mobileRow>
		<cfset url.title = "By Appointment Type">
		<cfset url.field="AppointmentTypeName">
		<cfset url.order="AppointmentTypeName">
		<cfinclude template="doGraph.cfm">
		
		<cfif isDefined("doChart_gAppointmentTypeName")>
			<cfset vThisFunction = evaluate("doChart_gAppointmentTypeName")>
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
						
						<cfset url.columnLabel = "Type">
						<cfset url.columnField = "AppointmentTypeName">
						<cfset url.columnDescription = "AppointmentTypeName">
						<cfset url.columnOrder = "AppointmentTypeName">
						
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
		<cfset url.field="AppointmentTypeName">
		<cfset url.order="AppointmentTypeName">
		<cfset url.title = "#url.qunit#">
		<cfset url.division = "">
		<cfset url.id = "Overall">
		<cfset url.column = "gender">
		<cfinclude template="doGraphMultiple.cfm">
		
		<cfif isDefined("doChart_g#URL.id#")>
			<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
			<cfset AjaxOnLoad("function() { #vThisFunction# }")>	
		</cfif>
	</cf_mobileRow>	

<cfelse>

	<cfquery name="getDivision" 
		datasource="martStaffing">		 
			SELECT   MissionParentOrder,MissionParent
			FROM     Gender 
			WHERE    Mission = '#URL.Mission#'
			AND      Incumbency = '100'
			AND      MissionParent != ''
			AND      SelectionDate = '#URL.Date#'
			GROUP BY MissionParentOrder,
			         MissionParent
			ORDER BY MissionParentOrder		
	</cfquery>

	<cfset lFunctions = "">
	<cfset URL.mode = "">
	
	<cfloop query="getDivision">
		
		<cf_mobileRow>
			
			<cfset url.field    = "AppointmentType">
			<cfset url.order    = "AppointmentType">
			<cfset url.division = getDivision.Division>
			<cfset url.column = "gender">
			
			<cfset url.title = "#URL.mission# / #getDivision.Division#">
			<cfset url.id 	 = Left(getDivision.MissionParent,4)&"_"&getDivision.MissionParentOrder>
			<cfset lFunctions = "#lFunctions# doChart_g#Trim(url.id)#">
			<cfinclude template="doGraphMultiple.cfm">
			
			<cfif isDefined("doChart_g#getDivision.Division#")>
				<cfset vThisFunction = evaluate("doChart_g#getDivision.Division#")>
				<cfset AjaxOnLoad("function() { #vThisFunction# }")>
			</cfif>
		
		</cf_mobileRow>
		
	</cfloop>	 
	
</cfif>




	