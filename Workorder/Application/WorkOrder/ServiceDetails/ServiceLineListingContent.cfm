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

<cfparam name="url.systemfunctionid"    default="">
<cfparam name="url.workorderid"         default="">
<cfparam name="url.orgunit"             default="">
<cfparam name="url.ref"                 default="">
<cfparam name="url.mission"             default="">
<cfparam name="url.domain"              default="">
<cfparam name="url.unit"                default="">
<cfparam name="url.operational"         default="1">
<cfparam name="url.filter"              default="active">

<cfif url.workorderid neq "">
	
	<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrder
		 WHERE   WorkOrderId     = '#url.workorderid#'	
	</cfquery>
	
	<cfquery name="ServiceItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    ServiceItem
		 WHERE   Code   = '#workorder.serviceitem#'	
	</cfquery>
	
	<cfset url.domain  = serviceitem.servicedomain>	
    <cfset url.mission = workorder.mission>
		
</cfif>

<cfquery name="Param" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    Ref_ParameterMission
		 WHERE   Mission = '#url.mission#'	
</cfquery>
  
<cfif url.domain eq "Person">

	<!--- show all services for the person --->
	
	<cfset ref = "Service Id">
	
	<cfparam name="ServiceItem.EnableOrgUnit" default="0">	
	
	<cfset allowconcurrent = "0">
		
<cfelse>
	
	<cfquery name="Domain" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    Ref_ServiceItemDomain
		 WHERE   Code   = '#url.domain#'	
	</cfquery>
	
	<cfset allowconcurrent = domain.allowconcurrent>
	
	<cfif url.workorderid eq "">
	
		<cfquery name="ServiceItem" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT  *	
		     FROM    ServiceItem
			 WHERE   ServiceDomain   = '#url.domain#'	
			 AND     enablePerson = 1
		</cfquery>
	
	</cfif>

	<cfquery name="TopicList" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  R.*
	     FROM    Ref_Topic R INNER JOIN Ref_TopicServiceItem S ON R.Code = S.Code
		 WHERE   ServiceItem = '#serviceitem.code#'	
		 AND     Description != 'Description'
		 AND     R.Operational = 1
		 AND     S.ShowListing = 1
	</cfquery>
	
	<cfif domain.recordcount eq "1">
	    <cfset ref = "#domain.description#">
	<cfelse>
		<cfset ref = "Id">
	</cfif>

</cfif>   

<!--- define fields to be included on the fly --->

<cfset FileNo = round(Rand()*30)>

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#WorkOrder" range="30">  

