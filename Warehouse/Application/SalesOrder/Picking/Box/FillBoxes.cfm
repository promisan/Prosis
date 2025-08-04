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
<cfquery name="getTransaction" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  T.*,
                U.UoMDescription,
                I.ItemNoExternal
        FROM    ItemTransaction T WITH (NOLOCK)
                INNER JOIN Item I WITH (NOLOCK)
                    ON T.ItemNo = I.ItemNo
                INNER JOIN ItemUoM U WITH (NOLOCK)  
                    ON T.ItemNo = U.ItemNo
                    AND T.TransactionUoM = U.UoM
        WHERE   T.TransactionId = '#url.transactionId#'
</cfquery> 

<cfquery name="getBoxes" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  C.*,
                (SELECT CollectionQuantity FROM ItemTransactionCollection WHERE CollectionId = C.CollectionId AND TransactionId = '#url.transactionId#') as Quantity,
                (SELECT Memo FROM ItemTransactionCollection WHERE CollectionId = C.CollectionId AND TransactionId = '#url.transactionId#') as Memo
        FROM   WarehouseBatchCollection C
        WHERE  C.BatchNo = '#url.batchno#'
        ORDER BY CONVERT(INT, C.CollectionCode) ASC
</cfquery> 

<cfif getBoxes.recordCount eq 0>
    <cfinclude  template="createDefaultBox.cfm">
    <cfquery name="getBoxes" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
            SELECT  C.*,
                    (SELECT CollectionQuantity FROM ItemTransactionCollection WHERE CollectionId = C.CollectionId AND TransactionId = '#url.transactionId#') as Quantity,
                    (SELECT Memo FROM ItemTransactionCollection WHERE CollectionId = C.CollectionId AND TransactionId = '#url.transactionId#') as Memo
            FROM   WarehouseBatchCollection C
            WHERE  C.BatchNo = '#url.batchno#'
            ORDER BY C.CollectionCode ASC
    </cfquery>
</cfif>

<cfset vTransactionQuantity = getTransaction.transactionQuantity*-1>
<cfset vCollectedQuantity = 0>
<cfquery name="qCollected" dbtype="query">
    SELECT SUM(Quantity) as Total
    FROM getBoxes
</cfquery>

<cfif qCollected.recordCount eq 1 AND qCollected.Total neq "">
    <cfset vCollectedQuantity = qCollected.Total>
</cfif>
<cfset vCollectedPending = vTransactionQuantity - vCollectedQuantity>
<cfif vCollectedPending lt 0>
    <cfset vCollectedPending = 0>
</cfif>

<iframe name="iSubmitBoxesForm" style="display:none;"></iframe>

<cfoutput>
    <form 
        name="fillBoxesForm" 
        method="POST" 
        target="iSubmitBoxesForm"
        action="#session.root#/warehouse/application/salesorder/picking/box/FillBoxesSubmit.cfm?batchno=#url.batchno#&submitid=#url.submitid#&transactionid=#url.transactionid#">

        <table width="100%" align="center">
            <tr>
                <td style="padding-bottom:20px; font-size:18px; width:99%;" title="#getTransaction.itemdescription#">
                    <b>#numberformat(vTransactionQuantity, ",")#</b> #getTransaction.uomdescription# - 
                    <b>#getTransaction.ItemNoExternal#</b> 
                    <cfif trim(len(getTransaction.itemdescription)) gt 50>
                        #left(getTransaction.itemdescription, 50)#...
                    <cfelse>
                        #getTransaction.itemdescription#
                    </cfif>
                <td>
                <td style="padding-left:20px; padding-top:5px;" valign="top">
                    <select name="boxestoadd" id="boxestoadd" style="">
                        <cfloop index="iBox" from="1" to="100">
                            <option value="#iBox#"> #iBox#
                        </cfloop>
                    </select>
                </td>
                <cf_tl id="Add box" var="1">
                <td style="padding-left:10px; padding-bottom:20px; cursor:pointer;" title="#lt_text#">
                    <i class="fad fa-box" style="font-weight:bold; font-size:30px; color:##c83702;" onclick="addQuickBox('#url.submitid#','#url.transactionid#','#url.batchno#',$('##boxestoadd').val())"></i>
                    <div style="font-size:16px; font-weight:bold; padding-left:10px; margin-top:-22px; display:block; color:##353535;">
                        +
                    </div>
                </td>
            </tr>
        </table>

        <table width="95%" align="center" class="table table-striped table-bordered table-hover">
            <thead>
                <tr>
                    <th style="text-align:center;">
                        <cf_tl id="Distribute evenly" var="1">
                        <i class="fas fa-th" title="#lt_text#" style="padding-right:10px; font-size:115%; color:##c83702; cursor:pointer;" onclick="distributeEvenly(#vTransactionQuantity#);"></i> <cf_tl id="Box/Bag">
                    </th>
                    <th style="text-align:center;"><cf_tl id="Items"></th>
                    <th><cf_tl id="Memo"></th>
                </tr>
            </thead>
            <tbody>
                <cfloop query="getBoxes">
                    <cfset vThisId = replace(collectionid, "-", "", "ALL")>
                    <tr>
                        <td style="text-align:center;">
                            <i class="fad fa-box" style="font-weight:bold; font-size:28px; color:##c83702; cursor:pointer;" onclick="putItemsIntoBox('#vThisId#', #vTransactionQuantity#);"></i>
                            <div style="font-size:12px; font-weight:normal; padding-left:1px; margin-top:-17px; display:block; color:##353535;">
                                #CollectionCode#
                            </div>
                            <cfif collectionCode neq collectionName>
                                <div style="font-size:12px; font-weight:normal; padding-left:1px; display:block; color:##353535;">
                                    #CollectionName#
                                </div>
                            </cfif>
                        </td>
                        <td style="text-align:center;">
                            <cfset vQuantity = Quantity>
                            <cfif vCollectedPending gt 0 AND (Quantity eq "" OR Quantity eq 0)>
                                <cfset vQuantity = vCollectedPending>
                                <cfset vCollectedPending = 0>
                            </cfif>
                            <input type="number" id="fbQuantity_#vThisId#" class="clsBoxQuantity" name="fbQuantity_#vThisId#" min="0" max="9999999" value="#vQuantity#" style="width:75px; text-align:center;">
                        </td>
                        <td>
                            <input type="textbox" id="fbMemo_#vThisId#" name="fbMemo_#vThisId#" maxlength="100" value="#Memo#" style="padding-left:5px; width:100%;">
                        </td>
                    </tr>
                </cfloop>
            </tbody>
        </table>

        <div style="text-align:center;">
            <cf_tl id="Save and Consolidate" var="1">
            <input type="submit" class="btn" value="#lt_text#" onclick="return validateBoxQuantities(#vTransactionQuantity#);">
        </div>

        <div style="display:none;" id="boxFillSubmit"></div>

    </form>

</cfoutput>