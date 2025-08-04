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
<cfset vyear = mid(url.id3, 1, 4)>
<cfset vmonth = mid(url.id3, 6, 2)>
<cfset vday = mid(url.id3, 9, 2)>
<cfset vSelectionDate = createDate(vyear, vmonth, vday)>

<cfset as = 0>
<cfif url.actionStatus eq 0>
	<cfset as = 1>
</cfif>

<cfquery name="ActionStatus" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE	ServiceItemMissionPosting
	SET		ActionStatus = #as#
	WHERE 	ServiceItem	= '#url.id1#'
	AND		Mission = '#url.id2#'
	AND		SelectionDateExpiration = #vSelectionDate#
</cfquery>


<cfif as eq "1">

	<!--- creates a copy of the SK table if the action is Closing --->
<!---	
	<cfquery name="CheckTable" 
	datasource="WarehouseOICT" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT *  
		FROM INFORMATION_SCHEMA.TABLES  
		WHERE TABLE_SCHEMA = 'dbo'  
		AND  TABLE_NAME = 'skWorkOrderCharges_Closing_#DateFormat(vSelectionDate, "yyyymm")#'
	</cfquery>
	
	<cfquery name="getDBServer" datasource="AppsControl">
		SELECT DatabaseServer
		FROM ParameterSite
		WHERE ApplicationServer='#CGI.HTTP_HOST#'
	</cfquery>
	
	<cfif CheckTable.recordcount eq "0">
	
		<cfquery name="CreateCopy" 
		datasource="WarehouseOICT" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
				INTO STG_WarehouseOICT.dbo.skWorkOrderCharges_Closing_#DateFormat(vSelectionDate, "yyyymm")#
			FROM [#GetDBServer.DataBaseServer#].WorkOrder.dbo.skWorkOrderCharges
			WHERE ServiceItem	= '#url.id1#'
		</cfquery>
	
	<cfelse>
		<cfquery name="CreateCopy" 
		datasource="WarehouseOICT" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
			DELETE
			FROM STG_WarehouseOICT.dbo.skWorkOrderCharges_Closing_#DateFormat(vSelectionDate, "yyyymm")#
			WHERE ServiceItem	= '#url.id1#'
		</cfquery>
	
		<cfquery name="CreateCopy" 
		datasource="WarehouseOICT" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO STG_WarehouseOICT.dbo.skWorkOrderCharges_Closing_#DateFormat(vSelectionDate, "yyyymm")#
			SELECT *
			FROM [#GetDBServer.DataBaseServer#].WorkOrder.dbo.skWorkOrderCharges
			WHERE ServiceItem	= '#url.id1#'
		</cfquery>
	
	</cfif>
	--->
		

	
	<!--- Build the table with the differences between this closing and the prior (if exists) --->

	<cfquery name    = "Param"
		 datasource = "AppsWorkOrder"
		 username   = "#SESSION.login#"
		 password   = "#SESSION.dbpw#">	
				  SELECT   * 
				  FROM     ServiceItemMission
				  WHERE    Mission      = '#url.id2#'
				  AND      ServiceItem  = '#url.id1#'			  
	</cfquery>	 
	
	<cfif Param.DateChargesCalculate eq "">
		
		<cfquery name    = "Param"
		     datasource = "AppsWorkOrder"
		     username   = "#SESSION.login#"
		     password   = "#SESSION.dbpw#">	
			  SELECT * 
			  FROM   Ref_ParameterMission 
			  WHERE  Mission = '#url.id2#'
		</cfquery>	 
	
	</cfif>	
	
	<!---
	<cfquery name="GetPriorClosing" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
		SELECT TOP 1 *
		FROM Log_WorkOrderChargesSummary
		WHERE 	ServiceItem	= '#url.id1#'
		AND		BatchDate < #vSelectionDate#
		AND     BatchDate >= '#Param.DateChargesCalculate#'
		ORDER BY BatchDate DESC
	</cfquery>

	<cfif GetPriorClosing.recordcount neq "0">
	
	
		<cfquery name="InvoiceDetails" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
		
			UPDATE L
			SET L.AmountPrior = (
					SELECT ISNULL(SUM (AmountNew),0)
						FROM TransactionHeaderWorkOrder L1
						WHERE L1.WorkOrderId = L.WorkOrderId
						AND L1.WorkOrderLine = L.WorkOrderLine
						AND L1.SelectionDate = L.Selectiondate
						AND L1.ServiceItem = L.ServiceItem
						AND L1.UnitClass = L.UnitClass
						AND L1.Charged = L.Charged
						AND L1.Currency = L.Currency
						AND L1._BatchDate = '#GetPriorClosing.BatchDate#'),
				)
			FROM TransactionHeaderWorkOrder L
			WHERE L._BatchDate = #vSelectionDate#
			AND L.ServiceItem	= '#url.id1#'
								
		</cfquery>	

		<!--- Records present in the prior closing and not present in the current closing  --->	
		<cfquery name="Differences" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
	
			SELECT  #vSelectionDate# as BatchDate, 
					L.WorkorderId, 
					L.Workorderline, 
					L.Selectiondate, 
					L.ServiceItem, 
					L.UnitClass, 
					L.Charged, 
					L.Currency, 
					L.FundingId, 
					L.GLAccount,
					NULL AS AmountNew,
					AmountNew as AmountPrior 
			FROM TransactionHeaderWorkOrder L
			WHERE L.ServiceItem	= '#url.id1#'
			AND L._BatchDate = '#GetPriorClosing.BatchDate#'
			AND NOT EXISTS (
				SELECT 1
				FROM TransactionHeaderWorkOrder L1
						WHERE L1.WorkOrderId = L.WorkOrderId
						AND L1.WorkOrderLine = L.WorkOrderLine
						AND L1.SelectionDate = L.Selectiondate
						AND L1.ServiceItem = L.ServiceItem
						AND L1.UnitClass = L.UnitClass
						AND L1.Charged = L.Charged
						AND L1.Currency = L.Currency
						AND L1.FundingId = L.FundingId
						AND L1.GLAccount = L.GLAccount
						AND L1._BatchDate = #vSelectionDate#)		
			
		</cfquery>
	
	</cfif>
	--->

</cfif>


<cfoutput>
	<script>		
		ColdFusion.navigate('ActionStatus_MissionPosting.cfm?id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&actionstatus=#as#', 'iconStatusContainer_#url.id1#_#url.id2#');
	</script>
</cfoutput>