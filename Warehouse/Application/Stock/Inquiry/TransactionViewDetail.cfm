
<cfparam name="pad"       default="1">
<cfparam name="url.print" default="0">
<cfparam name="access"    default="All">
<cfparam name="url.mission" 		default="">

<cfquery name="get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   ItemTransaction
	WHERE  TransactionId = '#url.drillid#'	
</cfquery>

<cfset url.mission			= get.Mission>

<cfquery name="parameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#get.Mission#'	
</cfquery>

<cfif get.recordcount eq "0">

	<table width="100%" align="center"><tr><td align="center" style="height:200" class="labellarge"><font color="FF0000">Transaction has been removed</td></tr></table>
	<cfabort>

</cfif>

<cfquery name="getAction" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT     R.Description, A.ActionDate, A.ActionCategory, AM.Metric, AM.MetricValue
  FROM       AssetItemAction A INNER JOIN
             AssetItemActionMetric AM ON A.AssetActionId = AM.AssetActionId INNER JOIN
             Ref_AssetAction R ON A.ActionCategory = R.Code
  WHERE      A.TransactionId = '#url.drillid#' 
</cfquery>

<cfquery name="bat" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   WarehouseBatch
		WHERE  BatchNo = '#get.TransactionBatchNo#'			
</cfquery>

<cfoutput query="get">

<table width="93%" align="center" cellspacing="#pad#">

<tr><td colspan="6" align="right" style="height:20px">
	
	<table width="100%">
	<tr>	
			
	<cfif url.print eq "0">
	
		<cfif access eq "ALL" and get.ActionStatus eq "0">
					
			<cfif url.accessmode eq "View">
					
					<td class="labellarge">					
					<a href="javascript:_cf_loadingtexthtml='';ptoken.navigate('TransactionViewDetail.cfm?drillid=#url.drillid#&systemfunctionid=#url.systemfunctionid#&accessmode=edit','main')"><cf_tl id="Amend transaction"></a>				
					</td>
				
			<cfelse>
			
					<td class="labellarge">
					<a href="javascript:_cf_loadingtexthtml='';ptoken.navigate('TransactionViewDetail.cfm?drillid=#url.drillid#&systemfunctionid=#url.systemfunctionid#&accessmode=view','main')"><cf_tl id="View"></a>				
					</td>
						
			</cfif>			
		
		</cfif>
			
	</cfif>
	
	<td style="padding-left:5px" align="right" class="labelmedium" style="padding-top:3px">	
	<cfif url.print eq "0">
		<a href="javascript:printme('#url.drillid#')"><cf_tl id="Printer Friendly Version"></a>
	<cfelse>
		<font face="Verdana" size="4"><b><cf_tl id="Stock Transaction"></font>
	</cfif>
	</td>
	
	</tr>
		
	</table>

</td></tr>

<tr><td colspan="2" style="height:50px;font-size:30px;" class="labellarge">#Bat.BatchDescription#</td></tr>
<tr><td colspan="4" style="border-top:1px dotted gray"></td></tr>

<tr class="labelmedium linedotted">
   <td class="labelmedium" style="padding-left:10px" width="130"><cf_tl id="Mission">:</td>
   <td width="30%">#get.Mission#</td>
   <td class="labelmedium" width="130"><cf_tl id="Warehouse">:</td>
   <td width="30%">     
	
	<cfquery name="whs" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Warehouse
		WHERE  Warehouse = '#get.Warehouse#'	
	</cfquery>
	
	#whs.WarehouseName#
	
	<input type="hidden" id="warehouse" value="#get.Warehouse#">
      
   </td>
</tr>

<tr class="labelmedium linedotted">
   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Location">:</td>
   <td>
   
   <cfquery name="loc" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   WarehouseLocation
		WHERE  Warehouse = '#get.Warehouse#'	
		AND    Location  = '#get.Location#'
	</cfquery>
	
	#loc.Location# #Loc.description# #Loc.StorageCode#
   
   </td>
   <td class="labelmedium"><cf_tl id="Class">:</td>
   <td>#Loc.LocationClass#</td>
</tr>

