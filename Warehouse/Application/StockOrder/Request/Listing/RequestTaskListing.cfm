
<cfparam name="url.script"        default="0">
<cfparam name="url.status"        default="0">
<cfparam name="url.source"        default="0">
<cfparam name="url.category"      default="0">
<cfparam name="url.requesttype"   default="">

<cfif url.script eq "1">
    <cfajaximport>
    <cf_listingscript>
	<cf_dialogWorkorder>	
</cfif>

<!--- limit access if the role of ServiceRequester and limit access if role is WorkOrderProcessor --->

<cfoutput>

<cfquery name="param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Ref_ParameterMission
	   WHERE     Mission = '#url.mission#'  
</cfquery>
		
<cfset diff = (100+param.taskorderdifference)/100>  

<cfsavecontent variable="myquery">	

	 SELECT     RH.RequestHeaderId,
	            RH.DateDue, 
	            R.Reference, 
				RT.RequestId, 
				RT.TaskSerialNo, 
				<cfif url.source eq "Procurement">
				(SELECT P.PurchaseNo 
				 FROM   Purchase.dbo.PurchaseLine L, Purchase.dbo.Purchase P 
				 WHERE  P.PurchaseNo = L.PurchaseNo 
				 AND    L.RequisitionNo = RT.SourceRequisitionNo) as PurchaseNo,
				</cfif>				
				RT.TaskId, 
				RT.TaskType, 
				RT.TaskQuantity, 
				
				 <cfif url.taskstatus eq "O">	
				 
				  <!--- nada --->
				
				 <cfelseif url.taskstatus eq "P">
				
					(
						       SELECT ISNULL(SUM(TransactionQuantity),0)
		                             FROM    ItemTransaction S
					 			     WHERE   RequestId    = RT.RequestId									
									 AND     TaskSerialNo = RT.TaskSerialNo
									 
									 AND     ( TransactionId IN (SELECT TransactionId 
				                    					         FROM   ItemTransactionShipping
															     WHERE  TransactionId = S.TransactionId
															     AND    ActionStatus = 1) 	
															   
												OR ActionStatus = '1'			   
											 )				   							
									 AND     TransactionQuantity > 0													 
									 AND     ActionStatus != '9' 
									 
					) as Shipped,	
				
				<cfelse>
				
				    (SELECT ISNULL(SUM(TransactionQuantity),0)
	                FROM    ItemTransaction S
	 			    WHERE   RequestId    = RT.RequestId									
					AND     TaskSerialNo = RT.TaskSerialNo
					 
					AND     ( TransactionId IN (SELECT TransactionId 
	                   					         FROM   ItemTransactionShipping
											     WHERE  TransactionId = S.TransactionId
											     AND    ActionStatus = 0) 	
											   
								OR ActionStatus = '0'			   
							 )				   							
					AND     TransactionQuantity > 0													 
					AND     ActionStatus != '9') as Receipt,
				
				
				</cfif>			 
				
				
				Item.ItemNo, 
				Item.ItemDescription, 				
				RT.ShipToMode, 
				RT.ShipToWarehouse 				
				,S.WarehouseName
				,T.WarehouseName as WarehouseNameProvider
												
	  FROM      RequestTask RT INNER JOIN
                Request R ON RT.RequestId = R.RequestId INNER JOIN
                RequestHeader RH ON R.Mission = RH.Mission AND R.Reference = RH.Reference INNER JOIN
                Item ON R.ItemNo = Item.ItemNo 
				
				
				LEFT OUTER JOIN Warehouse S ON RT.ShipToWarehouse = S.Warehouse 
				LEFT OUTER JOIN Warehouse T ON RT.SourceWarehouse = T.Warehouse
				
				
	  WHERE     R.Warehouse = '#url.warehouse#'			
      AND       RT.RecordStatus <> '3' <!--- manually completed --->	 
	  
	  <cfif url.category neq "">
	  AND       Item.Category = '#url.category#' 
	  </cfif>
	
	  AND       R.Status = '2' <!--- requisition is pending --->
	  AND       RH.ActionStatus = '3' <!--- reached the task --->
	  
	  <cfif url.shiptomode neq "">
	  AND       RT.ShipToMode = '#url.shiptomode#'	  
	  </cfif>

      <cfif url.source eq "Procurement">
				
	  AND     (RT.SourceRequisitionNo IN (SELECT RequisitionNo FROM Purchase.dbo.RequisitionLine WHERE RequisitionNo = RT.SourceRequisitionNo) or RT.SourceRequisitionNo is not NULL	)
	 	  						
  	  <cfelseif url.source neq "">		  
	  
	  AND     RT.SourceWarehouse IN (SELECT Warehouse 
	                                 FROM   Warehouse W, Ref_WarehouseClass RC 
									 WHERE  W.WarehouseClass = RC.Code 
									 AND    W.Mission = '#url.mission#'
									 AND    RC.Description = '#url.source#')	
										  
	  </cfif>
	  	  
	  <cfif url.taskstatus eq "O">		
	 	  
	  AND     RT.StockOrderId IS NULL 
	  
	  <!--- request has no shipping records (somehow, as this is unlikely to happen) --->
	  AND     RT.RequestId NOT IN (SELECT RequestId
	                               FROM    ItemTransaction S
				 			       WHERE   RequestId    = RT.RequestId									
								   AND     TaskSerialNo = RT.TaskSerialNo								
								   AND     TransactionQuantity > 0													 
								   AND     ActionStatus != '9') 		
	  	  
	  <cfelseif url.taskstatus eq "P">	  
	  
	  <!--- Pending receipt --->
	  	 
	  AND     (
	          RT.StockOrderId IS NOT NULL 
	          OR 
			  RT.RequestId IN (SELECT RequestId
	                               FROM    ItemTransaction S
				 			       WHERE   RequestId    = RT.RequestId									
								   AND     TaskSerialNo = RT.TaskSerialNo								
								   AND     TransactionQuantity > 0													 
								   AND     ActionStatus != '9') 	
			  )					   
	   	 	  	 	 	  
	  AND     RT.TaskQuantity > (SELECT ISNULL(SUM(TransactionQuantity),0)*#diff#
	                             FROM    ItemTransaction S
				 			     WHERE   RequestId    = RT.RequestId									
								 AND     TaskSerialNo = RT.TaskSerialNo								
								 AND     TransactionQuantity > 0													 
								 AND     ActionStatus != '9')									  
	  
	  <cfelseif url.taskstatus eq "R">	  
	   	  
	  <!--- pending receipt confirmation --->	  	  
	  
	   AND     (SELECT ISNULL(SUM(TransactionQuantity),0)
                FROM    ItemTransaction S
 			    WHERE   RequestId    = RT.RequestId									
				AND     TaskSerialNo = RT.TaskSerialNo
				 
				AND     ( TransactionId IN (SELECT TransactionId 
                   					         FROM   ItemTransactionShipping
										     WHERE  TransactionId = S.TransactionId
										     AND    ActionStatus = 0) 	
										   
							OR ActionStatus = '0'			   
						 )				   							
				AND     TransactionQuantity > 0													 
				AND     ActionStatus != '9') > 0 
	  	  
	  </cfif>	  
	  					
