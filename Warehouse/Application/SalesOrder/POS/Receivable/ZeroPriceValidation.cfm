<cfquery name="getZeroLines"
        datasource="AppsTransaction"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
	    SELECT  C.Category,S.*,I.ItemNoExternal
	    FROM    Sale#url.warehouse# S INNER JOIN
	            Materials.dbo.WarehouseCategoryPriceSchedule C
	            ON S.ItemCategory = C.Category
	            AND S.Warehouse = C.Warehouse
	            AND S.PriceSchedule = C.PriceSchedule INNER JOIN
	            Materials.dbo.Item I ON I.ItemNo = S.ItemNo
	    WHERE   CustomerId      = '#url.customerid#'
		AND     AddressId       = '#url.addressid#'
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
               <td width="20%" style="font-family: Calibri; color: 808080; font-size:23px">
                   #getZeroLines.ItemNo# (#getZeroLines.ItemNoExternal#)
               </td>
                <td width="40%" style="font-family: Calibri; color: 808080; font-size:23px">
                    #getZeroLines.ItemDescription#
                </td>
                <td width="20%"></td>
            </tr>
       </cfloop>
        </table>
    </cfoutput>
    <cfabort>
</cfif>