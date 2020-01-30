		  
<cfquery name="GetHeader" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Receipt R
WHERE ReceiptNo = '#URL.ID1#'
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


<cfquery name="GetAddressTransport" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM PurchaseAddress
WHERE PurchaseNo = '#GetPurchase.PurchaseNo#'
AND   AddressType = 'Transport'
</cfquery>

<cfquery name="GetLines" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM PurchaseLineReceipt
WHERE ReceiptNo = '#URL.ID1#'
</cfquery>

<cfquery name="GetApproval" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT OfficerLastName, OfficerFirstName, Created
FROM ReceiptAction
WHERE ReceiptId = '#GetLines.ReceiptId#'
ORDER BY Created DESC
</cfquery>

<cfquery name="GetRequisition" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT O.OrgUnitName
FROM      PurchaseLine L INNER JOIN
          RequisitionLine R ON L.RequisitionNo = R.RequisitionNo INNER JOIN
          Organization.dbo.Organization O ON R.OrgUnit = O.OrgUnit
WHERE     L.PurchaseNo = '#GetPurchase.PurchaseNo#'
</cfquery>

<cfset table0 = "border:0px solid b0b0b0">
<cfset table1 = "border:1px solid b0b0b0" >
<cfset td01 = "border-right:1px solid b0b0b0; border-bottom:1px solid b0b0b0">
<cfset td02 = "border-bottom:1px solid b0b0b0">
<cfset td03 = "border-right:1px solid b0b0b0">
<cfset data10 = "font-family:Verdana;font-size:10pt;font-weight:Bold">
<cfset data08 = "font-family:Verdana;font-size:8pt">

<cfdocumentitem type="header">
 <cfoutput> 
 <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="gray" rules="cols">
  <tr>
    <td  colspan="2" align="center" valign="middle"><cf_reportlogo></td>
 </tr>
  <tr>
    <td  colspan="2" align="center"  height="6px"></td>
 </tr> 
 <tr>
    <td colspan="2" align="center" valign="middle">
    <b></b><font size="4" face="verdana"><cf_tl id="RECEIVING AND INSPECTION REPORT"></font></b>
    </td>
 </tr>
 <tr>
    <td width="100%" class="top3n" height="26" colspan="2" align="center" valign="middle"> 
	<font face="verdana" size="1">
	<cf_tl id="IMPORTANT: Mark all packages and papers with contract and/or order numbers"></font></b></td>
 </tr>
 </table>
 
  </cfoutput>
</cfdocumentitem>

<cfdocumentitem type="footer">
 <cfoutput> <table width="100%">
            <tr><td align="center">
			<font size="1" face="verdana"><cf_tl id="Page"> #cfdocument.currentpagenumber# <cf_tl id="or"> #cfdocument.totalpagecount# </font>
			</td></tr>
			</table>
  </cfoutput>
</cfdocumentitem>

<cfoutput>
<table width="98%" style="#table1#" cellspacing="0" cellpadding="0" align="center" bordercolor="gray" rules="cols">
<tr>
    <td width="50%" valign="top"  style="#td01#">
