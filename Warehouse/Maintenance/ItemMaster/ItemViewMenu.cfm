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
<cf_submenuleftscript>

<cfquery name="Mission" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Organization.dbo.Ref_Mission
	WHERE  Mission IN (SELECT Mission
					   FROM   ItemUoMMission
					   WHERE  ItemNo = '#URL.ID#'
					   AND    Operational = 1) 
</cfquery>

<cfset fcolor = "002350">
	 
<input type="hidden" name="optionselect" id="optionselect">	 
	 	 
<table style="width:210px">

<tr><td height="8"></td></tr>
<tr><td style="padding-left:7px">
	<cfset heading      = "Specifications">
	<cfset module       = "'Warehouse'">
	<cfset img          = "condition.gif">	
	<cfset selection    = "'Item'">
	<cfset menuclass    = "'Maintain'">
	<cfinclude template = "../../../Tools/SubmenuLeft.cfm">
</td></tr>

<tr><td id="entityselect" style="padding-left:10px;padding-top:14px;padding-bottom:0px">

<select name="mission" id="mission" class="regularxxl" style="width:205px" onchange="applymenu()">
	<cfoutput query="Mission">
	<option value="#mission#" <cfif mission eq url.mission>selected</cfif>>#mission#</option>
	</cfoutput>
</select>

</td></tr>

<tr class="labelmedium">
    <td align="center" style="padding:5px;color:gray">The below function apply to the selected entity only</td>
</tr>

<tr><td style="padding-left:7px">
	<cfset heading        = "Acquisition">
	<cfset module         = "'Warehouse'">
	<cfset img            = "locate3.gif">	
	<cfset selection      = "'Acquisition'">
	<cfset menuclass      = "'Maintain','Inquiry'">
	<cfinclude template  ="../../../Tools/SubmenuLeft.cfm">
</td></tr>

<tr><td style="padding-left:7px">
	<cfset heading        = "Storage">
	<cfset module         = "'Warehouse'">
	<cfset img            = "locate3.gif">	
	<cfset selection      = "'Storage'">
	<cfset menuclass      = "'Maintain','Inquiry'">
	<cfinclude template   = "../../../Tools/SubmenuLeft.cfm">
</td></tr>

<tr><td style="padding-left:7px">
	<cfset heading        = "Sales and Distribution">
	<cfset module         = "'Warehouse'">
	<cfset img            = "locate3.gif">	
	<cfset selection      = "'Distribution'">
	<cfset menuclass      = "'Maintain','Inquiry'">
	<cfinclude template="../../../Tools/SubmenuLeft.cfm">
</td></tr>


<tr><td style="padding-left:7px">
	<cfset heading        = "Analysis">
	<cfset module         = "'Warehouse'">
	<cfset img            = "locate3.gif">	
	<cfset selection      = "'Analysis'">
	<cfset menuclass      = "'Maintain','Inquiry'">
	<cfinclude template="../../../Tools/SubmenuLeft.cfm">
</td></tr>

</table>
