<!--
    Copyright © 2025 Promisan B.V.

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
<style>
		
	.inputamount_active {	   
	    margin-left: 1px;
	    padding-left: 2px;
	    padding-right: 3px;
		text-align:right;
		color:##ffffff;
		background-color: ##3C5AAB;		
	}	
	
	.tdmmenu, .tdcmenu {
		font-family: calibri;
		font-size:12px;
		color:##000;
		background-color:##ffffff;
		text-decoration:none;
		display:block;
		height:50px;
		padding:15px;
		cursor:pointer;
		border:0px solid ##DDD;
		text-align:center;
	}

</style>

<cfquery name="WorkOrder" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT    *
	FROM      WorkOrderLine WL INNER JOIN
              WorkOrder W ON WL.WorkOrderId = W.WorkOrderId
	WHERE     WL.WorkOrderLineId = '#url.workorderlineid#'	
</cfquery>	

<cfquery name="getSale"
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 	SELECT    Currency, 
				  SUM(SalePayable) as sTotal
		FROM      WorkorderLineCharge
		WHERE     WorkOrderId     = '#workorder.workorderid#'	
		AND       WorkOrderLine   = '#workorder.WorkOrderLine#'
		AND       OrgUnitOwner    = '#url.orgunitowner#'	
		AND       TransactionDate = '#url.transactiondate#'	
		AND       Journal IS NULL
		GROUP BY  Currency
</cfquery> 

<cf_tl id="Settlement" var="set">

<cfform id="salesdetails" name="salesdetails" method="POST" style="height:98%;padding-right:6px">

	<table width="100%" height="100%" bgcolor="FFFFFF">
	
	<tr>
	
	<td colspan="2" valign="top" style="padding-left:17px">
		
		<cfquery name="qType" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		     SELECT    SM.Code, 
			           S.Description, 
					   S.Mode
			 FROM      Ref_SettlementMission SM INNER JOIN Ref_Settlement S ON SM.Code = S.Code
			 WHERE     S.Operational = '1'
			 AND       SM.Mission    = '#workorder.Mission#'
			 ORDER BY  ListingOrder Asc
		</cfquery>
			
		<table>
				
		<input type="hidden" id="settlement"     name="settlement"     value="<cfoutput>#qType.code#</cfoutput>"> 		   
		<input type="hidden" id="btn_settlement" name="btn_settlement" value="tdm<cfoutput>#qType.code#</cfoutput>"> 
							   
		<tr>	
		
			<td colspan="2"> 
			
				<table width="100%" class="formspacing">
				
					<tr>
					
						<cfset vType = "">
						
						<cfoutput query="qType">
						
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
							
						</cfoutput>
						
					</tr>
				
				</table>
		
			</td>  
		
		</tr>
		
		</table>
		
	</td>
	
	</tr>	
			
	<tr>			
			    <td width="320" style="padding-left:10px;padding-right:2px;padding-top:1px">
				
					<table width="100%" width="100%">			
					
						<tr>
							<td height="10" 
							  align="center" 
							  colspan="2" 			 
							  bgcolor="white"  
							  id="additional" 
							  name="additional" 
							  class="settlement_details" 
							  style="border:0px solid gray;height:115;padding-right:10px;padding-left:18px">			  
							  
							      <cfset url.mode     = qType.mode>				
								  <cfinclude template = "SettlementDetails.cfm">			  
								  
							</td>
						</tr>
						
						<cfquery name="qCurrency" 
						  datasource="AppsWorkOrder" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  
							SELECT   DISTINCT Currency
							FROM     WorkOrder
							WHERE    WorkOrderid = '#WorkOrder.WorkorderId#'
									
						</cfquery>
						
						<tr>
						
							<td colspan="2" style="padding-right:0px"> 
							
								<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formspacing">
								
									<tr>
									
									<input type="hidden" id="currency" name="currency" value="<cfoutput>#workorder.Currency#</cfoutput>"> 
									<input type="hidden" id="btn_currency" name="btn_currency" value="tdc<cfoutput>#workorder.Currency#</cfoutput>"> 
														
									<cfoutput query="qCurrency">	
									
										<cfif workorder.Currency eq currency>					
											<cfset vClass = "active_color">			
										<cfelse>
											<cfset vClass = "">							
										</cfif>			
													
										<td height="30px" style="padding:0px" onclick="setcurrency('#currency#')">
											
												<table cellpadding="0" cellspacing="0" width="100%" height="100%">
													<tr>
														<td align="center"id="tdc#Currency#" name="tdc#Currency#" class="labelit #vclass#" 									 
													     onmouseover="javascript:mouseover(this)" onmouseout="javascript:mouseout(this)"
														   valign="center" style="cursor:pointer;border-radius:3px;border:1px solid gray">#Currency#</td>
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
									   					
										<td align="left" width="50%" style="padding-left:3px">
										
										<cfoutput>
										
											<input type="Text" 
												  id   = "line_amount_number" 
												  name = "line_amount_number" 
												  maxlength="9" 
												  size="13" 
												  value="#getSale.sTotal#"
												  style="text-align:right;height:30px;border:1px solid gray;border-radius:4px;padding-right:4px"
												  class="regularxxl" 
												  onKeyUp="saveenter()"
												  onfocus="setFocusPOS(this,'yes')">
												  
												  </cfoutput>
												  
												  
										</td>
										
										<td align="right" width="50%" style="padding-left:7px;padding-right:1px">
										
											<cfparam name="url.terminal" default="">
										 
										    <cf_tl id="Save" var="1">
											
											<cfoutput>
											
												<input class="button10g"  
												   style="width:95%;height:31;font-size:15" 
												   type="button" 
												   name="Update" 
												   id="Update" 
												   value="#lt_text#" 							   
												   onClick="settlementlineadd('#url.workorderlineid#','#url.orgunitowner#','#url.terminal#','#url.transactiondate#','#url.transactiontime#')">	
												   
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
				 
			
		<td valign="top" style="padding-top:6px;padding-left:10px;">
		
			<table height="100%">
									
				<tr>	
					<td valign="top" style="border-left:1px solid silver;width:500;padding-left:24px;padding-top:5px;padding-bottom:16px;padding-right:10px" id="dlines">					
						<cfinclude template="SettlementLines.cfm">		
					</td>	
				</tr>
			
			</table>
			
		</td>
	</tr>
	
	</table>

</cfform>

<cfset AjaxOnload("initPOS")>
<script>
	initPOS();
</script>
