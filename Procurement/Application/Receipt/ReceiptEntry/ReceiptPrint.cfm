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
<cfquery name="GetHeader" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Receipt R
	WHERE  ReceiptNo = '#URL.ID1#'
</cfquery>

<cfquery name="GetCustom" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_CustomFields
</cfquery>

<cfquery name="GetPurchase" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  TOP 1 P.*
FROM    Receipt R INNER JOIN
        PurchaseLineReceipt PR ON R.ReceiptNo = PR.ReceiptNo INNER JOIN
        PurchaseLine PL ON PR.RequisitionNo = PL.RequisitionNo INNER JOIN
        Purchase P ON PL.PurchaseNo = P.PurchaseNo
WHERE R.ReceiptNo = '#URL.ID1#'		
</cfquery>

<cfquery name="GetVendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Organization
WHERE OrgUnit = '#GetPurchase.OrgUnitVendor#'
</cfquery>

<cfquery name="GetVendorAddress" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM vwOrganizationAddress
	WHERE OrgUnit = '#GetPurchase.OrgUnitVendor#'
	AND   AddressType = 'Mail'
</cfquery>

<cfquery name="GetLines" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PurchaseLineReceipt
	WHERE  ReceiptNo = '#URL.ID1#'
	AND    ActionStatus != '9'
	ORDER BY ReceiptItemNo
</cfquery>

<cfquery name="GetAddressTransport" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   PurchaseAddress
	WHERE  PurchaseNo = '#GetPurchase.PurchaseNo#'
	AND    AddressType = 'Transport'
</cfquery>

<cfquery name="GetApproval" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   DISTINCT OfficerLastName, OfficerFirstName, Created
	FROM     ReceiptAction
	WHERE    ReceiptId = '#GetLines.ReceiptId#'
	ORDER BY Created DESC
</cfquery>

<cfquery name="GetRequisition" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT O.OrgUnitName
	FROM      PurchaseLine L INNER JOIN
	          RequisitionLine R ON L.RequisitionNo = R.RequisitionNo INNER JOIN
	          Organization.dbo.Organization O ON R.OrgUnit = O.OrgUnit
	WHERE     L.PurchaseNo = '#GetPurchase.PurchaseNo#'
</cfquery>

<!---
<cfinclude template="../../../../Portal/Logon/BlueGreen/pkdb.css">
--->


<cfset td01   = "border-right:0.5px solid gray; border-bottom:0.5px solid gray">
<cfset td02   = "border-bottom:0.5px solid gray">
<cfset td03   = "border-right:0.5px solid gray">

<cfdocumentitem type="header">
 
  <cfoutput> 
	 
	 <table width="98%" align="center">
	  <tr class="labelit">
	    <td style="min-width:100px"><cf_reportlogo></td>
		<td align="right" style="font-size:45px;font-weight:bold"><h1><cf_tl id="RECEIVING AND INSPECTION REPORT"></h1></td>		
	 </tr>
	 <tr><td colspan="2" style="#td02#"></td></tr>	
	 </table>
 
  </cfoutput>
  
</cfdocumentitem>

<cfdocumentitem type="footer">
 
 <cfoutput>  
 		<table width="98%"> 	
				
            <tr class="labelmedium">
			<td style="font-size:25px;padding-left:20px">
			<h1><cf_tl id="Page"> #cfdocument.currentpagenumber# <cf_tl id="of"> #cfdocument.totalpagecount#</h1>
			</td>
			<td align="right" style="font-size:50px"> 
				<h1><cf_tl id="IMPORTANT: Mark all packages and papers with contract and/or order numbers"></h1>
			</td>
			</tr>
			
		</table>
  </cfoutput>
  
</cfdocumentitem>

<cfoutput>

