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
<cfparam name="Post" default="0">

<cfparam name="hasPostings" default="0">
<cfparam name="toPost" default="0">

 <cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrder
	WHERE    WorkOrderid   = '#get.WorkOrderid#' 		  
</cfquery>	

  <cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     WorkOrderLine
	WHERE    WorkOrderid   = '#get.WorkOrderid#' 
	AND      WorkOrderLine = '#get.WorkOrderLine#' 		  
</cfquery>	

<cfquery name="clean" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    DELETE WorkOrderLineCharge
	FROM      WorkOrderLineCharge C
	WHERE     WorkOrderid   = '#get.WorkOrderid#' 
	AND       WorkOrderLine = '#get.WorkOrderLine#' 
	AND       Journal is not NULL
	AND       NOT EXISTS (SELECT 'X' 
	                      FROM Accounting.dbo.TransactionHeader 
	                      WHERE Journal = C.Journal and JournalSerialNo = C.JournalSerialNo
						  AND   ActionStatus IN ('0','1')
						  AND   RecordStatus <> '9')
	
</cfquery>	

<cfquery name="ListBilling" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT   *, 
	         R.Description AS UnitClassName,
			 (SELECT OrgUnitName 
			  FROM   Organization.dbo.Organization
			  WHERE  OrgUnit = C.OrgUnitOwner) as OrgUnitOwnerName
			  
			 
	FROM     WorkOrderLineCharge C INNER JOIN Ref_UnitClass R ON C.UnitClass = R.Code
	WHERE    WorkOrderid   = '#get.WorkOrderid#' 
	AND      WorkOrderLine = '#get.WorkOrderLine#' 		
	
	AND      (SalePayable <> 0  or Warehouse is not NULL)
	
	<!---
	<cfif process eq "0">
	AND      Journal is not NULL
	</cfif>
	--->
	
	ORDER BY C.OrgUnitOwner, C.OrgUnitCustomer, C.TransactionDate, R.Description
	
</cfquery>	

<cfquery name="checkAccount" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      WorkOrderLineCharge C
	WHERE     WorkOrderid   = '#get.WorkOrderid#' 
	AND       WorkOrderLine = '#get.WorkOrderLine#' 
	
	AND       NOT EXISTS (SELECT 'X' 
	                  	  FROM   Accounting.dbo.Ref_Account 
					  	  WHERE  GLAccount = C.GLAccountCredit)					  
	
</cfquery>	

<cfif session.acc eq "administrator">
	<!---
	 cfdump var="#CheckAccount#"
	---> 	
</cfif>
	
<form method="post" name="BillingForm" id="BillingForm">

