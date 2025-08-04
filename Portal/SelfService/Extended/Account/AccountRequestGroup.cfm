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
<!--- select a relevant authorization group for workflow processing actors --->

<cfparam name="url.owner" default="">

<!--- <cfquery name="Workgroup" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
	FROM    Ref_Application
	WHERE   Owner = '#URL.Owner#'
</cfquery> --->

<cfquery name="Workgroup" 
datasource="AppsSystem">
    SELECT  *
	FROM    Ref_Application
	WHERE   Owner = '#URL.Owner#'
	<!--- AND		HostName = '#CGI.HTTP_HOST#' --->
</cfquery>

<cfif WorkGroup.recordcount gte "1">

    <select name="Workgroup" id="Workgroup" onChange="updateMission()" class="regularxl enterastab">
	<option value="">[Select]</option>
    <cfoutput query="Workgroup">
	<option value="#Code#" <cfif CGI.HTTP_HOST eq Workgroup.HostName>selected</cfif> >#Description#</option>
	</cfoutput>
    </select> 
	
	<!--- <input type="hidden" name="Workgroup" id="Workgroup" value="#CGI.HTTP_HOST#">
	#Workgroup.Description# --->
	
</cfif>		

<cfset ajaxOnLoad("updateMission")>