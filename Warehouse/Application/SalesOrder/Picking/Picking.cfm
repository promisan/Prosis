<cfparam name="url.threshold"   default="0">
<cfparam name="url.ordering"    default="DESC">
<cfparam name="url.showDays"    default="">
	
<cf_mobile appId="picking" toastr="yes">

    <cf_tl id="cleared" var="lblCleared">
    <cf_tl id="refresh" var="lblRefresh">
    <cf_tl id="This will remove all actions on this item. Continue?" var="lblResetStatus">

    <cfset vColorOn            = "019982">
    <cfset vIconOn             = "fas fa-tv">
    <cfset vColorOff           = "c83702">
    <cfset vIconOff            = "fas fa-tv">
    <cfset vColorOnHold        = "F28D8D">
    <cfset vColorLineRangeInit = "[255,255,255]">
    <cfset vColorLineRangeEnd = "[150,245,112]">

    <cfset vColorInitial 	  = "##919396">
    <cfset vColorPicked 	  = "##fcba6b">
    <cfset vColorMoved 		  = "##f26a2a">
    <cfset vColorConsolidated = "##1b4e7c">

    <cfset vIconPicked        = "fa fa-box-full">
    <cfset vIconMoved         = "fa fa-sign-in">
    <cfset vIconConsolidated  = "fa fa-box-check">

    <cfset vIconPickedClass   = replace(vIconPicked, " ", ".", "ALL")>
    <cfset vIconMovedClass    = replace(vIconMoved, " ", ".", "ALL")>
    <cfset vIconConsolidatedClass = replace(vIconConsolidated, " ", ".", "ALL")>

    <cfset vCardHeight          = "290px">
    <cfset vMaxDescriptionChars = "70">

    <cfset vPickingParameters = "warehouse=#url.warehouse#&iconpicked=#vIconPicked#&iconmoved=#vIconMoved#&iconconsolidated=#vIconConsolidated#&cardHeight=#vCardHeight#&MaxDescriptionChars=#vMaxDescriptionChars#">

	<cf_dialogMaterial>
		
    <cfoutput>
        <style>
            html{
                height:98%;
            }

            .hbar {
                color:##ffffff;
                padding:5px 8px 5px 8px;
                font-size:140%;
            }

            .hpanel.clsInitial .panel-body {
                border-color: #vColorInitial#;
            }
            .hbar.clsInitial {
                background-color:#vColorInitial#;
            }
            .htext.clsInitial {
                color:#vColorInitial#;
            }

            .hpanel.clsPicked .panel-body {
                border-color: #vColorPicked#;
            }
            .hbar.clsPicked {
                background-color:#vColorPicked#;
            }
            .htext.clsPicked {
                color:#vColorPicked#;
            }

            .hpanel.clsMoved .panel-body {
                border-color: #vColorMoved#;
            }
            .hbar.clsMoved {
                background-color:#vColorMoved#;
            }
            .htext.clsMoved {
                color:#vColorMoved#;
            }

            .hpanel.clsConsolidated .panel-body {
                border-color: #vColorConsolidated#;
            }
            .hbar.clsConsolidated {
                background-color:#vColorConsolidated#;
            }
            .htext.clsConsolidated {
                color:#vColorConsolidated#;
            }

            .clsStatusButton {
                font-size:250%;
                color:##E3E3E3;
            }

            .clsMainContainerBatch {
                border-radius:5px;
                -webkit-transition: all 1s ease-out;
                -moz-transition: all 1s ease-out;
                -o-transition: all 1s ease-out;
                transition: all 1s ease-out;
            }

            .clsBarIcon {
                text-align:right;
            }

            .clsUIProcessed, .clsUIProcessed .clsStatusButton {
                color:##FFFFFF;
            }

            .clsUIProcessedPicked {
                background-color:#vColorPicked#;
            }

            .clsUIProcessedMoved {
                background-color:#vColorMoved#;
            }

            .clsUIProcessedConsolidated {
                background-color:#vColorConsolidated#;
            }

            .clsIconContainer {
                padding:10px 8px 8px 5px;
            }
           
            .text-info {
                color:##000000;
            }
            .titletext {
                color:##000000;
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
            
            .threshold-button {
                position:fixed; 
                top:80px; 
                right:20px; 
                z-index:99; 
                color:##033F5D; 
                background-color:##EEEEEE;
                border:1px solid ##C0C0C0; 
                padding:8px; 
                cursor:pointer;
            }

            .days-button {
                position:fixed; 
                top:170px; 
                right:20px; 
                z-index:99; 
                color:##033F5D; 
                background-color:##EEEEEE;
                border:1px solid ##C0C0C0; 
                padding:8px; 
                cursor:pointer;
            }

            .ordering-button {
                position:fixed; 
                top:130px; 
                right:20px; 
                z-index:99; 
                color:##033F5D; 
                background-color:##EEEEEE;
                border:1px solid ##C0C0C0; 
                padding:8px; 
                cursor:pointer;
            }
            
            .clsPersonContainer {
                width:100%; 
                border:1px solid ##C0C0C0; 
                text-align:center; 
                font-size:16px; 
                padding:15px 10px;                  
                cursor:pointer; 
                margin-bottom:8px; 
                color:#vColorConsolidated#;
                background-color:##EEEEEE;
            }
            .clsPersonSelected {
                background-color:#vColorConsolidated#;
                border:1px solid ##46617E; 
                color:##FFFFFF;
            }
            .clsNoPersonsAssigned {
                color: ##F45E5E;
                font-size:15px;
                text-align:center;
            }
            body.page-small ##menu {
                margin-left: 0px;
            }
            .clsDetailsButton {
                font-size:70%;
                height:36px;
            }

            .modal-open{ 
                overflow: visible;
            }

        </style>

        <cf_systemscript>

        <cf_tl id="Box Edit" var="labelBoxEdit">
        <cf_tl id="Fill Boxes" var="labelFillBoxes">
        <cf_tl id="Do you want to remove this box?" var="lblRemoveBoxConfirm">
        <cf_tl id="The total must be less or equal than the transaction quantity." var="lblBoxTotalError">
        <cf_tl id="This action will create" var="labelBoxQuickAdd1">
        <cf_tl id="boxes.\n\nConfirm?" var="labelBoxQuickAdd2">
        <cf_tl id="Cannot distribute these items evenly in the current number of boxes." var="labelDistributeEvenlyError1">
        <cf_tl id="Remaining items" var="labelDistributeEvenlyError2">

        <script>

		    _cf_loadingtexthtml='<i class="fa fa-cog fa-spin"></i>';

            function updateClearedBatch(batchno) {
                doRefreshStatus(null, batchno);
            }

            function updateCardStatus(c, batchno, status) {
                var vClass = 'clsPicked';
                var vIcon = '#vIconPicked#';
                var vIconClass = '#vIconPickedClass#';

                $(c).find('.clsIconContainer').removeClass('clsUIProcessed').removeClass('clsUIProcessedPicked').removeClass('clsUIProcessedMoved').removeClass('clsUIProcessedConsolidated');

                if (status == '1') {
                    $(c).find('.clsInitial, .clsMoved, .clsConsolidated').removeClass('clsInitial').removeClass('clsMoved').removeClass('clsConsolidated').addClass('clsPicked');
                    $(c).find('.clsIconContainerPicked').addClass('clsUIProcessed').addClass('clsUIProcessedPicked');
                    vIcon = '#vIconPicked#';
                }
                if (status == '2') {
                    $(c).find('.clsInitial, .clsPicked, .clsConsolidated').removeClass('clsInitial').removeClass('clsPicked').removeClass('clsConsolidated').addClass('clsMoved');
                    $(c).find('.clsIconContainerPicked, .clsIconContainerMoved').addClass('clsUIProcessed').addClass('clsUIProcessedMoved');
                    vIcon = '#vIconMoved#';
                }
                if (status == '5') {
                    $(c).find('.clsInitial, .clsPicked, .clsMoved').removeClass('clsInitial').removeClass('clsPicked').removeClass('clsMoved').addClass('clsConsolidated');
                    $(c).find('.clsIconContainerPicked, .clsIconContainerMoved, .clsIconContainerConsolidated').addClass('clsUIProcessed').addClass('clsUIProcessedConsolidated');
                    vIcon = '#vIconConsolidated#';
                }
                
                $(c).find('.hbar .clsBarIcon').html("<i class='"+vIcon+"'></i>");

                updateClearedBatch(batchno);
            }

            function toggleStatus(c, cid, tid, batchno, status, statusDesc, allowRepost) {
                var acc = $('##selectedAccount').val();
                var vMemo = $.trim($('##memo_'+cid).val());
                var vDetailsContainer = 'clsDetails'+statusDesc+'_'+cid;
                var currStatus = $('##currentStatus_'+cid).val();

                if (status != currStatus || allowRepost) {
                    $('##currentStatus_'+cid).val(status);
                    ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/setTransactionStatus.cfm?transactionId='+tid+'&status='+status+'&acc='+acc+'&memo='+vMemo+'&detailscontainer='+vDetailsContainer+'&cid='+cid+'&batchno='+batchno, 'divSubmit_'+cid);
                }
            }

            function resetStatus(b, t, s) {
                if (confirm('#lblResetStatus#')) {
                    ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/resetTransactionStatus.cfm?batchno='+b+'&transactionid='+t, s);
                }
            }

            function showBatch(b) {
                $('.clsDetail'+b).slideDown();
                $('.clsMainContainer'+b).css('background-color','##EEEEEE');
                ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/pickingDetail.cfm?#vPickingParameters#&batchno='+b,'detail'+b);
            }

            function hideBatch(b) {
                $('.clsDetail'+b).slideUp(300, function(){
                    $('.clsDetail'+b).html('');
                });
                $('.clsMainContainer'+b).css('background-color','');
            }

            function toggleBatch(b) {
                if ($('.clsDetail'+b).is(':visible')) {
                    hideBatch(b);
                } else {
                    showBatch(b);
                }
            }

            function refreshBatch(b) {
                if ($('.clsDetail'+b).is(':visible')) {
                    showBatch(b);
                }
            }

            function selectThisPerson(acc, c) {
                $('##selectedAccount').val(acc);
                $('.clsPersonContainer').removeClass('clsPersonSelected');
                $(c).addClass('clsPersonSelected');
            }

            function doTicketPrint(e, b) {
                e.stopPropagation();
                ptoken.open('#session.root#/Warehouse/Application/SalesOrder/Picking/PrintTicket.cfm?batchno='+b, "_blank", "left=10, top=10, width=600, height=800, status=yes, toolbar=no, scrollbars=no, resizable=yes");	
            }
            
            function doRefreshStatus(e, b) {
                if (e) { e.stopPropagation(); }
                ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/refreshStatus.cfm?&batchno='+b,'refresh'+b);
            }

            function showInCustomerView(e, b) {
                if (e) { e.stopPropagation(); }
                ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/monitor/setCustomerView.cfm?coloron=#vColorOn#&coloroff=#vColorOff#&iconon=#vIconOn#&iconoff=#vIconOff#&batchno='+b,'submit'+b);
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

            function openBatch(e, b, m) {
                if (e) { e.stopPropagation(); }
                batch(b,m,'process','#url.systemfunctionid#')
            }

            function refreshBoxes(b) {
                ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/box/BoxRefresh.cfm?batchno='+b, 'divBoxContainer_'+b);
            }

            function editBoxes(e, b) {
                if (e) { e.stopPropagation(); }
                showModal('#labelBoxEdit#','','#session.root#/warehouse/application/salesorder/picking/box/BoxEdit.cfm?batchno='+b);
            }

            function editBox(cid, b) {
                ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/box/BoxEdit.cfm?mode=edit&batchno='+b+'&collectionid='+cid, 'modalBody');
            }

            function saveBox(cid, b, c, n) {
                ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/box/BoxSubmit.cfm?batchno='+b+'&code='+c+'&name='+n+'&collectionid='+cid, 'boxEditSubmit');
            }

            function removeBox(cid, b) {
                ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/box/BoxDelete.cfm?batchno='+b+'&collectionid='+cid, 'boxEditSubmit');
            }

            function fillBoxes(sid, tid, b) {
                showModal('#labelFillBoxes#','','#session.root#/warehouse/application/salesorder/picking/box/FillBoxes.cfm?batchno='+b+'&submitid='+sid+'&transactionid='+tid);
            }

            function addQuickBox(sid, tid, b, n) {
                if (n > 10) {
                    if (confirm('#labelBoxQuickAdd1# ' + n + ' #labelBoxQuickAdd2#')) {
                        ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/box/BoxQuickAdd.cfm?batchno='+b+'&submitid='+sid+'&transactionid='+tid+'&number='+n, 'boxFillSubmit');
                    }
                } else {
                    ptoken.navigate('#session.root#/warehouse/application/salesorder/picking/box/BoxQuickAdd.cfm?batchno='+b+'&submitid='+sid+'&transactionid='+tid+'&number='+n, 'boxFillSubmit');
                }                
            }

            function putItemsIntoBox(id, n) {
                $('.clsBoxQuantity').val('');
                $('##fbQuantity_'+id).val(n);
            }

            function distributeEvenly(items) {
                var vBoxes = parseInt($('.clsBoxQuantity').length);
                var vItemsPerBox = parseInt(items / vBoxes);
                var vRemainingItems = parseInt(items % vBoxes);
                
                if (vRemainingItems == 0) {
                    $('.clsBoxQuantity').each(function(i,v) {
                        $(this).val(vItemsPerBox);
                    });
                } else {
                    alert('#labelDistributeEvenlyError1#\n\n#labelDistributeEvenlyError2#:'+' '+vRemainingItems+'.');
                }
            }

            function validateBoxQuantities(q) {
                var vTotal = 0;
                $('.clsBoxQuantity').each(function(i) {
                    if ($(this).val().trim() != '') {
                        vTotal = vTotal + parseInt($(this).val());
                    }
                });
                
                if (vTotal > q) {
                    alert('#lblBoxTotalError#');
                    return false;
                }
                return true;
            }

            function showModal(title, subtitle, contentURL) {
                var vTitle = title;
                if ($.trim(vTitle) == '') { vTitle = 'Detail'; }
                
                ColdFusion.navigate(contentURL, 'modalBody');
                $('##modalBoxes .modal-title').html(vTitle);
                $('##modalBoxes .modal-subtitle').html(subtitle);
                $('##modalBoxes').modal('show');
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
            <cfif session.acc eq "administrator" OR getAdministrator('*') eq "1">
                AND     OA.AccessLevel > 0
            <cfelse>
                AND     OA.AccessLevel = 1
            </cfif>
            AND		U.AccountType = 'Individual'
            AND		U.Disabled = '0'
            AND		W.Operational = '1'
            AND		W.Warehouse = '#url.warehouse#'
            AND		L.LocationClass IN (#preserveSingleQuotes(vAuthLC)#)
            ORDER BY U.FirstName, U.LastName
    </cfquery>
	    
    <cfquery name="getData" 
        datasource="AppsMaterials" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
		
		SELECT  *,
                CONVERT(VARCHAR(8), CollectionDate, 112) as CollectionDateString
		FROM (
		
		    <!--- POS sale --->
		
	        SELECT  B.BatchNo,
	                B.BatchClass,
	                B.BatchReference,
	                B.OfficerFirstName,
	                B.OfficerLastName,
	                B.Created,
					C.CustomerSerialNo,
	                C.CustomerName,
	                C.Reference as CustomerReference,
                    RA.AddressId,
                    RA.Address,
                    RA.Address2,
                    RA.AddressCity,
                    RA.AddressRoom,
                    RA.AddressPostalCode,
                    RA.State as AddressState,
                    RA.Country as AddressCountry,
                    (SELECT Name FROM System.dbo.Ref_Nation WITH (NOLOCK) WHERE Code = RA.Country) as AddressCountryDescription,

                    <!--- boxes --->
                    ISNULL((SELECT COUNT(*)
	                    FROM    WarehouseBatchCollection WITH (NOLOCK)
	                    WHERE   BatchNo = B.BatchNo), 0) as Boxes, 
					
					<!--- date of collection --->
					
					ISNULL((SELECT ActionDate
	                    FROM    WarehouseBatchAction WITH (NOLOCK)
	                    WHERE   BatchNo = B.BatchNo
	                    AND     ActionCode = 'Collection'),B.TransactionDate) as CollectionDate, 
	                
					<!--- details about the sale --->
					SUM(T.TransactionQuantity)  as TotalQuantity,
	                COUNT(T.TransactionBatchNo) as CountTransactions,					
	                SUM(CASE WHEN T.ActionStatus = '1' THEN 1 ELSE 0 END) as CountTransactionsCleared,
					
					<!--- details about the line of collection --->
	                (   SELECT TOP 1 ActionStatus
	                    FROM    ItemTransactionAction as ITAx WITH (NOLOCK)
	                    WHERE   EXISTS (SELECT 'X' FROM ItemTransaction WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo AND TransactionId = ITAx.TransactionId)
	                ) as AnyAction,
					
					<!--- show for the customer --->
					
	                (   SELECT TOP 1 ActionCode
	                    FROM    WarehouseBatchAction
	                    WHERE   BatchNo = B.BatchNo
	                    AND     ActionCode = 'Monitor'
	                    AND     ActionStatus = '1' ) as CustomerView
	
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
                    LEFT OUTER JOIN CustomerAddress CA WITH (NOLOCK)
                        ON C.CustomerId = CA.CustomerId
                        AND CA.AddressId = B.AddressId
                    LEFT OUTER JOIN System.dbo.Ref_Address RA WITH (NOLOCK) 
                        ON CA.AddressId = RA.AddressId
						
	            WHERE   B.Warehouse = '#url.warehouse#'
	            AND     B.BatchClass IN ('WhsSale','WOShip')
	            AND     T.TransactionQuantity < 0		
									
	            AND     B.ActionStatus = '0'
				<cfif getAdministrator eq "0">
	            AND		(WL.LocationClass IN (#preserveSingleQuotes(vAuthLC)#) OR WL.Location = '#getWarehouse.LocationReceipt#' )					 
				</cfif>
				GROUP BY B.BatchNo,
	                     B.BatchClass,
	                     B.BatchReference,
						 B.TransactionDate,
	                     B.OfficerFirstName,
	                     B.OfficerLastName,
	                     B.Created,
	                     C.CustomerName,
	                     C.Reference,
						 C.CustomerSerialNo,
                         RA.AddressId,
                         RA.Address,
                         RA.Address2,
                         RA.AddressCity,
                         RA.AddressRoom,
                         RA.AddressPostalCode,
                         RA.State,
                         RA.Country
						 
						 
				<!--- WorkOrder sale link on the workorder --->	
				
				
				
					 
				
				
						 
					 
			) as C		
			
			WHERE  1=1
            
            <cfif trim(url.showDays) neq "">
                AND CollectionDate < '#dateformat(now()+url.showDays,client.datesql)#'
            </cfif>

            <cfif url.threshold eq "1">
                AND ABS(TotalQuantity) < '#getWarehouse.PickingThreshold#'
            </cfif>
			 
            ORDER BY CollectionDateString #url.ordering#, CollectionDate ASC, C.BatchNo
			
    </cfquery>

    <div class="modal" id="modalBoxes" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
        <div class="modal-dialog modal-lg" >
            <div class="modal-content">
                <div class="color-line"></div>
                <div class="modal-header" style="padding-bottom:60px; min-height:100px;">
                    <div style="float:left; width:95%;">
                        <h4 class="modal-title">Details</h4>
                        <small class="font-bold modal-subtitle"></small>
                    </div>
                    <button type="button" class="close clsNoPrint btn-close" data-dismiss="modal" aria-label="Close" style="float:right;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="modalBody"></div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default clsNoPrint btn-close" data-dismiss="modal"><cf_tl id="Close"></button>
                </div>
            </div>
        </div>
    </div>

    <cfoutput>
        <div 
            class="refresh-button" 
            title="#lblRefresh#"
            onclick="parent.pickingThreshold('', 'D7171BFE-F173-D956-A207-C52639C8E980', document.getElementById('btnThreshold'), '#url.ordering#', '#url.showDays#');">
                <i class="fas fa-sync-alt fa-3x"></i>
        </div>

        <div class="threshold-button">
            <input 	type="checkbox" id="btnThreshold" 
                    onchange="parent.pickingThreshold('', 'D7171BFE-F173-D956-A207-C52639C8E980', this, '#url.ordering#', '#url.showDays#');" 
                    value="1" <cfif url.threshold eq 1>checked</cfif>> <label for="btnThreshold" style="cursor:pointer;"><cf_tl id="Threshold"> <&nbsp;#getWarehouse.PickingThreshold#</label>
        </div>  

        <cfif url.ordering eq "ASC">
            <div class="ordering-button" onclick="parent.pickingThreshold('', 'D7171BFE-F173-D956-A207-C52639C8E980', document.getElementById('btnThreshold'), 'DESC', '#url.showDays#');">
                <i class="fas fa-arrow-up" style="font-size:115%;"></i> ASC
            </div>
        </cfif>
        <cfif url.ordering eq "DESC">
            <div class="ordering-button" onclick="parent.pickingThreshold('', 'D7171BFE-F173-D956-A207-C52639C8E980', document.getElementById('btnThreshold'), 'ASC', '#url.showDays#');">
                <i class="fas fa-arrow-down" style="font-size:115%;"></i> DESC
            </div>
        </cfif> 

        <div class="days-button">
            &lt; &nbsp;
            <select onchange="parent.pickingThreshold('', 'D7171BFE-F173-D956-A207-C52639C8E980', document.getElementById('btnThreshold'), '#url.ordering#', this.value);">
                <option value="" <cfif url.showDays eq "">selected</cfif>><cf_tl id="Ever"></option>
                <option value="1" <cfif url.showDays eq 1>selected</cfif>>+1d</option>
                <option value="2" <cfif url.showDays eq 2>selected</cfif>>+2d</option>
                <option value="3" <cfif url.showDays eq 3>selected</cfif>>+3d</option>
                <option value="5" <cfif url.showDays eq 5>selected</cfif>>+5d</option>
                <option value="10" <cfif url.showDays eq 10>selected</cfif>>+10d</option>
                <option value="15" <cfif url.showDays eq 15>selected</cfif>>+15d</option>
                <option value="30" <cfif url.showDays eq 30>selected</cfif>>+30d</option>
                <option value="60" <cfif url.showDays eq 60>selected</cfif>>+60d</option>
                <option value="90" <cfif url.showDays eq 90>selected</cfif>>+90d</option>
            </select>
        </div>
       
        <aside id="menu" style="top:0; border-right:1px solid ##C0C0C0; position:fixed; overflow-y:auto; padding:8px; width:160px;">
            <cfset vAccountSelected = "">
            <cfif getAuthUsers.recordCount gt 0>
                <cfset vAccountSelected = session.acc>
            <cfelse>
                <div class="clsNoPersonsAssigned">[ <cf_tl id="No persons assigned"> ]</div>
            </cfif>
            
            <input type="hidden" id="selectedAccount" value="#vAccountSelected#">

            <cfloop query="getAuthUsers">
                <cfset vPersonSelectedClass = "">
                <cfif Account eq vAccountSelected>
                    <cfset vPersonSelectedClass = "clsPersonSelected">
                </cfif>
                <div class="clsPersonContainer #vPersonSelectedClass#" onclick="selectThisPerson('#Account#', this);">
                    <i class="fas fa-user-alt" style="font-size:180%;"></i>
                    <div style="padding-top:5px; line-height:18px;">
                        #FirstName# #LastName#
                        <div style="font-size:70%;">#Account#</div>
                    </div>
                    
                </div>
            </cfloop>

        </aside>

    </cfoutput>

    <div style="margin-left:160px; padding:10px; padding-left:2%; padding-right:2%;">

        <div class="row clsMainContainerBatch fixrow hide">
            <div style="padding-left:10px; border-bottom:1px solid #C0C0C0;">
                <h2 class="text-info titletext" style="font-size:140%; text-transform:capitalize">
                    <table width="90%">
                        <tr>
                            <td width="5%" style="min-width:50px;"></td>
                            <td width="38%" style="padding-right:10px; font-size:70%;">
                                <cf_tl id="Sale">
                            </td>
                            <td width="5%" style="min-width:20px;"></td>
                            <td width="12%" style="font-size:70%;">   
                                <cf_tl id="Seller">
                            </td>
                            
                            <td width="12%" style="font-size:70%;" align="center">
                                <cf_tl id="Total Items">
                            </td>
                            <td width="2%" style="min-width:20px;"></td>
                            <td width="12%" style="font-size:70%;" align="center">
                                <cf_tl id="Status">
                            </td>
							<td width="12%" style="font-size:70%;" align="center">
                                <cf_tl id="Cleared">
                            </td>
                            <td width="2%" style="min-width:20px;"></td>
                        </tr>
                    </table>                            
                    
                </h2>
            </div>
        </div>       
	
        <cfoutput query="getData" group="CollectionDateString">
			
            <div class="row" style="padding-top:10px;">
                <cf_tl id="#dateFormat(collectionDate, "dddd")#" var="1">
                <h1>#lt_text# <span style="font-size:50%;">#dateFormat(collectionDate, client.dateformatshow)#</span></h1>
            </div>

            <cfoutput>
                <cfset vCustomerViewStyle = "color:###vColorOff#;">
                <cfset vCustomerViewIcon = vIconOff>

                <cfif customerView neq "">
                    <cfset vCustomerViewStyle = "color:###vColorOn#;">
                    <cfset vCustomerViewIcon = vIconOn>
                </cfif>

                <cfset vIconSizeStyle = "font-size:120%">

                <div class="row clsMainContainerBatch clsMainContainer#BatchNo#" onclick="toggleBatch('#batchNo#');" style="cursor:pointer;">
                    <div style="padding-left:10px; border-bottom:1px solid ##C0C0C0;">
                        <h2 class="text-info titletext" style="font-size:170%;">
                            <table width="90%">
                                <tr class="fixlengthlist" style="text-overflow: ellipsis;white-space: nowrap;overflow: hidden; padding-left:3px;">
                                    <td width="5%" align="center" style="min-width:50px;">
                                        <span style="display:none;" id="submit#batchno#"></span>
                                        <i class="fas fa-print" style="padding-left:10px; color:##C83702; #vIconSizeStyle#" onclick="doTicketPrint(event, '#batchNo#');"></i>
                                    </td>
									<td width="5%" align="center" style="min-width:20px;">
                                        <i class="#vCustomerViewIcon#" style="#vCustomerViewStyle# #vIconSizeStyle#" id="customerView#batchno#" onclick="showInCustomerView(event, '#batchNo#')"></i>
                                    </td>
									
                                    <td style="min-width:240px;padding-left:5px;padding-right:10px; text-transform:capitalize; line-height:18px;text-overflow: ellipsis; white-space: nowrap; overflow: hidden; max-width:240px;">
                                        #BatchNo# - #lcase(CustomerName)# <span style="font-size:70%;">#CustomerSerialNo#</span> <cfif BatchReference neq ""> <span style="font-size:70%;">(#ucase(BatchReference)#)</span></cfif>
                                        <cfif AddressId neq ""> 										
                                            <br>
                                            <span style="font-size:13px; line-height:13px; color:##000000; font-weight:normal; padding-top:5px; text-transform:capitalize;">											
                                                <cfif Address neq "">#lcase(Address)#. </cfif> <cfif Address2 neq "">#lcase(Address2)#. </cfif> <cfif AddressCity neq "">#lcase(AddressCity)#. </cfif> 
                                                <cfif AddressRoom neq ""><cf_tl id="Room">: #lcase(AddressRoom)#. </cfif> <cfif AddressPostalCode neq "">#lcase(AddressPostalCode)#. </cfif> 
                                                <cfif AddressState neq "">#lcase(AddressState)#. </cfif> <cfif AddressCountry neq "">#lcase(AddressCountryDescription)#. </cfif>
                                            </span>
                                        </cfif>
                                    </td>
                                    
                                    <td width="12%" class="fixlength" style="font-size:70%; text-transform:capitalize;text-overflow: ellipsis; white-space: nowrap; overflow: hidden; max-width:200px;">   
                                        #ucase(OfficerLastName)#
                                        <br><span style="font-size:75%; color:##808080; font-weight:normal;">#dateFormat(created, client.dateformatshow)# - #timeFormat(created, "hh:mm tt")#</span>
                                    </td>
                                
                                    <td width="12%" style="font-size:70%" align="center">
                                        #numberformat(TotalQuantity*-1, ',')#
                                    </td>
                                    <td width="2%" align="center" style="min-width:20px;">
                                        <i class="fad fa-box" style="color:###vColorOff#; #vIconSizeStyle#" onclick="editBoxes(event, '#batchno#');"></i>
                                        <div id="divBoxContainer_#batchno#" style="font-size:11px; font-weight:normal; padding-left:1px; margin-top:-13px; display:block; color:##353535;">
                                            #numberformat(boxes,",")#
                                        </div>
                                    </td>
                                    <td width="12%" style="font-size:80%;text-overflow: ellipsis; white-space: nowrap; overflow: hidden; min-width:100px;max-width:200px;" align="center" id="initiated#batchno#">
                                        <cfif AnyAction eq ""><span style="color:###vColorOnHold#;font-weight:bold;"><cf_tl id="On hold"><cfelse><span style="font-weight:bold; color:###vColorOn#;"><cf_tl id="Initiated"></cfif></span>
                                    </td>
                                    <td width="12%" style="font-size:80%;text-overflow: ellipsis; white-space: nowrap; overflow: hidden; max-width:200px;" align="center">
                                        <span class="clsSelected#BatchNo# font-bold" id="progress#BatchNo#">#CountTransactionsCleared#</span> / #CountTransactions#
                                        <button id="content_#batchno#_refresh" class="btnRefresh" onclick="doRefreshStatus(event, '#batchno#');" style="display:none;"></button>
                                        <span id="refresh#BatchNo#" style="display:none;"></span>
                                    </td>
                                    <td width="2%" style="min-width:20px;" align="center">
                                        <i class="fas fa-external-link" style="color:##C83702; #vIconSizeStyle#" onclick="openBatch(event, '#BatchNo#','#getwarehouse.Mission#')"></i>
                                    </td>
                                </tr>
                            </table>                            
                            
                        </h2>
                    </div>
                </div>

                <div class="row clsDetail#batchno#" id="detail#batchno#" style="display:none;"></div>
                
            </cfoutput>

        </cfoutput>
    </div>
         
        <cfinvoke component = "Service.Connection.Connection"  
            method           = "setconnection"    
            object           = "WarehouseBatchCenter" 	
			ScopeMode        = "Picking"		
            ScopeId          = "#getWarehouse.MissionOrgUnitId#"
            ScopeFilter      = "B.Warehouse=''#url.warehouse#'' AND (B.BatchClass=''WhsSale'' OR B.BatchClass=''WOShip'') AND B.ActionStatus=''0''"
            ControllerNo     = "992"
            ObjectContent    = "#getData#"
            ObjectIdfield    = "batchno"
            delay            = "20"> 
         
</cf_mobile>
