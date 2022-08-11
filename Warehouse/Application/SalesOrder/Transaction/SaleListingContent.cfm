
<cfinvoke component  = "Service.Access"  
   method            = "RoleAccess" 
   mission           = "#url.mission#" 	  
   anyUnit           = "No"
   role              = "'WhsPick'"
   parameter         = "#url.systemfunctionid#"
   accesslevel       = "'0','1','2'"
   returnvariable    = "globalmission">	
   
   <!--- create a temp table here for the user --->
  								   
	<cfif globalmission neq "Granted">	
	
		<!--- check access on the level of the mission --->
				
		<cfinvoke component  = "Service.Access"  
		   method            = "RoleAccessList" 
		   role              = "'WhsPick'"
		   mission           = "#url.mission#" 	  		  
		   parameter         = "#url.systemfunctionid#"
		   accesslevel       = "'0','1','2'"
		   returnvariable    = "accesslist">	
			   
		<cfif accessList.recordcount eq "0">			
			
			   <table>
			   <tr><td align="center" style="padding-top:70;" valign="top" class="labelmedium"><i>
			    <font color="FF0000">
				<cf_tl id="You have <b>NOT</b> been granted any access to this inquiry function" class="Message">
				</font>
				</td>
			   </tr>
			   </table>								 
						
		</cfif>		
		
	</cfif>	 
	
<cf_verifyOperational module = "WorkOrder" Warning   = "No">	
	
<cftry>

	<cfquery name="checkfile" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
	    SELECT TOP 1 * FROM #SESSION.acc#_SaleTransaction
	</cfquery>	
	
	<cfif checkfile.created neq "">
			
		<cfset diff  = datediff("n",checkfile.created,now())>
				
		<cfif diff lt "20">								
		   <cfset action = "same">		  
		<cfelse>		
		   <cfset action = "refresh">
		</cfif>
		
	<cfelse>
	
		<cfset action = "refresh">
				
	</cfif>	

	<cfcatch>

		<cfset action = "refresh">
	
	</cfcatch>

</cftry>


<cfif action eq "refresh">

	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_SaleTransaction"> 		
	
	<!--- get relevant data in memory --->
	    
	<cfquery name="getDataInMemory" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 

		<!--- store sales --->
			
		SELECT    P.WarehouseName,
		          WB.BatchNo, 
		          WB.Batchid,
		          C.CustomerName, 
				  C.Reference, 
				  WB.BatchClass,
				  WB.BatchDescription,
				  WB.ActionStatus,
				  T.ItemCategory, 
				  T.ItemNo, 
				  T.ItemDescription, 
				  T.TransactionUoM, 
				  T.TransactionDate, 
				  T.TransactionCostPrice,
				  - (1 * T.TransactionQuantity) AS Quantity, 
				  - (1 * T.TransactionValue) AS COGS, 
				  S.SalesPrice,
				  S.TaxPercentage,
				  S.TaxExemption,
				  S.SalesBaseAmount AS Sale, 
				  S.SalesBaseTax as SaleTax, 
				  S.SalesBaseTotal as SaleTotal,
				  S.SalesBaseAmount + T.TransactionValue AS GrossMargin,
				  
				  (SELECT   TOP (1) ActionReference1
                   FROM     Accounting.dbo.TransactionHeaderAction
                   WHERE    Journal = S.Journal 
				   AND      JournalSerialNo = S.JournalSerialNo 
				   AND      ActionCode = 'Invoice' 
				   AND      ActionStatus = '1'
                   ORDER BY Created DESC) AS Invoice,

				  
				  #now()# as Created
				  
				  
		INTO      userQuery.dbo.#SESSION.acc#_SaleTransaction		  
		
		FROM      ItemTransaction T INNER JOIN
	              ItemTransactionShipping S ON T.TransactionId = S.TransactionId INNER JOIN
	              WarehouseBatch WB ON T.TransactionBatchNo = WB.BatchNo INNER JOIN
	              Customer C ON WB.CustomerId = C.CustomerId INNER JOIN 
				  Warehouse P ON P.Warehouse = WB.Warehouse
	    WHERE     T.Mission        = '#url.mission#'
		AND       T.TransactionType IN ('2')
	   
		<cfif globalmission neq "granted">
			
			 AND       P.MissionOrgUnitId IN
					
					           (					   
				                  SELECT DISTINCT MissionOrgUnitId 
				                  FROM   Organization.dbo.Organization
								  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
							   )	
				
		</cfif>			
		
		<cfif operational eq "1">
		
		UNION ALL	
		
		<!--- workorder sales --->
		
		SELECT    P.WarehouseName,
		          WB.BatchNo, 
		          WB.Batchid,
		          C.CustomerName, 
				  C.Reference, 
				  WB.BatchClass,
				  WB.BatchDescription,
				  WB.ActionStatus,
				  T.ItemCategory, 
				  T.ItemNo, 
				  T.ItemDescription, 
				  T.TransactionUoM, 
				  T.TransactionDate, 
				  T.TransactionCostPrice,
				  - (1 * T.TransactionQuantity) AS Quantity, 
				  - (1 * T.TransactionValue) AS COGS, 
				  S.SalesPrice,
				  S.TaxPercentage,
				  S.TaxExemption,
				  S.SalesBaseAmount AS Sale, 
				  S.SalesBaseTax as SaleTax, 
				  S.SalesBaseTotal as SaleTotal,
				  S.SalesBaseAmount + T.TransactionValue AS GrossMargin,
				  
				  (SELECT   TOP (1) ActionReference1
                   FROM     Accounting.dbo.TransactionHeaderAction
                   WHERE    Journal         = S.Journal 
				   AND      JournalSerialNo = S.JournalSerialNo 
				   AND      ActionCode      = 'Invoice' 
				   AND      ActionStatus    = '1'
                   ORDER BY Created DESC) AS Invoice,
							  
				  #now()# as Created
				  
		FROM      ItemTransaction T INNER JOIN
	              ItemTransactionShipping S ON T.TransactionId = S.TransactionId INNER JOIN
	              WarehouseBatch WB ON T.TransactionBatchNo = WB.BatchNo INNER JOIN
				  WorkOrder.dbo.WorkOrder W ON T.WorkOrderId = W.WorkOrderId INNER JOIN			  
	              WorkOrder.dbo.Customer C ON W.CustomerId = C.CustomerId INNER JOIN 
				  Warehouse P ON P.Warehouse = WB.Warehouse
	    WHERE     T.Mission        = '#url.mission#'
		AND       T.TransactionType IN ('2','3')
	   
			<cfif globalmission neq "granted">
				
				 AND       P.MissionOrgUnitId IN
						
						           (					   
					                  SELECT DISTINCT MissionOrgUnitId 
					                  FROM   Organization.dbo.Organization
									  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
								   )	
					
			</cfif>
		
		</cfif>	
		
	</cfquery>
		