</cfsavecontent>

</cfoutput>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

<cfset itm = itm + 1>						
<cfset fields[itm] = {label           = "Request", 					
					  field           = "Reference",	
					  alias           = "R",			
					  searchalias     = "R",													
					  search          = "text"}>		

<cfif url.source neq "Procurement">
					  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label           = "Type", 					
					  field           = "TaskType",	
					  filtermode      = "3",												
					  search          = "text"}>							  
					  
<cfelse>
				  
<cfset itm = itm + 1>						
<cfset fields[itm] = {label           	= "Purchase", 					
					  field           	= "PurchaseNo",	
					  functionscript    = "ProcPOEdit",
					  functionfield 	= "PurchaseNo",		
					  filtermode      	= "2",												
					  search          	= "text"}>		

</cfif>					  
	
<cfset itm = itm + 1>						
<cfset fields[itm] = {label           = "Mode", 					
					  field           = "ShipToMode",	
					  filtermode      = "3",												
					  search          = "text"}>		
					  				  
<cfset itm = itm+1>
<cfset fields[itm] = {label           = "Due",                   		
					  field           = "DateDue",		
					  align           = "center",			
					  alias           = "RH",	
					  formatted       = "dateformat(DateDue,CLIENT.DateFormatShow)",												
					  search          = "date"}>						  					  

				  
	
	<cfset itm = itm + 1>
	<cfset fields[itm] = {label           = "Provider",                    
	     				  field           = "WarehouseNameProvider",	
						  fieldsort       = "WarehouseName",		
						  alias           = "T",	
						  searchfield     = "WarehouseName",		
						  searchalias     = "T",	
						  filtermode      = "2",					
						  search          = "text"}>	
						  
						  <!--- fieldsort is used for apply the correct sorting of the value --->						  
						  
	<cfset itm = itm + 1>
	<cfset fields[itm] = {label           = "Facility",                    
	     				  field           = "WarehouseName",		
						  alias           = "S",	
						  searchfield     = "WarehouseName",		
						  searchalias     = "S",						 
						  filtermode      = "2",					
						  search          = "text"}>	
					  
				  						  					  	
					  
