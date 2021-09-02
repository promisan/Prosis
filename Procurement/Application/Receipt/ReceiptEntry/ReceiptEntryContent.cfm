 
<cf_screentop html="no" jquery="Yes">

<cfajaximport tags="cfdiv,cfform">
<cf_dialogOrganization>
<cf_dialogProcurement>
<cf_dialogMaterial>
<cf_calendarscript>
<cf_dialogWorkOrder>

<cfparam name="URL.Purchase"      default="">
<cfparam name="URL.ReceiptNo"     default="">
<cfparam name="URL.Reqno"         default="">
<cfparam name="URL.box"           default="">
<cfparam name="URL.taskId"        default="">
<cfparam name="URL.mode"          default="regular">

<cfif url.purchase eq "">
				  
	<cfquery name="get" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
			 SELECT *			
			 FROM   PurchaseLine		
			 WHERE  RequisitionNo = '#URL.ReqNo#'		
	</cfquery>
	
	<cfset url.purchase = get.PurchaseNo>

</cfif>		
						  
<cfquery name="PO" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT P.*, 
	        R.InvoiceWorkflow   AS ParameterInvoiceWorkflow, 
			R.EnableFinanceFlow AS ParameterEnabledFinanceFlow, 
			R.Tracking          AS ParameterTracking, 
	        R.ReceiptEntry      AS ParameterReceiptEntry,
			R.ReceiptEntryLines,
			R.Description       AS OrderTypeDescription,
			Org.OrgUnitName,
			(SELECT OrgUnitName FROM Organization.dbo.Organization WHERE OrgUnit = P.OrgUnit) as ManagingUnit
	 FROM   Purchase P, 
	        Ref_OrderType R, 
			Organization.dbo.Organization Org 
	 WHERE  P.OrderType     = R.Code
	 AND    P.PurchaseNo    = '#URL.Purchase#'
	 AND    P.OrgUnitVendor = Org.OrgUnit 
</cfquery>

<cfoutput>