<tr class="labelmedium linedotted">
   <td style="padding-left:10px"><cf_tl id="Transaction Type">:</td>
   <td>
   
   <cfquery name="tpe" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Ref_TransactionType
		WHERE  TransactionType = '#get.TransactionType#'	
		
	</cfquery>
	
	<b>#tpe.Description#</font></b>
   
   </td>
   <td class="labelmedium"><cf_tl id="Financials">:</td>
   <td>#tpe.Area#</td>
</tr>

<!---

<cfif get.ReceiptId neq "00000000-0000-0000-0000-000000000000">
	
	 <cfquery name="purchase" 
		datasource="appsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     R.ReceiptNo, P.PurchaseNo
		FROM         PurchaseLineReceipt R INNER JOIN
		                      PurchaseLine P ON R.RequisitionNo = P.RequisitionNo
		WHERE     (R.ReceiptId = '#get.receiptId#')
	</cfquery>

	<tr>
	   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Receipt">:</td>
	   <td><a href="javascript:receipt('#Purchase.ReceiptNo#','receipt')"><font size="2" color="0080FF">#Purchase.ReceiptNo#</a></td>
	   <td><cf_tl id="Purchase No">:</td>
	   <td><a href="javascript:ProcPOEdit('#Purchase.Purchaseno#','view')"><font size="2" color="0080FF">#Purchase.PurchaseNo#</font></a></td>
	</tr>
	
	<tr><td colspan="4" style="border-top:1px dotted silver"></td></tr>

</cfif>
--->

<cfif get.WorkOrderId neq "">

       <cfquery name="qWorkOrder"
       datasource="appsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
              SELECT WorkOrderId,Reference,CustomForm 
			  FROM   WorkOrder.dbo.WorkOrder W, 
			         WorkOrder.dbo.ServiceItem S
			  WHERE  W.ServiceItem = S.Code		 
              AND    WorkOrderId='#get.WorkOrderId#'
       </cfquery>    	   
	   	   	   
	   <cfif findNoCase("medical",qWorkOrder.CustomForm)>
	      	   	   
	   	 <cfquery name="getLine"
       datasource="appsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
              SELECT *
			  FROM   WorkOrder.dbo.WorkOrderLine W
			  WHERE  W.WorkOrderId   = '#get.WorkOrderId#'
			  AND    W.WorkOrderLine = '#get.WorkOrderLine#'
       </cfquery>    
	   	   
			<tr class="labelmedium linedotted">
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="WorkOrder">:</td>
			   <td><a href="javascript:workorderview('#getLine.WorkOrderLineId#','medical')">#qWorkOrder.Reference#</a></td>
			   <td class="labelmedium"></td>
			   <td></td>
			</tr>
			
		<cfelse>
		
			<tr class="labelmedium linedotted">
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="WorkOrder">:</td>
			   <td><a href="javascript:workorderview('#qWorkOrder.WorkOrderId#','production')">#qWorkOrder.Reference#</a></td>
			   <td class="labelmedium"></td>
			   <td></td>
			</tr>
		
		</cfif>	
	
</cfif>



<tr class="labelmedium linedotted">
   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Item">:</td>
   <td><a href="javascript:item('#get.itemNo#','','#get.mission#')">#get.ItemNo#</a></td>
   <td class="labelmedium"><cf_tl id="Name">:</td>
   <td>#get.ItemDescription#</td>
</tr>

<tr class="labelmedium">
   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Category">:</td>
   <td>#get.ItemCategory#</td>
   <td class="labelmedium"><cf_tl id="UoM">:</td>
   <td>
   
   <cfquery name="UoM" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   ItemUoM
		WHERE  ItemNo = '#get.ItemNo#'	
		AND    UoM = '#get.TransactionUoM#'		
	</cfquery>
   
   #UoM.UoMDescription#
   
   </td>
</tr>

<!--- ----------- --->
<!--- Transaction --->
<!--- ----------- --->

<tr><td height="10"></td></tr>
<tr><td colspan="2" class="labellarge" style="height:50px;font-size:30px;"><font color="008000"><cf_tl id="Transaction Details"></td></tr>

