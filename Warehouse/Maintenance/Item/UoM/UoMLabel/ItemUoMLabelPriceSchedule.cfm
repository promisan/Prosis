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
<cfquery name="getConfigMission" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	skMissionItemPrice 
		WHERE  	ItemNo = '#url.item#'
		AND    	UoM    = '#url.uom#'
        AND     Mission = '#url.mission#'
		ORDER BY ListingOrder ASC
</cfquery>

<cfoutput query="getConfigMission">
    <table width="100%">
        <tr>
            <td width="5%">
                <input type="checkbox" class="clsPrintLabelParameterCheck" name="fprice#priceschedule#" id="fprice#priceschedule#" style="height:15px; width:15px;" onclick="refreshLabelEPLButton('#url.item#', '#url.uom#')" <cfif fieldDefault eq 1>checked</cfif>>
            </td>
            <td class="labelmedium" style="padding-left:5px;"><label for="fprice#priceschedule#">#PriceScheduleDescription#</label></td>
        </tr>
    </table>
</cfoutput>

<cfset ajaxOnLoad("function() { refreshLabelEPLButton('#url.item#', '#url.uom#') }")>