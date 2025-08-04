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
<!--- select all PO's for this vendors with the same type --->

<cfparam name="InvoiceId" default="">

<cfset t= 0>

<cfif InvoiceId eq "">
     <cf_assignid>
     <cfset inid = rowguid>		 
<cfelse>
     <cfset inid = invoiceid>
</cfif>

<cfquery name="Lines" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
	SELECT    R.Mission, 
			  J.CaseNo,
			  PL.*,
			  			  
			  <!--- allow association ONLY for PO that are not fully matched/paid --->		  
			  
			   (
						SELECT  SUM(DocumentAmountMatched)
						FROM    InvoicePurchase S, Invoice INV
						WHERE   INV.InvoiceId = S.InvoiceId
						AND     S.RequisitionNo = R.RequisitionNo				
						AND     INV.InvoiceId      = '#inid#' 
						AND     INV.ActionStatus != '9'
						) as Amount,
						
					    
					    <!--- not posted --->
					
						(
						SELECT  SUM(S.AmountMatched)
						FROM    InvoicePurchase S, Invoice INV
						WHERE   S.InvoiceId     = INV.InvoiceId
						AND     RequisitionNo = R.RequisitionNo	
						AND     INV.ActionStatus != '9'											
						<!--- is not the current invoice --->											
						<cfif invoiceId neq "">						
						AND     INV.InvoiceId != '#inId#'					
						</cfif>			
						AND         
							(
								NOT EXISTS 
									( SELECT 'X'
									  FROM   Organization.dbo.OrganizationObject
							          WHERE  EntityCode      = 'ProcInvoice'
									  AND    ObjectKeyValue4 = INV.InvoiceId 
									 )
							)	
									 
					   	    <!--- AND     (INV.EntityClass IS NULL OR INV.EntityClass = '') --->
														
						) as AmountOnHold,		
						
						<!--- posted --->				
						
						(
						SELECT  SUM(S.AmountMatched)
						FROM    InvoicePurchase S, Invoice INV
						WHERE   INV.InvoiceId   = S.InvoiceId
						AND     S.RequisitionNo = R.RequisitionNo	
						AND     INV.ActionStatus != '9'											
						<!--- is not the current invoice --->											
						<cfif invoiceId neq "">
						AND     INV.InvoiceId != '#inId#'					
						</cfif>		
						
						AND     ( 
								EXISTS 
								(
									SELECT ObjectKeyValue4 
					                FROM   Organization.dbo.OrganizationObject
	      				        	WHERE  EntityCode    = 'ProcInvoice'
									AND    ObjectKeyValue4 = INV.InvoiceId 
								)
						     <!--- OR  INV.EntityClass IS NULL --->
							)
						
						) as AmountPosted				  
	        
	FROM      PurchaseLine PL INNER JOIN
              RequisitionLine R ON PL.RequisitionNo = R.RequisitionNo LEFT OUTER JOIN
              Job J ON R.JobNo = J.JobNo
	WHERE     PL.PurchaseNo = '#URL.PurchaseNo#'		
	AND       PL.OrderAmount <> 0
	ORDER BY  PL.ListingOrder,R.RequisitionNo	
		
</cfquery>

<cfif Lines.recordcount eq "0">

	<table cellspacing="0" width="100%" align="center" border="0" cellpadding="0">	
		<tr><td class="linedotted"></td></tr>
		<tr><td class="labelit" align="center" height="40"><font color="FF0000">
			<cf_tl id="Problem">:<cf_tl id="This purchase order does not have active obligation lines">
		</td></tr>
		<tr><td class="linedotted"></td></tr>
	</table>