<tr class="labelmedium linedotted">
   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Date">:</td>
   <td>
   
	   <cfif url.accessmode eq "View">
	   
	   		#dateformat(get.TransactionDate,CLIENT.DateFormatShow)# #timeformat(get.TransactionDate,"HH:MM")# (GMT #TransactionTimeZone#)
	   
	   <cfelse>
	   
		    <cf_getWarehouseTime warehouse="#whs.warehouse#">
		   
		    <cf_setCalendarDate
				      name         = "transaction"        
				      timeZone     = "#tzcorrection#"     
				      font         = "13"			  
					  valuecontent = "datetime"
					  value        = "#get.TransactionDate#"
				      mode         = "datetime"> 
	   
	   </cfif>
   
   </td>
         
   <cfif get.TransactionBatchNo neq "">
      
	   <td class="labelmedium"><cf_tl id="Batch">:</td>
	   <td class="labelmedium">
	   
	   <cfinvoke component = "Service.Access"  
		   method           = "WarehouseAccessList" 
		   mission          = "#url.mission#" 					   					 
		   Role             = "'WhsShip'"
		   FunctionName     = "'Process Transactions'"
		   accesslevel      = "'1','2'" 					  
		   returnvariable   = "Access">
	   
	    <cfif findNoCase(get.Warehouse,Access) or getAdministrator(url.mission) eq "1">
		   <a href="javascript:batch('#get.TransactionBatchNo#','#get.Mission#','process','#url.systemfunctionid#')"><font size="3">#get.TransactionBatchNo#</font></a>
	   <cfelse>
		   <a href="javascript:batch('#get.TransactionBatchNo#','#get.Mission#','view','#url.systemfunctionid#')"><font size="3">#get.TransactionBatchNo#</font></a>	 
	   </cfif>
	   
	    <cfquery name="bat" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   WarehouseBatch
			WHERE  BatchNo = '#get.TransactionBatchNo#'			
		</cfquery>
		
		<cfif bat.actionStatus eq "0">
			<font size="3" color="red"><cf_tl id="Pending"></font>
		<cfelse>
			<font size="3" color="008000"><cf_tl id="Cleared"></font>
		</cfif>
	     
	   </td>
   
   </cfif>
   
</tr>

<tr class="labelmedium linedotted">
   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Reference">:</td>
   <td>
    <cfif url.accessmode eq "View">
   #get.TransactionReference#
   <cfelse>   
  
     <input type="text" class="regularh" style="height:22;padding-top:2px;font-size:13px" name="TransactionReference" value="#get.TransactionReference#" maxlength="20">
  
   </cfif>
   </td>
   
    <td class="labelmedium"><cf_tl id="Billing">:</td>
    <td>
    <cfif url.accessmode eq "View">
	   #get.BillingMode#
    <cfelse>
	   
	  <table><tr><td>
		  <input type="radio" name="BillingMode" value="Internal"  <cfif get.BillingMode eq "Internal">checked</cfif>></td><td style="padding-left:3px" class="labelmedium">No</td>
		  <td style="padding-left:3px">
    	  <input type="radio" name="BillingMode" value="External"  <cfif get.BillingMode eq "External">checked</cfif>></td><td style="padding-left:3px" class="labelmedium">Yes</td>
		</tr>
	 </table>  
	
   </cfif>
   </td>
      
</tr>   

<cfif Parameter.LotManagement eq "1">

<tr class="labelmedium">
   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Production Lot">:</td>
   <td>
    <cfif url.accessmode eq "View">
   #get.TransactionLot#
   <cfelse>   
  
     <input type="text" class="regularh" style="height:22;padding-top:2px;font-size:13px" name="TransactionLot" value="#get.TransactionLot#" maxlength="20">
  
   </cfif>
   </td>
   
      
</tr>   

</cfif>


<!--- view relate transactions in case of a transfer --->

<cfif get.TransactionType eq "8">
	
	<tr>
		<td colspan="4" style="padding-left:4px;padding-right:4px;">
		
		<table width="100%">
		
		<tr><td>
		
			<!--- details of the batch --->
			<cfset url.mission = get.Mission>
			<cfset url.batchno = get.TransactionBatchNo>
			<cfset url.mode    = "embed">
			<cfset url.ItemNo  = get.ItemNo>
			<cfinclude template="../Batch/BatchViewTransaction.cfm">
		
		</td></tr>
		</table>
		
		</td>
	</tr>

</cfif>

<cf_precision number="#itemPrecision#">