<table width="96%" align="center">
<tr>
    <td width="50%" valign="top"  style="#td01#">
    <table width="100%" class="formpadding">
	   <tr>
        <td width="100%" height="20">
        <table width="100%">
          <tr class="labelit">
            <td width="36%"><cf_tl id="DATE OF RECEIPT">:</td>
            <td width="64%">
				<cfloop query="GetHeader">
				<cfif ReceiptDate eq ""><cf_tl id="DRAFT"><cfelse>#Dateformat(ReceiptDate, CLIENT.DateFormatShow)#</cfif>
				</cfloop></td>
          </tr>
        </table>
        </td>
      </tr>	  
	  
	  <cfif GetCustom.ReceiptReference1 neq "">
		  <tr><td style="#td02#"></td></tr>	 
	      <tr>
	        <td width="100%" height="20">
	        <table width="100%">
	          <tr class="labelit">
	            <td width="36%">
				#UCase(GetCustom.ReceiptReference1)#:</td>
	            <td width="64%">
				#GetHeader.ReceiptReference1#
				</td>
	          </tr>
	        </table>
	        </td>
	      </tr>	 
	  </cfif>
	  
	  <tr><td style="#td02#"></td></tr>	  
      <tr>
        <td width="100%" height="20">
        <table width="100%">
          <tr class="labelit">
            <td width="36%">
			<cfloop query="GetCustom"><cf_tl id="PACKINGSLIP NO">:</cfloop>
			</font></td>
            <td width="64%">
			<cfloop query="GetHeader">#PackingslipNo#</cfloop></td>
          </tr>
        </table>
        </td>
      </tr>	 
	  <tr><td style="#td02#"></td></tr>	  
      <tr>
        <td width="100%" valign="top">
		<table width="100%">
		<tr><td valign="top" ><cf_tl id="RECEIVED FROM">:</td></tr>		
		<tr class="labelit">  	  
		  <td style="padding-left:10px">  
				<table border="0" width="100%">
		          <tr>
				    <td width="5%">
		            <td width="95%"><cfloop query="GetVendor">#OrgUnitName#</cfloop></td>
		          </tr>
		          <tr>
		   		    <td width="5%">
		            <td width="95%"><cfloop query="GetVendorAddress">#Address1#</cfloop></td>
		          </tr>
		          <tr>
				    <td width="5%">
		            <td width="95%"><cfloop query="GetVendorAddress">#Address2#</cfloop></td>
		          </tr>
		          <tr>
				    <td width="5%">
		            <td width="95%"><cfloop query="GetVendorAddress">#City# #PostalCode#</cfloop>
					</b></td>
		          </tr>
		          <tr>
				    <td width="5%">
					<td width="95%"><cfloop query="GetVendorAddress">#TelephoneNo#</cfloop></td>
		          </tr>
		        </table>
           </td>
        </tr>
		
		</table>
		</td>
	  </tr>	
	 
	  <cfif GetCustom.ReceiptReference3 neq "">
	  
	      <tr><td style="#td02#"></td></tr>	 
	      <tr>
	        <td width="100%" height="20">
	        <table width="100%">
	          <tr class="labelit">
	            <td width="36%">
				#UCase(GetCustom.ReceiptReference3)#:</td>
	            <td width="64%">
				#GetHeader.ReceiptReference3#
				</td>
	          </tr>
	        </table>
	        </td>
	      </tr>	 
		  
	  </cfif>
	 
	  <tr><td style="#td02#"></td></tr>	 
      <tr>
        <td width="100%" height="20" valign="top">
        <table width="100%" height="21">
          <tr class="labelit">
            <td width="36%" valign="top" height="21"><cf_tl id="PLACE OF INSPECTION">:</td>
            <td width="64%" height="21">
			 
				<table width="100%">
		        
		          <tr class="labelit">
		   		    <td width="5%" height="16">
		            <td width="95%" height="16">
					<cfloop query="GetAddressTransport">#Address1# #Address2#</cfloop></td>
		          </tr>
		          <tr class="labelit">
				    <td width="5%" height="16">
		            <td width="95%" height="16">
					<cfloop query="GetAddressTransport">#City# #PostalCode#</cfloop></td>
		          </tr>
		          <tr class="labelit">
				    <td width="5%" height="29">
		            <td width="95%" height="29">
					<cfloop query="GetAddressTransport">#TelephoneNo#</cfloop></td>
		          </tr>
		        </table>
           </td>
			
          </tr>
        </table>
        </td>
      </tr>	 
	 
    </table>
    </td>

    <td width="50%" valign="top" style="#td02#">
     		
    <table width="100%">
	
	   <tr>
        <td width="100%" height="20">
        <table width="100%">
          <tr class="labelit">
            <td width="50%"><cf_tl id="DOCUMENT No">:</td>
            <td width="50%">
			<cfloop query="GetPurchase">#URL.ID1#</cfloop></td>
          </tr>
        </table>
        </td>
      </tr>
	  
	  <tr><td style="#td02#"></td></tr>
	  	  
	   <tr>
        <td width="100%" height="20">
        <table width="100%">
          <tr class="labelit">
            <td width="50%"><cf_tl id="ORDER NO">:</td>
            <td width="50%"><cfloop query="GetPurchase">#PurchaseNo#</cfloop></td>
          </tr>
        </table>
        </td>
      </tr>
	  
	  <cfif GetCustom.ReceiptReference2 neq "">
	  
	      <tr><td style="#td02#"></td></tr>	 
	      <tr>
	        <td width="100%" height="20">
	        <table width="100%">
	          <tr class="labelit">
	            <td width="36%">
				#UCase(GetCustom.ReceiptReference2)#:</td>
	            <td width="64%">
				#GetHeader.ReceiptReference2#
				</td>
	          </tr>
	        </table>
	        </td>
	      </tr>	 
		  
	  </cfif>
	 	  
	  <tr><td style="#td02#"></td></tr>
	  
	  <tr>
        <td width="100%" valign="top">
        <table width="100%">
          <tr class="labelit">
            <td width="50%" valign="top"><cf_tl id="REQUISITIONER(S)">:</td>
            <td width="50%" valign="top">
				<table width="100%" cellspacing="0" cellpadding="0">
				<cfloop query="GetRequisition">
				<tr><td valign="top">#OrgUnitName#</td></tr>
				</cfloop>
				</table> 
			</td>
          </tr>
        </table>
        </td>
      </tr>
	  
	  <tr><td style="#td02#"></td></tr>
	  
      <tr>
        <td width="100%" valign="top">
        <table border="0" width="100%" height="22">
          <tr class="labelit">
            <td width="50%" valign="top" height="22">
            <cf_tl id="OFFICER">:</td>
            <td width="50%" height="22"><cfloop query="GetHeader">#OfficerFirstName# #OfficerLastName#</cfloop></td>
          </tr>
        </table>
        </td>
      </tr>
	  
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
      <tr>
        <td width="100%" valign="top">
        <table border="0" width="100%" height="22">
          <tr class="labelit">
            <td width="50%" valign="top" height="22"><cf_tl id="REMARKS">:</td>
            <td width="50%" height="22"><cfoutput query="GetHeader">#ReceiptRemarks#</cfoutput></td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    </td>
