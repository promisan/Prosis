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

		SELECT   T.Reference,
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
		WHERE    WorkOrderId   = '#URL.WorkorderId#' 
		AND      WorkOrderLine = '#URL.WorkorderLine#'
		AND      Source = 'Manual' 
	
</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

					
<cfset itm = itm+1>					
					
<cfset fields[itm] = {label     = "Date",                    
					field       = "TransactionDate", 		
					formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>	
		
<cfset itm = itm+1>

<cfset fields[itm] = {label     = "Reference",                   		
					field       = "Reference",					
					alias       = "",														
					search      = "text"}>							

<cfset itm = itm+1>

<cfset fields[itm] = {label       = "Description",                   		
					  field       = "DetailReference",					
					  alias       = "",														
					  search      = "text"}>					
						
<cfset itm = itm+1>					
					
<cfset fields[itm] = {label     = "Officer",                    
					field       = "OfficerlastName", 	
					alias       = "T.",				
					search      = "text"}>		
		
<cfset itm = itm + 1>										
					
<cfset fields[itm] = {label    = "Quantity", 					
					field      = "Quantity",		
					align      = "right",	
					formatted  = "numberformat(Quantity,'__,__')",													
					search     = "text"}>	
					

<cfset itm = itm + 1>										
					
<cfset fields[itm] = {label    = "Curr", 					
					field      = "Curr",	
					align      = "right",																	
					search     = "text"}>													
	
<cfset itm = itm + 1>										
					
<cfset fields[itm] = {label    = "Price", 					
					field      = "Rate",	
					align      = "right",		
					formatted  = "numberformat(Rate,'__,__.__')",													
					search     = "text"}>						
					
<cfset itm = itm + 1>										
					
<cfset fields[itm] = {label    = "Amount", 					
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
													
		<cfset menu[1] = {label  = "Add Transaction", 
		                  icon   = "insert.gif", 
						  script = "addusage('#workorder.mission#','#url.workorderid#','#url.workorderline#')"}>				 
						  
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
		drillmode      = "" 
		drillargument  = "630;580;true;true"			
		drillkey       = ""
		drillbox       = "addworkorder">	
		