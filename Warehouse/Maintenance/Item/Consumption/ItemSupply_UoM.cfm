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
<cfquery name="getLookup" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ItemUoM
		WHERE	ItemNo = '#URL.ID#'
</cfquery>
<cfoutput>
<input type="Hidden" name="countUoM" id="countUoM" value="#getLookup.recordCount#">
<select name="SupplyItemUoM" id="SupplyItemUoM" class="regularxl">
	<cfloop query="getLookup">
	  <option value="#getLookup.UoM#" <cfif getLookup.UoM eq URL.uom>selected</cfif>>#getLookup.UoM# - #getLookup.UoMDescription#</option>
  	</cfloop>
</select>
</cfoutput>
 