</tr>
  
<TR>

<td colspan="2" style="padding-top:4px">

	   <table width="96%" cellspacing="2" border="0">
	   
		<tr class="line labelit">
	      <td height="20"><cf_tl id="No"></td>
	      <TD><cf_tl id="Item or service"></TD>
		  <TD><cf_tl id="ItemNo"></TD>
	      <TD align="right"><cf_tl id="Quantity"></TD>
	      <TD align="right"><cf_tl id="Unit"></TD>
		  <TD align="center"><cf_tl id="Curr"></TD>
	      <TD align="right"><cf_tl id="Unit Price"></TD>
		  <TD align="right"><cf_tl id="Amount"></TD>		  
	    </tr>
		
	    <cfset subtotal = "0">
	    <cfset tax      = "0">
	    <cfset total    = "0">
	    <cfset currOrd  = "USD">
						
	    <CFOUTPUT query="GetLines">
		    <cfset total     = total + ReceiptAmount>
		    <cfset tax       = tax + ReceiptAmountTax>
			<cfset subtotal  = subtotal + ReceiptAmountCost>
			<cfset currOrd   = Currency>
		   	
		    <TR class="labelit">
		    <td align="right" style="padding-right:10px">#CurrentRow#</td>
		    <td>#ReceiptItem#</td>
			<td>#ReceiptItemNo#</td>
		    <TD style="text-align:right">#NumberFormat(ReceiptQuantity,'._')#</font></TD>
		    <td style="text-align:right">#ReceiptUoM#</td>
		    <td style="text-align:center">#Currency#</td>
		    <td style="text-align:right">#NumberFormat(ReceiptAmountCost/ReceiptQuantity,'.__')#</font></td>
		    <td style="text-align:right;padding-left:10px">#NumberFormat(ReceiptAmountCost,',.__')#</td>
			<Td style="width:10px"></TD>
		    </TR>
			<cfif Remarks neq "">
			<tr class="line"><td colspan="9">#Remarks#</td></tr>
			</cfif>		
	    </CFOUTPUT>		
		
		</table>
		
	</td>
</TR>

<cfoutput>

  <tr>
   
     <td width="55%" valign="top" style="#td01#">		
		
		<table width="100%">
		<tr>		
		 	  
		  <td valign="top">  
	  
		 	 <table width="100%">
	  		 <tr>
		    	<td colspan="2" valign="top">  
		  		<cf_tl id="I CERTIFY THAT ALL ITEMS, EXCEPT WHERE NOTED, LISTED WERE INSPECTED AND ACCEPTED">
                </td>
             </tr>			 
			 <tr><td><cf_tl id="NAME">:</td>
		          <td style="height:50px"><cfloop query="GetApproval">#OfficerFirstName# #OfficerLastName#</cfloop></td>
			 </TR> 		
			 	 
			 <tr><td><cf_tl id="DATE">:</td>
		         <td style="height:30px"><cfloop query="GetApproval">#Dateformat(Created, CLIENT.DateFormatShow)#</cfloop></td>
			 </TR> 
			 </TABLE>
			 
		  </TD>
		  </TR>	 
		</table>
				
	</td>

    <td style="#td02#" valign="top" align="right" style="padding-right:10px">	
		<table style="width:100%" class="formpadding">
		  <tr class="line"><td colspan="2"><cf_tl id="GRAND TOTALS IN">#CurrOrd#</td>
		  </tr> 
	      <tr class="labelmedium">
	        <td><cf_tl id="SUBTOTAL"></td>
	        <td align="right">#NumberFormat(subtotal,',.__')#</td>
	      </tr>	  
	      <tr>
	        <td><cf_tl id="TAX"></td>
	        <td align="right">#NumberFormat(tax,',.__')#</td>
	      </tr>	  
	      <tr>
	        <td><cf_tl id="TOTAL"></td>
	        <td align="right">#NumberFormat(total,',.__')#</td>
	      </tr>
	    </table>
    </td>
  </tr> 
  
  </table>
  
</cfoutput>  
