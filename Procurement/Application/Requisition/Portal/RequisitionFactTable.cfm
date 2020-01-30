
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RequisitionFact"> 

<cfparam name="url.role" default="ProcReqEntry">
<cfparam name="url.period" default="">

<cfquery name="Role" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_AuthorizationRole
	 WHERE  Role = '#URL.Role#' 
</cfquery>			

<!--- show only funding requisition lines here and split but funding percentage which is not the same
as in the inquiry status review to be matched with the total --->
		             
<cfquery name="Requisition" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	
	SELECT     newid() as FactTableId, 
				
				L.Period AS Period_dim, 
				
				YEAR(L.RequestDate) as Year_dim,
				MONTH(L.RequestDate) as Month_dim,
				
				F.Fund AS Fund_dim, 
				
				F.ObjectCode AS Object_dim, 
				      O.Description AS Object_nme, 
					  O.HierarchyCode AS Object_ord, 
				
				I.EntryClass AS RequestClass_dim,	  
					  C.Description as RequestClass_nme,		           	  
				
	            L.ItemMaster AS ItemMaster_dim, 
				      I.Description AS ItemMaster_nme, 
				
				L.StandardCode AS Standard_dim, 
				
				P.ProgramCode AS Program_dim,	  
					  P.ProgramName as Program_nme,		
				
				Par.OrgUnit as Service_dim,	
				      Par.OrgUnitName as Service_nme,	
					  Par.HierarchyCode as Service_ord,
				
				L.OrgUnit AS Unit_dim, 
				      Org.OrgUnitName AS Unit_nme, 
					  Org.HierarchyCode AS Unit_ord,  				
				
				<!--- added 20/7/2012 --->
				(SELECT W.ServiceItem FROM WorkOrder.dbo.Workorder W WHERE WorkOrderid = L.WorkOrderId) as WorkOrder_dim,	
				
				L.ActionStatus AS Status_dim, 
				      S.Description AS Status_nme, 
				
				L.OfficerUserId AS Officer_dim, 
				      L.OfficerLastName AS Officer_nme, 
				
				L.Reference, 
				L.RequisitionNo, 				
				(SELECT W.Reference FROM Workorder.dbo.Workorder W WHERE WorkOrderid = L.WorkOrderId) as WorkOrderReference,	            				
				L.CaseNo,
				L.RequestAmountBase * F.Percentage AS AmountRequisition, 
				PL.OrderAmountBase  * F.Percentage AS AmountObligation
				
	INTO        userQuery.dbo.#SESSION.acc#RequisitionFact		
		
	FROM        RequisitionLine AS L 
	            INNER JOIN RequisitionLineFunding AS F ON L.RequisitionNo = F.RequisitionNo 
				INNER JOIN Program.dbo.Ref_Object AS O ON F.ObjectCode = O.Code 
				LEFT OUTER JOIN Program.dbo.Program AS P ON F.ProgramCode = P.ProgramCode 
				LEFT OUTER JOIN PurchaseLine AS PL ON L.RequisitionNo = PL.RequisitionNo AND PL.ActionStatus != '9' 
				INNER JOIN ItemMaster AS I ON L.ItemMaster = I.Code 
				INNER JOIN Ref_EntryClass AS C ON I.EntryClass = C.Code 
				INNER JOIN Organization.dbo.Organization AS Org ON L.OrgUnit = Org.OrgUnit 
				INNER JOIN Organization.dbo.Organization AS Par ON Par.Mission = Org.Mission AND Par.MandateNo = Org.MandateNo and Par.OrgUnitCode = Org.HierarchyRootUnit	
				INNER JOIN Status S ON L.ActionStatus = S.Status
				
	WHERE       L.Mission = '#url.mission#' 
	<cfif url.period neq "">
	AND         L.Period = '#url.period#'
	</cfif>
	
	AND         S.StatusClass = 'Requisition'
	AND         S.Status NOT IN ('0','0z','9')
		
	<!--- to be define if this is needed here. 8/8/2010
	
	<cfif getAdministrator("*") eq "0">
	
	AND (
	
		<cfif Role.OrgUnitLevel eq "All">
							
		 L.OrgUnit IN 
	            (SELECT OrgUnit 
				 FROM   Organization.dbo.OrganizationAuthorization 
				 WHERE  Role        = '#URL.Role#' 
				 AND    UserAccount = '#SESSION.acc#') 
				 
		<cfelse>
		
		 L.OrgUnit IN 
	            (SELECT   O.OrgUnit
				 FROM     Organization.dbo.Organization O INNER JOIN
	                      Organization.dbo.Organization Par ON 
						  	Par.OrgUnitCode = O.HierarchyRootUnit
							AND O.Mission = Par.Mission 
							AND O.MandateNo = Par.MandateNo INNER JOIN
	                      Organization.dbo.OrganizationAuthorization OA ON Par.OrgUnit = OA.OrgUnit
				 WHERE  OA.Role        = '#URL.Role#' 
				 AND    OA.UserAccount = '#SESSION.acc#')		
		
		</cfif>		
		 
		 OR
			Org.Mission IN 
			 (SELECT Mission
			 FROM Organization.dbo.OrganizationAuthorization 
			 WHERE Role        = '#URL.Role#'
			 AND   UserAccount = '#SESSION.acc#'
			 AND   OrgUnit is NULL)
			 
		)	 
		
	</cfif>
	
	--->
		
</cfquery>

<cfset client.table1_ds = "#SESSION.acc#RequisitionFact">