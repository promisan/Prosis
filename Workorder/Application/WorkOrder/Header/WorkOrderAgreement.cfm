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


<table width="100%" cellspacing="0" cellpadding="0">

	<cfquery name="workorder" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     WorkOrder
		WHERE    workorderid = '#url.workorderid#'
   </cfquery>	

   <cfquery name="getItem" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     ServiceItemMission
		WHERE    ServiceItem = '#workorder.ServiceItem#'
		AND      Mission     = '#workorder.Mission#'			  
   </cfquery>	

	<!--- to be changed to include also the effective date --->	
	
	<cfquery name="getList" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    DISTINCT DateEffective, 
		          DateExpiration 
		FROM      WorkOrderBaseLine
		WHERE     WorkOrderId         = '#URL.workorderid#'
		AND       YEAR(DateEffective) = '#url.year#'    
		AND       ActionStatus        = '3'
		ORDER BY  DateEffective DESC					  
   </cfquery>	   
   
   <cfset expdate = getList.DateExpiration>	
     
   <cfoutput query="getList" group="DateExpiration">
      
	   <cfoutput>   	  
	   	
		   <cfquery name="ServiceAgreement" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 * 
				FROM     WorkOrderBaseLine
				WHERE    WorkOrderId = '#URL.workorderid#'
				AND      DateEffective = '#dateformat(dateeffective,client.datesql)#'
				AND      YEAR(DateEffective) = '#url.year#'    
				AND      ActionStatus = '3'
				ORDER BY Created DESC					  
		   </cfquery>			   
			   
		   <cfif serviceagreement.recordcount eq "1">   
		            
				   <cfquery name="ServiceAgreementLines" 
						datasource="appsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
				        SELECT   R.ServiceItem,
						         R.Unit as ServiceItemUnit,
								 R.UnitDescription,
								 R.UnitSpecification,
								 
								 <!--- sla quantity --->
								 (
								   SELECT Quantity 
								   FROM   WorkOrderBaseLineDetail 
								   WHERE  TransactionId = '#serviceAgreement.TransactionId#'
								   AND    ServiceItemUnit = R.Unit
								   
								 ) as Quantity,  
														
								 (
								   SELECT Rate 
								   FROM   WorkOrderBaseLineDetail 
								   WHERE  TransactionId = '#serviceAgreement.TransactionId#'
								   AND    ServiceItemUnit = R.Unit
								   
								 ) as Rate,  
								 
								 (
								   SELECT Amount 
								   FROM   WorkOrderBaseLineDetail 
								   WHERE  TransactionId = '#serviceAgreement.TransactionId#'
								   AND    ServiceItemUnit = R.Unit
								   
								 ) as Amount,  
								 
								 <!--- actual quantity --->
								 						   
								 ( SELECT   COUNT(*) 
									FROM     WorkOrderLineBilling WB 
									         INNER JOIN WorkOrderLineBillingDetail WBD ON WB.WorkOrderId = WBD.WorkOrderId 
											      AND WB.WorkOrderLine = WBD.WorkOrderLine 
												  AND WB.BillingEffective = WBD.BillingEffective 
											 INNER JOIN
									         WorkOrderLine W ON WB.WorkOrderId = W.WorkOrderId AND WB.WorkOrderLine = W.WorkOrderLine
									WHERE    WB.WorkOrderId = '#url.workorderid#' 
									AND      WBD.Operational = 1 
									AND      W.Operational = 1
									AND      W.DateEffective    < GETDATE() 
									AND      (W.DateExpiration IS NULL OR W.DateExpiration >= GETDATE()) 
								    AND      WB.BillingEffective < GETDATE() 
								    AND      (WB.BillingExpiration IS NULL OR WB.BillingExpiration >= GETDATE())
									AND      WBD.ServiceItemUnit = R.Unit ) as Actual
								
								 
				        FROM     ServiceItemUnit R INNER JOIN Ref_UnitClass C ON R.UnitClass = C.Code
						 												 
				        WHERE    R.ServiceItem = '#workorder.ServiceItem#' 
						AND      R.BaseLineMode = 1
						ORDER By C.ListingOrder, R.ListingOrder
					</cfquery>

					<tr>
						<td colspan="3" style="padding-left:0px;padding-top:4px;font-family: Verdana; color: 002350;">
							<table width="100%" cellspacing="0" cellpadding="0">
							<tr>
							<td style="height:30px" class="labellarge"><font color="gray">Agreement: <b>#dateformat(ServiceAgreement.dateEffective, CLIENT.DateFormatShow)# - #dateformat(ServiceAgreement.dateExpiration, CLIENT.DateFormatShow)#</font></td>
							<td align="right" class="labelmedium">Prepared on #dateformat(ServiceAgreement.created, CLIENT.DateFormatShow)# #timeformat(ServiceAgreement.created, "HH:MM")#</td>
							</tr>					
							</table>
						 </td>	
					</tr>
					
					<tr>
						
						<td style="padding-left:0px;" valign="top" width="70%">	
						
							<table width="100%" border="0" cellspacing="1" cellpadding="0" bgcolor="FDFFF0" style="border:1px dotted silver">
							
								<tr class="labelit line">
									<td width="45%" style="padding-left:3px">Unit</td>						
									<td width="10%" align="right" style="padding:2px">Agreed</td>
									<td width="10%" align="right" style="padding:2px">Actual</td>									
									<td width="10%" align="right" style="padding:2px"><!--- Rate ---></td>
									<td width="15%" align="right" style="padding:2px">Agreement Amount</td>
								</tr>
																
								<cfset tot = 0>
																	
								<cfloop query="ServiceAgreementLines">
								
									<tr class="line labelit">
										<td style="padding-left:3px">#UnitDescription#</td>						
										<td align="right" style="padding:1px">
										<cfif quantity neq "">
										#numberformat(quantity,"__,__")#
										</cfif>
										</td>
										<td align="right" style="padding:1px">
										<a href="javascript:agreementdetail('#ServiceAgreement.workorderid#','#serviceitemunit#')">
										<font color="0080C0">#numberformat(actual,"__,__")#</font></a>
										</td>
										<td align="right" style="padding:1px">
										<!---
										<cfif quantity neq "">
										#numberformat(rate,"__,__.__")#
										</cfif>
										--->
										</td>
										<td align="right" style="padding:1px">
										<cfif quantity neq "">
										#numberformat(amount,"__,__.__")#
										</cfif>
										</td>
									</tr>
									
									<tr>
										<td class="line" colspan="5"></td>
									</tr>
									
									<cfif amount neq "">
										<cfset tot = tot+amount>
									</cfif>	
																	
								</cfloop>
								
								<tr>
									<td style="padding-left:20px" colspan="4"></td>												
									<td align="right" class="labelmedium" style="padding-right:4px">#numberformat(tot,"__,__.__")#</td>
								</tr>
															
							</table>
							
						</td>
						
						<td style="width:2px">&nbsp;</td>
											
						<td valign="top" width="30%" height="100%" style="padding-left:15px">
						
						   <cfquery name="Posting" 
							datasource="appsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   * 
							FROM     TransactionHeader
							WHERE    Journal = '#getItem.Journal#'
							AND      DocumentDate >= '#ServiceAgreement.dateEffective#'						
							AND      DocumentDate <= '#expdate#'												
							AND      ReferenceId = '#url.workorderid#'						
							ORDER BY Created DESC					  
					   </cfquery>
					   
					   <table width="100%" height="100%" cellspacing="0" cellpadding="0" style="border:1px dotted silver navigation_table">
					 
					   <tr bgcolor="D7FFFF" class="labelit line">
					   	<td height="19" style="padding-left:3px">Number</td>
						<td>Date</td>
						<td></td>
						<td>Amount</td>				   
					   </tr>
					   					
					   <cfset tot = 0>
								
					   <cfloop query="Posting">
						   <tr class="line labelit navigation_row">
						   <td height="18" style="padding-left:3px"><a href="javascript:ShowTransaction('#journal#','#journalserialno#','1')"><font color="0080FF">#Journal#-#JournalSerialNo#</a></td>
						   <td>#dateformat(documentdate,CLIENT.DateFormatShow)#</td>
						   <td>#documentCurrency#</td>
						   <td align="right">#numberformat(documentamount,'__,__.__')#</td>
						   </tr>
						   <tr>
							<td class="line" colspan="4"></td>
							</tr>
						   <cfset tot = tot+documentamount>
					   </cfloop>				   
						
						<tr><td height="100%"></td></tr>
											
					    <tr bgcolor="D7FFFF" class="line labelit">
						   <td height="23" style="padding-left:3px"><cf_tl id="Total"></td>
						   <td></td>
						   <td></td>
						   <td align="right" class="labelmedium">#numberformat(tot,'__,__.__')#</td>
						</tr>
					   
					   </table>						
						
					  </td>
						
					   </tr>	
				</cfif>		
							
			<cfset expdate = dateeffective>
				
	</cfoutput>	

</cfoutput>
	
</table>

