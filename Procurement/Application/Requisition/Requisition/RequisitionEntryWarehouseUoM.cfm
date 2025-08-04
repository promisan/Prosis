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

<cfparam name="URL.reqid"  default="">
<cfparam name="URL.uom"    default="">
<cfparam name="URL.itemno" default="">

<cfif url.reqid neq "">
	
	<cfquery name="get" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     RequisitionLine
			WHERE    RequisitionNo = '#url.ReqId#'					
	</cfquery>
		
	<cfset url.uom    = get.WarehouseUoM>
	<cfset url.itemno = get.WarehouseItemNo>

</cfif>

<cfquery name="UoM" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo = '#url.ItemNo#'		
		AND      UoM    = '#url.UoM#'	
</cfquery>

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo = '#url.ItemNo#'		
</cfquery>

<cfoutput>

	<input type="hidden" name="quantityuom" id="quantityuom" value="#UoM.UoMDescription#" size="10" maxlength="20" readonly> 

	<select name="warehouseuom" id="warehouseuom" class="enterastab regularxxl" onchange="document.getElementById('quantityuom').value=this.options[this.selectedIndex].text">
	<cfloop query="get">
		<option value="#UoM#" <cfif url.uom eq UoM>selected</cfif>>#UoMDescription#</option>
	</cfloop>
	</select>

</cfoutput>		
	
					
	
		