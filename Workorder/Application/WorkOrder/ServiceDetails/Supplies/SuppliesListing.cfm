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
<cfparam name="url.addScripts" default="0">

<cfif url.addScripts eq "1">
	<cf_screentop html="no" jquery="no">
	<cf_listingScript>
	<script>
		function addsupply(mis,wid,lid) {  	   
	 	   ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/Warehouse/Application/Stock/Transaction/TransactionInit.cfm?mode=workorder&mission="+mis+"&workorderid="+wid+"&workorderline="+lid,"workorder","left=20, top=20, width=960,height=800,status=yes, toolbar=no, scrollbars=yes, resizable=yes")	 	
		}
	</script>
</cfif>

<!--- show the matching lines --->

<cfparam name="url.workorderid"   default="">
<cfparam name="url.workorderline" default="">

<cfquery name="WorkOrder" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Wo.*, 
	         SI.Description AS ServiceItemDescription, 			
			 C.OrgUnit,
			 C.CustomerName AS CustomerName, 
             C.Reference AS CustomerReference, 
			 C.PhoneNumber AS CustomerPhoneNo
    FROM     WorkOrder Wo INNER JOIN
             ServiceItem SI ON Wo.ServiceItem = SI.Code INNER JOIN
             Customer C ON Wo.CustomerId = C.CustomerId	
	WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
</cfquery>	

<cfoutput>
	
	<cfsavecontent variable="myquery">
	
			SELECT   T.TransactionId, 
			         T.TransactionDate,
	                 T.ItemNo, 
	                 T.ItemDescription, 
	                 T.TransactionQuantityBase, 
	                 T.TransactionCostPrice,
	                 T.TransactionValue, 
					 T.TransactionUoM,
					 U.UOMDescription,
	                 T.Remarks, 
					 S.SalesPrice,
					 S.SalesAmount,
	                 T.Warehouse,
	                 T.OfficerUserid, 
					 T.OfficerLastName, 
					 T.OfficerFirstName
			FROM     ItemTransaction T, ItemTransactionShipping S, ItemUoM U
			WHERE    T.TransactionId = S.TransactionId
	        AND      WorkOrderId     = '#url.WorkorderId#' 
			AND      WorkOrderLine   = '#url.workorderline#' 
			AND      T.ItemNo = U.ItemNo
			AND      T.TransactionUoM = U.UoM
					
	</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
					
<cfset itm = itm+1>					
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label     = "#vDate#",                    
					field       = "TransactionDate", 		
					formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>	
					
<cfset itm = itm+1>
<cf_tl id="Warehouse" var="vWarehouse">
<cfset fields[itm] = {label     = "#vWarehouse#",
					field       = "Warehouse",					
					alias       = "",														
					search      = "text"}>					
		
<cfset itm = itm+1>
<cf_tl id="ItemNo" var="vItemNo">
<cfset fields[itm] = {label     = "#vItemNo#",                   		
					field       = "ItemNo",					
					alias       = "",														
					search      = "text"}>							

<cfset itm = itm+1>
<cf_tl id="Description" var="vDescription">
<cfset fields[itm] = {label       = "#vDescription#",
					  field       = "ItemDescription",					
					  alias       = "",														
					  search      = "text"}>	
					  
<cfset itm = itm+1>					
<cf_tl id="UoM" var="vUoM">
<cfset fields[itm] = {label     = "#vUoM#",                    
					field       = "UoMDescription", 								
					alias       = "",	
					search      = "text"}>							  				
	

<cfset itm = itm + 1>										
<cf_tl id="Quantity" var="vQuantity">
<cfset fields[itm] = {label    = "#vQuantity#",
					field      = "TransactionQuantityBase",		
					align      = "right",	
					formatted  = "numberformat(-TransactionQuantityBase,'__,__')",													
					search     = "text"}>						
	
<cfset itm = itm + 1>										
<cf_tl id="Price" var="vPrice">
<cfset fields[itm] = {label    = "#vPrice#", 					
					field      = "SalesPrice",	
					align      = "right",		
					formatted  = "numberformat(SalesPrice,'__,__.__')",													
					search     = "text"}>						
					
<cfset itm = itm + 1>										
<cf_tl id="Amount" var="vAmount">
<cfset fields[itm] = {label    = "#vAmount#", 					
					field      = "SalesAmount",	
					align      = "right",		
					formatted  = "numberformat(SalesAmount,'__,__.__')",					
					search     = "number"}>						

<!--- define access --->

<cfinvoke component = "Service.Access"  
		method          = "WorkorderProcessor" 
		mission         = "#workorder.mission#" 
		serviceitem     = "#workorder.serviceitem#"
		returnvariable  = "access">	    
					
	<cfif access eq "EDIT" or access eq "ALL">		
	
		<cf_tl id="Add Issued Supply" var="vAdd">
		<cfset menu[1] = {label  = "#vAdd#", 
		                  icon   = "insert.gif", 
						  script = "addsupply('#workorder.mission#','#url.workorderid#','#url.workorderline#')"}>				 
						  
		<cfset dt   = "ItemTransaction">
		<cfset dk   = "TransactionId">   				  
						  
	<cfelse>	
	
		<cfset menu = "">				
		<cfset dt   = "">
		<cfset dk   = "">			  
			
	</cfif>		
		
<cf_listing
	    header          = "supplieslist"
	    box             = "adhoc"
		link            = "#SESSION.root#/WorkOrder/Application/Workorder/ServiceDetails/Supplies/SuppliesListing.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#"
	    html            = "No"				
		datasource      = "AppsMaterials"
		listquery       = "#myquery#"
		listorderfield  = "TransactionDate"
		listorderalias  = ""
		listorder       = "TransactionDate"
		listorderdir    = "DESC"
		headercolor     = "ffffff"
		show            = "40"			
		menu            = "#menu#"			
		filtershow      = "Hide"
		excelshow       = "No" 		
		listlayout      = "#fields#"
		drillmode       = "" 
		drillargument   = "890;720;true;true"			
		drillkey        = "#dk#"
		deletetable     = "#dt#"
		drillbox        = "addworkorder">	
		
		
		
		
		