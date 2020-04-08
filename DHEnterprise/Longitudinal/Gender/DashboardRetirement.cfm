<cfinclude template="Header.cfm">
<cfset thisTemplate ="DashboardRetirement.cfm">
<cfinclude template = "determineMission.cfm">
		
	<cf_mobileRow>
		<cfset url.field     = "Year(DateRetirement)">
		<cfset url.order     = "Year(DateRetirement)">
		<cfset url.id        = "retire">
		<cfset url.Title     = "By Year"> 
		<cfset url.condition = "Retirement">
		<cfinclude template  = "doGraph.cfm">
	
		<cfif isDefined("doChart_g#URL.id#")>
			<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
			<cfset AjaxOnLoad("function() { #vThisFunction# }")>
		</cfif>
	
	</cf_mobileRow>
		
	<cf_mobileRow>
	
		<cfset url.field     =  "Year(DateRetirement)">
		<cfset url.order     =  "Year(DateRetirement)">
		<cfset url.title     =  "#url.qunit#">
		<cfset url.division  = "">
		<cfset url.condition = "Retirement">
		<cfset url.id        = "RetireGender">
		<cfset url.column    = "gender">
		
		<cfinclude template="doGraphMultiple.cfm">
		
		<cfif isDefined("doChart_g#URL.id#")>
			<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
			<cfset AjaxOnLoad("function() { #vThisFunction# }")>	
		</cfif>		
		
	</cf_mobileRow>
		

	<cfquery name="getGrade" 
		datasource="martStaffing">			
		 
		 	<cfif URL.Seconded eq "1">
			SELECT   Distinct GradeContract, GradeContractOrder			
			<cfelse>
			SELECT   Distinct PositionGrade, PositionGradeOrder	
			</cfif>
			FROM     Gender 
			WHERE    Mission = '#URL.Mission#'
			AND      Incumbency = '100'
			
			<cfif URL.Seconded eq "1">
			
				AND    AppointmentType NOT IN ('04')
				AND    ContractTerm NOT IN ('100','125','250')
				AND    PositionSeconded   = '0'
								
			<cfelseif URL.Seconded eq "5">
			
				AND    PositionSeconded   = '1'
				
			<cfelse>
			
			AND    1=1 <!--- all --->
			
			</cfif>					
			
			AND      MissionParent != ''
			AND      SelectionDate = '#URL.Date#'
			
			<cfif URL.Seconded eq "1">
			ORDER BY GradeContractOrder			
			<cfelse>
			ORDER BY  PositionGradeOrder	
			</cfif>
			
			
	</cfquery>

	<cfset cnt = 0>
	
	<cf_mobileRow>
		<cfloop query="getGrade">
			<cfset cnt++>
			<cf_mobileCell class="col-md-12">
				<cfset url.field       = "Year(DateRetirement)">
				<cfset url.order       = "Year(DateRetirement)">
				<cfif URL.Seconded eq "1">
					<cfset url.title       = "#url.qunit# #getGrade.GradeContract#">
					<cfset url.personGrade = "#getGrade.GradeContract#">
				<cfelse>
					<cfset url.title       = "#url.qunit# #getGrade.PositionGrade#">
					<cfset url.personGrade = "#getGrade.PositionGrade#">
				</cfif>
				<cfset url.division    = "">
				<cfset url.condition   = "DateRetirement">
				<cfset url.id          = "RetireGender#cnt#">
				<cfset url.column      = "gender">
				<cfset url.content     = "table">
				
				<cfinclude template="doGraphMultiple.cfm">
			</cf_mobileCell>
		</cfloop>
	</cf_mobileRow>
		
	
