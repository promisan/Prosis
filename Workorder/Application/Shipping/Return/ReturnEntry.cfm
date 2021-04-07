
<cf_screentop scroll="Yes" 
   layout="webapp" 
   jQuery="Yes" 
   bannerforce="Yes" 
   banner="red" 
   label="Return of issued/confirmed shipments">
    

<cf_dialogMaterial>
<cf_dialogOrganization>
<cf_dialogWorkOrder>
<cf_dialogLedger>
<cf_PresentationScript>

<script>
	function selectAllCB(c,selector) {
		if (c.checked) {
			$(selector).prop('checked', true);
		}else{
			$(selector).prop('checked', false);
		}
		_cf_loadingtexthtml='';
		ptoken.navigate('setTotal.cfm','totalbox','','','POST','billingform');
	}
</script>


<!---

Show information by batch (warehouse) and allow to select the items that were confirmed already, each line will become a line in 

TransactionLine and the sum will be booked in TransactionHeader as a receivable.

Journal from WarehouseJournal.Sales.

(If there are different warehouses and they have different journals we do not allow to mix transactions, if the journal is the same we can mix)

<br>

Receivable from the journal
a/ Income  : GL account : WorkOrderGLedger.Sale

<br>

<!--- show for a workorder any shipments that were not be invoiced yet 

ItemTransactionShipping for a workorder that has InvoiceId = NULL

Allow to select one or more receipt.
Create receivable and associate the invoiceId to the ItemtransactionShipping line 
														 
Maybe goo to show in 3 sections

1. Already billed
2. Ready for billing which check box
3. Under clearance.															 

Submit will generate the payable and bring up the screen as i did for POS mode as well.
	
--->
--->


<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT * 
	FROM WorkOrder W, Customer C 
	WHERE WorkorderId = '#url.workorderid#'
	AND  W.Customerid = C.CustomerId
</cfquery>  


<!--- total amount of the workorder which is billable, exclude class is not sale --->

<cfquery name="Sale" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   SUM(I.SalePayable) AS Total
    FROM     WorkOrderLineItem I INNER JOIN
             WorkOrderLine WL ON I.WorkOrderId = WL.WorkOrderId AND I.WorkOrderLine = WL.WorkOrderLine INNER JOIN
             Ref_ServiceItemDomainClass R ON WL.ServiceDomain = R.ServiceDomain AND WL.ServiceDomainClass = R.Code
    WHERE    I.WorkOrderId = '#url.workorderid#'
</cfquery>  


<cfquery name="getMandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT  *
      FROM     Ref_MissionPeriod
   	  WHERE    Mission = '#WorkOrder.Mission#'
	  AND      Period  = (
	  					  SELECT TOP 1 Period 
	                      FROM   Program.dbo.Ref_Period 
						  WHERE  DateEffective  <= '#dateformat(now(),client.dateSQL)#' 
						  AND    DateExpiration >= '#dateformat(now(),client.dateSQL)#'
						 )
				
	    
</cfquery>


<cfif getMandate.recordcount eq "0">

		<table align="center">
		  <tr><td align="center" style="padding-top:16px" class="labelmedium"><font color="FF0000">Problem, an entity period has not been defined for today's date</td></tr>
	    </table>

		<cfabort>

</cfif>

