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
		  
<cf_DialogProcurement>
<cf_dialogOrganization>

<cfparam name="URL.Id" default="#URL.Id#">
<cfparam name="URL.Mode" default="Receipt">
  
<cfoutput>

<script language="JavaScript">

	function mail()	{
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  ptoken.open("#SESSION.root#/Tools/Mail/MailPrepare.cfm?Id=Mail&ID1=#Receipt.ReceiptNo#&ID0=Procurement/Application/Receipt/ReceiptEntry/ReceiptPrint.cfm","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
  	}
		
	function print() {
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  ptoken.open("#SESSION.root#/Tools/Mail/MailPrepare.cfm?Id=Print&ID1=#Receipt.ReceiptNo#&ID0=Procurement/Application/Receipt/ReceiptEntry/ReceiptPrint.cfm","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
  	} 

</script>

</cfoutput>

<cfquery name="Rollback" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT DISTINCT PurchaseNo
 FROM   PurchaseLine PL,
		PurchaseLineReceipt PR
 WHERE  PL.RequisitionNo = PR.RequisitionNo
 AND    PR.ReceiptId = '#URL.Id#'
</cfquery>	
			  
<cfquery name="PO" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT P.*, 
        R.InvoiceWorkflow AS ParameterInvoiceWorkflow, 
		R.EnableFinanceFlow AS ParameterEnabledFinanceFlow, 
		R.Tracking AS ParameterTracking, 
        R.ReceiptEntry AS ParameterReceiptEntry,
		R.Description as OrderTypeDescription,
		Org.OrgUnitName
 FROM   Purchase P, 
        Ref_OrderType R, 
		Organization.dbo.Organization Org
 WHERE  P.OrderType = R.Code
 AND    P.PurchaseNo = '#Rollback.PurchaseNo#'
 AND    P.OrgUnitVendor = Org.OrgUnit
</cfquery>

 <cfquery name="CustomFields" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_CustomFields
	WHERE HostSerialNo = '#CLIENT.HostNo#'
</cfquery>
   
<cfoutput>
 <table width="100%" border="0">
 
 <tr><td height="24">
  
	  <table width="98%" align="center" class="formpadding">
	   <tr>
	   
	    <td height="24" class="labellarge">
				
		<cf_tl id="Record an receipt of an asset item">
		</td>	  
		<td align="right">
		 
		 <cfoutput>
		 
		  <table><tr><td>
       			 
		<a onClick="javascript:mail()" style="cursor: pointer;"><img src="#SESSION.root#/Images/mail.png"
	     alt="eMail Routing Slip Invoicing Procedures" border="0" style="width:36px;" align="absmiddle"><span>Email Receipt</span></a></td>
		<td style="padding-left:10px;padding-right:8px"> 
	    
		<a onclick="avascript:print()" style="cursor: pointer;"><img src="#SESSION.root#/Images/print_gray.png" style="width:36px;" alt="Print" border="0" align="absmiddle"><span>Print Receipt</span></a>		
		 
		 </td></tr>
		</table>			
		 
		 <!---
			   &nbsp;|&nbsp;
			   <button onClick="javascript:mail()" class="button3">
			     <img src="#SESSION.root#/images/mail_new.gif" alt="Mail" border="0" align="top">
			   </button>&nbsp;|&nbsp;
			   <button onClick="javascript:print()" class="button3">
			     <img src="#SESSION.root#/images/print.gif" alt="Print" border="0">
			   </button>
			   &nbsp;|&nbsp;
			   
			   --->
				   
		 </cfoutput>		   
		 
	     </td>
		 	 
	   </tr>
	  </table>
 </td></tr>
   
 <tr><td style="padding:10px">
 
  <table width="95%" align="center" class="formpadding"> 
  <tr class="labelmedium2">
    <td width="200"><cf_tl id="Purchase No">:</td>
	<td><a href="javascript:ProcPOEdit('#PO.PurchaseNo#','view')">#PO.PurchaseNo#</a></td>
	<td width="150"><cf_tl id="Ordertype">:</td>
	<td>#PO.OrderTypeDescription#</td>
  </tr>	
  <tr class="labelmedium2">
    <td width="200"><cf_tl id="Vendor">:</td>
	<td><a href="javascript:viewOrgUnit('#PO.OrgUnitVendor#')">#PO.OrgUnitName#</a></td>
  </tr>	
  <tr class="labelmedium2">
    <td width="200"><cf_tl id="Order date">:</td>
	<td>#DateFormat(PO.OrderDate,CLIENT.DateFormatShow)#</td>
  </tr>	
   
  <tr><td class="linedotted" colspan="4"></td></tr>
	  	  
	  <tr class="labelmedium2">
	    <td width="200"><cf_tl id="Packingslip No">:</td>
		<td><cfif Receipt.PackingslipNo eq "">n/a<cfelse>#Receipt.PackingslipNo#</cfif>
			
		<td><cf_tl id="Receipt date">:</td>
		<td>#Dateformat(Receipt.ReceiptDate, CLIENT.DateFormatShow)#
	  </tr>
	  
	  <cfif Receipt.ReceiptReference1 neq "" and Receipt.ReceiptReference2 neq "">
	  
	  <tr class="labelmedium2">
		<td>#CustomFields.ReceiptReference1#:</td>
		<td>#Receipt.ReceiptReference1#</td>
		
	  	<td>#CustomFields.ReceiptReference2#:</td>
		<td>#Receipt.ReceiptReference2#
	
	  </tr>	
	  
	  </cfif>
	  
	  <cfif Receipt.ReceiptReference3 neq "" and Receipt.ReceiptReference4 neq "">
	 	  
	  <tr class="labelmedium2">	
		<td>#CustomFields.ReceiptReference3#:</td>
		<td>#Receipt.ReceiptReference3#
	 	<td>#CustomFields.ReceiptReference4#:</td>
		<td>#Receipt.ReceiptReference4#</td>
	  </tr>
	  
	  <tr><td height="1" colspan="4" class="linedotted"></td></tr>
	  
	  </cfif>
	   
	   <tr class="labelmedium2">	
		<td><cf_tl id="Item">:</td>
		<td style="width:300">#Receipt.ReceiptItem#
	 	<td><cf_tl id="Quantity">:</td>
		<td>#Receipt.ReceiptQuantity#</td>
	  </tr>
	  
	  <tr class="labelmedium2">	
		<td><cf_tl id="Unit price in #APPLICATION.BaseCurrency#">:</td>
		<td><cfset amount = round((Receipt.ReceiptAmountBaseCost/Receipt.ReceiptQuantity) * 100)>
			<cfset amount = amount/100>
			#numberformat(amount,",.__")#
	 	<td><cf_tl id="Tax">:</td>
		<td>
		<cfset amount = round((Receipt.ReceiptAmountBaseTax/Receipt.ReceiptQuantity) * 100)>
		<cfset amount = amount/100>
		#numberformat(amount,",.__")#</td>
	  </tr> 
	  <cfif Receipt.ReceiptRemarks neq "">
	   <tr class="labelmedium2">	
		<td ><cf_tl id="Remarks">:</td>
		<td colspan="3">#Receipt.ReceiptRemarks#</td>
	  </tr>
	  </cfif>
	  
	   <tr><td colspan="4" class="linedotted"></td></tr>
	  	  
	   <tr class="labelmedium2">	
		<td ><cf_tl id="Officer">:</td>
		<td colspan="1">#Receipt.OfficerFirstName# #Receipt.OfficerLastName#</td>
		<td ><cf_tl id="Registered on">:</td>
		<td >#DateFormat(Receipt.Created, CLIENT.DateFormatShow)#</td>	 	
	  </tr>
  	  </table>
	  </td></tr>
	  
	 </cfoutput>