<tr class="labelmedium">
   <td class="labelmedium" style="<cfif accessmode eq 'edit'>height:23</cfif>;padding-left:10px"><cf_tl id="Quantity">:</td>
   <td>
   
   <cfif url.accessmode eq "view">
   	     
	   <cfif transactiontype eq "2">
	   #numberformat(-get.TransactionQuantity,"#pformat#")#
	   <cfelse>
	   #numberformat(get.TransactionQuantity,"#pformat#")#
	   </cfif>
   
   <cfelse>
   
   	  <cfif transactiontype eq "2">
   		<cfset qty = -get.TransactionQuantity>
	  <cfelse>
	    <cfset qty = get.TransactionQuantity>	 
   	  </cfif>  
	     
     <input type="text" class="regularh" style="text-align:right;height:22;width:90;padding-top:2px;font-size:13px" 
	 		name="TransactionQuantity" value="#numberformat(qty,'#pformat#')#" maxlength="10">
    
   </cfif>   
   
   </td>
   <td class="labelmedium"><cf_tl id="Quantity Base">:</td>
   <td>
	   <cfif transactiontype eq "2">
	   #numberformat(-get.TransactionQuantityBase,"#pformat#")#
	   <cfelse>
	   #numberformat(get.TransactionQuantityBase,"#pformat#")#
	   </cfif>
   </td>
</tr>

<tr class="labelmedium">
   <td style="<cfif accessmode eq 'edit'>height:23</cfif>;padding-left:10px"><cf_tl id="Price">:</td>
   <td>#numberformat(get.ReceiptCostPrice,",.____")#</td>
   <td><cf_tl id="Transaction Value">:</td>   
   <td>
	   <cfif transactiontype eq "2">
	   #numberformat(-get.TransactionValue,",.__")#
	   <cfelse>
	   #numberformat(get.TransactionValue,",.__")#
	   </cfif>
   </td>
</tr>

<tr class="labelmedium">
   <td class="labelmedium" valign="top" style="padding-top:2px;padding-left:10px"><cf_tl id="Remarks">:</td>
   <td colspan="3">
   
    <cfif url.accessmode eq "View">
	
      #get.Remarks#
  
    <cfelse>   
   
      <textarea name="Remarks" style="width:99%;height:40;padding:3px" totlength="200" onkeyup="return ismaxlength(this)"	class="regular">#get.Remarks#</textarea>
  
   </cfif>
   
   </td>
</tr>   

<cfif transactiontype eq "1">
	
	<!--- ----------- --->
	<!--- Transaction --->
	<!--- ----------- --->
	<tr><td height="10"></td></tr>
	<tr><td colspan="2" class="labellarge"><b><cf_tl id="Provider"></td></tr>
	<tr><td colspan="4" style="border-top:1px dotted gray"></td></tr>
	
	<cfif get.ReceiptId neq "00000000-0000-0000-0000-000000000000">
	
			<cfquery name="rct" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     PR.ReceiptNo, PR.DeliveryDate, P.PurchaseNo, O.OrgUnitName AS Vendor
				FROM         PurchaseLineReceipt PR INNER JOIN
		                      PurchaseLine PL ON PR.RequisitionNo = PL.RequisitionNo INNER JOIN
		                      Purchase P ON PL.PurchaseNo = P.PurchaseNo INNER JOIN
		                      Organization.dbo.Organization O ON P.OrgUnit = O.OrgUnit
				WHERE     (PR.ReceiptId = '#get.ReceiptId#')
			</cfquery>
	 	 	
			<tr class="labelmedium">
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Vendor">:</td>
			   <td>#rct.Vendor#</td>
			   <td class="labelmedium"><cf_tl id="PurchaseNo">:</td>
			   <td><a href="javascript:ProcPOEdit('#rct.PurchaseNo#')">#rct.PurchaseNo#</a></td>
			</tr>
			
			<tr class="labelmedium">
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="ReceiptNo">:</td>
			   <td><a href="javascript:receipt('#rct.receiptno#')">#rct.ReceiptNo#</a></td>
			   <td class="labelmedium"><cf_tl id="Delivery">:</td>
			   <td>#dateformat(rct.DeliveryDate,client.dateformatshow)#</td>
			</tr>
				
	</cfif>
	
