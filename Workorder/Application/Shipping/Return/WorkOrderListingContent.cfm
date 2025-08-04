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
<cfparam name="url.mission"             default="">
<cfparam name="url.status"              default="all">
<cfparam name="url.transactionlot"      default="">
	
<cfoutput>

<cfsavecontent variable="myquery">

SELECT * 
FROM (

SELECT     W.WorkOrderId,
           C.CustomerName,
           C.City, 
		   W.Reference, 
		   W.ActionStatus, 
		   S.Description, 
		   W.OrderDate,
           (SELECT    MAX(DateExpiration)
            FROM      WorkOrderLine
            WHERE     WorkorderId = W.WorkorderId AND Operational = 1) AS DueDate, 
		    W.Created
FROM        WorkOrder W INNER JOIN
            Customer C ON W.CustomerId = C.CustomerId INNER JOIN
            ServiceItem S ON W.ServiceItem = S.Code
WHERE       W.Mission = '#URL.Mission#'
AND         W.ActionStatus IN ('0','1','2')

	<cfif url.transactionlot neq "">
	AND        W.WorkorderId IN 
	                        (SELECT WorkOrderId 
							 FROM   Materials.dbo.Itemtransaction 
							 WHERE  WorkOrderId = W.WorkOrderId 
					         AND    Mission     = '#url.mission#' 
							 AND    TransactionLot LIKE ('%#url.transactionlot#%'))
	
	</cfif>

<!--- original condition 

a.	 Show only workorders that issue / return lines that are NOT billed,

b.	 Hanno 18/1/2016 consideration show in principle all workorders 

c.   Hanno 23/3/2014 : technically we sould also filter to take only WorkOrderLine that are meant for sale !!

d.   Formally closed order are not shown 

--->

AND         WorkOrderId IN 

			( 
			SELECT DISTINCT T.WorkOrderId
			FROM   Materials.dbo.ItemTransaction T INNER JOIN
                   Materials.dbo.ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId
			WHERE  T.WorkOrderId     = W.workorderid
			AND    T.Mission         = '#URL.mission#'
			AND    RequirementId is NOT NULL
			 <!--- AND    T.ActionStatus    = '1'   shipment transaction was cleared in the batch --->	   
			AND    T.TransactionType IN ('2','3')   <!--- issuance, or shipping return ---> 
			AND    TS.InvoiceId IS NULL 					
		   				  
			UNION ALL
			
			SELECT DISTINCT T.WorkOrderId
			FROM   Materials.dbo.ItemTransaction T INNER JOIN
                   Materials.dbo.ItemTransactionShipping TS ON T.TransactionId = TS.TransactionId
			WHERE  T.WorkOrderId     = W.workorderid
			AND    T.Mission         = '#URL.mission#'
			AND    RequirementId is NOT NULL
			 <!--- AND    T.ActionStatus    = '1'   shipment transaction was cleared in the batch --->	   
			AND    T.TransactionType IN ('2','3')   <!--- issuance, or shipping return ---> 
			AND    NOT EXISTS (SELECT  'X'
			                    FROM    Accounting.dbo.TransactionLine TL
						        WHERE   TL.ReferenceId = TS.InvoiceId)			  

            )
			
) as D
WHERE 1=1
--condition			

</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm+1>				
<cf_tl id="Customer" var="vCustomer">
<cfset fields[itm] = {label      = "#vCustomer#",                    
    				field        = "CustomerName",	
					filtermode   = "2",					
					search       = "text"}>		
								
<cfset itm = itm+1>
<cf_tl id="Reference" var="vReference">
<cfset fields[itm] = {label     = "#vReference#",                    
    				field       = "Reference",	
					fieldsort    = "Reference",																		
					searchfield  = "Reference",
					searchalias  = "W",
					search       = "text"}>		

<cfset itm = itm+1>				
<cf_tl id="Description" var="vDescription">
<cfset fields[itm] = {label     = "#vDescription#",                    
    				field       = "Description",	
					fieldsort    = "Description",																		
					searchfield  = "Description"}>		
					
<cfset itm = itm+1>				
<cf_tl id="City" var="vCity">
<cfset fields[itm] = {label      = "#vCity#",                    
    				field        = "City",		
					filtermode   = "2",					
					search       = "text"}>		
					
<cfset itm = itm+1>				
<cf_tl id="Status" var="vStatus">
<cfset fields[itm] = {label      = "#vStatus#",                    
    				field        = "ActionStatus",	
					filtermode   = "2",	
					align        = "center",				
					search       = "text"}>									
					
<cfset itm = itm+1>					
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label     = "#vDate#",
					field       = "OrderDate", 		
					formatted   = "dateformat(OrderDate,CLIENT.DateFormatShow)",		
					align       = "center",		
					search      = "date"}>		
					
<cfset itm = itm+1>					
<cf_tl id="Due" var="vDue">
<cfset fields[itm] = {label     = "#vDue#",
					field       = "DueDate", 		
					formatted   = "dateformat(DueDate,CLIENT.DateFormatShow)",		
					align       = "center"}>																																	

<!--- hidden key field --->
<cfset itm = itm+1>				
<cf_tl id="WorkOrderId" var="vId">
<cfset fields[itm] = {label     = "#vId#",                    
    				field       = "WorkOrderId",	
					display     = "No",
					align       = "center"}>	
					

<!--- adding is currently done from the finishe product line --->

<!---
		
<cfif filter eq "active">
		
	<!--- define access as requisitioner --->
	
	<cfinvoke component = "Service.Access"  
		   method           = "WorkorderProcessor" 
		   mission          = "#mission#"	  		  
		   returnvariable   = "access">	
					
		<cfif access eq "EDIT" or access eq "ALL">		
		
				<cf_tl id="Add Requisition" var="vAdd">
				
				<cfset menu[1] = {label = "#vAdd#", icon = "insert.gif",	script = "requisitionadd('#mission#','#url.workorderid#','#url.workorderline#','')"}>				 
				
		</cfif>						
	
</cfif>						

--->

<cfset menu = "">
	
<!--- embed|window|dialogajax|dialog|standard --->
							
<cf_listing
	    header            = "return"
	    box               = "#url.mission#_return"
		link              = "#SESSION.root#/WorkOrder/Application/Shipping/Return/WorkOrderListingContent.cfm?systemfunctionid=#url.systemfunctionid#&Status=#url.status#&Mission=#URL.Mission#"
	    html              = "No"				
		tableheight       = "99%"
		tablewidth        = "99%"
		datasource        = "AppsWorkorder"		
		listquery         = "#myquery#"		
		listgroup         = "CustomerName"
		listorderfield    = "OrderDate"
		listorderalias    = "W"		
		listorderdir      = "ASC"
		headercolor       = "ffffff"
		show              = "35"				
		filtershow        = "Yes"
		excelshow         = "Yes" 	
		screentop         = "No"	
		listlayout        = "#fields#"
		drillmode         = "tab" 
		drillargument     = "950;1050;true;true"	
		drilltemplate     = "WorkOrder/Application/Shipping/Return/ReturnEntry.cfm?systemfunctionid=#url.systemfunctionid#&header=1&mode=listing&workorderid="
		drillkey          = "WorkorderId"
		drillbox          = "blank">	
