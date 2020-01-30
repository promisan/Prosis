
<cfinclude template="../../Template/IndicatorTarget.cfm">

<cfoutput>
<cfsavecontent variable="Where">
	AND       Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND       (#preserveSingleQuotes(indicator.IndicatorCriteriaBase)#)
	</cfif>		
	#preservesingleQuotes(OrgFilter)#
	AND       PersonNo is not NULL
	AND       PersonNo NOT IN
                          (SELECT     PersonNo
                            FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
							WHERE     Mission        = '#Target.OrgUnitCode#' 
							AND       SelectionDate  = '#BaseLine.AuditDate#' 
							AND Personno IS NOT NULL
						   )		
	#preserveSingleQuotes(client.programgraphfilter)#
	<cfif url.item neq "">
	AND     #URL.Item#      = '#URL.Select#' 
	</cfif>
	
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
		formula_1_L   = ""
		formula_1_C   = "count(DISTINCT PersonNo)"		
		formula_1_T   = "SUM"				
		mode          = "0"
		node          = "1">	
	
</cfif>
		
</td></tr>
</table>

</cfoutput>  	