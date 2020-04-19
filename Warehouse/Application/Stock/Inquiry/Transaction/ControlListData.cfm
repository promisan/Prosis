

<cfparam name="url.mde"     default="1">
<cfparam name="URL.page"    default="1">
<cfparam name="client.view" default="location">
<cfparam name="URL.view"    default="#client.view#">
<cfset client.view = url.view>
<cfparam name="URL.sort"   default="B.ItemDescription">

<!--- filter values from ControlListLocate.cfm --->
   
<cfquery name="System"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ModuleControl
		WHERE  SystemFunctionId = '#url.systemfunctionid#'		
</cfquery>

<cfif system.functioncondition eq "Dataset">
		
		<cfparam name="Form.Location"        default="">
		<cfparam name="Form.amountoperator"  default="">
		<cfparam name="Form.amount"          default="">
		<cfparam name="Form.Category"        default="">
		<cfparam name="Form.Description"     default="">
		<cfparam name="Form.OrgUnitCode"     default="">
		<cfparam name="Form.DateStart"       default="">
		<cfparam name="Form.DateEnd"         default="">
		<cfparam name="Form.CreatedStart"    default="">
		<cfparam name="Form.CreatedEnd"      default="">
		
		<cfset condition = "">
		
		<cfif Form.Location neq "">
		     <cfset condition   = "#condition# AND B.Location = '#Form.Location#'">
		</cfif>
		
		<cfif Form.Category neq "">
		     <cfset condition   = "#condition# AND B.ItemCategory = '#Form.Category#'">
		</cfif>
		
		<!---
		<cfif Form.OrgUnitCode neq "">
		     <cfset condition   = "#condition# AND B.OrgUnitCode = '#Form.OrgUnitCode#'">
		</cfif>
		--->
		
		<cfif Form.Quantity neq "" and isNumeric(form.Quantity)>
		     <cfset condition   = "#condition# AND abs(B.TransactionQuantity) #form.QuantityOperator# '#Form.Quantity#'">
		</cfif>
		
		<cfif Form.QuantityTo neq "" and isNumeric(form.QuantityTo)>
		     <cfset condition   = "#condition# AND abs(B.TransactionQuantity) #form.QuantityOperatorTo# '#Form.QuantityTo#'">
		</cfif>
		
		<!---
		
		<cfif Form.Amount neq "" and isNumeric(form.amount)>
		     <cfset condition   = "#condition# AND abs(B.TransactionValue) #form.AmountOperator# '#Form.Amount#'">
		</cfif>
		
		<cfif Form.AmountTo neq "" and isNumeric(form.amountTo)>
		     <cfset condition   = "#condition# AND abs(B.TransactionValue) #form.AmountOperatorTo# '#Form.AmountTo#'">
		</cfif>
		
		--->
		    
		<cfif Form.DateStart neq "">
		     <cfset dateValue = "">
			 <CF_DateConvert Value="#Form.DateStart#">
			 <cfset dte = dateValue>
			 <cfset condition = "#condition# AND B.TransactionDate >= #dte#">
		</cfif>	
		  
		<cfif Form.DateEnd neq "">
			 <cfset dateValue = "">
			 <CF_DateConvert Value="#Form.DateEnd#">
			 <cfset dte = dateValue>
			 <cfset dte = DateAdd("h","24", dte)>		
			 <cfset condition = "#condition# AND B.TransactionDate <= #dte#">
		</cfif>
		
		<!---
		
		<cfif Form.CreatedStart neq "">
		     <cfset dateValue = "">
			 <CF_DateConvert Value="#Form.CreatedStart#">
			 <cfset dte = dateValue>
			 <cfset condition = "#condition# AND B.Created >= #dte#">
		</cfif>	
		  
		<cfif Form.CreatedEnd neq "">
			 <cfset dateValue = "">
			 <CF_DateConvert Value="#Form.CreatedEnd#">
			 <cfset dte = dateValue>
			 <cfset dte = DateAdd("h","24", dte)>	
			 <cfset condition = "#condition# AND B.Created <= #dte#">
		</cfif>
		
		--->
		
		<cfset url.selection = form.selection>
		
<cfelse>

	 <cfset url.selection = "Unit">
		
		
</cfif>		

