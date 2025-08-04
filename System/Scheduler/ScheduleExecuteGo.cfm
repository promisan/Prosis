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
<cfquery name="Template"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Schedule S
	WHERE  ScheduleId = '#URL.ID#' 
</cfquery>

<!--- verify if a schedule is already running for this id with a actionstatus = 0 and created time less than
10 minutes different then we do not launch this one --->
			
<cfoutput> 
	<cfdiv bind="url:#SESSION.root#/Tools/Scheduler/RunScheduler.cfm?idlog=#url.idlog#&id=#url.id#&mode=schedule&#Template.SchedulePassThru#">
</cfoutput>