<cftry>

	<cfquery name="qService" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		SELECT   *
		FROM     Ref_ServiceItemDomainClass
		WHERE    ServiceDomain = '#url.domain#' 
		AND      ServiceType = 'Service'
	</cfquery>

		<cfoutput>  
		<cfsavecontent variable="myquery">
		
		   SELECT *, DateEffective
		   FROM (
			
			SELECT WO.WorkOrderId,
			       W.Reference as WorkOrderReference,
			       WO.WorkOrderLine,
				   WO.WorkOrderLineId,				  
				   C.CustomerName,
				   left(WL.Description,50) as ReferenceName,
				   WO.Reference,
			       WO.DateEffective,
				   ISNULL(WO.DateExpiration,'9999-12-31') as DateExpiration,
				   
				   (SELECT TOP 1 Description
				    FROM   Ref_ServiceItemDomainClass 
					WHERE  ServiceDomain = WO.ServiceDomain
					AND    Code          = WO.ServiceDomainClass) as ServiceDomainClass,		  
					
				   SI.Description,
				   
				   (SELECT   TOP 1 T.Description
					FROM     RequestWorkOrder AS RW INNER JOIN
		                     Request AS R ON RW.RequestId = R.RequestId INNER JOIN
		                     Ref_Request AS T ON R.RequestType = T.Code
					WHERE    RW.WorkOrderId   = WO.WorkorderId
					AND      RW.WorkOrderLine = WO.WorkorderLine 
					ORDER BY R.Created DESC) as RequestType,		 
							   
				   	<cfif url.domain eq "Person">
					
					<cfelse>
				  
				      	<cfif serviceitem.enablePerson eq "1">
							(SELECT PersonNo               FROM Employee.dbo.Person WHERE PersonNo = WO.PersonNo) as PersonNo,
							(SELECT IndexNo                FROM Employee.dbo.Person WHERE PersonNo = WO.PersonNo) as IndexNo,
							(SELECT FirstName+' '+LastName FROM Employee.dbo.Person WHERE PersonNo = WO.PersonNo) as Name,
						</cfif>
						
						<cfif serviceitem.enableOrgUnit eq "1">
							(SELECT TOP 1 OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = WO.OrgUnit) as OrgUnitName,
						</cfif>
									
						<cfloop query="TopicList">			
						  <cfset fld = replace(description," ","","ALL")>
						  <cfset fld = replace(fld,".","","ALL")>
						  <cfset fld = replace(fld,",","","ALL")>
							(SELECT TOP 1 TopicValue 
							 FROM WorkOrderLineTopic 
							 WHERE WorkOrderId = WO.WorkOrderId AND WorkOrderLine = WO.WorkOrderLine AND Operational = 1 AND Topic = '#code#') as #fld#,						
						</cfloop>
					
					</cfif>
					
					( SELECT MIN(BillingEffective) 
					  FROM   WorkOrderLineBilling 
					  WHERE  WorkOrderId   = WO.WorkOrderId 
					  AND    WorkOrderLine = WO.WorkOrderLine			
					) as BillingEffective,	
					
					( SELECT TOP 1 ISNULL(BillingExpiration,'9999-12-31')
					  FROM   WorkOrderLineBilling 
					  WHERE  WorkOrderId   = WO.WorkOrderId 
					  AND    WorkOrderLine = WO.WorkOrderLine	
					  ORDER BY BillingEffective DESC		
					) as BillingExpiration,	
					
					<!--- 3/1/2016 this code is likely very specific for services added a different mode in case we
					know this is a workorder listing --->
								
					( SELECT TOP 1 DateTimePlanning
					  FROM   WorkorderLineAction
					  WHERE  WorkOrderId   = WO.WorkorderId
					  AND    WorkOrderLine = WO.WorkorderLine
					  AND    ActionClass    = SI.UsageActionClose
					  ORDER BY DateTimePlanning DESC
					 ) as LastClosed, 				
					
					<cfif qService.recordcount gte "1">
								
						( SELECT ISNULL(SUM(Amount),0) 
						  FROM   skWorkOrderCharges 
						  WHERE  WorkOrderId   = WO.WorkorderId
						  AND    WorkOrderLine = WO.WorkorderLine
						  AND    SelectionDate >= '01/01/#year(now())#' 
						  AND    SelectionDate <= '12/31/#year(now())#'
						) as Amount,			
					
					<cfelse>
					
					    ( SELECT   ISNULL(SUM(SaleAmountIncome),0)
						  FROM     WorkOrderLineItem
						  WHERE    WorkOrderId   = WO.WorkorderId
						  AND      WorkOrderLine = WO.WorkorderLine
						
						) as Amount,					
					
					</cfif>
								
					WO.Operational,
				    WO.Created		
									
								
		    FROM    Workorder W ,
			        WorkOrderLine WO , 
					WorkOrderService WL ,
					ServiceItem SI , 
					Customer C		
					
		    WHERE   W.WorkOrderId      = WO.WorkorderId
			AND     WO.ServiceDomain   = WL.ServiceDomain
			AND     WO.Reference       = WL.Reference
			AND     W.ServiceItem      = SI.Code
			AND     SI.Operational     = 1
			AND     W.CustomerId       = C.CustomerId
			AND     W.Mission          = '#url.mission#'
				
			<cfset today = dateformat(now(),client.dateSQL)>	
			
			<cfif url.orgunit neq "">
			
			    AND    WO.OrgUnit = '#url.orgunit#'
				
			<cfelseif url.workorderid neq "">
			
				AND     WO.WorkOrderId = '#url.workorderid#'	
				
				<cfif url.unit neq "">	
				
				AND     WO.WorkorderLine IN (	
						
									    SELECT   WB.WorkOrderLine 
										FROM     WorkOrderLineBilling WB INNER JOIN
										         WorkOrderLineBillingDetail WBD ON WB.WorkOrderId = WBD.WorkOrderId AND WB.WorkOrderLine = WBD.WorkOrderLine AND 
										         WB.BillingEffective = WBD.BillingEffective INNER JOIN
										         WorkOrderLine W ON WB.WorkOrderId = W.WorkOrderId AND WB.WorkOrderLine = W.WorkOrderLine
										WHERE    WB.WorkOrderId = '#url.workorderid#'
										AND      WBD.Operational = 1 
										AND      W.DateEffective < '#today#' 
										AND      (W.DateExpiration IS NULL OR W.DateExpiration >= '#today#') 
									    AND      WB.BillingEffective < '#today#'  
									    AND      (WB.BillingExpiration IS NULL OR WB.BillingExpiration >= '#today#')
										AND      WBD.ServiceItemUnit = '#url.unit#'
										
										)
																		
			   </cfif>		 
			
			<cfelseif url.domain neq "Person">
			
				AND     WO.Reference    = '#url.ref#'
				AND     W.ServiceItem IN (
				                           SELECT Code
				                           FROM   ServiceItem
										   WHERE  ServiceDomain = '#url.domain#'
										   )	
									   
				
			<cfelse>
			
				<!--- filter on the person but show only if access --->
			
				AND WO.PersonNo = '#url.ref#'
			
			    <cfif getAdministrator(url.mission) eq "1">
			
					<!--- no filtering --->
								
				<cfelse>
											
						AND (
								W.ServiceItem IN (
								                SELECT ClassParameter
								                FROM   Organization.dbo.OrganizationAuthorization
											    WHERE  UserAccount = '#SESSION.acc#'
											    AND    Role = 'WorkOrderProcessor'
											   )	
											   
								OR 		
								
								 <!--- is a requester for this service item --->
									
								 W.ServiceItem IN (
								                SELECT ClassParameter
								                FROM   Organization.dbo.OrganizationAuthorization
											    WHERE  UserAccount = '#SESSION.acc#'
												AND    Mission = '#param.treecustomer#'
											    AND    Role IN ('ServiceRequester','WorkOrderFunder')
											   )		   
							 )				    
									
				</cfif>
			
			</cfif>			
			
			<cfif url.filter eq "any">
				
				<!--- nada --->
				
			<cfelseif url.filter eq "enabled">
					
			    AND     WO.Operational = 1	
				
			<cfelseif url.filter eq "disabled">
					
			    AND     WO.Operational = 0	
			
			<cfelseif url.filter eq "active">
			
			    AND     WO.Operational = 1	
			 
				 <cfif allowconcurrent eq "0">
				 AND    (WO.DateExpiration >= '#today#' or WO.DateExpiration is NULL) 
				 AND     WO.DateEffective  <= '#today#'
				 </cfif>
			
			<cfelse>
			
			    AND     WO.Operational = 1		
		  	    <cfif allowconcurrent eq "0">
			    AND     (WO.DateExpiration < '#today#' OR  WO.DateEffective > '#today#')
			    </cfif>
			 
			</cfif> 
			
			) as D
			WHERE 1=1
			--condition
											
		</cfsavecontent>
		
		</cfoutput>

	<cfcatch>
			
		<script>
			Prosis.busy('no')
		</script>	
				
		<table width="100%" height="100%" align="center">
			<tr><td align="center" class="labelmedium">Please make your selection again</td></tr>
		</table>
		<cfabort>
		
	</cfcatch>

