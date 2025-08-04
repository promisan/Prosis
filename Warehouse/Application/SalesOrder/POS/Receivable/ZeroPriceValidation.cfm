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
<cfquery name="getZeroLines"
   datasource="AppsMaterials"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	    SELECT  C.Category,S.*,I.ItemNoExternal
	    FROM    vwCustomerRequest S 
				INNER JOIN Materials.dbo.WarehouseCategoryPriceSchedule C ON S.ItemCategory = C.Category
				     AND S.Warehouse = C.Warehouse
	                 AND S.PriceSchedule = C.PriceSchedule 
			    INNER JOIN Materials.dbo.Item I ON I.ItemNo = S.ItemNo
	    WHERE   RequestNo       = '#url.RequestNo#'		
	    AND     S.SalesPrice    = 0
	    AND     C.SalePriceZero = 1
</cfquery>

<cfif getZeroLines.recordcount neq 0>
    <cfoutput>
    <table width="100%">
        <tr valign="top">
            <td width="20%"></td>
            <td colspan="2" style="font-family: Calibri; color: 808080; font-size:23px">
                <cf_tl id="The following items have zero price">
            </td>
            <td width="20%"></td>
        </tr>
       <cfloop query="getZeroLines">
            <tr valign="top">
               <td width="20%"></td>
               <td width="20%" style="font-family: Calibri; color: 808080; font-size:23px">#getZeroLines.ItemNo# (#getZeroLines.ItemNoExternal#)</td>
               <td width="40%" style="font-family: Calibri; color: 808080; font-size:23px">#getZeroLines.ItemDescription#</td>
               <td width="20%"></td>
            </tr>
       </cfloop>
        </table>
    </cfoutput>
    <cfabort>
</cfif>