<cfelse>
	
	<cfoutput>
	<input type = "hidden"
	      name  = "PurchaseNo"
		  id    = "PurchaseNo"
	      value = "#url.PurchaseNo#">
	</cfoutput>
	
		
	<table cellspacing="0" width="100%" align="center" border="0" cellpadding="0">	
			
		<!--- -----------------------------8/8/2009 amendment for CMP  ----------------- --->							
		<!--- associate an amount to an associated purchase execution amount ----------- --->
		<!--- only if the purchase has one or more execution lines --------------------- --->
		<!--- select dropdown and amount ensure that amunt equal/less as selected amount --->
		<!--- -------------------------------------------------------------------------- --->	
		
		<cfquery name="PurchaseHeader" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					SELECT  *
					FROM    Purchase
					WHERE   PurchaseNo = '#URL.PurchaseNo#'				
		</cfquery>
			
		<cfquery name="List" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					SELECT  *
					FROM    PurchaseExecution
							
		</cfquery>
	
		<cfif List.recordcount gte "1">
		
			<cfquery name="Current" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						SELECT  *
						FROM    InvoicePurchaseExecution
						WHERE   PurchaseNo = '#URL.PurchaseNo#'				
						<cfif invoiceid eq "">
						AND     InvoiceId = '#guid#'								
						<cfelse>
						AND     InvoiceId = '#invoiceid#'
						</cfif>
			</cfquery>		
			
			<tr>
			
				<td height="26" class="labelmedium" style="cursor: pointer;"><cf_UIToolTip  tooltip="Associated an amount of this invoice to a defined distribution item"><cf_tl id="Associate to Execution">:</cf_UIToolTip></td>
			    <td>
				
					<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td>
					<select name="ExecutionId" id="ExecutionId" class="regularxl">
					    <option value="">N/A</option>
						<cfoutput query="List"><option value="#ExecutionId#" <cfif current.executionid eq ExecutionId>selected</cfif>>#Description#</option></cfoutput>
					</select>
					</td>
					
					<!--- the invoice amount is distributed here now disalbed 29/4/2016
					<td>
					
					 <cfoutput>
					 <input type="Text"
				       name     = "ExecutionAmount"
					   id       = "ExecutionAmount"
					   class    = "regularxl"
				       value    = "#Current.AmountInvoiced#"
					   style    = "text-align:right; padding: 0 2px 0 0;">		
					 </cfoutput>  	
						   
					</td>
					--->
					</tr>
					</table>		
				
				</td>
				
			</tr>		
		
		</cfif>
			
		<tr>
			<td colspan="4"><cfdiv id="icomments"/></td>
		</tr>
				
		<cfquery name="Parameter1" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#PurchaseHeader.Mission#' 
		</cfquery>
					
		<tr><td colspan="4">
					
			<table width="100%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
							
			<cfquery name="Curr" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						SELECT  *
						FROM    Invoice
						<cfif invoiceid eq "">
						WHERE   InvoiceId = '#guid#'								
						<cfelse>
						WHERE   InvoiceId = '#invoiceid#'
						</cfif>
			</cfquery>		
				
			<tr class="line">
			   <td height="26"></td>
			   <td class="labelit"><cf_space spaces="20"><cf_tl id="Date"></td>
			   <td class="labelit"><cf_tl id="Item"></td>
			   <td class="labelit"><cf_space spaces="30"><cf_tl id="CaseNo"></td>
			   <td class="labelit" align="center"></td>
			   <td class="labelit" align="right"><cf_tl id="Amount"></td>
			   <td class="labelit" align="right"><a href="##" title="On Hold"><cf_tl id="In Process"></a><cf_space spaces="20"></td>
			   <td class="labelit" align="right"><a href="##" title="Recorded and/or processed"><cf_tl id="Posted"></a><cf_space spaces="20"></td>
			   <td class="labelit" align="right" style="padding-right:3px"><cf_tl id="Balance"><cf_space spaces="20"></td>
			   <cfif lines.recordcount gte "1" or invoiceid neq "">	
			   <td class="labelit" align="right" id="toggleresult" style="padding-left:4px;border-left:1px solid silver"><cf_space spaces="26">
			  		<a href="javascript:togglecpl('expand')"><cfoutput>#Curr.DocumentCurrency#</cfoutput> <cf_tl id="AP"></a>

			   <cfoutput>
			   
			       <img src = "#SESSION.root#/Images/collapse3.gif" 
		     		    alt     = "hide completed lines" 
						border  = "1" 
						height  = "13"  
						width   = "13" 
						align   = "absmiddle" 
						onclick = "togglecpl('expand')">
					
			   </cfoutput>	
			   
			   </td>
			   </cfif>
			</tr>
			
			<cfset cpl = "">		
													
			<cfoutput query="Lines">
			
			    <!--- ----------------------------------------------------------------------------------------- --->
				<!--- 21/2/2012 adjust this for the invoices recorded in a different currency to be reverted to the
				purchase line amounts --->
				<!--- ----------------------------------------------------------------------------------------- --->
																																	
					<cfif InvoiceId neq "">					
					   <cfset p = Amount>						   
					<cfelse>					
					   <cfset p = "">			   					   
					</cfif>				
														
					<cfif AmountOnHold gt "0">
						<cfset hld = AmountOnHold>
					<cfelse>
					    <cfset hld = 0>
					</cfif>	
																			
					<cfif AmountPosted gt "0">
						<cfset exp = AmountPosted>
					<cfelse>
					    <cfset exp = 0>
					</cfif>								
					
					<cfset allowed = OrderAmount + (OrderAmount * (parameter1.InvoiceMatchDifference/100))>			
															
					<cfif allowed-Exp-Hld gt "0.001">
					   <cfif p gt "0">
					     <cfset cl = "e4e4e4">
					   <cfelse>
					     <cfset cl = "ffffff">
					   </cfif>		
					<cfelseif allowed-Exp-Hld lte "-0.5"> 
					   <cfset cl = "red">  	
					<cfelseif OrderAmount-Exp-Hld lte "-0.5"> 
					   <cfset cl = "Yellow">  	  
					<cfelse>
					   <cfset cl = "f1f1f1">
					</cfif>
									
					<tr class="cellcontent linedotted navigation_row" bgcolor="#cl#" id="row#currentrow#">
					
					   <td valign="top" style="padding-top:2px;padding-left:3px"><font size="1">#CurrentRow#.</td>
					   <td valign="top" style="padding-top:2px;">#DateFormat(Created, CLIENT.DateFormatShow)#</td>
					   <td valign="top" style="padding-top:2px">#OrderItem#</td>
					   <td valign="top" style="padding-top:2px">#CaseNo#</td>
					   <td valign="top" style="padding-top:2px;padding-right:4px" align="center">#Currency#</td>
					   <td valign="top" style="padding-top:2px;" align="right">#NumberFormat(OrderAmount,"__,__.__")#</td>
					   <td valign="top" style="padding-top:2px;" align="right"><cfif hld neq "0"><a title="View recorded invoice amounts" href="javascript:drillinvoice('inv#currentrow#','#requisitionno#')"><font color="0080ff">#NumberFormat(Hld,"__,__.__")#</a><cfelse>-</cfif></td>
					   <td valign="top" style="padding-top:2px;" align="right"><cfif exp neq "0"><a title="View recorded invoice amounts" href="javascript:drillinvoice('inv#currentrow#','#requisitionno#')"><font color="0080FF">#NumberFormat(Exp,"__,__.__")#</a><cfelse>-</cfif></td>
					   <td valign="top" style="padding-top:2px;" align="right"><cfif OrderAmount-Exp-Hld neq "0">#NumberFormat(OrderAmount-Exp-Hld,"__,__.__")#<cfelse></cfif></td>
					   	
					   <cfif lines.recordcount gte "1" 
					         or invoiceid neq "" 
							 or Parameter.EnablePurchaseClass eq "1">	  
					    			  
						   <td align="right" height="21" style="padding-right:1px;padding-left:4px;border-left:1px dotted silver">						   	     
						  					   
							   <input type="hidden" name="selcurrency" id="selcurrency" value="#Currency#">		
							   	
							   <cfset cpl = "#cpl#|#currentrow#">
							   
							   <!--- has balance or this lines was covered by the same invoice as currently loaded --->
							   						   					   	 				  					   
							   <cfif allowed-Exp-Hld gt "0.001" or p neq "">
							   						   
							 	    <input type="Text" 
									      name     = "req#currentrow#" 
										  id       = "req#currentrow#"
										  style    = "text-align:right;border:0px;padding-top:0px;height:20px;font-size:13px" 									
										  onchange = "showclass('req#currentrow#',this.value,'#requisitionno#','#invoiceid#');showtotal('#invoiceid#','#lines.recordcount#')"									 
										  class    = "regularxl enterastab" 
										  visible  = "Yes" 
										  value    = "#numberformat(p,',.__')#" 
										  enabled  = "Yes" 
										  size     = "8" 
										  maxlength= "15">
										  
							   <cfelse>
							   
				   					<input type="hidden" name="req#currentrow#" id="req#currentrow#" value="0">
							   		<font color="FF0000"><cf_tl id="Completed"></font>
									
							   </cfif>	
							   		 					   
						   </td>
						   
					   </cfif>		
					  
			    	</tr>
																			
					<!--- --------------------------------------------- --->
					<!--- allow for splitting the line by class amounts --->
					<!--- but only if the line has not been fully paid  --->
					<!--- --------------------------------------------- --->				
					
					<cfif Parameter.EnablePurchaseClass eq "1" and (OrderAmount-Exp-Hld gt "0.002" or p neq "")> 
																		 
						 <cfif p gt "0">
						 
						 	<tr bgcolor="ffffdf" class="regular" id="req#currentrow#_box">				     
					    	 <td align="center" id="req#currentrow#_class" colspan="10">
						 
							 <cfset url.box           = "req#currentrow#">
							 <cfset url.val           = p>
							 <cfset url.requisitionno = requisitionno>
							 <cfset url.invoiceid     = invoiceid> 
							 <cfinclude template      = "InvoiceEntryMatchRequisitionClass.cfm">
							 
							 </td>
							 </tr>
						 							 
						 <cfelse>
						 
						 	<tr bgcolor="ffffdf" class="hide" id="req#currentrow#_box">				     
					    	     <td align="center" id="req#currentrow#_class" colspan="10"></td>
							</tr>
						 							 
						 </cfif>											
										
					</cfif>		
					
					<!--- box to show detail matching --->
					
					<tr class="hide" id="inv#currentrow#_box">				     
					    <td></td>
						<td></td>
						<td style="padding-top:1px;padding-bottom:1px" id="inv#currentrow#_class" colspan="6"></td>
					</tr>								
						
			</cfoutput>				
			
			<cfoutput>
			
				<script>			
					function togglecpl(act) {			    
						 ColdFusion.navigate('#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryMatchRequisitionToggle.cfm?action='+act+'&list=#cpl#','toggleresult')				 
					}				
				</script>
			
			</cfoutput>
			
			</table>
			
		</td></tr>
			
		<tr><td height="5"></td></tr>
										
		</table>
				
</cfif>		