<cfelseif transactiontype eq "2">
		
	<!--- ----------- --->
	<!--- Transaction --->
	<!--- ----------- --->
	<tr><td height="10"></td></tr>
	<tr><td colspan="2" class="labellarge"><b><cf_tl id="Beneficiary"></font></td></tr>
	<tr><td colspan="4" style="border-top:1px dotted gray"></td></tr>
	
	<cfif url.accessmode eq "view">
	
		<cfif get.ProgramCode neq "">
			
			<cfquery name="prg" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     Program
						WHERE    ProgramCode = '#get.ProgramCode#'				
				</cfquery>
			
			<tr>
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Program"></td>			  
			   <td class="labelmedium">#prg.ProgramName#</td>	  			   
			   <td class="labelmedium"><cf_tl id="Mission"></td>
			   <td class="labelmedium">#prg.Mission#</td>
			</tr>
			<tr><td colspan="4" style="border-top:1px dotted silver"></td></tr>
		
		</cfif>
		
		<cfif get.WorkOrderId neq "">
			
			<cfquery name="wrk" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   I.Description, C.CustomerName
					FROM     WorkOrder W, Customer C, ServiceItem I
					WHERE    W.CustomerId = C.CustomerId
					AND      WorkOrderId = '#get.WorkOrderid#'		
					AND      W.ServiceItem = I.Code		
			</cfquery>
			
			<cfif findNoCase("medical",qWorkOrder.CustomForm)>
			
			<tr class="labelmedium linedotted">
			   <td style="padding-left:10px"><cf_tl id="WorkOrder">:</td>
			   <td><a href="javascript:workorderview('#getLine.WorkOrderLineId#','medical')">#wrk.Description#</a></td>
			   <td><cf_tl id="Customer">:</td>
			   <td>#wrk.CustomerName#</td>
			</tr>
						
			<cfelse>
			
			<tr class="labelmedium linedotted">
			   <td style="padding-left:10px"><cf_tl id="WorkOrder">:</td>
			   <td><a href="javascript:workorderview('#get.workorderid#')">#wrk.Description#</a></td>
			   <td><cf_tl id="Customer">:</td>
			   <td>#wrk.CustomerName#</td>
			</tr>
			
			</cfif>
		
		</cfif>
		
		<cfif get.AssetId neq "">
			
			<cfquery name="ass" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     AssetItem
					WHERE    AssetId = '#get.AssetId#'				
			</cfquery>
			
			<cfquery name="item" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     Item
					WHERE    ItemNo = '#ass.ItemNo#'				
			</cfquery>
			
			<tr>
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="BarCode">:</td>
			   <td><font size="2">#ass.AssetBarCode#</td>	
			   <td class="labelmedium"><cf_tl id="Name"></td>   
			   <td><a href="javascript:AssetDialog('#get.assetid#')">#ass.Description#</a></td>
			</tr>
			<tr>
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Item Generic">:</td>
			   <td><font size="2">#Item.ItemDescription#</td>
			    <td class="labelmedium"><cf_tl id="Category"></td>
			   <td><font size="2">#item.Category#</td>
			</tr>
			<tr>
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="DecalNumber">:</td>
			   <td><font size="2">#ass.AssetDecalNo#</td>
			   <td class="labelmedium"><cf_tl id="SerialNo"></td>
			   <td><font size="2">#ass.SerialNo#</td>
			</tr>
			<tr>
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Make">:</td>
			   <td><font size="2">#ass.Make#</td>
			   <td class="labelmedium"><cf_tl id="Model">:</td>
			   <td><font size="2">#ass.Model#</td>
			</tr>
			
		</cfif>
		
		<cfif getAction.recordcount gte "1">
		
			<cfloop query="getAction">
			<tr>
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Log">:</td>
			   <td>#Description#</td>
			   <td class="labelmedium"><cf_tl id="#Metric#">:</td>   
			   <td>  
			   <b>#numberformat(MetricValue,",__")# 
			   </td>
			</tr>
			</cfloop>
			
			<tr><td colspan="4" style="border-top:1px dotted silver"></td></tr>
		
		</cfif>
		
		<cfif get.OrgUnit neq "">
		<tr>
		   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Unit">:</td>
		   <td><font size="2">#get.OrgUnitCode#</td>
		   <td class="labelmedium"><cf_tl id="UnitName">:</td>
		   <td><font size="2">#get.OrgUnitName#</td>
		</tr>
		</cfif>
		
		<cfif get.PersonNo neq "">
			
			<cfquery name="per" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     Person
						WHERE    PersonNo = '#get.PersonNo#'				
				</cfquery>
			
			<tr>
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Officer">:</td>

			   <cfif getAdministrator(get.mission) eq "1">
			   <td><a href="javascript:EditPerson('#PersonNo#')"><font size="2">#per.firstName# #per.LastName#</a></td>
			   <cfelse>
			   <td><font size="2">#per.firstName# #per.LastName#</td>	  
			   </cfif>
			   
			   <td class="labelmedium"><cf_tl id="IndexNo">:</td>
			   <td class="labelmedium"><font size="2">#per.IndexNo#</td>
			</tr>
			<tr>
			   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Reference">:</td>			  
			   <td><font size="2"><cfif per.reference eq "">n/a<cfelse>#per.Reference#</cfif></td>	  			 
			   <td class="labelmedium"><cf_tl id="Nationality">:</td>
			   <td><font size="2">#per.Nationality#</td>
			</tr>
			<tr><td colspan="4" style="border-top:1px dotted silver"></td></tr>
		
		</cfif>	
		
	<cfelse>
	
	    <cfinclude template="TransactionEditAssetDetail.cfm">
			
	</cfif>	
	
