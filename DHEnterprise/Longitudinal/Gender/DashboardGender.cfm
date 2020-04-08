<cfinclude template="Header.cfm">
<cfset thisTemplate ="DashboardGender.cfm">
<cfinclude template = "determineMission.cfm">

<cfif URL.showdivision eq "no">

	<cf_mobileRow>
		<cfset url.field    = "Gender">
		<cfset url.order    = "Gender">
		<cfset url.title    = "">
		<cfinclude template = "doGraph.cfm">
	
		<cfif isDefined("doChart_g#URL.field#")>
			<cfset vThisFunction = evaluate("doChart_g#URL.field#")>
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
						
						<cfset url.columnLabel = "Gender">
						<cfset url.columnField = "Gender">
						<cfset url.columnDescription = "Gender">
						<cfset url.columnOrder = "Gender">
						<cfset url.rowLabel = "Grade">
						
						<!--- Anonymous version ---->
						<cfif url.seconded eq "1">
						   <cfset url.rowField 			= "#getParams.GenderField#">
						   <cfset url.rowDescription 	= "#getParams.GenderField#">
						   <cfset url.rowOrder 			= "#getParams.GenderField#ORder">
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
	
		<cfif url.seconded eq "1"> <!-----gender parity ------>
			<cfset url.field    	= "#getParams.GenderField#">
			<cfset url.order    	= "#getParams.GenderField#Order">
			<cfset url.orderType    = "Integer">
		<cfelse>
			<cfset url.field    	= "#getParams.CurrentField#">
			<cfset url.order    	= "#getParams.CurrentField#Order">
			<cfset url.orderType    = "Integer">
		</cfif>
		<cfset url.title    = "">
		<cfset url.division = "">
		<cfset url.id       = "PersonGrade">
		
		<cfset url.column   = "gender">
		
		<cfif url.seconded eq "1">
			<cfset url.mode     = "target">
		<cfelse>
			<cfset url.mode     = "">
		</cfif>
		
		<cfinclude template="doGraphMultiple.cfm">
		
		<cfif isDefined("doChart_g#URL.id#")>
			<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
			<cfset AjaxOnLoad("function() { #vThisFunction# }")>	
		</cfif>		
		
	</cf_mobileRow>

	<cf_mobileRow>
		<cfset url.field    = "MissionParent">
		<cfset url.order    = "MissionParentOrder">
		<cfset url.title    = "">
		<cfset url.division = "">
		<cfset url.id       = "MissionParent">
		<cfset url.column   = "gender">
		<cfset url.mode     = "">
		
		<cfinclude template = "doGraphMultiple.cfm">
		
		<cfif isDefined("doChart_g#URL.id#")>
			<cfset vThisFunction = evaluate("doChart_g#URL.id#")>
			<cfset AjaxOnLoad("function() { #vThisFunction# }")>	
		</cfif>
		
	</cf_mobileRow>

<cfelse>  <!----show division  ------>

	<cfquery name="getDivision" 
		datasource="martStaffing">		 
			SELECT   MissionParentOrder,MissionParent
			FROM     Gender 
			WHERE    Mission        = '#URL.Mission#'
			AND      Incumbency     = '100'
			AND      MissionParent != ''
			AND      SelectionDate = '#URL.Date#'
			GROUP BY MissionParentOrder,
			         MissionParent
			ORDER BY MissionParentOrder		
	</cfquery>

	<cfset lFunctions = "">
	<cfset URL.mode = "">
	<cfset url.cntTotalTimes = "#getDivision.recordCount#">
	<cfset url.cntThisTime	 = "1">
	<cfset url.contentResults= "0">
	<cfloop query="getDivision">
		
		<cf_mobileRow>
				
			<cfif url.seconded eq "1">
				<cfset url.field    	= "#getParams.GenderField#">
				<cfset url.order    	= "#getParams.GenderField#Order">
				<cfset url.orderType    = "Integer">
			<cfelse>
				<cfset url.field    	= "#getParams.CurrentField#">
				<cfset url.order    	= "#getParams.CurrentField#Order">
				<cfset url.orderType    = "Integer">
			</cfif>
						
			<cfset url.division  = getDivision.MissionParent>
			<cfset url.column    = "gender">
			
			
			<cfset url.title     = "#getDivision.MissionParent#">
			<cfset url.id 	     = Left(getDivision.MIssionParent,4)&"_"&getDivision.MissionParentOrder>
			<cfset lFunctions    = "#lFunctions# doChart_g#Trim(url.id)#">
			
			<cfinclude template  = "doGraphMultiple.cfm">
			
			<cfif isDefined("doChart_g#URL.id#")>
				<cfset vThisFunction = evaluate("doChart_g#url.id#")>
				<cfset AjaxOnLoad("function() { #vThisFunction# }")>
			</cfif>
		
		</cf_mobileRow>
		<cfset url.cntThisTime	 = url.cntThisTime + 1>
	</cfloop>	 
	
</cfif>	
