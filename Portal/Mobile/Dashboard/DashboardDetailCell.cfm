
<cfquery name="getCells" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		SELECT  *
		FROM    Ref_ModuleControlSectionCell
		WHERE	SystemFunctionId = '#url.systemfunctionId#'
		AND		FunctionSection = '#FunctionSection#'
</cfquery>

<cfif getCells.recordCount eq 1>
	<cfoutput query="getCells">
	
		<cfinclude template="DashboasrDetailCellPreparation.cfm">
		
		<h1 class="m-xs">#vCellResultString#</h1>
		<div class="font-bold">
			#CellLabel#
		</div>
	</cfoutput>
</cfif>

<cfif getCells.recordCount gt 1>

	<cfset vCols = 2>
	<cfset vCnt = 0>

	<div class="row m-t-md">
	
		<cfoutput query="getCells">
		
			<cfinclude template="DashboasrDetailCellPreparation.cfm">
		
			<div class="col-lg-6 animated-panel zoomIn" style="animation-delay: 0.5s;">
				<h3 class="no-margins font-extra-bold text-success">#vCellResultString#</h3>
				<div class="font-bold">
					#CellLabel#
				</div>
			</div>
			
			<cfset vCnt = vCnt + 1>
			<cfif vCnt eq vCols>
				<cfset vCnt = 0>
				</div>
				<div class="row m-t-md">
			</cfif>
		
		</cfoutput>
		
	</div>
</cfif>

