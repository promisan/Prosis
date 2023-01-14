<cfparam name="url.receiptid" default="">

<cfquery name="Receipt" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  *
        FROM    Receipt
        WHERE   ReceiptNo = '#url.receiptid#'
</cfquery>

<cfquery name="ReceiptLines" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  *
        FROM    PurchaseLineReceipt
        WHERE   ReceiptNo = '#url.receiptid#'
        AND     ActionStatus != '9'
        ORDER BY ReceiptItem ASC
</cfquery>

<cfquery name="GetPrices" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	P.*
		FROM   	skMissionItemPrice P
		WHERE  	Mission = '#Receipt.mission#'
</cfquery>

<cf_tl id="View Item" var="lblViewItem">
<cf_tl id="Print" var="vPrintLabel">

<cfoutput>
    <table width="100%" height="100%" class="formpadding">
        <tr>
            <td valign="top" style="width:20%; border-right:1px solid ##C0C0C0;">
                <table width="100%" class="formpadding">
                    <tr>
                        <td colspan="2" class="labellarge" style="font-weight:bold; font-size:110%;">
                            #url.receiptid#   
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="labellarge" style="font-size:110%; padding-bottom:15px;">
                            #Receipt.mission# 
                        </td>
                    </tr>
                    <tr>
                        <td width="5%">
                            <input type="checkbox" class="clsPrintLabelParameterCheck" name="fdescription" id="fdescription" style="height:15px; width:15px;" checked>
                        </td>
                        <td class="labelmedium" style="padding-left:5px;"><label for="fdescription"><cf_tl id="Description"></label></td>
                    </tr>
                    <tr>
                        <td width="5%">
                            <input type="checkbox" class="clsPrintLabelParameterCheck" name="fbarcode" id="fbarcode" style="height:15px; width:15px;" checked>
                        </td>
                        <td class="labelmedium" style="padding-left:5px;"><label for="fbarcode"><cf_tl id="Barcode"></label></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cfquery name="GetDistinctPrices" dbtype="query">
                                SELECT DISTINCT 
                                        PriceSchedule, 
                                        PriceScheduleDescription
                                FROM   	GetPrices
                                ORDER BY ListingOrder ASC
                            </cfquery>
                            <cfloop query="GetDistinctPrices">
                                <table width="100%">
                                    <tr>
                                        <td width="5%">
                                            <input 
                                                type="checkbox" 
                                                class="clsPrintLabelParameterCheckPrice" 
                                                name="fprice#priceschedule#" 
                                                id="fprice#priceschedule#" 
                                                value="#priceschedule#"
                                                style="height:15px; width:15px;" 
                                                checked>
                                        </td>
                                        <td class="labelmedium" style="padding-left:5px;"><label for="fprice#priceschedule#">#PriceScheduleDescription#</label></td>
                                    </tr>
                                </table>
                            </cfloop>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="padding-top:15px;">
                            <input 
                                type="button" 
                                value="#vPrintLabel#" 
                                class="button10g" 
                                onclick="printReceiptLabels('#Receipt.mission#');">
                            <cfdiv id="divPrintList" />
                        </td>
                    </tr>
                </table>
            </td>
            <td valign="top" style="padding-left:10px; overflow:auto;">
                <table width="100%">
                    <tr class="line">
                        <td>
                            <input 
                                type="checkbox" 
                                name="fitemselectall" 
                                id="fitemselectall" 
                                style="height:15px; width:15px;" 
                                onclick="$('.clsPrintLabelParameterCheckItem').prop('checked', this.checked)"
                                checked>
                        </td>
                        <td class="labellarge">
                            <cf_tl id="Items to Print" var="1">
                            #lt_text#
                        </td>
                    </tr>
                    <cfloop query="ReceiptLines">
                        <cfquery name="GetItemPrices" dbtype="query">
                            SELECT  PriceSchedule, 
                                    PriceScheduleDescription
                            FROM   	GetPrices
                            WHERE  	ItemNo = '#WarehouseItemNo#'
                            AND    	UoM    = '#WarehouseUoM#'
                            ORDER BY ListingOrder ASC
                        </cfquery>
                        <cfset vPrices = ValueList(GetItemPrices.PriceScheduleDescription, ", ")>
                            <tr>
                                <td width="5%">
                                    <cfif trim(vPrices) neq "">
                                        <input 
                                            type="checkbox" 
                                            class="clsPrintLabelParameterCheckItem" 
                                            name="fitem#WarehouseItemNo##WarehouseUoM#" 
                                            id="fitem#WarehouseItemNo##WarehouseUoM#" 
                                            value="#receiptId#"
                                            style="height:15px; width:15px;" 
                                            checked>
                                    <cfelse>
                                        &nbsp;
                                    </cfif>
                                </td>
                                <td class="labelmedium" style="padding-left:5px;">
                                    <label for="fitem#WarehouseItemNo##WarehouseUoM#">
                                        #ReceiptItem# [<a title="#lblViewItem#" href="javascript:item('#WarehouseItemNo#','','#Receipt.mission#')">#ReceiptItemNo#</a>]
                                        <cfif trim(vPrices) neq "">
                                            <span style="font-size:65%; color:##808080;">(#vPrices#)</span>
                                        <cfelse>
                                            <span style="font-size:65%; color:##f54242;">(<cf_tl id="No prices defined">)</span>
                                        </cfif>
                                    </label>
                                </td>
                            </tr>
                            <tr><td colspan="2" class="line"></td></tr>
                    </cfloop>
                </table>
            </td>
        </tr>
    </table>
    
</cfoutput>