<cfset itm = itm+1>							
<cfset fields[itm] = {label           = "Product",                    
					  field           = "ItemDescription", 													
					  search          = ""}>	
					  
<cfif url.taskstatus eq "O">	

  <cfset itm = itm+1>							
  <cfset fields[itm] = {label         = "Tasked",                    
					  field           = "TaskQuantity", 
					  align           = "right",													
					  search          = "number"}>						  

<cfelseif url.taskstatus eq "P">

	<cfset itm = itm+1>							
	<cfset fields[itm] = {label       = "Tasked",                    
						  field       = "TaskQuantity", 
						  align       = "right",													
						  search      = "number"}>	
	
	<cfset itm = itm+1>							
	<cfset fields[itm] = {label       = "Shipped",                    
						  field       = "Shipped", 
						  align       = "right",													
						  search      = ""}>		
					  
<cfelse>

	<cfset itm = itm+1>							
	<cfset fields[itm] = {label       = "Receipt",                    
						  field       = "Receipt", 
						  align       = "right",													
						  search      = "number"}>	
						  
</cfif>					  					  									  					  				

<!---					
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Requester",                    
					  field       = "Contact", 													
					  search      = "text"}>	
					  
--->			
 				  				  				
<cfset itm = itm+1>
	
<cfset fields[itm] = {label          = "id",                    
	     			field            = "RequestHeaderId",	
					display          = "No", 																												
					search           = "text"}>	
										
<cfset menu=ArrayNew(1)>	
							
<cf_listing
	    header           = "requestlinelist"
	    box              = "requestlinelistdetail"
		link             = "#SESSION.root#/Warehouse/Application/StockOrder/Request/Listing/RequestTaskListing.cfm?mission=#url.mission#&warehouse=#url.warehouse#&status=#url.status#&taskstatus=#url.taskstatus#&systemfunctionid=#url.systemfunctionid#&shiptomode=#url.shiptomode#&source=#url.source#"
	    html             = "No"		
		tableheight      = "100%"
		tablewidth       = "98%"
		datasource       = "AppsMaterials"
		listquery        = "#myquery#"
		listorderfield   = "Reference"
		listorder        = "Reference"
		listorderalias   = "R"
		listorderdir     = "DESC"
		headercolor      = "ffffff"
		show             = "40"		
		menu             = "#menu#"
		filtershow       = "show"
		excelshow        = "Yes" 		
		listlayout       = "#fields#"
		drillmode        = "securewindow" 
		systemfunctionid = "#url.systemfunctionid#"
		annotation       = "whsRequest"
		drillargument    = "#client.height-160#;#client.width-100#;true;false"	
		drilltemplate    = "Warehouse/Application/StockOrder/Request/Create/Document.cfm?drillid="
		drillkey         = "RequestHeaderId"
		drillbox         = "addworkorder">	
	