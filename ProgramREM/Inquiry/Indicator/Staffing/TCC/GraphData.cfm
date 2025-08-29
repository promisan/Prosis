<!--
    Copyright © 2025 Promisan B.V.

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
<cfinclude template="../../Template/GraphScript.cfm">

<cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *, 0 as Other, 1 as TCC
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PostType       = 'International'	
	#preservesingleQuotes(OrgFilter)#
	#preserveSingleQuotes(client.programgraphfilter)#
	<cfif indicator.IndicatorCriteriaBase neq "">
	AND    (#preserveSingleQuotes(indicator.IndicatorCriteriaBase)#)
	</cfif>		
	UNION ALL
	SELECT    *, 1 as Other, 0 as TCC
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PersonNo is not NULL
	AND       PostType       = 'International'	
	#preservesingleQuotes(OrgFilter)#
	#preserveSingleQuotes(client.programgraphfilter)#
	<cfif indicator.IndicatorCriteriaOther neq "">
	AND	   (#preserveSingleQuotes(indicator.IndicatorCriteriaOther)#)
	</cfif>		
</cfquery>	


<cfswitch expression="#URL.Item#">

	  <cfcase value="PostGradeBudget">
	 
	 	<cfquery name="Graph"
         dbtype="query">
		SELECT   #URL.Item#, 
		          SUM(Other) AS Other,
			      SUM(TCC) as TCC
		 FROM     Base
		GROUP BY PostGradeBudget, PostOrderBudget
		ORDER BY PostOrderBudget	
		</cfquery>  
	 
	 </cfcase>
	
	 <cfcase value="AssignPostGradeBudget">
	 
	 	<cfquery name="Graph"
         dbtype="query">
		 SELECT   #URL.Item#, 
		          SUM(Other) AS Other,
			      SUM(TCC) as TCC
		 FROM     Base
		 GROUP BY AssignPostGradeBudget, AssignPostOrderBudget
		 ORDER BY AssignPostOrderBudget	
		</cfquery>  
	 
	 </cfcase>
	 
	 <cfcase value="PostClass">
	 
	 	<cfquery name="Graph" 
	    dbtype="query">
		SELECT   #URL.Item#, 
		         SUM(Other) AS Other,
			     SUM(TCC) as TCC
		FROM     Base
		GROUP BY PostClass
		ORDER BY PostClass
		</cfquery>  
	 
	 </cfcase> 
	 
	  <cfcase value="ParentNameShort">
	 
	 	<cfquery name="Graph" 
	    dbtype="query">
		SELECT   #URL.Item#, 
		         SUM(Other) AS Other,
			     SUM(TCC) as TCC
		FROM     Base
		GROUP BY ParentHierarchyCode, ParentNameShort
		ORDER BY ParentHierarchyCode
		</cfquery>  
	 
	 </cfcase>
		 
	 <cfcase value="OccGroupAcronym">
	 
	 	<cfquery name="Graph" 
	    dbtype="query">
		SELECT   #URL.Item#, 
		         SUM(Other) AS Other,
			     SUM(TCC) as TCC
		FROM     Base
		GROUP BY OccupationalGroup, OccGroupAcronym
		ORDER BY OccupationalGroup, OccGroupAcronym
		</cfquery>  
	 
	 </cfcase>

</cfswitch>	

<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="png"
           chartheight="220"
           title="TCC and PCC representation (in blue); Other (in yellow)"
           chartwidth="#w#"
           showxgridlines="yes"
           seriesplacement="percent"
           font="Verdana"
           fontsize="10"
		    show3d="yes"
           labelformat="number"          
           tipstyle="mouseOver"
           tipbgcolor="D0D0D0"
           pieslicestyle="sliced"
           url="javascript:listener('$ITEMLABEL$')">
    
 <cfchartseries
        type="bar"
        query="Graph"
        itemcolumn="#url.item#"
        valuecolumn="TCC"
        serieslabel="TCC/PCC"
        seriescolor="1AB5FF"
        datalabelstyle="value"
        paintstyle="raise"
        markerstyle="circle">
	  
<cfchartseries
      type="bar"
      query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Other"
      serieslabel="Other"
      seriescolor="ffffaf"
      paintstyle="raise"
      markerstyle="circle"/> 	  

</cfchart>