</cfoutput>	
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	   <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td width="36%" valign="absmiddle"><font size="1" face="verdana"><cf_tl id="DATE OF RECEIPT">:</td>
            <td width="64%" valign="absmiddle"><font size="2" face="verdana">
				<cfoutput query="GetHeader">
				<cfif ReceiptDate eq ""><cf_tl id="DRAFT"><cfelse>#Dateformat(ReceiptDate, CLIENT.DateFormatShow)#</cfif>
				</cfoutput> 
                  </font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
      <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#C0C0C0" frame="hsides" rules="rows" width="100%">
          <tr>
            <td width="36%"><font face="verdana" size="1">
			<cfoutput query="GetCustom">#UCase(ReceiptReference1)#:</cfoutput>
			</font></td>
            <td width="64%"><font face="verdana" size="2">
			<cfoutput query="GetHeader">#ReceiptReference1#</cfoutput>
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
      <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
          <tr>
            <td width="36%"><font face="verdana" size="1">
			<cfoutput query="GetCustom"><cf_tl id="PACKINGSLIP NO">:</cfoutput>
			</font></td>
            <td width="64%"><font face="verdana" size="2">
			<cfoutput query="GetHeader">#PackingslipNo#</cfoutput>
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
      <tr>
        <td width="100%" height="79" valign="top">
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
		
		  <td width="26%" valign="top"><font face="verdana" size="1"><cf_tl id="RECEIVED FROM">:</td>
		  
		  <td width="74%">  
				<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
		          <tr>
				    <td width="5%" height="16">
		            <td width="95%" height="16"><font face="verdana" size="2">
					<cfoutput query="GetVendor">#OrgUnitName#</cfoutput>
					</font></b></td>
		          </tr>
		          <tr>
		   		    <td width="5%" height="16">
		            <td width="95%" height="16"><font face="verdana" size="2">
					<cfoutput query="GetVendorAddress">#Address1#</cfoutput>
					</font></b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="16">
		            <td width="95%" height="16"><font face="verdana" size="2">
					<cfoutput query="GetVendorAddress">#Address2#</cfoutput>
					</font></b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="16">
		            <td width="95%" height="16"><font face="verdana" size="2">
					<cfoutput query="GetVendorAddress">#City# #PostalCode#</cfoutput>
					</b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="29">
		            <td width="95%" height="29"><font face="verdana" size="2">
					<cfoutput query="GetVendorAddress">#TelephoneNo#</cfoutput>
					</font></b></td>
		          </tr>
		        </table>
           </td>
        </tr>
		</table>
		</td>
	  </tr>	
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
      <tr>
        <td width="100%" height="22" valign="top">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
          <tr>
            <td width="36%"><font face="verdana" size="1">
			<cfoutput query="GetCustom">#UCase(ReceiptReference3)#:</cfoutput>
			</font></td>
            <td width="64%"><font face="verdana" size="2">
			<cfoutput query="GetHeader">#ReceiptReference3#</cfoutput>
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>	  
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
      <tr>
        <td width="100%" height="20" valign="top">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="21">
          <tr>
            <td width="36%" valign="top" height="21"><font face="verdana" size="1"><cf_tl id="PLACE OF INSPECTION">:</font></td>
            <td width="64%" height="21"><font face="verdana" size="2">
			 
				<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
		        
		          <tr>
		   		    <td width="5%" height="16">
		            <td width="95%" height="16"><font face="verdana" size="2">
					<cfoutput query="GetAddressTransport">#Address1# #Address2#</cfoutput>
					</font></b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="16">
		            <td width="95%" height="16"><font face="verdana" size="2">
					<cfoutput query="GetAddressTransport">#City# #PostalCode#</cfoutput>
					</b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="29">
		            <td width="95%" height="29"><font face="verdana" size="2">
					<cfoutput query="GetAddressTransport">#TelephoneNo#</cfoutput>
					</font></b></td>
		          </tr>
		        </table>
           </td>
			
          </tr>
        </table>
        </td>
      </tr>	 
	 
      
    </table>
    </td>
<cfoutput>
    <td width="50%" height="304" valign="top" style="#td02#">
