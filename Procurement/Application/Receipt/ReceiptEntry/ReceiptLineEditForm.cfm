	
<table width="99%" class="formpadding" align="center">
	
<cfoutput>	
	<input type="hidden" style="width:500px" id="mylink" value="mode=#url.mode#&reqno=#url.reqno#&action=#URL.action#&ID=#url.rctid#&TBL=#tbl#&taskid=#url.taskid#">	
</cfoutput>
	
<cfparam name="URL.date" default="">
<!--- mode 

	Check the status of the receipt 

	if status = 1 (cleared) only view
	if status = 0 (not cleared) : you may edit and remove
	if ordertype.receiptentry = 0 : limit the editable fields to only price + quantity
	if ordertype.receiptentry = 1 : enforce the entry of a receipt record, open contract.

--->

<cfajaximport tags="cfform">

<!-- <cfform> -->

<!--- -------------------------- --->
<!--- ---item creation helper--- --->
<!--- -------------------------- --->

<cfif not isDefined("SESSION.helper")>
	<cfset helper          = StructNew() /> 
	<cfset helper.mode     = "--generate" />   <!--- no longer by default selected --->
	<cfset helper.topics   =  StructNew() >
	<cfset helper.category = StructNew()>

	<cfset SESSION.helper = helper />

</cfif>

<cfset helper  = SESSION.helper>

<!--- /helper --->

<cfparam name="tbl"         default="PurchaseLineReceipt">
<cfparam name="URL.reqno"   default="">
<cfparam name="URL.taskid"  default="">
<cfparam name="URL.action"  default="view">


<cfquery name="Prior" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
	    FROM   #tbl#
		WHERE  RequisitionNo = '#URL.ReqNo#' 
		ORDER BY Created DESC 
</cfquery>

<cfinclude template="ReceiptLineScript.cfm">

<cfquery name="Purchase" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
    FROM   PurchaseLine L, 
	       Purchase P, 
		   Ref_OrderType R
	WHERE  RequisitionNo = '#URL.reqno#'  
	AND    L.PurchaseNo  = P.PurchaseNo
	AND    P.OrderType   = R.Code
</cfquery>

<cfset url.purchase = Purchase.PurchaseNo>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Purchase.Mission#' 
</cfquery>

<cfquery name="Param" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ParameterMission
	 WHERE  Mission = '#Purchase.Mission#'
</cfquery>

<cfparam name="PO.Mission" default="#Purchase.Mission#">

<cfquery name="UoM" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
       SELECT *
       FROM   Ref_UoM
</cfquery>

