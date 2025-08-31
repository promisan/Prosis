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
<cf_screentop height="100%" html="No" scroll="No" jQuery="Yes">

<cfoutput>
	
	<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE    Mission = '#URL.Mission#'
	</cfquery>
	
	<script language="JavaScript">
	
	function more(bx,act) {
	
	    icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById(bx)
			
		if (act=="show") {
			se.className  = "regular";
			ptoken.navigate('LocatePurchaseDetailLines.cfm?purchaseNo='+bx,bx)
			icM.className = "regular";
		    icE.className = "hide";
		} else {
			se.className  = "hide";
		    icM.className = "hide";
		    icE.className = "regular";
		}
		}
		
	function invoiceentry(orgunit,po,personno) {
	   ptoken.location("InvoiceEntry.cfm?Mission=#URL.Mission#&Period=#URL.Period#&OrgUnit="+orgunit+"&PersonNo="+personno+"&PurchaseNo="+po);	
	  }	
	  
	</script>

</cfoutput>

<cf_DialogProcurement>

<cfparam name="form.PurchaseNo"     default="">
<cfparam name="form.RequisitionNo"  default="">
<cfparam name="form.OrderDate"      default="">
<cfparam name="form.OrderClass"     default="">
<cfparam name="form.OrderType"      default="">
<cfparam name="form.OrgUnitVendor"  default="">
<cfparam name="form.Period"         default="">
<cfparam name="form.IndexNo"        default="">
<cfparam name="form.PersonNo"       default="">
<cfparam name="form.OrgUnit"        default="">
<cfparam name="form.ActionStatus"   default="">
<cfparam name="form.OrderItem"      default="">
<cfparam name="form.Amount"         default="0">
<cfparam name="form.DeliveryStatus" default="">

<cfset condition = "">

<cfset condition = "AND P.Mission = '#URL.Mission#'">

<cfif Form.PurchaseNo neq "">
   <cfif Parameter.PurchaseCustomField eq "">
     <cfset condition = "#condition# AND (P.PurchaseNo LIKE '%#Form.PurchaseNo#%')">  
   <cfelse>
     <cfset condition = "#condition# AND (P.PurchaseNo LIKE '%#Form.PurchaseNo#%' OR P.Userdefined#Parameter.PurchaseCustomField# LIKE '%#Form.PurchaseNo#%')">
   </cfif>
</cfif>

<cfif Form.OrderDate neq "">
   <cfset dateValue = "">
   <cf_DateConvert Value = "#Form.OrderDate#">
   <cfset dte = dateValue>
   <cfset condition = "#condition# AND P.OrderDate >= #dte#">
</cfif>	

<cfif Form.OrderClass neq "">
  <cfset condition = "#condition# AND P.OrderClass = '#Form.OrderClass#'">
</cfif>

<cfif Form.PersonNo neq "">
    <cfset condition = "#condition# AND P.PersonNo = '#Form.PersonNo#'">
</cfif>

<cfif Form.IndexNo neq "">
    <cfset condition = "#condition# AND P.PersonNo IN (SELECT PersonNo FROM Employee.dbo.Person WHERE IndexNo LIKE '%#Form.IndexNo#%')">
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

<cfif len(Form.OrderItem) gt "1">
  <cfset condition = "#condition# AND L.OrderItem LIKE '%#Form.OrderItem#%'">
</cfif>

<cfif Form.RequisitionNo neq "">
  <cfset condition  = "#condition# AND  (P.PurchaseNo IN (SELECT P.PurchaseNo FROM RequisitionLine L INNER JOIN PurchaseLine P ON L.RequisitionNo = P.RequisitionNo WHERE (L.RequisitionNo LIKE '%#Form.RequisitionNo#%') OR (L.Reference LIKE '%#Form.RequisitionNo#%')))">								
</cfif>	

