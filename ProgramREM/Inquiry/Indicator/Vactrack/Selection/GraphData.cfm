

<cfinclude template="../../Template/IndicatorTarget.cfm">
<cfinclude template="../../Template/GraphScript.cfm">

<cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *
	FROM      EmployeeSnapShot.dbo.HRPO_AppSelectionDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND     #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
	</cfif>	
	#preserveSingleQuotes(client.programgraphfilter)#		
</cfquery>	

<cfswitch expression="#URL.Item#">
	
	 <cfcase value="PostGradeBudget">
	 
	 	<cfquery name="Graph"
         dbtype="query">
		 SELECT   #URL.Item#, 
		     	  count(DISTINCT documentNo) AS Tracks,
		          AVG(NumDays) AS AverageDays
		 FROM     Base
		 GROUP BY PostGradeBudget, PostOrderBudget
		 ORDER BY PostOrderBudget
		</cfquery>  
	 
	 </cfcase>
	 
	 <cfcase value="PostClass">
	 
	 	<cfquery name="Graph" 
	    dbtype="query">
		SELECT   #URL.Item#, 
				 count(DISTINCT documentNo) AS Tracks,
		         AVG(NumDays) AS AverageDays
		FROM     Base
		GROUP BY PostClass
		ORDER BY PostClass
		</cfquery>  
	 
	 </cfcase>
	 
	  <cfcase value="ParentNameShort">
	 
	 	<cfquery name="Graph" 
	    dbtype="query">
		SELECT   #URL.Item#, 
		         count(DISTINCT documentNo) AS Tracks,
		         AVG(NumDays) AS AverageDays
		FROM     Base
		GROUP BY ParentHierarchyCode, ParentNameShort
		ORDER BY ParentHierarchyCode
		</cfquery>  
	 
	 </cfcase>
	 
	 <cfcase value="OccGroupAcronym">
	 
	 	<cfquery name="Graph" 
		dbtype="query">
		SELECT   #URL.Item#, 
				count(DISTINCT documentNo) AS Tracks,
		         AVG(NumDays) AS AverageDays
		FROM     Base
		GROUP BY OccupationalGroup, OccGroupAcronym
		ORDER BY OccupationalGroup, OccGroupAcronym
		</cfquery>  
	 
	 </cfcase>
	 
</cfswitch>	

<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png"
      chartheight="230"
      chartwidth="#w#"
      showxgridlines="yes"
      seriesplacement="cluster"
      font="Trebuchet MS"
      fontsize="11"
	  title="Average Selection time (blue) and Total tracks (gray)"
      labelformat="number"         
      show3d="yes"
      tipstyle="mouseOver"
      tipbgcolor="D0D0D0"
      pieslicestyle="sliced"
      url="javascript:listener('$ITEMLABEL$')">

 <cfchartseries
             type="bar"
             query="Graph"
             itemcolumn="#url.item#"
             valuecolumn="AverageDays"
			  datalabelstyle="value"
             serieslabel="Average Selection Time"
             seriescolor="00ABFD"
             paintstyle="raise"
             markerstyle="circle"/> 
	  
	  <cfchartseries
      type="bar"
      query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Tracks"
      serieslabel="Tracks"
      seriescolor="silver"
      paintstyle="raise"
      markerstyle="circle"/> 
 

</cfchart>
