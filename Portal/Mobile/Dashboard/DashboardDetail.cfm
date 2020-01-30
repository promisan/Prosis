<cfquery name="getSections" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT  S.*,
				ISNULL((
					SELECT  COUNT(*)
					FROM    Ref_ModuleControlSectionCell
					WHERE	SystemFunctionId = S.SystemFunctionId
					AND		FunctionSection = S.FunctionSection
				), 0) as CellCount
		FROM    Ref_ModuleControlSection S
		WHERE	S.SystemFunctionId = '#url.systemfunctionId#'
		ORDER BY S.ListingOrder ASC
</cfquery>

<cf_mobileRow>

	<cfoutput query="getSections">

		<cf_mobileCell class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
		
			<cfset vBodyClass = "list">
			<cfif CellCount eq 1>
				<cfset vBodyClass = "text-center h-200">
			</cfif>
		
			<cf_tl id="As of" var="lastUpdateLabel">
			<cf_MobilePanel 
				panelClass = "hgreen stats"
				footer = "#lastUpdateLabel#: #dateFormat(now(), client.dateFormatShow)# #timeFormat(now(), 'hh:mm:ss tt')#"
				bodyClass = "#vBodyClass#">
				
				<cfif CellCount eq 1>
				
					<i class="#SectionIcon#"></i>
					
					<cfinclude template="DashboardDetailCell.cfm">
					
					<br>
					<h3 class="font-extra-bold no-margins text-success" style="font-size:20px;">
						#SectionName#
					</h3>
					
					<small>#SectionMemo#</small>
				
				</cfif>
				
				<cfif CellCount eq 0 or CellCount gt 1>
				
					<div class="stats-title pull-left">
						<h4 style="font-size:20px;">#SectionName#</h4>
					</div>
					
					<div class="stats-icon pull-right">
						<i class="#SectionIcon#"></i>
					</div>
					
					<div class="m-t-xl">
						<small>#SectionMemo#</small>
					</div>
					
					<cfinclude template="DashboardDetailCell.cfm">
				
				</cfif>
				
			</cf_MobilePanel>
		
		</cf_mobileCell>
		
	</cfoutput>
	
</cf_mobileRow>