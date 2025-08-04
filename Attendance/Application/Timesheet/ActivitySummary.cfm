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

<CF_DropTable dbName="AppsQuery"  tblName="Work#URL.PersonNo#">	

<cfquery name="Set" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     YEAR(CalendarDate) AS WorkYear, 
           { fn WEEK(CalendarDate) } AS WorkWeek, 
		   CalendarDate, 
		   SUM(HourSlotMinutes)/60 AS WorkHour
INTO       userQuery.dbo.Work#URL.PersonNo#		   
FROM       PersonWorkDetail
WHERE     (PersonNo = '#URL.PersonNo#') AND (ActionCode = '#URL.ActivityId#')
GROUP BY CalendarDate
ORDER BY CalendarDate 
</cfquery>

<cfquery name="Detailed" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       userQuery.dbo.Work#URL.PersonNo#		   
</cfquery>

<table width="95%" border="0" cellspacing="0" cellpadding="0">


<cfquery name="getYear" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     DISTINCT WorkYear
		FROM       userQuery.dbo.Work#URL.PersonNo#		   		
</cfquery>

<tr class="labelmedium line">
	<td height="20" width="80" style="padding-left:4px">Year</td>
	<td width="60">Week</td>
	<td width="50%" colspan="2">Day</td>
	<td width="90" align="right">Day total</td>
	<td width="90" align="right">Week total</td>
	<cfif getYear.recordcount gte "2">
	<td width="90" style="padding-right:7px" align="right">Total</td>
	</cfif>
</tr>


<cfoutput query="Detailed" group="WorkYear">

    <cfif getYear.recordcount gte "2">
	
	<cfquery name="Year" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     SUM(WorkHour) AS WorkHour
		FROM       userQuery.dbo.Work#URL.PersonNo#		   
		WHERE      WorkYear = '#WorkYear#'
	</cfquery>
				
	<tr class="labelmedium line">
	
		<td style="font-size:28px" style="padding-left:3px">#WorkYear#</td>
		<td colspan="5"></td>
		<td align="right" style="padding-right:4px">#Year.WorkHour#</td>
		
	</tr>
	
	</cfif>
	
	<cfoutput group="WorkWeek">
		
		<cfquery name="Week" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     SUM(WorkHour) AS WorkHour
			FROM       userQuery.dbo.Work#URL.PersonNo#		   
			WHERE      WorkYear = '#WorkYear#'
			AND        WorkWeek = '#WorkWeek#'
		</cfquery>
		
		<tr class="labelmedium linedotted">
		<td style="padding-left:4px">
		<cfif getYear.recordcount eq "1">
		#WorkYear#
		</cfif>
		</td>
		<td style="padding-left:3px">#WorkWeek#</td>
		<td colspan="3"></td>
		<td align="right" style="padding-right:4px">#Week.WorkHour#</td>
		<td></td>
		</tr>
	
		<cfoutput>
			<tr class="labelit linedotted">
			<td colspan="2"></td>
			<td colspan="2">#dayofweekAsString(dayofweek(CalendarDate))# #dateformat(CalendarDate,"DD/MM")#</td>
			<td align="right" colspan="1">#WorkHour#</td>
			<td colspan="2"></td>
			</tr>
		</cfoutput>
	
	</cfoutput>

</cfoutput>

</table>

<CF_DropTable dbName="AppsQuery"  tblName="Work#URL.PersonNo#">	
