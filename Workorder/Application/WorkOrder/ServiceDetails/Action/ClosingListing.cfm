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
<cfparam name="url.workorderid"   default="">
<cfparam name="url.workorderline" default="">
<cfparam name="url.action"        default="">
<cfparam name="url.tabno"         default="">
<cfparam name="url.serviceitem"   default="">
<cfparam name="url.scope"         default="backoffice">

<cfoutput>

<cfif url.action eq "delete">

	<cfquery name="get" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM WorkOrderLineAction			
			WHERE	WorkActionId = '#WorkActionId#'
	</cfquery>

	<cfquery name="Remove" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE	WorkOrderLineAction
			SET     ActionStatus = '9'
			WHERE	WorkActionId = '#WorkActionId#'
	</cfquery>
	
	
	
</cfif>

<cfif url.scope eq "portal">

	<cfquery name="ServiceDomain" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT *
			FROM   Ref_ServiceItemDomain
			WHERE Code IN (	
						SELECT ServiceDomain
						FROM   ServiceItem
						WHERE  Code = '#url.serviceitem#')
		
		</cfquery>

</cfif>

<cfquery name="SearchResult" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	SELECT *
	FROM (
	SELECT	DISTINCT P.PersonNo,
			P.FullName,
			P.IndexNo,
			S.Description as ServiceDescription,
			L.WorkOrderId,
			L.WorkOrderLine,
			L.Reference,
			A.SerialNo,
			A.WorkActionId,
			A.DateTimePlanning,		
			(
				SELECT MIN(D.TransactionDate)
				FROM WorkOrderLineDetail D
				WHERE D.WorkOrderId = L.WorkOrderId
				AND	D.WorkOrderLine = L.WorkOrderLine
				AND D.ServiceUsageSerialNo <= A.SerialNo
				AND D.ServiceUsageSerialNo > ISNULL((
					SELECT TOP 1 A1.SerialNo
					FROM WorkOrderLineAction A1
					WHERE A1.WorkOrderId = A.WorkOrderId
					AND A1.WorkOrderLine = A.WorkOrderLine
					AND A1.SerialNo < A.SerialNo
					AND A1.ActionStatus<>'9'
					ORDER BY A1.SerialNo DESC),0)
				AND D.Transactiondate>= (
					SELECT TOP 1 DatePortalProcessing
					FROM ServiceItemMission M
					WHERE M.Mission   = W.Mission
					AND M.serviceItem = D.ServiceItem)

				AND D.Transactiondate>= (
					SELECT TOP 1 DatePostingCalculate
					FROM ServiceItemMission M
					WHERE M.Mission   = W.Mission
					AND M.serviceItem = D.ServiceItem)
					
				AND D.Transactiondate >= L.DateEffective					
				
			) AS DatePeriodStart,
			
			(
				SELECT MAX(D.TransactionDate)
				FROM WorkOrderLineDetail D
				WHERE D.WorkOrderId = L.WorkOrderId
				AND	D.WorkOrderLine = L.WorkOrderLine
				AND D.ServiceUsageSerialNo <= A.SerialNo
			) AS DatePeriodEnd,
			
			(
				SELECT COUNT(1)
				FROM WorkOrderLineDetail D
				WHERE D.WorkOrderId = L.WorkOrderId
				AND	D.WorkOrderLine = L.WorkOrderLine
				AND D.ServiceUsageSerialNo <= A.SerialNo
				AND D.ServiceUsageSerialNo > ISNULL((
					SELECT TOP 1 A1.SerialNo
					FROM     WorkOrderLineAction A1
					WHERE    A1.WorkOrderId = A.WorkOrderId
					AND      A1.WorkOrderLine = A.WorkOrderLine
					AND      A1.SerialNo < A.SerialNo
					AND      A1.ActionStatus  <> '9'
					ORDER BY A1.SerialNo DESC),0)
					
				AND D.Transactiondate>= (
					SELECT TOP 1 DatePostingCalculate
					FROM ServiceItemMission M
					WHERE M.Mission   = W.Mission
					AND M.serviceItem = D.ServiceItem)
					
			) AS TransactionsApproved,
			
			ISNULL((
			
				SELECT SUM (ROUND(AMOUNT,2))
				FROM (
				
				SELECT Amount
				FROM WorkOrderLineDetail D
				INNER JOIN WorkOrderLineDetailCharge C 
					ON C.WorkOrderId = D.WorkOrderId
					AND	C.WorkOrderLine = D.WorkOrderLine
					AND C.ServiceItem = D.ServiceItem
					AND C.ServiceItemUnit = D.ServiceItemUnit
					AND C.TransactionDate = D.TransactionDate
					AND C.Reference = D.Reference
				WHERE D.WorkOrderId = L.WorkOrderId
				AND	D.WorkOrderLine = L.WorkOrderLine
				AND D.ServiceUsageSerialNo <= A.SerialNo
				AND D.ServiceUsageSerialNo > ISNULL((
					SELECT TOP 1 A1.SerialNo
					FROM WorkOrderLineAction A1
					WHERE A1.WorkOrderId = A.WorkOrderId
					AND A1.WorkOrderLine = A.WorkOrderLine
					AND A1.SerialNo < A.SerialNo
					AND A1.ActionStatus<>'9'
					ORDER BY A1.SerialNo DESC),0)
					
				AND D.Transactiondate>= (
					SELECT TOP 1 DatePostingCalculate
					FROM ServiceItemMission M
					WHERE M.Mission   = W.Mission
					AND M.serviceItem = D.ServiceItem)
					
				AND C.Charged = '1'
				
				UNION ALL
				
				SELECT Amount
				FROM WorkOrderLineDetail D
				WHERE D.WorkOrderId = L.WorkOrderId
				AND	D.WorkOrderLine = L.WorkOrderLine
				AND D.ServiceUsageSerialNo <= A.SerialNo
				AND D.ServiceUsageSerialNo > ISNULL((
					SELECT TOP 1 A1.SerialNo
					FROM WorkOrderLineAction A1
					WHERE A1.WorkOrderId = A.WorkOrderId
					AND A1.WorkOrderLine = A.WorkOrderLine
					AND A1.SerialNo < A.SerialNo
					AND A1.ActionStatus<>'9'
					ORDER BY A1.SerialNo DESC),0)
					
				AND D.Transactiondate>= (
					SELECT TOP 1 DatePostingCalculate
					FROM ServiceItemMission M
					WHERE M.Mission   = W.Mission
					AND M.serviceItem = D.ServiceItem)

				AND NOT EXISTS (
				
					SELECT *
					FROM WorkOrderLineDetailCharge C1 
					WHERE C1.WorkOrderId = D.WorkOrderId
					AND	C1.WorkOrderLine = D.WorkOrderLine
					AND C1.ServiceItem = D.ServiceItem
					AND C1.ServiceItemUnit = D.ServiceItemUnit
					AND C1.TransactionDate = D.TransactionDate
					AND C1.Reference = D.Reference
				
				)					
				) AS TT
				
			),0) AS TotalBusinessApproved,	
	
			ISNULL((
				SELECT SUM(Amount)
				FROM   WorkOrderLineDetail D INNER JOIN WorkOrderLineDetailCharge C 
						ON C.WorkOrderId      = D.WorkOrderId
						AND	C.WorkOrderLine   = D.WorkOrderLine
						AND C.ServiceItem     = D.ServiceItem
						AND C.ServiceItemUnit = D.ServiceItemUnit
						AND C.TransactionDate = D.TransactionDate
						AND C.Reference       = D.Reference
				WHERE D.WorkOrderId        = L.WorkOrderId
				AND	  D.WorkOrderLine      = L.WorkOrderLine
				AND   D.ServiceUsageSerialNo <= A.SerialNo
				AND   D.ServiceUsageSerialNo > ISNULL((
							SELECT TOP 1 A1.SerialNo
							FROM WorkOrderLineAction A1
							WHERE A1.WorkOrderId = A.WorkOrderId
							AND A1.WorkOrderLine = A.WorkOrderLine
							AND A1.SerialNo      < A.SerialNo
							AND A1.ActionStatus  <> '9'
							ORDER BY A1.SerialNo DESC),0)
							
				AND D.Transactiondate>= (
					SELECT TOP 1 DatePostingCalculate
					FROM ServiceItemMission M
					WHERE M.Mission   = W.Mission
					AND M.serviceItem = D.ServiceItem)
							
				AND C.Charged = '2'
			),0) AS TotalPersonalApproved
			
	FROM   WorkOrderLine L
	
		   INNER JOIN WorkOrder W ON L.WorkOrderId = W.WorkOrderId 
		   INNER JOIN ServiceItem S ON S.Code = W.ServiceItem
		   INNER JOIN WorkOrderLineAction A ON L.WorkOrderId = A.WorkOrderId AND L.WorkOrderLine = A.WorkOrderLine AND A.ActionClass = S.UsageActionClose
		   INNER JOIN Employee.dbo.Person P ON L.PersonNo = P.PersonNo
		   LEFT OUTER JOIN Ref_ServiceItemDomain D ON L.ServiceDomain = D.Code
		
	WHERE  L.Operational = 1
	AND    A.ActionStatus <> '9'
	
	<cfif url.scope eq "portal">	
	 AND   L.PersonNo    = '#client.personno#'
	 AND   W.ServiceItem = '#url.serviceItem#'		
	<cfelse>
	
		<cfif url.workorderid neq "">
		 AND   L.WorkOrderId = '#url.workorderid#'
		</cfif>

		<cfif url.workorderline neq "">
		 AND   L.WorkOrderLine = '#url.workorderline#'
		</cfif>
	 
	</cfif>
	) X
	WHERE X.TransactionsApproved > 0
	ORDER BY x.Reference,x.SerialNo DESC	
	
	
</cfquery>

</cfoutput>

<!--- define the access for back-office--->

<cfif url.scope neq "portal">

	<cfquery name="Customer" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    
		SELECT  C.*, W.ServiceItem, W.Mission
	    FROM    Customer C INNER JOIN WorkOrder W ON C.CustomerId = W.CustomerId
		WHERE   W.WorkOrderId = '#url.workorderid#'	
	
	</cfquery>
	
	<cfquery name="Param" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		 SELECT  *	
	   	 FROM    Ref_ParameterMission
		 WHERE   Mission  = '#Customer.mission#'		
	</cfquery>
	
	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderFunder" 
	   mission          = "#Param.TreeCustomer#" 
	   serviceitem      = "#Customer.serviceitem#"
	   orgunit          = "#Customer.OrgUnit#"
	   returnvariable   = "access">				   
	
	<cfif SearchResult.recordcount eq "0">
	
		<table align="center">
		<tr><td align="center" height="60" class="labelmedium"><cf_tl id="There are no closing records for this user" class="message"></td></tr></table>		
	    <cfabort>
	
	</cfif>
	
<cfelse>

	<cfset access = "EDIT">
	
</cfif> 

<cfinclude template="ClosingServiceLine.cfm">


