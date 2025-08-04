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
<cfquery name="WorkOrder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    WorkOrder
		 WHERE   WorkOrderId = '#url.workorderid#'	
</cfquery>

<cfquery name="ServiceItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    ServiceItem
		 WHERE   Code = '#workorder.serviceitem#'	
</cfquery>

<cfset FileNo = round(Rand()*100)>
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#WorkOrder" range="100">  

<cfquery name="Detail" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT 	P.PublicationId,
				P.WorkOrderId,
				P.PeriodEffective,
				P.PeriodExpiration,
				P.ActionStatus,
				CASE
					WHEN P.ActionStatus = '0' THEN 'Initiated'
					WHEN P.ActionStatus = '1' THEN 'Published'
					WHEN P.ActionStatus = '9' THEN 'Eliminated'
					ELSE ''
				END AS ActionStatusDescription,
				P.Description,
				P.OfficerUserId,
				(P.OfficerFirstName + ' ' + P.OfficerLastName) AS Officer,
				P.Created
		INTO    UserQuery.dbo.tmp#SESSION.acc#WorkOrder_#fileno#
		FROM   	Publication P
		WHERE	P.WorkOrderId = '#url.workOrderId#'
		AND		P.ActionStatus <> '9'
		
</cfquery>

<cfoutput>
	
	<cfsavecontent variable="myquery">
		SELECT 	*
		FROM	tmp#SESSION.acc#WorkOrder_#fileno#
	</cfsavecontent>

</cfoutput>

<cfset itm = 0>
<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>
<cf_tl id="Description" var="vDescription">
<cfset fields[itm] = {label     = "#vDescription#",                   		
					  field       = "Description",
					  search      = "text"}>

<cfset itm = itm+1>	
<cf_tl id="Effective" var="vEffective">
<cfset fields[itm] = {label     = "#vEffective#",                    
     				field       = "PeriodEffective",											
					formatted   = "dateformat(PeriodEffective,CLIENT.DateFormatShow)",		
					align       = "left",																
					search      = "date"}>	
					
<cfset itm = itm+1>	
<cf_tl id="Expiration" var="vExpiration">
<cfset fields[itm] = {label     = "#vExpiration#",                    
     				field       = "PeriodExpiration",											
					formatted   = "dateformat(PeriodExpiration,CLIENT.DateFormatShow)",		
					align       = "left",																
					search      = "date"}>	
					
<cfset itm = itm+1>
<cf_tl id="Status" var="vStatus">
<cfset fields[itm] = {label     = "#vStatus#",                   		
					  field       = "ActionStatusDescription",
					  filterMode  = "2",
					  search      = "text"}>
					  
<cfset itm = itm+1>
<cf_tl id="Officer" var="vOfficer">
<cfset fields[itm] = {label     = "#vOfficer#",                   		
					  field       = "Officer"}>
					  
<cfset itm = itm+1>
<cf_tl id="Created" var="vCreated">
<cfset fields[itm] = {label     = "#vCreated#",                   		
					  field       = "Created",
					  formatted   = "dateformat(Created,CLIENT.DateFormatShow)"}>



<cfset menu=ArrayNew(1)>

<cfif url.workorderid neq "">
		
	<!--- define access --->
	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderProcessor" 
	   mission          = "#workOrder.mission#"	  
	   serviceitem      = "#serviceitem.code#"
	   returnvariable   = "access">	
				
	<cfif (access eq "EDIT" or access eq "ALL") and workorder.actionstatus lte "1">		
	
			<cf_tl id="Add Line" var="vAdd">
			
			<cfset menu[1] = {label = "#vAdd#", icon = "insert.gif",	script = "addPublication('#url.workOrderId#')"}>				 
			
	</cfif>						

</cfif>

<!--- embed|window|dialogajax|dialog|standard --->

<cf_listing
	    header            = "servicedetails"
	    box               = "linesdetail"
		link              = "#SESSION.root#/WorkOrder/Application/Activity/Publication/PublicationListingContent.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#"
	    html              = "No"		
		classheader       = "labelit"
		classline         = "label"
		tableheight       = "99%"
		tablewidth        = "99%"
		datasource        = "AppsQuery"		
		listquery         = "#myquery#"
		listorderfield    = "PeriodEffective"
		listorderdir      = "ASC"
		headercolor       = "ffffff"
		show              = "35"		
		menu              = "#menu#"
		filtershow        = "Show"
		excelshow         = "Yes" 	
		screentop         = "No"	
		listlayout        = "#fields#"
		drillmode         = "window" 
		drillargument     = "800;1400;true;true"	
		drilltemplate     = "WorkOrder/Application/Activity/Publication/PublicationView.cfm?systemfunctionid=#url.systemfunctionid#&workOrderId=#url.workOrderId#&drillid="
		drillkey          = "PublicationId"
		drillbox          = "publicationLines">