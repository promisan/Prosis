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
<cfquery name="holiday" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Holiday
		WHERE	CalendarDate = '#dateformat(url.calendardate,client.dateSQL)#'
		AND     Mission     = '#url.mission#'
</cfquery>

<cfset maxk = holiday.recordcount>															

<cfif holiday.recordcount EQ 0>										  						   
	
<cfelse>	
   													
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
																			
		<cfoutput query="holiday">		
		<tr>								
		<cfif holiday.HoursHoliday gt "0" and Description neq "">
		  <td align="center">		  	
				<span style="line-height:10px; font-size:10px;">#Description#</span>			
		  </td>
		</cfif>											
		</tr>
		</cfoutput>

	</table>
																
</cfif>
							