</cfif>	


<cfif get.GLAccountDebit neq "">
	
	<!--- ----------- --->
	<!--- Financials- --->
	<!--- ----------- --->
	
	<tr class="labelmedium">
	   <td style="padding-left:10px"><cf_tl id="GL Debit"></td>   
	   
		<cfquery name="gla" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_Account
				WHERE    GLAccount = '#get.GLAccountDebit#'				
		</cfquery>
		
	   <td>#get.GLAccountDebit# #gla.Description#</td>
	   <td><cf_tl id="GL Credit"></td>
	   
	   <cfquery name="gla" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_Account
				WHERE    GLAccount = '#get.GLAccountCredit#'				
		</cfquery>
		
	   <td>#get.GLAccountCredit# #gla.Description#</td>
	</tr>
	
	<cfquery name="hea" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Accounting.dbo.TransactionHeader
		WHERE    ReferenceId = '#get.Transactionid#'
	</cfquery>	
	
	<tr class="labelmedium linedotted">
	   <td style="padding-left:10px"><cf_tl id="Journal">:</td>   
	      
		<cfinvoke component = "Service.Access"  
		   method           = "journal" 
		   journal          = "#hea.journal#"
		   orgunit          = "0"
		   returnvariable   = "access">	   
	   
	    <cfif access neq "NONE">
			   <td><a href="javascript:ShowTransaction('#hea.Journal#','#hea.JournalSerialNo#')">#hea.Journal#-#hea.JournalSerialNo#</a></td>
	    <cfelse>   
		      <td>#hea.Journal#-#hea.JournalSerialNo#</td>
	    </cfif>
	   
	   <td class="labelmedium"><cf_tl id="Amount">:</td>
	   <td>#hea.Currency# #numberformat(hea.Amount,',.__')#</td>
	</tr>   
	
	<cfquery name="line" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   R.AccountLabel, R.Description, TL.* 
		FROM     Accounting.dbo.TransactionLine TL, 
		         Accounting.dbo.Ref_Account R
		WHERE    TL.GLAccount = R.GLAccount		 
		AND      Journal         = '#hea.Journal#'
		AND      JournalSerialNo = '#hea.JournalSerialNo#'
	</cfquery>	
			
	<tr><td></td><td colspan="3" style="padding-right:40px">
	
		<table width="100%">
		
			<tr class="labelmedium line" style="height:20px">						
				<td colspan="2"><cf_tl id="Account"></td>				
				<td><cf_tl id="Fiscal Year"></td>
				<td><cf_tl id="Period"></td>
				<td style="width:10%" align="right"><cf_tl id="Debit"></td>		
				<td style="width:10%" align="right"><cf_tl id="Credit"></td>	
			</tr>
		
		<cfloop query="line">
		
			<tr class="labelmedium" style="height:20px">						
				<td>#AccountLabel#</td>
				<td style="width:40%">#Description#</td>
				<td>#AccountPeriod#</td>
				<td>#TransactionPeriod#</td>
				<td style="width:10%" align="right">#numberformat(AmountBaseDebit,",.__")#</td>		
				<td style="width:10%" align="right">#numberformat(AmountBaseCredit,",.__")#</td>	
			</tr>
		
		</cfloop>
		
		</table>
		
	</td></tr>	

