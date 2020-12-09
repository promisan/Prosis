

<!--- show the line of the batch transaction --->

<cfquery name="Batch"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatch B,
	         Ref_TransactionType R 
	WHERE    B.TransactionType = R.TransactionType
	AND      BatchNo           = '#URL.BatchNo#'
</cfquery>

<cfquery name="CheckContent"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     ItemTransaction I
	WHERE    TransactionBatchNo = '#URL.BatchNo#'
</cfquery>

<cfoutput>

<cfsavecontent variable="MyQuery">
	
	SELECT * 
	FROM (

	     SELECT  TOP 100  T.TransactionId, 
		           T.Mission, 
				   T.Warehouse as Facility, 
				   
				   ( SELECT  W.WarehouseName
		              FROM    Warehouse W
					  WHERE   W.Warehouse   = T.Warehouse 	              
					) as FacilityName,			
					
				   T.TransactionType, 
				     
				   
				   R.Description, 
				   R.TransactionClass,
				   T.TransactionDate, 
				   T.ItemNo, 
				   I.ItemBarCode,
				   M.ItemNoExternal,
				   T.ItemDescription, 
				   T.ItemCategory, 
				   T.BillingMode,
				   T.ItemPrecision,
	               T.Location, 			   
				   ( SELECT Description + ' ' +StorageCode
				     FROM   WarehouseLocation L 
					 WHERE  L.Warehouse = T.Warehouse AND L.Location = T.Location) as LocationDescription,	
					 
				    ( SELECT Reference 
				     FROM   Request R
					 WHERE  R.RequestId = T.RequestId) as RequestReference,		 
					
					<cfif Batch.transactiontype eq "2">
					T.TransactionQuantity*-1 as TransactionQuantity, 
					<cfelse>
					T.TransactionQuantity, 
					</cfif> 
				   
				   T.TransactionUoM, 
				   I.UOMDescription, 
				   T.TransactionUoMMultiplier, 
				   T.TransactionQuantityBase, 
				   T.TransactionCostPrice, 
	               T.TransactionValue, 
				   T.TransactionBatchNo, 
				   T.TransactionReference,
				   B.BillingStatus,
				   <!---  T.AssetId, --->
				   <!---  T.ReceiptId, --->
				   T.PersonNo, 
				 				 
					( SELECT  S.SupplyCapacity
		              FROM    Materials.dbo.AssetItemSupply S
					  WHERE   S.AssetId       = T.AssetId 
	                  AND     S.SupplyItemNo  = T.ItemNo 
	 			      AND     S.SupplyItemUoM = T.TransactionUoM
					) as Capacity,										 
							  			   
				   ( SELECT P.ReceiptNo 
				     FROM   Purchase.dbo.PurchaseLineReceipt P WHERE T.ReceiptId = P.ReceiptId
				   ) as ReceiptNo,	
				 				   		 
				   <!--- T.RequestId, --->
				   <!--- T.OrgUnit,  --->
				   T.OrgUnitCode, 
				   T.OrgUnitName, 
				   T.Remarks, 
				   T.ActionStatus,
				   A.AssetBarCode,
				   A.AssetDecalNo,
				   A.SerialNo    as AssetSerialNo,
				   A.Model       as AssetModel,
				   A.Description as AssetDescription,
				   A.Make        as AssetMake,		
				   AI.Category   as AssetCategory,
				   
				   (SELECT  TOP 1 AAM.MetricValue
				    FROM    AssetItemAction AI INNER JOIN
                            AssetItemActionMetric AAM ON AI.AssetActionId = AAM.AssetActionId
				    WHERE TransactionId = T.TransactionId) as AssetMetric,
				   				   
				   P.IndexNo as PersonIndexNo,
				   P.Reference as PersonReference,
				   P.LastName as PersonLastName,
				   P.FirstName as PersonFirstName,	   				
				   T.Created
				   
		FROM      <cfif batch.actionStatus neq "9">ItemTransaction<cfelse>ItemTransactionDeny</cfif> T INNER JOIN
	               Ref_TransactionType R ON T.TransactionType = R.TransactionType 
				   INNER JOIN Item M ON M.ItemNo = T.ItemNo
				   INNER JOIN ItemUoM I ON T.ItemNo = I.ItemNo AND T.TransactionUoM = I.UoM 
				   INNER JOIN WarehouseBatch B ON B.BatchNo = T.TransactionBatchNo 
				   LEFT OUTER JOIN AssetItem A ON T.AssetId = A.AssetId
				   LEFT OUTER JOIN Item AI ON A.ItemNo = AI.ItemNo
				   LEFT OUTER JOIN Employee.dbo.Person P ON T.PersonNo = P.PersonNo
				   
  		
		WHERE      T.TransactionBatchNo  = '#URL.BatchNo#'  	
		
		) as EmbeddedTable WHERE 1=1		
					   
