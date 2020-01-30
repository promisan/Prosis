
<cfquery name="Purchase" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Purchase
		WHERE  PurchaseNo = '#url.purchaseno#' 		
</cfquery>	

<cfquery name="Invoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Invoice
		WHERE  InvoiceId = '#url.invoiceid#' 		
</cfquery>	

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#Invoice.Mission#' 
</cfquery>

<cfquery name="ResultSet" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  P.*, 
	        Cl.Description AS OrderClassdescription, 
	        Tp.Description AS OrderTypeDescription, 
			S.Description as ActionDescription,
			(SELECT SUM(OrderAmount)     FROM PurchaseLine WHERE PurchaseNo = P.PurchaseNo AND ActionStatus != '9') as TotalOrderAmount,
			(SELECT SUM(OrderAmountBase) FROM PurchaseLine WHERE PurchaseNo = P.PurchaseNo AND ActionStatus != '9') as TotalOrderAmountBase,			
			L.OrderQuantity, 
			L.OrderUoM, 
			L.OrderItem,
			L.Currency, 
			L.OrderAmountCost, 
			L.OrderAmountTax, 
			L.OrderAmount,
			(SELECT OrgUnitName
			 FROM   Organization.dbo.Organization 
			 WHERE  OrgUnit = P.OrgUnitVendor) as OrgUnitName
			
	FROM    Purchase P, 
	        Ref_OrderClass Cl, 
			Ref_OrderType Tp, 
			PurchaseLine L,
			Status S
			
	WHERE 	P.PurchaseNo   = L.PurchaseNo
	AND     P.OrderType    = Tp.Code	
	AND     P.OrderClass   = Cl.Code				
	AND     P.ActionStatus = S.Status
	AND     S.StatusClass  = 'Purchase'	
	AND     P.Mission      = '#Invoice.Mission#'
	
	AND     P.PurchaseNo NOT IN (SELECT PurchaseNo
	                             FROM   skPurchase 
								 WHERE  InvoiceAmount >= OrderAmount)									 
	AND      (
		 	       (
				  		(P.OrgUnitVendor = '#Purchase.OrgUnitVendor#' AND P.OrgUnitVendor <> '0') 
				        OR (P.PersonNo = '#Purchase.PersonNo#' AND P.PersonNo <> '')
					    OR P.InvoiceAssociate = 1
					)	
						  				   
				  AND P.OrderType   = '#Purchase.OrderType#'  <!--- import to keep the same ordertype  for posting !!!! --->
				  AND P.OrderClass  = '#Purchase.OrderClass#' <!--- import to keep the same orderclass for posting !!!! --->					  
							
			)		
			
			
	AND   	P.PurchaseNo <> '#url.purchaseno#'						 
	
	AND     P.ActionStatus != '9'
		
</cfquery>	


<table width="100%" border="0" bgcolor="white">

<tr><td style="border:1px solid silver;padding-left:8px;padding-right:8px">

	<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
	
	<tr class="line labelit">
		<td width="1%"></td>	
		<td></td>
		<td><cf_tl id="Purchase No"></td>
		<td><cf_tl id="Vendor"></td>
		<td><cf_tl id="Class"></td>
		<td><cf_tl id="Type"></td>
		<td><cf_tl id="Status"></td>	
		<td align="right"><cf_tl id="Curr">.</td>
		<td align="right"><cf_tl id="Amount"></td>
		<td></td>
	</tr>
	
	<cfoutput query="ResultSet" group="PurchaseNo">
	
		<tr id="#currentrow#" class="navigation_row linedotted labelit">
		
			<td style="padding-left:4px;padding-top:2px">
			  <cf_img icon="add" tooltip="select" onClick="purchaseselect('#purchaseno#','#invoiceid#')">
			</td>
			
			<td width="2%" align="center">
			
				<img src="#SESSION.root#/Images/arrowright.gif" alt="Purchase lines" 
					id="#purchaseNo#Exp" border="0" class="regular" style="height:12px"
					align="middle" style="cursor: pointer;" 
					onClick="more('#purchaseNo#','show')">
							
				<img src="#SESSION.root#/Images/arrowdown.gif" 
					id="#purchaseNo#Min" alt="Hide" border="0" style="height:12px"
					align="middle" class="hide" style="cursor: pointer;" 
					onClick="more('#purchaseNo#','hide')">
						
			</td>
			
			<td>
			
			   <a href="javascript:ProcPOEdit('#Purchaseno#','view')">
					<font color="6688aa">	
					<cfif Parameter.PurchaseCustomField eq "">#PurchaseNo#<cfelse>				
					<cfif evaluate("ResultSet.Userdefined#Parameter.PurchaseCustomField#") neq "">#evaluate("ResultSet.Userdefined#Parameter.PurchaseCustomField#")#<cfelse>#PurchaseNo#</cfif>
					</cfif>
					</font>
				</a>
			</td>
			
			<td>#OrgUnitName#</td>			
			<td onClick="invoiceentry('#orgunitvendor#','#PurchaseNo#','#PersonNo#')">#OrderClassDescription#</td>		
			<td onClick="invoiceentry('#orgunitvendor#','#PurchaseNo#','#PersonNo#')">#OrderTypeDescription#</td>		
			<td>#ActionDescription# <cfif ActionStatus eq "3">on: <u>#DateFormat(OrderDate, CLIENT.DateFormatShow)#</cfif></td>
			<td width="50" align="right">#currency#</td>
			<td width="100" align="right" onClick="invoiceentry('#orgunitvendor#','#PurchaseNo#')">#NumberFormat(TotalOrderAmount,",.__")#</td>
		
		</tr>
	
		<tr id="#purchaseno#" bgcolor="f6f6f6" class="hide">
		
			<td bgcolor="white" colspan="2"></td>
			<td colspan="7">
			 <table width="100%">
				<cfoutput>
				    <tr><td></td><td colspan="5" bgcolor="E2E2E2"></td></tr>
					<tr class="labelit">			
						<td width="30%">#OrderItem#</td></td>
					   	<td width="10%" align="right">#OrderQuantity#</td>
						<td width="20%" align="center">#OrderUoM#</td>
						<td width="10%" align="center">#Currency#</td>
						<td width="12%" align="right">#NumberFormat(OrderAmount/OrderQuantity,",__.__")#</td>
					    <td width="12%" align="right">#NumberFormat(OrderAmount,",__.__")#</td>
					</tr>			
				</cfoutput>
			  </table>
			</td>
			
		</tr>	
	
	</cfoutput>
	
	</table>
	
</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>	