<cfif Form.deliveryStatus neq "">

	<cfif Form.deliveryStatus eq "3">
	  <cfset condition = "#condition# AND (SELECT MIN(DeliveryStatus) FROM PurchaseLine WHERE PurchaseNo = P.PurchaseNo) = '#Form.DeliveryStatus#'">
	<cfelse>
	  <cfset condition = "#condition# AND (SELECT MIN(DeliveryStatus) FROM PurchaseLine WHERE PurchaseNo = P.PurchaseNo) <= '2'">
	</cfif>

</cfif>	

<cfset FileNo = round(Rand()*20)>
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Invoice_#fileNo#">

<!--- retrieve only purchase order with receipts that are not posted in GL yet = not matched --->

	<cfquery name="Invoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  PL.PurchaseNo
		INTO    userQuery.dbo.#SESSION.acc#Invoice_#fileNo#
		
		<!--- receipt enabled PO's --->
		
		<cfif parameter.InvoicePriorReceipt eq "0">		
			
			FROM    Purchase P INNER JOIN
		            PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo INNER JOIN
		            PurchaseLineReceipt PR ON PL.RequisitionNo = PR.RequisitionNo
			WHERE   P.Mission = '#URL.Mission#' 
			<cfif Form.Period neq "">
			AND     P.Period = '#Form.Period#'	 
			</cfif>
			AND     P.OrderType IN (SELECT Code 
			                        FROM   Ref_OrderType 
									WHERE  ReceiptEntry IN ('0','1')) 
													  
			AND     PR.ActionStatus != '9'	
			
			<!--- do not allow recording of invoice for a purchase order for which there are no POSTED receipt --->
						
			AND 	PR.ReceiptId NOT IN
		                          (SELECT ReferenceId
		                            FROM  Accounting.dbo.TransactionLine
									WHERE Reference = 'Invoice')
																		
			 						
		<cfelse>					
					
			FROM    Purchase P INNER JOIN
		            PurchaseLine PL ON P.PurchaseNo = PL.PurchaseNo
			WHERE   P.Mission = '#URL.Mission#' 
			<cfif Form.Period neq "">
			AND     P.Period = '#Form.Period#'	 
			</cfif>
			AND     P.OrderType IN (SELECT Code 
			                        FROM   Ref_OrderType 
									WHERE  ReceiptEntry IN ('0','1'))									
					  
		</cfif>						
		
		<!--- purchase is enabled for invoice --->		
		AND      P.OrderType NOT IN (SELECT Code FROM Ref_OrderType WHERE InvoiceWorkflow = '9') 
		
		<!--- only if not forced for closure --->
		AND      P.ObligationStatus = '1'
						
		GROUP BY PL.PurchaseNo
			
		<!--- invoice only PO --->
			
		UNION
		
		<!--- retrieve invoice only PO's --->
		
		SELECT   P.PurchaseNo
		FROM     Purchase P 
		WHERE    P.Mission = '#URL.Mission#' 
		<cfif Form.Period neq "">
		AND      P.Period = '#Form.Period#'	 
		</cfif>
		AND      P.OrderType IN     (SELECT Code FROM Ref_OrderType WHERE ReceiptEntry IN ('9')) 
		
		<!--- exclude purchase orders that do not have invoice enabled --->		
		AND      P.OrderType NOT IN (SELECT Code FROM Ref_OrderType WHERE InvoiceWorkflow = '9') 
								  
		<!--- -only if not forced for closure --->
		AND      P.ObligationStatus = '1'		  		
								  	  
		GROUP BY P.PurchaseNo 
					
	</cfquery>

<!--- END retrieve purchase order with receipts that are not posted in GL yet = not matched --->	

