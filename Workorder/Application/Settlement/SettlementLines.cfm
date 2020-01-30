
<cfparam name="url.close" default="0">
<cfparam name="transtime" default="00_00_00">
<cfparam name="url.transactiontime" default="00_00_00">

<cfset transtime = "#url.transactiontime#">
<cfset transtime = replace(transtime,"_",":","all")>
<cfset transtime = "#transtime#.000">

<cfquery name="get" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT    *
	FROM      WorkOrderLine WL INNER JOIN
              WorkOrder W ON WL.WorkOrderId = W.WorkOrderId
	WHERE     WL.WorkOrderLineId = '#url.workorderlineid#'	
</cfquery>	

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_Mission
	 WHERE   Mission = '#get.Mission#'	
</cfquery>

<cfquery name="customer" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT    C.*
	FROM      WorkOrder W INNER JOIN
              Customer C ON W.CustomerId = C.CustomerId
	WHERE     W.WorkOrderId = '#get.workorderid#'	
</cfquery>	

<cfquery name="qClear"
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE FROM WorkOrderLineSettlement
	 WHERE  WorkOrderId   = '#get.workorderid#'	
	 AND    WorkOrderLine = '#get.WorkOrderLine#'
	 AND    OrgUnitOwner  = '#url.orgunitowner#'	
	 AND    TransactionDate = '#url.transactiondate# #transtime#'	
	 AND    SettleAmount < 0		
</cfquery> 	

<cfquery name="getSettle"
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT    SE.*, 
	          S.Mode, S.Description 
	FROM      WorkorderLineSettlement SE INNER JOIN Ref_Settlement S ON SE.SettleCode = S.Code
	WHERE     WorkOrderId     = '#get.workorderid#'	
	AND       WorkOrderLine   = '#get.WorkOrderLine#'
	AND       OrgUnitOwner    = '#url.orgunitowner#'	
	AND       TransactionDate = '#url.transactiondate# #transtime#'	
</cfquery> 


<cfquery name="getSale"
 datasource="AppsWorkOrder" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT    Currency, 
			  ISNULL(SUM(SalePayable),0) as sTotal
	FROM      WorkorderLineCharge
	WHERE     WorkOrderId     = '#get.workorderid#'	
	AND       WorkOrderLine   = '#get.WorkOrderLine#'
	AND       OrgUnitOwner    = '#url.orgunitowner#'	
	AND       TransactionDate = '#url.transactiondate# #transtime#'		
	AND       Journal is NULL
	GROUP BY  Currency 
</cfquery> 

<cfif getSale.sTotal eq "0">
	
	<script>
		alert("Charges with no amount were recorded. Operation aborted.")
	</script>

</cfif>

<cfoutput>

<table id="tsettlement" name="tsettlement" align="center" height="100%" border="0" class="navigation_table">

<tr><td colspan="7">

<cfif getSettle.SettleReference eq "" and getSettle.SettleCustomerName eq "">

    <cfset per = customer.PersonNo>
	<cfset ref = customer.Reference>
	<cfset nme = customer.CustomerName>

<cfelse>

    <cfset per = getSettle.SettlePersonNo>
	<cfset ref = getSettle.SettleReference>
	<cfset nme = getSettle.SettleCustomerName>
	
</cfif>