</cftry>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
			
<cfif url.ref neq "" or url.domain eq "Person">	
					
	<cfset itm = itm+1>	
	<cfset fields[itm] = {label     = "Service",                    
	     				field       = "Description",											
						alias       = "",																			
						search      = "text"}>								

</cfif>
			
<cfif qService.recordcount eq "0" and url.workorderid eq "">
			
	<cfset itm = itm+1>

	<cf_tl id="WorkOrder" var="vWorkOrder">
	<cfset fields[itm] = {label      = "#vWorkOrder#",                    
     				field            = "WorkOrderReference",																										
					search           = "text"}>		
					
					<!---
					functionscript   = "workorderview",
				    functionfield    = "workorderid",	
					--->
					
</cfif>					

<cfif url.filter neq "enabled">
	
	<cfif qService.recordcount gte "1" or url.domain eq "Person" or serviceitem.enableOrgUnit eq "1">
	
		<cfset itm = itm+1>	
		<cfset fields[itm] = {label     = "#ref#",                   		
							  field       = "Reference",					
							  alias       = "",									  											
							  search      = "text"}>					  					
							  
	</cfif>						  

</cfif>	

<cfif qService.recordcount eq "0">

	<cfset itm = itm+1>
	
	<cf_tl id="Action Center" var="vDescription">
	
	<cfset fields[itm] =
	                 {label            = "#vDescription#",                    
			     	  field            = "ReferenceName",																			
					  functionscript   = "workorderview",
					  functionfield    = "workorderid",	
					  fieldsort        = "Description",	
					  filtermode       = "2",																	
					  searchfield      = "Description",
					  search           = "text"}>									
					