<script language="JavaScript">

	function validate(act) {

	    if (act == "go") {		  
		   document.entry.onsubmit() 		  
		   if( _CF_error_messages.length == 0 ) {    	
		        Prosis.busy('yes')		        
			    ptoken.navigate('ReceiptEntrySubmit.cfm?header=0&box=#url.box#&mode=#url.mode#&EntryMode=#PO.ParameterReceiptEntry#&receiptNo=#url.receiptNo#','result','','','POST','entry')
		   }   
				
		} else {
	
			se = document.getElementsByName("DetailProcess")
			if (se[0].checked) {
				document.entry.onsubmit() 
				if( _CF_error_messages.length == 0 ) {    
				    Prosis.busy('yes')	
				    ptoken.navigate('ReceiptEntrySubmit.cfm?header=0&box=#url.box#&mode=#url.mode#&EntryMode=#PO.ParameterReceiptEntry#&receiptNo=#url.receiptNo#','result','','','POST','entry')
					}   
			} else {
					 <cf_tl id="Do you want to record this receipt as a denied receipt" var="1">
		    		if (confirm("#lt_text#?")) {  
					   Prosis.busy('yes')	
					   ptoken.navigate('ReceiptEntrySubmit.cfm?header=0&actionstatus=9&box=#url.box#&mode=#url.mode#&EntryMode=#PO.ParameterReceiptEntry#&receiptNo=#url.receiptNo#','result','','','POST','entry')
					}		
			
			    }	
			} 
		}	
		
    function methodquestionaire() {	
		document.getElementById('recordreceipt').className = "regular"	
	}	 	
		
	function itemapply(context,id,box,itm,uom) {
		document.item.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
		    _cf_loadingtexthtml='';	
         	ptoken.navigate('#session.root#/warehouse/maintenance/item/Description/ItemSubmit.cfm?context='+context+'&id='+id+'&itemno='+itm+'&uom='+uom,box,'','','POST','item')
	 }   
	}		
	
	function rctmore(box,req,act,mode) {	
	  
		icM  = document.getElementById(box+"Min")
	    icE  = document.getElementById(box+"Exp")
		se   = document.getElementById(box);					
		 		 
		if (act=="show") {	 
	     	 icM.className = "regular";
		     icE.className = "hide";
			 se.className  = "regular";					
			 ptoken.navigate('ReceiptDetail.cfm?box=i'+box+'&reqno='+req+'&mode='+mode,'i'+box)	   	
		 } else {	    
	     	 icM.className = "hide";
		     icE.className = "regular";
	     	 se.className  = "hide"	 
		 }			 		
	  }	 
	  
	function taskmore(box,task,req,act,mode) {		  		
		se   = document.getElementById(task);			 	
		se.className  = "regular";		
		ptoken.navigate('ReceiptDetail.cfm?reqno='+req+'&box='+box+'&taskid='+task+'&mode='+mode,box)	   			 		
	}	   
	  
	function show(itm,act) {
	
	 	 se   = document.getElementsByName(itm)		
		 count = 0
		 
		 if (act == "0") {
			   
			   while (se[count]) { 
			      se[count].className = "hide"; 
	  		      count++
			   }			 	  
			   
			 } else {
			 
			    while (se[count]) {
			      se[count].className = "regular"; 
			      count++
			    }				   	
		   }
	 }  	     
				 
	function maximize(itm,act) {
	
	 	 se   = document.getElementsByName(itm)
		 icM  = document.getElementById(itm+"Min")
		 icE  = document.getElementById(itm+"Exp")
		 count = 0
		 
		 if (se[0].className == "regular" || act == "0" ) {
			   
			   while (se[count]) { 
			      se[count].className = "hide"; 
	  		      count++
			   }		   
		 	   icM.className = "hide";
			   icE.className = "regular";
			   
			 } else {
			 
			    while (se[count]) {
			    se[count].className = "regular"; 
			    count++
			    }	
			    icM.className = "regular";
			    icE.className = "hide";			
		   }
	 }  	
	 	 
	function setstockline(box,req,uom,qty,prc,mode,wuo,cur) {		      
		_cf_loadingtexthtml='';			    
	     ptoken.navigate('setReceiptLine.cfm?mode='+mode+'&box='+box+'&requisitionno='+req+'&uom='+uom+'&warehouseitemuom='+wuo+'&quantity='+qty+'&price='+prc+'&currency='+cur,'boxorderprocess_'+box)	   
	}
	  
	function mail() {
		w = #CLIENT.width# - 100;
		h = #CLIENT.height# - 140;
		ptoken.open("../../../../Tools/Mail/MailPrepare.cfm?Id=Mail&ID1=#URL.Purchase#&ID0=Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	}
			
	function print() {
		w = #CLIENT.width# - 100;
		h = #CLIENT.height# - 140;
		ptoken.open("../../../../Tools/Mail/MailPrepare.cfm?Id=Print&ID1=#URL.Purchase#&ID0=Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	} 
	
</script>

</cfoutput>

<cfquery name="Cur" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Currency
		WHERE  EnableProcurement = 1		
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#'
</cfquery> 
 
<cfquery name="Param" 
 datasource="AppsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ParameterMission
	 WHERE  Mission = '#PO.Mission#'
</cfquery>

<!--- retrieve purchase lines --->

<cfquery name="Purchase" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 
	  SELECT   Req.RequestType, 
 	           Req.CaseNo,
	           Req.RequestQuantity, 
			   Req.QuantityUoM,
			   Req.WarehouseItemNo,
			   Req.WarehouseUoM,	           	
			   (   SELECT ItemBarCode
			       FROM   Materials.dbo.ItemUoM
				   WHERE  ItemNo =  Req.WarehouseItemNo
				   AND    UoM    =  Req.WarehouseUoM ) as ItemBarCode,    			  		  
			   Req.Warehouse,			  
			   PL.*,
			   (   SELECT   SUM(RCT.ReceiptQuantity/RCT.ReceiptOrderMultiplier) <!--- 6/3 to add the multiplier to determine the quantiy expressed in UoM of the order --->
			   	   FROM     PurchaseLineReceipt RCT 
				   WHERE    RCT.RequisitionNo = PL.RequisitionNo
	    	       AND      RCT.ActionStatus != '9'
			   ) as ReceiptQuantity			  			  
	  FROM     RequisitionLine Req INNER JOIN PurchaseLine PL ON PL.RequisitionNo = Req.RequisitionNo	        
	  WHERE    PL.ActionStatus != '9'	
	  AND      PL.PurchaseNo    = '#url.Purchase#'	
	  ORDER BY PL.OrderItemNo  
	  
</cfquery>
   
<!--- check the delivery status of the purchase lines --->
  
<cfloop query="Purchase">

	  <cfinvoke component = "Service.Process.Procurement.PurchaseLine"  
		  method           = "getDeliveryStatus" 							   
		  RequisitionNo    = "#RequisitionNo#">		

</cfloop>
  
 <cfquery name="CustomFields" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_CustomFields
	<!---
	WHERE    HostSerialNo = '#CLIENT.HostNo#'
	--->
</cfquery>

<cf_assignid>

<cfoutput>

<cfform name="entry" id="entry" style="min-width:1200px;height:100%" target="result" method="POST" onsubmit="return false">

<table width="96%" height="100%" align="center">
	     		 
  <tr class="hide"><td height="200"><cf_divscroll style="height:100%" id="result"/></td></tr>
   
  <tr><td style="padding-top:12px" valign="top">  
  	     
	<cfoutput>
		<input type="hidden" name="Mission"      id="Mission"        value="#PO.Mission#">
		<input type="hidden" name="Period"       id="Period"         value="#PO.Period#">	  
		<input type="hidden" name="AttachmentId" id="AttachmentId"   value="#rowguid#">	 
		<input type="hidden" name="ReqNo"        id="ReqNo"          value="#url.reqno#">
		<input type="hidden" name="TaskId"       id="TaskId"         value="#url.taskid#">
	</cfoutput>
   
	  <table width="100%" align="center" style="background-color:f1f1f1">	 
	  		  
	  <tr class="labelmedium2">
	    <td style="min-width:250px;padding-left:10px"><cf_tl id="Purchase No">:</td>
		<td width="203">
		
			<table>
			
			<tr class="labelmedium2"><td>
						
			<a href="javascript:ProcPOEdit('#PO.Purchaseno#','','tab')">			
			<cf_getPurchaseNo purchaseNo="#PO.PurchaseNo#" mode="both">
			</a>	
			
			</td>
			
			<td style="PADDING-LEFT:4PX">
       			 
					<img src="#SESSION.root#/Images/mail.png"
				     alt="eMail Routing Slip Invoicing Procedures"
				     border="0" align="bottom" width="25px" height="25px"
				     style="cursor: pointer;"
					 onClick="javascript:mail()">
					 
					</td>
					<td style="padding-left:10px"> 
				    
					<img src="#SESSION.root#/Images/print_gray.png" 
					 style="cursor: pointer;" onclick="avascript:print()"
					 alt="Print"
					 height="25px"
					 width="25px"
					 border="0" align="absmiddle">		
					 
					 </td>
					 
			 </tr>
			 </table>
					 
						
		</td>
		<td width="150"><cf_tl id="Type of Order">:</td>
		<td>#PO.OrderTypeDescription#</td>				
		<td align="right"></td>		
	  </tr>	
	  	  
	  <tr class="labelmedium2">
	    <td style="padding-left:10px"><cf_tl id="Vendor">:</td>
		<td style="min-width:300px"><a href="javascript:viewOrgUnit('#PO.OrgUnitVendor#')">#PO.OrgUnitName#</a></td>
	    <td><cf_tl id="Order Date">:</td>
		<td>#DateFormat(PO.OrderDate,CLIENT.DateFormatShow)#</td>
		<td><cf_tl id="Class">:</td>
		<td>#PO.OrderClass#	(#PO.ManagingUnit#)</td>
	  </tr>	
	  
	   <cf_verifyOperational module="WorkOrder" Warning="No">				
				
		<cfif Operational eq "1">
		
			<cfquery name="WorkOrder" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   DISTINCT W.Reference, WL.WorkOrderLine, WL.WorkOrderLineId, C.CustomerName
				FROM     PurchaseLine P INNER JOIN
		                 RequisitionLine R ON P.RequisitionNo = R.RequisitionNo INNER JOIN
		                 WorkOrder.dbo.WorkOrderLine WL ON R.WorkorderId = WL.WorkOrderId AND R.WorkOrderLine = WL.WorkOrderLine INNER JOIN
		                 WorkOrder.dbo.WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
		                 WorkOrder.dbo.Customer C ON W.CustomerId = C.CustomerId
				WHERE    P.PurchaseNo = '#PO.PurchaseNo#'		  
			</cfquery>
			
			<cfif workorder.recordcount gte "1">			
		  
		    <tr class="labelmedium2">
		    <td valign="top" style="padding-top:5px;padding-left:10px;padding-top:4px"><cf_tl id="Workorder">:</td>
			<td colspan="3" style="padding-top:4px">
			
			<table style="width:300" class="navigation_table">
				<cfloop query="workorder">
					<tr style="height:21px" class="labelmedium2 navigation_row">
						<td style="padding-top:2px"><cf_img icon="edit" onclick="workorderlineopen('#workorderlineid#','#url.systemfunctionid#','#reference#')"></td>
						<td>#Reference#</td>
						<td>#Workorderline#</td>
						<td>#CustomerName#</td>					
					</tr>
				</cfloop>
			</table>
						
			</td>			
			</tr>		
						
			</cfif>
			
		</cfif>	
	  
	  <cfif url.taskid neq "">
	  			  
		 <cfquery name="Task" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	  
			SELECT   T.Reference, T.OrderDate, RT.TaskQuantity, RT.TaskUoM, R.ItemNo, UoM.UoMDescription, I.ItemDescription
			FROM     RequestTask RT INNER JOIN
                     TaskOrder T ON RT.StockOrderId = T.StockOrderId INNER JOIN
                     Request R ON RT.RequestId = R.RequestId INNER JOIN
                     ItemUoM UoM ON R.ItemNo = UoM.ItemNo AND R.UoM = UoM.UoM INNER JOIN
                     Item I ON UoM.ItemNo = I.ItemNo
			WHERE    RT.TaskId = '#url.taskid#'
		 </cfquery>	
	   
	   <tr bgcolor="B1E7F5" class="labelmedium2">
	    <td style="height:24;padding-left:20px"><cf_tl id="Task Order">:</td>
		<td>#Task.Reference#</td>
	    <td><cf_tl id="Date Issued">:</td>
		<td>#DateFormat(Task.OrderDate,CLIENT.DateFormatShow)#</td>		
		<td><cf_tl id="Item">:</td>
		<td>#Task.ItemDescription# <font size="3"><b>#numberformat(Task.TaskQuantity,',__')# #Task.UoMDescription#</font></td>		
	  </tr>	
		  
	  </cfif>
	  	 
	  </table>
  
  </td>
  
  </tr>  
    
  <cfinvoke component="Service.Access"
	   Method="procRI"
	   OrgUnit="#PO.OrgUnit#"
	   OrderClass="#PO.OrderClass#"
	   ReturnVariable="ReceiptAccess">		   
		
	<cfif (ReceiptAccess eq "NONE" or ReceiptAccess eq "READ")>	
	 
		 <tr height="10">
		 <td>
	     	<p>&nbsp;</p>
			<cf_tl id="You are not authorized to record receipts for this purchase order." var="1">
		  	<cf_message message = "#lt_text#" return = "">	   		
		 </td>
		 </tr>	  
	 
	<cfelse>
			
	<tr class="line">
	<td colspan="1" valign="bottom" style="height:50px;padding-left:10px;font-size:32px" class="labelmedium"><cf_tl id="This Receipt"></td></tr>	  
	 		 		 		  	  
		 <cf_workflowenabled 
		     mission="#po.mission#" 
			 entitycode="ProcReceipt">   	
			 
			 <cfquery name="getReceipt" 
			   datasource="AppsPurchase"
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			 	SELECT  * 
				 FROM   Receipt
				 WHERE  ReceiptNo = '#url.receiptNo#' 
			</cfquery>		  
		 		 	 	     
			<tr><td height="100%" valign="top">			 	  	       
				  		 
					  <table height="100%" width="98%" border="0" class="formpadding" align="center">	  					  
					  				  
					  <tr class="labelmedium" style="height:20px">
					    <td style="height:30px;padding-left:10px;padding-right:5px"><cf_tl id="Shipping Document No">:</td>
						<td width="200">
						<cfif url.receiptNo eq "">	
						<input type="text" name="PackingSlipNo" id="PackingSlipNo" size="20" class="regularxl enterastab" maxlength="20">
						<cfelse>
						#getReceipt.PackingSlipNo#
						</cfif>						
						</td>
						<td width="150"><cf_tl id="Document date">:</td>
						<td width="50%">
						  <cfif url.receiptNo eq "">
							  <cf_intelliCalendarDate9
								FieldName="receiptdate" 
								class="regularxl"
								DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"	
								Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
								AllowBlank="False">	
						  <cfelse>
						    #Dateformat(getReceipt.ReceiptDate, CLIENT.DateFormatShow)#
						  </cfif>	
							
					  </tr>
					 				  
					  <cfif CustomFields.ReceiptReference1 neq "" or CustomFields.ReceiptReference2 neq "">
					  <tr class="labelmedium" style="height:20px">
						<td style="height:30px;padding-left:10px">#CustomFields.ReceiptReference1#:</td>
						<td>
						<cfif url.receiptNo eq "">
						<input type="text" name="ReceiptReference1" id="ReceiptReference1" size="20" class="regularxl enterastab" maxlength="20">
						<cfelse>
						#getReceipt.ReceiptReference1#
						</cfif>
						</td>
					  	<td>#CustomFields.ReceiptReference2#:</td>
						<td>
						<cfif url.receiptNo eq "">
						<input type="text" name="ReceiptReference2" id="ReceiptReference2" size="20" class="regularxl enterastab" maxlength="20">
						<cfelse>
						#getReceipt.ReceiptReference2#
						</cfif>
						</td>
					  </tr>	
					  </cfif>
					  
					  <cfif CustomFields.ReceiptReference3 neq "" or CustomFields.ReceiptReference4 neq "">
					  <tr class="labelmedium" style="height:20px">	
						<td style="height:30px;padding-left:10px">#CustomFields.ReceiptReference3#:</td>
						<td>
						<cfif url.receiptNo eq "">
						<input type="text" name="ReceiptReference3" id="ReceiptReference3" size="20" class="regularxl enterastab" maxlength="20">
						<cfelse>
						#getReceipt.ReceiptReference3#
						</cfif>
						</td>
					 	<td>#CustomFields.ReceiptReference4#:</td>
						<td>
						<cfif url.receiptNo eq "">
						<input type="text" name="ReceiptReference4" id="ReceiptReference4" size="20" class="regularxl enterastab" maxlength="20">
						<cfelse>
						#getReceipt.ReceiptReference4#
						</cfif>
						</td>
					  </tr>	
					  </cfif>
					  			   	  
					  <tr class="labelmedium" style="height:20px">	
						<td style="height:30px;padding-left:10px;padding-top:3px"  valign="top"><cf_tl id="Remarks">:</td>
						<td colspan="3">
						<cfif url.receiptNo eq "">
						<textarea class="regular" style="width:100%;padding:3px;font-size:14px;" rows="3" name="ReceiptRemarks" id="ReceiptRemarks"></textarea>
						<cfelse>
						 #getReceipt.ReceiptRemarks#
						</cfif>
						</td>	 	
					  </tr>	 
					  
					  <tr class="labelmedium" style="height:20px"><td style="padding-left:10px"><cf_tl id="Attachments"></td>
					  <td colspan="3">
					  		 									  
						  <cf_filelibraryN
							DocumentPath   = "PurchaseReceipt"
							SubDirectory   = "#rowguid#" 		
							Filter=""
							Insert="yes"
							Remove="yes"
							reload="true">		  
					  
					  </td></tr>		
					  								  
					 <cfif workflowenabled eq "1" and url.receiptNo eq "">
					  
						  <tr class="labelmedium" style="height:20px">
						  <td style="padding-left:10px"><cf_tl id="Clearance Workflow">:</td>
						  <td colspan="3" style="padding-left:1px">
						  
						    <cfquery name="Class" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT *
								 FROM   Ref_EntityClass
								 WHERE  EntityCode = 'ProcReceipt'	 
								 AND    EntityClass IN (SELECT EntityClass 
								                        FROM   Ref_EntityClassPublish
								                        WHERE  EntityCode = 'ProcReceipt'
													 )
								 AND    EntityClass IN (
								                        SELECT EntityClass
								                        FROM   Ref_EntityClassOwner
														WHERE  EntityCode = 'ProcReceipt'
														AND    EntityClassOwner = (SELECT MissionOwner 
														                           FROM   Ref_Mission 
																				   WHERE  Mission = '#PO.Mission#')
														)					 
								 AND    Operational = 1
							</cfquery>
							
							<cfif class.recordcount eq "0">
							
								<cfquery name="Class" 
								 datasource="AppsOrganization"
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
									 SELECT *
									 FROM   Ref_EntityClass
									 WHERE  EntityCode = 'ProcReceipt'	 
									 AND    EntityClass IN (
									                        SELECT EntityClass 
									                        FROM   Ref_EntityClassPublish
									                        WHERE  EntityCode = 'ProcReceipt'
														   )								
									 AND    Operational = 1
								</cfquery>
												
							</cfif>					 
							
							<select name="entityclass" id="entityclass" style="width:200" class="regularxl">					   
								<cfloop query="Class">
								<option value="#EntityClass#" <cfif PO.OrderClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
								</cfloop>
							</select>		
						  
						  </td>
						  
						  </tr>			 
						  
						  <tr><td height="3"></td></tr>
						  
					 </cfif>				  					  		  
										 
					 <cfif url.taskid neq "" and url.reqno neq "">
					 		 	 
					 	<tr><td colspan="4" class="line"></td></tr>	
						
						<cfif workflowenabled eq "1">						
									
							<tr>
							
								<td style="padding-left:0px;padding-top:8px;padding-bottom:5px" valign="top">
								
									<table>
										<tr>
										<td onClick="maximize('det_question','1')" style="cursor: pointer;" class="labelmedium"><u><cf_tl id="Checklist"></u></td>
										
										<td style="padding-left:4px;padding-right:4px">
										 	
											<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
												id="det_questionExp" name="det_questionExp" border="0" class="hide" 
												align="absmiddle" style="cursor: pointer" 
												onClick="maximize('det_question','1')">
														
											<img src="#SESSION.root#/Images/arrowdown.gif" 
												id="det_questionMin" name="det_questionMin" alt="" border="0" 
												align="absmiddle" class="regular" style="cursor: pointer;" 
												onClick="maximize('det_question','0')">
										
										</td>										
										</tr>
									</table>
								
								</td>				
											
								<td colspan="3" id="det_question" name="det_question" class="regular">
				
										<cf_securediv id="questioncontent"
										   bind="url:#SESSION.root#/tools/entityaction/ProcessActionQuestionaireObject.cfm?entitycode=ProcReceipt&entityclass={entityclass}">			
									
								</td>
								
							</tr>											
							
							<tr><td id="det_detail" name="det_detail" class="hide" colspan="4">				
								<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">											
									<cfset url.action = "new">																							
									<cfinclude template="ReceiptLineEditForm.cfm">					
								</table>					
								</td>
							</tr>	
							
							<tr><td height="4"></td></tr>
							
							<tr id="recordreceipt" class="hide">
							<td colspan="4" bgcolor="fafafa" height="30" style="border-top:dotted silver 1px;">
							
								<table width="100%" align="center" cellspacing="0" cellpadding="0">
									<tr><td style="padding-right:4px" colspan="4" align="center">
									
										<table cellspacing="0" cellpadding="0" style="padding:4px" class="formpadding">
											<cfoutput>		
											<tr>
												<td>
													<cf_tl id="Accept" var="1">
													
													<input type="radio" 
												    name   = "DetailProcess" 
													id     = "DetailProcess"
												    value  = "#lt_text#" 
													onClick= "document.getElementById('submitbox').className='regular';show('det_detail','1');maximize('det_question','0')">
													
												</td>
												<td style="padding-left:2px" class="labelmedium"><cf_tl id="Accept Delivery"></td>
												
												<td style="padding-left:10px" id="submitbox" class="hide">									
												
												   <cf_tl id="Record Receipt" var="1">														   	  												   
												   <input type="button" 
												      width="190" 
													  style="height:24;font-size:13px" 
													  class="button10g" 
													  id="submit" 
													  name="submit" 
													  value="#lt_text#" 
													  onclick="validate()">		
												   
												</td>
												
												<td style="padding-left:10px">
													<cf_tl id="Deny" var="1">
													
												    <input type = "radio" 
													   name     = "DetailProcess" 
													   id       = "DetailProcess"
													   value    = "#lt_text#" 
													   onClick  = "document.getElementById('submitbox').className='regular';show('det_detail','0');maximize('det_question','1')"></td>
													   
												<td style="padding-left:2px" class="labelmedium"><cf_tl id="Do not accept"></td>
																					
											</tr>
											</cfoutput>	 
											
										</table>
									</td>
									
									</tr>
								</table>
							
							</td>
							</tr>									
										
					   <cfelse>
										
							<cfset url.action = "new">									
							<cfinclude template="ReceiptLineEditForm.cfm">
							
							 <tr><td colspan="4" class="line"></td></tr>
							
							 <tr><td height="39" align="center" colspan="4">
					 
								 <cfoutput>				 
								   
								   <cf_tl id="Record Receipt" var="1">
								   <input type="button" 
								       style="height:27;width:190px;font-size:13px" 
									   class="button10g" 
									   id="submit" 
									   name="submit" 
									   value="#lt_text#" 
									   onclick="validate('go')">	   
								   
								 </cfoutput>		 
												 
						     </td>
						     </tr>
											
					   </cfif>	
						
					   <input type="hidden" name="row" id="row" value="1">
													 
					 <cfelse>
									 
					 	 <tr>
						 
							 <td height="100%" colspan="4" valign="top" style="padding-left:5px;padding-right:5px">																 
							     <cf_divscroll>	
							 	 <cfinclude template="ReceiptEntryContentLines.cfm">							 
								 </cf_divscroll>	
							 </td>				 
							 			 
						 </tr>	 	
						 						 
						 <tr><td height="39" align="center" colspan="4">
					 
							 <cfoutput>		
							 		 				   
							   <cf_tl id="Record Receipt" var="1">
							   							  
							   <input type="button" 
								     width="200"	
									 class="button10g" 
									 style="height:27;width:190px;font-size:13px"			    
									 id="submit" 
									 name="submit" 
									 value="#lt_text#" 
									 onclick="validate('go')">	   
								 
							 </cfoutput>		 					
							 
						     </td>
						  </tr>
						 			
					 </cfif>	
				 
				 </table>	
							 
		</td>
		</tr>	  
							 
	</cfif>	 
				
</table>	
	 
 </cfform>
  
 </cfoutput>
   
 