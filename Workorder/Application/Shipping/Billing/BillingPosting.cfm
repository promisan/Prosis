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
<cfquery name="Journal" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   *
	FROM     Journal
	WHERE    Mission  = '#workorder.mission#' 
	AND      TransactionCategory IN ('Receivables','Advances')
	AND      Currency = '#workorder.currency#'
	ORDER BY TransactionCategory DESC, Journal
</cfquery>  

<cfquery name="PeriodList" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   *
	FROM     Period
	WHERE    AccountPeriod IN (SELECT AccountPeriod 
	                           FROM   Organization.dbo.Ref_MissionPeriod 
							   WHERE  Mission = '#workorder.mission#')
	AND      ActionStatus = '0'		
</cfquery>  
	
<cfquery name="Param" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#workorder.mission#' 		
</cfquery>  

<cfquery name="ServiceItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   *
	FROM     ServiceitemMission
	WHERE    ServiceItem = '#workorder.serviceitem#'
	AND      Mission = '#workorder.mission#' 		
</cfquery>  
	
<table width="100%">

<cfoutput>
	
<cfif journal.recordcount eq "0" or PeriodList.recordcount eq "0">

	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	   <td colspan="2" style="height:40" align="center" class="labelmedium">
	   <cfoutput>
	   <font color="FF0000"><cf_tl id="No receivables journal has been declared">#workorder.currency#</font>
	   </cfoutput>
	   </td>
    </tr>

<cfelse>

	<tr><td colspan="2" align="center">
		
			<table width="100%">
			
			<tr>
			
			<td style="padding-right:10px">
			
			    <cfoutput>
				
				<table width="100%" class="formspacing">				
																				
					<tr class="labelmedium2 fixlengthlist">
					   <td style="padding-left:20px"><cf_tl id="Goods and services"> #workorder.currency#:</td>			   
					   <td colspan="1" align="right" style="padding-right:5px">
				          <table><tr>
						  <td id="totalbox">
						   <input type="text" value="#numberformat(0,",.__")#" readonly id="saleamount" name="saleamount" class="regularxxl enterastab" style="padding-right:4px;width:100px;text-align:right;background-color: e1e1e1;">				
						   </td>
						   <td id="sale"></td>
				           </tr>
						   </table>
					    </td>					   
					</tr>
					
					<cfquery name="Entry" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							   SELECT    R.Area, R.ListingOrder, R.Description
							   FROM      Ref_ParameterMissionGLedger G INNER JOIN
					                     Ref_AreaGLedger R ON G.Area = R.Area
							   WHERE     R.BillingEntry = 1
							   AND       G.Mission = '#workorder.mission#'
							   ORDER BY  R.ListingOrder
					</cfquery>
							 
					<cfloop query="Entry">
					     <tr class="labelit">
						 <td style="padding-left:25px"><cf_tl id="#Description#"></td>
						 <td colspan="1" align="right" id="xchargebox" style="padding-right:15px">						 
							 <input type="text" name="Amount_#Area#" value="#numberformat(0,",.__")#" 
							 onchange="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/WorkOrder/Application/Shipping/Billing/setTotal.cfm?workorderid=#url.workorderid#','sale','','','POST','billingform')"
							 class="regularl enterastab" style="border:1px solid silver;padding-right:4px;width:100px;text-align:right">
						 </td>						
						 </tr>
					</cfloop> 
					
					<tr class="labelmedium2">					   
						<td style="padding-left:20px" colspan="1"><cf_tl id="Total">:</td>
						<td align="right" style="padding-right:15px">
						<input type="text" value="#numberformat(0,",.__")#" readonly id="totalamount" name="totalamount" class="regularxl enterastab" style="padding-right:4px;width:100px;text-align:right;background-color: AFEEEE;">				
						</td>
					</tr>
								
					<tr class="labelit">					    
						<td style="padding-left:20px" colspan="1"><cf_tl id="Tax">:</td>
						<td align="right" style="padding-right:15px">
						<input type="text" value="#numberformat(0,",.__")#" readonly id="taxamount" name="taxamount" class="regularl enterastab" style="border:1px solid silver;padding-right:4px;width:100px;text-align:right;background-color: f1f1f1;">				
						</td>
					</tr>
					
					<tr class="labelmedium2">
					    <td style="padding-left:20px" colspan="1"><cf_tl id="Payable">:</td>
						<td align="right" id="overall" style="padding-right:15px">
						<input type="text" value="#numberformat(0,",.__")#" readonly id="payableamount" name="payableamount" class="regularxl enterastab" style="padding-right:4px;width:100px;text-align:right;background-color: ffffaf;">				
				        </td>
					</tr>
					
				</table>	
				</cfoutput>
			
			</td>
			
			    <td width="67%" valign="top" style="padding-left:10px;padding-bottom:4px;padding-top:4px;border-left:1px solid silver">
			
			    <table width="100%">
				
					<tr><td><cfinclude template="BillingPostingInvoice.cfm"></td></tr>
						
					<tr>
						<td align="center" style="padding:8px">
							
							<cfif url.id eq "STA">
							 <cf_tl id="Prepare Receivable" var="1">
							 <cfelse>
							 <cf_tl id="Prepare Credit Note" var="1">
							 </cfif>
													
							 <cfoutput>
							 
								  <input type="button" 
									  class="button10g" 
									  style="border:1px solid silver;font-size:13px;width:380px;height:42" 
									  onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('BillingEntrySubmit.cfm?workorderid=#url.workorderid#&systemfunctionid=#url.systemfunctionid#&id=#url.id#','processbox','','','POST','billingform')"
									  name="Submit" 
									  value="#lt_text#">
							  
							 </cfoutput>
							  
						</td>						
						<td style="width:1px" id="processbox"></td>
							
					</tr>
			
				</table>
			
			</td>
			
			
			
			</tr>
						
			</table>					
				
			</td></tr>
						
				
		</table>	
	
	</td>
	</tr>
	
  </cfif>	
  
</cfoutput>  
	  
 </table>