</cfif>
				
<cfsavecontent variable="myquery">

	<cfoutput>	 
	
	SELECT *
	FROM   userquery.dbo.#SESSION.acc#_SaleTransaction	
	WHERE  1=1
							  			
	</cfoutput>	
		
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
	
<cfset itm = itm+1>
	<cf_tl id="Facility" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "WarehouseName",																	
						filtermode  = "2",																		
						search      = "text"}>		

	<cfset itm = itm+1>
	<cf_tl id="SalesNo" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "BatchNo",																							
						search      = "text"}>		
						
	<cfset itm = itm+1>						
	<cfset fields[itm] = {label   = "St", 	
                    LabelFilter   = "Status",				
					field         = "ActionStatus",					
					filtermode    = "3",    
					search        = "",
					align         = "center",
					formatted     = "Rating",
					ratinglist    = "0=Yellow,1=Green"}>						
						
	<cfset itm = itm+1>
	<cf_tl id="Class" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "BatchClass",																							
						search      = "text",
						filtermode  = "2"}>						
						
	<cfset itm = itm+1>
	<cf_tl id="Customer" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "CustomerName",										
						search      = "text"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Reference" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Reference",																																	
						search      = "text"}>														

	<cfset itm = itm+1>
	<cf_tl id="ItemNo" var = "1">
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ItemNo",																															
						search      = "text",
						filtermode  = "2"}>		

	<cfset itm = itm+1>	
	
	<cf_tl id="Name" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ItemDescription",																																							
						search      = "text",
						filtermode  = "2"}>				
		
						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",											
						filterforce = "1",
						align       = "center",		
						formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>		
					

	<cfset itm = itm+1>
	<cf_tl id="Quantity" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Quantity",	
						align       = "right",				
						alias       = "",					
						formatted   = "numberformat(Quantity,'__,__')",														
						search      = ""}>								
	
			
						
	<cfset itm = itm+1>
	<cf_tl id="COGS" var = "1">									
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "COGS",					
						align       = "right",
						alias       = "",					
						formatted   = "numberFormat(COGS,'__,_.__')",														
						search      = ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Sale" var = "1">											
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Sale",					
						align       = "right",
						alias       = "",		
						aggregate   = "SUM",			
						formatted   = "numberformat(Sale,'__,__.__')",														
						search      = ""}>	
	
	<cfset itm = itm+1>				
	
	<!--- hidden fields --->
	<cf_tl id="Id" var = "1">												
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "BatchId",					
						display     = "No",
						alias       = "",																			
						search      = "text"}>	
						
		
																																			
		
<cfset menu=ArrayNew(1)>	
				
<cf_listing
	    header              = "salelist"		
	    box                 = "salelisting"
	    link                = "#SESSION.root#/Warehouse/Application/Salesorder/Transaction/SaleListingContent.cfm?warehouse=#url.warehouse#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "appsQuery"
		listquery           = "#myquery#"		
		listgroup           = "WarehouseName"
		listorderfield      = "TransactionDate"
		listorder           = "TransactionDate"		
		listorderdir        = "ASC"
		headercolor         = "ffffff"
		show                = "200"		<!--- better to let is be set in the preferences --->
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 		
		analysisModule      = "Warehouse"
		analysisReportName  = "Facttable: Sales Transactions"	
		analysisPath        = "Warehouse\Application\SalesOrder\Transaction\"
		analysisTemplate    = "FactTableSales.cfm"		
		queryString         = "warehouse=#url.warehouse#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Warehouse/Application/Stock/Batch/BatchView.cfm?trigger=salesinquiry&mode=process&systemfunctionid=#url.systemfunctionid#&batchno="
		drillkey            = "BatchNo"
		drillbox            = "addaddress">	
		