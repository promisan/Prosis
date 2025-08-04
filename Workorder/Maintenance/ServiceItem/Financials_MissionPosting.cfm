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
<cfquery name="getMissionPosting" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ServiceItemMissionPosting
	WHERE 	ServiceItem	= '#url.id1#'
	AND		Mission = '#url.id2#'
	ORDER BY SelectionDateExpiration DESC
</cfquery>
<cfoutput>
	<font color="808080">
	<cfif getMissionPosting.recordcount gt 0>		
		#Dateformat(getMissionPosting.SelectionDateExpiration, "#CLIENT.DateFormatShow#")#, <cfif getMissionPosting.ActionStatus eq 0>Open<cfelseif getMissionPosting.ActionStatus eq 1><b>Closed</b></cfif>, #getMissionPosting.recordcount# record<cfif getMissionPosting.recordcount gt 1>s</cfif>			
	<cfelse>
		No periods defined
	</cfif>
	</font>
</cfoutput> 