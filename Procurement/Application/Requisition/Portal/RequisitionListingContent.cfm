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
<cfparam name="url.role"     default="ProcReqEntry">
<cfparam name="url.period"   default="">

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

<cfoutput>
		             
<cfsavecontent variable="myquery">	
   
    SELECT *, --, RequestDate
	FROM ( 
	
	SELECT      F.FundingId,
	            L.Period, 				
				L.RequestDate,
								
				F.Fund                  as Fund_dim, 
				
				F.ObjectCode            as Object_dim, 
				      O.Description     as Object_nme, 
					  O.HierarchyCode   as Object_ord, 
				
				I.EntryClass as RequestClass_dim,	  
					  C.Description     as RequestClass_nme,		           	  
				
	            L.ItemMaster            as ItemMaster_dim, 
				      I.Description     as ItemMaster_nme, 
				
				L.StandardCode          as Standard_dim, 
				
				P.ProgramCode           as Program_dim,	  
					  P.ProgramName     as Program_nme,		
				
				Par.OrgUnit             as Service_dim,	
				      Par.OrgUnitName   as Service_nme,	
					  Par.HierarchyCode as Service_ord,
				
				L.OrgUnit               as Unit_dim, 
				      Org.OrgUnitName   as Unit_nme, 
					  Org.HierarchyCode as Unit_ord,  		
					  
				<cf_verifyOperational module="WorkOrder" Warning="No">    	  		
				
				<cfif Operational eq "1">
				
					<!--- added 20/7/2012 --->
					(SELECT W.ServiceItem 
					       FROM WorkOrder.dbo.Workorder W WHERE WorkOrderid = L.WorkOrderId) as WorkOrder_dim,	
						   
					(SELECT W.Reference 
					       FROM Workorder.dbo.Workorder W WHERE WorkOrderid = L.WorkOrderId) as WorkOrderReference,	   	   
					   
				</cfif>	   
				
				L.ActionStatus          as Status_dim, 
				      S.Description     as Status_nme, 
				
				L.OfficerUserId         as Officer_dim, 
				      L.OfficerLastName as Officer_nme, 
				
				L.Reference, 
				L.RequisitionNo, 	
				Left(L.RequestDescription,30) as RequestDescription,			
								
				L.RequestAmountBase * F.Percentage as AmountRequisition, 
				ISNULL(PL.OrderAmountBase  * F.Percentage,0) as AmountObligation,
				L.Created
				
	<!--- INTO        userQuery.dbo.#SESSION.acc#RequisitionFact --->
		
	FROM        RequisitionLine AS L 
	            INNER JOIN RequisitionLineFunding AS F          ON L.RequisitionNo = F.RequisitionNo 
				INNER JOIN Program.dbo.Ref_Object AS O          ON F.ObjectCode = O.Code 
				LEFT OUTER JOIN Program.dbo.Program AS P        ON F.ProgramCode = P.ProgramCode 
				LEFT OUTER JOIN PurchaseLine AS PL              ON L.RequisitionNo = PL.RequisitionNo AND PL.ActionStatus != '9' 
				INNER JOIN ItemMaster AS I                      ON L.ItemMaster = I.Code 
				INNER JOIN Ref_EntryClass AS C                  ON I.EntryClass = C.Code 
				INNER JOIN Organization.dbo.Organization AS Org ON L.OrgUnit = Org.OrgUnit 
				INNER JOIN Organization.dbo.Organization AS Par ON Par.Mission = Org.Mission AND Par.MandateNo = Org.MandateNo and Par.OrgUnitCode = Org.HierarchyRootUnit	
				INNER JOIN Status S                             ON L.ActionStatus = S.Status
				
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
	
	) as D
	WHERE 1=1
	--condition
		
</cfsavecontent>

</cfoutput>
	
