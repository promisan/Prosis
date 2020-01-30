
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


<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td height="20" valign="top"><cfinclude template="../../Template/Pivot.cfm"></td></tr>
<tr><td height="100%">

<cfif form.Xax neq "">

	<cfif xaxfld eq "Gender" or yaxfld eq "Gender" or xaxfld eq "Nationality" or yaxfld eq "Nationality">
	
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
		formula_1_L   = ""
		formula_1_C   = "count(DISTINCT PersonNo)"		
		formula_1_T   = "SUM"				
		mode          = "0"
		node          = "1">	
		
	<cfelse>
	
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
		formula_1_L   = "Inc"
		formula_1_C   = "count(DISTINCT PersonNo)"		
		formula_1_T   = "SUM"		
		formula_2_L   = "Vac"
		formula_2_C   = "COUNT(DISTINCT PositionNo) - COUNT(DISTINCT PersonNo)"		
		formula_2_T   = "SUM"		
		mode          = "0"
		node          = "1">		
		
	</cfif>	
	
</cfif>
		
</td></tr>
</table>


</cfoutput>  	