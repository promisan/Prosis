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
<cfparam name="url.application" default="">
<cfparam name="url.scope" default="">
<cfparam name="url.selected" default="">

<cfquery name="GetModule" datasource="AppsSystem" username="#SESSION.login#" password="#SESSION.dbpw#">

	SELECT M.*
	FROM   Ref_ApplicationModule AM
	INNER  JOIN Ref_SystemModule M
		   ON AM.SystemModule = M.SystemModule
	WHERE  AM.Code = '#url.application#'
	       AND M.Operational = 1

</cfquery>

<cfoutput>
<select name="#url.scope#SystemModule" id="#url.scope#SystemModule" class="regularxxl enterastab">
	<option>[Select]</option>
	<cfloop query="GetModule">
		<option value="#SystemModule#" <cfif url.selected eq SystemModule>selected</cfif> >#Description#</option>
	</cfloop>
</select>
</cfoutput>