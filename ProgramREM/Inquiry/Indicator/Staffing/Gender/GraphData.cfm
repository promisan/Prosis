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

<cfsavecontent variable="qry">
		<cfoutput>
		SELECT  #URL.Item#, 
				COUNT(CASE Gender WHEN 'M' THEN 1 END) AS Male, COUNT(CASE Gender WHEN 'F' THEN 1 END) AS Female		       
		FROM    EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
		WHERE   Mission        = '#Target.OrgUnitCode#' 
		AND     SelectionDate  = '#Audit.AuditDate#' 
		#preservesingleQuotes(OrgFilter)#
		<cfif indicator.IndicatorCriteriaBase neq "">
		AND #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
		</cfif>
		#preserveSingleQuotes(client.programgraphfilter)#						
		</cfoutput>	
</cfsavecontent>	

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
	
	 <cfcase value="AssignPostGradeBudget">
	 
	 	<cfquery name="Graph" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		#preserveSingleQuotes(qry)#
		GROUP BY AssignPostGradeBudget, AssignPostOrderBudget
		ORDER BY AssignPostOrderBudget	
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
           chartheight="220"
           title="Female Representation (in red)"
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
             valuecolumn="Female"
             serieslabel="Female"
             seriescolor="red"
             datalabelstyle="value"
             paintstyle="raise"
             markerstyle="circle"/> 
	  
<cfchartseries
      type="bar"
      query="Graph"
      itemcolumn="#url.item#"
      valuecolumn="Male"
      serieslabel="Male"
      seriescolor="ffffaf"
      paintstyle="raise"
      markerstyle="circle"/> 	  

</cfchart>