<cfquery name="ResultSet" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  P.*, 
	
		    (SELECT SUM(OrderAmount) 
			 FROM   PurchaseLine
			 WHERE  PurchaseNo = P.PurchaseNo) AS TotalOrderAmount, 	
			
			(SELECT MIN(DeliveryStatus) 
			 FROM      PurchaseLine
			 WHERE  PurchaseNo = P.PurchaseNo) AS PurchaseDeliveryStatus,	  	
	
	        Cl.Description AS OrderClassdescription, 
	        Tp.Description AS OrderTypeDescription, 
			S.Description as ActionDescription,
			
			L.OrderQuantity, 
			L.OrderUoM, 
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
			Organization.dbo.Organization Org			
			
	WHERE 	P.PurchaseNo   = L.PurchaseNo
	AND     P.OrderType    = Tp.Code		
	AND     P.OrderClass   = Cl.Code				
	AND     P.ActionStatus = S.Status
	AND     S.StatusClass  = 'Purchase'
	
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
	
	<cfelse>
	
		AND     P.OrderType IN (SELECT GroupParameter 
		                        FROM   Organization.dbo.OrganizationAuthorization 
								WHERE  UserAccount    = '#SESSION.acc#' 
								AND    Role           = 'ProcInvoice' 
								AND    Mission        = '#url.mission#'
								AND    GroupParameter = P.OrderType)
							
	</cfif>	
	
	AND     Org.OrgUnit = P.OrgUnitVendor 
	AND     P.PurchaseNo IN (SELECT PurchaseNo 
	                         FROM   userQuery.dbo.#SESSION.acc#Invoice_#fileNo#
							 WHERE  PurchaseNo = P.PurchaseNo) <!--- only purchase order that have not been invoiced --->
							 
	#preserveSingleQuotes(condition)#  
	
	AND      P.OrgUnitVendor > ''
	
	<cfif Form.ProgramCode neq "">
	
	AND   L.RequisitionNo IN  (SELECT RequisitionNo 
	                           FROM   RequisitionLineFunding F
						       WHERE  F.ProgramCode = '#Form.ProgramCode#'
							   AND    F.RequisitionNo = L.RequisitionNo)
	</cfif>		    
	
	UNION ALL
	
	SELECT  P.*, 	
		
		    (SELECT SUM(OrderAmount) 
			FROM   PurchaseLine
			WHERE  PurchaseNo = P.PurchaseNo) AS TotalOrderAmount, 
			
			(SELECT MIN(DeliveryStatus) 
			 FROM      PurchaseLine
			 WHERE  PurchaseNo = P.PurchaseNo) AS PurchaseDeliveryStatus,	  	
			
	        Cl.Description AS OrderClassdescription, 
	        Tp.Description AS OrderTypeDescription, 
			S.Description as ActionDescription,			
			
			L.OrderQuantity, 
			L.OrderUoM, 
			L.OrderItem,
			L.Currency, 
			L.OrderAmountCost, 
			L.OrderAmountTax, 
			L.OrderAmount,
			Org.FirstName+' '+Org.LastName as OrgUnitName
			
	FROM    Purchase P, 
	        Ref_OrderClass Cl, 
			Ref_OrderType Tp, 
			PurchaseLine L,
			Status S,
			Employee.dbo.Person Org			
			
	WHERE 	P.PurchaseNo   = L.PurchaseNo
	AND     P.OrderType    = Tp.Code		
	AND     P.OrderClass   = Cl.Code				
	AND     P.ActionStatus = S.Status
	AND     S.StatusClass  = 'Purchase'
	AND     Org.PersonNo   = P.PersonNo 
	AND     P.PurchaseNo IN (SELECT PurchaseNo 
	                         FROM   userQuery.dbo.#SESSION.acc#Invoice_#fileNo#
							 WHERE  PurchaseNo = P.PurchaseNo) <!--- only purchase order that have not been invoiced --->
	#preserveSingleQuotes(condition)# 
	AND      P.PersonNo > ''
	
	<cfif getAdministrator(url.mission) eq "1">
		 
		 	<!--- no filtering as user is a (local) administrator --->
		 
	<cfelse>
	
	AND     P.OrderType IN (SELECT GroupParameter 
	                        FROM   Organization.dbo.OrganizationAuthorization 
							WHERE  UserAccount    = '#SESSION.acc#' 
							AND    Role           = 'ProcInvoice' 
							AND    Mission        = '#url.mission#'
							AND    GroupParameter = P.OrderType)
							
	</cfif>
	
	<cfif Form.ProgramCode neq "">
	
	AND   L.RequisitionNo IN  (SELECT RequisitionNo 
	                           FROM   RequisitionLineFunding F
						       WHERE  F.ProgramCode   = '#Form.ProgramCode#'
							   AND    F.RequisitionNo = L.RequisitionNo)
	</cfif>
					
	ORDER BY P.PurchaseNo 
	
