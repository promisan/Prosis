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
<cfinclude template="../../Template/GraphScript.cfm">

<cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *, 0 as Pending, 1 as Exceed
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
	SELECT    *, 1 as Pending, 0 as Exceed
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PostType       = 'International'
	AND       PersonNo IS NOT NULL
	#preserveSingleQuotes(client.programgraphfilter)#
	AND       IndexNo IN
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
			      SUM(Exceed) as Exceed
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
		         SUM(Exceed) as Exceed
		FROM     Base
		GROUP BY PostClass
		ORDER BY PostClass
		</cfquery>  
	 
	 </cfcase>
	 
	   <cfcase value="ParentNameShort">
	 
	 	<cfquery name="Graph" dbtype="query">
		SELECT   #URL.Item#, 
		         SUM(Pending) AS Pending, 
		         SUM(Exceed) as Exceed
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
		         SUM(Exceed) as Exceed
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
	  title="#Indicator.IndicatorDescription# (in green)"
      labelformat="number"         
      show3d="yes"
      tipstyle="mouseOver"
      tipbgcolor="D0D0D0"
      pieslicestyle="sliced"
      url="javascript:listener('$ITEMLABEL$','$SERIESLABEL$')">   
 	  
<cfchartseries
      type="bar"
      query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Exceed"
	  datalabelstyle="value"
      serieslabel="Exceeds"
      seriescolor="green"
      paintstyle="raise"
      markerstyle="circle"/> 	  
	  
<cfchartseries
      type="bar" query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Pending"
      serieslabel="Pending"
      seriescolor="ffffcf"
      paintstyle="raise"
      markerstyle="circle"/> 	  

</cfchart>
