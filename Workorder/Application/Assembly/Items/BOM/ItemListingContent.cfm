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

<cfquery name="Workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Workorder
    WHERE     WorkorderId = '#url.workorderid#'    									  
</cfquery>

<cfquery name="Line" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrderLine
	WHERE     WorkOrderId   = '#url.workorderid#' 				
	AND       WorkOrderLine = '#url.workorderline#'
</cfquery>	

<cfquery name="Service" 
	datasource="AppsWorkOrder"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
	FROM      WorkOrderServiceMission
	WHERE     ServiceDomain   = '#Line.ServiceDomain#' 				
	AND       Reference       = '#Line.Reference#'
	AND       Mission         = '#WorkOrder.Mission#'				
</cfquery>	

<cfset bomwhs = "">

<cfif service.orgunitimplementer neq "">
			
	<cfquery name="BOMwarehouse" 
		datasource="AppsMaterials"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">					
		SELECT    W.*
		FROM      Organization.dbo.Organization AS O INNER JOIN
  	              Materials.dbo.Warehouse AS W ON O.MissionOrgUnitId = W.MissionOrgUnitId
		WHERE     O.OrgUnit = '#service.OrgUnitImplementer#'					
	</cfquery>
	
	<cfif bomwarehouse.recordcount eq "1">
	
		<cfset bomwhs = BOMwarehouse.Warehouse>
	
	</cfif>
	
</cfif>				

<cfparam name="url.mode" default="FinalProduct">

<cfoutput>

<!--- code to define what is earmarked and what is not earmarked --->

<cfinvoke component = "Service.Process.WorkOrder.WorkorderLineItem"  
	   method           = "InternalWorkOrder" 
	   datasource       = "AppsMaterials"
	   mission          = "#WorkOrder.Mission#" 
	   workorderid      = "#url.WorkOrderId#"
       workorderline    = "#url.WorkOrderLine#"
	   Table            = "WorkOrderLineResource"
	   mode             = "view"
	   returnvariable   = "NotEarmarked">	
	   
	
