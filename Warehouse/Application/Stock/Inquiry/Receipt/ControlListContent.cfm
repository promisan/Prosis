
<!--- control list data content --->

<cfquery name="Param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'	
</cfquery>

<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 	  
	   anyUnit           = "No"
	   role              = "'WhsPick'"
	   parameter         = "#url.systemfunctionid#"
	   accesslevel       = "'0','1','2'"
	   returnvariable    = "globalmission">	
	   
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
	
		<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0" align="center">
			   <tr><td align="center" style="padding-top:70;" valign="top" class="labelmedium"><i>
			    <font color="FF0000">
				<cf_tl id="You have <b>NOT</b> been granted any access to this inquiry function" class="Message">
				</font>
				</td>
			   </tr>
		</table>	
		<cfabort>
	
	</cfif>		 
		   
</cfif>		   

<cfsavecontent variable="myquery">

	<cfoutput>	   
	
	SELECT * 
	  --,DeliveryDate
	  --,TransactionDate
	FROM (
		
	SELECT     WL.Description, 
	           W.WarehouseName,
	           T.Location, 
			   R.DeliveryDate, 
			   T.TransactionDate, 
			   T.ItemPrecision,
			   R.ReceiptNo, 
			   T.ItemDescription, 
			   U.UoMDescription, 
			   T.TransactionLot,
			   T.TransactionQuantity, 
			   R.DeliveryOfficer, 
               T.Remarks, 
			   R.Currency, 
			   R.ReceiptAmount, 
			   T.Warehouse
	FROM       ItemTransaction T INNER JOIN
               Purchase.dbo.PurchaseLineReceipt R ON T.ReceiptId = R.ReceiptId INNER JOIN
               ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM INNER JOIN
               WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location INNER JOIN
			   Warehouse W ON T.Warehouse = W.Warehouse			   
			   
	<cfif globalmission neq "granted">
	
	AND     W.MissionOrgUnitId IN
			
			           (					   
		                  SELECT DISTINCT MissionOrgUnitId 
		                  FROM   Organization.dbo.Organization
						  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
					   )	
		
	</cfif>
	
	WHERE   T.Warehouse = '#url.warehouse#'
	
	) as D
	WHERE 1=1
	--condition
	
	<!---
	WHERE   T.Mission = '#url.mission#'
	--->
			
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

    <!---
	<cfset itm = itm+1>		
	<cf_tl id="Facility" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "WarehouseName",																	
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>	
						
	--->					

	<cfset itm = itm+1>	
	<cf_tl id="Location" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Description",																	
						alias       = "WL",																			
						search      = "text",
						filtermode  = "2"}>				
	
	
	<!---					
	<cfset itm = itm+1>
	<cf_tl id="Delivery" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "DeliveryDate",					
						column      = "month",	
						align       = "center",		
						formatted   = "dateformat(DeliveryDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>		
						--->					
						
	<cfset itm = itm+1>
	<cf_tl id="ReceiptNo" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ReceiptNo",					
						alias       = "",																			
						search      = "text"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Date" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",					
						column      = "month",	
						align       = "center",		
						formatted   = "dateformat(TransactionDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Product" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ItemDescription",																	
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>				
							
	<cfset itm = itm+1>
	<cf_tl id="UoM" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "UoMDescription",					
						alias       = "",																			
						search      = "text",
						filtermode  = "2"}>			
    						
						
	<cfif Param.LotManagement eq "1">
	
		<cfset itm = itm+1>
		<cf_tl id="Lot" var = "1">			
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "TransactionLot",					
							alias       = "T",																			
							searchalias = "T",
							search      = "text",
							filtermode  = "2"}>		
	
	</cfif>									

	<cfset itm = itm+1>
	<cf_tl id="Quantity" var = "1">							
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionQuantity",	
						align       = "right",																			
						formatted   = "numberformat(TransactionQuantity,'[precision]')",							
						precision   = "ItemPrecision",													
						search      = ""}>								
	
	<!--- define access --->
	
	<cfinvoke component = "Service.Access"  
		   method           = "RoleAccess" 
		   Role             = "'WhsPick'"
		   Parameter        = "#url.systemfunctionid#"
		   Mission          = "#url.mission#"  	  
		   AccessLevel      = "2"
		   returnvariable   = "accesslevel">						
						
    <cfif AccessLevel eq "GRANTED">		
	
		<cfset itm = itm+1>
 		<cf_tl id="Currency" var = "1">											
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "Currency",					
							align       = "right",
							alias       = "",														
							search      = ""}>				
							
		<cfset itm = itm+1>
 		<cf_tl id="Amount" var = "1">											
		<cfset fields[itm] = {label     = "#lt_text#",                    
		     				field       = "ReceiptAmount",					
							align       = "right",
							aggregate   = "sum",											
							formatted   = "numberformat(ReceiptAmount,',.__')",														
							search      = ""}>	
						
	</cfif>																													
																											
		
<cfset menu=ArrayNew(1)>	

<cf_listing
	    header              = "transactionlist"
	    box                 = "receiptlist_#url.warehouse#"
		link                = "#SESSION.root#/Warehouse/Application/Stock/Inquiry/Receipt/ControlListContent.cfm?warehouse=#url.warehouse#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		font                = "Verdana"
		datasource          = "AppsMaterials"
		listquery           = "#myquery#"		
		listorderfield      = "DeliveryDate"
		listorder           = "DeliveryDate"
		listorderdir        = "DESC"
		headercolor         = "ffffff"		
		menu                = "#menu#"
		filtershow          = "Yes"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "Procurement/Application/Receipt/ReceiptEntry/ReceiptEdit.cfm?mode=receipt&id="
		drillkey            = "ReceiptNo"
		drillbox            = "addaddress">	