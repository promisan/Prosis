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
<cf_tl id="reset" var="lblReset">

    
<cfquery name="getWarehouse" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
        SELECT  *
        FROM   Warehouse
        WHERE  Warehouse = '#url.warehouse#'
</cfquery>    

<cfif getAdministrator('*') eq "0">
	
	<cfquery name="getAuthLocationClasses" 
	    datasource="AppsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	        SELECT  DISTINCT LC.Code as LocationClass
	        FROM	OrganizationAuthorization OA
	                INNER JOIN System.dbo.UserNames U     ON OA.UserAccount = U.Account
	                INNER JOIN Organization O             ON OA.OrgUnit = O.OrgUnit
	                INNER JOIN Materials.dbo.Warehouse W  ON O.MissionOrgUnitId = W.MissionOrgUnitId
	                INNER JOIN Materials.dbo.WarehouseLocation L ON W.Warehouse = L.Warehouse AND L.LocationClass   = OA.ClassParameter
	                INNER JOIN Materials.dbo.Ref_WarehouseLocationClass LC ON L.LocationClass = LC.Code
	        WHERE	OA.Role        = 'WhsAssist'
	        AND     OA.AccessLevel > 0
	        AND		U.AccountType = 'Individual'
	        AND		U.Disabled = '0'
	        AND		W.Operational = '1'
	        AND		W.Warehouse = '#url.warehouse#'
	        <cfif session.acc neq "administrator">
	            AND		U.Account = '#session.acc#'
	        </cfif>
	</cfquery>
	
	<cfset vAuthLC = "''">
	<cfif getAuthLocationClasses.recordCount gt 0>
	    <cfset vAuthLC = QuotedValueList(getAuthLocationClasses.LocationClass)>
	</cfif>

</cfif>