<table height="100%" width="100%" class="formpadding">
	
	<tr class="labelmedium">
		<td height="20" style="padding-right:4px"><cf_tl id="TaxReference">:</td>
		<td>
		
		<input type="text" onchange="ColdFusion.navigate('#session.root#/workorder/application/settlement/setPayer.cfm?orgunitowner=#url.orgunitowner#&workorderlineid=#url.workorderlineid#','taxpay','','','POST','salesdetails')" 
		   name="SettleReference" id="SettleReference" value="#ref#" size="20" maxlength="20" class="enterastab regularxl">	
		   
		</td>
		
		<td id="payerbox"></td>
		
		<td>
		
			<input type="hidden" id="SettlePersonNo" name="SettlePersonNo" value="#per#">
			
			<cf_tl id="TaxCode" var="1">
									
			<cfset link = "#SESSION.root#/Workorder/Application/Settlement/setTax.cfm?country=#mission.countrycode#&orgunitowner=#url.orgunitowner#&workorderlineid=#url.workorderlineid#">
			   		
			<cf_selectlookup
			    box          = "taxpay"
				title        = "#lt_text#"
				link         = "#link#"
				filter1      = "country"
				filter1value = "#mission.countrycode#"						
				button       = "No"
				close        = "Yes"
				class        = "tax"
				des1         = "taxcode">			
			
		</td>
	</tr>
	
	<tr class="labelmedium">
		<td height="20" ><cf_tl id="Name">:</td>
		
		<td colspan="3">
		<input type="text" onchange="ColdFusion.navigate('#session.root#/workorder/application/settlement/setPayer.cfm?orgunitowner=#url.orgunitowner#&workorderlineid=#url.workorderlineid#','taxpay','','','POST','salesdetails')"  
		 name="SettleCustomerName" id="SettleCustomerName" value="#nme#" style="width:100%" maxlength="80" class="enterastab regularxl">	
		</td>
	</tr>
	
	<tr class="hide"><td id="taxpay"></td></tr>
	
	<tr><td height="7"></td></tr>

</table>

</td></tr>

<tr><td height="100%" colspan="7" valign="top">

<table width="100%">

<tr class="settlement_title labelit">
	
	<td class="line" width="3%"></td>
	<td class="line" width="5%"></td>
	<td class="line" width="35%"><cf_tl id="Type"></td>	
	<td class="line" align="right"></td>
	<td class="line" width="15%" align="right"><cf_tl id="Amount"></td>
	<td class="line" width="15%" align="right">#getSale.Currency#</td>
	<td class="line" width="2%"></td>		
</tr>

<cfset vTotal = 0>
<cfset vTotal_Cash = 0>

<cfloop query = "getSettle">

	<tr class="line_details navigation_row labelmedium">
			
		<td class="line" style="padding-left:10px;padding-right:7px;height:35px">#currentrow#.</td>
		<td class="line" style="padding-right:7px">
		
		<img src="#SESSION.root#/images/delete5.gif" 
						     alt="#lt_text#" 
							 border="0" 
							 width="15" height="15"
							 style="cursor:pointer" 
							 class="navigation_action"
						     onclick="_cf_loadingtexthtml='';settlementlinedelete('#workordersettleid#','#url.workorderlineid#','#url.orgunitowner#','#url.terminal#','#url.transactiondate#','#url.transactiontime#')">
					
			
		</td>
		<td class="line">#Description#</td>
		<td class="line" align="right" style="font-size:13px">#SettleCurrency#</td>
		<td class="line" align="right" style="padding-left:5px;font: large Calibri;">#NumberFormat(SettleAmount, ',.__')# </td>
		<td class="line" align="right">
	 
			<cfif SettleCurrency neq getSale.Currency>
			
			    <!--- this will not happen as the currency is set the workorder currency --->
				
				<cfset exc = 0.00>
				<cf_exchangerate CurrencyFrom = "#SettleCurrency#" CurrencyTo = "#getSale.Currency#">
				<cfset vConverted_Amount = round(SettleAmount/exc * 100 )/ 100>		
				
			<cfelse>
				<cfset vConverted_Amount = SettleAmount>	
			</cfif>	
			
			<cfif Mode eq "Cash">
				<cfset vTotal_Cash = vTotal_Cash + vConverted_Amount>
			</cfif>
			
			#NumberFormat(vConverted_Amount, ',.__')#	
			<cfset vTotal = vTotal + vConverted_Amount>		
			
		</td>
		<td class="line"></td>
	
	</tr>
	
	<cfswitch expression="#Mode#">
	
		<cfcase value="Gift">
			<tr height="20">
			<td></td>
			<td colspan="6" class="labelmedium">#PromotionCardNo#</td>
			</tr>
		</cfcase>
		
		<cfcase value="Credit">
			<tr height="20">
			<td></td>
			<td colspan="6">
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
				<tr class="labelmedium line_details"><td style="padding-left:10px">#CreditCardNo# &nbsp;&nbsp;Expiry: #ExpirationMonth#/#ExpirationYear# &nbsp;&nbsp;&nbsp;Approval: #ApprovalCode#</td></tr>									
			</table>
			</td>
			</tr>
		</cfcase>
		
		<cfcase value="Check">
			<tr height="20">
			<td></td>
			<td colspan="6">
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
				<tr class="labelmedium line_details"><td style="padding-left:10px">#BankName# &nbsp;&nbsp;Check No.: #ApprovalReference#  &nbsp;&nbsp;Approval: #ApprovalCode#</td></tr>									
			</table>
			</td>
			</tr>
		</cfcase>
		
	</cfswitch>
	
	</td>		
	</tr>
			