</cfif>

<cfif transactionQuantity gt "0">
	
	<tr><td colspan="2" style="height:50px;font-size:30px;" class="labellarge"><font color="800080"><b><cf_tl id="Sourcing"></td></tr>
	
	<tr><td colspan="4">
	<cfquery name="sourcelist" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    T.TransactionType, T.TransactionTimeZone, T.TransactionDate, IV.TransactionQuantity, IV.TransactionPrice, IV.TransactionPriceValue, T.Warehouse, R.Description, 
                  W.WarehouseName, T.TransactionBatchNo
		FROM      ItemTransactionValuation IV INNER JOIN
                  ItemTransaction T ON IV.DistributionTransactionId = T.TransactionId INNER JOIN
                  Ref_TransactionType R ON T.TransactionType = R.TransactionType INNER JOIN
                  Warehouse W ON T.Warehouse = W.Warehouse
		WHERE     IV.TransactionId = '#url.drillid#'
	</cfquery>	
	
	<table width="100%">
	
	<cfloop query="SourceList">
	
	<tr class="line labelmedium">
		  <td style="padding-left:10px">#TransactionBatchNo#</td>	
	      <td>#TransactionType# #Description#</td>
		  <td>#WarehouseName#</td>
		  <td>#dateformat(TransactionDate,client.dateformatshow)# #timeformat(TransactionDate,"HH:MM")#</td>		  
	      <td>#TransactionQuantity#</td>		 
		  <td align="right">#numberformat(TransactionpriceValue,',.__')#</td>
	  </tr>
		
	</cfloop>
	
	</table>
	
	</td></tr>

</cfif>



<!--- ----------- --->
<!--- Transaction --->
<!--- ----------- --->

<tr><td height="10"></td></tr>
<tr><td colspan="2" style="height:50px;font-size:30px;" class="labellarge"><font color="0080C0"><cf_tl id="Amendment History"></td></tr>
<tr><td colspan="4" style="border-top:1px dotted gray"></td></tr>

<tr>
   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Officer">:</td>
   <td class="labelmedium">#get.OfficerFirstName# #get.OfficerLastName#</td>
   <td class="labelmedium"><cf_tl id="Recorded">:</td>
   <td class="labelmedium">#dateformat(get.created,CLIENT.DateFormatShow)# #timeformat(get.created,"HH:MM:SS")#</td>
</tr>

<!--- history --->

<cfquery name="log" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 5 *
	FROM     ItemTransactionDeny
	WHERE    ParentTransactionId = '#get.Transactionid#'
	ORDER BY Created DESC
</cfquery>	

<cfloop query="log">

<tr>
   <td class="labelmedium" style="padding-left:10px"><cf_tl id="Officer">:</td>
   <td class="labelmedium">#log.OfficerFirstName# #log.OfficerLastName#</td>
   <td class="labelmedium"><cf_tl id="Recorded">:</td>
   <td class="labelmedium">#dateformat(log.created,CLIENT.DateFormatShow)# #timeformat(log.created,"HH:MM:SS")#</td>
</tr>

</cfloop>

<tr><td colspan="4" style="border-top:1px dotted gray"></td></tr>

<cfif accessmode eq "edit">

<tr><td colspan="4" align="center" style="height:36px" id="process">
	
	<table cellspacing="0" align="center" class="formspacing">
	<tr>
		<td><input type="button" name="Delete" class="button10g" value="Delete" style="width:140;height:25" onclick="doit('delete')"></td>
		<td><input type="button" name="Update" class="button10g" value="Update" style="width:140;height:25" onclick="doit('update')"></td>
	</tr>
	</table>

</td></tr>

</cfif>

</table>

</cfoutput>