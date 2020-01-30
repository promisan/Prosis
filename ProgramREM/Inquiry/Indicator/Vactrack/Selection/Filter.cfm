
<cfinclude template="../../Template/IndicatorTarget.cfm">

<cfparam name="client.graph" default= "PostGradeBudget">
<cfparam name="url.item"     default= "#client.graph#">
<cfset client.graph = url.item>

<!--- customise to show additional details in the left box  --->

<cftry>

	<cfquery name="Probe" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  TOP 1 *
	FROM    EmployeeSnapShot.dbo.HRPO_AppSelectionDetail
	WHERE 1 = 1
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND #preserveSingleQuotes(indicator.IndicatorCriteriaBase)# 
	</cfif>
	</cfquery>
	
	<cfset tbl = "EmployeeSnapShot.dbo.HRPO_AppStaffingDetail">
	
	<cfcatch>
		<cfset tbl = "userQuery.dbo.#SESSION.acc#Indicator#url.fileNo#">
	</cfcatch>

</cftry>
	
<cfsavecontent variable="fr">
	<cfoutput>
	FROM    #tbl#
	WHERE   Mission         = '#Target.OrgUnitCode#' 
	AND     SelectionDate   = '#Audit.AuditDate#' 
	<cfif indicator.IndicatorCriteriaBase neq "" and indicator.IndicatorTemplateApply eq "1">
	AND #preserveSingleQuotes(indicator.IndicatorCriteriaBase)# 
	</cfif>		
	</cfoutput>	
</cfsavecontent>

<cfquery name="Grade" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT DISTINCT PostGradeBudget, PostOrderBudget 
	#preserveSingleQuotes(fr)#	
	ORDER BY PostOrderBudget	
</cfquery>  

<cfquery name="Gender" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT  Gender
	#preservesingleQuotes(fr)#	
	AND     PersonNo > ''
	GROUP BY Gender
</cfquery> 

<cfform name="filterform">

<table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
<!---
<cfif url.item neq "PostGradeBudget">
--->
<tr><td><b>Grade</b></td></tr>
<tr><td align="center">
      <input type="hidden" name="filter1" value="PostGradeBudget">
	  <select name="filtervalue1" 
	     size="11" 
		 multiple style="width: 120px;">
			<cfoutput query="Grade">
			
			<option value="'#PostGradeBudget#'" <cfif find(PostGradeBudget,client.programgraphfilter)>selected</cfif>>#PostGradeBudget#</option>
			</cfoutput>				
	  </select>
</td></tr>
<!---
<cfelse>
<tr><td><b>Nationality</b></td></tr>
<tr><td align="center">
      <input type="hidden" name="filter1" value="Nationality">
	  <select name="filtervalue1" 
	     size="11" 
		 multiple style="width: 120px;">
			<cfoutput query="Nationality">
			<option value="'#Nationality#'">#Nationality#</option>
			</cfoutput>				
	  </select>
</td></tr>
</cfif>
--->
<tr><td><b>Gender</b></td></tr>
<tr><td>
<input type="radio" name="Gender" value="M">M
<input type="radio" name="Gender" value="F">F
<input type="radio" name="Gender" checked value="">B
</td></tr>
<tr><td class="line" height="1"></td></tr>
<cfoutput>
<tr><td height="30" align="center"><input type="button" onclick="filterapply('#url.item#','no')" name="Apply" class="button10g" value="Apply"></td></tr>
</cfoutput>

</cfform>

</table>

	