<table width="100%">

	<cfif checkAccount.recordcount gte "1">
	
	<tr>
		<td colspan="2" align="center" class="labelmedium"><font color="FF0000">
		<cf_tl id="One ore more charges do not have a GL account defined, contact your administrator">
			
		<cfoutput>
		<table width="100%">	
		<cfloop query="CheckAccount">
			<tr>
				<td width="40%"></td>
				<td><font color="FF0000">#CheckAccount.Unit#</font></td>
				<td><font color="FF0000">#CheckAccount.UnitDescription#</font></td>
				<td width="40%"></td>
			</tr>
				<cfquery name="checkSIUM" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
  					FROM   ServiceItemUnitMission
  					WHERE  ServiceItemUnit = '#CheckAccount.Unit#'									  
				</cfquery>		

				<cfloop query="checkSIUM">
					<tr>
						<td></td>
						<td>
							<font color="FF0000">
							#checkSIUM.Currency# #checkSIUM.Price#
							</font>
						</td>
						<td>
							<font color="FF0000">
							#checkSIUM.GlAccount#
							</font>
						</td>	
						<td></td>
							
					</tr>
				</cfloop>				
		</cfloop>		
		</table>
		</cfoutput>
			
		</td>
	
	</tr>
	
	</cfif>
  					   
	<tr>
	   	<td colspan="2">
		    <table width="100%" align="center">
			
				<tr class="labelmedium2 fixlengthlist" style="height:20px;border-bottom:1px solid silver">
					
					<td style="padding-left:5px"><cf_tl id="Class"></td>
					<td><cf_tl id="Unit"></td>	
					<td style="border-left:1px solid silver;border-right:1px solid silver align="right"><cf_tl id="Quantity"></td>	
					<td style="border-left:1px solid silver;border-right:1px solid silver" align="right"><cf_tl id="Amount"></td>												
					<td style="border-left:1px solid silver;border-right:1px solid silver" align="right"><cf_tl id="Amount"></td>										
					<td style="border-right:1px solid silver" align="right"><cf_tl id="Tax"></td>																	
					<td style="border-right:1px solid silver" align="right"><cf_tl id="Receivable"></td>
				</tr>				
								
				<tr class="labelit line fixlengthlist" style="height:20px">								
					<td></td>
					<td></td>
					<td style="border-left:1px solid silver;border-right:1px solid silver" align="right"><cf_tl id="Used">|<cf_tl id="Charged"></td>	
					<td style="border-left:1px solid silver;border-right:1px solid silver" align="right"><cf_tl id="Cost"></td>	
					<td style="border-left:1px solid silver;border-right:1px solid silver" align="right"><cf_tl id="Income"></td>	
					<td style="border-right:1px solid silver" align="right"></td>	
					<td style="border-right:1px solid silver" align="right"></td>					
				</tr>
				
				<cfquery name="Owner" dbtype="query">
						SELECT    *								
						FROM      ListBilling							
				</cfquery>	
				
				<cfif Owner.recordcount gt "1">
								
				<cfoutput>
				<tr bgcolor="D3E9F8" class="fixlengthlist"> 
						<td colspan="3" align="right" style="padding-right:10px;border-top:1px solid silver;padding-left:6px;height:35px;font-size:14px" class="labelmedium">					
						<cf_tl id="Total">
						</td>
					
						 <cfquery name="Owner" dbtype="query">
							SELECT    SUM(CostAmount)       as COSS, 
									  SUM(SaleAmountIncome) as Income, 
							          SUM(SaleAmountTax)    as Tax, 
									  SUM(SalePayable)      as Payable									
							FROM      ListBilling							
						 </cfquery>	
						<td class="labellarge" style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;font-size:18px" align="right"><font color="808080">#numberformat(Owner.COSS,',.__')#</td>													
						<td class="labellarge" style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;font-size:18px" align="right">#numberformat(Owner.Income,',.__')#</td>
						<td class="labellarge" style="border-top:1px solid silver;border-right:1px solid silver;font-size:18px" align="right">#numberformat(Owner.Tax,',.__')#</td>
						<td class="labellarge" style="border-top:1px solid silver;border-right:1px solid silver;font-size:18px" align="right">#numberformat(Owner.Payable,',.__')#</td>					
					
				</tr>				
				</cfoutput>
				
				</cfif> 
													
				<cfoutput query="ListBilling" group="OrgUnitOwner">
				
					<cfquery name="Org" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT    *
						FROM      Organization
						WHERE     OrgUnit = '#orgunitOwner#'		
					</cfquery>	
				
					<tr bgcolor="ffffaf" class="line labelmedium  fixlengthlist"> 
						<td colspan="3" style="border-top:1px solid silver;padding-left:8px;height:36px;font-size:19px">					
						#OrgunitOwnerName#
						</td>
					
						 <cfquery name="Owner" dbtype="query">
							SELECT    SUM(CostAmount) as COSS,
							          SUM(SaleAmountIncome) as Income, 
							          SUM(SaleAmountTax) as Tax, 
									  SUM(SalePayable) as Payable									
							FROM      ListBilling
							WHERE     OrgUnitOwner = '#orgunitowner#'
						 </cfquery>	
						<td style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;font-size:16px" align="right">#numberformat(Owner.COSS,',.__')#</td>													
						<td style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;font-size:16px" align="right">#numberformat(Owner.Income,',.__')#</td>
						<td style="border-top:1px solid silver;border-right:1px solid silver;font-size:16px" align="right">#numberformat(Owner.Tax,',.__')#</td>
						<td style="border-top:1px solid silver;border-right:1px solid silver;font-size:16px" align="right">#numberformat(Owner.Payable,',.__')#</td>					
					
					</tr>								
													
					<cfoutput group="OrgUnitCustomer">
																							
							 <cfif OrgUnitCustomer eq "0">							 						 							     							 
								 
							 <cfelse>
							 
								 <cfquery name="Org" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT    *
									FROM      Organization
									WHERE     OrgUnit = '#orgunitcustomer#'		
								</cfquery>	
								
								<tr>
								<td colspan="7"  style="height:30px;padding-left:4px" class="labellarge line">
							 	 <font color="6688aa">							 
							     #Org.OrgunitName#								 
								 </td>
								</tr>
								 
							 </cfif>
							 
						<cfset reference = ""> 
						<cfset prior     = "">
									
						<cfoutput group="TransactionDate">

							<cfoutput group="InvoiceNo">							
							
							    <cfset vamt = 0>
							    <cfset vtax = 0>
								
								<cfif post eq "0" and reference neq "#BillingReference# - #BillingName#">											
								<tr class="line labelmedium  fixlengthlist">
								<td colspan="7"  style="padding-left:10px;height:1px;">
									<!--- we are hiding this now as it gave some confusion in the presentation 
									#dateformat(TransactionDate,client.dateformatshow)#
									--->																						
									<b>#BillingReference# - #BillingName#								
									<cfset reference = "#BillingReference# - #BillingName#">								
								</td></tr>
								<cfelse>
								<tr><td style="height:15px"></td></tr>
								</cfif>
								
								<cfoutput group="UnitClassName">		
								
									<cfoutput>
									
										<tr class="labelmedium  fixlengthlist" style="height:20px;border-top:1px solid silver">							    														
											<td style="padding-left:10px;border-bottom:1px solid silver"><cfif prior neq UnitClassName>#unitclassname#</cfif></td>
											<td style="border-bottom:1px solid silver">#UnitDescription#</td>		
											<td align="right" style="border-left:1px solid silver;border-right:1px solid silver"><cfif quantityCost gte "1">#QuantityCost#|</cfif>#Quantity#</td>																	
											<td align="right" style="border-left:1px solid silver;border-right:1px solid silver"></td>
											<td align="right" style="border-left:1px solid silver;border-right:1px solid silver">#numberformat(SaleAmountIncome,',__.__')#</td>		
											<td align="right" style="border-right:1px solid silver">#numberformat(SaleAmountTax,',.__')#</td>									
											<td align="right" style="border-right:1px solid silver">#numberformat(SalePayable,',.__')#</td>								
										</tr>
										
										<cfset vamt = vamt + SaleAmountIncome>	
										<cfset vtax = vtax + SaleAmountTax>		
										<cfset prior = unitclassname>
																				
									</cfoutput>
								
								</cfoutput>
																										
								<tr class="labelmedium2  fixlengthlist" style="height:20px;background-color:f1f1f1">
								    <td colspan="2" align="left" style="border-bottom:1px solid silver;padding-left:20px"></td>
									<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" >
																
									<cfif journal neq "">
									
										<cfset haspostings = "1">
										
										<cfquery name="header" 
											datasource="AppsLedger" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT    *
											FROM      TransactionHeader
											WHERE     Journal         = '#journal#' 
											AND       JournalSerialNo = '#journalserialno#' 		
											AND       ActionStatus IN ('0','1') 
											AND       RecordStatus != '9'	
										</cfquery>	
										
										<cfif header.recordcount eq "1">
		
										<table style="width:100%">
											<tr class="labelmedium2 fixlengthlist">
											
											<td style="width:20px;padding-left:10px;">
											
													<cfquery name="Invoice" 
													datasource="AppsLedger" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														SELECT    *
														FROM      TransactionHeaderAction
														WHERE     Journal         = '#journal#' 
														AND       JournalSerialNo = '#journalserialno#' 	
														AND       ActionCode      = 'Invoice'
														AND       ActionMode      = '2'		
														AND       ActionStatus    = '1'
														ORDER BY Created DESC
												   </cfquery>	
											
												    <!--- check if we have indeed an electronic invoice --->
											
											        <cfif Invoice.recordcount eq "0">
													
														<cfquery name="Document" 
												         	  datasource="AppsOrganization" 
											      			  username="#SESSION.login#" 
											        	  	  password="#SESSION.dbpw#">
											      			    SELECT * 
													       		FROM   Ref_EntityDocument 
											      				WHERE  EntityCode   = 'GLTransaction'
																AND    DocumentType = 'document'																							 
											      			</cfquery>
			
										      			<cfif Document.recordcount eq "1">
														
															<cf_tl id="Print form" var="1">
															
															<cf_button2 
																type="button" 
																mode="icon" 
																image="print_gray.png" 
																height="22px" 
																width="22px" 
																imageHeight="20px" 
																title="#lt_text#"
																onclick="doPrintFormat('#journal#', '#journalserialNo#','#document.documentid#','#document.documenttemplate#');">											
														
														<cfelseif Document.recordCount gte 2>
																									
															<cf_tl id="Print form" var="1">
															
															<cf_button2 
																type="button" 
																mode="icon" 
																image="print_gray.png" 
																height="22px" 
																width="22px" 
																imageHeight="20px" 
																title="#lt_text#"
																onclick="printFormSelected('#journal#', '#journalserialNo#','#workorder.serviceitem#');">									
																
																
														</cfif>
													
													<cfelse>
													
														<cf_tl id="Print form" var="1">
															
															<cf_button2 
																type="button" 
																mode="icon" 
																image="print_gray.png" 
																height="22px" 
																width="22px" 
																imageHeight="20px" 
																title="#lt_text#"
																onclick="PrintTaxReceivable('#Invoice.ActionId#', 'finance');">	
													
														<!--- open the view --->
														
													</cfif>
													
												</td>
												
												<td>
												
												   #DateFormat(header.DocumentDate,CLIENT.DateFormatShow)# :
													<a href="javascript:ShowTransaction('#journal#', '#journalserialNo#','','window','workorderbiller')">
																					
														 <cfif header.amountOutstanding gte "0.05"><font color="FF0000"></cfif>										
													     <cfif InvoiceNo neq "">
														 	#InvoiceSeries#-#InvoiceNo#</font>
														 <cfelse>												 
															#journal#-#journalserialNo#</font>
														</cfif>
																																					
													</a>
																			
													
												</td>
												
												<cfif header.transactionSourceId neq "">
												
													<!--- if transaction has no separate 
													   offset postings outside the stand we allow to remove it --->
													
													 <cfquery name="checkOffset" 
														datasource="AppsLedger" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															SELECT   *
															FROM     TransactionLine L, TransactionHeader H
															WHERE    L.Journal             = H.Journal
															AND      L.JournalSerialNo     = H.JournalSerialNo
															AND      ParentJournal         = '#journal#' 
															AND      ParentJournalSerialNo = '#journalserialno#' 		
															AND      TransactionSourceId  != '#header.transactionsourceid#'  
															AND      H.ActionStatus IN ('0','1') 
															AND      H.RecordStatus != '9'
													</cfquery>																								
																											
											 	  <cfinvoke component="Service.Access"  
												      method    = "journal"  
													  journal   = "#Journal#" 
													  orgunit   = "#header.OrgUnitOwner#"
													  returnvariable="access">			  
																																	
													<cfif checkOffset.recordcount eq "0" 
													      and listBilling.recordcount gte "1"
														  and (access eq "EDIT" or access eq "ALL")>
													
														<td align="right" style="padding-top:2px">
																																		
														 <cf_img icon="delete" 
														     onclick="Prosis.busy('yes');ptoken.navigate('undoPosting.cfm?workorderlineid=#get.workorderlineid#&journal=#journal#&journalserialno=#journalserialno#','posting')">
														 
														</td>
													
													</cfif>
												
												</cfif>
												
											</tr>
										</table>
										
										</cfif>
		
									</cfif>
									</td>
									<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"></td>							
									<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right">#numberformat(vamt,',.__')#</b></td>
									<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right">#numberformat(vtax,',.__')#</td>
									<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-right:1px solid silver;padding-right:10px" align="right">#numberformat(vtax+vamt,',.__')#</td>			
								</tr>	
																																										
						<cfif post eq "1" and Journal eq "">
							
							    <tr><td colspan="7" align="center">
							
								<cfset toPost = "1">
								
								<table width="100%" border="0" style="background-color:ffffff;border:1px solid silver;border-top:0px;">																		
																									 
									 <tr class="labelmedium2 line" style="background-color:AEFFAE">
									 <TD style="width:20%;padding-left:20px;padding-right:4px;height:35px" colspan="2">
									 
									     <!--- we verify invoice mode for the associated journal --->
										   
										   <cfquery name="Parameter" 
												datasource="AppsLedger" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												SELECT 	 TOP 1 *
												FROM 	 Ref_ParameterMission
												WHERE 	 Mission = '#workorder.mission#'		
										    </cfquery>	
											 
										   <cfquery name="getJournal" 
											datasource="AppsLedger" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT 	 TOP 1 *
												FROM 	 Accounting.dbo.Journal
												WHERE 	 Mission        = '#workorder.Mission#'
												
												<cfif Parameter.administrationLevel eq "Parent">
												AND      OrgUnitOwner   = '#orgunitowner#'
												</cfif>
												
												AND      Currency       = '#currency#'
												AND      SystemJournal  = 'WorkOrder'				
										   </cfquery>		
									 
										 <table style="width:100%">
										 <tr class="labelmedium2 fixlengthlist">
										   <td style="width:20px;padding-left:10px"><cf_tl id="Bill to">:</TD>
										   
										   <cfquery name="TaxCode" 
												datasource="AppsSystem" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												SELECT 	 TOP 1 *
												FROM 	  CountryTaxCode
												WHERE 	 TaxCode = '#BillingReference#'		
										    </cfquery>	
										   
										   <td style="width:20px;cursor:pointer" 
										        onclick="setaddress('#TaxCode.AddressId#','Taxcode','#billingreference#')" title="Maintain address information">
												
										        <cfif TaxCode.recordcount eq "1">										   
										          <img src="#session.root#/images/home.png" style="height:25px;width:25px" alt="" border="0">
										        </cfif>
										   
										   </td>
										   
										   <td style="font-size:16px;padding-left:10px;padding-right:10px">#BillingReference# #BillingName#</td>					
										   
										   <cfset dte = DateTimeFormat(TransactionDate,"YYYYMMDD_HH_nn_ss")>
										   
										   <cfquery name="Tax" 
											  datasource="AppsSystem" 
											  username="#SESSION.login#" 
											  password="#SESSION.dbpw#">
												    SELECT *
													FROM   Organization.dbo.Ref_Mission
													WHERE  Mission = '#workorder.Mission#'												   
										   </cfquery>
										   
										   <cfif Tax.EDIMethod neq "" and getJournal.OrgUnitTax neq "">	
										   
										      <td style="width:20px" class="fixlength" align="right"><cf_tl id="Tax submission">:</td>
										      <td style="width:20px" aslign="right">											   										   										   									   
       										   <input type="checkbox" checked class="radiol" name="#orgunitOwner#_#orgunitCustomer#_#dte#_invoicemode" value="2">										  
										      </td>									  
										   
											  <!--- show eMail ---> 											
																						
												<cfquery name="get" 
														datasource="AppsWorkOrder" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
														SELECT  *, C.PersonNo as ApplicantNo
														FROM    WorkOrder W, 
														        WorkOrderLine WL,
															    Customer C
														WHERE   W.WorkOrderId     = WL.WorkOrderId
														AND     WL.WorkOrderid    = '#get.WorkOrderid#' 
		                                            	AND     WL.WorkOrderLine  = '#get.WorkOrderLine#' 				
														AND     C.CustomerId      = W.CustomerId
												</cfquery>	
																								
												<td style="padding-right:6px;width:200px" align="right" title="eMail Address">	
																																		   
												   <input type="Text" style="width:100%;background-color:ffffcf;text-align:center" class="regularxxl enterastab" 
												   name="#orgunitOwner#_#orgunitCustomer#_#dte#_email" value="#get.EMailAddress#">
												   
												</td>  										   
										   									   
										   <cfelse>
										
										      <cfset dte = DateTimeFormat(TransactionDate,"YYYYMMDD_HH_nn_ss")>
																				      										   										   
											   <td style="padding-left:20px;padding-right:4px;padding-top:2px"><cf_tl id="Invoice/Reference"><cf_tl id="No">:</TD>
									           <td style="padding-left:10px">	
											 												      
												   <input type="Text" title="Invoice series" style="width:100%;background-color:ffffcf;padding-left:5px" class="regularxxl enterastab"
												   name="#orgunitOwner#_#orgunitCustomer#_#dte#_invoiceseries" value="" size="10" maxlength="10">
												   </td>
												   
												   <td style="padding-left:2px">	
												   
												   <cf_tl id="Record an invoice no" var="inv">		   
												   <input type="Text" title="Invoice No" style="background-color:ffffcf;" class="regularxxl enterastab" 
												   name="#orgunitOwner#_#orgunitCustomer#_#dte#_invoiceno" value="" size="15" maxlength="30"> 
												  </td>
												  
											</cfif>	
										   </tr>
										   </table>
									 </td>						  
									 </tr>
									 
									 <cfif OrgUnitCustomer eq "0" and vamt neq "0">
									 
									 	 <CF_DateConvert Value="#dateformat(transactiondate,client.dateformatshow)#">
									 
									     <cfset sdte = dateformat(dateValue,client.dateSQL)>
									      	<cfset hour = Hour(transactiondate)>
											<cfset minute = Minute(transactiondate)>
											<cfset second = Second(transactiondate)>
											<cfif hour lt 10>
												<cfset hour ="0#hour#">
											</cfif>
											<cfif minute lt 10>
												<cfset minute ="0#minute#">
											</cfif>
											<cfif second lt 10>
												<cfset second = "0#second#">
											</cfif>
									     <cfset stme = "#hour#_#minute#_#second#">
									 
										 <tr>
											<cf_tl id="Record Settlement" var="1">
											<td class="labelmedium" style="font-size:22px;padding-bottom:4px;padding-top:4px;padding-left:20px;padding-right:4px" colspan="1">		
											<input class="button10g" type="button" value="#lt_text#" style="width:200px;border:1px solid silver"
											  onclick="dosettlement('#url.workorderlineid#','#orgunitowner#','#sdte#','#stme#')">															
											</td>					
											
											<td width="100%" valign="top" align="right" style="padding-top:1px;padding-right:30px;padding-bottom:3px">
											 											 
											    <table width="100%">
												
												<cfset dte = DateTimeFormat("#sdte#","YYYYMMDD")>
												
												<tr><td id="#orgunitowner#_#dte#_#stme#_settlement" width="100%" style="padding:5px">												
													<cfinclude template="WorkOrderLineSettlement.cfm">							
													</td></tr>
												</table>	
											
											</td>
										</tr>										
						
									</cfif>									
																	 
								</table>
								
							</td></tr>	
							
							<tr><td style="height:3px"></td></tr>	
								
						</cfif>								
						
						</cfoutput>				<!--- InvoiceNo --->

						</cfoutput>				<!--- transactionDAte --->
					
					</cfoutput>  <!--- orgunitcustomer --->
																	
				</cfoutput> <!--- orgunitowner --->
													
			</table>
			
		</td>
	</tr>		
	
	<!---
				
	<cfif hasPostings eq "1" and listBilling.recordcount gte "1">
	
		<tr><td colspan="2" align="center" style="height:35px">	
				
			 <cf_tl id="Revert Accounts Receivable" var="1">
				   
			   <!--- allow to revert charges once we determine for each posting if 
			     there are already offsetting transactions recorded unless this is for
				 an insurer then we can just remove lines --->
					
			   <cfoutput>		
					   		  				   
			   		<input type="button"
				      onclick="Prosis.busy('yes');ptoken.navigate('undoPosting.cfm?workorderlineid=#get.workorderlineid#','posting')" 
					  style="background-color:ffffaf;font-size:14px;width:320;height:30px" 
					  name="close" 
					  value="#lt_text#" 
					  class="button10g">							  						
							  
			   </cfoutput>		
						   
			</td>
		</tr>
	
	</cfif>	
	
	--->
					   					   
   </table>
   
</form>