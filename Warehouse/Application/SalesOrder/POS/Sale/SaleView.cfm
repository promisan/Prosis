
<cfparam name="url.requestno"  default="">

<cfif url.requestNo neq "">
			
	<cfquery name="request" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    SELECT  *
			FROM   CustomerRequest
			WHERE  Requestno = '#url.requestNo#'
	</cfquery>

	<cfparam name="url.customerid" default="#request.customerId#">
	<cfparam name="url.addressid"  default="#request.addressid#">
	<cfparam name="url.warehouse"  default="#request.warehouse#">
		
<cfelse>

	<cfparam name="url.customerid" default="00000000-0000-0000-0000-000000000000">
	<cfparam name="url.addressid"  default="00000000-0000-0000-0000-000000000000">

</cfif>

<cfparam name="url.init"       default="1">

<cfset vHide = "regular">

<cfif find("Android",cgi.HTTP_USER_AGENT)>
   <cfset full = "hide">
<cfelse>
   <cfset full = "regular">
</cfif>		

<cfajaximport tags="cfform">					

<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT  *
		FROM   Warehouse
		WHERE  Warehouse = '#url.warehouse#'
</cfquery>

<cfquery name="MParameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#get.Mission#'	
</cfquery>

<cfif get.SaleMode eq "0">

	<cfoutput>

	<table align="center"><tr><td style="padding-top:20px" class="labelmedium"><cf_tl id="Sale function is not enabled for this warehouse"></td></tr></table>
	</cfoutput>

<cfelse>

<cfif get.QuotationMode eq "0">
	
	<!--- clean --->
	
	<cfquery name="clean" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		    DELETE
			FROM   CustomerRequest
			WHERE  Warehouse = '#url.warehouse#'
			AND    Created < getDate()-1
	</cfquery>

</cfif>

<!--- check if this is a mode in which we potentially are connecting the POS to a tax unit source --->

<cfquery name="getWarehouseJournal" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT  TransactionMode
		FROM   WarehouseJournal
		WHERE  Warehouse = '#url.warehouse#'
		AND    Area = 'SETTLE'
</cfquery>

