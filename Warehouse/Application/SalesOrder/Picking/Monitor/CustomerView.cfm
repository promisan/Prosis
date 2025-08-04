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
<cf_mobile appId="customerview">

    <cf_tl id="refresh" var="lblRefresh">

    <cfset vColorOn = "12AEAE">
    <cfset vColorOff = "DEDEDE">
    <cfset vColorOnHold = "F28D8D">
    <cfset vColorLineRangeInit = "[255,255,255]">
    <cfset vColorLineRangeEnd = "[150,245,112]">

    <cfoutput>
        <style>
            html{
                height:98%;
            }

            .titletext {
                color:##033f5d;
            }

            .clsMainContainerBatch {
                border-radius:5px;
                -webkit-transition: all 1s ease-out;
                -moz-transition: all 1s ease-out;
                -o-transition: all 1s ease-out;
                transition: all 1s ease-out;
            }

            .refresh-button {
                position:fixed; 
                top:15px; 
                right:20px; 
                z-index:99; 
                color:##033F5D; 
                background-color:##EEEEEE;
                border:1px solid ##C0C0C0; 
                padding:8px; 
                cursor:pointer;                
            }

        </style>

        <cf_systemscript>

        <script>

		    _cf_loadingtexthtml='<i class="fa fa-cog fa-spin"></i>';

            function doRefreshStatus(b) {
                ColdFusion.navigate('#session.root#/warehouse/application/salesorder/picking/refreshStatus.cfm?&batchno='+b,'refresh'+b);
            }

            function colorByPercentage(color2, color1, weight) {
                var p = weight;
                var w = p * 2 - 1;
                var w1 = (w/1+1) / 2;
                var w2 = 1 - w1;
                var rgb = [Math.round(color1[0] * w1 + color2[0] * w2),
                    Math.round(color1[1] * w1 + color2[1] * w2),
                    Math.round(color1[2] * w1 + color2[2] * w2)];
                return rgb;
            }

            function getLineColor(w) {
                var vColor = colorByPercentage(#vColorLineRangeInit#, #vColorLineRangeEnd#, w);
                return vColor;
            }

        </script>
        
    </cfoutput>
        
	<cfquery name="getWarehouse" 
  	datasource="AppsMaterials" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">
	    	SELECT  *
			FROM   Warehouse
			WHERE  Warehouse = '#url.warehouse#'
	</cfquery>
    
    <cfquery name="getData" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT  B.BatchNo,
                B.BatchClass,
                B.BatchReference,
                B.OfficerFirstName,
                B.OfficerLastName,
                B.Created,
                C.CustomerName,
                C.Reference as CustomerReference,
                SUM(T.TransactionQuantity) as TotalQuantity,
                COUNT(T.TransactionBatchNo) as CountTransactions,
                SUM(CASE WHEN T.ActionStatus = '1' THEN 1 ELSE 0 END) as CountTransactionsCleared,
                (
                    SELECT TOP 1 ActionStatus
                    FROM    ItemTransactionAction as ITAx WITH (NOLOCK)
                    WHERE   EXISTS (SELECT 'X' FROM ItemTransaction WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo AND TransactionId = ITAx.TransactionId)
                ) as AnyAction

            FROM ItemTransaction AS T WITH (NOLOCK)
                INNER JOIN WarehouseLocation AS WL WITH (NOLOCK)
                    ON T.Warehouse = WL.Warehouse
                    AND T.Location = WL.Location
                INNER JOIN ItemUoM AS U WITH (NOLOCK)
                    ON T.TransactionUoM = U.UoM
                    AND T.ItemNo = U.ItemNo
                INNER JOIN WarehouseBatch AS B WITH (NOLOCK)
                    ON T.TransactionBatchNo = B.BatchNo 
                    AND T.Warehouse = B.Warehouse
                INNER JOIN Ref_WarehouseLocationClass AS LC WITH (NOLOCK)
                    ON WL.LocationClass = LC.Code
                INNER JOIN Customer C WITH (NOLOCK)
                    ON B.CustomerId = C.CustomerId
            WHERE   T.Warehouse = '#url.warehouse#'
            AND     B.BatchClass = 'WhsSale'
            AND     T.TransactionQuantity < 0
            AND     B.ActionStatus = '0'
			<!--- removed we need it flexible
            AND     B.TransactionDate >= '#dateFormat(now(), "yyyy-mm-dd")#'
			--->
            AND     EXISTS
                    (
                        SELECT  'X'
                        FROM    WarehouseBatchAction WITH (NOLOCK)
                        WHERE   BatchNo = B.BatchNo
                        AND     ActionCode = 'Monitor'
                        AND     ActionStatus = '1'
                    )
			GROUP BY 
                    B.BatchNo,
                    B.BatchClass,
                    B.BatchReference,
                    B.OfficerFirstName,
                    B.OfficerLastName,
                    B.Created,
                    C.CustomerName,
                    C.Reference
            ORDER BY B.BatchNo
    </cfquery>

    <cfif getData.recordCount eq 0>

        <div style="text-align:center; padding-top:15%; color:#1FC0DE;">
            <h1>[ <cf_tl id="No customers in line"> ]</h1>
        </div>

    <cfelse>

        <div class="refresh-button" id="content_refresh" title="<cfoutput>#lblRefresh#</cfoutput>"
            onclick="parent.customerview('','9123E610-17D9-4E1C-B350-AE0EDCBF3EC2');">
                <i class="fas fa-sync-alt fa-3x"></i>
        </div>

        <div style="padding:10px; padding-left:2%; padding-right:2%;">

            <div class="row clsMainContainerBatch">
                <div style="padding-left:10px; border-bottom:1px solid #C0C0C0;">
                    <h2 class="text-info titletext" style="font-size:140%; text-transform:capitalize">
                        <table width="90%">
                            <tr>
                                <td width="6%" style="padding-left:10px; padding-right:10px;" align="center">&nbsp;</td>
                                <td width="46%" style="padding-right:10px">
                                    <cf_tl id="Customer">
                                </td>
                                <td width="12%" style="font-size:70%;">   
                                    <cf_tl id="Seller">
                                </td>
                                
                                <td width="12%" style="font-size:70%;" align="center">
                                    <cf_tl id="Sale">
                                </td>
                                <td width="12%" style="font-size:70%;" align="center">
                                    <cf_tl id="Status">
                                </td>
                                <td width="12%" style="font-size:70%;" align="center">
                                    <cf_tl id="Completed">
                                </td>
                            </tr>
                        </table>                            
                        
                    </h2>
                </div>
            </div>       
        
            <cfoutput query="getData">

                <div class="row clsMainContainerBatch clsMainContainer#BatchNo# clsColorMainContainer#BatchNo#">
                    <div style="padding-left:10px; padding-top:5px; padding-bottom:5px; border-bottom:1px solid ##C0C0C0;">
                        <h2 class="text-info titletext" style="font-size:225%;">
                            <table width="90%">
                                <tr>
                                    <td width="6%" style="padding-left:10px; padding-right:10px;" align="center">
                                        <i class="fas fa-shopping-cart"></i>
                                    </td>
                                    <td width="46%" style="padding-right:10px; text-transform:capitalize; font-weight:400;">
                                        #lcase(CustomerName)# <cfif BatchReference neq "">- <span style="font-size:70%;">(#ucase(BatchReference)#)</span></cfif>
                                    </td>
                                        <td width="12%" style="font-size:70%; font-weight:400;">   
                                        #OfficerFirstName# #OfficerLastName#
                                        <br><span style="font-size:70%; color:##808080;">#timeFormat(created, "hh:mm tt")#</span>
                                    </td>
                                    
                                    <td width="12%" style="font-size:70%; font-weight:400;" align="center">
                                        #numberformat(BatchNo, ',')#
                                    </td>
                                    <td width="12%" style="font-size:70%; font-weight:400;" align="center" id="initiated#batchno#">
                                        <cfif AnyAction eq ""><span style="color:###vColorOnHold#;"><cf_tl id="On hold"><cfelse><span style="font-weight:bold; color:###vColorOn#;"><cf_tl id="Initiated"></cfif></span>
                                    </td>
                                    <td width="12%" style="font-size:70%; font-weight:400;" align="center">
                                        <span class="font-bold" id="progressPercentage#BatchNo#">#numberformat(CountTransactionsCleared*100/CountTransactions, ",")#</span> %
                                        <button id="content_#batchno#_refresh" class="btnRefresh" onclick="doRefreshStatus('#batchno#');" style="display:none;"></button>
                                        <span id="refresh#BatchNo#" style="display:none;"></span>
                                    </td>
                                </tr>
                            </table>                            
                            
                        </h2>
                    </div>
                </div>

                <script>
                    $('.clsColorMainContainer#BatchNo#').css('background-color', getLineColor(#CountTransactionsCleared/CountTransactions#));
                </script>
                
            </cfoutput>
        </div>
								        
        <cfinvoke component = "Service.Connection.Connection"  
                method           = "setconnection"    
                object           = "WarehouseBatchCenter" 
                ScopeId          = "#getWarehouse.MissionOrgUnitId#"
				ScopeMode        = "Monitor"
                ScopeFilter      = "B.Warehouse=''#url.warehouse#'' AND B.BatchClass=''WhsSale'' AND B.ActionStatus=''0''"
                ControllerNo     = "992"
                ObjectContent    = "#getData#"
                ObjectIdfield    = "batchno"
                delay            = "20">        

    </cfif>
      
</cf_mobile>
