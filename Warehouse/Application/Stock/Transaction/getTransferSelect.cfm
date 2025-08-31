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
<cfquery name="loc" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   W.*, R.Description as LocationClassName
		FROM     WarehouseLocation W, Ref_WarehouseLocationClass R
		WHERE    Warehouse = '#url.warehouse#'		
		AND      W.LocationClass = R.Code
		AND      Location != '#url.location#'
</cfquery>

<cfoutput>

<select name="Tolocation" id="Tolocation">
	<cfloop query="loc">
		<option value="#Location#">#LocationClassName#: #Description#</option>
	</cfloop>
</select>		

</cfoutput>	

