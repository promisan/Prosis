
<cfinclude template="../../Template/IndicatorTarget.cfm">

<cfoutput>
<cfsavecontent variable="Where">
     AND    Mission        = '#Target.OrgUnitCode#' 
	 AND    SelectionDate  = '#Audit.AuditDate#' 
	 <cfif indicator.IndicatorCriteriaBase neq "">
	 AND    #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
	 </cfif>
	 #preservesingleQuotes(OrgFilter)#
	 <cfif url.item neq "">
	 AND     #URL.Item#      = '#URL.Select#'	
	 </cfif>
	 #preserveSingleQuotes(client.programgraphfilter)#		
</cfsavecontent>	

<table width="100%" cellspacing="0" cellpadding="0">
<tr><td><cfinclude template="../../Template/Pivot.cfm"></td></tr>
<tr><td>

<cfif form.Xax neq "">
	
	<cf_PivotPrepare
	    Alias         = "AppsProgram"
		Base          = "EmployeeSnapshot.dbo.HRPO_AppStaffingDetail" 
		Condition     = "#Where#"
		XaxLbl        = "#XaxLbl#"
		XaxFld        = "#XaxFld#"
		XaxOrd        = "#XaxOrd#"
		YaxLbl        = "#YaxLbl#"
		YAxFld        = "#YaxFld#"
		YaxOrd        = "#YaxOrd#"
		formula_1_L   = "Loc"
		formula_1_C   = "count(DISTINCT PositionNo)"		
		formula_1_T   = "SUM"				
		mode          = "0"
		node          = "1">	
	
</cfif>
	
</td></tr>
</table>
</cfoutput>  	