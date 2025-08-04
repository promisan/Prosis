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
	
	<!--- content for the calendar date to be shown  --->
	
	<cfif ParameterExists(Listing)> 
	
		<!--- continued --->
	
	<cfelse>
								
		<cfinvoke component = "Service.Process.Materials.Taskorder"  
		   method           = "TaskorderList" 
		   tasktype         = "Internal"		   
		   mission          = "#url.mission#"
		   warehouse        = "#url.warehouse#"	   		  
		   mode             = "Pending"
		   stockorderid     = ""
		   selected         = ""
		   returnvariable   = "listing">	
		  		  		   		   
	</cfif>	   
			
	<cfquery name="getpending" dbtype="query">
			SELECT   ItemDescription, 
			         COUNT(DISTINCT TaskOrderReference) as Stockorder, 
			         COUNT(*) as tasks
			FROM     Listing
			WHERE    DeliveryDate = '#dateformat(url.calendardate,client.dateSQL)#'
			GROUP BY ItemDescription
	</cfquery>		
		
	<cfif url.calendardate gte now()>
	 <cfset cl = "transparent">
	<cfelse>
	 <cfset cl = "FFCACA"> 
	</cfif>
	
	<cfif getPending.recordcount gte "1">
			
	<table width="98%" align="center" height="100%" bgcolor="<cfoutput>#cl#</cfoutput>">
	
		<tr><td class="linedotted" colspan="2"></td></tr>

		<cfoutput query="getPending">
			<tr><td class="label" style="padding-left:4px">#Itemdescription#</td>			
			<td class="label" align="right" style="padding-right:4px"><font size="1">(#StockOrder#)</font>&nbsp;#tasks#</td></tr>
		</cfoutput>

	</table>	
	
	<cfelse>
	
		<cf_compression>
	
	</cfif>
	