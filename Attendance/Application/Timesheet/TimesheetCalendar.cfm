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

<cfparam name="URL.ID0" default="">

<!--- Make-o Calendar-o Start --->
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td width="100%" colspan="7" style="height:30" class="labelmedium">
	<cfoutput>#MonthAsString(Month(DateOb))# #Year(Dateob)#</cfoutput>
	</td>
	</tr>
	<tr><td height="1" colspan="7" class="linedotted"></td></tr>
	<tr class="line labelit">
	<td width="30" height="21" align="center"><span class="caltxt">Sun</span></td>
	<td width="30" align="center"><span class="caltxt">Mon</span></td>
	<td width="30" align="center"><span class="caltxt">Tue</span></td>
	<td width="30" align="center"><span class="caltxt">Wed</span></td>
	<td width="30" align="center"><span class="caltxt">Thu</span></td>
	<td width="30" align="center"><span class="caltxt">Fri</span></td>
	<td width="30" align="center"><span class="caltxt">Sat</span></td>
	</tr>
	<!--- Now we need to display the weeks of the month. --->
	<!---  The logic here is not too complex. We know that every 7 days we need to start a new table row. 
	The only hard part is figuring out how much we need to pad the first and last row. 
	To figure out how much we need to pad, we just figure out what day of the week the first of the month is. if it is wednesday, 
	then we need to pad for sunday,monday, and tuesday. 3 days. --->			
	<tr>
	<cfset FIRSTOFMONTH=CreateDate(Year(DateOb),Month(DateOb),1)>
	<cfset TOPAD=DayOfWeek(FIRSTOFMONTH) - 1>
	<cfset PADSTR=RepeatString("<td width=30 height=30>&nbsp;</td>",TOPAD)>
	<cfoutput>#PADSTR#</cfoutput>
	<cfset DW=TOPAD>
	<cfloop index="X" from="1" to="#DaysInMonth(DateOb)#">
	<cfif x EQ url.day>
		<cfoutput>
			<td width="30" height="30" bgcolor="##C83702" align="center">
					<!---<a href="javascript:showdate('#x#')" class="callinkday">#X#</a> Changed by JM on 01/02/2010 ----->
			<a href="javascript:gotodate('#URL.ID#','#x#','#Month(dateob)#','#Year(dateob)#','#x#')">
			<font color="##FFFFFF">#X#</font>
			</a>

			</td>
			</cfoutput>
		<cfelse>
		
		<cfoutput>

			<cfquery name="work" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
    	    	password="#SESSION.dbpw#">
				SELECT 	SUM(TimeMinutes) as Total
				FROM 	PersonWorkClass P INNER JOIN Ref_TimeClass R ON P.TimeClass = R.TimeClass
				WHERE	PersonNo        = '#URL.ID#'
				AND     CalendarDate    = #Createdate(Year(dateob),Month(dateob),X)#
				AND     TransactionType = '1'
				AND     R.TimeParent IN ('Work','Absent')
		   </cfquery>

			<td width="30" height="30" align="center" bgcolor="##F2F6FF">				
			<a href="javascript:gotodate('#URL.ID#','#x#','#Month(dateob)#','#Year(dateob)#','#x#')">
			<cfif Work.total gt 0><font color="##0000FF"><b>#X#</b></font><cfelse>#X#</cfif></a>
		
		</td>
		
		</cfoutput>
	</cfif>
	<cfset DW=DW + 1>
	<cfif DW EQ 7>
	</tr>
	<cfset DW=0>
	<cfif X LT DaysInMonth(DateOb)><tr></cfif>
	</cfif>
	</cfloop>
	<!--- Now we need to do a pad at the end, just to make our table "proper"  we can figure out how much the pad should be by examining DW --->
	<cfset TOPAD=7 - DW>
	<cfif TOPAD LT 7>
		<cfset PADSTR=RepeatString("<td width=30 height=30>&nbsp;</td>",TOPAD)>
		<cfoutput>#PADSTR#</cfoutput>
	</cfif>
	</tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td align="center" class="labelmedium2 line">
	<!--- display calendar end --->			
		<cfset prev_date=DateAdd("m",-1,dateob)>
		<cfset next_date=DateAdd("m",1,dateob)>
		<cfoutput>
		<a href="javascript:gotodate('#URL.ID#','1','#Month(prev_date)#','#Year(prev_date)#','1')" class="callink"><cf_tl id="Prior"></a> - 
		<a href="javascript:gotodate('#URL.ID#','1','#Month(next_date)#','#Year(next_date)#','1')" class="callink"><cf_tl id="Next"></a>
	</cfoutput>
	</td></tr>
	<tr><td class="line"></td></tr>
	</table>
	

<!--- Make-o Calendar-o End --->

