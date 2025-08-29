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

  <cfquery name="Base" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	<cfif url.series eq "Completed">
	SELECT    *, 0 as Pending, 1 as Completed
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PostType       = 'International'
	AND       PersonNo is not NULL
	#preservesingleQuotes(OrgFilter)#
	#preserveSingleQuotes(client.programgraphfilter)#
	<cfif url.mode eq "drillbox">
	#preserveSingleQuotes(client.programpivotfilter)#
	</cfif>
	<cfif url.item neq "">
	AND     #URL.Item#       = '#URL.Select#'	
	</cfif>
	<cfif url.OrgUnitOperational neq "">
	AND OrgUnitOperational   = '#URL.OrgUnitOperational#'
	</cfif>
	<cfif url.Nationality neq "">
	AND Nationality = '#URL.Nationality#'
	</cfif>
	AND       IndexNo IN
	              (SELECT   Indexno
	               FROM     EmployeeSnapShot.dbo.HRPO_EPASDetail
	               WHERE    1= 1 
				   <cfif indicator.IndicatorCriteriaBase neq "">
				   AND     #preserveSingleQuotes(indicator.IndicatorCriteriaBase)#
				   </cfif>		
				   AND      ePASCreateDate <= '#Audit.AuditDate#'
				  ) 
	<cfelse>			  
	SELECT    *, 1 as Pending, 0 as Completed
	FROM      EmployeeSnapShot.dbo.HRPO_AppStaffingDetail
	WHERE     Mission        = '#Target.OrgUnitCode#' 
	AND       SelectionDate  = '#Audit.AuditDate#' 
	AND       PostType       = 'International'
	AND       PersonNo IS NOT NULL
	#preserveSingleQuotes(client.programgraphfilter)#
	<cfif url.mode eq "drillbox">
	#preserveSingleQuotes(client.programpivotfilter)#
	</cfif>
	<cfif url.item neq "">
	AND     #URL.Item#       = '#URL.Select#'	
	</cfif>
	<cfif url.OrgUnitOperational neq "">
	AND OrgUnitOperational   = '#URL.OrgUnitOperational#'
	</cfif>
	<cfif url.Nationality neq "">
	AND Nationality = '#URL.Nationality#'
	</cfif>
	AND       IndexNo NOT IN
	              (SELECT   Indexno
	               FROM     EmployeeSnapShot.dbo.HRPO_EPASDetail
	               WHERE    1= 1 
				   <cfif indicator.IndicatorCriteriaOther neq "">
				   AND      #preserveSingleQuotes(indicator.IndicatorCriteriaOther)#
				   </cfif>		
				   AND      (ePASCreateDate <= '#Audit.AuditDate#')
				   )  
	</cfif>			   
 </cfquery>	
		
 <cfquery name="Unit"
   dbtype="query">
	SELECT  DISTINCT HierarchyCode, OrgUnitOperational, OrgUnitName
	FROM    Base
	ORDER BY HierarchyCode</cfquery> 

<cfquery name="Nat" dbtype="query">
	SELECT  DISTINCT Nationality
	FROM    Base
	WHERE Nationality > ''
	ORDER BY Nationality		
</cfquery> 

<cfquery name="List" dbtype="query">
	SELECT  *
	FROM    Base
	WHERE   1= 1 
	<cfif URL.Nationality neq "">
	AND     Nationality = '#URl.Nationality#' 
	</cfif>
	<cfif URL.OrgUnitOperational neq "">
	AND     OrgUnitOperational = #URl.OrgUnitOperational# 
	</cfif>
	ORDER BY HierarchyCode	
</cfquery> 
 
<table width="100%" border="0" cellpadding="0" class="formpadding">
<tr>
	<td align="right" bgcolor="f4f4f4">
		<cfinclude template="../../Template/ListingMenu.cfm">
	</td>
</tr>
<tr><td class="line"></td></tr>
<tr><td valign="top">
<table width="98%" cellspacing="0" cellpadding="0" align="center">

<cfif list.recordcount eq "0">
	<tr><td colspan="8" align="center"><b>No records found</b></td></tr>
	
<cfelse>

<tr>
  <td></td>
  <td>No</td>
  <td>Function</td>
  <td>IndexNo</td>
  <td>Name</td>
  <td>Signed</td>
  <td>MidPoint</td>
  <td>End of Cycle SM</td>
</tr>	
<tr><td class="line" colspan="8"></td></tr>
</cfif>

<cfoutput query="List" group="HierarchyCode">

	<tr><td colspan="8">#OrgUnitName#</td></tr>	
	
	<cfoutput>
					
		<cfif Completed eq "1">
		<cfset cl = "ffffff">
		<cfelse>
		<cfset cl = "FFA07A">
		</cfif>
		
		<td></td>
		
		<tr bgcolor="#cl#">
			<td height="18" width="20"></td>
			<td width="20">#currentrow#.</td>
			<td><a href="javascript:EditPost('#PositionNo#')">#FunctionDescription#</a></td>
			<td><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
			<td>#FullName#</td>
			
			<cfif completed eq "1">
			
			 <cfquery name="Pas" 
		    datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT   *
	            FROM     EmployeeSnapShot.dbo.HRPO_EPASDetail
    	        WHERE    Indexno = '#Indexno#'
			    AND      Mission        = '#Target.OrgUnitCode#' 				  
			</cfquery>										
			
			<td>#dateformat(Pas.EPasPlanFROSignedDate,CLIENT.DateFormatShow)#</td>
			<td>#dateformat(Pas.EPasMidPointFRODate,CLIENT.DateFormatShow)#</td>
			<td>#dateformat(Pas.EPasEndCycleSMDate,CLIENT.DateFormatShow)#</td>			
			
			<cfelse>
			
			<td></td>
			<td></td>
			<td></td>
			
			</cfif>
			
		</tr>
		<tr><td colspan="8" bgcolor="d0d0d0"></td></tr>
		
		<!--- provision for export --->
		<cfif id neq "">
			<cfset id = "#id#,'#recordno#'">	
		<cfelse>
		    <cfset id = "'#recordno#'">	
		</cfif>
	
	</cfoutput>
	<tr><td height="20"></td></tr>
	
</cfoutput>

<cfinclude template="../../Template/ListingBottom.cfm">

</table>
</td></tr></table>