</cfoutput>      		
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding" style="border-collapse: collapse">
	
	   <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td width="50%"><font size="1" face="verdana"><cf_tl id="DOCUMENT No">:</font></td>
            <td width="50%"><font face="verdana" size="2">
			<cfoutput query="GetPurchase">#URL.ID1#</cfoutput>
			
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
	  
	   <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td width="50%"><font size="1" face="verdana"><cf_tl id="ORDER NO">:</font></td>
            <td width="50%"><font face="verdana" size="2">
			<cfoutput query="GetPurchase">#PurchaseNo#</cfoutput>
			
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
	  
      <tr>
        <td width="100%" height="22" valign="top">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
          <tr>
            <td width="36%"><font face="verdana" size="1">
			<cfoutput query="GetCustom">#UCase(ReceiptReference3)#:</cfoutput>
			</font></td>
            <td width="64%"><font face="verdana" size="2">
			<cfoutput query="GetHeader">#ReceiptReference3#</cfoutput>
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	  
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
      <tr>
        <td width="100%" height="28" valign="top">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="24">
          <tr>
            <td width="50%" valign="top" height="24"><font face="verdana" size="1">
            <cf_tl id="REQUISITIONER(S)">:</font></td>
            <td width="50%" height="24">
			<table width="100%">
			<cfoutput query="GetRequisition">
			<tr><td>
            <font size="2" face="verdana">#OrgUnitName#</font>
			</td></tr>
			</cfoutput>
			</table> 
			</b></td>
          </tr>
        </table>
        </td>
      </tr>
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
      <tr>
        <td width="100%" height="15" valign="top">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="22">
          <tr>
            <td width="50%" valign="top" height="22">
            <font face="verdana" size="1"><cf_tl id="OFFICER">:</font></td>
            <td width="50%" height="22"><font face="verdana" size="2">
			<cfoutput query="GetHeader">#OfficerFirstName# #OfficerLastName#</cfoutput>
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	  <cfoutput>
	  	<tr><td style="#td02#"></td></tr>
	  </cfoutput>
      <tr>
        <td width="100%" height="15" valign="top">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="22">
          <tr>
            <td width="50%" valign="top" height="22">
            <font face="verdana" size="1"><cf_tl id="REMARKS">:</font></td>
            <td width="50%" height="22"><font face="verdana" size="2">
			<cfoutput query="GetHeader">#ReceiptRemarks#</cfoutput>
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    </td>
  </tr>

  
<TR>

<td height="450" colspan="2" valign="top">

    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr bgcolor="d2d2d2">
      <td height="20"><font face="verdana" size="1">&nbsp;<cf_tl id="No"></font></td>
      <TD><font face="verdana" size="1"><cf_tl id="Item or service"></font></TD>
	  <TD><font face="verdana" size="1"><cf_tl id="ItemNo"></font></TD>
      <TD align="right"><font face="verdana" size="1"><cf_tl id="Quantity"></font></TD>
      <TD align="right"><font face="verdana" size="1"><cf_tl id="Unit"></font></TD>
	  <TD align="center"><font face="verdana" size="1"><cf_tl id="Curr"></font></TD>
      <TD align="right"><font face="verdana" size="1"><cf_tl id="Unit Price"></font></TD>
	  <TD align="right"><font face="verdana" size="1"><cf_tl id="Amount">&nbsp;</font></TD>
	  <Td>&nbsp;</TD>
    </TR>
	<tr><td colspan="9" bgcolor="gray"></td></tr>
    <cfset subtotal = "0">
    <cfset tax      = "0">
    <cfset total    = "0">
    <cfset currOrd  = "USD">
			
    <CFOUTPUT query="GetLines">
	    <cfset total     = #total# + #ReceiptAmount#>
	    <cfset tax       = #tax# + #ReceiptAmountTax#>
		<cfset subtotal  = #subtotal# + #ReceiptAmountCost#>
		<cfset currOrd   = #Currency#>
	   	
	    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f4f4f4'))#">
	    <td height="25" align="left"><font face="verdana" size="1">&nbsp;#CurrentRow#</A></font></td>
	    <td align="left"><font face="verdana" size="1">#ReceiptItem#</font></td>
		<td align="left"><font face="verdana" size="1">#ReceiptItemNo#</font></td>
	    <TD align="right"><font face="verdana" size="1">#NumberFormat(ReceiptQuantity,'______._')#</font></TD>
	    <td align="right"><font face="verdana" size="1">#ReceiptUoM#</font></td>
	    <td align="center"><font face="verdana" size="1">#Currency#</font></td>
	    <td align="right"><font face="verdana" size="1">#NumberFormat(ReceiptAmountCost/ReceiptQuantity,'_____.__')#</font></td>
	    <td align="right"><font face="verdana" size="1">#NumberFormat(ReceiptAmountCost,'__,____.__')#</font></td>
		<td>&nbsp;</td>
	    </TR>
		<cfif #Remarks# neq "">
		<tr><td colspan="9">#Remarks#</td></tr>
		</cfif>
		<tr><td colspan="9" class="line"></td></tr>
    </CFOUTPUT>
		
	</table>
	</td>
</TR>

