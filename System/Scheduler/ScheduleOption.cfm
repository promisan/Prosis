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

<!--- Query returning search results --->
<cfquery name="Schedule"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Schedule S
	WHERE  ScheduleId = '#URL.ID#'
</cfquery>

<cfquery name="Host" 
	datasource="AppsInit">
	SELECT *
	FROM    Parameter P 
	WHERE   P.HostName = '#CGI.HTTP_HOST#' 
	</cfquery>

<cfoutput>
	
	<cfif schedule.operational eq "1" and 
	(Schedule.applicationserver eq host.Applicationserver 
	     or Schedule.ApplicationServer eq CGI.HTTP_HOST)>
	
	  <img src="#CLIENT.VirtualDir#/Images/Execute.png" 
	      alt="Run Selected Task" 
		  name="img8#schedule.schedulename#" 
		  style="cursor: pointer;" 
		  width="17" 
		  height="17" 
		  border="0" 
		  onClick="recordrun('#Schedule.ScheduleId#');"
		  align="absmiddle">
		  
	<cfelse>
		
		<cf_compression>	  
	
	</cfif>		
	
</cfoutput>	