<table height="100%" width="100%">

	<tr><td style="padding:16px" valign="top">
	
	<form name="billingform" id="billingform" style="height:100%">
	
		<table width="97%" align="center" height="100%" class="navigation_table">
		
		<cfoutput>
			
		<tr class="line"><td colspan="2" style="background-color:f1f1f1;padding:3px">
		
			<table width="100%">
				<tr class="labelmedium2"><td style="width:15%"><cf_tl id="Workorder">:</td>
				    <td><a href="javascript:workorderview('#url.workorderid#')"><font color="0080C0">#workorder.Reference#</td>
					<td><cf_tl id="Date">:</td>
					<td>#dateformat(workorder.OrderDate,client.dateformatshow)#</td>
				</tr>
	
				<tr class="labelmedium2"><td><cf_tl id="Customer"></td>
				    <td><a href="javascript:viewOrgUnit('#workorder.orgunit#')"><font color="0080C0">#workorder.customername#</a></td>
					<td><cf_tl id="Terms">:</td>
					<td>#workorder.Terms#</td>
				</tr>
				
				<tr class="labelmedium2">
				<td height="32px" valign="top" style="padding-top:4px"><cf_tl id="Bill to">:</td>	
				<td colspan="3">
				
					<table width="96%" cellspacing="0" cellpadding="0">
					<tr><td style="border:1px solid d4d4d4;padding:4px;">
					
					<cfset url.orgunit = workorder.OrgUnit>
					<cfinclude template="../../../../System/Organization/Application/Address/UnitAddressView.cfm">
					
					</td></tr>
					</table>
				
				</td>
				</tr>			
	
				<tr class="labelmedium2"><td style="height:28px"><cf_tl id="Sale Order Amount">:</td>
				     <td>#workorder.currency# #numberformat(Sale.Total,",.__")#</td>
					 <td><cf_tl id="Billed">:</td>
					 <td id="billingbox">				 
						 <cfinclude template="setBilled.cfm">				
					 </td>
				</tr>
				
				<tr><td colspan="4" class="line"></td></tr>
										
				<tr>				
					<td height="32" class="labelmedium"><cf_tl id="Reference">:</td>
					<td>			
					<input type="text" name="BatchReference" size="15" maxlength="20" class="regularxxl">			
					</td>			
				
				 <td height="32" class="labelmedium"><cf_tl id="Date">:</td>
					 <td class="labelmedium">
													
					 <cf_setCalendarDate
					      name     = "transactiondate"        				      
					      font     = "16"
						  edit     = "Yes"
						  class    = "regular"				  
					      mode     = "date"> 
						  
					</td>		
					
				</tr>							
				
			</table>
			
		</td></tr>
			
		<tr><td colspan="2">
		
			<table>
			
				<tr>
				
					<td style="padding-left:4px">			
					<input type="radio" name="mode" onclick="ptoken.navigate('ReturnEntryDetail.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#&shipmode=pending','content')" class="radiol" value="Pending" checked>					
					</td>			
					<td style="padding-left:4px" class="labelmedium2"><cf_tl id="No billed"></td>			
					<td style="padding-left:8px">			
					<input type="radio" name="mode" class="radiol" value="Pending" onclick="ptoken.navigate('ReturnEntryDetail.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#&shipmode=billed','content')">					
					</td>			
					<td style="padding-left:4px;padding-right:10px" class="labelmedium2"><cf_tl id="Billed"></td>		
					
					<td style="padding-left:4px;padding-right:10px">
						
						<cfinvoke component = "Service.Presentation.TableFilter"  
							   method           = "tablefilterfield" 
							   filtermode       = "enter"
							   name             = "filtersearch"
							   style            = "font:14px;height:25px;width:120px"
							   rowclass         = "clsWarehouseRow"
							   rowfields        = "ccontent">
					</td>			
				</tr>
				
			</table>
			
		</td></tr>
		
		</cfoutput>
				
	    <tr><td style="height:100%;padding-left:3px;padding-right:3px;min-width:900px">	
			<cf_divscroll id="content" style="height:100%">
			    <cfinclude template="ReturnEntryDetail.cfm">
			</cf_divscroll>
		</td></tr>	
						
		<cfquery name="Param" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		  	SELECT   *
			FROM     Ref_ParameterMission
			WHERE    Mission = '#workorder.mission#' 		
		</cfquery>  
		
		<tr><td colspan="2" align="center" height="35">
			
				<table width="100%">
				
				<!--- initial value --->
										
				<tr>
				   <td style="padding-left:8px" class="labelmedium">Total <cfoutput>#workorder.currency#:</cfoutput></td>
				   <td colspan="1" align="right" id="totalbox" class="labelmedium" style="padding-right:3px">0.00</td>
				</tr>
				
				<tr><td colspan="2" class="line"></td></tr>
				
				<tr><td colspan="2" height="40" align="center">
				
					 <table width="97%" class="formpadding" align="center">
					 <tr class="labelmedium2">
					 
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
					 
					 	<td width="60"><cf_tl id="Warehouse">:</td>
					 	<td style="padding-left:4px">		
						
						<select name="warehouse" id="warehouse"
						    class="regularxxl" style="width:100%"
							onchange="_cf_loadingtexthtml='';ptoken.navigate('setLocation.cfm?warehouse='+this.value,'locationbox')">
							<cfoutput query="Warehouse">
								<option value="#Warehouse#">#WarehouseName#</option>
							</cfoutput>
						</select>						 
									
				        </td>
						
						<td style="padding-left:10px"><cf_tl id="Location">:</td>
						
						<td id="locationbox">
						
							<cfset url.warehouse = warehouse.warehouse>					
							<cfinclude template="setLocation.cfm">
											
						</td>
						
						</tr>
						
						<tr class="labelmedium2">											
											 
						 <td><cf_tl id="Destination">:</td>						 
						 <td style="padding-left:3px">
						 			 
						  <select name="ReturnMode" id="ReturnMode" class="regularxxl" style="width: 200px;">				     					   
			     		   	  <option value="unearmarked"><cf_tl id="Unearmarked"></option>
							  						  
							   <cfinvoke component = "Service.Access"  
								   method           = "WorkOrderProcessor" 
								   mission          = "#workorder.mission#"  
								   serviceitem      = "#workorder.serviceitem#"
								   returnvariable   = "access">
				   
				   			  <cfif access eq "ALL">
							  						  
							  <option value="Disposal"><cf_tl id="Disposal"></option>		
							  
							  </cfif>         	  
							  
			              </select>	
						  
						  </td>
						 
						 <!--- 
						 <td width="60" class="labelit" style="padding-left:10px"><cf_tl id="Journal">:</td>
						 
						 <td class="labelit" style="padding-left:3px">					 			 
											  
						  </td>					  
						  
						  --->
						  
																
					  </tr>
					  </table>		
					
					</td></tr>
					
					<tr><td colspan="2" class="line"></td></tr>
										
					<tr>
						<td colspan="2" align="center" style="padding:6px">
						
						 <cfoutput>
						 
							  <input type="button" 
								  class="button10g" 
								  style="font-size:13px;width:210px;height:29" 
								  onclick="Prosis.busy('yes');ptoken.navigate('ReturnEntrySubmit.cfm?workorderid=#url.workorderid#&systemfunctionid=#url.systemfunctionid#','processbox','','','POST','billingform')"
								  name="Submit" 
								  value="Record return">
						  
						 </cfoutput>
						  
						</td>
						
						<td id="processbox"></td>
					</tr>
					
				</table>	
			
			</td>
		</tr>
		  		
		</table>
	
	</form>
	
</td></tr>

</table>	

