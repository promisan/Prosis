

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

<cfquery name="ListBilling" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT   *, 
	         R.Description AS UnitClassName,
			 (SELECT OrgUnitName 
			  FROM   Organization.dbo.Organization
			  WHERE  OrgUnit = C.OrgUnitOwner) as OrgUnitOwnerName
			 
	FROM     WorkOrderLineCharge C INNER JOIN
             Ref_UnitClass R ON C.UnitClass = R.Code
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
  					FROM ServiceItemUnitMission
  					WHERE        
  						ServiceItemUnit = '#CheckAccount.Unit#'									  
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
	   	<td align="center" colspan="2">
		    <table width="100%" align="center">
			
				<tr class="labelit" style="border-top:1px solid silver">
					
					<td style="padding-left:5px"><cf_tl id="Class"></td>
					<td><cf_tl id="Unit"></td>	
					<td style="border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Quantity"></td>	
					<td style="border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Amount"></td>												
					<td style="border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Amount"></td>										
					<td style="border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Tax"></td>																	
					<td style="border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Receivable"></td>
				</tr>
				
								
				<tr class="labelit line">								
					<td></td>
					<td></td>
					<td style="border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Used">|<cf_tl id="Charged"></td>	
					<td style="border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Cost"></td>	
					<td style="border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"><cf_tl id="Income"></td>	
					<td style="border-right:1px solid silver;padding-right:4px" align="right"></td>	
					<td style="border-right:1px solid silver;padding-right:4px" align="right"></td>					
				</tr>
				
				<cfquery name="Owner" dbtype="query">
						SELECT    *								
						FROM      ListBilling							
				</cfquery>	
				
				<cfif Owner.recordcount gt "1">
								
				<cfoutput>
				<tr bgcolor="D3E9F8"> 
						<td colspan="3" align="right" style="padding-right:10px;border-top:1px solid silver;padding-left:6px;height:35px;font-size:14px" class="labelmedium">					
						<cf_tl id="Total">
						</td>
					
						 <cfquery name="Owner" dbtype="query">
							SELECT    SUM(CostAmount) as COSS, 
									  SUM(SaleAmountIncome) as Income, 
							          SUM(SaleAmountTax) as Tax, 
									  SUM(SalePayable) as Payable									
							FROM      ListBilling							
						 </cfquery>	
						<td class="labellarge" style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;font-size:20px;padding-right:4px" align="right"><font color="808080">#numberformat(Owner.COSS,',.__')#</td>													
						<td class="labellarge" style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;font-size:20px;padding-right:4px" align="right">#numberformat(Owner.Income,',.__')#</td>
						<td class="labellarge" style="border-top:1px solid silver;border-right:1px solid silver;font-size:20px;padding-right:4px" align="right">#numberformat(Owner.Tax,',.__')#</td>
						<td class="labellarge" style="border-top:1px solid silver;border-right:1px solid silver;font-size:20px;padding-right:4px" align="right">#numberformat(Owner.Payable,',.__')#</td>					
					
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
				
					<tr bgcolor="ffffaf" class="line labelmedium"> 
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
						<td style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;font-size:17px;padding-right:4px" align="right">#numberformat(Owner.COSS,',.__')#</td>													
						<td style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;font-size:17px;padding-right:4px" align="right">#numberformat(Owner.Income,',.__')#</td>
						<td style="border-top:1px solid silver;border-right:1px solid silver;font-size:17px;padding-right:4px" align="right">#numberformat(Owner.Tax,',.__')#</td>
						<td style="border-top:1px solid silver;border-right:1px solid silver;font-size:19px;padding-right:4px" align="right">#numberformat(Owner.Payable,',.__')#</td>					
					
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
							<cfif reference neq "#BillingReference# - #BillingName#">											
							<tr class="line labelmedium">
							<td colspan="7"  style="padding-left:10px;height:1px;">
								<!--- we are hiding this now as it gave some confusion in the presentation 
								#dateformat(TransactionDate,client.dateformatshow)#
								--->																
								<b>#BillingReference# - #BillingName#								
								<cfset reference = "#BillingReference# - #BillingName#">								
							</td></tr>
							</cfif>
							
						<cfoutput group="UnitClassName">		
						
						<cfoutput>
						
							<tr class="labelmedium" style="height:20px;border-top:1px solid silver">							    														
								<td style="padding-left:10px;border-bottom:1px solid silver"><cfif prior neq UnitClassName>#unitclassname#</cfif></td>
								<td style="width:40%;border-bottom:1px solid silver">#UnitDescription#</td>		
								<td align="right" style="border-left:1px solid silver;border-right:1px solid silver;padding-right:4px"><cfif quantityCost gte "1">#QuantityCost#|</cfif>#Quantity#</td>																	
								<td align="right" style="border-left:1px solid silver;border-right:1px solid silver;padding-right:4px"></td>
								<td align="right" style="border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" >#numberformat(SaleAmountIncome,',__.__')#</td>		
								<td align="right" style="border-right:1px solid silver;padding-right:4px">#numberformat(SaleAmountTax,',.__')#</td>									
								<td align="right" style="border-right:1px solid silver;padding-right:10px">#numberformat(SalePayable,',.__')#</td>								
							</tr>
							
							<cfset vamt = vamt + SaleAmountIncome>	
							<cfset vtax = vtax + SaleAmountTax>		
							<cfset prior = unitclassname>
																	
						</cfoutput>
						
						</cfoutput>
																										
						<tr class="labelmedium">
						    <td colspan="2" align="left" style="height:28px;padding-left:20px"></td>
							<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" >
							
							<cfif journal neq "">
							
								<cfset haspostings = "1">

								<table>
									<tr>
									
									<td style="padding-left:10px;">
											
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
													height="20px" 
													width="20px" 
													imageHeight="18px" 
													title="#lt_text#"
													onclick="doPrintFormat('#journal#', '#journalserialNo#','#document.documentid#','#document.documenttemplate#');">											
											
											<cfelseif Document.recordCount gte 2>
											
												<cf_tl id="Print form" var="1">
												
												<cf_button2 
													type="button" 
													mode="icon" 
													image="print_gray.png" 
													height="20px" 
													width="20px" 
													imageHeight="18px" 
													title="#lt_text#"
													onclick="printFormSelected('#journal#', '#journalserialNo#','#workorder.serviceitem#');">									
													
													
											</cfif>
											
										</td>
										
										<cfquery name="header" 
											datasource="AppsLedger" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT    *
											FROM      TransactionHeader
											WHERE     Journal         = '#journal#' 
											AND       JournalSerialNo = '#journalserialno#' 			
										</cfquery>	
										
										<td style="padding-top:3px;padding-left:10px;" class="labelmedium">
											<a href="javascript:ShowTransaction('#journal#', '#journalserialNo#','','window','workorderbiller')">
																				
												 <cfif header.amountOutstanding gte "0.05"><font color="FF0000"><cfelse><font color="0080FF"></cfif>										
											     <cfif InvoiceNo neq "">
												 	#InvoiceSeries#-#InvoiceNo# #DateFormat(header.DocumentDate,CLIENT.DateFormatShow)#</font>
												 <cfelse>
													#journal#-#journalserialNo#</font>
												</cfif>
											</a>									
											
										</td>
										
										<cfif header.transactionSourceId neq "">
										
											<!--- if transaction has no offset postings we allow to remove it --->
											
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
													AND      TransactionSourceId != '#header.transactionsourceid#'  
													AND      H.ActionStatus IN ('0','1') 
													AND      H.RecordStatus != '9'
											</cfquery>	
																															
											<cfif checkOffset.recordcount eq "0" and listBilling.recordcount gte "1">
											
											<td style="padding-top:2px">
																															
											 <cf_img icon="delete" 
											     onclick="Prosis.busy('yes');ptoken.navigate('undoPosting.cfm?workorderlineid=#get.workorderlineid#&journal=#journal#&journalserialno=#journalserialno#','posting')">
											 
											</td>
											
											</cfif>
										
										</cfif>
										
									</tr>
								</table>

								</cfif>
							</td>
							<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"></b></td>							
							<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"><b>#numberformat(vamt,',.__')#</b></td>
							<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-right:1px solid silver;padding-right:4px" align="right"><b>#numberformat(vtax,',.__')#</b></td>
							<td style="border-bottom:1px solid silver;border-top:1px solid silver;border-right:1px solid silver;padding-right:10px" align="right"><b>#numberformat(vtax+vamt,',.__')#</b></td>			
						</tr>	
																																										
						<cfif post eq "1" and Journal eq "">
							
							    <tr><td colspan="7" align="center" style="padding-top:9px">
							
								<cfset toPost = "1">
								
								<table width="100%" border="0" style="min-width:660;background-color:eaeaea;border:1px solid e0e0e0">
								
								     <tr><td colspan="2" style="height:5px"></td></tr>
									 
									 <tr class="labelmedium" >
									 <TD class="labelmedium" style="width:20%;padding-left:20px;padding-right:4px"><cf_tl id="Bill to">:</TD>
									 <td>#BillingReference# #BillingName#</td>
									 </tr>
							      
									 <TR>		  
				  					 <TD class="labelmedium" style="padding-left:20px;padding-right:4px"><cf_tl id="Invoice/Reference"><cf_tl id="No">:</TD>
							         <td style="padding-right:10px">	
									 										   
									   	   <cfset dte = DateTimeFormat(TransactionDate,"YYYYMMDD_HH_nn_ss")>
									       <table>
										   <tr>
										    <td style="padding-left:0px">			   
										   <input type="Text" style="background-color:ffffcf;width:20px;padding-left:5px" class="regularxl enterastab"
										    name="#orgunitOwner#_#orgunitCustomer#_#dte#_invoiceseries" value="" size="1" maxlength="10"> 
										   </td>
										   <td style="padding-left:3px">	
										   
										   <cf_tl id="Record an invoice no" var="inv">		   
										   <input type="Text" style="background-color:ffffcf;" class="regularxl enterastab" 
										   name="#orgunitOwner#_#orgunitCustomer#_#dte#_invoiceno" value="" size="15" maxlength="30"> 
										   </td>
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
											<td class="labelmedium" style="min-width:200;font-size:24px;padding-top:4px;padding-left:20px;padding-right:4px" colspan="1">		
											<a href="javascript:dosettlement('#url.workorderlineid#','#orgunitowner#','#sdte#','#stme#')">[#lt_text#]</a>					
											</td>					
											
											<td width="100%" valign="top" align="right" style="padding-top:1px;padding-right:30px">
											 
											    <table width="100%">
												<tr><td id="#orgunitowner#_#dte#_settlement" width="100%" style="padding:5px">												
													<cfinclude template="WorkOrderLineSettlement.cfm">							
													</td></tr>
												</table>	
											
											</td>
										</tr>
										
						
									</cfif>
									
									<tr><td colspan="2" style="height:5px"></td></tr>
																	 
								</table>
								
							</td></tr>		
								
						</cfif>								
						
						</cfoutput>				<!------InvoiceNo---->

						</cfoutput>				<!------transactionDAte---->
					
					</cfoutput>  <!------orgunitcustomer---->
																	
				</cfoutput> <!-------orgunitowner ----->
													
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