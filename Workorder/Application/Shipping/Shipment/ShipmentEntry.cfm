<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.workorderid" default="6E73726E-F11F-A592-6067-8B1C722B4371">
<cfparam name="url.transactionserialno" default="">


<cf_screentop jQuery="Yes" html="Yes" scroll="Yes" layout="webapp" banner="gray" label="WorkOrder Shipment">

<cf_dialogOrganization>
<cf_PresentationScript>

<cfajaximport tags="cfdiv">

<script language="JavaScript">
	
	function earmarkstock(whs,woid,sale) {				
		ProsisUI.createWindow('myearmark', 'Earmark', '',{x:100,y:100,height:document.body.clientHeight-70,width:document.body.clientWidth-70,modal:true,resizable:true,center:true})    						
		ptoken.navigate("ShipmentNotEarmarked.cfm?PointerSale="+sale+"&Warehouse="+whs+"&WorkOrderItemId="+woid,'myearmark') 		
    }
	
	function earmarkrefresh(whs,woid) {	    
		_cf_loadingtexthtml='';	
	    ptoken.navigate('setQuantities.cfm?warehouse='+whs+'&WorkOrderItemId='+woid,'process');
	    ptoken.navigate('ShipmentEntryDetailEarmarked.cfm?warehouse='+whs+'&WorkOrderItemId='+woid,woid);
	}

	function searchBarcode(search,e,whs) {

		if (e == null || e.keyCode == 13) {
			if (search.value != '') {
				if ($('#ship_reference_'+search.value))
				{
					id = $('#ship_reference_'+search.value).val();

					if ($('#ship_'+id).is(':checked'))
					{
						v=0
						$('#BarCode').val('');
						$('#BarCode').focus();
						alert('Already scanned on this batch')

					}
					else
					{
						$('#ship_'+id).attr('checked',true);
						$('#lines').animate({
							scrollTop: $('#ship_'+id).offset().top
						}, 2000);						
						$('#BarCode').val('');
						$('#BarCode').focus();
						v=1
					}
				 }
				 else
				 	alert('not found');
			 }
		 }
	 }
	 	
	function initBarCode()
	{
    	$('#BarCode').focus();
		<cfoutput>
		<cfif url.transactionserialno neq "">
			$('##BarCode').val('#url.transactionserialNo#');
			$('##BarCode').trigger(jQuery.Event('keyup', { keyCode: 13 }));
		</cfif>
		</cfoutput>
	}

	function doBarCodeSelection()
	{
		$('#BarCode').trigger(jQuery.Event('keyup', { keyCode: 13 }));
	}
		

</script>

<cf_dialogWorkOrder>
<cf_dialogMaterial>

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT * 
	FROM   WorkOrder W, Customer C 
	WHERE  WorkorderId = '#url.workorderid#'
	AND    W.Customerid = C.CustomerId
</cfquery>  