<cfoutput>
	
	<cfif get.SaleBackground neq "">
		<cfset bck = "#SESSION.root#/Images/BG-White.jpg?id=#NOW()#">			
	<cfelse>	
		<cfset bck = "">
	</cfif>
							
	<table style="width:100%;height:100%;" onclick="doHideSelectBox()">
		
	<tr><td style="height:100%;" class="clsPrintContent">
	
		<cfform id="saleform" name="saleform" style="width:100%;height:100%">
	
		<table height="100%" width="100%" border="0">					    
			
			<tr class="hide"><td height="0" id="process"></td></tr>			
			
			<tr>
			<td colspan="2">
			
			<table height="100%" width="100%" border="0">			
			
			<tr id="header" class="<cfif url.scope eq 'POS'>regular<cfelse>hide</cfif>">
																		
			    <td width="100%" style="height:63px;border-bottom-left-radius:0px;background-image: linear-gradient(to bottom,##ffffff,##d6d6d6);">
												  											
					<table width="100%">
							
						<tr>
										
						<td>	
													
						  <cf_getWarehouseTime warehouse="#url.warehouse#">	
																			
						  <table style="height:100%">
						  
					        <tr>
							
							<td style="padding-left:5px;padding-top:6px;padding-right:5px" onClick="stockfullview()">
				
						               <cfquery name="getLogo" 
									     datasource="AppsInit">
										   SELECT * 
										   FROM Parameter
										   WHERE HostName = '#CGI.HTTP_HOST#'  
					                   </cfquery>
								
					                   <cfif find(":",getLogo.logopath)>
					                       <cfimage
					                           action = "write"
					                           destination = "#session.rootdocumentpath#\CFReports\clientLogo.png"
					                           source = "#getLogo.logopath#\#getLogo.logofilename#"
					                           overwrite = "yes">
					                       <cfset vLogoSource="#session.rootdocument#/CFReports/clientLogo.png">
					                   <cfelse>
					                       <cfset vLogoSource="#SESSION.root#/#getLogo.logopath#/#getLogo.logofilename#">
					                   </cfif>
					                   <img style="border:0px solid silver;border-radius:5px;height:42px" src="#vLogoSource#">
									   &nbsp;
					                </td>
					            
	                            <td valign="bottom" align="left" class="fixlength" style="min-width:500px;padding-left:8px;font-size:28px">
	                                    #get.WarehouseName#
	                                    <span title="#get.Address#" style="padding-left:8px;font-size:13px">#get.Address#</span>						  
								 </td>  
					        </tr>		
														
					        <tr>
	                            <td>
	
									<cfif getWarehouseJournal.TransactionMode eq "2">								
										<cf_printer ajax="yes" warehouse="#URL.warehouse#">									
									<cfelse>
										<input type="hidden" id="terminal" name="terminal" value="0">									
									</cfif>	
									</td>
								</tr>
								
							</table>	
							
							<!---		
							</div>
							--->
												
						</td>
						
						<td style="width:160px;padding-top:3px;padding-bottom:3px" align="right" class="clsNoPrint">		
															  
			                  <table align="center" width="100%">
							 										    				  		   											
						      <cfset hr = "#timeformat(localtime,'HH')#">			
							  <cfset mn = "#timeformat(localtime,'MM')#">
													  
							  <tr><td width="100%" style="padding-right:5px;padding-top:5px;">
							  
							  	  <table width="100%" style="border:1px solid silver;background-color:##ffffaf50">
							  
								  <tr>
								  <td style="padding-left:15px;padding-right:10px;min-width:30px;">						  			 
									  <input type="checkbox" class="radiol" name="arefresh" id="arefresh" checked onclick = "datetimemode('#URL.warehouse#')">
								  </td>	  
								  		
								  <td>						  
									<input type="hidden" name="itoday" id="itoday" value="#dateformat(now(),CLIENT.DateFormatShow)#">							
									
									<div id="dtoday" style="padding-bottom:10px;;padding-top:18px" class="labellarge">#dateformat(now(),CLIENT.DateFormatShow)#</div>							
									
									<cf_getWarehouseTime warehouse="#url.warehouse#">													
									
									<div id="dTransactionDate" class="hide">	
																														
									 <cf_setCalendarDate
								      name     = "transaction"  
									  id       = "transaction"      
								      timeZone = "#tzcorrection#"  
									  future   = "Yes"   
								      font     = "16"
								      mode     = "date"
								      edit     = "yes">						       
												
									</div>		
														
							      </td>
								  
								  <td align="right" width="50" style="padding-left:4px">
								  
								    <div id="dhour" class="labellarge" style="padding-bottom:10px;width:20px;;padding-top:18px" align="right">#hr#</div>					
								
									<select name="Transaction_hour" id="Transaction_hour"  style="height:28px;font-size:14px" class="hide">
									
										<cfloop index="it" from="0" to="23" step="1">
										
											<cfif it lte "9">
											    <cfset it = "0#it#">
											</cfif>				 
											
											<option value="#it#" <cfif hr eq it>selected</cfif>>#it#</option>
										
										</cfloop>	
										
									</select>					
						
								  </td>						  
								  <td style="padding-top:10px;width:1px;padding-bottom:13px;padding-top:18px" class="labellarge" align="center">:</td>						
								  
								  <td style="padding-left:2px"><div class="labellarge" style=";padding-top:18px;padding-bottom:10px" id="dminute">#mn#&nbsp;</div>		
								    
									<select name="Transaction_minute" id="Transaction_minute"  style="height:28px;font-size:14px" class="hide">
										
											<cfloop index="it" from="0" to="59" step="1">
											
											<cfif it lte "9">
											  <cfset it = "0#it#">
											</cfif>				 
											
											<option value="#it#" <cfif mn eq it>selected</cfif>>#it#</option>
											
											</cfloop>	
														
									</select>		
									
								  </td>
								  
								   <td style="padding-left: 8px;padding-top: 0px;">
								   		<cfoutput>
								   			<cf_tl id="Quote" var="1">
											<span id="printTitle" style="display:none;">#ucase("#get.mission# #lt_text#")#</span>
											<cf_tl id="Print" var="1">
											<cfif MParameter.RequestTemplate eq "">
												<cf_button2
														mode		= "icon"
														type		= "Print"
														title       = "#lt_text#"
														id          = "Print"
														height		= "36px"
														width		= "36px"
														printTitle	= "##printTitle"
														printIcon   = "Print-blue.png"
														imageHeight = "32px"
														printContent = ".clsPrintContent"
														printCallback="$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;'); $('##saleform').attr('style','height:auto'); $('##customer_box').attr('style','height:auto')">
											<cfelse>
												<cf_button2
														mode		= "icon"
														type		= "button"
														id          = "Print"
														height		= "36px"
														width		= "36px"
														imageHeight = "32px"
														image 		= "Print.png"
														onclick 	= "composequote('#MParameter.RequestTemplate#')">
											</cfif>
										</cfoutput>
								   </td>
								   	                              
									<td align="right" width="30%" align="right" height="100%" onClick="stockfullview()" style="padding-left:0;padding-top:0px;padding-right:9px;color:000000;cursor:pointer" id="fullview" class="labelmedium">
									  <img src="#session.root#/Images/Maximize-blue.png" alt="maximize screen" height="40" border="0" title="maximize screen">
									</td>									                                 
	
								  </tr>
								  
								 </table>
								 
								 </td>
								 </tr> 
														  
							  </table>					  
						  				
				      </td>						
									
					</tr>					
						
					</table>
			
				</td>								
		
		</tr>		
																
		<tr>
		
		    <td style="padding-top:5px">  					

			<table width="100%" class="formspacing">
			
			<tr>
			
			  <cfif url.scope eq "POS">
			
			  <td style="padding:7px;width:10%;background-color:transparent;" align="center" valign="top" class="clsNoPrint">				
					<cf_securediv id="divVoidDocument" bind="url:#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/SaleVoid.cfm?customerid=#url.customerid#&warehouse=#url.warehouse#&bbbb">						
			   </td>		
			   
			   <cfelse>
			   
			   <td style="min-width:7.0px;max-width:7.3px"></td>
			   
			   </cfif>
																		
			<td colspan="1" valign="top" style="min-width:65%;border-radius:15px;border-bottom-left-radius:1px;<cfif url.scope eq 'POS'>border:0px solid silver;background-image:linear-gradient(to bottom,##f1f1f1,##f1f1f1)</cfif>;padding-right:15px;height:80px;" id="customer_box">
						
				<table width="100%" align="left" style="min-width:360px">
				
					<!--- --------------- --->
					<!--- CUSTOMER SELECT --->
					<!--- --------------- --->
															
					<tr>
					
					<td valign="top" style="height:30px;padding-top:3px;padding-left:2px;padding-right:5px;color:##000000;" class="labelmedium">
						
						<table style="cursor: pointer;" 
						    onclick="customertoggle('customerdata',document.getElementById('customeridselect').value,'','#url.warehouse#','#url.addressid#');">
							
							<tr id="customerdata_main">								
																		
								<td align="left" id="customerdata_toggle" style="width:10px" class="hide">		
																														
									<img src="#SESSION.root#/Images/ToggleDown.png" 
									    id="customerdata_exp" 
										height="18" width="18" border="0" class="show" align="absmiddle">
										
									<img src="#SESSION.root#/Images/ToggleUp.png" 
									   id="customerdata_col" 
									   height="18" width="18" border="0" class="hide" align="absmiddle">
									   
								</td>
	                         	</tr>	
							
						</table>	
							
					</td>
																                				
					<td valign="top" colspan="1" align="left" style="width:100%;padding-top:6px">
									
						<table style="width:100%">
							
							<tr>
							
							<td onkeydown="if (event.keyCode==13) {$('##customerinvoiceselect').focus(); }" class="clsNoPrint"
							   style="border-top-left-radius:0px;border:0px solid gray"> 
							
								<input type="hidden"  id="customeridselect"     name="customeridselect" value="#url.customerid#">
								<input type="hidden"  id="customeridselect_val" name="customeridselect_val" value="">
								
								<cf_tl id="Select a customer" var="1">
								
								<cfif url.scope neq "POS">
																																								
								 	<input type         = "text" readonly
								         name         = "customerselect" 
								         id           = "customerselect"	
										 onfocus      = "this.style.border='1px solid gray';document.getElementById('customerinvoiceselectbox').className ='hide';" 
										 onblur       = "this.style.border='0px solid gray';forceSelect(this, 'customeridselect');"			 
								         style        = "border:0px solid silver;width:75px;height:26px;font-size:16px;"
								         autocomplete = "off">						
								
								<cfelse>
																													
							  	<cfinput type         = "text" 
								         name         = "customerselect" 
								         id           = "customerselect"	
										 onfocus      = "this.style.border='1px solid gray';document.getElementById('customerinvoiceselectbox').className ='hide';" 
										 onblur       = "this.style.border='0px solid gray';forceSelect(this, 'customeridselect');"			 
								         style        = "text-align:center;border:1px solid silver;background-image:linear-gradient(to bottom,##ffffff,##ffffff);padding-left:4px;width:75px;height:26px;font-size:16px;"
								         autocomplete = "off" 				  							       		  
								         onkeyup      = "searchcombo('#get.mission#','#url.warehouse#','','customer',this.value,'up','','##customeridselect_val');"
								         onkeydown    = "searchcombo('#get.mission#','#url.warehouse#','','customer',this.value,'down','','##customeridselect_val');">
										 
								</cfif>		 
								 
							  	<cfset ajaxOnload('salesfocus')>								 	
							  
							  </td>							
							
							  <td style="width:100%;padding-left:0px;border:0px solid gray;" class="regular">	
							  
							       <table width="100%">								  
								   <tr><td id="customerbox" style="width:100%;background-color:##d4d4d4;max-height:26px;min-width:150px;height:26px;font-size:16px;padding-right:4px">					 						 								  								   
								   <cfinclude template="applyCustomer.cfm">																				   
								   </td>								  	
								   </tr>
								   </table>								   
							  </td>							  
							 							  
							</tr>
														
						</table>
			
					</td>	
																									
					</tr>	
										
					<tr id="customerdata_box" class="#vHide#">						
						<td style="padding-left:2px;padding-top:3px;padding-bottom:3px;" colspan="3" id="customerdata_content"></td>
					</tr>	
					
					<!--- combo box to select the customer --->
					<tr id="box2" class="clsNoPrint">
						<td></td>
						<td bgcolor="white" id="customerselectbox">	
							<div style="position: absolute;z-index: 2000;left:529px;top: 145px;" id="customerfind"></div>			
						</td>
					</tr>	
					
					<tr id="box3" class=" clsNoPrint">
						<td></td>
						<td bgcolor="white" id="switchselectbox">	
							<div style="position: absolute;;z-index: 2000;left: 23px;top: 200px;" id="switchfind"></div>			
						</td>
					</tr>	
				   				   
				   </table>
			   
			   </td>			   
			  			   			   	  			  			 			   	  			  
			   <td valign="top" 
			       style="border-radius:15px;min-width:200px;padding-left:5px;<cfif url.scope eq 'POS'>border:0px solid gray;background-image:linear-gradient(to bottom,##ffffaf,##ffffaf)</cfif>" 
				   class="#full#">
			   
				   <table width="100%" border="0"> 
					
					<!--- ------------------ --->
					<!--- BILLING TO SELECT- --->
					<!--- ------------------ --->						
					<tr>
					<td valign="top" style="padding-top:5px;padding-left:2px; color:##000000;padding-right:2px" class="labelmedium">
					
						<table width="100%" style="cursor: pointer;" 
						    onclick="customertoggle('customerinvoicedata',document.getElementById('customerinvoiceidselect').value,'','#url.warehouse#','#url.addressid#');">
												
							<tr id="customerinvoicedata_main">
								
								<td align="left" id="customerinvoicedata_toggle" style="width:1px;padding-right:4px" class="hide">
								
									<img src="#SESSION.root#/Images/ToggleDown.png" 
									    id="customerinvoicedata_exp" 
										height="18" 
										width="18" 
										border="0" 
										class="show" 
										align="absmiddle">
										
									<img src="#SESSION.root#/Images/ToggleUp.png" 
									   id="customerinvoicedata_col" 
									   height="18" 
									   width="18" 
									   border="0" 
									   class="hide" 
									   align="absmiddle">
																
								</td>
								<!---
	                            <td class="labelmedium clsCustomerBilling"><span class="fontLight"><cf_tl id="Billing"></span></td>	
								--->
							</tr>	
						</table>						
					</td>
	             
					<td colspan="2" valign="top" style="padding-top:6px">
					
						<table width="100%" class="clsCustomerBilling">
												
							<tr>
							
							    <td width="100" onkeydown="if (event.keyCode==13) {$('##ItemSelect').focus(); }" style="border-top-left-radius:0px;border-bottom-left-radius:0px;border:0px solid silver" class="clsNoPrint"> 
							
								<input type="hidden" id="customerinvoiceidselect" name="customerinvoiceidselect" value="#url.customerid#">
								<input type="hidden" id="customerinvoiceidselect_val" name="customerinvoiceidselect_val" value="">
								
								<cf_tl id="Select the person recorded for the Invoice" var="1">
															
							  	<cfinput type   = "text" 
									  name      = "customerinvoiceselect" id="customerinvoiceselect"	
									  onfocus   = "document.getElementById('customerselectbox').className ='hide';" 
									  onblur    = "this.style.border='0px solid silver';forceSelect(this, 'customerinvoiceidselect');"			 
									  style     = "padding-left:4px;;background-image:linear-gradient(to bottom,##ffffff,##ffffff);padding-left:3px;width:90px;height:26;font-size:14px" 	
									  autocomplete = "off"			  									  							  	  
									  onkeyup   = "searchcombo('#get.mission#','#url.warehouse#','','customerinvoice',this.value,'up','','##customerinvoiceidselect_val');"
									  onkeydown = "searchcombo('#get.mission#','#url.warehouse#','','customerinvoice',this.value,'down','','##customerinvoiceidselect_val');">
								  							  
								  </td>
								
								   <td style="width:100%;color:##f4f4f4;border:0px solid silver;" class="regular">	
							       
								   <table style="width:100%">
									
									   <tr>									   
									   	   <td id="customerinvoicebox" class="fixlength"
										     style="background-color:99E8CA;height:26px;max-width:150px;min-width:150;font-size:14px;padding-left:5px;padding-top:1px">											 
										    <cfinclude template="getCustomerBilling.cfm">		
									   	   </td>							  	
									   </tr>  								  
								   
								   </table>
							 	   </td>
								   
								   <td style="padding-right:4px" class="clsNoPrint">
							  
								  		<cfset link = "#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applySaleHeader.cfm?field=billing&customerid={customeridselect}&warehouse=#url.warehouse#&requestno={RequestNo}">
										
								  		<cf_selectlookup
										    box          = "salelines"
											title        = "CustomerInvoice"
											icon         = "Logos/Search.png"
											link		 = "#link#"
											des1		 = "CustomerIdInvoice"
											button       = "No"
											style        = "width:25;height:26;border:none;"
											close        = "Yes"			
											datasource	 = "AppsMaterials"		
											class        = "Customer">	
										
							  		</td>			
								 
							</tr>
														
						</table>
						
						</td>
						</tr>
						
						<!--- combo box to select the billing person --->
						<tr id="boxc">
							<td></td>
							<td bgcolor="white" id="customerinvoiceselectbox">			
								<div style="position:absolute;  color: white; z-index: 2000;left:800" id="customerinvoicefind"></div>			
							</td>
						</tr>	
						
						<tr id="customerinvoicedata_box" class="hide">							    
							<td style="padding-top:4px;padding-right:3px" colspan="3" id="customerinvoicedata_content"></td>	
						</tr>	
						
					</table>
				
				</td>
				
				<td style="width:5px"></td>
																							
				</tr>	
													
			</table>	
												
			</td>
			</tr>	
										
			<tr class="labelmedium line">
			<td style="padding-top:5px;height:34px;padding-left:14px;padding-right:10px" colspan="5">
						
			<table height="100%" align="left">
									
			<tr style="height:32px;fixlengthlist">
								
					<td style="border:0px solid silver;min-width:60px;font-size:20px" id="trarequestno" align="center">					
					<cfinclude template="getCustomerRequest.cfm">					
					</td>			
												
					<!--- --------------- --->
					<!--- CURRENCY SELECT --->
					<!--- --------------- --->		
			
					<td style="border:0px solid silver;border-bottom:0px solid gray;height:20px;padding-right:4px;padding-left:15px; color:##000000;"><cf_tl id="currency"></td>
					<td style="min-width:70px;border-bottom:0px solid gray">				
									
					<cfquery name="currencylist" 
					  datasource="AppsLedger" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						    SELECT *
							FROM   Currency
							WHERE  EnableProcurement = 1	   							   
					</cfquery>
					
					<select name="currency" id="currency" style="background-color:f1f1f1;font-size:16px;height:100%;width:100%;border:0px;" class="regularxxl"
						onchange="ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applySaleHeader.cfm?field=currency&currency='+this.value+'&requestno='+document.getElementById('RequestNo').value+'&customeridinvoice='+document.getElementById('customerinvoiceidselect').value,'salelines','','','POST','saleform')">
						
						<cfloop query="currencylist">
							<option value="#Currency#" <cfif get.SaleCurrency eq currency>selected</cfif>>#Currency#</option>
						</cfloop>
						
					</select>								
					
					</td>	
					
					<!--- --------------- --->
					<!--- ---Commision--- --->
					<!--- --------------- --->		
					
					<td align="right" style="padding-left:10px;border-top:0px solid gray;border-right:0px solid gray">
					
						<table style="height:100%">
						<tr class="labelmedium2">
						
						<td style="padding-right:10px; color:000000"><cf_tl id="Sale"></td>
						<td style="min-width:120px;border-left:0px solid gray" id="personbox">
						
						<!--- get people that have an active assignment in the mission and in the orgunit of the warehouse --->
																
							<cfset URL.mission  		= get.mission>
							<cfset URL.MissionOrgUnitId = get.MissionOrgUnitId>
							<cfset URL.SaleId 			= "salespersonno">
							<cfset URL.field            = "salesperson">
														
							<cfinclude template="getSalesPerson.cfm">								
						
						</td>
						</tr>
						</table>				
					</td>							
					
					
					<!--- --------------- --->
					<!--- SCHEDULE SELECT --->
					<!--- --------------- --->				
					
					<td align="left" style="padding-left:10px;;border-top:0px solid gray;border-right:0px solid gray">
					
						<table style="height:100%">
						<tr class="labelmedium2">						
						<td style="padding-right:10px; color:##000000"><cf_tl id="Schedule"></td>
						<td style="min-width:100px;border-left:0px solid gray" id="schedulebox">
						
						<cfinclude template="getSchedule.cfm">					
						
						</td>
						</tr>
						</table>				
					</td>
										
					<!--- ----------------- --->
					<!--- --DISOUNT APPLY-- --->
					<!--- ----------------- --->				
					
					<td align="left">
					
						<table height="100%" style="border-top:0px solid gray">
						
						<tr class="labelmedium2">
						
						<td style="padding-left:10px;padding-right:10px; color:##000000;"><cf_tl id="Discount"></td>
						<td style="border-left:0px solid gray;border-right:0px solid gray;" id="discountbox">
						
						<cfinclude template="getDiscount.cfm">
																		
						</td>
						</tr>
						</table>				
					</td>
					
					</tr>
			</table>
			</td>
			</tr>
							
			<tr><td style="padding-left:14px; padding-right:10px;" colspan="2" height="100%" valign="top" width="100%">
							
				<cfset htx = "100%">
												
					<table border="0" width="100%" height="100%" style="border-top:0px solid silver;">
										   						
						<tr style="height:10px;border-bottom:1px solid silver">
						<td style="padding:5px 10px 6px 0;">
						
							<table width="99%" border="0" class="clsPOSDetailLinesHeader">
							
							<tr class="labelmedium">
								<cf_tl id="Show/hide details" var="1">
							    <td style="min-width:50px" align="center" colspan="2"><i class="fas fa-chevron-square-down" style="cursor:pointer;color:##033F5D;font-size:22px;" onclick="$('.clsDetailLineCell').toggle();" title="#lt_text#"></i></td>
								<td style="width:90%">
									<cf_tl id="Item">
									<div class="clsDetailLineCellHeader">
										<cf_tl id="Code">, <cf_tl id="UoM">, <cf_tl id="Minimum Purchase">
									</div>
									
								</td>	
								<td style="min-width:200px"><cf_tl id="Stock"></td>						
								<td style="min-width:50px;" align="right"><cf_tl id="Qty"></td>	
								<td style="min-width:100px" align="right">								
									<b><cf_tl id="Your Price"></b>
									<div class="clsDetailLineCellHeader">
										<cf_tl id="Price">
									</div>
								</td>
								<td style="min-width:103px;padding-right:3px;" align="right" style="padding-right:4px">
									<cf_tl id="Extended">
									<div class="clsDetailLineCellHeader">
										<cf_tl id="Tax">
									</div>
								</td>
							</tr>
							
							</table>
						</td>
						</tr>
						
						<tr style="border-bottom:1px solid silver;">
													
						    <td height="100%" width="100%" valign="top" style="background-color:f9f9f9"> 		
							
						    <cf_divscroll id="salelines" overflowy="scroll">																
							   <cfinclude template="SaleViewLines.cfm">								
							</cf_divscroll>   							
							</td>
						</tr>
												
																						
					</table>					
											
			</td>		
			</tr>	
											
			<!--- customer and actions --->
										
			<tr><td colspan="2" style="padding-top:4px;padding-left:9px;padding-right:10px;max-height:210px;">
			
				<table height="100%">
				
				<tr>
				
				<td valign="top" style="padding-top:4px;padding-left:5px;min-width:340px;padding-right:5px" class="clsNoPrint">
				
					<table>
					
						<cfif get.SaleMode gte "1">
						
							<tr class="clsNoPrint">
							<td style="height:40px;padding-top:4px;padding-left:5px; color:##000000;">
			
								<table cellspacing="0" cellpadding="0">
								<tr>
								<cf_tl id="Toggle footer details" var="1">
								<td style="width:100px;color:##0678ba; cursor:pointer; text-decoration:underline;"
								  title="#lt_text#" class="labellarge" onclick="$('.clsFooterDetail').toggle()">
								<cf_tl id="Code">
								</td>
								
								<td style="padding-left:6px; color:##000000;width:200px;">
								  <cfoutput>
																 
								  <input type    = "text" 
								       onkeyup   = "doItemSelect(this, event, '#url.warehouse#')" 							 
									   name      = "ItemSelect" 
									   id        = "ItemSelect"
									   tabindex  = "1000" 
									   onfocus   = "this.style.border='2px solid ##6483a2'" 
									   onblur    = "this.style.border='1px solid silver'"
									   class     = "regularxl"
									   style     = "border-radius:0px;height:33px; width:100%;min-width:100px;">
									   
								   </td>
								   
								   <td style="padding-left:1px;">	   

									<cf_tl id="Search" var="1">
									
									<input type = "button" 
										value   = "#lt_text# &raquo;" 
										style   = "width:85px;font-size:16px;height:33px;" 
										class   = "button10g clsItemSelectButton" 
										onclick = "doItemSelect(document.getElementById('ItemSelect'), null, '#url.warehouse#')">
									   							   
								  </cfoutput>	 
								</td>
								</tr>
								<tr><td id="finditem" colspan="3" class="label" style="padding-left:3px; max-height:30px;height:30px;max-width:20%;width:20%;"></td></tr>
								</table>
								
							</td></tr>	
						
						</cfif>				
																	
						<tr class="clsFooterDetail"><td valign="middle" width="100%" style="padding-bottom:0px; padding-right:0px;">				         
								<cfinclude template="SaleViewMenu.cfm">							
						</td></tr>							
					
					</table>		
	
				</td>	
				
				<cfif url.scope eq "POS">		
				
				<td width="50%" style="padding-top:4px;height:100px;" valign="top" class="clsFooterDetail clsCustomeradditional;#full#">
													
					<div id="customeradditional" style="border-bottom-left-radius:10px;height:100%; padding-top:1px; padding-bottom:3px;background-image: linear-gradient(to bottom,##ffffff,##fffffff);">								
						<cfinclude template="getCustomerInfo.cfm">
					</div>
													
				</td>
				
				<cfelse>
				
				<td width="50%"></td>
				
				</cfif>
													
				<td width="50%" valign="top" style="padding-top:4px;min-width:300px;" class="clsFooterDetail">
				
					<table width="100%" height="100%">
																					
						<tr><td style="border-bottom-right-radius:10px;padding-bottom:5px;padding-top:4px;background-image: linear-gradient(to bottom,##fafafa,##eaeaea);">
																		
						<cfquery name="getTotal"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT SUM((SchedulePrice - SalesPrice) * TransactionQuantity) AS Discount,
								       SUM(SalesAmount) AS Sales, 
								       SUM(SalesTax) AS Tax, 
									   SUM(SalesTotal) AS Total 
								FROM   CustomerRequestLine
								WHERE  RequestNo = '#url.requestNo#'									
						</cfquery>
														
						<cfoutput>													
											
						<table width="95%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
							<!--- ------------------------ --->	
						    <!--- total amount without tax --->
							<!--- ------------------------ --->		
													
							<tr class="clsNoPrint line"><td class="labellarge" style="color:##666666;"><cf_tl id="Net total"></td>						   
							    <td id="totalamount" align="right" style="color:##666666; ">#numberformat(getTotal.Sales,',.__')#</td>
							</tr>															
							<tr id="discountbox" class="clsNoPrint"><td class="labelmedium line" style="padding-left:10px;color:gray;"><cf_tl id="Discount">:</td>						   
							    <td id="totaldiscount" align="right" style="padding-right:20px; color:green; ">#numberformat(getTotal.Discount,',.__')#</td>
							</tr>														
							<!--- ------------------------ --->	
						    <!--- ------total tax--------- --->
							<!--- ------------------------ --->		
							<tr class="clsNoPrint line"><td class="labellarge" style="color:##666666;"><cf_tl id="Tax"></td>
								<td id="totaltax" align="right" style="color:##666666;">#numberformat(getTotal.Tax,',.__')#</td>
							</tr>			
														
							<!--- ------------------------ --->	
						    <!--- ----total receiavable -- --->
							<!--- ------------------------ --->		
							
							<tr><td style="padding-top:3px;font-size:20px;color:##666666; " class="labellarge"><cf_tl id="Total"></td>
							    <td align="right"
							        id="total"
							        style="font-size:38px; color:##666666;">#numberformat(getTotal.Total,',.__')#</td>
							</tr>
							
							<tr><td height="3%" colspan="2" class="line"></td></tr>
							
							<tr class="clsNoPrint">
							<td colspan="2" valign="bottom" align="center" style="padding-top:20px;padding-right:20px">
												
								<cfif get.SaleMode eq "1" or get.SaleMode eq "3">
									<cfset vScriptFunction = "posreceivable('#url.warehouse#')">
									<cf_tl id="Post Receivable" var="label1">
								<cfelse>							
									<cfset vScriptFunction = "possettlement('#url.warehouse#')">			
									<cf_tl id="Record Tender" var="label1">
								</cfif>	   		
								
								<cfset label1 = replaceNoCase(label1," ","&nbsp;","ALL")> 
																																														
								<cf_button2
										text		= "#label1#" 
										id			= "tenderbutton"  
										bgColor		= "##FFFF00"
										textsize	= "18px" 
										textColor   = "##black"
										image       = "payment-methods.png"
										imagepos    = "right"
										height		= "66px"
										class       = "#vHide#" 
										width		= "80%"
	                                    imageHeight = "48px"										
										style		= "cursor:pointer;min-width:150px;border-radius: 4px!important;background-color: ##FFFF00;background-repeat: no-repeat;background-size: 48px 48px;background-position:  270px 8px;padding-right: 40px;"																
										onclick		= "#vScriptFunction#">	
										
							</td></tr>
							 				
						</table>
						
						</td>
						</tr>
					
					</table>
																					
					</cfoutput>				
				
				</td>				
				</tr>			
				</table>
								
		    </td>
			</tr>
		
		</table>
			
	</td></tr>
	
	</table>
	
	</cfform>
	
	</td>
	
	</tr>
	
	</table>
	
				
