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
<cfparam name="url.orgunit"      default="0">
<cfparam name="url.personno"     default="">
<cfparam name="url.personlist"   default="">
<cfparam name="session.timesheet.DateStart"   default="">

<cfif session.timesheet["DateStart"] neq "">
	
	<cfquery name="getThisOrgUnit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Organization
			WHERE 	OrgUnit = '#url.orgunit#'
	</cfquery>
	
	<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Parameter	
	  </cfquery>
	  
	 <cftransaction action="BEGIN" isolation="READ_UNCOMMITTED">
	
	 <cfquery name="summary" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	
				  
			  SELECT    BillingMode, 
			            BillingPayment,
			            ActivityPayment,
						LeaveId,
			            SUM(CONVERT(float, HourSlotMinutes)) / (60 * #Param.HoursInDay#) AS Days,					
						SUM(CONVERT(float, HourSlotMinutes)) / (60) AS Hours
			  FROM      PersonWorkDetail
			  WHERE     PersonNo = '#url.personno#'
			  AND       (
			  			 ActionClass IN (SELECT   ActionClass
			                             FROM     Ref_WorkAction
	        		                     WHERE    ActionParent = 'worked')
										 
						 OR 
						 LeaveId is not NULL  <!--- official leave recorded from leave module then it counts as work --->
						)
		      AND	    CalendarDate >= #session.timesheet["DateStart"]#
			  AND       CalendarDate <= #session.timesheet["DateEnd"]#  	
			  AND       TransactionType     = '1'
			  GROUP BY  BillingMode, BillingPayment, ActivityPayment, Leaveid
			  
	 </cfquery>  
	 
	 </cftransaction>
	 
	 <cfquery name="work" dbtype="query">
	        SELECT sum(Hours) as Hours  FROM  summary WHERE BillingMode = 'Contract' AND LeaveId is NULL
	 </cfquery>  
	 
	  <cfquery name="leave" dbtype="query">
	        SELECT sum(Hours) as Hours  FROM  summary WHERE BillingMode = 'Contract' AND LeaveId is NOT NULL
	 </cfquery> 
	 
	  <cfquery name="day" dbtype="query">
	        SELECT sum(Days) as Days    FROM  summary WHERE BillingMode = 'Contract'
	 </cfquery> 	
	  
	 <cfquery name="overtime" dbtype="query">	
			SELECT sum(Hours) as Hours  FROM  summary WHERE BillingMode != 'Contract' AND BillingPayment = '1'			
	 </cfquery> 
	 
	  <cfquery name="time" dbtype="query">	
			SELECT sum(Hours) as Hours  FROM  summary WHERE BillingMode != 'Contract' AND BillingPayment = '0'		
	 </cfquery> 
	 
	 <cfquery name="activity" dbtype="query">
			SELECT sum(Hours) as Hours  FROM  summary WHERE ActivityPayment != '0'		
	 </cfquery>  	
	 
	<cfoutput>
	
	<cfif getThisOrgUnit.WorkSchema eq 1>
										
	<table>
	
		<tr style="height:22px" class="labelmedium">	
			
				<td bgcolor="e1e1e1" align="right" style="padding-top:3px;font-size:12px;padding-right:2px;background-color:##e1e1e180;border-right:1px solid silver;min-width:36px"><cfif work.hours eq "">-<cfelse>#numberformat(work.hours,'._')#</cfif></td>
				<td bgcolor="FFFF00" align="right" style="padding-top:3px;font-size:12px;padding-right:2px;background-color:##FFFF004D;border-right:1px solid silver;min-width:36px"><cfif leave.hours eq "">-<cfelse>#numberformat(leave.hours,'._')#</cfif></td>
				<td bgcolor="CFE2E9" align="right" style="padding-top:3px;font-size:12px;padding-right:2px;background-color:##CFE2E980;border-right:1px solid silver;min-width:36px"><cfif day.days eq "">-<cfelse>#numberformat(day.days,'._')#</cfif></td>
				<td bgcolor="FFFFFF" align="right" style="padding-top:3px;font-size:12px;padding-right:2px;background-color:##FFFFFF4D;border-right:1px solid silver;min-width:36px"><cfif overtime.hours eq "">-<cfelse>#numberformat(overtime.hours,'._')#</cfif></td>
				<td bgcolor="FFFFFF" align="right" style="padding-top:3px;font-size:12px;padding-right:2px;background-color:##FFFFFF4D;border-right:1px solid silver;min-width:36px"><cfif time.hours eq "">-<cfelse>#numberformat(time.hours,'._')#</cfif></td>
				<td bgcolor="400040" align="right" style="padding-top:3px;font-size:12px;padding-right:2px;background-color:##40004080;color:white;min-width:36px"><cfif activity.hours eq "">-<cfelse>#numberformat(activity.hours,'._')#</cfif></td>
			
			</tr>
	</table>	
	
	</cfif>	
	
	</cfoutput> 
	
</cfif>	