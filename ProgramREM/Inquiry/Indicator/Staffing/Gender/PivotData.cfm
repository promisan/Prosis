
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
		XaxTbl        = "" 
		XaxFld        = "#XaxFld#"
		XaxOrd        = "#XaxOrd#"
		YaxLbl        = "#YaxLbl#"
		YaxTbl        = ""
		YAxFld        = "#YaxFld#"
		YaxOrd        = "#YaxOrd#"
		formula_1_L   = "M"
		formula_1_C   = "COUNT(CASE Gender WHEN 'M' THEN 1 END)"		
		formula_1_T   = "SUM"		
		formula_2_L   = "F"
		formula_2_C   = "COUNT(CASE Gender WHEN 'F' THEN 1 END)"		
		formula_2_T   = "SUM"		
		mode          = "0"
		node          = "1">	
	
</cfif>
		
</td></tr>
</table>

</cfoutput>  	