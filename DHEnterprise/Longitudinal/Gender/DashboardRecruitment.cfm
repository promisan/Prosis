<cfinclude template="Header.cfm">

<cfif URL.showdivision eq "No">


	<cf_mobileRow>
		<cfset url.field       = "JobOpeningClass">
		<cfset url.order       = "JobOpeningClass">
		<cfset url.source      = "Recruitment">
		<cfset url.title       = "By recruitment type #dateformat(URL.Date,'YYYY')#">
		<cfset url.countoption = "DISTINCT JobOpeningId">
		
		<cfinclude template    = "doGraph.cfm">
		
		<cfif isDefined("doChart_gRecruitment")>
			<cfset vThisFunction = evaluate("doChart_gRecruitment")>
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

						<cfset url.queryTable = "Recruitment">
						<cfset url.columnLabel = "Class">
						<cfset url.columnField = "JobOpeningClass">
						<cfset url.columnDescription = "JobOpeningClass">
						<cfset url.columnOrder = "JobOpeningClass">
						
						<cfset url.rowLabel = "Grade">
						<cfset url.rowField = "PostGrade">
					    <cfset url.rowDescription = "PostGrade">
					    <cfset url.rowOrder = "PostGradeOrder">
						
						<cfset url.countoption = "DISTINCT JobOpeningId">
						
						<cfset url.queryCondition = "#vCondition#">
						<cfinclude template="CrossTable.cfm">
						
					</cf_mobileCell>
				</cf_mobilerow>
		</cf_MobilePanel>
	
	</cf_mobileRow>

	<cf_mobileRow>
		<cfset url.field       = "JobOpeningClass">
		<cfset url.order       = "JobOpeningClass">
		<cfset url.source      = "Recruitment">
		<cfset url.title       = "Applicants by Gender #dateformat(URL.Date,'YYYY')#">
		<cfset url.division    = "">
		<cfset url.id          = "ByGender">
		<cfset url.column      = "gender">
		<cfset url.countoption = "1">
		<!--- <cfset url.countoption = "DISTINCT PersonNo"> --->
		<cfset url.content     = "details">
		<cfset url.showDetail  = "0">

		<cfinclude template="doGraphMultiple.cfm">

		<cfif isDefined("doChart_g#URL.id#")>
			<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
			<cfset AjaxOnLoad("function() { #vThisFunction# }")>
		</cfif>
			
	</cf_mobileRow>

	<cfquery name="getCategory" 
		datasource="martStaffing">		 
		SELECT  DISTINCT JobOpeningClass
		FROM    Recruitment
		WHERE   JobOpeningClass IN ('Job Opening','Temporary Job Opening')
		AND     Mission = '#URL.Mission#'
	</cfquery>
				
	<cfloop query="getCategory">	
	
		<cf_mobileRow>
			<cfset url.field       = "PresentationLevel">
			<cfset url.order       = "PresentationLevel">
			<cfset url.source      = "RecruitmentStage">
			<cfset url.title       = "Applicants by Stage #getCategory.JobOpeningClass# #dateformat(URL.Date,'YYYY')#">
			<cfset url.division    = "">
			<cfset url.id          = "#Left(getCategory.JobOpeningClass,3)#">
			<cfset url.column      = "gender">
			<cfset url.countoption = "1">
			<cfset url.category    = "#getCategory.JobOpeningClass#">
			<cfset url.content     = "split">
			<cfset url.total       = "No">
			<cfset url.showDetail  = "0">
	
			<cfinclude template="doGraphMultiple.cfm">
			
			<cfif isDefined("doChart_g#URL.id#")>
				<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
				<cfset AjaxOnLoad("function() { #vThisFunction# }")>	
			</cfif>
			
		</cf_mobileRow>
		
	</cfloop>	

<cfelse>

	<cfquery name="getCategory" 
		datasource="martStaffing">		 
		SELECT  DISTINCT JobOpeningClass
		FROM    Recruitment
		WHERE   JobOpeningClass IN ('Job Opening','Temporary Job Opening')
		AND     Mission = '#URL.Mission#'
	</cfquery>
	
	<cfset cnt_graph = 0>
		
	<cfloop query="getCategory">
	
		<cfset cnt_graph++>
			
		<cf_mobileRow>
			<cfset url.field       = "PostGrade">
			<cfset url.order       = "PostGradeOrder">
			<cfset url.source      = "Recruitment">
			<cfset url.title       = "Applicants #getCategory.JobOpeningClass# #dateformat(URL.Date,'YYYY')#">
			<cfset url.division    = "">
			<cfset url.id          = "app#cnt_graph#">
			<cfset url.column      = "gender">
			<cfset url.countoption = "DISTINCT PersonNo">
			<cfset url.category    = "#getCategory.JobOpeningClass#">
			<cfset url.content     = "details">
	
			<cfinclude template="doGraphMultiple.cfm">
			
			<cfif isDefined("doChart_g#URL.id#")>
				<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
				<cfset AjaxOnLoad("function() { #vThisFunction# }")>	
			</cfif>
			
		</cf_mobileRow>

		<cf_mobileRow>
			
			<cfset url.field       = "JobFamily">
			<cfset url.order       = "JobFamily">
			<cfset url.source      = "Recruitment">
			<cfset url.title       = "Applicants by Disposition #getCategory.JobOpeningClass# / Occupational Group / #dateformat(URL.Date,'YYYY')#">
			<cfset url.division    = "">
			<cfset url.id          = "occ#cnt_graph#">
			<cfset url.column      = "gender">
			<cfset url.countoption = "DISTINCT PersonNo">
			<cfset url.category    = "#getCategory.JobOpeningClass#">
			<cfset url.content     = "details">
			<cfset url.total       = "No">
	
			<cfinclude template="doGraphMultiple.cfm">
			
			<cfif isDefined("doChart_g#URL.id#")>
				<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
				<cfset AjaxOnLoad("function() { #vThisFunction# }")>	
			</cfif>
			
		</cf_mobileRow>

	</cfloop>	
	
</cfif>




	