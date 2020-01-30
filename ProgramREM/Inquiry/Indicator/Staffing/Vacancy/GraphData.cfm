
<cfinclude template="../../Template/IndicatorTarget.cfm">
<cfinclude template="../../Template/GraphScript.cfm">

<cfsavecontent variable="qry">
		<cfoutput>		
		SELECT  #URL.Item#, 
		        COUNT(DISTINCT PositionNo) AS countedPosition, 
				COUNT(DISTINCT PersonNo) AS Occupied, 
				COUNT(DISTINCT PositionNo) - COUNT(DISTINCT PersonNo) AS Vacant	
		FROM    EmployeeSnapShot.dbo.HRPO_AppStaffingDetail	
		WHERE   Mission        = '#Target.OrgUnitCode#' 
		AND     SelectionDate  = '#Audit.AuditDate#' 
		#preservesingleQuotes(OrgFilter)#
		#preservesingleQuotes(OrgFilter)#
		<cfif indicator.IndicatorCriteriaBase neq "">
		AND #preserveSingleQuotes(indicator.IndicatorCriteriaBase)# 
		</cfif>		
		#preserveSingleQuotes(client.programgraphfilter)#
		</cfoutput>	
</cfsavecontent>	

<cfquery name="Mandate" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM    EmployeeSnapShot.dbo.HRPO_AppStaffingDetail	
	WHERE   Mission        = '#Target.OrgUnitCode#' 
	AND     SelectionDate  = '#Audit.AuditDate#' 
</cfquery>  

<!--- <cfinclude template="DataPrepare.cfm"> --->

<cfswitch expression="#URL.Item#">
	
	 <cfcase value="PostGradeBudget">
	 
	 	<cfquery name="Graph" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		#preserveSingleQuotes(qry)#
		GROUP BY PostGradeBudget, PostOrderBudget
		ORDER BY PostOrderBudget	
		</cfquery>  
	 
	 </cfcase>
	 
	 <cfcase value="PostClass">
	 
	 	<cfquery name="Graph" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		#preserveSingleQuotes(qry)#
		GROUP BY PostClass
		ORDER BY PostClass
		</cfquery>  
	 
	 </cfcase>
	 
	  <cfcase value="ParentNameShort">
	 
	 	<cfquery name="Graph" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		#preserveSingleQuotes(qry)#
		GROUP BY ParentHierarchyCode, ParentNameShort
		ORDER BY ParentHierarchyCode
		</cfquery>  
	 
	 </cfcase>
	 
	 <cfcase value="OccGroupAcronym">
	 
	 	<cfquery name="Graph" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		#preserveSingleQuotes(qry)#
		GROUP BY OccupationalGroup, OccGroupAcronym
		ORDER BY OccupationalGroup, OccGroupAcronym
		</cfquery>  
	 
	 </cfcase>

</cfswitch>	


<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png"
      chartheight="240"
      chartwidth="#client.width-340#"
      showxgridlines="yes"
      seriesplacement="stacked"
      font="Trebuchet MS"
      fontsize="10"
      labelformat="number"
	  <!---
      xaxistitle="#url.Item#"
	  --->
      yaxistitle="Post/Vacancy count"
      show3d="yes"
      tipstyle="mouseOver"
      tipbgcolor="D0D0D0"
      pieslicestyle="sliced"
      url="javascript:listener('$ITEMLABEL$')">

 <cfchartseries
      type="bar"
      query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Occupied"
      serieslabel="Encumbered"
	  datalabelstyle="value"
      seriescolor="ffffaf"
      paintstyle="raise"
      markerstyle="circle"/> 
   
 <cfchartseries
      type="bar" query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Vacant"
      serieslabel="Vacant"
      seriescolor="CC3300"
      paintstyle="raise"
      markerstyle="circle"/> 

</cfchart>