<cfquery name="getAuthUsers" 
    datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT DISTINCT U.PersonNo, U.Account, U.FirstName, U.LastName
        FROM	OrganizationAuthorization OA
                INNER JOIN System.dbo.UserNames U
                    ON OA.UserAccount = U.Account
                INNER JOIN Organization O
                    ON OA.OrgUnit = O.OrgUnit
                INNER JOIN Materials.dbo.Warehouse W
                    ON O.MissionOrgUnitId = W.MissionOrgUnitId
                INNER JOIN Materials.dbo.WarehouseLocation L
                    ON W.Warehouse = L.Warehouse
                    AND L.LocationClass = OA.ClassParameter
                INNER JOIN Materials.dbo.Ref_WarehouseLocationClass LC
                    ON L.LocationClass = LC.Code
        WHERE	OA.[Role] = 'WhsAssist'
        <cfif getAdministrator('*') eq "1">
            AND     OA.AccessLevel > 0
        <cfelse>
            AND     OA.AccessLevel = 1
        </cfif>
        AND		U.AccountType = 'Individual'
        AND		U.Disabled = '0'
        AND		W.Operational = '1'
        AND		W.Warehouse = '#url.warehouse#'
		<cfif getAdministrator('*') eq "0">
        AND		L.LocationClass IN (#preserveSingleQuotes(vAuthLC)#)
		</cfif>
        ORDER BY U.FirstName, U.LastName
</cfquery>
    
<cfquery name="getData" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT  B.BatchNo,
            T.TransactionId, 
            T.ItemNo, 
            T.ItemDescription, 
			I.ItemNoExternal,
            T.TransactionQuantity, 
            T.TransactionUoM, 
            U.UoMDescription, 
            U.ItemBarCode, 
            WL.Location, 
            WL.Description as LocationDescription,
            WL.LocationClass, 
            LC.Description as LocationClassDescription,
            T.TransactionBatchNo, 
            B.BatchClass,
            B.BatchReference,
            B.OfficerFirstName,
            B.OfficerLastName,
            C.CustomerName,
            C.Reference as CustomerReference,

            <!--- boxes --->
            ISNULL((SELECT COUNT(*)
                FROM    WarehouseBatchCollection WITH (NOLOCK)
                WHERE   BatchNo = B.BatchNo), 0) as Boxes, 

            T.ActionStatus,
            (
                SELECT TOP 1 ActionStatus
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                ORDER BY ActionDate DESC
            ) as LatestActionActionStatus,
            (
                SELECT TOP 1 OfficerUserId
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                AND     ActionCode = 'Picked'
                ORDER BY ActionDate DESC
            ) as LatestActionPicked,
            (
                SELECT TOP 1 OfficerUserId
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                AND     ActionCode = 'Moved'
                ORDER BY ActionDate DESC
            ) as LatestActionMoved,
            (
                SELECT TOP 1 OfficerUserId
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                AND     ActionCode = 'Consolidated'
                ORDER BY ActionDate DESC
            ) as LatestActionConsolidated,
            (
                SELECT TOP 1 Created
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                AND     ActionCode = 'Picked'
                ORDER BY ActionDate DESC
            ) as LatestActionDatePicked,
            (
                SELECT TOP 1 Created
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                AND     ActionCode = 'Moved'
                ORDER BY ActionDate DESC
            ) as LatestActionDateMoved,
            (
                SELECT TOP 1 Created
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                AND     ActionCode = 'Consolidated'
                ORDER BY ActionDate DESC
            ) as LatestActionDateConsolidated,
            (
                SELECT TOP 1 ActionMemo
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                AND     ActionCode = 'Picked'
                ORDER BY ActionDate DESC
            ) as LatestActionMemoPicked,
            (
                SELECT TOP 1 ActionMemo
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                AND     ActionCode = 'Moved'
                ORDER BY ActionDate DESC
            ) as LatestActionMemoMoved,
            (
                SELECT TOP 1 ActionMemo
                FROM    ItemTransactionAction WITH (NOLOCK)
                WHERE   TransactionId = T.TransactionId
                AND     ActionCode = 'Consolidated'
                ORDER BY ActionDate DESC
            ) as LatestActionMemoConsolidated,
            T.TransactionReference
            
        FROM ItemTransaction AS T WITH (NOLOCK)
            INNER JOIN WarehouseLocation AS WL WITH (NOLOCK)
                ON T.Warehouse = WL.Warehouse
                AND T.Location = WL.Location
            INNER JOIN ItemUoM AS U WITH (NOLOCK)
                ON T.TransactionUoM = U.UoM
                AND T.ItemNo = U.ItemNo
		    INNER JOIN Item AS I WITH (NOLOCK)
                ON  T.ItemNo = I.ItemNo		
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
		<cfif getAdministrator('*') eq "0">
        AND		(WL.LocationClass IN (#preserveSingleQuotes(vAuthLC)#) 
                    OR WL.Location = '#getWarehouse.LocationReceipt#' )	
		</cfif>			

        AND     B.BatchNo = '#url.batchno#'				 
                    
        ORDER BY B.BatchNo, 
                    WL.LocationClass,
                    WL.Description,
                    U.ItemBarCode
				
</cfquery>

<cfif getData.recordCount eq 0>
    <div style="text-align:center; padding:30px; color:#FB8383;"><h4>[<cf_tl id="You do not have access to any location."> <cf_tl id="Please, contact your administrator.">]</h4></div>
</cfif>
	
<cfoutput query="getData" group="LocationClass">
    
    <div class="row clsBatch#BatchNo#" style="padding-left:10px;">
        <div style="padding-left:8px;">
            <h4 style="cursor:pointer;">#ucase(LocationClassDescription)# <span style="font-size:60%;">(#LocationClass#)</span></h4>
        </div>
    </div>
    
    <div class="row clsBatch#BatchNo#" style="padding-left:15px;">
        <cfoutput>
            <cfset vSubmitId = replace(transactionId, "-", "", "ALL")>
            <cfset vIcon = url.IconPicked>
            <cfset vStatusClass = "clsInitial">
            <cfset vIconContainerClass = "">
            <cfif LatestActionActionStatus eq "1">
                <cfset vIcon = url.IconPicked>
                <cfset vStatusClass = "clsPicked">
                <cfset vIconContainerClass = "clsUIProcessed clsUIProcessedPicked">
            </cfif>
            <cfif LatestActionActionStatus eq "2">
                <cfset vIcon = url.IconMoved>
                <cfset vStatusClass = "clsMoved">
                <cfset vIconContainerClass = "clsUIProcessed clsUIProcessedMoved">
            </cfif>
            <cfif LatestActionActionStatus eq "5">
                <cfset vIcon = url.IconConsolidated>
                <cfset vStatusClass = "clsConsolidated">
                <cfset vIconContainerClass = "clsUIProcessed clsUIProcessedConsolidated">
            </cfif>

            <div class="col-xs-12 col-sm-6 col-lg-3" id="container_#vSubmitId#">
                <cf_MobilePanel 
                    panelClass="#vStatusClass#" 
                    bodyStyle="padding:0px; border-top-width:1px!important; min-height:#url.CardHeight#; max-height:#url.CardHeight#; overflow:hidden;" 
                    showCollapse="0">

                        <div class="hbar clsIndicator#batchno# #vStatusClass#">
                            <table width="100%">
                                <tr>
                                    <td>
                                        <cfif session.acc eq "administrator">
                                            <i class="fas fa-undo" style="padding-right:5px; cursor:pointer;" title="#lblReset#" onclick="resetStatus('#batchno#','#transactionid#','currentStatus_#vSubmitId#');"></i>
                                        </cfif>
                                        <span style="width:100%;">#LocationDescription# - <span class="htext font-extra-bold">#ItemNoExternal#</span></span>
                                        <span id="divSubmit_#vSubmitId#"></span>
                                        <input type="hidden" id="currentStatus_#vSubmitId#" value="#LatestActionActionStatus#" />
                                    </td>
                                    <td class="clsBarIcon">
                                        <i class="#vIcon#"></i>
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <div style="height:40px; padding:2px 5px 0px 10px;" title="#trim(ItemDescription)#">
                            <span class="font-bold no-margins" style="font-size:100%;">
                                #left(trim(ItemDescription),url.MaxDescriptionChars)#<cfif len(trim(ItemDescription)) gt url.MaxDescriptionChars>...</cfif>
                            </span>
                        </div>
						
                        <div>
                            <table width="100%">
                                <tr>
                                    <td width="60%" style="padding:0px 0px 2px 8px;">
                                        <cfif trim(TransactionReference) neq "">
                                            <small style="font-weight:bold;">#trim(ucase(TransactionReference))#<br></small>
                                        </cfif>
                                        <small>I:#itemNoExternal#, U:#TransactionUoM#, B:#ItemBarCode#, L:#Location#, LC:#LocationClass#</small>
                                    </td>
                                    <td width="40%" align="right" style="padding-right:10px;">
                                        <h1 class="htext no-margins font-extra-bold #vStatusClass#" style="font-size:325%;">#numberFormat(TransactionQuantity*-1, ",")#</h1>
                                        <div class="font-bold">#UoMDescription#</div>
                                    </td>
                                </tr>
                            </table>    
                        </div>
						
                        <div style="padding-top:10px;">
                            <div 
                                class="col-xs-4 col-lg-4 clsIconContainer clsIconContainerPicked <cfif LatestActionActionStatus gte "1">#vIconContainerClass#</cfif>" 
                                style="text-align:center; cursor:pointer;" 
                                ondblclick="return false;"
                                onclick="toggleStatus($('##container_#vSubmitId#'), '#vSubmitId#', '#transactionId#', '#batchNo#', '1', 'Picked', false);">
                                    <i class="#url.IconPicked# clsStatusButton"></i>
                                    <br>
                                    <small><cf_tl id="Picked"></small><br>
                                    <small class="clsDetailsButton clsDetailsPicked_#vSubmitId#">
                                        <cfif LatestActionPicked eq "">
                                            &nbsp;<br>&nbsp;
                                        <cfelse>
                                            <span title="#LatestActionMemoPicked#">#LatestActionPicked#<br>#dateformat(LatestActionDatePicked, "dd/mm")# #timeformat(LatestActionDatePicked, "hh:mm tt")#</span>
                                        </cfif>
                                    </small>
                            </div>
                            <div 
                                class="col-xs-4 col-lg-4 clsIconContainer clsIconContainerMoved <cfif LatestActionActionStatus gte "2">#vIconContainerClass#</cfif>" 
                                style="text-align:center; cursor:pointer;" 
                                ondblclick="return false;"
                                onclick="toggleStatus($('##container_#vSubmitId#'), '#vSubmitId#', '#transactionId#', '#batchNo#', '2', 'Moved', false);">
                                    <i class="#url.IconMoved# clsStatusButton"></i>
                                    <br>
                                    <small><cf_tl id="Moved"></small><br>
                                    <small class="clsDetailsButton clsDetailsMoved_#vSubmitId#">
                                        <cfif LatestActionMoved eq "">
                                            &nbsp;<br>&nbsp;
                                        <cfelse>
                                            <span title="#LatestActionMemoMoved#">#LatestActionMoved#<br>#dateformat(LatestActionDateMoved, "dd/mm")# #timeformat(LatestActionDateMoved, "hh:mm tt")#</span>
                                        </cfif>
                                    </small>
                            </div>

                            <cfset vConsolidatedAction = "fillBoxes('#vSubmitId#', '#transactionId#', '#batchno#');">
                            <cfif Boxes eq 0>
                                <cfset vConsolidatedAction = "toggleStatus($('##container_#vSubmitId#'), '#vSubmitId#', '#transactionId#', '#batchNo#', '5', 'Consolidated', false);">
                            </cfif>

                            <div 
                                class="col-xs-4 col-lg-4 clsIconContainer clsIconContainerConsolidated <cfif LatestActionActionStatus gte "5">#vIconContainerClass#</cfif>" 
                                style="text-align:center; cursor:pointer;" 
                                ondblclick="return false;"
                                onclick="#vConsolidatedAction#">
                                    <i class="#url.IconConsolidated# clsStatusButton"></i>
                                    <br>
                                    <small><cf_tl id="Consolidated"></small><br>
                                    <small class="clsDetailsButton clsDetailsConsolidated_#vSubmitId#">
                                        <cfif LatestActionConsolidated eq "">
                                            &nbsp;<br>&nbsp;
                                        <cfelse>
                                            <span title="#LatestActionMemoConsolidated#">#LatestActionConsolidated#<br>#dateformat(LatestActionDateConsolidated, 'dd/mm')# #timeformat(LatestActionDateConsolidated, "hh:mm tt")#</span>
                                        </cfif>
                                    </small>
                            </div>
                        </div>
                        <div>
                            
                            <cfquery name="qAction" 
                                datasource="AppsMaterials" 
                                username="#SESSION.login#" 
                                password="#SESSION.dbpw#">
                                    SELECT I.ActionMemo
                                    FROM ItemTransactionAction I INNER JOIN 
                                    (SELECT	MAX(ActionDate) as ActionDate
                                        FROM	ItemTransactionAction
                                        WHERE	TransactionId = '#transactionId#'
                                        AND ActionMemo IS NOT NULL
                                        AND ActionMemo != '' 													
                                    ) M
                                    ON I.ActionDate = M.ActionDate
                                    WHERE	I.TransactionId = '#transactionId#'
                                    AND I.ActionMemo IS NOT NULL
                                    AND I.ActionMemo != ''
                            </cfquery>		

                            <cfif qAction.ActionMemo neq "">
                                <cfset vActionMemo = qAction.ActionMemo>
                            <cfelse>	
                                <cf_tl id="Memo for this action" var="1">
                                <cfset vActionMemo = lt_text>
                            </cfif>		
                                
                            <input 
                                type="text" 
                                id="memo_#vSubmitId#" 
                                style="width:100%; height:36px; font-size:18px;" 
                                placeholder="#vActionMemo#" 
                                maxlength="100">
                        </div>

                </cf_mobilePanel>
            </div>
        </cfoutput>
    </div>
</cfoutput>