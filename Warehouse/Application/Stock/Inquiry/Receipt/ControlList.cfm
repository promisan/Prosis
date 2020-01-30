<!--- listing of receipts will drill down to receipt dialog --->

 <cf_LanguageInput
			TableCode       = "Ref_ModuleControl" 
			Mode            = "get"
			Name            = "FunctionName"
			Key1Value       = "#url.SystemFunctionId#"
			Key2Value       = "#url.mission#"				
			Label           = "Yes">			
			
<cfparam name="lt_content" default="Stock Transactions">

<table width="100%" height="100%">

        <!---
		
		<tr><td height="50">
		
		<table width="100%">

		<tr>
			<td style="z-index:5; position:absolute; top:5px; left:17px; ">
				<cfoutput><img src="#SESSION.root#/images/logos/warehouse/Monitor.png" height="42"></cfoutput>
			</td>
		</tr>							
		<tr>
			<td style="z-index:3; position:absolute; top:7px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
				<cfoutput>#lt_content#</cfoutput>
			</td>
		</tr>
		<tr>
			<td style="position:absolute; top:4px; left:90px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
				<cfoutput>#lt_content#</cfoutput>
			</td>
		</tr>			
		
		<cf_LanguageInput
			TableCode       = "Ref_ModuleControl" 
			Mode            = "get"
			Name            = "FunctionMemo"
			Key1Value       = "#url.SystemFunctionId#"
			Key2Value       = "#url.mission#"				
			Label           = "Yes">
					
		<tr>
			<td style="position:absolute; top:35px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
				<cfoutput>#lt_content#</cfoutput>
			</td>
		</tr>					

		</table>
		
		</td></tr>
		
		--->
		

<!--- control list data content --->

<cfquery name="Param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.Mission#'	
</cfquery>

<cfsavecontent variable="myquery">

	<cfoutput>	   
		
	SELECT     WL.Description, 
	           T.Location, 
			   R.DeliveryDate, 
			   T.TransactionDate, 
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
               WarehouseLocation WL ON T.Warehouse = WL.Warehouse AND T.Location = WL.Location
	WHERE     (T.Warehouse = '#url.warehouse#')
		
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>	
	<cf_tl id="Location" var = "1">		
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "Description",																	
						alias       = "WL",																			
						search      = "text",
						filtermode  = "2"}>				
	
	
						
	<cfset itm = itm+1>
	<cf_tl id="Delivery" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "DeliveryDate",					
						alias       = "",		
						align       = "center",		
						formatted   = "dateformat(DeliveryDate,CLIENT.DateFormatShow)",																	
						search      = "date"}>							
						
	<cfset itm = itm+1>
	<cf_tl id="ReceiptNo" var = "1">			
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "ReceiptNo",					
						alias       = "",																			
						search      = "text"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Stock Date" var = "1">				
	<cfset fields[itm] = {label     = "#lt_text#",                    
	     				field       = "TransactionDate",					
						alias       = "",		
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
						alias       = "",					
						formatted   = "numberformat(TransactionQuantity,'__,__')",														
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
							alias       = "",					
							formatted   = "numberformat(ReceiptAmount,'__,__.__')",														
							search      = ""}>	
						
	</cfif>																																		
																											
		
<cfset menu=ArrayNew(1)>	
	
<!--- embed|window|dialogajax|dialog|standard --->

<!--- prevent the method to see this as an embedded listing --->

   <tr>

   <td colspan="1" height="100%" valign="top">
		<cfdiv id="divListingContainer" style="height:100%" bind="url:../Inquiry/Receipt/ControlListContent.cfm?warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#">        	
	</td>	
	
   </tr>

</table>		
		