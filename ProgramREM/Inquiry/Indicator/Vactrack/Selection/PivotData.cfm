<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfinclude template="../../Template/IndicatorTarget.cfm">

<cfoutput>
<cfsavecontent variable="Where">
     AND    Mission        = '#Target.OrgUnitCode#' 
	 AND    SelectionDate  = '#Audit.AuditDate#' 
	 <cfif indicator.IndicatorCriteriaBase neq "">
	 AND    #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
	 </cfif>
	 <cfif url.item neq "">
	 AND     #URL.Item#      = '#URL.Select#'	
	 </cfif>
	 #preserveSingleQuotes(client.programgraphfilter)#		
</cfsavecontent>	

<table width="100%" cellspacing="0" cellpadding="0">
<tr><td><cfinclude template="../../Template/Pivot.cfm"></td></tr>
<tr><td>

<cfif form.Xax neq "" and XaxLbl neq "" and YaxLbl neq "">
	
	<cf_PivotPrepare
	    Alias         = "AppsProgram"
		Base          = "EmployeeSnapShot.dbo.HRPO_AppSelectionDetail" 
		Condition     = "#Where#"
		XaxLbl        = "#XaxLbl#"
		XaxFld        = "#XaxFld#"
		XaxOrd        = "#XaxOrd#"
		
		YaxLbl        = "#YaxLbl#"
		YAxFld        = "#YaxFld#"
		YaxOrd        = "#YaxOrd#"
		formula_1_L   = "Track"
		formula_1_C   = "count(DISTINCT DocumentNo)"		
		formula_1_T   = "SUM"		
		formula_2_L   = "Avg"
		formula_2_C   = "AVG(NumDays)"		
		formula_2_T   = "AVG"		
		mode          = "0"
		node          = "1">	
	
</cfif>
		
</td></tr>
</table>

</cfoutput>  	