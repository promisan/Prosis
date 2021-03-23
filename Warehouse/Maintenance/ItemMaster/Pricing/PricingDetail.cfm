<cfquery name="getDetail"
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  *
        FROM    ItemUoMPrice
        WHERE   ItemNo = '#URL.ItemNo#'				
        AND     UoM= '#URL.UoM#'
        AND     PriceSchedule = '#URL.PriceSchedule#'
        AND     Mission = '#URL.Mission#'
        <cfif trim(url.warehouse) eq "">
            AND     (Warehouse IS NULL OR LTRIM(RTRIM(Warehouse)) = '')
        <cfelse>
            AND     Warehouse = '#url.warehouse#'
        </cfif>
        ORDER BY DateEffective DESC
</cfquery>	

<div style="padding-top:5px; padding-bottom:5px; padding-left:5%;">
    <table width="100%" class="navigation_table" style="border:1px solid #c0c0c0;">
        <tr class="line labelmedium2" style="background-color:#F1F1F1;">
            <td style="padding-left:4px"><cf_tl id="Effective"></td>
            <td><cf_tl id="Currency"></td>
            <td align="right"><cf_tl id="Price"></td>
            <td align="center"><cf_tl id="Promotion"></td>
            <td><cf_tl id="Officer"></td>
            <td><cf_tl id="Created"></td>
        </tr>
        <cfoutput query="getDetail">
            <tr class="navigation_row labelmedium2">
                <td style="padding-left:4px">#dateformat(DateEffective, client.dateformatshow)#</td>
                <td>#Currency#</td>
                <td align="right">#NumberFormat(SalesPrice, ',.___')#</td>
                <td align="center"><cfif promotion eq 0><cf_tl id="No"><cfelse><cf_tl id="No"></cfif></td>
                <td>#OfficerUserId#</td>
                <td>#dateformat(Created, client.dateformatshow)#</td>
            </tr>
        </cfoutput>
        <cfif getDetail.recordCount eq 0>
            <tr class="navigation_row labelmedium2">
                <td colspan="6" align="center">
                    [ <cf_tl id="No price history for this element"> ]
                </td>
            </tr>
        </cfif>
    </table>
</div>

<cfset AjaxOnLoad("doHighlight")>