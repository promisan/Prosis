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
<cfquery name="getCustomers" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT	*
	FROM	Customer
	WHERE  	Mission = '#url.mission#'
	ORDER BY CustomerName
	
</cfquery>

<select name="Crit2_Value" id="Crit2_Value" class="regularxl">
	<option value="">- All -</option>
	<cfoutput query="getCustomers">
		<option value="#getCustomers.CustomerId#">#getCustomers.CustomerName#</option>
	</cfoutput>
</select>	