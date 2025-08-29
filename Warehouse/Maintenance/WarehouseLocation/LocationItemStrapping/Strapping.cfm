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
<cfparam name="url.showOpenST" default="0">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" id="tableStrappingContainer" class="formpadding">

	<tr><td height="5"></td></tr>
	
	<tr>
		
		<td width="50%"
		    valign="top"
		    style="padding-right:10px;">			
			<cf_divscroll>
				<cfinclude template="StrappingList.cfm">			
			</cf_divscroll>	
		</td>
		
		<td width="50%">
			<cfset vLink = "#SESSION.root#/warehouse/maintenance/WarehouseLocation/LocationItemStrapping/StrappingGraph.cfm">				
			<cfset vParameters = "warehouse=#url.warehouse#&location=#url.location#&itemno=#url.itemno#&uom=#url.uom#&strappingLevel=0">
			<cfdiv id="divGraphTank" bind="url:#vLink#?#vParameters#">
		</td>
	</tr>

</table>	