</cfquery>


<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Invoice_#fileNo#">

<table width="100%" height="100%" border="0" bgcolor="white">

<tr><td height="100%">

<cf_divscroll>

<table style="width:98.5%" class="navigation_table">

<tr class="line fixrow labelmedium2 fixlengthlist">
	<td width="5%"></td>
	<td><cf_tl id="Vendor"></td>
	<td><cf_tl id="Purchase No"></td>
	<td><cf_tl id="Class"></td>
	<td><cf_tl id="Type"></td>
	<td><cf_tl id="Status"></td>
	<td></td>
	<td><cf_tl id="Curr">.</td>
	<td align="right"><cf_tl id="Amount"></td>
	<td></td>
</tr>

<cfif Form.Amount gt "0">

	<cfquery name="ResultSet" dbtype="query">
		SELECT *
		FROM   ResultSet
		WHERE  TotalOrderAmount #Form.amountoperator# #Form.Amount#
	</cfquery>

</cfif>

<cfoutput query="ResultSet" group="PurchaseNo">
		
	<tr id="#currentrow#" class="navigation_row line labelmedium2 fixlengthlist" style="height:24px">
		
	<td style="height:16" width="5%" align="center">
		    	
			<img src="#SESSION.root#/Images/arrowright.gif" alt="Purchase lines" 
				id="#purchaseNo#Exp" border="0" class="regular" 
				align="middle" style="cursor: pointer;" 
				onClick="more('#purchaseNo#','show')">
						
			<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="#purchaseNo#Min" alt="Hide" border="0" 
				align="middle" class="hide" style="cursor: pointer;" 
				onClick="more('#purchaseNo#','hide')">
				
	</td>
	<td>#OrgUnitName#</td>
	<td>
	
		<a href="javascript:ProcPOEdit('#Purchaseno#','','tab')">	
		
		<cfif Parameter.PurchaseCustomField neq "">
			<cfif evaluate("ResultSet.Userdefined#Parameter.PurchaseCustomField#") neq "">#evaluate("ResultSet.Userdefined#Parameter.PurchaseCustomField#")#<cfelse>#PurchaseNo#</cfif>	
		<cfelse>
   		#PurchaseNo#
		</cfif>	
		
		</a>
		
	</td>
	
	<td>#OrderClassDescription#</td>
	<td>#OrderTypeDescription#</td>
	<td>#ActionDescription#&nbsp;<cfif ActionStatus eq "3">&nbsp;[<u>#DateFormat(OrderDate, CLIENT.DateFormatShow)#</u>]</cfif></td>
	<td></td>	
	<td>#currency#</td>
	<td align="right">#NumberFormat(TotalOrderAmount,",__.__")#</td>
	<td align="center">
	
	     <cf_img icon="add" navigation="yes" onClick="invoiceentry('#orgunitvendor#','#PurchaseNo#','#PersonNo#')">
		 			
	</td>
	</tr>
		
	<tr>
	<td bgcolor="white"></td>	
	<td colspan="8" class="hide" id="#purchaseno#"></td>
	
	</tr>
			
</cfoutput>

</table>

</cf_divscroll>

</td></tr>

</table>

