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
<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrder
	WHERE    WorkOrderId   = '#url.workorderid#'	
</cfquery>	

<cfquery name="Param" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#workorder.mission#' 		
</cfquery>  

<cfquery name="clearme" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM WorkOrderLineItemBilling
	WHERE WorkOrderItemBillingId IN (

			SELECT WorkOrderItemBillingId
			FROM   WorkOrderLineItemBilling B
			WHERE NOT EXISTS ( SELECT 'X' 
						       FROM  Accounting.dbo.TransactionHeader
							   WHERE Journal         = B.Journal
							   AND   JournalSerialNo = B.JournalSerialNo
							   AND   RecordStatus   != '9' 
							   AND   ActionStatus   != '9'
							   )
			)
	
</cfquery>	

<cfquery name="getLines" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   L.WorkOrderItemId, L.Quantity,
	
	         <!--- already billed --->
			 
                (SELECT     ISNULL(SUM(Quantity), 0)
                 FROM       WorkOrderLineItemBilling B
                 WHERE      WorkOrderItemId = L.WorkOrderItemId
				 AND        EXISTS  (SELECT 'X' 
						             FROM  Accounting.dbo.TransactionHeader
						             WHERE Journal         = B.Journal
								     AND   JournalSerialNo = B.JournalSerialNo
									 AND   RecordStatus != '9' AND ActionStatus !='9')) AS QuantityBilled, 
				 
			 L.SaleAmountIncome, 
			 L.SaleAmountTax, 
			 L.SalePayable, 
			 L.WorkOrderId, 
			 L.WorkOrderLine, 
             I.ItemNo, 
			 I.ItemDescription, 
			 U.UoMCode, 
			 U.UoMDescription, 
			 U.ItemBarCode
	FROM     WorkOrderLineItem L INNER JOIN
             Materials.dbo.Item I ON L.ItemNo = I.ItemNo INNER JOIN
             Materials.dbo.ItemUoM U ON L.ItemNo = U.ItemNo AND L.UoM = U.UoM
	WHERE    WorkOrderId     = '#url.workorderid#'
	AND      WorkorderLine   = '#url.workorderline#'
	
	<!--- no lines which have been billed already --->
	
	AND      NOT EXISTS (SELECT 'X'
	                     FROM   Materials.dbo.ItemTransaction
						 WHERE  WorkOrderId = L.WorkOrderId
						 AND    WorkOrderLine = L.WorkorderLine
						 AND    TransactionType = '2') 
	
</cfquery>	


<cfquery name="check" dbtype="query">
	SELECT   *
	FROM     getLines
	WHERE    QuantityBilled < Quantity
</cfquery>	

<cfif check.recordcount eq "0">

<table width="100%">
						
	<tr class="line">
					
	<td class="labellarge" style="font-size:22px;padding-right:20px"><cf_tl id="No more lines found to bill in advance"></td>
	
	</tr>
	
</table>	
					

<cfelse>


