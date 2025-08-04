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

<cfparam name="url.selected" default="">

<cfquery name="Reason" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_PersonGroup
	WHERE ActionCode = '#url.actionCode#'			
</cfquery>

<cfquery name="getList" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *
    FROM     Ref_PersonGroupList
	WHERE    GroupCode = '#Reason.Code#' 
	ORDER BY GroupListOrder						
</cfquery>

<cfoutput>

<cfif getList.recordcount eq "0">

	<input type="hidden" name="GroupCode"     value="">
	<input type="hidden" name="GroupListCode" value="">

<cfelse>
	
	<input type="hidden" name="GroupCode" value="#getList.GroupCode#">
	
	<select name="GroupListCode" class="regularxl enterastab" style="width:300px">	
		<cfloop query="getlist">
			<option value="#grouplistcode#" <cfif url.selected eq grouplistcode>selected</cfif>>#Description#</option>
		</cfloop>
	</select>

</cfif>

</cfoutput>