<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>
<cfset fields[itm] = {label      = "No",                   
					field      = "Reference",		
					width      = "40",	
					filtermode   = "3",		
					search     = "text"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Status" var="1">						
<cfset fields[itm] = {label       = "#lt_text#", 	
                    LabelFilter   = "#lt_text#",				
					field         = "Status_nme",	
					fieldsort     = "Status_dim",	
					column       = "common",				
					filtermode    = "3",    									
					align         = "left"}>						

<cfif url.period eq "">					

	<cfset itm = itm+1>		
	<cf_tl id="Period" var="1">							
	<cfset fields[itm] = {label      = "#lt_text#",                   
						field        = "Period",								
						column       = "common",										
						align        = "center",
						filtermode   = "3",
						search       = "text"}>	

</cfif>					
<cfset itm = itm+1>		
<cf_tl id="Class" var="1">							
<cfset fields[itm] = {label      = "#lt_text#",                   
					field        = "RequestClass_nme",								
					fieldsort    = "RequestClass_dim",
					column       = "common",										
					align        = "center",
					filtermode   = "3",
					search       = "text"}>		
							
					
<cfset itm = itm+1>
<cf_tl id="Date" var="1">								
<cfset fields[itm] = {label      = "#lt_text#",                   
					field      = "RequestDate",								
					column     = "month",	
					width      = "20",
					align      = "center",
					formatted  = "dateformat(RequestDate,CLIENT.DateFormatShow)",
					search     = "date"}>		
					
<cfset itm = itm+1>
<cf_tl id="Description" var="1">								
<cfset fields[itm] = {label      = "#lt_text#",                   
					field      = "RequestDescription",													
					align      = "left",					
					search     = "text"}>	
					
<cfset itm = itm+1>
<cf_tl id="Officer" var="1">								
<cfset fields[itm] = {label      = "#lt_text#",                   
					field      = "Officer_nme",													
					align      = "left",					
					search     = "text"}>						
					
<cfset itm = itm+1>		
<cf_tl id="Fund" var="1">							
<cfset fields[itm] = {label      = "#lt_text#",                   
					field        = "Program_nme",								
					fieldsort    = "Program_dim",													
					align        = "center",
					filtermode   = "3",
					search       = "text"}>																										
					
<cfset itm = itm+1>		
<cf_tl id="Amount" var="1">									
<cfset fields[itm] = {label      = "#lt_text#",  
					field      = "AmountRequisition",
					search     = "number", 
					aggregate  = "sum",
					width      = "25",
					align      = "right",
					formatted  = "numberformat(AmountRequisition,',.__')"}>	
					
<cfset itm = itm+1>		
<cf_tl id="Obligation" var="1">									
<cfset fields[itm] = {label      = "#lt_text#",  
					field      = "AmountObligation",
					search     = "number", 
					aggregate  = "sum",
					width      = "25",
					align      = "right",
					formatted  = "numberformat(AmountObligation,',.__')"}>	

<!---					
<cfset itm = itm+1>
<cf_tl id="Recorded" var="1">								
<cfset fields[itm] = {label      = "#lt_text#",                   
					field      = "Created",								
					column     = "month",	
					width      = "20",
					align      = "center",
					formatted  = "dateformat(Created,CLIENT.DateFormatShow)",
					search     = "date"}>	
					
					--->
					
					
					
<!---										

<cfset itm = itm+1>
<cf_tl id="Source" var="1">
<cfset fields[itm] = {label      = "#lt_text#",                   
					field      = "TransactionSource",
					filtermode = "2",
					column     = "common",
					search     = "text"}>						
					
<cfset itm = itm+1>
<cf_tl id="Date" var="1">								
<cfset fields[itm] = {label      = "#lt_text#",                   
					field      = "TransactionDate",								
					column     = "month",	
					width      = "20",
					align      = "center",
					formatted  = "dateformat(TransactionDate,CLIENT.DateFormatShow)",
					search     = "date"}>									
					
<cfset itm = itm+1>		
<cf_tl id="Period" var="1">							
<cfset fields[itm] = {label      = "#lt_text#",                   
					field        = "TransactionPeriod",								
					column       = "common",	
					width        = "18",					
					align        = "center",
					filtermode   = "3",
					search       = "text"}>														
				
<cfif journal.TransactionCategory eq "Receivables">
						
	<cfset itm = itm+1>	
	<cf_tl id="Invoice" var="1">						
	<cfset fields[itm] = {label       = "I", 	
	                    LabelFilter   = "#lt_text#",				
						field         = "Invoiced",					
						filtermode    = "3",    
						column       = "common",
						width         = "8",
						search        = "text",
						align         = "center",
						formatted     = "Rating",
						ratinglist    = "NA=Yellow,Issued=silver"}>							
					
</cfif>							

<cfset itm = itm+1>		
<cf_tl id="Relation" var="1">				
<cfset fields[itm] = {label      = "#lt_text#",                    
					field        = "ReferenceName",					
					labelfilter  = "#lt_text#",
					search       = "text"}>	
				
<cfset itm = itm+1>		
<cf_tl id="Reference" var="1">				
<cfset fields[itm] = {label      = "#lt_text#",                    
					field        = "TransactionReference",					
					labelfilter  = "Reference",
					display      = "No",	
					search       = "text"}>	
				
															
			


<cfset itm = itm+1>	
<cf_tl id="Status" var="1">						
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "#lt_text#",				
					field         = "ActionStatus",					
					filtermode    = "3",    
					width         = "8",					
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green,9=Red"}>		
					
--->								
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Id",    					
					display    = "No",					
					field      = "RequisitionNo"}>		
<cftry>

<!---
<cf_wfpending entityCode="ProcInvoice"  
      table="#SESSION.acc#wfInvoice" mailfields="No" IncludeCompleted="No">							--->							
	  						
<cf_listing
    header        = "Requisition#url.mission#"
    box           = "Requisition#url.mission#_#url.period#"
	link          = "#SESSION.root#/Procurement/Application/Requisition/Portal/RequisitionListingContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&period=#url.period#"
    html          = "Yes"
	show          = "250"
	datasource    = "AppsPurchase"
	listquery     = "#myquery#"
	listkey       = "FundingId"		
	listorder     = "RequisitionNo"
	listorderdir  = "DESC"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"	
	drillmode     = "tab"
	drillargument = "1030;#client.widthfull#;false;false"	
	drilltemplate = "Procurement/Application/Requisition/Process/RequisitionView.cfm?mission=#url.mission#&period=#url.period#&requisitionRef="
	drillkey      = "Reference">
	
	<!--- annotation    = "GLTransaction" --->
	
	<cfcatch>
	
	 <cf_message width="100%"
			height="80"
			message="An error has occurred retrieving your data <br>#CFCatch.Message# - #CFCATCH.Detail#" return="no">
	
	</cfcatch>		
	
</cftry>	
