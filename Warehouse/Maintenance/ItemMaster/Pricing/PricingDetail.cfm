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
<cfquery name="getDetail"
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT    *
        FROM      ItemUoMPrice
        WHERE     ItemNo  = '#URL.ItemNo#'				
        AND       UoM     = '#URL.UoM#'
        AND       PriceSchedule = '#URL.PriceSchedule#'
        AND       Mission = '#URL.Mission#'
        <cfif trim(url.warehouse) eq "">
            AND     (Warehouse IS NULL OR LTRIM(RTRIM(Warehouse)) = '')
        <cfelse>
            AND     Warehouse = '#url.warehouse#'
        </cfif>
        ORDER BY DateEffective DESC
</cfquery>	

<table width="90%" align="right" class="navigation_table" style="border-left:1px solid silver">
    <tr class="line labelit fixlengthlist" style="background-color:#F1F1F1;height:10px">
        <td style="padding-left:4px"><cf_tl id="Effective"></td>
        <td><cf_tl id="Currency"></td>
        <td align="right"><cf_tl id="Price"></td>
        <td align="center"><cf_tl id="Promotion"></td>
        <td><cf_tl id="Officer"></td>
        <td><cf_tl id="Created"></td>
    </tr>
    <cfoutput query="getDetail">
	    <cfif currentrow neq "1">
		
		    <tr class="navigation_row labelit line fixlengthlist" style="height:20px">
            <td style="padding-left:4px">#dateformat(DateEffective, client.dateformatshow)#</td>
            <td>#Currency#</td>
            <td align="right">#NumberFormat(SalesPrice, ',.___')#</td>
            <td align="center"><cfif promotion eq 0><cf_tl id="No"><cfelse><cf_tl id="No"></cfif></td>
            <td>#OfficerUserId#</td>
            <td>#dateformat(Created, client.dateformatshow)#</td>
        </tr>
		</cfif>
    </cfoutput>
    <cfif getDetail.recordCount eq 0>
        <tr class="navigation_row labelmedium2">
            <td colspan="6" align="center">
                [ <cf_tl id="No price history for this element"> ]
            </td>
        </tr>
    </cfif>
</table>
	
<cfset AjaxOnLoad("doHighlight")>