</table>
<br>
<cfoutput>
<table width="98%" style="#table1#" cellspacing="0" cellpadding="0" align="center" bordercolor="C0C0C0">
  <tr>
    <td width="55%" height="58" valign="top" style="#td01#">
		
		<table width="100%" cellpadding="0" cellspacing="0" class="formpadding">
		<tr>
		
		  <td width="26%" valign="top"><font face="verdana" size="1"><cf_tl id="CERTIFICATION OF RECEIPT">:</td>
		  
		  <td width="74%">  
</cfoutput>		  
		 	 <table width="100%" cellpadding="0" cellspacing="0" class="formpadding">
	  		 <tr>
		    	<td width="100%" colspan="2">  
		  		<cf_tl id="I CERTIFY THAT ALL ITEMS, EXCEPT WHERE NOTED, LISTED WERE INSPECTED AND ACCEPTED">
                </td>
             </tr>
			 <TR><td colspan="2" bgcolor="E5E5E5"></td></TR>
			 <tr><td colspan="1"><font face="verdana" size="1"><cf_tl id="NAME">:</font></td>
		          <td height="21">
					<font size="2" face="verdana">
					<cfoutput query="GetApproval">#OfficerFirstName# #OfficerLastName# 
					</td>
			 </TR> 
			  <TR><td colspan="2" bgcolor="E5E5E5"></td></TR>
			 <tr><td colspan="1"><font face="verdana" size="1"><cf_tl id="DATE">:</font></td>
		          <td height="21">
				    <font size="2" face="verdana"> 
					 #Dateformat(Created, CLIENT.DateFormatShow)#</cfoutput>
					</font></b>
					</td>
			 </TR> 
			 </TABLE>
		  </TD>
		  </TR>	 
		</table>
				
	</td>
<cfoutput>
    <td bgcolor="f4f4f4" style="#td02#">
</cfoutput>	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="formpadding">
	  <tr><td colspan="2"><font face="verdana" size="1"><cf_tl id="GRAND TOTALS IN"> <cfoutput>#CurrOrd#</cfoutput></font></td>
	  </tr> 
      <tr>
        <td height="21">
        <b><font size="1" face="verdana">&nbsp;<cf_tl id="SUBTOTAL"></font></b>
		</td>
        <td width="50%" align="right">
		<cfoutput><font size="1" face="verdana">#NumberFormat(subtotal,'___,___.__')#</b></font></cfoutput>
		</td>
      </tr>
	  <TR><td colspan="2" bgcolor="E5E5E5"></td></TR>
      <tr>
        <td height="21"><font size="1" face="verdana">&nbsp;<cf_tl id="TAX"></font></b>
		</td>
        <td width="50%" align="right">
		<cfoutput><font size="1" face="verdana">#NumberFormat(tax,'__,____.__')#</font></cfoutput>
       </td>
      </tr>
	  <TR><td colspan="2" bgcolor="E5E5E5"></td></TR>
      <tr>
        <td height="21"><font size="1" face="verdana">&nbsp;<cf_tl id="TOTAL"></font></b></td>
        <td width="50%" align="right">
	    <cfoutput><font size="1" face="verdana">#NumberFormat(total,'_,_____.__')#</font></b></cfoutput>
		</td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
<cfoutput>  
    <td width="55%" height="59" valign="top" style="#td03#">
</cfoutput>	
	<!---
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
	  <tr><td colspan="1"><font face="verdana" size="1">NAME:</font></td></tr> 
      <tr>
        <td height="21" align="center">
		
		<font size="2" face="verdana">
		<cfoutput query="GetApproval">#OfficerFirstName# #OfficerLastName# 
		<br>
		( #Dateformat(Created, CLIENT.DateFormatShow)# )</cfoutput>
		</font></b>
		</td>
     </table>
	 --->
	
	</td>
    <td width="45%" height="59" valign="top">
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
	  <tr><td colspan="1"><font face="verdana" size="1"><cf_tl id="PROPERTY RECORDS">:</font></td></tr> 
      <tr>
        <td height="21" align="center">
		<!---
		<font size="2" face="verdana">
		<cfoutput query="GetApproval">#OfficerFirstName# #OfficerLastName# 
		<br> ( #Dateformat(Created, CLIENT.DateFormatShow)# )</cfoutput>
		</font></b>
		--->
		</td>
     </table>
	
	</td>
	
  </tr>
  </table>
