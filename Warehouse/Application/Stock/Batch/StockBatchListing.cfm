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
<cfparam name="URL.init"              default="1">
<cfparam name="URL.id"                default="0000">
<cfparam name="URL.mission"           default="">


<cfparam name="URL.Group"             default="TransactionDate">
<cfparam name="URL.page"              default="1">
<cfparam name="URL.status"            default="0">
<cfparam name="URL.Fnd"               default="">
<cfparam name="URL.TransactionType"   default="">

<cfoutput>
<input type="hidden" id="warehouseselected" value="#url.warehouse#">
</cfoutput>

<cfif url.status eq "9">
     <cfset suff = "Deny">
<cfelse>
     <cfset suff = "">  
</cfif>

<cfoutput>
<cfsavecontent variable="myquery">
	
	SELECT BatchNo, BatchReference,  TransactionType, Description, 	DeliveryMode, Category, LocationDescription, BatchDescription, TransactionDate, TransactionStatusDate,
      	   ActionStatus, ContraWarehouse, CustomerId,CustomerName, Quantity, Lines, Cleared, Amount, OfficerUserId, OfficerLastName, OfficerFirstName,
		   Created
	
	       , CASE WHEN Lines > Cleared THEN '0' ELSE '1' END as ProcessStatus
		  
	
	FROM (
	
		SELECT     B.BatchNo, 
		           B.BatchReference,
		           R.TransactionType, 
				   R.Description, 	
				   B.DeliveryMode,	
				   	
				   (SELECT  Description FROM Ref_Category WHERE Category = B.Category) as Category,   					   
				   (SELECT  Description FROM WarehouseLocation WHERE warehouse = '#URL.Warehouse#' AND Location = B.Location) as LocationDescription,	
				   
				   B.BatchDescription, 
				   
				   B.TransactionDate,
				   			   		   
				   (CASE WHEN B.ActionOfficerDate is NULL THEN B.TransactionDate ELSE B.ActionOfficerDate END) as TransactionStatusDate,
				  				   
				   B.ActionStatus,		
				   
				   (ISNULL((SELECT  TOP 1 TW.WarehouseName
				    FROM    ItemTransaction AS T WITH (NOLOCK) INNER JOIN Warehouse AS TW ON T.Warehouse = TW.Warehouse
				    WHERE   T.TransactionBatchNo = B.BatchNo AND T.Warehouse <> '#url.warehouse#'),'- Internal -')) as ContraWarehouse,
				   	   
				   B.CustomerId,
				   
				   (SELECT CustomerName FROM Customer WHERE CustomerId = B.CustomerId) as CustomerName,			   
				  
				   (SELECT  SUM(TransactionQuantity) FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo) as Quantity,			   			    
				   (SELECT  count(*)                 FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo) as Lines,	
				   (SELECT  count(*)                 FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo and ActionStatus='1') as Cleared,				  			   	   
				   (SELECT  SUM(TransactionValue)    FROM ItemTransaction#suff# WITH (NOLOCK) WHERE TransactionBatchNo = B.BatchNo) as Amount,
				 
	          	   B.OfficerUserId, 
				   B.OfficerLastName, 
	               B.OfficerFirstName,
				   B.Created
				   			   
	     FROM      WarehouseBatch B WITH (NOLOCK) INNER JOIN
	               Ref_TransactionType R ON B.TransactionType = R.TransactionType 
		 WHERE     (B.Warehouse     = '#URL.Warehouse#' OR B.BatchWarehouse = '#url.warehouse#')			
		 AND       B.ActionStatus  = '#URL.Status#' 
		
		 AND       B.BatchNo IN (SELECT TransactionBatchNo 
		                         FROM   ItemTransaction#suff# WITH (NOLOCK) 
								 WHERE  TransactionBatchNo = B.BatchNo)
						 
	 ) as B
	 
	 WHERE 1=1 	 
	 
	 --condition
	 
	 	
</cfsavecontent>
</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cf_tl id="BatchNo" var="vBatchNo">
<cfset fields[itm] = {label         = "#vBatchNo#", 
					  field         = "BatchNo",
				      searchfield   = "BatchNo",
					  filtermode    = "0",
					  search        = "text"}>		
					  
<cfset itm = itm+1>		
<cf_tl id="Class" var="vBatchClass">
<cfset fields[itm] = {label         = "#vBatchClass#", 
					  field         = "BatchDescription",
				      searchfield   = "BatchDescription",
					  filtermode    = "2",
					  search        = "text"}>		
					  
<cfset itm = itm+1>		
<cf_tl id="Destination Warehouse" var="vDestination">
<cfset fields[itm] = {label         = "#vDestination#", 
					  field         = "ContraWarehouse",
				      searchfield   = "ContraWarehouse",
					  filtermode    = "2",
					  search        = "text"}>							  					  	

<cfset itm = itm+1>		
<cf_tl id="Customer Name" var="vCustomer">
<cfset fields[itm] = {label         = "#vCustomer#", 
					  field         = "CustomerName",
					  searchfield	= "CustomerName",
  					  filtermode    = "0",
					  search		= "text"}>		
					  
<cfset itm = itm+1>		
<cf_tl id="Invoice" var="vInvoice">
<cfset fields[itm] = {label         = "#vInvoice#", 
					  field         = "BatchReference",
					  searchfield	= "BatchReference",
  					  filtermode    = "0",
					  search		= "text"}>							  
					  
<cfset itm = itm+1>		
<cf_tl id="Location" var="vLocation">
<cfset fields[itm] = {label         = "#vLocation#", 
					  field         = "LocationDescription",
					  searchfield	= "LocationDescription",
  					  filtermode    = "3",
					  search		= "text"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Del" var="vDelivery">
<cfset fields[itm] = {label         = "#vDelivery#", 
					  field         = "DeliveryMode",
					  searchfield	= "DeliveryMode",
  					  filtermode    = "2",
					  search		= "text"}>				  					  						  

<cfset itm = itm+1>		
<cf_tl id="Name" var="vFirst">
<cfset fields[itm] = {label         = "#vFirst#", 
					  field         = "OfficerFirstName",
				      searchfield   = "OfficerFirstName",
					  filtermode    = "2",
					  search        = "text"}>	
					  
<cfset itm = itm+1>		
<cf_tl id="Date" var="vDate">
<cfset fields[itm] = {label         = "#vDate#", 
					  field         = "TransactionDate",
				      searchfield   = "TransactionDate",
					  column        = "month",
					  align       	= "center",		
					  filtermode    = "0",
					  formatted     = "dateformat(TransactionDate,client.dateformatshow)",
					  search        = "date"}>	
					  
<cfset itm = itm+1>
<cf_tl id="Status Date" var = "1">				
<cfset fields[itm] = {label     	= "#lt_text#",                    
     				field       	= "TransactionStatusDate",					
					
					align       	= "center",		
					formatted   	= "dateformat(TransactionStatusDate,CLIENT.DateFormatShow)",																	
					search      	= "date"}>						  
					  
<cfset itm = itm+1>		
<cf_tl id="Time" var="vTime">
<cfset fields[itm] = {label         = "#vTime#", 
					  field         = "Created",
				      searchfield   = "Created",
					  filtermode    = "0",
					  formatted     = "timeformat(Created,'HH:MM')"}>	
					  
<cfset itm = itm+1>	
<cfset fields[itm] = {label         = "##", 
                      labelfilter   = "Lines",
					  field         = "Lines",
				      searchfield   = "Lines",
					  filtermode    = "0",
					  align         = "right",
					  formatted     = "numberformat(Lines,',_')",
					  search        = "number"}>	
					 
<cfset itm = itm+1>		
<cf_tl id="Clear" var="vClear">
<cfset fields[itm] = {label         = "CL", 
                      LabelFilter   = "Lines cleared",
					  field         = "Cleared",
				      searchfield   = "Cleared",
					  filtermode    = "0",
					  align         = "right",
					  formatted     = "numberformat(Cleared,',_')",
					  search        = "number"}>						  					  

<cfset itm = itm+1>			
<cf_tl id="Status" var="vStatus">			
<cfset fields[itm] = {label       = "S", 	
                    LabelFilter   = "#vStatus#",				
					field         = "ProcessStatus",					
					filtermode    = "3",    
					search        = "text",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green,9=Red"}>	
		
<cfif url.status eq "0">
	<cfset sl = "Yes">
<cfelse>
	<cfset sl = "Yes">
</cfif>			
				  
<cf_listing
    header         = "batch_#url.status#_#url.warehouse#"
    box            = "batch_#url.status#_#url.warehouse#"
	link           = "#session.root#/warehouse/application/stock/batch/stockbatchlisting.cfm?status=#url.status#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#"
    html           = "Yes"
	show           = "40"
	datasource     = "AppsMaterials"
	listquery      = "#myquery#"		
	navigation     = "auto"
	listorderalias = ""	
	listorder      = "BatchNo"
	listorderdir   = "DESC"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	filterShow     = "#sl#"
	excelShow      = "Yes"
	drillmode      = "tab"	
	drillstring    = "mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&mode=process"
	drilltemplate  = "warehouse/application/stock/batch/BatchView.cfm?batchno="
	drillkey       = "BatchNo">	

<!--- rework the refresh --->

<cfif url.status eq "0">

	<cf_securediv bind="url:#session.root#/warehouse/application/stock/batch/StockBatchlistingConnection.cfm?warehouse=#url.warehouse#">	
		   
</cfif>		   