</cfloop>

</table></td></tr>

	 <cfset dte = DateTimeFormat("#url.TransactionDate# #transtime#","YYYYMMDD_HH_nn_ss")>


	<script language="JavaScript">					
		settlementview('#url.workorderlineid#','#url.orgunitowner#','#url.transactiondate#','#url.orgunitowner#_#dte#') 		
	</script>
	
	<cfquery name="getDiscounted" dbtype="query">
		SELECT 	SUM(SettleAmount) as SettleAmount
		FROM 	getSettle
		WHERE	Mode = 'Gift'
	</cfquery>
		
	<cfset vDiscount = 0>
	
	    <cfif getDiscounted.recordCount gt 0>
			<cfset vDiscount = getDiscounted.SettleAmount>
		</cfif>		
		
		<tr height="45" style="border-top:1px solid silver">
		    <td colspan="3"></td>
			<td colspan="2" align="left" style="padding-right:20px" class="labellarge"><cf_tl id="Receipt"></td>
			<td align="right" class="labellarge" style="border-top:1px solid gray;font-size:30px; color:gray">#NumberFormat((vTotal - vDiscount), ',__.__')# </td>
			<td></td>
		</tr>
		
		<cfif vDiscount gt 0>		
			
			<tr height="45">
				<td colspan="3"></td>
				<td colspan="2" style="padding-right:20px" class="labellarge"><cf_tl id="Discounted"></td>
				<td align="right" class="labellarge" style="border-top:1px solid gray;width:400px;font-size:30px; color:red">#NumberFormat(vDiscount, ',__.__')# </td>
				<td></td>
			</tr>
			
		</cfif>
						
		<cfset vPending = getSale.sTotal - vTotal>
		
		<cfif vPending gt 0.005>		
			
			<tr height="45">
				<td colspan="3"></td>
				<td colspan="2" style="padding-right:20px" class="labellarge"><cf_tl id="Pending"></td>
				<td align="right" class="labellarge" style="border-top:1px solid gray;width:400px;font-size:30px;">				
				#NumberFormat(vPending, ',.__')#</td>
				<td></td>
			</tr>
			
		</cfif>
						
		<tr height="45">
		    <td colspan="3"></td>
			<td colspan="2" style="padding-left:10px;padding-right:20px" class="labelmedium"><cf_tl id="Total Due"><cf_space spaces="40"></td>
			<td align="right" class="labellarge" style="border-top:1px solid gray;width:400px;font-size:21px;color:gray">#NumberFormat(getSale.sTotal, ',__.__')# </td>
			<td></td>
		</tr>
		
		<tr><td colspan="7" class="line"></td></tr>
		
		<cfif ABS(vTotal-getSale.sTotal) gte 0.01>
				
			<cfif getSale.recordcount gt 0>
				<cfset vRemaining = vTotal_Cash - (getSale.sTotal - (vTotal - vTotal_Cash) ) >
			<cfelse>
				<cfset vRemaining = 0>
			</cfif>		
													
			<cfif vRemaining gt 0.00>		
													
				<cfquery name="getMode"
				 datasource="AppsWorkOrder" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 	SELECT    Code 
					FROM      Ref_Settlement
					WHERE     Mode = 'Cash' 
				</cfquery> 			
				
				<cfquery name="qCheck"
				 datasource="AppsWorkOrder" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 	 SELECT  *
					 FROM    WorkOrderLineSettlement
					 WHERE   WorkOrderId     = '#get.workorderid#'	
					 AND     WorkOrderLine   = '#get.WorkOrderLine#'
					 AND     OrgUnitOwner    = '#url.orgunitowner#'	
					 AND     TransactionDate = '#url.transactiondate# #transtime#'		 				
		 			 AND     SettleCode      = '#getMode.Code#'		
					 AND     SettleCurrency  = '#getSale.Currency#'
				</cfquery> 	 
	
				<cfif qCheck.recordCount eq 0>
								
					<cfquery name="qInsert"
					 datasource="AppsWorkOrder" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 INSERT INTO WorkOrderLineSettlement
						        ( WorkOrderId,
							      WorkOrderLine,
							      OrgUnitOwner,	
							      TransactionDate,						   							 
						          SettleCode,					 
						          SettleCurrency,
						          SettleAmount )
						 VALUES ( '#get.workorderid#',
						          '#get.WorkOrderLine#',
								  '#url.orgunitowner#',
								  '#url.transactiondate# #transtime#',
								  '#getMode.Code#',					
								  '#getSale.Currency#',
								  '#-1*vRemaining#'
								)
					</cfquery>
					
				<cfelse>
								
					<cfquery name="qUpdate"
					 datasource="AppsWorkOrder" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 UPDATE   WorkOrderLineSettlement
						 SET      SettleAmount 	  = '#-1*vRemaining+qCheck.SettleAmount#' 
						 WHERE    WorkOrderId     = '#get.workorderid#'	
						 AND      WorkOrderLine   = '#get.WorkOrderLine#'
						 AND      OrgUnitOwner    = '#url.orgunitowner#'		 				
						 AND      TransactionDate = '#url.transactiondate# #transtime#'
			 			 AND      SettleCode      = '#getMode.Code#'		
						 AND      SettleCurrency  = '#getSale.Currency#'						
					</cfquery> 	
					
				</cfif>	 
						
				<tr><td colspan="7" class="line"></td></tr>	
				<tr height="50">
					<td colspan="5" align="left" style="padding-left:20px" class="labellarge"><cf_tl id="Cash back"><cf_space spaces="50"></td>
					<td align="right" style="font-size:34px"><font color="0080C0">#NumberFormat(vRemaining, '_,____.__')#</td>
					<td></td>
				</tr>	
			
			</cfif>
			
			<tr><td height="20"></td></tr>
			
		<cfelseif url.close eq "1">
		
			<script>
				ColdFusion.Window.destroy('wsettle',true)
			</script>	
			
		</cfif>	
		
		<!---
		
		<cfif getSettle.recordcount gte "1">
		
		<tr class="settlement_title" height="100%">
				
			<td colspan="7" align="center" valign="bottom" style="padding-top:6px">
					
			<cf_tl id="Tender" var="1">	
		
			<cf_button2
				text		 = "#lt_text#" 
				subtext		 = "#lt_text#"
				id			 = "printsettlement"  
				bgColor		 = "##a0a0a0"
				textsize	 = "26px" 
				subtextsize	 = "15px" 
				height		 = "60px"
				width		 = "200px"							
				textColor	 = "##F2F2F2"
				borderRadius = "5px">
						
			</td>			
			
		</tr>	
					
		</cfif>		
		
		--->	
		
		<!--- not relevant here as we post from the main screen 
		
		<cfif NumberFormat(vTotal, '_____.__') gte NumberFormat(getSale.sTotal, '_____.__')>
		
			<tr><td colspan="7" class="line"></td></tr>				
			<tr><td colspan="7" height="10"></td></tr>	
				
			<tr class="settlement_title" height="100%">
				
					<td colspan="7" align="center" valign="bottom" style="padding-bottom:10px">
										
					<cf_tl id="Invoice"    var="label1">
					<cf_tl id="Electronic" var="label2">		
					<cf_tl id="Manual"     var="label3">						
								
					<cfquery name="getInvoiceSale"
					 datasource="AppsTransaction" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 	SELECT  R.*
						FROM    Sale#url.warehouse# R
						WHERE   CustomerIdInvoice IN (SELECT CustomerId FROM Materials.dbo.Customer WHERE CustomerId = R.CustomerIdInvoice)
						AND     CustomerId = '#URL.CustomerId#'
					</cfquery> 
					
					<cfif getInvoiceSale.recordcount gte "1">
								
						<cfset customeridinvoice = getInvoiceSale.CustomerIdInvoice>
						
					<cfelse>
					
						<cfset customeridinvoice = url.customerid>
						
					</cfif>					
										
					<cfquery name="getWarehouseJournal"
						 datasource="AppsMaterials" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 	SELECT  *
							FROM    WarehouseJournal
							WHERE   Warehouse = '#url.warehouse#'
							AND		Area      = 'SETTLE'
							AND		Currency  = '#getSale.SalesCurrency#'
					</cfquery> 
					
					<cfif getWarehouseJournal.TransactionMode eq "2">
					
						<cfif getSale.sTotal neq "0">
						
							<cf_button2
								text		 = "&nbsp;&nbsp;#label2#" 
								subtext		 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#label1#"
								id			 = "postsettlementbutton1"  
								bgColor		 = "##3C5AAB"
								textsize	 = "26px" 
								subtextsize	 = "15px" 
								height		 = "60px"
								width		 = "200px"							
								textColor	 = "##F2F2F2"
								borderRadius = "5px"
								onclick	     = "postsettlement('#url.warehouse#','#url.customerid#','#customeridinvoice#','#getSale.SalesCurrency#','#url.batchid#','#url.terminal#','#url.td#','#url.th#','#url.tm#','2')">
							
						</cfif>
						
							<cf_button2
								text		 = "&nbsp;&nbsp;&nbsp;#label3#" 
								subtext		 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#label1#"
								id			 = "postsettlementbutton2"  
								bgColor		 = "##a0a0a0"
								textsize	 = "26px" 
								subtextsize	 = "15px" 
								height		 = "60px"
								width		 = "200px"							
								textColor	 = "##F2F2F2"
								borderRadius = "5px"
								onclick	     = "postsettlement('#url.warehouse#','#url.customerid#','#customeridinvoice#','#getSale.SalesCurrency#','#url.batchid#','#url.terminal#','#url.td#','#url.th#','#url.tm#','1')">
														
					
					<cfelse>		
							
							<cf_tl id="Tender" var="1">	 
							
							<cf_button2
								text		 = "&nbsp;&nbsp;#label1#" 
								subtext		 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#lt_text#"
								id			 = "postsettlementbutton"  
								bgColor		 = "##a0a0a0"
								textsize	 = "26px" 
								subtextsize	 = "15px" 
								height		 = "60px"
								width		 = "200px"							
								textColor	 = "##F2F2F2"
								borderRadius = "5px"
								onclick	     = "postsettlement('#url.warehouse#','#url.customerid#','#customeridinvoice#','#getSale.SalesCurrency#','#url.batchid#','#url.terminal#','#url.td#','#url.th#','#url.tm#','1')">
								
					</cfif>		
											   
					</td>
			 </tr>					
			 <tr class="hide"><td colspan="settlementprocessbox"></td></tr>	
			 
		<cfelse>
		
			<tr><td height="100%"></td></tr>	 
		 
		 </cfif>
		 
		 --->
			
</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>
