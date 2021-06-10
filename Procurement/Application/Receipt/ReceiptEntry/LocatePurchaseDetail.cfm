
<cfparam name="URL.PurchaseNo" default="">
<cfparam name="URL.OrderDate" default="">
<cfparam name="URL.OrderClass" default="">
<cfparam name="URL.OrderType" default="">
<cfparam name="URL.Period" default="">
<cfparam name="URL.OrgUnit" default="">
<cfparam name="URL.ActionStatus" default="">
<cfparam name="URL.OrderItem" default="">

<cfset condition = "">

<cfif Form.Period neq "">
	<cfset condition = "AND P.Period = '#Form.Period#' and P.Mission = '#URL.Mission#'">
<cfelse>
	<cfset condition = "AND P.Mission = '#URL.Mission#'">
</cfif>	

<cfsavecontent variable="taskfilter">

<cfoutput>

  SELECT SourceRequisitionNo 
  FROM   Materials.dbo.RequestTask T, Materials.dbo.Request R 
  WHERE  T.Requestid = R.RequestId 
  AND    T.SourceRequisitionNo = L.RequisitionNo 
  AND    R.Reference LIKE '%#Form.PurchaseNo#%'
  
  UNION
  
  SELECT SourceRequisitionNo 
  FROM   Materials.dbo.RequestTask T, Materials.dbo.TaskOrder R 
  WHERE  T.StockOrderId = R.StockOrderId 
  AND    T.SourceRequisitionNo = L.RequisitionNo 
  AND    R.Reference LIKE '%#Form.PurchaseNo#%' 
</cfoutput> 

</cfsavecontent>

<cfif Form.PurchaseNo neq "">
  <cfset condition = "#condition# AND (P.PurchaseNo LIKE '%#Form.PurchaseNo#%' OR L.RequisitionNo IN (#preservesinglequotes(taskfilter)#))">
</cfif>

<cfif Form.OrderDate neq "">
	     <cfset dateValue = "">
		 <CF_DateConvert Value="#Form.OrderDate#">
		 <cfset dte = #dateValue#>
		 <cfset condition = "#condition# AND P.OrderDate >= #dte#">
  </cfif>	

<cfif Form.OrderClass neq "">
  <cfset condition = "#condition# AND P.OrderClass = '#Form.OrderClass#'">
</cfif>

<cfif Form.OrderType neq "">
  <cfset condition = "#condition# AND P.OrderType = '#Form.OrderType#'">
</cfif>

<cfif Form.OrgUnitVendor neq "">
  <cfset condition = "#condition# AND P.OrgUnitVendor = '#Form.OrgUnitVendor#'">
</cfif>

<cfif Form.OrgUnit neq "">
  <cfset condition = "#condition# AND P.OrgUnitVendor = '#Form.OrgUnit#'">
</cfif>

<cfif Form.ActionStatus neq "">
  <cfset condition = "#condition# AND P.ActionStatus = '#Form.ActionStatus#'">
</cfif>

<cfif Form.OrderItem gt "a">
  <cfset condition = "#condition# AND L.OrderItem LIKE '%#Form.OrderItem#%'">
</cfif>

<cfif isNumeric(Form.Amount)>
  <cfset condition = "#condition# AND T.TotalOrderAmountBase #Form.amountoperator# #Form.Amount#">
</cfif>

<cfif Form.deliveryStatus eq "3">
  <cfset condition = "#condition# AND D.PurchaseDeliveryStatus = '#Form.DeliveryStatus#'">
<cfelse>
  <cfset condition = "#condition# AND D.PurchaseDeliveryStatus <= '2'">
</cfif>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Purchase">
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Delivery">

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#URL.Mission#'
</cfquery>

<cfsavecontent variable="purchasestatus">

	<cfoutput>
	SELECT    PurchaseNo, 
	          Currency, 
			  SUM(OrderAmount) AS TotalOrderAmount, 
			  SUM(OrderAmountBase) AS TotalOrderAmountBase	
	FROM      PurchaseLine
	WHERE     PurchaseNo IN (SELECT PurchaseNo FROM Purchase WHERE Mission = '#URL.Mission#')
	GROUP BY  PurchaseNo, Currency 
	</cfoutput>

