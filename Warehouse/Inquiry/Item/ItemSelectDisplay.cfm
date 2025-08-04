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

<cfparam name="url.selectuom" default="1">

<cfoutput>
<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Item
	WHERE ItemNo = '#URL.ItemNo#'
</cfquery>

<input type="text" name="itemno" id="itemno" size="4" value="#Item.ItemNo#" class="regularxl" readonly style="text-align: center;">
<input type="text" name="itemdescription" id="itemdescription" value="#Item.ItemDescription#" class="regularxl" size="30" readonly style="text-align: left;">
<cfif url.selectuom eq 1>
	
	<cfquery name="qUoM" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     ItemUoM
			WHERE    ItemNo = '#URL.ItemNo#'
			ORDER BY UOMMultiplier
	</cfquery>	

	<select name="itemuom" id="itemuom" class="regularxl">
		<cfloop query="qUoM">
			<option value="#UOM#" <cfif UOM eq url.uom>selected</cfif>>#UOMDescription#</option>
		</cfloop>
	</select> 
	
<cfelse>

	<cfquery name="qUoM" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     ItemUoM
			WHERE    ItemNo = '#URL.ItemNo#'
			AND		 UoM = '#url.uom#'
	</cfquery>	
	<input type="hidden" name="itemuom" id="itemuom" size="4" value="#qUoM.uom#" class="regularxl" readonly style="text-align: center;">
	( <input type="text" name="itemuomdesc" id="itemuomdesc" size="10" value="#qUoM.UOMDescription#" class="regularxl" readonly style="text-align: center;"> )
	
</cfif>
</cfoutput>		   