<form name="shipmentform" 
      action="ShipmentEntrySubmit.cfm?<cfoutput>systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#</cfoutput>" 
	  style="height:100%" 
	  method="post">

	<table width="100%" height="100%" align="center">
	
	<tr><td id="process"></td></tr>
	
	<cfoutput>
	
	<tr><td id="Header" height="40" style="padding-top:10px">
	
	     <table cellspacing="0" cellpadding="0" width="94%" align="center">
		 
		 	<tr class="line fixlengthlist">
				<td style="height:35px;padding-left:16px;font-size:18px" class="labellarge" colspan="2">
				<cfif workorder.orgunit gt "0">
				<a href="javascript:viewOrgUnit('#workorder.OrgUnit#')">#workorder.customername#</a>
				<cfelse>
				#workorder.customername#
				</cfif>
				</td>
			    <td class="labelmedium"><cf_tl id="WorkOrder No">:</td>
			    <td style="padding-left:5px;font-size:18px" class="labelmedium"><b>#workorder.Reference#</td>
			    <td style="padding-left:10px" height="26px" class="labelmedium"><cf_tl id="Order date">:</td>
				<td style="padding-left:5px;font-size:18px" class="labelmedium"><b>#dateformat(workorder.orderdate,client.dateformatshow)#</td>				  
			</tr>	
							
			<tr>
			
			<td></td>
			<td colspan="5" style="padding-left:1px">
			
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td style="border:0px dotted silver;">				
				<cfset url.orgunit = workorder.OrgUnit>
				<cfinclude template="../../../../System/Organization/Application/Address/UnitAddressView.cfm">				
				</td></tr>
				</table>
			
			</td>
			</tr>	
				
			</tr>	
			
			<tr class="fixlengthlist">
			
				<td style="height:45px;padding-left:15px" class="labelmedium"><cf_tl id="Ship from">:</td>
		    	<td style="padding-left:16px" colspan="1">
						
				<cfquery name="warehouse" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				  	SELECT * 
					FROM   Warehouse
					WHERE  Mission = '#workorder.mission#'
					AND    Operational = 1
					AND    (
					           Warehouse IN (SELECT Warehouse 
					                     FROM   WarehouseCategory
										 WHERE  Category IN (SELECT DISTINCT I.Category
															 FROM   Workorder.dbo.WorkOrderLineItem WLI INNER JOIN
											                        Materials.dbo.Item I ON WLI.ItemNo = I.ItemNo 
															 WHERE  WLI.WorkorderId = '#url.workorderid#')	
									    ) 
										
										OR
										
							   Warehouse IN (SELECT Warehouse 
							                 FROM   ItemTransaction 
											 WHERE   RequirementId IN (SELECT WorkOrderItemId
							                                           FROM   Workorder.dbo.WorkOrderLineItem 
																	   WHERE  WorkOrderId = '#url.workorderid#')			
											)						   
							)				
    											   
					ORDER BY WarehouseDefault DESC				 
				</cfquery>  
				
				<cfif warehouse.recordcount eq "0">
								
					<cfquery name="warehouse" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					  	SELECT    * 
						FROM      Warehouse
						WHERE     Mission = '#workorder.mission#'
						AND       Operational = 1				
						ORDER BY  WarehouseDefault DESC				 
					</cfquery>  
							
				</cfif>
				
				<select name="warehouse" 
				    class="regularxl" style="font-size:18px;height:30px"
					onchange="ptoken.navigate('ShipmentEntryDetail.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#&warehouse='+this.value,'lines')">
					<cfloop query="Warehouse">
						<option value="#Warehouse#">#WarehouseName#</option>
					</cfloop>
				</select>			
				
				<cfset url.warehouse = warehouse.warehouse>			
						
			 </td>
			
			 <td colspan="4">
			 			 	
				<table>
				
				<tr>		    
			 
			    <td height="32" style="padding-left:10px"  class="labelmedium"><cf_tl id="Date">:</td>
				 <td style="padding-left:6px" class="labelmedium">
												
				 <cf_setCalendarDate
				      name     = "transactiondate"        				      
				      font     = "18"
					  edit     = "Yes"
					  class    = "regular"				  
				      mode     = "date"> 
					  
				</td>	
				
				  	<td colspan="3" style="padding-left:10px;width:100px" height="32" class="labelmedium"><cf_tl id="Reference">:</td>
					<td style="padding-left:3px">			
					<input type="text" name="BatchReference" id="BatchReference" size="15" maxlength="20" class="regularxxl">			
					</td>	
					<td>TransactionSerialNo:</td>
					<td>

						<input type    = "text" 
							onkeyup   = "searchBarcode(this, event)" 							 
							name      = "BarCode" 
							id        = "BarCode"
							tabindex  = "1000" 
							onfocus   = "this.style.border='2px solid ##6483a2'" 
							onblur    = "this.style.border='1px solid silver'"
							class     = "regularxl"
							style     = "border-radius:0px;height:33px; width:100%;min-width:100px;">					
					</td>		
					</tr>
				
				</table></td>		
				
			</tr>			
				
			<tr><td height="4"></td></tr>		
			<tr><td colspan="6" class="line"></td></tr>
					
		 </table>
		 
	</td></tr>
			
	</cfoutput>
	
	<tr class="line">
	  <td height="100%" style="border-top:0px dotted silver;">		
				
		<cf_divscroll id="lines" style="padding-right:5px">					
			<cfinclude template="ShipmentEntryDetail.cfm">				
		</cf_divscroll>		
			
	</td></tr>
	
	<tr><td style="padding-top:6px;padding-left:30px;padding-right:25px"><textarea maxlength="400" style="width:100%;height:60px;border:1px solid silver;font-size:13px;padding:3px" name="BatchMemo"></textarea>
	
	
	</td></tr>
	
		
	<tr>
	   <td background="f1f1f1" style="padding:4px">
	  
	   <table width="100%">
		   <tr>
		   	  
		   
		   <td width="130" style="padding-left:40px" class="labelmedium"><cf_tl id="Audit total">:</td>
		   <td style="text-align:center;width:120px;padding-left:3px;border:1px solid silver" id="totals" class="labellarge"></td>
		   
		   <td style="width:40px"></td>
		   <td width="200" class="labelmedium"><cf_tl id="Issue Delivery Order">:</td>
		   <td><input type="checkbox" class="radiol" name="deliveryrequest" value="1"></td>
			
		   <td style="width:50%;height:30;padding-right:20px" id="submitbox" align="right">
		
			<cfoutput>
			<cf_tl id="Submit" var="tSubmit">
			<input type="button" 
			     name="Submit" 
				 value="#tSubmit#" 
				 style="font-size:15px;height:26px;width:190;background-color:gray;color:white" 
				 class="button10g" 
			     onclick="Prosis.busy('yes');ptoken.navigate('ShipmentEntrySubmit.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#','submitbox','','','POST','shipmentform')">
			</cfoutput>  
		
			</td>
			</tr>
		</table>
		
	</tr>
	
	</table>
	
</form>
<cfset AjaxOnLoad("function(){initBarCode();}")>