<cfset currrow = 0>

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

<!--- provision to only refresh memory if this is more than 20 minutes ago --->


<cftry>
	
	<cfquery name="checkfile" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
	    SELECT TOP 1 * FROM #SESSION.acc#_ItemTransaction
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
	
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#_ItemTransaction"> 		
	
	<!--- get relevant data in memory --->
	    
	<cfquery name="getDataInMemory" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		
		SELECT  
		        B.TransactionId, 
				B.Mission, 
				B.Warehouse, 
				P.WarehouseName,
							
				B.TransactionDate, 
				B.ItemNo, 
				B.ItemDescription, 
				B.ItemCategory, 
				B.TransactionLot,
				
				CASE 
				
				 WHEN B.TransactionReference is NULL THEN W.BatchReference
				 WHEN B.TransactionReference = '' THEN W.BatchReference
				 ELSE B.TransactionReference
				
				END as BatchReference,	   
				
				B.TransactionQuantity, 
				B.TransactionUoM, 
				U.UoMDescription,
	            B.TransactionValue, 
				B.TransactionBatchNo, 
				WL.StorageCode,
				B.ReceiptId, 
				B.RequestId, 
				B.CustomerId, 
				B.AssetId, 
				B.WorkOrderId, 
				B.WorkOrderLine, 
				B.ProgramCode, 
				B.PersonNo, 
				B.Source,
				B.ActionStatus,				
			       
				W.BatchDescription,  
				
				(SELECT AssetBarCode FROM AssetItem WHERE AssetId = B.AssetId) as AssetBarCode,
										
				<!--- record status from record --->
				
				(SELECT Reference 
				 FROM   Request 
				 WHERE  RequestId = B.Requestid) as RequestReference,		
													
				
				CASE 
				
				 WHEN B.OrgUnitName is NULL THEN (SELECT TOP 1 TW.WarehouseName 
										          FROM   Warehouse TW, ItemTransaction TT 
										          WHERE  TW.Warehouse = TT.Warehouse 
										          AND    TT.ParentTransactionId = B.TransactionId)
				  ELSE left(B.OrgUnitName,30)
				END as Destination,	            
				  
				
				#now()# as Created
				
				
		INTO    userQuery.dbo.#SESSION.acc#_ItemTransaction 
		
		FROM    ItemTransaction B,	       
				Warehouse P,
				WarehouseBatch W,
				WarehouseLocation WL,
				ItemUoM	U
				
		WHERE   B.Mission         = '#url.mission#'
		AND     B.Warehouse       = P.Warehouse
		AND     B.Warehouse       = WL.Warehouse
		AND     B.Location        = WL.Location
		AND     B.ItemNo          = U.ItemNo	
		AND     W.BatchNo         = B.TransactionBatchNo  
		
		AND     B.TransactionType   != '1'
		
		AND     B.TransactionUoM    = U.UOM 
		
		<!--- we show warehouse to which we have access --->
		
		<cfif globalmission neq "granted">
		
		AND     P.MissionOrgUnitId IN
				
				           (					   
			                  SELECT DISTINCT MissionOrgUnitId 
			                  FROM   Organization.dbo.Organization
							  WHERE  OrgUnit IN (#quotedvalueList(accesslist.orgunit)#) 						 																			  
						   )	
			
		</cfif>
		
		<!--- --------------------------------- --->
		
		AND     B.ItemNo IN (SELECT ItemNo 
		                     FROM   Item 
							 WHERE  ItemNo    = B.ItemNo 
							 AND    ItemClass = 'Supply')		
							 
		<cfif system.functioncondition eq "Dataset">					  
		#preservesingleQuotes(condition)# 
		</cfif>
		<cfif URL.sort neq "hierarchyCode">
		ORDER BY #URL.Sort# 
		<cfelse>
		ORDER BY O.MandateNo, #url.sort#
		</cfif>
			
	</cfquery>  
	
</cfif>	
 
<!--- retrieve for extended analysis ---> 
	
<table width="100%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
	<tr><td class="linedotted"></td></tr>
	<tr>
	<td colspan="1" align="right" height="100%">		
	   <cfinclude template="ControlListDataContent.cfm">					
	</td>
	</tr>					
	
</table>

