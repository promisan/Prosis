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
<cf_screentop html="no">

<cfif url.capacity eq 0>
	<cfset auxCapacity = 1>
<cfelse>
	<cfset auxCapacity = url.capacity>
</cfif>

<cfoutput>
<table style="font-size:#tooltipFontSize#;" width="#url.tableSize#">
	<tr>
		<td width="50%"><cf_tl id="Warehouse">:</td>
		<td><b>#url.warehouseName# / #url.locationName#</b></td>
	</tr>	
	<tr>
		<td><cf_tl id="Official Capacity">:</td>
		<td><b>#lsnumberFormat(url.capacity,'#url.itemPrecision#')# #url.uom#</b></td>
	</tr>
	<tr>
		<td valign="top"><cf_tl id="Actual Capacity">:</td>
		<td><b>#lsnumberFormat(url.actualcapacity,'#url.itemPrecision#')# #url.uom#<br>(<cfif url.actualLabel eq -1><i>No strapping reference</i><cfelse>#lsnumberFormat(url.actualLabel,',._')# units aprox.</cfif>)</b></td>
	</tr>
	<tr>
		<td valign="top"><cf_tl id="Minimum Stock">:</td>
		<td><b>#lsnumberFormat(url.minimumcapacity,'#url.itemPrecision#')# #url.uom#<br>(<cfif url.minimumLabel eq -1><i>No strapping reference</i><cfelse>#lsnumberFormat(url.minimumLabel,',._')# units aprox.</cfif>)</b></td>
	</tr>
	<tr>
		<td valign="top">#url.levelText#:</td>
		<td><b>#lsnumberFormat(url.balance,'#url.itemPrecision#')# #url.uom#<br>(<cfif url.level eq -1><i>No strapping reference</i><cfelse>#lsnumberFormat(url.level,',._')# units aprox.</cfif>)</b></td>
	</tr>
	<tr>
		<td valign="top"><cf_tl id="Ullage">:</td>
		<td><b>#url.ullageText#</b></td>
	</tr>
	<cfif url.showTank neq 1>
	
	<cfif url.gGraphType neq "loss">
	<tr>
		<td valign="top">#url.strapText#:</td>
		<td><b>#lsnumberFormat(url.strapbalance,'#url.itemPrecision#')# #url.uom#<br>(#lsnumberFormat(url.straplevel,',._')# <cf_tl id="units">)</b></td>
	</tr>
	</cfif>
	<tr>
		<td><cf_tl id="Acceptable Losses">:</td>
		<td>
			<cf_getLossValue
				id="#url.ItemLocationId#"
				date="#now()#">
				<b>#lsNumberFormat(resultTotalLoss,",.__")# #url.uom#</b>
		</td>
	</tr>
	
	</cfif>
</table>
</cfoutput>