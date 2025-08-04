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

<cfparam name="url.selecteddate"     default="#now()#">

<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(url.selecteddate,CLIENT.DateFormatShow)#">
<cfset DTE = dateValue>


<cfquery name  = "get" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   *
		FROM     WorkSchedule W
		WHERE    W.Code = '#url.workschedule#'	
</cfquery>


<cfquery name  = "mandate" 
    datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">      				 
		SELECT   M.*
		FROM     Organization.dbo.Ref_Mandate M
		WHERE    M.Mission = '#get.mission#'	
		AND      DateEffective  <= #DTE#
		AND      DateExpiration >= #DTE#
</cfquery>

<cfquery name="positions" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	  WP.PositionNo, 
				  P.FunctionDescription, 
				  COUNT(WP.WorkSchedule) as Number
		FROM   	  WorkSchedulePosition WP INNER JOIN Position P ON WP.PositionNo = P.PositionNo
		WHERE	  WP.WorkSchedule = '#url.workschedule#'
		AND       WP.CalendarDate = #dte#
		GROUP BY  WP.PositionNo, 
				  P.FunctionDescription
		ORDER BY  WP.PositionNo
	</cfquery>	

	<table>
	    <!---
		<tr><td colspan="3" height="10" class="labelit">Valid: #DateFormat(url.selecteddate,CLIENT.DateFormatShow)#</td></tr>
		--->
		<cfif positions.recordCount eq 0>
			<tr>
				<td class="labelit" colspan="3">[<cf_tl id="No positions assigned">]</td>
			</tr>
		</cfif>
		<cfoutput query="positions">
			<tr class="labelit">
				<td style="padding-left:3px;" class="linedotted"><a href="javascript:EditPosition('#get.mission#','#mandate.mandateno#','#PositionNo#')"><font color="0080C0">#PositionNo#</a></td>
				<td style="padding-left:3px;" class="linedotted">#FunctionDescription#</td>
				<td class="linedotted" align="right" style="width:20px;padding-left:5px;" title="days used">#lsNumberFormat(Number, ",")#</td>
			</tr>					
		</cfoutput>				
	</table>