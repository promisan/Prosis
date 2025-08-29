<!--
    Copyright © 2025 Promisan B.V.

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
<cf_droptable dbname="AppsQuery" tblname="tWorkOrderUsage">
<cf_droptable dbname="AppsQuery" tblname="tWorkOrderUsageTopic">
<!---
<cf_droptable dbname="AppsQuery" tblname="tmpWorkOrderUsageNBillable">
<cf_droptable dbname="AppsQuery" tblname="tmpWorkOrderUsageTopicNBillable">
--->
<cf_droptable dbname="AppsOLAP" tblname="skWorkOrderCharges">
<cf_droptable dbname="AppsOLAP" tblname="skWorkOrderUsage">
<!---
<cf_droptable dbname="AppsOLAP" tblname="skWorkOrderUsageNonBillable">
--->
<cf_droptable dbname="AppsOLAP" tblname="skWorkOrderProvisioning">


<cfquery name="Provisioning" 
   datasource="AppsOLAP" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT newid() as FactTableId,
			CU.CustomerName as Customer_dim,
			S.Code as ServiceName_dim,
			S.Description as ServiceName_nme,
			S.ListingOrder as ServiceName_ord,
			SC.Code as ServiceCategory_dim,
			SC.Description as ServiceCategory_nme,
			SC.ListingOrder as ServiceCategory_ord,
			U.Unit as FeatureDescription_dim,
			U.UnitDescription as FeatureDescription_nme,
			U.ListingOrder as FeatureDescription_ord,
			UC.Code as FeatureCategory_dim,
			UC.Description as FeatureCategory_nme,		
			UC.ListingOrder as FeatureCategory_ord,					
			L.Reference as ServiceAccount_dim,		
			
			CASE D.Charged
				WHEN '0' THEN 'NonBillable'
				ELSE 'Billable'
			END as Billable_dim,
			
			D.BillingMode,			
			D.Frequency,
			D.Quantity,
			D.Currency,
			D.Rate,
			D.Amount,
			P.PersonNo as UserName_dim,
			replace(P.FullName,'''','') as UserName_nme,
			W.Mission,
			O.orgunit as OrgUnit_dim,
			O.OrgunitName as OrgUnit_nme,			
			PO.Orgunit as ParentOrgUnit_dim,
			PO.OrgUnitName as ParentOrgUnit_nme			
			,(select top 1 ContractLevel
				from employee.dbo.PersonContract PC
				where PC.PersonNo = L.PersonNo 
				and PC.DateEffective <= getdate()
				and PC.DateExpiration > getdate()
				order by DateExpiration Desc) as Grade_dim

			,(select top 1 G.PostOrder
				from employee.dbo.PersonContract PC
				inner join employee.dbo.Ref_PostGrade G on PC.ContractLevel = G.PostGrade
				where PC.PersonNo = L.PersonNo 
				and PC.DateEffective <= getdate()
				and PC.DateExpiration > getdate()
				order by DateExpiration Desc) as Grade_ord			
				
			,ISNULL(DC.Code,'') AS OwnerType_dim
			,ISNULL(DC.Description,'') AS OwnerType_nme
			,ISNULL(DC.ListingOrder,0) AS OwnerType_ord
				
    INTO    dbo.skWorkOrderProvisioning
				
	FROM WorkOrder.dbo.WorkOrderLine L
		INNER JOIN WorkOrder.dbo.WorkOrderLineBilling B ON L.WorkOrderid = B.WorkOrderid and L.WorkOrderLine = B.WorkOrderLine
		INNER JOIN WorkOrder.dbo.WorkOrderLineBillingDetail D ON L.WorkOrderid = D.WorkOrderid and L.WorkOrderLine = D.WorkOrderLine AND D.BillingEffective=B.BillingEffective
		INNER JOIN WorkOrder.dbo.WorkOrder W ON L.WorkOrderId = W.WorkOrderId  
		INNER JOIN WorkOrder.dbo.ServiceItem S ON W.ServiceItem = S.Code
		INNER JOIN WorkOrder.dbo.ServiceItemUnit U ON D.ServiceItem = U.ServiceItem and D.ServiceItemUnit = U.Unit
		INNER JOIN WorkOrder.dbo.Ref_UnitClass UC ON U.UnitClass = UC.Code
		INNER JOIN WorkOrder.dbo.ServiceItemClass SC ON S.ServiceClass = SC.Code
		INNER JOIN WorkOrder.dbo.Customer CU ON W.CustomerId = CU.CustomerId
		LEFT OUTER JOIN Employee.dbo.Person P ON L.PersonNo = P.PersonNo
		INNER JOIN Organization.dbo.Organization O ON CU.Orgunit = O.Orgunit
		LEFT OUTER JOIN Organization.dbo.Organization PO ON O.HierarchyRootUnit = PO.Orgunitcode AND O.Mission = PO.mission	
		LEFT OUTER JOIN WorkOrder.dbo.Ref_ServiceItemDomainClass DC ON L.ServiceDomain = DC.ServiceDomain AND L.ServiceDomainClass = DC.Code
	WHERE L.Operational = 1
	AND ((L.DateExpiration >= getdate()) OR (L.DateExpiration is null))
	AND S.Operational =1
	AND U.Operational =1 
	AND D.BillingEffective <= getdate()
	AND ((B.BillingExpiration >= getdate()) OR (B.BillingExpiration is null))
	
</cfquery>
 			             
<cfquery name="Charges" 
   datasource="AppsOLAP" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 
	SELECT	newid() as FactTableId,
			CU.CustomerName as Customer_dim,
			S.Code as ServiceName_dim,
			S.Description as ServiceName_nme,
			S.ListingOrder as ServiceName_ord,			
			SC.Code as ServiceCategory_dim,
			SC.Description as ServiceCategory_nme,
			SC.ListingOrder as ServiceCategory_ord,
			U.Unit as FeatureDescription_dim,
			U.UnitDescription as FeatureDescription_nme,
			U.ListingOrder as FeatureDescription_ord,
			UC.Code as FeatureCategory_dim,
			UC.Description as FeatureCategory_nme,		
			UC.ListingOrder as FeatureCategory_ord,
			L.Reference as ServiceAccount_dim,		
			Year(C.SelectionDate) as Year_dim,
			Month(C.SelectionDate) as Month_dim,
			CASE Month(C.SelectionDate) 
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
			L.PersonNo,
			C.SelectionDate,
			C.BillingMode,
			C.Currency,
			C.Amount,
			W.Mission,
			O.orgunit as OrgUnit_dim,
			O.OrgunitName as OrgUnit_nme,
			PO.Orgunit as ParentOrgUnit_dim,
			PO.OrgUnitName as ParentOrgUnit_nme			
			
			,ISNULL(
				(select top 1 ContractLevel
				from employee.dbo.PersonContract PC
				where PC.PersonNo = C.PersonNo 
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
			
			,ISNULL (
			(select top 1 G.PostOrder
				from employee.dbo.PersonContract PC
				inner join employee.dbo.Ref_PostGrade G on PC.ContractLevel = G.PostGrade
				where PC.PersonNo = C.PersonNo 
				and PC.DateEffective <= getdate()
				and PC.DateExpiration > getdate()
				order by DateExpiration Desc),0) as Grade_ord

			,Pe.PersonNo as Person_dim
			,replace(Pe.FullName,'''','') as Person_nme
			
			,ISNULL(DC.Code,'') AS OwnerType_dim
			,ISNULL(DC.Description,'') AS OwnerType_nme
			,ISNULL(DC.ListingOrder,0) AS OwnerType_ord
			
	INTO    dbo.skWorkOrderCharges
	
	FROM   WorkOrder.dbo.skWorkOrderCharges C
			INNER JOIN WorkOrder.dbo.WorkOrder W ON C.WorkOrderId = W.WorkOrderId
			INNER JOIN WorkOrder.dbo.ServiceItem S ON C.ServiceItem = S.Code
			INNER JOIN WorkOrder.dbo.ServiceItemUnit U ON C.ServiceItem = U.ServiceItem and C.ServiceItemUnit = U.Unit
			INNER JOIN WorkOrder.dbo.Customer CU ON W.CustomerId = CU.CustomerId
			INNER JOIN WorkOrder.dbo.ServiceItemClass SC ON S.ServiceClass = SC.Code
			INNER JOIN WorkOrder.dbo.Ref_UnitClass UC ON U.UnitClass = UC.Code
			INNER JOIN WorkOrder.dbo.WorkOrderLine L ON C.WorkOrderid = L.WorkOrderid and C.WorkOrderLine = L.WorkOrderLine
			INNER JOIN Organization.dbo.Organization O ON CU.Orgunit = O.Orgunit
			LEFT OUTER JOIN Organization.dbo.Organization PO ON O.HierarchyRootUnit = PO.Orgunitcode AND O.Mission = PO.mission	
			LEFT OUTER JOIN Employee.dbo.Person PE on PE.PersonNo = L.PersonNo	
			LEFT OUTER JOIN WorkOrder.dbo.Ref_ServiceItemDomainClass DC ON L.ServiceDomain = DC.ServiceDomain AND L.ServiceDomainClass = DC.Code
	WHERE  S.Operational = 1
	<!---
	AND    U.Operational = 1 	 
	--->
</cfquery>

<cfquery name="Usage" 
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
			  
			  ,IL.ServiceUsageSerialNo as UsageUploadId_dim
			  ,IL.ActionStatus as UsageUploadStatus_dim
			  
			  ,CASE IL.ActionStatus
			  	WHEN '0' THEN 'Pending Review'
				WHEN '1' THEN 'Approved'
				WHEN '9' THEN 'Discarded'
			   END AS UsageUploadStatus_nme
			  
			
	INTO UserQuery.dbo.tWorkOrderUsage
	FROM   WorkOrder.dbo.WorkOrderLineDetail D
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
		INNER JOIN WorkOrder.dbo.ServiceItemLoad IL ON IL.Mission = W.Mission AND IL.ServiceItem = D.Serviceitem AND IL.ServiceUsageSerialNo = D.ServiceUsageSerialNo
		LEFT OUTER JOIN Organization.dbo.Organization PO ON O.HierarchyRootUnit = PO.Orgunitcode AND O.Mission = PO.mission
		LEFT OUTER JOIN Employee.dbo.Person PE on PE.PersonNo = L.PersonNo	
		LEFT OUTER JOIN WorkOrder.dbo.Ref_ServiceItemDomainClass DC ON L.ServiceDomain = DC.ServiceDomain AND L.ServiceDomainClass = DC.Code		
	WHERE S.Operational = 1
	AND   D.ActionStatus != '9'
<!---	AND ((L.DateExpiration > getdate()) or (L.DateExpiration is null))--->
	
</cfquery>	


<cfquery name="Topics"
	Datasource="AppsQuery"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">


	SELECT  *
	INTO UserQuery.dbo.tWorkOrderUsageTopic
	FROM WorkOrder.dbo.WorkOrderLineDetailTopic	
	WHERE TransactionId IN (
		SELECT TransactionId FROM UserQuery.dbo.tWorkOrderUsage)
		
</cfquery>	

<cfquery name="UsageTopics"
	Datasource="AppsOLAP"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	
		SELECT D.*,
		
				(SELECT TopicValue FROM UserQuery.dbo.tWorkOrderUsageTopic WHERE TransactionId = D.TransactionId AND Topic = 'T031') AS Location_dim,
				(SELECT TopicValue FROM UserQuery.dbo.tWorkOrderUsageTopic WHERE TransactionId = D.TransactionId AND Topic = 'T032') AS CallType_dim,
				(SELECT TopicValue FROM UserQuery.dbo.tWorkOrderUsageTopic WHERE TransactionId = D.TransactionId AND Topic = 'T034') AS Direction_dim,
				(SELECT TopicValue FROM UserQuery.dbo.tWorkOrderUsageTopic WHERE TransactionId = D.TransactionId AND Topic = 'T049') AS Origin_dim	
		INTO dbo.skWorkOrderUsage
		FROM UserQuery.dbo.tWorkOrderUsage D
		
</cfquery>

<!--- Non Billable Usage ---->
<!----
<cfquery name="UsageNonBillable" 
   datasource="AppsOLAP" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#"
   timeout="5000">

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
			,(select top 1 ContractLevel
				from employee.dbo.PersonContract PC
				where PC.PersonNo = L.PersonNo 
				and PC.DateEffective <= getdate()
				and PC.DateExpiration > getdate()
				order by DateExpiration Desc) as PersonGrade_dim

			,(select top 1 G.PostOrder
				from employee.dbo.PersonContract PC
				inner join employee.dbo.Ref_PostGrade G on PC.ContractLevel = G.PostGrade
				where PC.PersonNo = L.PersonNo 
				and PC.DateEffective <= getdate()
				and PC.DateExpiration > getdate()
				order by DateExpiration Desc) as PersonGrade_ord
				
			,Pe.PersonNo as UserName_dim
			,replace(Pe.FullName,'''','') as UserName_nme

			,ISNULL(DC.Code,'NoClass') AS OwnerType_dim
			,ISNULL(DC.Description,'--No Class--') AS OwnerType_nme
			,ISNULL(DC.ListingOrder,0) AS OwnerType_ord
			
			,CASE
				WHEN L.DateExpiration IS NULL THEN 'Expired'
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
			  ,'NonBillable' as Billable_dim
			
	INTO UserQuery.dbo.tmpWorkOrderUsageNBillable
	FROM   WorkOrder.dbo.WorkOrderLineDetailNonBillable D
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
	AND YEAR(D.TransactionDate) >= 2013
<!---	AND ((L.DateExpiration > getdate()) or (L.DateExpiration is null))--->
	
</cfquery>	


<cfquery name="TopicsNonBillable"
	Datasource="AppsQuery"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"
	timeout="5000">


	SELECT  *
	INTO UserQuery.dbo.tmpWorkOrderUsageTopicNBillable
	FROM WorkOrder.dbo.WorkOrderLineDetailTopicNonBillable
	WHERE TransactionId IN (
		SELECT TransactionId FROM UserQuery.dbo.tmpWorkOrderUsageNBillable)
		
</cfquery>	

<cfquery name="UsageTopicsNonBillable"
	Datasource="AppsOLAP"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"
	timeout="5000">
	
	
		SELECT D.*,
		
				(SELECT TopicValue FROM UserQuery.dbo.tmpWorkOrderUsageTopicNBillable WHERE TransactionId = D.TransactionId AND Topic = 'T031') AS Location_dim,
				(SELECT TopicValue FROM UserQuery.dbo.tmpWorkOrderUsageTopicNBillable WHERE TransactionId = D.TransactionId AND Topic = 'T032') AS CallType_dim,
				(SELECT TopicValue FROM UserQuery.dbo.tmpWorkOrderUsageTopicNBillable WHERE TransactionId = D.TransactionId AND Topic = 'T034') AS Direction_dim,
				(SELECT TopicValue FROM UserQuery.dbo.tmpWorkOrderUsageTopicNBillable WHERE TransactionId = D.TransactionId AND Topic = 'T049') AS Origin_dim	
		INTO dbo.skWorkOrderUsageNonBillable
		FROM UserQuery.dbo.tmpWorkOrderUsageNBillable D
		
</cfquery>
--->


<cfquery name="Indexes" 
   datasource="AppsOLAP" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#"
   timeout="5000">
	CREATE  NONCLUSTERED  INDEX IX_skWorkOrderCharges  ON skWorkOrderCharges (Mission) 
	CREATE  NONCLUSTERED  INDEX IX_skWorkOrderUsage  ON skWorkOrderUsage (Mission) 
	CREATE  NONCLUSTERED  INDEX IX_skWorkOrderUsageRef  ON skWorkOrderUsage (ServiceAccount_dim, TransactionDate) 
<!---	CREATE  NONCLUSTERED  INDEX IX_skWorkOrderUsageNB  ON skWorkOrderUsageNonBillable (Mission) 
	CREATE  NONCLUSTERED  INDEX IX_skWorkOrderUsageRefNB  ON skWorkOrderUsageNonBillable (ServiceAccount_dim, TransactionDate) 
--->
	CREATE  NONCLUSTERED  INDEX IX_skWorkOrderProvisioning  ON skWorkOrderProvisioning (Mission) 	
</cfquery>