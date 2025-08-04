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
	
<!--- shows the information for the date as to how many are pending for that date --->
	
<cftry>
	
	<cfquery name="get"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    BatchDescription, count(*) as Counted
		FROM      StockBatch_#SESSION.acc#
		WHERE     TransactionDate = '#dateformat(url.calendardate,client.dateSQL)#'			
		GROUP BY BatchDescription
	</cfquery>
	
	<cfif url.Status eq "0">
		<cfset cl = "yellow">
	<cfelseif url.Status eq "9">	
	    <cfset cl = "red">
	<cfelse>
	    <cfset cl = "lime">	
	</cfif>	
	
	<cfif get.recordcount gte "1">
	
	<table width="98%" align="center">
		
			<cfoutput query="get">
				<tr class="labelmedium" style="height:20px">
				<td style="height:10px;padding-left:2px">#BatchDescription#:</td>			
				<td align="right" style="height:10px;padding-left:2px;padding-right:4px;">#Counted#</td>
				</tr>			
			</cfoutput>
	
	</table>	
		
	</cfif>
	
	<cfcatch>
	
	<table><tr><td><font color="FF0000">problem</font></td></tr></table>
	
	</cfcatch>
	
</cftry>
