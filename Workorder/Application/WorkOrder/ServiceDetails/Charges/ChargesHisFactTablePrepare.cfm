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
<!--- This is a batch process --->

<cf_droptable dbname="AppsQuery" tblname="tWorkOrderUsageHis">
<cf_droptable dbname="AppsQuery" tblname="tWorkOrderUsageHisTopic">
<cf_droptable dbname="AppsOLAP" tblname="skWorkOrderUsageHis">


<cfquery name="HistoricalUsage" 
   datasource="AppsOLAP" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">

	SELECT	newid() as FactTableID,
			C.CustomerName as Customer_dim,
			D.ServiceItem as ServiceName_dim,
			S.Description as ServiceName_nme,
			S.ListingOrder as ServiceName_ord,
			U.Unit as FeatureDescription_dim,
			U.UnitDescription as FeatureDescription_nme,
			U.ListingOrder as FeatureDescription_ord,		
			UC.Code as FeatureCategory_dim,
			UC.Description as FeatureCategory_nme,	
			UC.ListingOrder as FeatureCategory_ord,	
			SC.Code as ServiceCategory_dim,
			SC.ListingOrder as ServiceCategory_ord,
			SC.Description as ServiceCategory_nme,			
			year(D.TransactionDate) as Year_dim,
			Month(D.TransactionDate) as Month_dim,
			CASE Month(D.TransactionDate) 
				WHEN 1 THEN 'January'
				WHEN 2 THEN 'February'
				WHEN 3 THEN 'March'
				WHEN 4 THEN 'April'
				WHEN 5 THEN 'May'
				WHEN 6 THEN 'June' 
				WHEN 7 THEN 'July'
				WHEN 8 THEN 'August'
				WHEN 9 THEN 'September' 
				WHEN 10 THEN 'October'
				WHEN 11 THEN 'November'
				WHEN 12 THEN 'December'
			END as Month_nme,			
			D.TransactionId,
			L.Reference as ServiceAccount_dim,
			D.TransactionDate,
			D.Reference as UsageReference,
			D.Quantity,
			D.Rate,
			D.Amount,
			W.Mission,
			O.orgunit as OrgUnit_dim,
			O.OrgunitName as OrgUnit_nme,			
			PO.Orgunit as ParentOrgUnit_dim,
			PO.OrgUnitName as ParentOrgUnit_nme			
									
			,ISNULL(
				(select top 1 ContractLevel
				from employee.dbo.PersonContract PC
				where PC.PersonNo = L.PersonNo 
				and PC.DateEffective <= getdate()
				and PC.DateExpiration > getdate()
				order by DateExpiration Desc),
				(
				
				select TOP 1 PostGrade
				from employee.dbo.personAssignment PA
				inner join Employee.dbo.vwPosition V ON PA.PositionNo=V.PositionNo
				where PA.personno = L.PersonNo
				and PA.AssignmentStatus=1
				and V.PostAuthorised=0
				order by PA.DateExpiration desc
				)
			) as Grade_dim
			
			
			,ISNULL(
			(select top 1 G.PostOrder
				from employee.dbo.PersonContract PC
				inner join employee.dbo.Ref_PostGrade G on PC.ContractLevel = G.PostGrade
				where PC.PersonNo = L.PersonNo 
				and PC.DateEffective <= getdate()
				and PC.DateExpiration > getdate()
				order by DateExpiration Desc),0) as Grade_ord
				
			,Pe.PersonNo as UserName_dim
			,replace(Pe.FullName,'''','') as UserName_nme

			,ISNULL(DC.Code,'NoClass') AS OwnerType_dim
			,ISNULL(DC.Description,'--No Class--') AS OwnerType_nme
			,ISNULL(DC.ListingOrder,0) AS OwnerType_ord
			
			,CASE
				WHEN L.DateExpiration IS NULL THEN 'Active'
				WHEN L.DateExpiration <= GETDATE() THEN 'Expired'
				ELSE 'Active'
			 END AS ServiceStatus_dim
			 
			 ,SD.Code as ServiceType_dim
			 ,SD.Description as ServiceType_nme
			 ,(
			 	SELECT TOP 1 LC.Charged
				FROM WorkOrder.dbo.WorkorderLineDetailCharge LC
				WHERE LC.WorkorderId = D.WorkorderId
				AND LC.WorkOrderLine = D.WorkOrderLine
				AND LC.ServiceItem = D.ServiceItem
				AND LC.ServiceItemUnit = D.ServiceItemUnit
				AND LC.TransactionDate = D.TransactionDate
				AND LC.Reference = D.Reference
				) AS Charged
			  ,'Billable' as Billable_dim
			
	INTO UserQuery.dbo.tWorkOrderUsageHis
	FROM   AR_WorkOrder.dbo.ARC_WorkOrderLineDetail D
		INNER JOIN WorkOrder.dbo.WorkOrderLine L ON D.WorkOrderId = L.WorkOrderId and D.WorkOrderLine = L.WorkOrderLine
		INNER JOIN WorkOrder.dbo.WorkOrder W ON L.WorkOrderId = W.WorkOrderId
		INNER JOIN WorkOrder.dbo.Customer C ON W.CustomerId = C.CustomerId
		INNER JOIN WorkOrder.dbo.ServiceItem S ON W.ServiceItem = S.Code
<!---		INNER JOIN WorkOrder.dbo.ServiceItemUnitMission M ON D.ServiceItem = M.ServiceItem AND D.ServiceItemUnit =M.ServiceItemUnit--->
		INNER JOIN WorkOrder.dbo.ServiceItemUnit U ON D.ServiceItem = U.ServiceItem AND D.ServiceItemUnit =U.Unit
		INNER JOIN WorkOrder.dbo.Ref_UnitClass UC ON U.UnitClass = UC.Code
		INNER JOIN WorkOrder.dbo.ServiceItemClass SC ON S.ServiceClass = SC.Code	
		INNER JOIN Organization.dbo.Organization O ON C.Orgunit = O.Orgunit
		INNER JOIN WorkOrder.dbo.Ref_ServiceItemDomain SD ON L.ServiceDomain = SD.Code
		LEFT OUTER JOIN Organization.dbo.Organization PO ON O.HierarchyRootUnit = PO.Orgunitcode AND O.Mission = PO.mission
		LEFT OUTER JOIN Employee.dbo.Person PE on PE.PersonNo = L.PersonNo	
		LEFT OUTER JOIN WorkOrder.dbo.Ref_ServiceItemDomainClass DC ON L.ServiceDomain = DC.ServiceDomain AND L.ServiceDomainClass = DC.Code		
	WHERE S.Operational = 1
	AND Year(D.transactionDate) >= 2010
	AND    D.ActionStatus != '9'
<!---	AND ((L.DateExpiration > getdate()) or (L.DateExpiration is null))--->
	
</cfquery>	


<cfquery name="Topics"
	Datasource="AppsQuery"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">


	SELECT  *
	INTO UserQuery.dbo.tWorkOrderUsageHisTopic
	FROM AR_WorkOrder.dbo.ARC_WorkOrderLineDetailTopic	
	WHERE TransactionId IN (
		SELECT TransactionId FROM UserQuery.dbo.tWorkOrderUsageHis)
		
</cfquery>	

<cfquery name="UsageTopics"
	Datasource="AppsOLAP"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	
		SELECT D.*,
		
				(SELECT TopicValue FROM UserQuery.dbo.tWorkOrderUsageHisTopic WHERE TransactionId = D.TransactionId AND Topic = 'T031') AS Location_dim,
				(SELECT TopicValue FROM UserQuery.dbo.tWorkOrderUsageHisTopic WHERE TransactionId = D.TransactionId AND Topic = 'T032') AS CallType_dim,
				(SELECT TopicValue FROM UserQuery.dbo.tWorkOrderUsageHisTopic WHERE TransactionId = D.TransactionId AND Topic = 'T034') AS Direction_dim,
				(SELECT TopicValue FROM UserQuery.dbo.tWorkOrderUsageHisTopic WHERE TransactionId = D.TransactionId AND Topic = 'T049') AS Origin_dim	
		INTO dbo.skWorkOrderUsageHis
		FROM UserQuery.dbo.tWorkOrderUsageHis D
		
</cfquery>


<cfquery name="Indexes" 
   datasource="AppsOLAP" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#"
   timeout="5000">

	CREATE  NONCLUSTERED  INDEX IX_skWorkOrderUsageHisRef  ON skWorkOrderUsageHis (ServiceAccount_dim, TransactionDate) 
	CREATE  NONCLUSTERED  INDEX IX_skWorkOrderUsageHisCustomer  ON skWorkOrderUsageHis (Customer_dim, ServiceName_dim) 
</cfquery>