</cfif>				

<cfset itm = itm+1>	
<cf_tl id="Service" var="vServiceClass">
<cfset fields[itm]   = 
                     {label            = "#vServiceClass#",                    
     				  field            = "ServiceDomainClass",											
					  alias            = "",			
					  filtermode       = "2",																
					  search           = "text"}>		
									
<cfif serviceitem.enableOrgUnit eq "1">
		
	<cfset itm = itm+1>				
	<cf_tl id="OrgUnit" var="vOrgUnit">
	<cfset fields[itm] = 
	                 {label            = "#vOrgUnit#",
					  field            = "OrgUnitName", 	
					  filtermode       = "2",																					
					  search           = "text"}>	
				
<cfelse>

	<cfset itm = itm+1>
	<cf_tl id="Customer" var="vCustomer">
	<cfset fields[itm] = {label     = "#vCustomer#",                    
     				field       = "CustomerName",											
					alias       = "",		
					filtermode  = "2",																		
					search      = "text"}>					
					
</cfif>								
											
<cfset itm = itm+1>
<cf_tl id="Line" var="vLine">
<cfset fields[itm] = {label     = "#vLine#", 
     				field       = "WorkOrderLine",
					display     = "false"}>			
					
<cfset itm = itm+1>					
<cf_tl id="Effective" var="vEffective">
<cfset fields[itm] = {label     = "#vEffective#",
					field       = "DateEffective", 		
					column      = "month",
					formatted   = "dateformat(dateeffective,CLIENT.DateFormatShow)",		
					align       = "left",		
					search      = "date"}>						

<cfset itm = itm+1>		
<cf_tl id="Expiration" var="vExpiration">
<cfset fields[itm] = {label     = "#vExpiration#", 					
					field       = "DateExpiration",	
					align       = "left",		
					formatted   = "dateformat(dateexpiration,CLIENT.DateFormatShow)",					
					search      = "date"}>											
												
<cfif url.domain neq "Person">																
					
	<cfif serviceitem.enablePerson eq "1">	
						
		<cfset itm = itm+1>				
		<cf_tl id="Responsible" var="vResponsible">
		<cfset fields[itm] = {label  = "#vResponsible#",                    
					field       = "Name", 	
					width       = "40",					
					search      = "text"}>			
	
	</cfif>
	
	<cfloop query="TopicList" startrow="1" endrow="3">
	
		<cfset itm = itm + 1>
		
		<cfset fld = replace(description," ","","ALL")>
		<cfset fld = replace(fld,".","","ALL")>
		<cfset fld = replace(fld,",","","ALL")>
		
		<cfset fields[itm] = {label  = "#Description#",                    
				field       = "#fld#", 						
				search      = "text"}>		
	
	</cfloop>

