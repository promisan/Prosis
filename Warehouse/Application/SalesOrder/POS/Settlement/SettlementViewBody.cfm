	<table border="0" width="100%" height="100%">
	
	<cfquery name="qType" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT   SM.Code, S.Description, S.Mode, SM.GLAccount
		FROM     Ref_SettlementMission SM INNER JOIN  Ref_Settlement S 
		ON       SM.Code        = S.Code
		WHERE    S.Operational  = '1'
		AND      SM.Mission     = '#qWarehouse.Mission#'
		ORDER BY ListingOrder Asc
	</cfquery>
	
	<tr class="line">	
			
		<td colspan="2" style="padding-left:10px"> 
		
			<table>
						
			<tr>			
				
				<cfinvoke component  = "Service.Process.Materials.Customer"  
					method           = "CustomerReceivables" 
					mission          = "#qWarehouse.Mission#" 
					customerid       = "#Sale.customerId#"  			
					returnvariable   = "credit">	
					
				<input type="hidden" id="settlement"     name="settlement"     value="<cfoutput>#qType.code#</cfoutput>"> 		   
				<input type="hidden" id="btn_settlement" name="btn_settlement" value="tdm<cfoutput>#qType.code#</cfoutput>"> 	
			
				<cfset vType = "">
				
				<cfoutput query="qType">
				
					<cfif glaccount eq "" and credit.threshold eq "0">
					
						<!--- not shown as invoice customer does not have option for credit --->
					
					<cfelse>
				
						<cfset vClass = "">
						<cfif currentrow eq 1>
							<cfset vType = qType.Code>
							<cfset vClass = "active_color">									
						</cfif>
						
                        <style>
                            .tdmmenu, .clear_color{ background: ##ffffff;color:##333333!important;}
                            .active_color, .over_color, .over_color p{
                                background: ##f1f1f1!important;
                                color:##333333!important;
                            }
                        </style>
												
						<td onmouseover="mouseover(this)" onmouseout="mouseout(this)" 
							onclick="setmode('#mode#','#code#')" style="width:140px !important; height:80px; border:1px solid ##cccccc;">
								
								<table width="100%" height="100%" align="center">
								<tr><td align="center"><i class="fas stlmnt-md#lcase(mode)# stlmnt"></i></td></tr>
								<tr class="labelmedium">
								<td id="tdm#code#" name="tdm#code#" class="tdmmenu #vClass#" style="padding-bottom:4px;font-size:14px" valign="bottom"><cf_tl id="#Description#"></td></tr>
								</table>									
								
						</td>		
						
					</cfif>										
					
				</cfoutput>
				
			</tr>
			
			</table>
	
		</td>  
	</tr>
		
	<tr>
	
	<td valign="top" style="width:400px;min-width:400px;max-width:400px;padding-left:17px;padding-top:10px">
				
		<table width="100%">
			
		<tr>	
		    <td colspan="1" style="padding-left:2px;padding-right:2px;padding-top:1px">
				<table width="100%">			
					<tr>
						<td height="10" 
						  align="center" 
						  colspan="2" 			 
						  bgcolor="white"  
						  id="additional" 
						  name="additional" 
						  class="settlement_details" 
						  style="background-color:f4f4f4;border:0px outset gray;height:115px;padding-right:10px;padding-left:10px">			  
						    <cfset url.mode = qType.mode>	
														
							<cfinclude template="SettlementDetails.cfm">	
															  
						</td>
					</tr>
				</table>
			 </td>
		</tr>
			
		<cfquery name="qCurrency" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
			SELECT   DISTINCT Currency
			FROM     WarehouseCategoryPriceSchedule
			WHERE    Warehouse = '#qWarehouse.Warehouse#'
			UNION 
			SELECT   SaleCurrency as Currency
			FROM     Warehouse
			WHERE    Warehouse = '#qWarehouse.Warehouse#'
			
		</cfquery>
		<cfif url.td eq "">
		<tr>
			<td colspan="2" style="padding-top:4px">
				<cf_intelliCalendarDate9
				FieldName="SettlementDate"
				class="regularxl" style="font-size:20px"
				DateFormat="#APPLICATION.DateFormat#"
				Default="#dateformat(now(), CLIENT.DateFormatShow)#">
			</td>
		</tr>
		</cfif>
		<tr>
		
			<td colspan="2" style="padding-right:0px"> 
			
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formspacing">
				
					<tr>
					
					<input type="hidden" id="currency" name="currency" value="<cfoutput>#qWarehouse.SaleCurrency#</cfoutput>"> 
	
					<input type="hidden" id="btn_currency" name="btn_currency" value="tdc<cfoutput>#qWarehouse.SaleCurrency#</cfoutput>"> 
										
					<cfoutput query="qCurrency">	
					
						<cfif qWarehouse.SaleCurrency eq currency>					
							<cfset vClass = "active_color">			
						<cfelse>
							<cfset vClass = "">							
						</cfif>			
									
						<td height="30px" style="padding:0px" onclick="setcurrency('#currency#')">
							
								<table cellpadding="0" cellspacing="0" width="100%" height="100%">
									<tr>
										<td align="center"id="tdc#Currency#" name="tdc#Currency#" class="labelit #vclass#" 									 
									     onmouseover="javascript:mouseover(this)" onmouseout="javascript:mouseout(this)"
										   valign="center" style="cursor:pointer;border:1px solid gray">#Currency#</td>
									</tr>
								</table>
							
						</td>		
						
					</cfoutput>	
					
					</tr>
				
				</table>
				
			</td>
		
		</tr>
		
		<tr><td height="5"></td></tr>
	
		<tr>
			<td colspan="2">
				<table cellpadding="0" cellspacing="0" width="100%">
					<tr>
					   					
						<td align="left" width="50%" style="padding-left:5px;">
							<input type="Text" 
								  id   = "line_amount_number" 
								  name = "line_amount_number" 
								  maxlength="9" 
								  value=""
								  style="text-align:right;font-size:22px;height:30px;border:1px solid gray;border-radius:4px;padding-right:4px;width:95%;"
								  class="regularxl" 
								  onKeyUp="saveenter()"
								  onfocus="setFocusPOS(this,'yes')">
								  
						</td>
						
						<td align="right" width="50%" style="padding-left:5px;padding-right:5px;">
						
						    <cf_tl id="Save" var="1">
							<cfoutput>
								<input class="button10g"  
								   style="width:100%;height:31px;font-size:15;width:95%;" 
								   type="button" 
								   name="Update" 
								   id="Update" 
								   value="#lt_text#" 							   
								   onClick="saveline('#url.warehouse#','#url.customerid#','#url.batchid#','#url.terminal#','#url.td#','#url.th#','#url.tm#','#url.addressid#','#url.requestno#')">	
							</cfoutput>	
						</td>
					</tr>
				</table>
			</td>
		</tr>
			
		<tr>
			<td colspan="2" bgcolor="white" align="center" id="dkeypad" name="dkeypad" style="padding-top:3px">
				<cf_keypad type="numeric" buttonwidth="84" buttonheight="68">		
			</td>
		</tr>
		
		</table>
	
	</td>
	
	<cfoutput>
		<input type="hidden" name="transaction_date"   id="transaction_date" value="#url.td#"> 	
		<input type="hidden" name="Transaction_hour"   id="transaction_date" value="#url.th#"> 	
		<input type="hidden" name="Transaction_minute" id="transaction_date" value="#url.tm#"> 					
	</cfoutput>
	
	<td valign="top" style="padding-left:40px;padding-top:6px" align="right">
	
		<table width="100%" height="100%">
		
			<tr>
			<td style="height:30px;padding-top:4px;padding-left:6px">
				<table style="width:100%">
				<tr class="labelmedium">
				<td valign="bottom" style="font-size:15px;padding-bottom:3px;padding-right:10px"><cf_tl id="Memo"></td>
				</tr>
				<tr>
				<td>
				<input type="text" name="transactionmemo" id="transactionmemo" maxlength="100" class="regularxl" 
				   style="font-size:20px;height:30px;width:98%;background-color:ffffcf">
				</td>		
				</tr>
				</table>
				</td>
			</tr>
							
			<tr>	
				<td height="100%" valign="top" style="width:100%;padding-left:4px;padding-top:5px;padding-bottom:16px;padding-right:10px" id="dlines">
				<cfinclude template="SettlementLines.cfm">		
				</td>	
			</tr>
		
		</table>
		
	</td>
	</tr>	
	
	</table>
<cfset ajaxOnLoad("doCalendar")>

  