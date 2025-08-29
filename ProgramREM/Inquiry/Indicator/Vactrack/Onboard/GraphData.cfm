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
<cfoutput>
<cfinclude template="../Template/IndicatorTarget.cfm">

<cfparam name="URL.Print" default="0">
<cfif url.print eq "1">
	<cfset w = 660>
<cfelse>
	<cfset w =  client.width-340>
</cfif>

<script>

 function listener(val) {
	    parent.document.getElementById("graphitem").value   = '#url.item#'
		parent.document.getElementById("graphselect").value = val
		parent.reloadlisting()
	 }

</script>

</cfoutput>

<cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT    *, 0 as Pending, 1 as Attended
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PostType = 'International'
	AND       PersonNo IN
	              (SELECT   PersonNo
	               FROM     EmployeeSnapShot.dbo.HRPO_AppStaffDevelopmentDetail
	               WHERE    1= 1 
				   <cfif indicator.IndicatorCriteriaBase neq "">
				   AND     #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
				   </cfif>		
				   AND      DateCompleted <= '#Audit.AuditDate#'
				  ) 
	UNION ALL
	SELECT    *, 1 as Pending, 0 as Attended
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PostType = 'International'
	AND       PersonNo IS NOT NULL
	AND       PersonNo NOT IN
	              (SELECT   PersonNo
	               FROM     EmployeeSnapShot.dbo.HRPO_AppStaffDevelopmentDetail
	               WHERE    1= 1 
				   <cfif indicator.IndicatorCriteriaBase neq "">
				   AND      #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
				   </cfif>		
				   AND      DateCompleted <= '#Audit.AuditDate#'
				   ) 
</cfquery>	


<cfswitch expression="#URL.Item#">
	
	 <cfcase value="PostGradeBudget">
	 
	 	<cfquery name="Graph"
         dbtype="query">
		 SELECT   #URL.Item#, 
		          SUM(Pending) AS Pending, 
			      SUM(Attended) as Attended 
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
		         SUM(Attended) as Attended 
		FROM     Base
		GROUP BY PostClass
		ORDER BY PostClass
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
      chartheight="230"
      chartwidth="#w#"
      showxgridlines="yes"
      seriesplacement="stacked"
      font="Trebuchet MS"
      fontsize="11"
	  title="Pending course completion (in red)"
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
      valuecolumn="Attended"
      serieslabel="Completed"
      seriescolor="ffffaf"
      paintstyle="raise"
      markerstyle="circle"/> 
   
 <cfchartseries
      type="bar" query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Pending"
      serieslabel="Pending"
      seriescolor="CC3300"
      paintstyle="raise"
      markerstyle="circle"/> 

</cfchart>