<style>

INPUT, SELECT{
border: 1px solid ##CCCCCC;
border-radius: 0px;
font-size: 13px;
}

##tenderbutton{border:none!important;}
##Print:hover{background-color: transparent!important;}
.switch-customer{border:1px solid ##CCCCCC;background: ##ffffff;border-radius: 5px!important;display: block;height: auto; height: 48px;margin-right: 24px;}
.switch-customer:hover{background-color: ##f1f1f1!important;}
.fontLight{font-weight: 400;font-size: 18px;}
.highLight4{background-color: transparent!important;}
h2{font-size: 20px;font-weight: 200;}

.btn {
    display: inline-block;
    font-weight: 400;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    border: 1px solid transparent;
    font-size: 1rem;
    line-height: 1.5;
    border-radius: .25rem;
    transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
    font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif,"Raleway",sans-serif!important;
}

.btn span{
    position: relative;
    top: -10px;
    }

.btn-light {
    color: ##212529;
    background-color: ##f8f9fa;
}

.btn-lg{
    margin-bottom: 10px;
    font-size: 16px;
    border: 1px solid ##CCCCCC;
    padding: .3rem 0.8rem 0.1rem 0.4rem!important;
}

.btn-lg:hover{
    background: ##E7EEF4;
}

a.date-picker-control:link, a.date-picker-control:visited {
    margin: 0 0 0 1px;
}

.CustDOB input{
    width: 85px;
}

.clsDetailLineCell {
	font-size:100% !important; 
	color:##808080;
}

.clsDetailLineCellHeader {
	font-size:65% !important; 
	color:##808080;
}

.clsPOSDetailLinesHeader td {
	font-size:115% !important;
}

.clsPOSDetailLines td, .clsPOSDetailLines td span, .clsPOSDetailLines td div {
	font-size:135%;
}

// @media (max-width: 1000px) {
//  .clsButton2IconLeft, .clsButton2Text, .clsCustomeradditional, .clsCustomerBilling {
//    display: none;
//   }
 

  .clsButton2Button {
	  width:75px !important;
	  height:75px !important;
  }
}

</style>

</cfoutput>

</cfif>
