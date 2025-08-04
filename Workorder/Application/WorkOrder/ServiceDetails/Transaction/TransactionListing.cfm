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

<!--- workorderline --->

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
		         T.Reference,
		         T.DetailReference,
                 T.TransactionDate, 
                 T.Quantity, 
                 T.Currency, 
                 T.Rate,
                 T.Amount, 
                 T.Charged, 				
                 T.OfficerUserid, 
				 T.OfficerLastName, 
				 T.OfficerFirstName
		FROM     WorkorderLineDetail T
		WHERE    T.WorkOrderId   = '#URL.WorkorderId#' 
		AND      T.WorkOrderLine = '#URL.WorkorderLine#' 
		AND      T.Source = 'Manual'
	
</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
			
<cfset itm = itm+1>
<cf_tl id="Reference" var="vReference">
<cfset fields[itm] = {label     = "#vReference#",                   		
					field       = "Reference",					
					alias       = "",														
					search      = "text"}>							
					
				
<cfset itm = itm+1>					
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label     = "#vDate#",                    
					field       = "TransactionDate", 		
					formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>						

<cfset itm = itm+1>
<cf_tl id= "Description" var="vDescription">
<cfset fields[itm] = {label       = "#vDescription#",                   		
					  field       = "DetailReference",					
					  alias       = "",														
					  search      = "text"}>					
						
<cfset itm = itm+1>					
<cf_tl id="Officer" var="vOfficer">
<cfset fields[itm] = {label     = "#vOfficer#",                    
					field       = "OfficerlastName", 	
					alias       = "T.",				
					search      = "text"}>		
		
<cfset itm = itm + 1>										
<cf_tl id="Quantity" var="vQuantity">
<cfset fields[itm] = {label    = "#vQuantity#", 					
					field      = "Quantity",		
					align      = "right",	
					formatted  = "numberformat(Quantity,'__,__')",													
					search     = "text"}>	
					

<cfset itm = itm + 1>										
<cf_tl id="Cur" var="vCur">
<cfset fields[itm] = {label    = "#vCur#.", 					
					field      = "Currency",	
					align      = "right",																	
					search     = "text"}>													
	
<cfset itm = itm + 1>										
<cf_tl id="Price" var="vPrice">
<cfset fields[itm] = {label    = "#vPrice#", 					
					field      = "Rate",	
					align      = "right",		
					formatted  = "numberformat(Rate,'__,__.__')",													
					search     = "text"}>						
					
<cfset itm = itm + 1>										
<cf_tl id="Amount" var="vAmount">
<cfset fields[itm] = {label    = "#vAmount#", 					
					field      = "Amount",	
					align      = "right",		
					formatted  = "numberformat(Amount,'__,__.__')",					
					search     = "number"}>						
									
<!--- define access --->

<cfinvoke component = "Service.Access"  
	method          = "WorkorderProcessor" 
	mission         = "#workorder.mission#" 
	serviceitem     = "#workorder.serviceitem#"
	returnvariable  = "access">		   
					
<cfif access eq "EDIT" or access eq "ALL">		

	<cf_tl id="Add Transaction" var="vAddTransaction">
	<cfset menu[1] = {label  = "#vAddTransaction#", 
	                  icon   = "insert.gif", 
					  script = "addtransaction('#workorder.mission#','#url.workorderid#','#url.workorderline#')"}>				 
					  
<cfelse>	

	<cfset menu = "">					  
		
</cfif>				
							
<cf_listing
	    header         = "supplieslist"
	    box            = "adhoc"
		link           = "#SESSION.root#/WorkOrder/Application/Workorder/ServiceDetails/Transaction/TransactionListing.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#"
	    html           = "No"		
		tableheight    = "100%"
		tablewidth     = "100%"
		datasource     = "AppsWorkOrder"
		listquery      = "#myquery#"
		listorderfield = "TransactionDate"
		listorderalias = ""
		listorder      = "TransactionDate"
		listorderdir   = "DESC"
		headercolor    = "ffffff"
		show           = "40"			
		menu           = "#menu#"			
		filtershow     = "Hide"
		excelshow      = "Yes" 		
		listlayout     = "#fields#"
		drilltemplate  = "WorkOrder/Application/WorkOrder/ServiceDetails/Transaction/Document.cfm"
		drillmode      = "dialogajax" 
		drillargument  = "550;590;true;true"			
		drillkey       = "transactionid"
		drillbox       = "drilldetail">	
		