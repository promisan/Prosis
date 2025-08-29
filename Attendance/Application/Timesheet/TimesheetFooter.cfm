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
<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<table width="100%" align="center">

		<cfquery name="last" 
	         datasource="AppsEmployee" 
			 username="#SESSION.login#" 
             password="#SESSION.dbpw#">
				SELECT 	TOP 1 *
				FROM 	PersonWork
				WHERE	CalendarDate = #dte#
				AND     PersonNo = '#URL.ID#' 
				ORDER BY Created
		</cfquery>
				
		<cfif Last.recordcount neq "0">
			<cfoutput>			    
				<tr><td class="labelit" align="center">#last.officerlastname# on: #DateFormat(last.created,CLIENT.DateFormatShow)# #timeformat(last.created,"HH:MM:SS")#</td></tr>
			</cfoutput>
		</cfif>
				
		
</table>