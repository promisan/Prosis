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

<cfoutput>

<input name = "month" id = "month" type = "hidden">
<input name = "scale" id = "scale" type = "hidden" value="#scale#">				

<table width="100%" cellspacing="0" cellpadding="0">

<tr class="line">
	<td bgcolor="EAFBFD" style="height:40px">
	<table width="100%" cellspacing="0" cellpadding="0"><tr>
	   
	    <td style="padding-left:8px">
		
		<table cellspacing="0" cellpadding="0" bgcolor="E9E9E9" style="border:1px solid gray">
		<tr>
		
		<td bgcolor="ffffaf" class="labelmedium" style="padding-right:12px;padding-left:10px">#getMetrics.Metric#</td>
			
		<input type="hidden" id="iselect" value="0">
	
		<cfloop from="0" to ="#mMax#" index="i">
			
			<cfif url.month eq "" and i eq 0>
				<cfset vClass = "highlight labelit">
			<cfelse>
				<cfset vClass = "blue labelit">
			</cfif>
									
			<td class = "#vClass#" 
			  style   = "cursor:pointer;height:15;width:40" 
			  align   = "center" 
			  id      = "#qConsumptionData.supplyItemNo#_month_#i#" 
			  onclick = "_cf_loadingtexthtml='';getchart('#url.assetid#',document.getElementById('viewmodeselect').value,'#scale#','#i#','#mMax#','#qConsumptionData.supplyItemNo#');document.getElementById('iselect').value='#i#'">
			
				<cfif i eq 0>
					<cfset display = "All">
				<cfelse>
					<cfset display = left(MonthAsString(i),3)>
				</cfif>
				#display#				
				
			</td>
			
		</cfloop>	

		</tr>
		
		</table>
		
		</td>
		
		<td align="right" style="padding-right:3px">
		
		    <input type="hidden" id="viewmodeselect" value="chart">
			
			<table class="formspacing">
			
			<tr><td>
				<input type="radio" class="radiol" name="viewmode" id="viewmode"
				onclick = "getchart('#url.assetid#','chart','#scale#',document.getElementById('iselect').value,'#mMax#','#qConsumptionData.supplyItemNo#');document.getElementById('viewmodeselect').value='chart'"
				value="chart" checked>
				</td>
				<td style="padding-left:4px;padding-right:4px" class="labelmedium">Chart</td>
				<td>
				<input type="radio" class="radiol" name="viewmode" id="viewmode" value="issue" 
				onclick = "getchart('#url.assetid#','issue','#scale#',document.getElementById('iselect').value,'#mMax#','#qConsumptionData.supplyItemNo#');document.getElementById('viewmodeselect').value='issue'">
				</td>
				<td style="padding-left:4px;padding-right:4px" class="labelmedium">Issuances</td>
			</tr>
			</table>
		
		</td>
		</tr>
		
	</table>
	</td>				
</tr>

<tr><td height="5"></td></tr>

<tr>
	<td id="dGraph_#qConsumptionData.supplyItemNo#" align="center" valign="middle">							    						    								
		<cfset url.scale = scale>
		<cfset url.mode = "chart">
		<cfinclude template = "AssetSupplyConsumptionViewPresentationGraph.cfm">								
	</td>
</tr>

</table>

</cfoutput>