<cfsavecontent variable="qQuery">

	SELECT WIR.WorkOrderId,
           WIR.WorkOrderLine, 
		   WIR.ResourceId,
		   WIR.ResourceItemNo, 
		   WIR.ResourceReference,
		   I.ItemDescription, 
		   I.Classification,
		   I.ItemClass,
		   I.Category,
		   RM.Code,
		   RM.Description,
		   WIR.ResourceUoM, 
		   UoM.UoMDescription, 
		   WIR.Quantity, 
           WIR.Amount AS Cost,
		   
		     <cfif getAdministrator(url.mission) eq "1">
			   
			    (CASE W.ActionStatus WHEN 1 THEN '2' ELSE '2' END) as AccessLevel,
			   
			   <cfelse>
			   
			    (CASE W.ActionStatus WHEN 1 THEN (
							
							 CASE  	(SELECT   count(*) 
									 FROM     Organization.dbo.OrganizationAuthorization AS A 
									 WHERE    A.UserAccount    = '#SESSION.acc#' 	
									 AND 	  A.Mission       = '#WorkOrder.Mission#'								 
									 AND      A.ClassParameter = '#Workorder.serviceitem#'
									 AND      A.Role           = 'WorkOrderProcessor' 
									 AND      A.Accesslevel   > '0' )
						 
						 	  WHEN 0 THEN '0' ELSE '2' END
							 								 
							 ) ELSE '0' END) as AccessLevel,			  
			   
			   </cfif>		
			   
			<cfif url.mode eq "FinalProduct">   		   			
		             
           (SELECT  ISNULL(SUM(RequestQuantity), 0)
            FROM    Purchase.dbo.RequisitionLine
            WHERE   Mission = '#url.mission#'  AND RequirementId   = WIR.ResourceId 			                                 
											   AND WorkOrderId     = WIR.WorkOrderId 
											   AND WorkOrderLine   = WIR.WorkOrderLine
											   AND ActionStatus   != '9' 
											   AND ActionStatus   >= '1') AS Procurement,
		   
		   <!--- transaction --->
		   
           ( SELECT  ISNULL(SUM(TransactionQuantity), 0)
             FROM    Materials.dbo.Itemtransaction
             WHERE   Mission = '#url.mission#' AND RequirementId = WIR.ResourceId 
			 								   <!---	
			                                   AND ItemNo          = WIR.ResourceItemNo 
			                                   AND TransactionUoM  = WIR.ResourceUoM
											   --->
											   AND TransactionType IN ('1','9') 
											   AND ActionStatus    = '1' <!--- confirmed --->
											   AND WorkOrderId     = WIR.WorkOrderId 
											   AND WorkOrderLine   = WIR.WorkOrderLine) AS Received,
											   
			</cfif>								   
											   
		   ( SELECT  ISNULL(SUM(TransactionQuantity*-1), 0)
             FROM    Materials.dbo.Itemtransaction			  
             WHERE   Mission         = '#url.mission#' 
			 AND     RequirementId = WIR.ResourceId
			 
			 <!---
			 AND     ItemNo          = WIR.ResourceItemNo 
             AND     TransactionUoM  = WIR.ResourceUoM 
			 --->
			 
     	     AND     TransactionType = '2' 	<!--- confirmed and not confirmed --->										   
		     AND     WorkOrderId     = WIR.WorkOrderId 
		     AND     WorkOrderLine   = WIR.WorkOrderLine) AS Consumed,							   

         											   
		   ( SELECT  ISNULL(SUM(TransactionQuantity), 0)
             FROM    Materials.dbo.Itemtransaction
             WHERE   Mission       = '#url.mission#' 
			 AND     RequirementId = WIR.ResourceId 
             		 
				     <!--- confirmed receipts or transfers 
					      AND pending/confirmed issuances --->
					 
			 AND     (
			          (ActionStatus = '1' and TransactionType != '2') OR (ActionStatus  IN ('0','1') and TransactionType = '2')
				     )		
					 					  
			 AND     WorkOrderId   = WIR.WorkOrderId 
		     AND     WorkOrderLine = WIR.WorkOrderLine) AS Earmarked,	
			 				 			
			 
			<!--- a regular stock query to reflect possible stock 
			                               available for this item in this mission --->	
										   
		   ( SELECT  SUM(TransactionQuantity)
             FROM    Materials.dbo.Itemtransaction T
             WHERE   Mission        = '#url.mission#' 
			 AND     ItemNo         = WIR.ResourceItemNo 
             AND     TransactionUoM = WIR.ResourceUoM
			 
			 <!--- approved transaction, but issuance we take immediately --->
			 
			 AND     (
			          (ActionStatus = '1' and TransactionType != '2') OR (ActionStatus  IN ('0','1') and TransactionType = '2')
				     )		
					 
			 AND    (T.RequirementId is NULL or T.RequirementId IN (#preserveSingleQuotes(NotEarmarked)#))) AS NotEarmarked		
			 
			 
			 <!--- stock for item in warehouse --->
			 
			 <cfif bomwhs neq "">
			 
			 ,
			 
				 ( SELECT  SUM(TransactionQuantity)
    	         FROM    Materials.dbo.Itemtransaction T
        	     WHERE   Warehouse      = '#BOMWarehouse.Warehouse#' 
				 AND     ItemNo         = WIR.ResourceItemNo 
	             AND     TransactionUoM = WIR.ResourceUoM ) as OnHand
			 
			 </cfif>
			 			 								   		 
		   
       
	FROM     WorkOrderLineResource WIR INNER JOIN
             Materials.dbo.Item I ON WIR.ResourceItemNo = I.ItemNo INNER JOIN
             Materials.dbo.ItemUoM UoM ON WIR.ResourceItemNo = UoM.ItemNo AND WIR.ResourceUoM = UoM.UoM INNER JOIN 
             Ref_ResourceMode RM ON WIR.ResourceMode = RM.Code INNER JOIN
			 Workorder W ON WIR.WorkOrderId = W.WorkOrderId 	
		 
	WHERE    WIR.WorkOrderId   = '#url.workorderid#' 
	AND      WIR.WorkOrderLine = '#url.workorderline#'
	AND      I.Category = '#url.category#'
		
	--Condition
							
</cfsavecontent>


</cfoutput>


<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfif url.mode eq "FinalProduct">
			
	<cfset itm = itm+1>
	<cf_tl id="Resource Mode" var="tResourceMode">
	<cfset fields[itm] = {label          = "#tResourceMode#",                   		
						 field           = "Code",
						 alias           = "RM",
						 processmode     = "radio",				
						 processlist     = "None=na,Purchase=Stock,Receipt=Cus",					
						 processtemplate = "WorkOrder/Application/Assembly/Items/BOM/setResourceMode.cfm?resourceid="}>
					 
</cfif>					 

<cfset itm = itm+1>
<cf_tl id="Item" var="tItem">
<cfset fields[itm] = {label     = "#tItem#",                   		
					 field      = "ResourceItemNo",
					 alias      = "WIR"}>					
						
<cfset itm = itm+1>		
<cf_tl id="Description" var="tDescription">
<cfset fields[itm] = {label      = "#tDescription#",                    
					 field       = "ItemDescription",
					 alias       = "I",
					 search      = "text",
					 filtermode  = "2"}>	
					 
<cfset itm = itm + 1>		
<cf_tl id="Class" var="tClass">
<cfset fields[itm] = {label    = "#tClass#", 					
					 field     = "ItemClass",
					 alias     = "I",
					 search    = "text",
					 filtermode  = "2"}>							 

			 
<cfset itm = itm + 1>						
<cf_tl id="Reference" var="tReference">
<cfset fields[itm] = {label    = "#tReference#", 					
					 field     = "ResourceReference",
					 alias     = "WIR",
					 search    = "text",
					 filtermode  = "2"}>						 	
				 
			 
	
<cfset itm = itm + 1>
<cf_tl id="UoM" var="vUoM">
<cfset fields[itm] = {label     = "#vUoM#", 					
					 field      = "UoMDescription",
					 alias      = "U",
					 search     = "text",
					 filtermode  = "2"}>		
					 
<cfif bomwhs neq "">
	
	<cfset itm = itm + 1>			
	<cfset fields[itm] = {label     = "#BOMWarehouse.Warehouse#", 					
						 field      = "OnHand",					
						 search     = "number",
						 style      = "background-color:DDFBE2",
						 align      = "right",
						  width      = "20",
						 formatted  = "numberformat(OnHand,',__.__')"}>	
					 
</cfif>							 				

<cfset itm = itm + 1>					
<cf_tl id="Required" var="vRequired">										
<cfset fields[itm] = {label     = "#vRequired#", 					
					 field      = "Quantity",
					 align      = "right",
					 style      = "background-color:ffffaf",
					 width      = "20",
					 formatted  = "numberformat(Quantity,',__.__')"}>						

<cfif url.mode eq "FinalProduct">
					 
	<cfset itm = itm + 1>		
	<cf_tl id="Purchase" var="tPurchase">
	<cfset fields[itm] = {label     = "#tPurchase#", 					
						 field      = "Procurement",
						 align      = "right",
						 style      = "background-color:ffffaf",
						 width      = "20",
						 formatted  = "numberformat(Procurement,',__.__')"}>			
						 
	<cfset itm = itm + 1>							
	<cf_tl id="Receipt" var="tReceipt">								
	<cfset fields[itm] = {label     = "#tReceipt#", 					
						 field      = "Received",
						 align      = "right",
						 style      = "background-color:ffffaf",
						 width      = "20",
						 formatted  = "numberformat(Received,',__.__')"}>	
						 
</cfif>					 
						 
<cfset itm = itm + 1>							
<cf_tl id="Consumed" var="tConsumed">								
<cfset fields[itm] = {label        = "#tConsumed#", 					
					 field         = "Consumed",
					 align         = "right",
					 drilltemplate = "/WorkOrder/Application/Assembly/Items/BOM/getDetailLines.cfm",
					 functionfield = "ResourceId",				
					 style         = "background-color:eaeaea",
					 width         = "20",
					 formatted     = "numberformat(Consumed,',__.__')"}>		
					 
<cfif url.mode eq "FinalProduct">					 					 	
						 
	<cfset itm = itm + 1>
	<cf_tl id="Earmarked" var="tAllocated">
	<cfset fields[itm] = {label        = "#tAllocated#", 					
						 field         = "Available",
						 align         = "right",
						 drilltemplate = "/WorkOrder/Application/Assembly/Items/BOM/getDetailLines.cfm",
						 functionfield = "ResourceId",							
						 style         = "background-color:eaeaea",
						 width         = "20",
						 formatted     = "numberformat(Earmarked,',__.__')"}>				
							 
	<cfset itm = itm + 1>							
	<cf_tl id="Other" var="tOther">								
	<cfset fields[itm] = {label     = "#tOther#", 					
						 field      = "OnHandNotEarmarked",
						 align      = "right",
						 width      = "20",
						 formatted  = "numberformat(NotEarmarked,',__.__')"}>			
					 
</cfif>					 			 					 			 
					 
<cfset itm = itm + 1>
<cf_tl id="Cost" var="tCost">
<cfset fields[itm] = {label     = "#tCost#",
					 field      = "Cost",
					 align      = "right",
					 aggregate  = "SUM",
					 width      = "22",
					 formatted  = "numberformat(Cost,',__.__')"}>			
					 
<cfset itm = itm + 1>
<cf_tl id="RID" var="tRID">
<cfset fields[itm] = {label     = "#tRID#", 					
					 field      = "ResourceId",
					 display    = "no"}>								 					 
									
<cfparam name="url.portal" default="0">

<cfif url.portal eq "0">
																																				   
	<cfset menu=ArrayNew(1)>	
	
		 <!--- access only for processors --->	
		   		   
		 <cfinvoke component = "Service.Access"  
			   method           = "WorkOrderProcessor" 
			   mission          = "#url.mission#"  
			   serviceitem      = "#workorder.serviceitem#"
			   returnvariable   = "access">
							   
		<cfif (access eq "EDIT" or access eq "ALL") and workorder.actionstatus lte "1">			
			
			<cf_tl id="Add Service" var="tAddService">			
			<cfset menu[1] = {label = "#tAddService#", icon = "add.png",	script = "editResourceService('#workorderid#','#workorderline#','')"}>				 
			
			<cfif url.mode eq "FinalProduct">
			
			<cf_tl id="Consume Earmarked Stock" var="tConsume">
				<cfset menu[2] = {label = "#tConsume#", icon = "add.png",	script = "consumeearmarked('#workorderid#','#workorderline#','#url.mode#','#url.category#','#url.systemfunctionid#')"}>		
			
			</cfif>
									
		</cfif>					
		
<cfelse>

	<cfset menu = "">		
							
</cfif>		

<cf_listing
		 header        = "bomheader"
		 box           = "bombox"
		 link          = "#session.root#/workorder/Application/Assembly/Items/BOM/ItemListingContent.cfm?mode=#url.mode#&systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&category=#url.category#"
		 html          = "No"
		 menu          = "#menu#"		 
		 show          = "40"
		 datasource    = "AppsWorkOrder"
		 listquery     = "#qQuery#"
		
		 listgroup     = "Category"
		 listgroupdir  = "ASC"	
		 listorder     = "Classification"	 
		 listorderalias = "I"
		 	
		 headercolor   = "ffffff"
		 listlayout    = "#fields#"
		 filterShow    = "Hide"
		 excelShow     = "Yes"
		 drillmode      = "dialogajax" 
		 drillargument  = "#client.height-420#;400;true;true"                                       
		 drilltemplate  = "/WorkOrder/Application/Assembly/Items/BOM/ResourceView.cfm"
	     drillkey       = "ResourceId">
 
	 	
<!--- we now drill to the item here for this mission. --->