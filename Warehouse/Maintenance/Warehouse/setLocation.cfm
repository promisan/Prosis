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
<cfquery name="getLocations" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	L.*,
			(LocationCode + ' - ' + LocationName) as LocationDisplay
	FROM   	Location L
	WHERE  	L.Mission = '#url.mission#'
	AND		L.StockLocation = 1
</cfquery>

<cfif getLocations.recordcount eq "0">

<select name="locationId" id="locationId"  class="regularxl">
	<option value=""><cf_tl id="Not available"></option>
</select>		

<cfelse>

<select name="locationId" id="locationId"  class="regularxl">
<cfoutput query="getlocations">
	<option value="#Location#">#LocationDisplay#</option>
</cfoutput>
</select>		

</cfif>	