</cfif>
	
<cfif qService.recordcount gte "1">
						
	<cfset itm = itm+1>		
	<cf_tl id="Review" var="vReview">
	<cfset fields[itm] = {label     = "#vReview#",
						field       = "LastClosed",	
						align       = "left",		
						formatted   = "dateformat(LastClosed,CLIENT.DateFormatShow)",					
						search      = "date"}>	
						
	<cfset itm = itm+1>		
	<cf_tl id="Provisioning" var="vProvisioning">
	<cfset fields[itm] = {label     = "#vProvisioning#", 					
						field       = "BillingExpiration",	
						align       = "left",		
						formatted   = "dateformat(billingexpiration,CLIENT.DateFormatShow)",					
						search      = "date"}>									
					
	<cfset itm = itm + 1>	
	<cf_tl id="YTD #year(now())#" var="vYTD">
	<cfset fields[itm] = {label    = "#vYTD#",	
						field      = "Amount",					
						align      = "right",
						aggregate  = "sum",
						formatted  = "numberformat(amount,',.__')",
						alias      = ""}>		
						
<cfelse>

	<cfset itm = itm + 1>	
	<cf_tl id="Amount" var="Amount">
	<cfset fields[itm] = {label    = "#Amount#",	
						field      = "Amount",					
						align      = "right",
						aggregate  = "sum",
						formatted  = "numberformat(amount,',.__')",
						alias      = ""}>		

</cfif>		

<cfset itm = itm+1>		
<cfset fields[itm] = {label     = "#vExpiration#", 					
					field       = "Created",	
					fieldentry  = "1",		
					display     = "No",					
					align       = "left",		
					formatted   = "dateformat(dateexpiration,CLIENT.DateFormatShow)"}>								

<cfset menu=ArrayNew(1)>	

<cfif url.workorderid neq "" and url.unit eq "">
		
	<cfif filter eq "active">
		
		<!--- define access --->
		<cfinvoke component = "Service.Access"  
		   method           = "WorkorderProcessor" 
		   mission          = "#url.mission#"	  
		   serviceitem      = "#serviceitem.code#"
		   returnvariable   = "access">	
					
		<cfif (access eq "EDIT" or access eq "ALL") and workorder.actionstatus lte "1">		
		
				<cf_tl id="Add Line" var="vAdd">
				
				<cfset menu[1] = {label = "#vAdd#", icon = "insert.gif",	script = "lineadd('#url.workorderid#','0')"}>				 
				
		</cfif>						
	
	</cfif>

</cfif>
	
<!--- embed|window|dialogajax|dialog|standard --->

<cf_listing
	    header            = "servicedetails"
	    box               = "linedetail#url.filter#"
		link              = "#SESSION.root#/WorkOrder/Application/Workorder/ServiceDetails/ServiceLineListingContent.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&filter=#url.filter#&workorderid=#url.workorderid#&ref=#url.ref#&domain=#url.domain#"
	    html              = "No"						
		datasource        = "AppsWorkOrder"		
		listquery         = "#myquery#"		
		listgroup         = "Description"
		listorderfield    = "Reference"
		listorderalias    = "WO"		
		listorderdir      = "ASC"
		headercolor       = "ffffff"
		show              = "50"		
		menu              = "#menu#"
		filtershow        = "Hide"
		excelshow         = "Yes" 	
		screentop         = "No"	
		listlayout        = "#fields#"
		drillmode         = "tab" 
		drillargument     = "920;1220;true;true"	
		drilltemplate     = "WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm?drillid="
		drillkey          = "WorkOrderLineId"
		drillbox          = "workorderlines">	
	
<script>
	Prosis.busy('no')
</script>	