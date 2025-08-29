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
<cfoutput>

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo = '#url.ItemNo#'		
</cfquery>

<cfset lnk = "ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getStockLevel.cfm?mission=#url.mission#&workorderidselect=#url.workorderid#&warehouse='+document.getElementById('warehouse').value+'&itemno=#url.ItemNo#&uom='+this.value+'&workorderid='+document.getElementById('workorderid').value+'&workorderline='+document.getElementById('workorderline').value,'stockbox')">

<cfif get.recordcount gte "4">
		
<select name="uom" id="uom" class="enterastab regularxl" 
onchange="#lnk#">
		
	<cfloop query="get">
		<option value="#UoM#">#UoMDescription#</option>
	</cfloop>
		
</select>	

<cfelse>
	
	<input type="hidden" name="uom" id="uom" value="#get.uom#">
	
	<table><tr>	
	<cfloop query="get">
	<td>
	<input onclick="#lnk#;document.getElementById('uom').value='#uom#'"
	     type="radio" class="enterastab radiol" name="uomselect" value="#UoM#" <cfif get.currentrow eq "1">checked</cfif>>	
		 </td>
		 <td class="labelmedium" style="padding-left:3px;padding-right:10px">
		#UoMDescription# 
		</td>
	</cfloop>
	</tr>
	</table>

</cfif>
	
<script language="JavaScript">
   document.getElementById('boxwarehouse').className = "regular"
   ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/getWarehouse.cfm?mission=#url.mission#&workorderid=#url.workorderid#&itemno=#url.ItemNo#&uom=#get.uom#','boxwarehouse')		
</script>

</cfoutput>		

