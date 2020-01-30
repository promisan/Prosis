
<cfinclude template="../../Template/IndicatorTarget.cfm">
<cfinclude template="../../Template/GraphScript.cfm">

<cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *, 0 as Pending, 1 as Completed
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PostType       = 'International'
	AND       PersonNo IS NOT NULL
	#preservesingleQuotes(OrgFilter)#
	#preserveSingleQuotes(client.programgraphfilter)#
	AND       IndexNo IN
	              (SELECT   Indexno
	               FROM     EmployeeSnapShot.dbo.HRPO_EPASDetail
	               WHERE    1= 1 
				   <cfif indicator.IndicatorCriteriaBase neq "">
				   AND     #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
				   </cfif>		
				   AND      ePASCreateDate <= '#Audit.AuditDate#'
				  ) 
	UNION ALL
	SELECT    *, 1 as Pending, 0 as Completed
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PostType       = 'International'
	AND       PersonNo IS NOT NULL
	#preserveSingleQuotes(client.programgraphfilter)#
	AND       IndexNo NOT IN
	              (SELECT   Indexno
	               FROM     EmployeeSnapShot.dbo.HRPO_EPASDetail
	               WHERE    1= 1 
				   <cfif indicator.IndicatorCriteriaOther neq "">
				   AND      #preserveSingleQuotes(indicator.IndicatorCriteriaOther)#
				   </cfif>		
				   AND      (ePASCreateDate <= '#Audit.AuditDate#')
				   )  
</cfquery>	


<cfswitch expression="#URL.Item#">
	
	 <cfcase value="PostGradeBudget">
	 
	 	<cfquery name="Graph"
         dbtype="query">
		 SELECT   #URL.Item#, 
		          SUM(Pending) AS Pending, 
			      SUM(Completed) as Completed 
		 FROM     Base
		 GROUP BY PostGradeBudget, PostOrderBudget
		 ORDER BY PostOrderBudget
		</cfquery>  
	 
	 </cfcase>
	 
	 <cfcase value="PostClass">
	 
	 	<cfquery name="Graph" 
	    dbtype="query">
		SELECT   #URL.Item#, 
		         SUM(Pending) AS Pending, 
		         SUM(Completed) as Completed 
		FROM     Base
		GROUP BY PostClass
		ORDER BY PostClass
		</cfquery>  
	 
	 </cfcase>
	 
	   <cfcase value="ParentNameShort">
	 
	 	<cfquery name="Graph" dbtype="query">
		SELECT   #URL.Item#, 
		         SUM(Pending) AS Pending, 
		         SUM(Completed) as Completed 
		FROM     Base
		GROUP BY ParentHierarchyCode, ParentNameShort
		ORDER BY ParentHierarchyCode
		</cfquery>  
	 
	 </cfcase>
	 
	 <cfcase value="OccGroupAcronym">
	 
	 	<cfquery name="Graph" 
	    dbtype="query">
		SELECT   #URL.Item#, 
		         SUM(Pending) AS Pending, 
		         SUM(Completed) as Completed 
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
      seriesplacement="percent"
      font="Trebuchet MS"
      fontsize="11"
	  title="Pending ePas completion (in red)"
      labelformat="number"         
      show3d="yes"
      tipstyle="mouseOver"
      tipbgcolor="D0D0D0"
      pieslicestyle="sliced"
      url="javascript:listener('$ITEMLABEL$','$SERIESLABEL$')">
   
 <cfchartseries
      type="bar" query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Pending"
      serieslabel="Pending"
      seriescolor="CC3300"
      paintstyle="raise"
      markerstyle="circle"/> 
	  
<cfchartseries
      type="bar"
      query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Completed"
	  datalabelstyle="value"
      serieslabel="Completed"
      seriescolor="ffffaf"
      paintstyle="raise"
      markerstyle="circle"/> 	  

</cfchart>