<cfparam name="Status" default="1">
	
	<cfquery name="Requisition" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT  L.*, 
		        R.EntryClass, 
				R.Description as ItemMaster, 
				R.EnforceWarehouse, 
				L.WarehouseItemNo  <!--- here we defined through the item master how we select item --->
	    FROM    RequisitionLine L INNER JOIN ItemMaster R ON L.ItemMaster = R.Code
		WHERE   RequisitionNo = '#URL.reqno#' 
	</cfquery>			
			
	<cfquery name="EntryClass" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    Ref_EntryClass
		WHERE   Code = '#Requisition.EntryClass#' 
	</cfquery>	
				    		
	<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   #tbl#
		WHERE  ReceiptId = '#URL.RctId#' 
	</cfquery>
			 			
    <!--- precalculation --->
				
	<cfif Line.recordcount eq "0"> 		
		
	     <!--- new record --->		 
								 		 
		 <cfif url.taskid eq "">
		 				 		 			  
			 <cfset no    = Purchase.OrderItemNo>
			 <cfset ord   = Purchase.OrderItem>
			 <cfset mul   = Purchase.OrderMultiplier>
			 <cfset qty   = "">
			 <cfset prc   = Purchase.OrderPrice>			 
							 
	 		 <cfset whsitemno = Requisition.WarehouseItemNo>			 
			
			 <!--- changed the default 
			 <cfset prc   = Purchase.OrderAmountCost/Purchase.OrderQuantity>
			 --->
			 
			 <cfset dis   = 0>
			 <cfset txu   = Purchase.OrderTax*100>
			 <cfset txi   = Purchase.TaxIncluded>
			 <cfset exm   = Purchase.TaxExemption>
			 
			 <cfif Purchase.OrderAmountTax eq "0">
				 <cfset exm = 1>
			 </cfif>
			
			 <cfset curr  = Purchase.Currency>
			 
			 <cfquery name="Cur" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   currency
					WHERE  currency = '#purchase.currency#'
		  	 </cfquery>
			 
			 <cfset exch = cur.exchangeRate>
			 <cfif exch eq "">
			   <cfset exch = 1>
			 </cfif>
			
			 <cfset amt   = 0>
			 <cfset damt  = 0>
			 <cfset cost  = 0>
			 <cfset costB = 0>
			 <cfset tax   = 0>
			 <cfset taxB  = 0>
			 <cfset pay   = 0>
			 <cfset payB  = 0>
		 
		 <cfelse>
		 		 
		    <!--- we determined it is a taskorder, so we have a lot of information already --->
		  						 
		    <cfquery name="get" 
				 datasource="AppsMaterials"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
				 SELECT    *
				 FROM      RequestTask
				 WHERE     TaskId  = '#url.taskid#'				
		    </cfquery>	
			
			 <!--- take the latest price here --->	
						
			 <cfquery name="getLoc" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    	SELECT * 
					FROM   Warehouse
					WHERE  Warehouse  = '#get.ShipToWarehouse#'			
			 </cfquery>	
			
			 <cfif getLoc.LocationId neq "">		
			
			   <cf_setTaskValue TaskId="#url.taskid#" ValueDate="#dateformat(now(),CLIENT.DateFormatShow)#">
			   						
			 </cfif>			 
			
			 <cfquery name="TaskOrder" 
				 datasource="AppsMaterials"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
				 SELECT    *
				 FROM       Request R, RequestTask T
				 WHERE      R.RequestId = T.RequestId
				 AND        T.TaskId  = '#url.taskid#'				
		    </cfquery>	
			
			 <cfset prc   = TaskOrder.TaskPrice>
								
			 <cfset whsitemno = taskorder.itemno>	
		   
		     <cfset no    = Purchase.OrderItemNo>
			 <cfset ord   = Purchase.OrderItem>
			 <cfset mul   = "1">
			 <cfset qty   = ""> <!--- TaskOrder.TaskQuantity --->
						
			 <cfset dis   = 0>
			 <cfset txu   = Purchase.OrderTax*100>
			 <cfset txi   = "1">
			 <cfset exm   = Purchase.TaxExemption>
			 
			 <cfif Purchase.OrderAmountTax eq "0">
				 <cfset exm = 1>
			 </cfif>
			
			 <cfset curr  = TaskOrder.TaskCurrency>
			 
			 <cfquery name="Cur" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Currency
					WHERE  Currency = '#TaskOrder.TaskCurrency#'
		  	 </cfquery>
			 
			 <cfset exch = cur.exchangeRate>
			 <cfif exch eq "">
			   <cfset exch = 1>
			 </cfif>
			
			 <cfset amt   = 0>
			 <cfset damt  = 0>
			 <cfset cost  = 0>
			 <cfset costB = 0>
			 <cfset tax   = 0>
			 <cfset taxB  = 0>
			 <cfset pay   = 0>
			 <cfset payB  = 0>   
		 	 
		 </cfif>		 
				
	<cfelse>		
	
		<cfif Line.WarehouseTaskId neq "">
		
			<cfquery name="TaskOrder" 
				 datasource="AppsMaterials"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
				 SELECT    *
				 FROM       Request R, RequestTask T
				 WHERE      R.RequestId = T.RequestId
				 AND        T.TaskId    = '#Line.WarehouseTaskid#'				
		    </cfquery>	
			
			<cfset url.taskid = line.warehousetaskid>
					
		</cfif>
	
		 <cfset whsitemno = line.warehouseitemno>
	
	     <!--- edit mode, take from the receipt line --->
		
		 <cfset no   = Line.ReceiptItemNo>
		 <cfset ord  = Line.ReceiptItem>
		 <cfset mul  = Line.ReceiptMultiplier>		 
		 	
		 
		 <cfquery name="Cur" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 *
			    FROM   CurrencyExchange
				WHERE  Currency = '#Line.Currency#'
				AND    EffectiveDate <= '#dateformat(Line.DeliveryDate,client.dateSQL)#'
				ORDER BY EffectiveDate DESC
	  	 </cfquery>
		 
		 <cfif cur.recordcount eq "0">
		 
		 	<cfset exch = Line.ExchangeRate>
		 
		 <cfelse>
			 
		 	<cfset exch = cur.ExchangeRate>			
					 
		 </cfif>	 			 
		 
		 <cfset qty  = Line.ReceiptQuantity>
		 <cfset prc  = Line.ReceiptPrice>								 
		 <cfset dis  = Line.ReceiptDiscount*100>
		 <cfset txu  = Line.ReceiptTax*100>
		 <cfset txi  = Line.TaxIncluded>
		 
		 <cfset curr = Line.Currency>
		 <cfset exm  = Line.TaxExemption>
		 		 	
		 <cfset amt  = round(Line.ReceiptPrice*Line.ReceiptQuantity*100)/100>		 
		 <cfset damt = Line.ReceiptPrice*Line.ReceiptQuantity*((100-dis)/100)>
		 <cfset damt = round(damt*100)/100>
		 
		 <cfif Line.TaxIncluded eq "1">
		 	<cfset cost = damt*(1/(1+Line.ReceiptTax))>
			<cfset tax  = damt*(Line.ReceiptTax/(1+Line.ReceiptTax))>
		 <cfelse>
		  	<cfset cost = damt>
			<cfset tax  = damt*(Line.ReceiptTax)>
		 </cfif>
		 
		 <cfset costB = cost/exch>
		 <cfset taxb  = tax/exch>
		 
		 <cfif Line.TaxExemption eq "1" or tax eq "">
			 <cfset pay   = cost>
			 <cfset payB  = costB>		
		 <cfelse>
		 	 <cfset pay   = cost+tax>
			 <cfset payB  = costB+taxB>			
		 </cfif>	
		
	</cfif>		
	
	 <cfset digit =  ToString(prc - Fix(prc)).ReplaceFirst("^0?\.","")>
	 <cfset dgt  = len(digit)>
	 <cfif dgt lte "2">
		 	<cfset dgt = ".__">
	 <cfelseif dgt eq "3">
	 	<cfset dgt = ".___">
	 <cfelseif dgt eq "4">
	    <cfset dgt = ".____">
	 <cfelse>	 		
	    <cfset dgt = "._____">
	 </cfif>	
						
	<cfif URL.action eq "new">
		
		<cfquery name="Item" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Item
			WHERE  ItemNo = '#Line.WarehouseItemNo#'
		</cfquery>				
					
	</cfif>	
		
	<cf_calendarscript>			
					
		<!--- time entry script --->
					
		<script>		
			
			var isNN = (navigator.appName.indexOf("Netscape")!=-1);
			
			function autoTab(input,len, e) {
				var keyCode = (isNN) ? e.which : e.keyCode; 
				var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
				if(input.value.length >= len && !containsElement(filter,keyCode)) {
				input.value = input.value.slice(0, len);
				input.form[(getIndex(input)+1) % input.form.length].focus();
				}
				function containsElement(arr, ele) {
				var found = false, index = 0;
				while(!found && index < arr.length)
				if(arr[index] == ele)
				found = true;
				else
				index++;
				return found;
				}
				function getIndex(input) {
				var index = -1, i = 0, found = false;
				while (i < input.form.length && index == -1)
				if (input.form[i] == input)index = i;
				else i++;
				return index;
				}
				return true;
			}
			
		</script>	
						
		<cfoutput>	
				
		<input type="hidden" name="workorderid"     value="#requisition.workorderid#">
		<input type="hidden" name="workorderline"   value="#requisition.workorderline#">
		<input type="hidden" name="RequirementId"   value="#requisition.RequirementId#">
		
		 <cfquery name="getLines" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT RL.*
			 FROM   PurchaseLineReceipt RL INNER JOIN PurchaseLine PL ON PL.RequisitionNo = RL.RequisitionNo 
			 WHERE  RL.ReceiptNo    = '#Line.ReceiptNo#'
			 AND    RL.ActionStatus <> '9' 
			 AND    PL.actionStatus <> '9' 
			 ORDER BY ReceiptItemNo, Created DESC
		 </cfquery>
		
		<cfset myArray = ValueArray( getLines,"ReceiptId" )>
		
		<cfset pr = "0">
		<cfset nr = "9999">		
		
		<cfloop from="1" to="#ArrayLen(myArray)#" index="cnt">
		
			<cfif myArray[cnt] eq url.rctid>				
				<cfset pr  = cnt-1>
				<cfset nr  = cnt+1>					
			</cfif> 			
			
		</cfloop>
			
		<tr>
			<td colspan="2" class="labelmedium" valign="top" style="border:0px solid silver;background: ##E9E9E9;padding:5px 2px 11px 2px;">
						
			<table width="98%" align="center" class="formpadding">
						
			   <cfif Requisition.workorderid neq "">
		
					<!--- WE IMPLICIT ASSUME THE WORKORDER MODULE IS IN USE --->
				
					<cfquery name="workorder" 
					 datasource="AppsWorkOrder" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT *			
						 FROM   WorkOrder W, Customer C
						 WHERE  W.CustomerId = C.CustomerId
						 AND    W.WorkorderId = '#requisition.workorderid#'
					 </cfquery>	
					
					<tr class="line labelmedium"><td style="padding-left:10px"><cf_tl id="WorkOrder">:</td>
						<td height="18">#workorder.CustomerName# [#workorder.Reference#]</td>
					</tr>				
				
				</cfif>
			
				<tr><td class="labellarge" style="font-size:25px;font-weight:240;height:40px;cursor:pointer;" onclick="$('.clsHeaderDescriptionDetail').toggle();"><a>#EntryClass.Description# / #Requisition.ItemMaster#</a></td></tr>
				<tr class="clsHeaderDescriptionDetail">
				<td class="labelmedium" style="height:20px;padding-left:10px;">#Requisition.RequestDescription# (#Requisition.RequestType#)</td>
				
				<td align="right">
				<table>
					<tr>
					<td style="width:auto">	
					<cfif pr gte "1">
									
					    <cf_tl id="&laquo; Previous" var="1">
						
						<cfquery name="getReq" 
						 datasource="AppsPurchase" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT *			
							 FROM   PurchaseLineReceipt
							 WHERE  ReceiptId = '#myArray[pr]#'						 
						 </cfquery>	
						
					    <input class="button-2019-a" type="button" onclick="openline('#url.mode#','#getReq.RequisitionNo#','#myArray[pr]#','#url.action#','#url.taskid#','#url.tbl#')" name="saveprior" id="savenext" value="#lt_text#">
							
					</cfif>
					</td>
					<td style="width:auto;padding-left:2px">	
					
					<cfif nr lte ArrayLen(myArray)>		
					
						<cfquery name="getReq" 
						 datasource="AppsPurchase" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT *			
							 FROM   PurchaseLineReceipt
							 WHERE  ReceiptId = '#myArray[nr]#'						 
						 </cfquery>	
						 			
					    <cf_tl id="Next &raquo;" var="1">
					    <input class="button-2019-a" type="button" onclick="openline('#url.mode#','#getReq.RequisitionNo#','#myArray[nr]#','#url.action#','#url.taskid#','#url.tbl#')" name="savenext" id="savenext" value="#lt_text#">					
					</cfif>
					
					</td>
					</tr>
				</table>
				</td>
				
				</tr>
				
				<cfif Requisition.WarehouseItemNo neq "">
		
					<cfquery name="Item" 
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT  *			
						 FROM    Item
						 WHERE   ItemNo = '#Requisition.WarehouseItemNo#'				
					 </cfquery>	
					 
					<tr class="clsHeaderDescriptionDetail" style="display:none;">		    
						<td style="height:25px;padding-left:10px" class="labelmedium">#Item.ItemDescription# #Item.Classification#</td>
					</tr>		 
				
				</cfif>
				
				<tr class="clsHeaderDescriptionDetail" style="display:none;">
					<td style="height:20px;padding-left:10px"><cf_getRequisitionTopic RequisitionNo="#URL.reqno#" TopicsPerRow="4"></td>
				</tr>
			
			</table>
               
			</td>
			
		</tr>		
				
		<cfif Requisition.RequestType eq "Warehouse">
	
			<!--- validate the item --->
			
			<cfquery name="checkItem" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT  *
			    FROM    ItemUoM
				WHERE   ItemNo = '#Requisition.WarehouseItemNo#' 
				AND     UoM    = '#Requisition.WarehouseUoM#' 
			</cfquery>	
			
			<cfif checkItem.recordcount eq "0">
			
				<tr>
			    <td></td>
				<td class="labelmedium"><font color="FF0000">Problem: this item (#Requisition.WarehouseItemNo# - #Requisition.WarehouseUoM#) is no longer recorded as a classified item. Please contact your administrator.</font></td>
				</tr>
				
				<cfabort>
					
			</cfif>
				
		</cfif>
		
		</cfoutput>		

		<tr><td colspan="2" height="10"></td></tr>
						
		<tr>
				 
			<td class="labelmedium" width="146" style="padding-left:10px"><cf_tl id="Delivery date">:<font color="FF0000">*</font></td>
				
			<td colspan="3">
				
					<table cellspacing="0" cellpadding="0">
						
					<tr>
					
					<td>
							
						<cfif Line.DeliveryDate eq "">
						
							<cfif url.date neq "undefined" and url.date neq "">
							
								<cfset dt = url.date>
								
							<cfelse>
							
								<cfset dt = dateformat(now(),CLIENT.DateFormatShow)>
							
							</cfif>
					
							<cf_intelliCalendarDate9
								FieldName="DeliveryDate" 
								DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"	
								Default="#dt#"					
								Class="regularxl enterastab"
								AllowBlank="False">	
							
						<cfelse>
						
							<cf_intelliCalendarDate9
								FieldName="DeliveryDate" 
								DateValidEnd="#Dateformat(Line.DeliveryDate, 'YYYYMMDD')#"	
								Default="#Dateformat(Line.DeliveryDate, CLIENT.DateFormatShow)#"					
								Class="regularxl enterastab"
								AllowBlank="False">							
						
						</cfif>	
								
					</TD>	
					
					</table>
					
				</td>
				
			</tr>								
					
			<cfif Purchase.ReceiptDeliveryTime eq "0">
					
					<input type="hidden" name="receiptstarthour" value="12">
					<input type="hidden" name="receiptstartminute" value="00">
					<input type="hidden" name="receiptendhour" value="12">
					<input type="hidden" name="receiptendminute" value="00">
					<input type="hidden" name="deliveryofficer" value="">
										
			<cfelse>
								
			<tr>		
			
			<td class="labelmedium" style="padding-left:10px"><cf_tl id="Delivery by">:<font color="FF0000">*</font></td>
			
			<td colspan="3">
			
					<table cellspacing="0" cellpadding="0">
						
					<tr>
					
					<cfoutput>											
								   
					    <TD style="padding-left:0px">
							<input type="text" name="DeliveryOfficer" id="DeliveryOfficer" value="#Line.DeliveryOfficer#" size="40" maxlength="80" class="regularxl enterastab">
						</TD>									
												
					</cfoutput>
						
					<td class="labelmedium" style="padding-left:14px"><cf_tl id="Arrival">:</td>							
					
					<td style="padding-left:4px">
							
					     <table cellspacing="0" cellpadding="0">
						 <tr>
						 <td>
						 
						 		  <cfset thr = timeformat(Line.DeliveryDate,"HH")>
											
								  <cfinput type = "Text"
							       name       = "receiptstarthour" 
							       value      = "#thr#"
							       maxlength  = "2"
								   message    = "Please enter time using 24 hour format"
							       validate   = "regular_expression"
							       pattern    = "[0-1][0-9]|[2][0-3]"
								   onKeyUp    = "return autoTab(this, 2, event);"
							       size       = "1"
								   required   = "Yes"
							       style      = "text-align: center;width:30"
							       class      = "regularxl enterastab">
																		
							    </td>
								<TD align="center" style="padding-left:1px">:</TD>
							    <td align="center">
								
								<cfset tmin = timeformat(Line.DeliveryDate,"MM")>
							
								<cfinput type = "Text"
							       name       = "receiptstartminute"
							       value      = "#tmin#"
							       message    = "Please enter a valid minute between 00 and 59"
							       maxlength  = "2"
								   validate   = "regular_expression"
							       pattern    = "[0-5][0-9]"
							       required   = "Yes"
								   onKeyUp    = "return autoTab(this, 2, event);"
								   size       = "1"
							       style      = "text-align: center;width:30"
							       class      = "regularxl enterastab">
																			
							    </td>
					
						</table>
						
					</td>													
					<td class="labelmedium" style="padding-left:14px"><cf_tl id="Departure">:</td>								
					<td style="padding-left:4px">						
					
						 <table cellspacing="0" cellpadding="0">
							 <tr>
							 <td>							 
							 		  <cfset thr = timeformat(Line.DeliveryDateEnd,"HH")>
												
									  <cfinput type = "Text"
								       name       = "receiptendhour" 
								       value      = "#thr#"
								       maxlength  = "2"
									   message    = "Please enter time using 24 hour format"
								       validate   = "regular_expression"
								       pattern    = "[0-1][0-9]|[2][0-3]"
									   onKeyUp    = "return autoTab(this, 2, event);"
								       size       = "1"
									   required   = "Yes"
								       style      = "text-align: center;width:30"
								       class      = "regularxl enterastab">
																			
								    </td>
									<TD align="center" style="padding-left:1px">:</TD>
								    <td align="center">
									
									<cfset tmin = timeformat(Line.DeliveryDateEnd,"MM")>
								
									<cfinput type="Text"
								       name="receiptendminute"
								       value="#tmin#"
								       message="Please enter a valid minute between 00 and 59"
								       maxlength="2"
									   validate="regular_expression"
								       pattern="[0-5][0-9]"
								       required="Yes"
									   size="1"
								       style="text-align: center;width:30"
								       class="regularxl enterastab">
																				
								</td>								
								
																
								</tr>
						
						</table>
					
					</td>
					
				
				</tr>										
					
				</table>
				</td>
		</tr>
		
		</cfif>
			
	<cfoutput>	
		
	<tr>
	
	 <td class="labelmedium" style="padding-left:10px"><cf_tl id="Receiving Officer">:<font color="FF0000">*</font></td>	 
	 <td colspan="3">
	 	 					
		<cfset link = "#SESSION.root#/Procurement/Application/Receipt/ReceiptEntry/ReceiptEmployee.cfm?PersonNo=#Line.PersonNo#">	
	
		<table cellspacing="0" cellpadding="0">
		<tr>		
		<td>	
			
		<cfif Line.PersonNo neq "">
			<cfdiv bind="url:#link#&selected=#Line.PersonNo#" id="employee"/>
		<cfelse>
		
			<cfquery name="getUser" 
			   datasource="AppsSystem"
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			 	SELECT  * 
				FROM   UserNames
				WHERE  Account = '#session.acc#' 
			</cfquery>				
			
			<cfif getUser.PersonNo neq "">	
				<cfdiv bind="url:#link#&selected=#getUser.PersonNo#" id="employee"/>	
			<cfelseif Prior.PersonNo neq "">
				<cfdiv bind="url:#link#&selected=#Prior.PersonNo#" id="employee"/>
			<cfelse>
			    <cfdiv bind="url:#link#&selected=" id="employee"/>	
			</cfif>
			
		</cfif>	
				
		</td>		
		<td>		
				
		   <cf_selectlookup
			    box        = "employee"
				link       = "#link#"
				button     = "Yes"
				icon       = "search.png"
				iconwidth  = "26"
				iconheight = "26"				
				close      = "Yes"
				type       = "employee"
				des1       = "Selected">	
						
		</td>
		</table>
		
	</td>
		 	
	</tr>
			
	<cfif Line.receiptVolume neq "0">
	
		<tr>		
		 <td class="labelmedium" style="padding-left:10px"><cf_tl id="Total volume">:<font color="FF0000">*</font></td>	 
		 <td colspan="3">	 
				<cfoutput>
				<input type="text" id="receiptvolume" name="receiptvolume" value="#Line.ReceiptVolume#" 
				   style="text-align:right;padding-right:3px" class="regularxl" size="5">
				</cfoutput>M3
		 </td>				 
		</tr> 
	  
	<cfelse>
	
		<input type="hidden" name="receiptvolume" value="0">  
	
	</cfif>
							
	<cfquery name="hasTopics" 
	   datasource="AppsMaterials"
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Ref_Topic T, Ref_TopicEntryClass C
		  WHERE    T.Code        = C.Code								  
		  AND      EntryClass    = '#Requisition.EntryClass#' 
		  AND      T.Operational = 1
		  AND      C.ItemPointer = 'UoM'
	</cfquery>
	
	<cfquery name="getClassification" 
	   datasource="AppsMaterials"
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	 	 SELECT  * 
		 FROM    ItemClassification 
		 WHERE   ItemNo = '#Line.WarehouseItemNo#' 
	</cfquery>	
			
	<cfset selectmode = "regular">
	
	<cf_verifyOperational module="Warehouse" Warning="No">
		
		<cfif Operational eq "1">
		
		     <cfquery name="getItem" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT *			
				 FROM   Item
				 WHERE  ItemNo = '#Requisition.WarehouseItemNo#'
			 </cfquery>								 
			 
			 <cfif (Requisition.requestType neq "Warehouse" 
			    or (Requisition.requestType eq "Warehouse" and getItem.ItemClass eq "Service"))
				or (Requisition.EnforceWarehouse eq "2")>
																
				 <cfset requestHasWarehouseItem = "No"> <!--- we allow the classified item to be selected here --->			 
				 
		     <cfelse>		 
			
			 	<cfset requestHasWarehouseItem = "Yes"> <!--- we do NOT allow the classified item to be selected here --->
			 
			 </cfif>					 			 
								   
			<cfif requestHasWarehouseItem eq "No"
			     and (url.taskid eq "" and Line.WarehouseTaskid eq "")>
						
				<!--- if the requisition request type = warehouse or purchase created (shipping) the item has beenis entered from the receipt list and no need to define it ---> 		
			  
				<TR>
			    <TD width="100" class="labelmedium" style="padding-left:10px"><cf_tl id="Item mode">:<font color="FF0000">*</font></TD>
			    <TD colspan="3">	
					<table width="100%" align="center">
					<tr>
					<td height="23">															
										
						<table>					
						
						<cfif Requisition.EnforceWarehouse eq "0">
												
						  <!--- if enforce warehouse eq "0" we allow just regular service items to be recorded ---> 		
				   										
						  <tr><td style="padding-left:5px">
						 		
					    	<input type="radio" 
								  name="requesttype" 
								  id="requesttype1"
								  class="enterastab radiol"
								  value="regular" <cfif Line.WarehouseItemNo eq "">checked</cfif> 
								  onClick="javascript:res('regular')">
							  
						 	 </td>					 
							 <td class="labelmedium" style="padding-left:7px;padding-top:2px">
							 <table><tr><td class="labelmedium"><cf_tl id="Non classified item"></td></tr></table>
							 </td>											
						  
						    <td style="padding-left:8px">
													
							<input type="radio" 
							       name="requesttype" 
								   id="requesttype2"
								   value="Warehouse" 
								   class="enterastab radiol"
								   <cfif selectmode eq "warehouse" or Line.WarehouseItemNo neq "" or Requisition.RequestType eq "Warehouse">checked</cfif> 
								   onClick="javascript:res('warehouse')">
							   
							</td>	
												
							<td style="padding-left:7px;padding-top:2px" class="labelmedium"><cf_tl id="Select Stock Item"></td>
							
						</tr>
													  
					   <cfelseif Requisition.EnforceWarehouse eq "1">
					   					   						 					 
						    <!--- this scenario is unlikely to happen as the mode above 
							      would have forced the requisition to be associated to a line but we categor for it --->
												 
						 	<cfset selectmode = "warehouse"> 
							
							<tr>
						  
						    <td style="padding-left:5px">
											
							<input type="radio" 
						       name="requesttype" 
							   id="requesttype3"
							   class="enterastab radiol"
							   value="Warehouse" checked
							   onClick="javascript:res('warehouse')">
							   					   
							</td>						
							<td style="padding-left:2px;padding-top:2px" class="labelmedium"><i><cf_tl id="Select Stocking Item"></td>
							
							</tr>
							
					   <cfelseif Requisition.EnforceWarehouse eq "2">					  		
					   					   					   
					   		<!--- WE enforce warehouse selection or THE GENERATION OF THE WAREHOUSE ITEM ---> 		
				   								 				 
						 	<cfset selectmode = "warehouse">	
																					
							<!--- ----------------------------------------------------------------------------------- --->
							<!--- determine of the item has a potential classification and/or existing topics already --->
							<!--- ----------------------------------------------------------------------------------- --->
							<!--- ----------------------------------------------------------------------------------- --->
							<!--- if the request is for a workorder in which stock management is 0, then deviation--- ---> 
							<!--- is not allowed but only if the requisition is for a resource----------------------- ---> 
							
							<cfset allowstockvariation = "1">
							
							<cfif Requisition.workorderid neq "" and Requisition.workorderline neq "">
							
								<cfquery name="getLine" 
								datasource="AppsWorkOrder" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   R.PointerStock
									FROM    WorkOrderLine W
											INNER JOIN   WorkOrderLineResource WL 
												ON  W.WorkOrderId = WL.WorkOrderId AND W.WorkOrderLine = WL.WorkOrderLine
											LEFT OUTER JOIN Ref_ServiceItemDomainClass R 
											 	ON W.ServiceDomain = R.ServiceDomain AND W.ServiceDomainClass = R.Code
									WHERE    WL.WorkOrderId   = '#Requisition.workorderid#' 
									AND      WL.WorkOrderLine = '#Requisition.workorderline#'
									AND      WL.ResourceId    = '#Requisition.RequirementId#'
								</cfquery>
								
								<cfif getLine.pointerStock neq "1">
									<cfset allowstockvariation = "0">
								</cfif>
							
							</cfif>
							
							<!--- ----------------------------------------------------------------------------------- --->
																																				
							<cfif hasTopics.recordcount gte "1" and allowstockvariation eq "1" and
							      (getClassification.recordcount gte "1" 
								       or Requisition.WarehouseItemNo eq "" 
									   or getItem.ItemClass eq "Service")>							   
							 
								<cfset modewarehouseitem = "generate">
															
							<cfelse>
							
								<cfset modewarehouseitem = "select">	
							
							</cfif>		
																											 
						 	<tr>
						  
							    <td style="padding-left:5px" width="20">
															
								<input type="radio" 
							       name="requesttype" 
								   id="requesttype4"
								   class="enterastab radiol"
								   value="Warehouse"  <cfif modewarehouseitem eq "select">checked</cfif> 
								   onClick="javascript:res('warehouse')">
								   
								</td>	
																				
								<td class="labelmedium" style="padding-left:6px;padding-top:2px"><cf_tl id="Select Stock Item"></td>						
							
														
							<!--- show this option only if topics are enabled for this entry class we provide this feature --->
						
								
							<cfif hasTopics.recordcount gte "1">
																
								   <td style="padding-left:9px">
								   
							    	<input type = "radio" 
									  name      = "requesttype" 
									  id        = "requesttype5"
									  class     = "enterastab radiol"
									  value     = "Generate"  <cfif modewarehouseitem eq "generate">checked</cfif>  
									  onClick   = "javascript:res('generate')">
									  
								   </td>
								 
								   <td style="padding-left:6px;padding-top:2px" class="labelmedium"><cf_tl id="Define Classified Stock item"></td>
								  
								</tr>	
							
							</cfif>		
													 					 
						 </cfif> 
																	
						 </table>
				   
					   </td>	
					   </tr>
					   
				   </table>
				   
				 </td>
				 </tr>  
				 
				
			<cfelse>		
																	  
			   	<input type="hidden" name="requesttype" id="requesttype6" value="Warehouse">										
				
			</cfif>					
										
		<cfelse>
											
		       <input type="hidden" name="requesttype" id="requesttype7" value="Regular">					 						
			   
		</cfif>		
		
			
	<cfif requestHasWarehouseItem eq "Yes">	
	
		    <!--- if the request has an enforced warehouse entry, we do not allow it to be changed here, just to enter a quantity
			which is usually combined with a no dialog entry --->				
																			
			<cfset clw = "regular">	  <!--- warehouse/lot selector --->
			<cfset cli = "hide">	  <!--- manual entry of product code --->
			<cfset clr = "hide">      <!--- manual entry of UoM ---> 											
			<cfset cla = "regular">	  <!--- warehouse item selection option --->		
			<cfset clc = "hide">	  <!--- warehouse item generation --->								
	
	
	<!--- I removed this option, 12/3/2014 as I don't think it has merits anymore :Hanno
		
	<cfelseif Purchase.ReceiptEntry eq "0">	<!--- dialog is disabled for initial entry, but a listing is presented --->
		
		    <!--- if dialog entry is disabled or we have a warehouse item driven requisition; we don't touch the
			receipt warehouse item and do not allow for selection of the item as this is driven by the dialog --->				
																					
			<cfset clw = "regular">		<!--- warehouse/lot selector --->
			<cfset cli = "regular">		<!--- manual entry of product code --->
			<cfif Requisition.RequestType eq "warehouse">				
				<cfset clr = "hide">   <!--- manual entry of UoM ---> 				
			<cfelse>
				<cfset clr = "regular">				
			</cfif>			
			<cfset cla = "hide">	  <!--- warehouse item selection option --->		
			<cfset clc = "hide">	  <!--- warehouse item generation --->		
			
	--->		
							
			
	<cfelseif url.taskid neq ""  <!--- coming from a taskorder so we need to select a warehouse --->
	      or Selectmode eq "warehouse"  	       		  
		  or (url.action eq "new" and requestHasWarehouseItem eq "Yes")>
		  
			<cfparam name="modewarehouseitem" default="select">	
		 		 			 		  		  		 		  
			<cfset clw = "regular">   <!--- warehouse/lot selector --->
			<cfset cli = "hide">      <!--- manual entry of product code --->
			<cfset clr = "hide">      <!--- manual entry of UoM --->
			
			<cfif modewarehouseitem eq "generate">					
			
				<cfset cla = "hide">      <!--- warehouse item selection option --->		
				<cfset clc = "regular">   <!--- warehouse item generation --->
			<cfelse>
			
				<cfset cla = "regular">   <!--- warehouse item selection option --->		
				<cfset clc = "hide">      <!--- warehouse item generation --->
			</cfif>	
													
	<cfelse>	
							
			<cfset clw = "hide">      <!--- warehouse/lot selector --->
			<cfset cli = "regular">   <!--- manual entry of product code --->
			<cfset clr = "regular">	  <!--- manual entry of UoM --->
			<cfset cla = "hide">	  <!--- warehouse item selection option --->	
			<cfset clc = "hide">      <!--- warehouse item generation --->				
						
	</cfif>		
		
	<!--- if this is warehouse action we allow for selection of the warehouse --->		
	
	<cfif Param.LotManagement eq "1">
	
		<tr id="whs" class="#clw#">
		
			<td class="labelmedium" width="100" style="padding-left:10px"><cf_tl id="Production Lot">:</td>
		
		    <td>
			
				<table cellspacing="0" cellpadding="0">
				
				   <tr>
				
				      <td>
			            <input type = "text"
				       	   name     = "TransactionLot"
			               id       = "TransactionLot"
					       value    = "<cfif line.transactionlot neq "">#Line.TransactionLot#<cfelse>#Prior.TransactionLot#</cfif>"
					       size     = "14"					
						   class    = "regularxl enterastab" 					     
					       style    = "text-align:right;padding-top:1px;padding-right:2px">
					  </td>
						   
					  <td id="TransactionLot_content" class="labelmedium" style="padding-left:3px;width:20">
						<cf_securediv bind="url:#session.root#/tools/process/stock/getLot.cfm?mission=#Purchase.mission#&transactionlot={TransactionLot}">
					  </td>
						   
				   </tr>
						   
			    </table>
												  
			</td>
		</tr>
	
	</cfif>	  
	
	<tr id="whs" class="#clw#">
	
		<td class="labelmedium" width="100" style="padding-left:10px"><cf_tl id="Site">:</td>
		<td colspan="3">			
						
		   <!--- define relevant warehouses for the item shipped --->
			
			<cfif Requisition.WarehouseItemNo eq "">
			
				<cfset whslimitlist = "">
				
				<cfquery name="Warehouse" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Warehouse
					WHERE  Mission = '#Purchase.Mission#'	
					AND    WarehouseClass IN (SELECT Code 
				                              FROM   Ref_WarehouseClass
										      WHERE  ExternalReceipt = 1)	
					AND (
						 Operational = 1 	 	
						 OR Warehouse = '#Line.Warehouse#'	<!--- already selected warehouse to be shown here for sure --->		
						)								
				</cfquery>	
								
			<cfelse>
			
				<cfquery name="item" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Item
						WHERE  ItemNo = '#Requisition.WarehouseItemNo#'								
				</cfquery>	
				
				<!--- determine if we can indeed receive this item into this warehouse based on the modeSetItem settings --->
				
				<cfquery name="Ware" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
																			    
						SELECT *
					    FROM   Warehouse
						WHERE  Mission = '#Purchase.Mission#'	
						AND    Operational = 1
						AND    ModeSetItem = 'Always'
						
						UNION
						
						SELECT *
					    FROM   Warehouse
						WHERE  Mission = '#Purchase.Mission#'	
						AND    Operational = 1
						AND    ModeSetItem = 'Category'						
						AND    Warehouse IN (SELECT Warehouse 
						                     FROM   WarehouseCategory 
											 WHERE  Category    = '#item.category#'
											 AND    Operational = 1)	
											 
						UNION
						
						SELECT *
					    FROM   Warehouse W
						WHERE  Mission = '#Purchase.Mission#'	
						AND    ModeSetItem = 'Location'		
						AND    Operational = 1				
						AND    Warehouse IN (SELECT Warehouse 
						                     FROM   ItemWarehouseLocation 
											 WHERE  Warehouse  = W.Warehouse
											 AND    ItemNo     = '#Requisition.WarehouseItemNo#')										 									 												 
											 
				</cfquery>
								
				<cfset whslimitlist = quotedValueList(ware.Warehouse)>
															
				<cfquery name="Warehouse" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Warehouse
					WHERE  Mission = '#Purchase.Mission#'	
					AND    WarehouseClass IN (SELECT Code 
				                              FROM   Ref_WarehouseClass
										      WHERE  ExternalReceipt = 1)	
					AND (
						 ( 
						   Operational = 1 <cfif whslimitlist neq ""> AND Warehouse IN (#preservesingleQuotes(whslimitlist)#) </cfif>		
						 ) 	
						 OR Warehouse = '#Line.Warehouse#'	<!--- already selected warehouse to be shown here for sure --->		
						)	
						
							
											
				</cfquery>	
				
				<cfif warehouse.recordcount eq "0">
				
				<cfquery name="Warehouse" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Warehouse
					WHERE  Mission = '#Purchase.Mission#'						
					AND (
						 ( 
						   Operational = 1 <cfif whslimitlist neq ""> AND Warehouse IN (#preservesingleQuotes(whslimitlist)#) </cfif>		
						 ) 	
						 OR Warehouse = '#Line.Warehouse#'	<!--- already selected warehouse to be shown here for sure --->		
						)						
											
				</cfquery>	
							
				
				</cfif>	
			
			</cfif>
			
			<cfquery name="Last" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT       Warehouse
				FROM         PurchaseLineReceipt
				WHERE        ActionStatus <> '9' 
				AND          Warehouse IN (SELECT Warehouse 
				                           FROM   Materials.dbo.Warehouse 
										   WHERE  Mission = '#Purchase.mission#')	
																   		
				ORDER BY Created DESC				
			</cfquery>	
										
			<select name="warehouse" id="warehouse" class="regularxl enterastab"
			     onchange="ptoken.navigate('setReceiptLinePrice.cfm?purchaseno=#purchase.purchaseno#&warehouse='+this.value+'&itemno='+document.getElementById('itemno').value+'&uom='+document.getElementById('itemuom').value,'processlines')">
				 
				<cfloop query="warehouse">
				
					<!--- validate access to the warehouse --->
				
				    <cfinvoke component = "Service.Access"  
					   method           = "ProcRI" 
					   missionorgunitid = "#missionorgunitid#" 
					   returnvariable   = "access">	
					   					   									
					    <cfif URL.action eq "new">
						
						    <cfif url.taskid eq "">
														
								<cfif access eq "EDIT" or access eq "ALL">   
								
								    <cfif Warehouse eq Requisition.Warehouse> 
									    <option value="#Warehouse#" selected>#WarehouseName#</option>
									<cfelseif Warehouse eq Last.Warehouse>
									    <option value="#Warehouse#" selected>#WarehouseName#</option>
									<cfelse>
										<option value="#Warehouse#">#WarehouseName#</option>
									
									</cfif>	
									
								</cfif>
							
							<cfelse>
							
								<option value="#Warehouse#" <cfif Warehouse eq TaskOrder.ShipToWarehouse>selected</cfif>>#WarehouseName#</option>
								
							</cfif>						
							
						<cfelse>
						
							<cfif access eq "EDIT" or access eq "ALL" or Warehouse eq Line.Warehouse>  
							<option value="#Warehouse#" <cfif Warehouse eq Line.Warehouse>selected</cfif>>#WarehouseName#</option>
							</cfif>
							
						</cfif>
					
					
				</cfloop>
				
			</select>
			
		</td>	    	
			 
	</tr>	
	
	<!--- hidden fields : multiplier is better to determine a submission --->
	
	<input type="hidden" name="ReceiptMultiplier" id="ReceiptMultiplier" value="#mul#"       size="20"   maxlength="20">
    <input type="hidden" name="RequisitionNo"     id="RequisitionNo"     value="#URL.reqno#" size="20"   maxlength="20">
	
	<!--- we have several modes
	
	receipt of item which is a service item or a not classified item

	receipt of an item which is a stock item

	receipt on an open contract recording which can be recorded as a stock item, 
	    extended with creation of a stock item as part of the entry (lisa mode)
		
    extended receipt in lines like fuel	
	
	--->			
	 
	<TR>
	    <TD class="labelmedium" valign="top" style="min-width:120px;padding-top:5px;padding-left:10px"><cf_tl id="Product Code">:</TD>
		
		<!--- ---------------------------------------- --->
		<!--- ---------------regular mode------------- --->
		<!--- ---------------------------------------- --->
								
	    <TD id="whs1" class="#cli#">
								
			 <table cellspacing="0" cellpadding="0">
			 <tr><td>								
		     <input type="Text" class="regularxl enterastab" name="receiptitemno" id="receiptitemno"  value="#no#" size="25" maxlength="25">				 
			 </td>		 					 
			 </tr>
			 </table>			 			    
			 
		</TD>
		
		<!--- ---------------------------------------- --->
		<!--- ---- ----- end of regular mode --------- --->
		<!--- ---------------------------------------- --->
							
		<!--- ---------------------------------------- --->
		<!--- --------warehouse item selection ------- --->
		<!--- ---------------------------------------- --->		
										
		<TD id="whs2" class="#cla#" colspan="2">
											
			    <cf_dialogMaterial>
				
				<table cellspacing="0" cellpadding="0">
				
				<tr>
								
				<td id="itembox" class="labelmedium">					
												
					<cfif URL.action eq "new">										
									
						<cfif url.taskid eq "">						
												
							<!--- we set the item based on the requisition item and if the requisitionline does not have an item defined
							we allow for selection of the item  --->	
																																											
							<cfif requestHasWarehouseItem eq "Yes" or requisition.EnforceWarehouse gte "1">
																																						
								<table cellspacing="0" cellpadding="0">
								<tr><td>								
								<input type="text"   name="itemno"  id="itemno"                   value="#Requisition.WarehouseItemNo#"     class="regularxl" size="6"   readonly>
								</td>
								<td style="padding-left:3px">
							    <input type="text"   name="itemdescription" id="itemdescription"  value="#Requisition.RequestDescription#"  class="regularxl" size="40"  readonly>
								</td>
													
								<td class="labelmedium" style="padding-left:14px;padding-right:4px"><cf_tl id="Stock as">:</td>
								<td style="padding-left:3px">
																								
								<cfquery name="UoMList" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT *
								    FROM   ItemUoM
									WHERE  ItemNo = '#Requisition.WarehouseItemNo#'		
									AND    Operational = 1		
								</cfquery>	
								
								<cfif UoMList.recordcount eq "0">
								
									<cfquery name="UoMList" 
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT *
									    FROM   ItemUoM
										WHERE  ItemNo = '#Requisition.WarehouseItemNo#'													
									</cfquery>	
																
								</cfif>
								
								<cfif UoMList.recordcount gte "2">
								
									<!--- in case of open contract we need to show the standard --->
											
									<select name="itemuom" class="regularxl enterastab">
										<cfloop query="UoMList"><option value="#uoM#" <cfif UoM eq Requisition.WarehouseUoM>selected</cfif>>#UoMDescription#</option></cfloop>
									</select>	
								
								<cfelse>	
																															
									<input type="text"   name="uomname" id="uomname"                  value="#Requisition.QuantityUoM#"         class="regularxl" size="10"  readonly 
									     style="background-color:eaeaea;padding-left:2px;text-align: left;">
										 										 
									<input type="hidden" name="itemuom" id="itemuom"                  value="#Requisition.WarehouseUoM#">	
																	
								</cfif>
								
																
								</td></tr>
								</table>							
							
							<cfelse>							
																									
								<input type="text"   name="itemno" id="itemno"                   value=""  class="regularxl" size="4"   readonly>
							    <input type="text"   name="itemdescription" id="itemdescription" value=""  class="regularxl" style="background-color:eaeaea;padding-left:2px;text-align: left;" size="40"  readonly>
								<input type="hidden" name="itemuom" id="itemuom"                 value="">						
								<input type="text"   name="uomname" id="uomname"                 value=""  class="regularxl" size="10"  readonly style="padding-left:2px;text-align: left;">
								
														
							</cfif>		
																
						<cfelse>
																		
						     <cfquery name="Item" 
							 datasource="AppsMaterials"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT * 
								 FROM   Item
								 WHERE  ItemNo = '#TaskOrder.ItemNo#'										 
							 </cfquery>
							
							 <cfquery name="ItemUoM" 
							 datasource="AppsMaterials"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT * 
								 FROM   ItemUoM
								 WHERE  ItemNo = '#TaskOrder.ItemNo#'
								 AND    UoM    = '#TaskOrder.UoM#'						 
							 </cfquery>
							
							#Item.ItemDescription# (#ItemUoM.UoMDescription# #ItemUoM.ItemBarCode#)
																					
							<!--- we set the item based on the tasked item --->
							
							<input type="hidden"   name="itemno"          id="itemno"          value="#TaskOrder.ItemNo#">
						    <input type="hidden"   name="itemdescription" id="itemdescription" value="#Item.ItemDescription#" >
							<input type="hidden"   name="itemuom"         id="itemuom"         value="#TaskOrder.UoM#">						
							<input type="hidden"   name="uomname"         id="uomname"         value="#ItemUoM.UoMDescription#">
																			
						</cfif>					
				
					<cfelse>
					
						<cfquery name="Currency" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   CurrencyMission
							WHERE  Mission = '#Purchase.Mission#' 
						</cfquery>
						
						<cfif currency.recordcount eq "0">
					
						    <cfquery name="Currency" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM   Currency
								WHERE  EnableProcurement = '1'
							</cfquery>
						
						</cfif>
			
						<!--- existing value --->		
						
						<cfif Line.WarehouseUoM neq "">
						
						 <cfquery name="ItemUoM" 
							 datasource="AppsMaterials"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								 SELECT * 
								 FROM   ItemUoM
								 WHERE  ItemNo = '#Line.WarehouseItemNo#'
								 AND    UoM    = '#Line.WarehouseUoM#'						 
							 </cfquery>
						
						
						<table>
						<tr>
						<td>
						
					    <input type="text"   name="itembarcode"      id="itembarcode"     value="#ItemUoM.ItemBarCode#"    size="15"  class="regularxl" readonly style="text-align: center;">
						</td>						
						<td style="padding-left:3px">
					    <input type="text"   name="itemdescription"  id="itemdescription" value="#Line.ReceiptItem#"       size="50"  class="regularxl" readonly style="text-align: left;">
						</td>
						<td style="padding-left:3px">		
						<input type="text"   name="itemno"           id="itemno"          value="#Line.WarehouseItemNo#"   size="6"   class="regularxl" readonly style="text-align: left;">
						</td>
						<!---
						<td class="labelmedium" style="padding-left:14px;padding-right:4px"><cf_tl id="Stock"></td>
						--->
						<td style="padding-left:3px" title="UoM of the stock requisition">
						<input type="text"   name="uomname"          id="uomname"         value="#ItemUoM.UoMDescription#" size="10"  class="regularxl" readonly style="background-color:eaeaea;padding-left:2px;text-align: left;">
						</td>
						<td style="padding-left:3px">
						
						      <cfif Line.WarehouseCurrency neq "">							 
							  	<cfset cur = Line.WarehouseCurrency>
							  <cfelse>							
							  	<cfset cur = application.baseCurrency>	
							  </cfif>
																		
							<select name="warehousecurrency" id="warehousecurrency" class="regularxl enterastab"
							    size="1" onchange="setstockline('1','#Line.RequisitionNo#',document.getElementById('WarehouseReceiptUoM').value,document.getElementById('receiptquantity').value,document.getElementById('warehouseprice').value,'editcurrency','#itemUoM.UoM#',this.value)">					
							    <cfloop query="currency">
									<option value="#Currency#" <cfif Currency eq cur>selected</cfif>>
						    		#Currency#
								</option>
								</cfloop>
						    </select>
						
						</td>
						
						<cfset vWarehousePrice = Line.WarehousePrice >
						<cfif vWarehousePrice eq "">
							<cfset vWarehousePrice = 0> 
						</cfif>
						<td style="padding-left:3px" title="Stock value cost price: use only if you need to overwrite the procurement calculated cost price">
						<input type="text"   name="warehouseprice"          id="warehouseprice"         value="#vWarehousePrice#" size="10"  class="regularxl" style="text-align: right;"
						onchange="setstockline('1','#Line.RequisitionNo#',document.getElementById('WarehouseReceiptUoM').value,document.getElementById('receiptquantity').value,this.value,'editprice','#itemUoM.UoM#',document.getElementById('warehousecurrency').value)">
						</td>
						 
						<cfset wto = vWarehousePrice*Line.ReceiptWarehouse>
						
												
						<td style="padding-left:3px" class="labelmedium2">##</td>
						
						<td style="padding-left:3px" title="Quantity to Warehouse" class="labelmedium2">
							<input type="text"   name="warehousequantity"   readonly   id="warehousequantity"   value="#Line.ReceiptWarehouse#" size="7"  class="regularxl" style="background-color:f1f1f1;text-align: right;">						
						</td>
						
						<td style="padding-left:3px;padding-right:4px" class="labelmedium2"><cf_tl id="$"></td>
						
						<td style="padding-left:3px" title="Calculated stock value">
						<input type="text"   name="warehousetotal"   readonly   id="warehousetotal"         value="#numberformat(wto,",.__")#" size="10"  class="regularxl" style="background-color:f1f1f1;text-align: right;">
						</td>
						
						<td id="boxordermultiplier_1"></td>					
						
						</tr>
						</table>
						<input type="hidden" name="itemuom"          id="itemuom"         value="#Line.WarehouseUoM#">
						
						<cfelse>	
							
						<cfset vWarehousePrice = 0>			
								
						<table cellspacing="0" cellpadding="0">
						<tr><td>																
						<input type="text"   name="itemno"           id="itemno"          value="#Line.WarehouseItemNo#" size="4"   class="regularxl" readonly style="text-align: left;">
						</td><td style="padding-left:3px">
					    <input type="text"   name="itemdescription"  id="itemdescription" value="#Line.ReceiptItem#"     size="40"  class="regularxl" readonly style="text-align: left;">
						</td><td class="labelmedium" style="padding-left:14px;padding-right:4px"><cf_tl id="Stock as">:</td>
						<td style="padding-left:3px">
						<input type="hidden" name="itemuom"          id="uomname"         value="#Line.WarehouseUoM#">
						<input type="text"   name="uomname"          id="itemuom"         value="#Line.ReceiptUoM#"      size="10"  class="regularxl" readonly style="text-align: left;">
						</td>
						<td style="padding-left:3px">
						
							<select name="warehousecurrency" id="warehousecurrency" class="regularxl enterastab"
							    size="1">				    
								<cfloop query="currency">
									<option value="#Currency#" <cfif Currency eq Line.WarehouseCurrency>selected</cfif>>
						    		#Currency#
								</option>
								</cfloop>
						    </select>
						
						</td>
						<td style="padding-left:3px">
						<input type="text"   name="warehouseprice"          id="warehouseprice"         value="#vWarehousePrice#" size="10"  class="regularxl" style="text-align: right;">
						</td>
						
						<cfset wto = vWarehousePrice*Line.ReceiptWarehouse>
						
						<td style="padding-left:3px">
						
						<input type="text"   name="warehousetotal"          id="warehousetotal"         value="#numberformat(wto,",.__")#" size="10"  class="regularxl" style="text-align: right;">
						</td>
						
						
						</tr></table>
						
						</cfif>
						
					</cfif>
					
				</td>
				
				
				 <!--- we allow for selection of the warehouse item  ---> 
								
			   	 <cfif url.taskid eq "" and line.WarehouseTaskid eq "" and requestHasWarehouseItem eq "No">
				 				
					  <td style="padding-left:4px;padding-top:2px">
										
						<!--- trigger the method upon saving to check the price --->	
										 
						<script>
											
						  function processwhsselect(uomid,scope) {		
						  						      		  						      						       						      								 								     
						       ptoken.navigate('#session.root#/Procurement/Application/Receipt/ReceiptEntry/setReceiptLinePrice.cfm?itemuomid='+uomid+'&purchaseno=#purchase.purchaseno#&warehouse='+document.getElementById('warehouse').value,'processlines')				  							  							 
														   
							   if (document.getElementById('stockuombox')) {									 			   
							      ptoken.navigate('#session.root#/Procurement/Application/Receipt/ReceiptEntry/setWarehouseUoM.cfm?requisitionno=#url.reqno#&itemuomid='+uomid,'stockuombox')								   
							   }
							   						   
						  }
						  
						</script> 							
						
						<!--- alert we need to adjust the selection screen of the UoM  on line if the item changes --->																											
						
						<cf_img icon="open" onClick="selectwarehouseitem('#Purchase.mission#','','#Requisition.ItemMaster#','processwhsselect','')">	 
						
											 
					 </td>
					 
					 <td width="3"></td>
					 
				 
				</cfif>
				
				</tr>
				</table>  
						
				<input type="hidden" name="requestquantity"   id="requestquantity"   value=""> 
				<input type="hidden" name="requestamountbase" id="requestamountbase" value="">  					
				
		</TD>		
		<!--- --------------------------------------------- --->
		<!--- -----------end of warehouse mode------------- --->
		<!--- --------------------------------------------- --->
		
		<!--- --------------------------------------------- --->
		<!--- -------warehouse item generation mode ------- --->
		<!--- --------------------------------------------- --->		
		
		</tr>
		
		<tr id="whs3" class="#clc#">	
								
			<td></td>						 
		    <TD colspan="3" style="padding-left:0px">	
			
				<cfparam name="hasTopics.recordcount" default="0">
			
				<cfif hasTopics.recordcount gte "1">
							
					<!--- show here the classifications as defined for the entry class to be set --->
					<cfset url.itemNo   = Line.WarehouseItemNo>
					<cfset url.UoM      = Line.WarehouseUoM>			
					<cfinclude template = "ReceiptLineEditFormTopic.cfm">
				
				</cfif>
			    		    			 
			</TD>
				
		</TR>	
	   						
	<!--- ------------------------------ --->
	<!--- ----end of warehouse mode----- --->
	<!--- ------------------------------ --->	
					
	<!--- this is the ajax process box for price and quantity definition based on the selections made --->
	<tr class="hide"><td colspan="4" id="processlines"></td></tr>	
	
	<!--- ------ CUSTOM FORM ----------- --->
	<!--- ------------------------------ --->
	<!--- get the default number of rows --->
	<!--- ------------------------------ --->
		
	<cfif url.taskid eq "" and (Purchase.ReceiptEntryForm neq "Fuel" and Purchase.ReceiptEntryForm neq "Standard" and Purchase.ReceiptEntryForm neq "Fabric")>
	  	<cfset rows = "0">
	<cfelse>
	  	<cfset rows = "#Purchase.ReceiptEntryLines#">
	</cfif>	
		

	<cfif rows lte "0" or Purchase.ReceiptEntryForm eq "">
	
		<!--- nada --->
		
	<cfelseif Purchase.ReceiptEntryForm eq "Standard" or Purchase.ReceiptEntryForm eq "Fabric">

		<tr>
		<td></td>	
		
		<cfif rows gt "6">
		    <td colspan="3" height="140">
			<cf_divscroll>
				<cfinclude template="ReceiptEntryContentLinesStandard.cfm">		
			</cf_divscroll>
			</td>
			
		<cfelse>
		   <td colspan="3">
		   <cfinclude template="ReceiptEntryContentLinesStandard.cfm">		
		   </td>
		   
		</cfif>
						
		</tr>
		
	<cfelseif Purchase.ReceiptEntryForm eq "Fuel">	
		
		<tr><td height="4"></td></tr>		
		<tr>				
		<td colspan="4" style="padding-left:10px;padding-right:10px">					
		<!--- eliminado --->
		<cfinclude template="ReceiptEntryContentLinesFuel.cfm">	
		</td>		
		</tr>
		
		<cfset clr = "hide">
		
		<tr><td colspan="3" height="4"></td></tr>
	
	</cfif>	
	
	
	<TR>
    <TD class="labelmedium" style="padding-top:0px;padding-left:10px"><cf_tl id="Quantity">:<font color="FF0000">*</font></TD>
    <TD colspan="3">
	
	 <table cellspacing="0" cellpadding="0"><tr><td>
	
	 <cfif rows gte "1">
	 
	 	  <input type  = "Text" 
			  name     = "receiptquantity" 
			  id       = "receiptquantity"
			  value    = "#qty#" 		  
			  validate = "float" 
			  class    = "regularxxl enterastab"		  
			  size     = "16" 
			  style    = "background-color:silver;text-align: right;padding-right:4px" 
			  readonly>
	 
	 <cfelse>
	 
	 	<cfset chg = "setstockline('1','#Line.RequisitionNo#',document.getElementById('WarehouseReceiptUoM').value,this.value,document.getElementById('warehouseprice').value,'quantityline',document.getElementById('itemuom').value,document.getElementById('warehousecurrency').value)">
	
   	 	 <cfinput type="Text" 
			  name="receiptquantity" 
			  id="receiptquantity"
			  value="#qty#" 
			  message="Enter a valid quantity" 
			  validate="float" 
			  class="regularxxl enterastab"
			  required="Yes" 
			  size="12" 
			  style="background-color:ffffaf;font-size:24px;text-align: right;padding-right:4px" 
			  range="1,10000000"
			  onChange="#chg#;calc(this.value,document.getElementById('receiptprice').value,document.getElementById('receiptdiscount').value,document.getElementById('receipttax').value,document.getElementById('taxincl').value,document.getElementById('exchangerate').value,document.getElementById('taxexemption').value,document.getElementById('taxexemption').value)">
		  
	 </cfif>	
	 	 
	 </td>	
	 	 	 		
	 	   <cfif Requisition.RequestType eq "warehouse" and 
		         Requisition.WarehouseUoM neq "" and 
				 clr eq "Hide" and  <!--- the other UoM is not shown, we we have passed logic --->
				 Purchase.OrderMultiplier gte "1"> <!--- we have a proper based ther we don't know how to compare the purchase UoM --->		
				 
						 				 
				 			 
			   <cfif Line.WarehouseUoM eq "">
			   
			       <cfset whsitm = Requisition.WarehouseItemNo>
			       <cfset whsuom = Requisition.WarehouseUoM>				  
				  				   
			   <cfelse>
			   
				   	<cfquery name="getUoM" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   ItemUoM
						WHERE  ItemNo = '#Line.WarehouseItemNo#'				
						AND    UoM    = '#Line.ReceiptUoM#'
					</cfquery>	
					
					<cfif getUoM.recordcount eq "1">			   
					   <!--- we take the valid UoM of the warehouse item as it is actually received in this receipt --->
					   <cfset whsitm = getUoM.ItemNo>
				   	   <cfset whsuom = getUoM.UoM>
					   
					<cfelse>
					   <!--- we take the UoM of the WarehouseItem --->	
					   <cfset whsitm = Line.WarehouseItemNo>				   
					   <cfset whsuom = Line.WarehouseUoM>
					</cfif> 
					  
			   </cfif>
			 
			 <td style="padding-left:4px" id="stockuombox" valign="bottom">	
			 			 
			 	<!--- added 15 / 11 / 2012 to have support for an item procured as warehouse item
				but to control the receipt into a different UoM preempt the need for UoM conversion
				driven by Gallons and Liters 				
				--->						

				<cfset url.itemno = whsitm>	
				<cfset url.uom    = whsuom>													
												
				<cfquery name="get" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   ItemUoM
					WHERE  ItemNo = '#url.ItemNo#'				
					AND    UoM    = '#url.uom#'
				</cfquery>
				
				<cfquery name="check" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   ItemUoM
					WHERE  ItemNo = '#url.ItemNo#'				
					AND    UoM    = '#line.receiptUoM#'
				</cfquery>
								
				<cfif check.recordcount eq "0">							
					<cfset url.default = "1">
				<cfelse>
				    <cfset url.default = "0">					
				</cfif>	
				
				<cfset url.itemuomid = get.ItemUoMId>				
																			
				<cfinclude template="setWarehouseUoM.cfm">		 	 
			 
			 </td>
			 
			</cfif>
			 
		</table>	 
	 
	   </td></tr>
				
	</TD>
	
	</TR>
	
	<!--- ------ CUSTOM FORM ----------- --->
	<!--- ------------------------------ --->
	<!--- -----end of custom form------- --->
	<!--- ------------------------------ --->
		
	<cfif rows lte "0" or Purchase.ReceiptEntryForm eq "">
	
	<TR>
        <td class="labelmedium" valign="top" style="padding-left:10px;padding-top:3px"><cf_tl id="Item">:</td>
        <TD colspan="3">
		<textarea style="padding:3px;width:100%;height:38;font-size:14px;" id="receiptitem" name="ReceiptItem" class="regular enterastab">#ord#</textarea>
		</TD>
	</TR>
	
	<cfelse>
	
	<TR>
        <td class="labelmedium" valign="top" style="padding-left:10px;padding-top:3px"><cf_tl id="Observations">:</td>
        <TD colspan="3">
		  <textarea onkeyup="return ismaxlength(this)" style="border:1px solid silver;font-size:13px;padding:2px;padding-top:3px;padding-left:5px;width:99%;height:25" totlength="100" onchange="" id="receiptitem" name="ReceiptItem" class="regular enterastab">#ord#</textarea>
		</TD>
	</TR>	
	
	</cfif>
		
	<TR id="uom1" class="#clr#">
    <TD class="labelmedium" style="padding-left:10px"><cf_tl id="UoM">:<font color="FF0000">*</font></TD>
    <TD colspan="3">
			   	
	   	<select name="receiptuom" id="receiptuom" size="1" class="regularxl enterastab">
	    <cfloop query="UoM">
			<option value="#Code#" <cfif Code eq Line.ReceiptUoM>selected</cfif>>#Description#</option>
		</cfloop>
	    </select>		
		
	</TD>
	
	</TR>
		
	</cfoutput>	
	
	<!---
	<tr><td colspan="2" class="labellarge" valign="bottom" style="font-size:28px;font-weight:200;padding-left:10px"><cf_tl id="Financials"></td></tr>
	
	<tr><td></td></tr>
	
	--->
		
	<TR id="pricing">
    <TD class="labelmedium" style="padding-left:10px"><cf_tl id="Price">:<font color="FF0000">*</font></TD>
    <TD colspan="3">
	
	    <table cellspacing="0" cellpadding="0">
	
	    <tr><td>
	
	    <cfif Parameter.EnforceCurrency eq "0">
		
			<!--- to be adjusted with CurrencyMission --->
			
			<cfquery name="Currency" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   CurrencyMission
				WHERE  Mission = '#Purchase.Mission#' 
			</cfquery>
			
			<cfif currency.recordcount eq "0">
		
			    <cfquery name="Currency" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Currency
					WHERE  EnableProcurement = '1'
				</cfquery>
			
			</cfif>
			
			<!--- to be adjusted with CurrencyMission --->
	   	
		   	<select name="currency" id="currency" class="regularxl enterastab"
			    size="1" 
				onChange="exch(this.value,document.getElementById('costprice').value,document.getElementById('taxprice').value,document.getElementById('pay').value)">
			    <cfoutput query="currency">
					<option value="#Currency#" <cfif Currency eq curr>selected</cfif>>
		    		#Currency#
				</option>
				</cfoutput>
		    </select>
			
			<cfoutput query="currency">
			   <cfif exchangerate eq "">
			     <input type="hidden" id="exchangerate_#Currency#" value="1">
			   <cfelse>
			     <input type="hidden" id="exchangerate_#Currency#" value="#ExchangeRate#">
			   </cfif>
			</cfoutput>
									
			</td>
								
		<cfelse>
								   
		   <cfquery name="Currency" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Currency
				WHERE  Currency = '#Purchase.Currency#' 
			</cfquery>
			
			<cfif Currency.recordcount eq "1">
				   
		    <cfoutput>
			  <input type="hidden" name="currency"     id="currency"     value="#Currency.Currency#"> 			 
			</cfoutput>
			
			<cfelse>
			
	  		  <cf_tl id="Currency problem. Operation not allowed." var="1">
			  <cf_message message = "#lt_text#" return = "back">
			  <cfabort>
			
			</cfif>
		
		</cfif>
		
		</td>
		
		<td style="padding-left:3px">
		
				
		<cfoutput>
		
		<input type="hidden" name="receiptprice" id="receiptprice" value="#numberFormat(prc,dgt)#">		

		<cfif Line.ReceiptZero eq '1'>
		
			<cfinput type="Text" name="receiptpriceShow" id="receiptpriceShow" value="#numberFormat(prc,dgt)#" message="Enter a valid price" 
			required="Yes" size="10" maxlength="10" style="text-align: right;" class="regularxl enterastab"
			onChange="calc(document.getElementById('receiptquantity').value,this.value,document.getElementById('receiptdiscount').value,document.getElementById('receipttax').value,document.getElementById('taxincl').value,document.getElementById('exchangerate').value,document.getElementById('taxexemption').value);nofree()" disabled>
			
		<cfelse>
		
			<cfinput type="Text" name="receiptpriceShow" id="receiptpriceShow" value="#numberFormat(prc,dgt)#" message="Enter a valid price" 
			required="Yes" size="10" maxlength="10" style="text-align: right;" class="regularxl enterastab"
			onChange="calc(document.getElementById('receiptquantity').value,this.value,document.getElementById('receiptdiscount').value,document.getElementById('receipttax').value,document.getElementById('taxincl').value,document.getElementById('exchangerate').value,document.getElementById('taxexemption').value);nofree()">
			
		</cfif>
		
		</cfoutput>	
		
		</td>
		
		<td style="padding-left:3px">
		
		<cfif Line.ReceiptZero eq "1">
	     	<input type="checkbox" name="receiptzero" id="receiptzero" value="1" class="enterastab" onClick="free(this.checked)" checked>
		<cfelse>
			<input type="checkbox" name="receiptzero" id="receiptzero" value="1" class="enterastab" onClick="free(this.checked)">
		</cfif> 
		
		</td>
		<td class="labelit" style="padding-left:3px"><cf_tl id="Item offered for free">
		</td></tr>
		
		</table>
				
	</TD>
	</TR>	
		
	<cfif Purchase.ReceiptPrice eq "0" and Purchase.ReceiptEntry eq "1"> 
		<cfset fin = "hide">	
	<cfelse>
	    <cfset fin = "regular">	
	</cfif>
	 	 
	<TR id="pricing" class="<cfoutput>#fin#</cfoutput>">
    <TD class="labelmedium" style="padding-left:10px"><cf_tl id="Discount on Price">:</TD>
    <TD colspan="3">
	
		<table cellspacing="0" cellpadding="0">
		<tr>		
		
	    <TD width="100">
		
		   <cfinput type="Text" 
		     class="regularxl enterastab" 
			 name="receiptdiscount" 
			 value="#dis#" 
			 message="Enter a valid percentage" 
			 validate="float" 
			 required="Yes" 
			 size="2" 
			 maxlength="2" 
			 style="text-align: right;padding-right:6px" 
			 onChange="calc(document.getElementById('receiptquantity').value,document.getElementById('receiptprice').value,this.value,document.getElementById('receipttax').value,document.getElementById('taxincl').value,document.getElementById('exchangerate').value,document.getElementById('taxexemption').value)"> %
					
		</TD>
				
		<TD class="labelit hide"><cf_tl id="Extended price">:</TD>
		<td class="hide">
		<cfoutput>
	
			<input type  = "Hidden" 
				   name  = "extprice" id="extprice" style="text-align:right"
				   value = "#numberFormat(amt,dgt)#" >

		    <input type="text" class="regularxl enterastab" name="extpriceShow" id="extpriceShow" style="text-align: right;" value="#numberFormat(amt,dgt)#" size="10" readonly>
				
		</cfoutput>
		
		</td>		
		
		<TD class="labelmedium" style="padding-left:10px" width="114"><cf_space spaces="40"><cf_tl id="Extended Price">:</TD>
		
	    <TD style="padding-left:2px">
		<cfoutput>
		
			<input type="Hidden" 
				name="discextprice" id="discextprice"
				value="#numberFormat(damt,dgt)#" >	
		
			<input type="text" 		  	
			    class="regularxl enterastab" 
			    style="width:90;font:14px;padding-right:3px;text-align: right;" 
			    name="discextpriceShow" id="discextpriceShow" value="#numberFormat(damt,dgt)#" 
			    readonly>
		   
		</cfoutput>
		</TD>
		
		</tr>
		</table>
	</TD>
	</TR>
	
		
	<TR id="pricing" class="<cfoutput>#fin#</cfoutput>">
	    <TD class="labelmedium" style="padding-left:10px"><cf_tl id="Product tax">:</TD>
	    <TD colspan="3">
		
			<table cellspacing="0" cellpadding="0"><tr><td width="100">
			   		
			<cfinput type="Text" 
			     class="regularxl enterastab" 
				 name="receipttax" 
				 value="#txu#" 
				 message="Enter a valid percentage" 
				 validate="float" 
				 required="Yes" 
				 size="2" 
				 maxlength="2" 
				 style="text-align: right;padding-right:6px" 
			     onChange="calc(document.getElementById('receiptquantity').value,document.getElementById('receiptprice').value,document.getElementById('receiptdiscount').value,this.value,document.getElementById('taxincl').value,document.getElementById('exchangerate').value,document.getElementById('taxexemption').value)"> %
			
			</td>
			
			<TD class="labelmedium" style="padding-left:10px" width="100"><cf_tl id="in Price">:</TD>
		    <TD class="labelmedium">
			    <cfoutput>
				<input type="radio" class="enterastab radiol" name="taxincluded" id="taxincluded1" value="1" <cfif txi eq "1">checked</cfif>
				onclick="tax('1'); calc(document.getElementById('receiptquantity').value,document.getElementById('receiptprice').value,document.getElementById('receiptdiscount').value,document.getElementById('receipttax').value,'1',document.getElementById('exchangerate').value,document.getElementById('taxexemption').value)">
				</td><td class="labelmedium" style="padding-left:3px"><cf_tl id="Yes"></td>
				<td style="padding-left:6px">
				<input type="radio" class="enterastab radiol" name="taxincluded" id="taxincluded2" value="0" <cfif txi eq "0">checked</cfif>
				onclick="tax('0'); calc(document.getElementById('receiptquantity').value,document.getElementById('receiptprice').value,document.getElementById('receiptdiscount').value,document.getElementById('receipttax').value,'0',document.getElementById('exchangerate').value,document.getElementById('taxexemption').value)">
				</td><td class="labelmedium" style="padding-left:3px"><cf_tl id="No">			
				<input type="hidden" name="taxincl" id="taxincl" value="#txi#">			
				</td>
				</cfoutput>
				
			<td class="labelmedium" style="padding-left:16px"><cf_tl id="Tax exemption">:</td>
			<TD class="labelmedium" style="padding-left:6px">
			    <cfoutput>
				<table cellspacing="0" cellpadding="0">
				<tr><td >
				<input type="radio" class="enterastab radiol" name="exem" id="exem1" value="1" <cfif exm eq "1" or exm eq "">checked</cfif>
				onclick="document.getElementById('taxexemption').value='1'; calc(receiptquantity.value,receiptprice.value,receiptdiscount.value,receipttax.value,taxincl.value,exchangerate.value,'1')">
				</td><td class="labelmedium" style="padding-left:3px"><cf_tl id="Yes"></td>
				<td style="padding-left:6px"><input type="radio" class="enterastab radiol" name="exem" id="exem2" value="0" <cfif exm eq "0">checked</cfif>
				onclick="document.getElementById('taxexemption').value='0'; calc(receiptquantity.value,receiptprice.value,receiptdiscount.value,receipttax.value,taxincl.value,exchangerate.value,'0')">
				</td>
				<td style="padding-left:3px" class="labelmedium"><cf_tl id="No"><input type="hidden" name="taxexemption" id="taxexemption" value="#exm#">	</td>
				</tr>
				</table>		
				</cfoutput>
			</td>						
					
			</tr>
			</table>
								
		</TD>
	</TR>
	
	<cfif exm eq "0" and fin neq "hide"> 
	  <cfset cl = "regular">
	<cfelse>
	  <cfset cl = "hide">  
	</cfif>
	
	<tr><td colspan="4" height="5"></td></tr>
	<tr><td></td><td colspan="3" class="line"></td></tr>
		
	<cfquery name="CostItem" 
		 datasource="AppsPurchase"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">				 
		 SELECT    *
		 FROM ReceiptCost
		 WHERE ReceiptNo  = '#Line.ReceiptNo#'				
	</cfquery>	
	
	<cfoutput>
				
    <TR id="pricesum" name="pricesum" class="<cfoutput>#cl#</cfoutput>">		    		
		
		<cf_tl id="Value" var="vReceiptPrice">
		 
		<td class="labelit" style="padding-left:35px"><cfoutput>#vReceiptPrice#</cfoutput>:&nbsp;</td>
			
	    <TD colspan="3">
		
			<table cellspacing="0" cellpadding="0">		
			   
			<tr>
			
			<td style="padding-left:0px">
								
		        <input type="text" class="regularxl regular2 enterastab" 
				   style="height:25;width:90;font:14px;padding-right:3px;text-align:right" 
				   name="costprice" id="costprice" 
				   value="#numberFormat(cost,".__")#" size="14" readonly>									
			
			</td>			
			<TD class="labelit" style="width:160;padding-left:28px">
			
			<table>
				<tr>
				<td><cfoutput>#vReceiptPrice# #APPLICATION.BaseCurrency#:</cfoutput></td>
				<td style="padding-left:4px"><input style="width:60px;text-align:right" 
				onchange="calc(document.getElementById('receiptquantity').value,document.getElementById('receiptprice').value,document.getElementById('receiptdiscount').value,document.getElementById('receipttax').value,document.getElementById('taxincl').value,this.value,document.getElementById('taxexemption').value);nofree()"
				type="input" name="exchangerate" id="exchangerate" value="<cfoutput>#exch#</cfoutput>"></td>
				</tr>
			</table>
			
			<!---
			<cfoutput query="currency">
			   <cfif exchangerate eq "">
			     <input type="hidden" id="exchangerate_#Currency#" value="1">
			   <cfelse>
			     <input type="hidden" id="exchangerate_#Currency#" value="#ExchangeRate#">
			   </cfif>
			</cfoutput>
			--->
			
			</TD>
		    <TD style="padding-left:3px">
			
		        <input type="text"  class="regularxl  regular2 enterastab" style="text-align: right;height:25;width:90;font:14px;padding-right:3px" name="costpriceb" id="costpriceb" value="#numberFormat(costB,"__.__")#" size="14" readonly>											
			
			</TD>
			
			<cfloop query="CostItem">
			
				<cfquery name="getCostItem" 
				 datasource="AppsPurchase"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
					 SELECT    *
					 FROM    PurchaseLineReceiptCost
					 WHERE   ReceiptId  = '#Line.ReceiptId#'				
					 AND     CostId     = '#costid#'
				</cfquery>	
			
				<TD class="labelit" style="width:160;padding-left:28px"><cf_tl id="Value"> #APPLICATION.BaseCurrency#</td>
			
				<td>	
				
				<input type="text" class="regularxl enterastab" 
				  style="height:25;width:90;font:14px;padding-right:3px;text-align:right" name="AmountCalculation_#left(costid,8)#"  id="amountcalculation_#left(costid,8)#" 
				  value="<cfif getCostItem.amountCalculation eq "">#numberFormat(costB,'__.__')#<cfelse>#numberFormat(getCostItem.AmountCalculation,'__.__')#</cfif>" size="14"
				  onchange="ptoken.navigate('setReceiptCost.cfm?action=apply&receiptid=#line.receiptid#&costid=#costid#&price='+this.value+'&percent='+document.getElementById('percent_#left(costid,8)#').value,'process')">
				
				</td>
				
				<td><cf_img icon="copy" onclick="ptoken.navigate('setReceiptCost.cfm?action=copy&receiptno=#line.receiptno#&receiptid=#line.receiptid#&costid=#costid#&price='+document.getElementById('costpriceb').value+'&percent='+document.getElementById('percent_#left(costid,8)#').value,'process')"></td>
				
			</cfloop>
												
			</tr>
			
			</table>
		
		</td>
					
	</tr>
	
	<TR id="pricesum" name="pricesum" class="<cfoutput>#cl#</cfoutput>">
	 
	 <cf_tl id="Tax" var="vTax">
	 
	 <td class="labelit" style="padding-left:35px"><cfoutput>#vTax#</cfoutput>:</td>
	 
	 <TD colspan="3">
		
			<table cellspacing="0" cellpadding="0">
									
			<tr>
			
				<td style="padding-left:0px">
				
			        <input type="text" class="regularxl regular2 enterastab" style="text-align: right;height:25;width:90;font:14px;padding-right:3px" name="taxprice" id="taxprice" value="#numberFormat(tax,"__.__")#" size="14" readonly>								
				
				</td>			
				<TD class="labelit" style="width:160;padding-left:28px"><cfoutput>#vTax# #APPLICATION.BaseCurrency#:</cfoutput></TD>
			    <TD style="padding-left:3px">
				
				    <input type="text" class="regularxl regular2 enterastab" style="text-align: right;height:25;width:90;font:14px;padding-right:3px" name="taxpriceb" id="taxpriceb" value="#numberFormat(taxb,"__.__")#" size="14" readonly>					
				
				</TD>
				
				<cfloop query="CostItem">
						
					<TD class="labelit" style="width:160;padding-left:28px"><cf_tl id="Percentage"></td>
				
					<td>	
					
				    <input type="text" class="regularxl enterastab" 
					onchange="ptoken.navigate('setReceiptCost.cfm?action=apply&receiptno=#line.receiptno#&receiptid=#line.receiptid#&costid=#costid#&price='+document.getElementById('amountcalculation_#left(costid,8)#').value+'&percent='+this.value,'process')"
					style="height:25;width:90;font:14px;padding-right:3px;text-align:right" name="Percent_#left(costid,8)#" id="percent_#left(costid,8)#" value="#numberFormat(getCostItem.Percentage,"__._")#" size="4">									
					
					</td>
			
			    </cfloop>			
				
			</tr>
			
			</table>
					
	</tr>
	  
	<TR id="pricing" class="<cfoutput>#fin#</cfoutput>">
	  
	   <TD class="labelit" style="padding-left:35px"><cf_tl id="Payable">:</td>
	   
	   <TD colspan="3">
		
			<table cellspacing="0" cellpadding="0">
			
			<tr>	  		
			
			<td style="padding-left:0px">
			
			    <input type="text" class="regularxl regular2 enterastab" style="text-align: right;height:25;width:90;font:14px;padding-right:3px" name="pay" id="pay" value="#numberFormat(pay,"__.__")#" size="14" readonly>
			
			</td>			
			<TD class="labelit" style="width:160;padding-left:28px"><cf_tl id="Payable"><cfoutput>#APPLICATION.BaseCurrency#</cfoutput>:</TD>
		    <TD style="padding-left:3px">
			
			    <input type="text" class="regularxl regular2 enterastab" style="text-align: right;height:25;width:90;font:14px;padding-right:3px" name="payB" id="payB" value="#numberFormat(payb,"__.__")#" size="14" readonly>
			
			</TD>
			
			<cfloop query="CostItem">
						
					<TD class="labelit" style="width:160;padding-left:28px">#description# <cf_tl id="Amount"></td>				
					<td>											
				    <input type="text" class="regularxl enterastab" style="height:25;width:90;font:14px;padding-right:3px;text-align:right" name="AmountCost_#left(costid,8)#" id="amountcost_#left(costid,8)#" value="#numberFormat(getCostItem.AmountCost,"__.__")#" size="4">														
					</td>
			
			    </cfloop>	
			
			</td>
			
			</tr>
			
			</table>
			
		</td>	
			
	</TR>		
	
	</cfoutput>
	
	<tr><td colspan="4" height="5"></td></tr>
	<tr><td></td><td colspan="3" class="line"></td></tr>
	<tr><td colspan="4" height="5"></td></tr>
				
	
	<cfif url.mode neq "task">
		   
	<TR>
        <td class="labelmedium" style="padding-top:4px;padding-left:10px" valign="top"><cf_tl id="Remarks">:</td>
		<cfoutput>
        <TD colspan="3">
		  <textarea style="font-size:15px;padding:3px;width:100%" rows="2" name="Remarks" class="regular enterastab">#Line.Remarks#</textarea> 
		</TD></cfoutput>
		
	</TR>
	
	</cfif>
			
	<!--- direct mode can be removed likely tonite 10/10/2011 --->
		
	<cfif url.mode eq "direct">
			
		 <cf_workflowenabled 
		     mission="#Purchase.mission#" 
			 entitycode="ProcReceipt">
		  
		 <cfif workflowenabled eq "1">
		  
			  <tr>
			  <td style="padding-left:10px"><cf_tl id="Routing">:</td>
			  <td colspan="3">
			  
			  <!--- show only pubished flows --->
			  
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
																	   WHERE  Mission = '#Purchase.mission#')
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
						                        WHERE  EntityCode = 'ProcReceipt'  )
						
						 AND    Operational = 1
					</cfquery>
									
				</cfif>
				
				<select name="entityclass" id="entityclass" class="regularxl;enterastab">
					<cfoutput query="Class">
					<option value="#EntityClass#">#EntityClassName#</option>
					</cfoutput>
				</select>		
			  
			  </td>
			  
			  </tr>			 
			  
		  </cfif>	
  
	  <tr>
		 <td style="padding-left:10px"><cf_tl id="Attachments">:</td>
		 <td colspan="3">

			  <cf_filelibraryN
					DocumentPath   = "PurchaseReceipt"
					SubDirectory   = "#receiptid#" 		
					Filter=""
					Insert="yes"
					Remove="yes"
					reload="true">		  
	
		</td>
	  </tr>
			  
  </cfif>		
  
  <cfset ajaxonload("doCalendar")>
  
<!-- </cfform> -->    					
  
<!--- this portion only applies if we potentially need to generate a warehouse item and does
not apply if we are in the requisition stock mode or if we have just a listing based entry of the recording 
Hanno : I have disabled 13/10/2014 it as we handle it at the moment of opening which mode to show 
   
<cfif hasTopics.recordcount gte "1"> 
	
	<cfif requestHasWarehouseItem eq "No" and Requisition.EnforceWarehouse eq "2" and modewarehouseitem eq "generate">
	     		
			<script language="JavaScript">
				res('generate');
			</script>
			
	</cfif> 

</cfif>

--->

</table>	
	