<!--- 
1.	get the lines of the workorder
2.	apply the correct calculation if already partially invoiced (not likely)
3.  generate invoice with a booking on the advance account, so it can be offsetted
--->

	<cfform name="billingform">
	
	<table width="96%" align="center">
	
	<tr><td width="100%" colspan="2">
	
		<table width="100%" align="center" class="formpadding navigation_table">
		
		    <tr><td colspan="8">
			
				<table width="100%">
				
					<cfoutput>
					
					<tr class="line">
					
					<td class="labellarge" style="font-size:35px;padding-right:20px"><cf_tl id="Preliminary Invoice"></td>
					
					<td align="right">
					
					<table align="right">
					<tr style="fixlengthlist">
				    			
					<td width="60" class="labelmedium"><cf_tl id="Date">:</td>
					<td colspan="4" class="labelmedium" style="padding-left:3px">
					 			 
					 <cf_intelliCalendarDate9
						FieldName="TransactionDate" 
						Class="regularxxl"
						Default="#dateformat(now(),client.dateformatshow)#"
						AllowBlank="False">	
					  
					</td>
					
					<cfquery name="Terms" 
							datasource="AppsWorkOrder"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					   	    SELECT     *
							FROM       Ref_Terms							
					</cfquery> 	
					
					<td width="60" class="labelmedium" style="padding-left:20px;padding-right:10px"><cf_tl id="Terms">:</td>
					
					<td>			
					<select name="terms" id="terms" class="regularxxl">
							<cfloop query="Terms">
								<option value="#Code#">#Description#</option>
							</cfloop>
						</select>
					</td>	
					
					<td width="60" style="padding-left:10px" class="labelmedium"><cf_tl id="Fiscal">:</td>
					<td width="60" class="labelmedium" style="padding-left:3px">
															
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
					
					<select name="AccountPeriod" class="regularxxl">
						 <cfloop query="PeriodList">
						 	<option value="#AccountPeriod#" <cfif param.currentaccountperiod eq Accountperiod>selected</cfif>>#AccountPeriod#</option>
						 </cfloop>
					</select>
					
					</td>
					</tr></table>
									
					</td>				
					</tr>		
					
					</cfoutput>	   	
				
				</table>
		
		</td></tr>
		
		<tr><td colspan="8">
		
			<table width="100%">
			<tr>							
				<td width="60" class="labelmedium"><cf_tl id="Memo">:</td>
				<td style="height:40px;padding-left:3px">
				<input type="text" name="Memo" value="" class="regularxl" style="width:100%" maxlength="100">
				</td>
			 </tr>
			 </table>
		 
		 </td></tr>
		
		<tr class="line labelmedium fixlengthlist">
		    <td></td>
			<td><cf_tl id="Item"></td>
			<td><cf_tl id="UoM"></td>
			<td><cf_tl id="Barcode"></td>
			<td align="right"><cf_tl id="Quantity"></td>
			<td colspan="3" align="right"><cf_tl id="Amount"></td>
			<!---
			<td align="right"><cf_tl id="Tax"></td>			
			<td align="right"><cf_tl id="Total"></td>
			--->
		</tr>
		
		<cfset tot = 0>
		<cfset sal = 0>
		<cfset tax = 0>
		
		<cfoutput query="getLines">
			
			<cfset qty = Quantity-QuantityBilled>
			
			<cfif qty gt "0">
				
				<cfset ratio = (Quantity-QuantityBilled)/Quantity>			
				<tr class="labelmedium2 navigation_row fixlengthlist line">
				    <td style="padding-left:4px">
						<input type="checkbox" 
					    class="radiol" 
						checked
						name="Selected" 
						onclick="ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Prebilling/setTotal.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','sale','','','POST','billingform')"
						value="'#workorderitemid#'">
					</td>
					<td>#ItemDescription#</td>
					<td>#UoMDescription#</td>
					<td>#ItemBarCode#</td>
					<td align="right">#qty#</td>
					<td colspan="3" align="right">#numberformat(SaleAmountIncome*ratio,",__.__")#</td>
					<!---
					<td align="right">#numberformat(SaleAmountTax*ratio,",__.__")#</td>
					<td align="right">#numberformat(SalePayable*ratio,",__.__")#</td>
					--->
				</tr>			
				<cfset tot = tot + SalePayable*ratio>
				<cfset sal = sal + SaleAmountIncome*ratio>
				<cfset tax = tax + SaleAmountTax*ratio>
				
			</cfif>	
		
		</cfoutput>
		
		<cfoutput>
		
			<tr class="labelmedium">
			    <td colspan="5" id="sale"></td>
				<td colspan="2"><cf_tl id="Goods and service">:</td>
				<td align="right" style="padding-right:4px">
				<input type="text" value="#numberformat(sal,",__.__")#" readonly id="saleamount" name="saleamount" class="regularxl enterastab" style="padding-right:4px;width:100px;text-align:right;background-color: AFEEEE;">				
				</td>
			</tr>
			
			<cfquery name="Entry" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					   SELECT    R.Area, R.ListingOrder, R.Description, R.ApplyTax
					   FROM      Ref_ParameterMissionGLedger G INNER JOIN
			                     Ref_AreaGLedger R ON G.Area = R.Area
					   WHERE     R.BillingEntry = 1
					   AND       G.Mission = '#workorder.mission#'
					   ORDER BY  R.ListingOrder
			</cfquery>
					 
			<cfloop query="Entry">
			     <tr>
				 <td colspan="5"></td>
				 <td colspan="2" class="labelmedium" style="padding-left:10px;padding-right:4px"><cf_tl id="#Description#">:</td>
				 <td colspan="1" align="right" id="xxxxchargebox" class="labelmedium" style="padding-left:10px;padding-right:4px">
					 <input type="text" name="Amount_#Area#" value="#numberformat(0,",.__")#"
					 onchange="ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Prebilling/setTotal.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#','sale','','','POST','billingform')"
					 class="regularxl enterastab" style="padding-right:4px;width:100px;text-align:right">
				 </td>						
				 </tr>
			</cfloop> 
				
			
			<tr class="labelmedium">
			    <td colspan="5" id="Total"></td>
				<td colspan="2"><cf_tl id="Total">:</td>
				<td align="right" style="padding-right:4px">
				<input type="text" value="#numberformat(sal,",.__")#" readonly id="totalamount" name="totalamount" class="regularxl enterastab" style="padding-right:4px;width:100px;text-align:right;background-color: AFEEEE;">				
				</td>
			</tr>
						
			<tr class="labelmedium">
			    <td colspan="5" id="tax"></td>
				<td colspan="2"><cf_tl id="Tax">:</td>
				<td align="right" style="padding-right:4px">
				<input type="text" value="#numberformat(tax,",.__")#" readonly id="taxamount" name="taxamount" class="regularxl enterastab" style="padding-right:4px;width:100px;text-align:right;background-color: f1f1f1;">				
				</td>
			</tr>
					
			<tr class="labelmedium">
			
				<td colspan="5" class="labelmedium">
				
				<table><tr class="labelmedium"><td><cf_tl id="Owner">:</td>
							
				<!--- show only the last parent org structure --->
				
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
			 
				   <cfquery name="Owner" 
				    datasource="AppsOrganization" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				      SELECT    DISTINCT TreeOrder,
					            OrgUnitName,
								OrgUnit,
								OrgUnitCode 
				      FROM      #Client.LanPrefix#Organization
				   	  WHERE     (
					             ParentOrgUnit is NULL OR ParentOrgUnit = '' OR Autonomous = 1 
								)							 
					  AND       Mission     = '#workorder.Mission#'
					  AND       MandateNo   = '#getMandate.MandateNo#'
					  
					  <!---
					  <cfif getAdministrator(workorder.mission) eq "1">
			
						<!--- no filtering --->
					
					  <cfelse>
					  AND       ( 
					            OrgUnit IN (SELECT OrgUnit 
					                        FROM   Organization.dbo.OrganizationAuthorization 
											WHERE  Role = 'ProcApprover' 
											AND    UserAccount = '#session.acc#' 
											AND    AccessLevel != '0') 
								OR 
								OrgUnit = '#Invoice.OrgUnitOwner#' 
								OR
							Mission IN (SELECT Mission 
					                        FROM   Organization.dbo.OrganizationAuthorization 
											WHERE  Role = 'ProcApprover' 
											AND    OrgUnit is NULL
											AND    UserAccount = '#session.acc#' 
											AND    AccessLevel != '0') 
								)			
					  </cfif>		
					  --->
					  
					  
					  ORDER BY  TreeOrder, OrgUnitName
				 </cfquery>
				 
				<td class="labelmedium" style="padding-left:3px">
				 			 
				  <select name="OrgUnitOwner" id="OrgUnitOwner" class="regularxl" style="width: 200px;">				     
				    <cfloop query="Owner">
			   		   	  <option value="#OrgUnit#">#OrgUnitName#</option>
			       	    </cfloop>  
			            </select>	
				  
				</td>	
				
				</table>
				</td>
								
				<td colspan="2" style="padding-left:0px"><cf_tl id="Payable">:</td>
				<td align="right" id="overall" style="padding-right:4px">
				<input type="text" value="#numberformat(tot,",__.__")#" readonly id="payableamount" name="payableamount" class="regularxl enterastab" style="padding-right:4px;width:100px;text-align:right;background-color: ffffaf;">				
		        </td>
			</tr>
		
		</cfoutput>
		
		</table>
		
		</td></tr>
						
		<tr><td colspan="2" class="line"></td></tr>
				
		<tr><td style="height:40px" colspan="2" align="center">
		
		<cf_tl id="Submit Pre-Invoice" var="1">
		
		<cfoutput>
		
		 <input type="button" 
			  class="button10g" 
			  style="font-size:13px;width:280px;height:32" 
			  onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('#session.root#/WorkOrder/Application/Assembly/Items/FinalProduct/Prebilling/PreBillingSubmit.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&systemfunctionid=#url.systemfunctionid#','processbox','','','POST','billingform')"
			  name="Submit" 
			  value="#lt_text#">
			  
		</cfoutput>	  
		
		</td></tr>
		
		<tr><td id="processbox"></td></tr>
			
	</table>
	
	</cfform>
	
</cfif>	

<cfset ajaxonload("doHighlight")>
<cfset ajaxonload("doCalendar")>