</cfsavecontent>	

<cfsavecontent variable="deliverstatus">

	<cfoutput>
		SELECT    PurchaseNo, 
		          MIN(DeliveryStatus) as PurchaseDeliveryStatus	
		FROM      PurchaseLine
		WHERE     PurchaseNo IN (SELECT PurchaseNo FROM Purchase WHERE Mission = '#URL.Mission#')
		GROUP BY  PurchaseNo
	</cfoutput>
	
</cfsavecontent>	

<cf_verifyOperational 
         datasource= "AppsPurchase"
         module    = "WorkOrder" 
		 Warning   = "No">

<cfquery name="ResultSet" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  P.*, 
	        Cl.Description AS OrderClassdescription, 
	        Tp.Description AS OrderTypeDescription, 
			S.Description  AS ActionDescription,
			T.TotalOrderAmount,
			T.TotalOrderAmountBase,
			L.OrderQuantity, 
			L.OrderUoM, 
			L.OrderUoMVolume,
			L.OrderItem,
			L.Currency, 
			L.OrderAmountCost, 
			L.OrderAmountTax, 
			L.OrderAmount,
			Org.OrgUnitName
	FROM    Purchase P, 
	        Ref_OrderClass Cl, 
			Ref_OrderType Tp, 
			PurchaseLine L,
			Status S,
			Organization.dbo.Organization Org,			
			(#preserveSingleQuotes(purchasestatus)#) as T,						
			(#preserveSingleQuotes(deliverstatus)#) as D
			
	WHERE 	P.PurchaseNo = L.PurchaseNo
	AND     P.OrderType = Tp.Code
	AND     T.PurchaseNo = P.PurchaseNo
	AND     D.PurchaseNo = P.PurchaseNo
	AND     P.OrderClass = Cl.Code			
	<cfif Form.Reference neq "">
	AND L.RequisitionNo IN (SELECT RequisitionNo 
	                        FROM   RequisitionLine L
							WHERE  Mission = '#url.mission#'
							AND    (
							       Reference LIKE '%#trim(Form.Reference)#%' 
							       OR  CaseNo LIKE '%#trim(Form.Reference)#%'							   
							       <cfif operational eq "1">								   
							       OR  WorkOrderId IN (SELECT WorkOrderId 
							                           FROM   WorkOrder.dbo.WorkOrder 
												       WHERE  WorkOrderId = L.WorkorderId
												       AND    Reference LIKE '%#trim(Form.Reference)#%')
							       </cfif>
							      )
							
						   )
	</cfif>	
	AND     P.ActionStatus = S.Status
	AND     S.StatusClass = 'Purchase'
	AND     Org.OrgUnit = P.OrgUnitVendor 
	AND     P.Mission = '#URL.Mission#'
	AND     Tp.ReceiptEntry IN ('0','1')
			#preserveSingleQuotes(condition)#  
			
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->		
		
	<cfelse>
	AND     P.OrderClass IN (SELECT ClassParameter 
	                         FROM   Organization.dbo.OrganizationAuthorization
							 WHERE  Mission        = P.Mission
							 AND    ClassParameter = P.OrderClass
							 AND    Role           = 'ProcRI'
							 AND    UserAccount    = '#SESSION.acc#')	
	</cfif>		
	ORDER BY P.PurchaseNo 
	
</cfquery>


<cf_divscroll>

<cfif Parameter.PurchaseCustomField neq "">
	<cfset colspan="10">
<cfelse>
	<cfset colspan="9">
</cfif>

<table width="100%" align="center" border="0"><tr><td>

<table width="98%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="line labelmedium2 fixrow">
	<td width="26"></td>
	<td width="4%"></td>
	<td><cf_tl id="Purchase order"></td>
	
	<cfif Parameter.PurchaseCustomField neq "">
	
		<cfquery name="CustomField" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   PurchaseReference#Parameter.PurchaseCustomField# AS Label
			FROM     Ref_CustomFields
		</cfquery>
		<td class="label"><cfoutput>#CustomField.Label#</cfoutput></td>
		
	</cfif>
	
	<td><cf_tl id="Issued"></td>
	<td><cf_tl id="Class"></td>
	<td><cf_tl id="Type"></td>
	<td><cf_tl id="Status"></td>
	<td><cf_tl id="Vendor"></td>
	<td align="right" style="padding-right:5px"><cf_tl id="Amount"></td>
</tr>

<cfif ResultSet.recordcount eq "0">

<tr><td colspan="9" align="center" style="height:40px" class="labelit"><font color="808080">There are no records found that match your search</td></tr>

</cfif>

<cfoutput query="ResultSet" group="PurchaseNo">
	
	<tr class="navigation_row labelmedium2">
	
	<td align="center" width="2%" style="padding-left:3px">
	
	    <cfif ActionStatus eq "3">
	      <cfset rct = "1">
	    <cfelseif ActionStatus lt "3" and Parameter.ReceiptPriorApproval eq "1">
		  <cfset rct = "1">
		<cfelseif ActionStatus eq "4" and Parameter.InvoicePriorReceipt eq "1">
		  <cfset rct = "1">  
	    <cfelse>
		  <cfset rct = "0">
		</cfif>
		
		<cfif rct eq "1">
		
		    <cf_img icon="add" navigation="yes" onclick="receiptentry('#purchaseno#')">		
			  
		</cfif>	  
	
	</td>
	
	<td height="18" width="5%" align="center">	
	
			<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
				id="#purchaseNo#Exp" border="0" class="regular" 
				align="middle" style="cursor: pointer;" 
				onClick="more('#purchaseNo#','show')">
				
				<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="#purchaseNo#Min" alt="" border="0" 
				align="middle" class="hide" style="cursor: pointer;" 
				onClick="more('#purchaseNo#','hide')">
								
	</td>
	<td><a href="javascript:ProcPOEdit('#Purchaseno#','view','tab')">#PurchaseNo#</a></td>
	<cfif Parameter.PurchaseCustomField neq "">
		<td>
			#Evaluate("UserDefined#Parameter.PurchaseCustomField#")#
		</td>
	</cfif>
	<td><cfif ActionStatus eq "3">#DateFormat(OrderDate, CLIENT.DateFormatShow)#<cfelse>Pending</cfif></td>
	<td>#OrderClassDescription#</td>
	<td>#OrderTypeDescription#</td>
	<td>#ActionDescription#</td>
	<td>#OrgUnitName#</td>
	<td align="right" style="padding-right:6px">#currency# #NumberFormat(TotalOrderAmount,",.__")#</td>
	</tr>	
	
	<tr id="#purchaseno#" class="hide">
	<td colspan="#colspan#">
		 <table width="100%" class="navigation_table">
				<cfoutput>		
				<tr class="navigation_row labelmedium2 line" style="height:20px">
					<td width="5%"></td>
					<td style="width:80%">#OrderItem#</td></td>
				   	<td style="min-width:100px" align="right">#OrderQuantity#</td>
					<td style="min-width:100px" width="20%" align="center">#OrderUoM#</td>
					<td style="min-width:100px" width="20%" align="center">#OrderUoMVolume#</td>
					<td style="min-width:40px" align="center">#Currency#</td>
					<td style="min-width:120px" width="12"  align="right">#NumberFormat(OrderAmount/OrderQuantity,",.__")#</td>
				    <td style="min-width:120px;padding-right:10px" width="12%" align="right">#NumberFormat(OrderAmount,",.__")#</td>
				</tr>			
				</cfoutput>
		  </table>
	</td>
	</tr>	
	
	<tr><td colspan="#colspan#" class="line"></td></tr>
	
</cfoutput>

</table>
</td></tr>
</table>

<cfset AjaxOnLoad("doHighlight")>	

<script>
	Prosis.busy('no')
</script>

</cf_divscroll>

