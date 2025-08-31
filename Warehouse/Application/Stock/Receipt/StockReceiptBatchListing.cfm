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
<cfquery name="Warehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT 	*
		FROM 	Warehouse
		WHERE   Warehouse = '#url.warehouse#'		
</cfquery>


<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 
	   missionorgunitid  = "#warehouse.missionOrgUnitId#"	   
	   role              = "'WhsPick'"	   	   
	   Parameter         = "#url.systemfunctionid#"
	   accesslevel       = "2"	  
	   returnvariable    = "accessright">	

<cfoutput>
<cfsavecontent variable="myquery">
	
	SELECT     B.BatchNo, 
	           R.TransactionType, 
			   R.Description, 	
			   B.Warehouse,
			   W.WarehouseName,		   			   			   
			   B.BatchDescription, 
			   B.TransactionDate,  
			   B.ActionStatus,		
			   			    
			   (SELECT  count(*)              FROM ItemTransaction WHERE TransactionBatchNo = B.BatchNo) as Lines,
			   <cfif accessright eq "GRANTED">
			   (SELECT  SUM(TransactionValue) FROM ItemTransaction WHERE TransactionBatchNo = B.BatchNo) as Amount,
			   </cfif>
			 
          	   B.OfficerUserId, 
			   B.OfficerLastName, 
               B.OfficerFirstName,
			   B.Created
			   
     FROM      WarehouseBatch B INNER JOIN
               Ref_TransactionType R ON B.TransactionType = R.TransactionType INNER JOIN Warehouse W ON B.Warehouse = W.Warehouse
			   
	 WHERE     B.BatchWarehouse  = '#URL.Warehouse#'		
	 
	 <!--- this filters for cross warehouse but better to show pending receipt transfer batchs
	 AND       B.BatchWarehouse <> B.Warehouse	
	 --->

	 <!--- pending  --->
	 AND       B.ActionStatus    = '0'
	 
	  <!--- has records --->
	 AND       BatchNo IN (SELECT TransactionBatchNo 
	                       FROM   ItemTransaction 
						   WHERE  TransactionBatchNo = B.BatchNo 
						   AND    ReceiptId IN (SELECT ReceiptId FROM Purchase.dbo.PurchaseLineReceipt)) 

	 <!--- transfer --->
	 AND       B.TransactionType = '8'
	
		 	
</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>

	<cfset itm = 1>
	<cf_tl id="BatchNo" var="1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "BatchNo",											
						alias       = "B",																			
						search      = "text",
						filtermode  = "0"}>	
						
		
	<cfset itm = itm+1>
	<cf_tl id="Transaction" var="1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Description",						
						alias       = "R",		
						searchalias = "R",																																																
						search      = "text"}>		

	<cfset itm = itm+1>
	<cf_tl id="Memo" var="1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "BatchDescription",																	
						alias       = "B",																			
						search      = "text"}>				
							
	<cfset itm = itm+1>
	<cf_tl id="Destination" var="1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "WarehouseName",					
						alias       = "W",																			
						search      = "text",
						filtermode  = "2"}>	
						
	<cfset itm = itm+1>		
	<cf_tl id="Officer" var="1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "OfficerLastName",					
						alias       = "B",																			
						search      = "text",
						filtermode  = "2"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",					
						alias       = "",		
						align       = "center",		
						formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",																	
						search      = ""}>										
		
						
	<cfset itm = itm+1>
	<cf_tl id="Lines" var="1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Lines",																										
						formatted   = "numberformat(Lines,',__')"}>		

    <cfif accessright eq "GRANTED">
		 						
		<cfset itm = itm+1>
		<cf_tl id="Value" var="1">
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "Amount",											
							align       = "right",																			
							formatted   = "numberformat(Amount,',__')"}>	
						
	</cfif>
													
	<cfset itm = itm+1>
		
	<!--- hidden fields --->
	
	<cfset fields[itm] = {label     = "Id",                    
	     				field       = "BatchId",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>		
						
		

<cfset menu=ArrayNew(1)>	

	<cf_listing
	    header              = "itemlocationlist"
	    box                 = "listing"
		link                = "#SESSION.root#/Warehouse/Application/Stock/Receipt/StockReceiptBatchListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&warehouse=#url.warehouse#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"		
		listgroup           = "TransactionDate"		 
		listorder           = "BatchNo"
		listorderalias      = "B"
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "35"		
		menu                = "#menu#"
		filtershow          = "Hide"
		excelshow           = "Yes" 		
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Warehouse/Application/Stock/Batch/BatchView.cfm?mode=process&trigger=&batchno="
		drillkey            = "BatchNo">	
	