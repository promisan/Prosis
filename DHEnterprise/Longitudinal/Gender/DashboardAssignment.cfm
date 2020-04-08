
<cfinclude template="Header.cfm">
<cfset thisTemplate ="DashboardAssignment.cfm">
<cfinclude template = "determineMission.cfm">

	<cf_mobileRow>
		<cfset url.field="AssignmentTypeName">
		<cfset url.order="AssignmentType">
		<cfset url.name = "AssignmentTypeName">
		<cfset url.title = "By Assignment Type">
		<cfinclude template="doGraph.cfm">
		
		<cfif isDefined("doChart_gAssignmentTypeName")>
			<cfset vThisFunction = evaluate("doChart_gAssignmentTypeName")>
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
						<cfset url.columnField = "AssignmentType">
						<cfset url.columnDescription = "AssignmentTypeName">
						<cfset url.columnOrder = "AssignmentType">
						
						<cfset url.rowLabel = "Grade">
						
						<cfif url.seconded eq "1">
						   <cfset url.rowField 				= "#getParams.GenderField#">
						   <cfset url.rowDescription 		= "#getParams.GenderField#">
						   <cfset url.rowOrder 				= "#getParams.GenderField#Order">
						<cfelse>
						   <cfset url.rowField 				= "#getParams.CurrentField#">
						   <cfset url.rowDescription 		= "#getParams.CurrentField#">
						   <cfset url.rowOrder 				= "#getParams.CurrentField#Order">
						</cfif>
						
						<cfset url.queryCondition = "#vCondition#">
						<cfinclude template="CrossTable.cfm">
						
					</cf_mobileCell>
				</cf_mobilerow>
		</cf_MobilePanel>
	
	</cf_mobileRow>
	
	
	<cf_mobileRow>
		<cfset url.field="AssignmentTypeName">
		<cfset url.name ="AssignmentTypeName">
		<cfset url.order="AssignmentType">
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

	<cfif URL.showdivision eq "Yes">
	
		<cfquery name="getDivision" 
			datasource="martStaffing">		 
				SELECT MissionParent,MissionParentOrder
				FROM   Gender 
				WHERE  Mission = '#URL.Mission#'
				AND    Incumbency = '100'
				AND    MissionParent != ''
				AND    SelectionDate = '#URL.Date#'
				GROUP BY MissionParentOrder,
				         MissionParent
				ORDER BY MissionParentOrder		
		</cfquery>
	
		<cfset lFunctions = "">
		<cfset URL.mode = "">
		
		<!---if this is a mission, then show the children, otherwise it means is a children, why showing gran dchildren? ---->
		
		<cfif qMission.recordCount gte 1>
				
			<cfloop query="getDivision">

				<cf_mobileRow>
					
					<cfset url.field    = "AssignmentTypeName">
					<cfset url.name     = "AssignmentTypeName">
					<cfset url.order    = "AssignmentType">
					<cfset url.division = getDivision.MissionParent>
					<cfset url.column = "gender">
					
					<cfset url.title = "#URL.mission# / #getDivision.MissionParent#">
					<cfset url.id 	 = Left(getDivision.MissionParent,4)&"_"&getDivision.MissionParentOrder>
					<cfset lFunctions = "#lFunctions# doChart_g#Trim(url.id)#">
					<cfinclude template="doGraphMultiple.cfm">
					
					<cfif isDefined("doChart_g#Trim(url.id)#")>
						<cfset vThisFunction = evaluate("doChart_g#Trim(url.id)#")>
						<cfset AjaxOnLoad("function() { #vThisFunction# }")>
					</cfif>
				
				</cf_mobileRow>
				
			</cfloop>	 
			
		</cfif>
		
	</cfif>




	