</cfsavecontent>	

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>
		
	<cf_tl id="Product" var = "1">		
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "ItemDescription",																	
						alias       	= "",																			
						search      	= "text",
						filtermode  	= "2"}>		
	
	<cfset itm = itm+1>					
	<cf_tl id="ItemNo" var = "1">		
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "ItemNoExternal",																	
						alias       	= "",																			
						search      	= "text"}>			
						
	<cfset itm = itm+1>
	<cf_tl id="Voucher" var = "1">				
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "TransactionReference",					
						alias       	= "",		
						align       	= "center",																											
						search      	= "text"}>		
											
	<cfset itm = itm+1>
	<cf_tl id="Reference" var = "1">				
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "RequestReference",					
						alias       	= "",		
						align       	= "center",		
						functionscript  = "openreference",																						
						search      	= "text"}>												

	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">				
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "TransactionDate",					
						alias       	= "",		
						align       	= "center",		
						formatted   	= "dateformat(TransactionDate,CLIENT.DateFormatShow)",																	
						search      	= ""}>										
							

<cfif checkcontent.assetid neq "">
				
	<cfset itm = itm+1>
	<cf_tl id="Make" var = "1">			
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "AssetMake",					
						alias       	= "",																			
						search      	= "text",
						filtermode  	= "2"}>			
						
	<cfset itm = itm+1>
	<cf_tl id="Barcode" var = "1">			
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "AssetBarcode",					
						alias       	= "",																			
						search      	= "text"}>						
						
</cfif>

<!---						
	<cfset itm = itm+1>
	<cf_tl id="Facilty" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "FacilityName",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>			
						
						--->				
						
	
						
					
	<!---					
	<cfset itm = itm+1>
	<cf_tl id="Time" var = "1">					
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",					
						alias       = "",		
						align       = "center",		
						formatted   = "timeformat(TransactionDate,'HH:MM')",																	
						search      = ""}>	
						--->												
	
	
						
	<cfset itm = itm+1>
	<cf_tl id="Category" var = "1">				
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "AssetCategory",					
						alias       	= "",								
						filtermode  	= "2",																												
						search      	= ""}>		
						
	<cfset itm = itm+1>
	<cf_tl id="UoM" var = "1">			
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "UoMDescription",					
						alias       	= "",																									
						search      	= "text",
						filtermode  	= "2"}>																			

	<cfset itm = itm+1>
	<cf_tl id="Quantity" var = "1">							
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "TransactionQuantity",	
						align       	= "right",				
						alias       	= "",					
						formatted   	= "numberformat(TransactionQuantity,',__')",														
						search      	= ""}>								
	
	<!--- define access 
	
	<cfinvoke component = "Service.Access"  
		   method           = "RoleAccess" 
		   Role             = "'WhsPick'"
		   Parameter        = "#url.systemfunctionid#"
		   Mission          = "#Batch.mission#"  	  
		   AccessLevel      = "2"
		   returnvariable   = "accesslevel">						
						
    <cfif AccessLevel eq "GRANTED">					
						
		<cfset itm = itm+1>
		<cf_tl id="Price" var = "1">									
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "TransactionCostPrice",					
							align       = "right",
							alias       = "",					
							formatted   = "numberFormat(TransactionCostPrice,'__,_.__')",														
							search      = ""}>		
							
		<cfset itm = itm+1>
 		<cf_tl id="Amount" var = "1">											
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "TransactionValue",					
							align       = "right",
							alias       = "",					
							formatted   = "numberformat(TransactionValue*-1,'__,__.__')",														
							search      = ""}>	
						
	</cfif>		
	
	--->																																
	
	<cfset itm = itm+1>				
	
	<!--- hidden fields --->
	<cf_tl id="Id" var = "1">												
	<cfset fields[itm] = {label     	= "#lt_text#",                    
	     				field       	= "TransactionId",					
						display     	= "No",
						alias       	= "",																			
						search      	= "text"}>																																
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->

<!--- prevent the method to see this as an embedded listing --->

<cf_tl id="Return" var="vReturn">	
<cf_tl id="Extended listing" var="vList">
	
<cfset menu[1] = {label = "#vReturn# #vList#", script = "Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('BatchViewTransactionLines.cfm?mode=process&systemfunctionid=#url.systemfunctionid#&batchno=#url.batchno#','main')"}>				 
	
<cf_listing
	    header              = "transactionlist"
	    box                 = "batch"
		link                = "#SESSION.root#/Warehouse/Application/Stock/Batch/BatchViewTransactionListing.cfm?batchno=#url.batchno#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "99%"		
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"		
		listorderfield      = "TransactionDate"
		listorder           = "TransactionDate"
		listorderdir        = "ASC"
		show                = "200"	
		headercolor         = "ffffff"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 				
		listlayout          = "#fields#"
		drillmode           = "window" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Warehouse/Application/Stock/Inquiry/TransactionView.cfm?accessmode=process&systemfunctionid=#url.systemfunctionid#&drillid="
		drillkey            = "TransactionId"
		drillbox            = "addaddress">	
		


