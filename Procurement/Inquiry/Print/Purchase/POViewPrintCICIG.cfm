		  
<cfquery name="GetHeader" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT P.*, R.Description as ConditionText
FROM Purchase P, Ref_Condition R
WHERE PurchaseNo = '#URL.ID1#'
AND P.Condition = R.Code
</cfquery>

<cfquery name="Buyer" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Organization
WHERE OrgUnit = '#GetHeader.OrgUnit#'
</cfquery>

<cfquery name="BuyerAddress" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM vwOrganizationAddress
WHERE OrgUnit = '#GetHeader.OrgUnit#'
AND   AddressType = 'Office'
</cfquery>

<cfquery name="GetCustom" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_CustomFields
</cfquery>

<cfquery name="Vendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Organization
WHERE OrgUnit = '#GetHeader.OrgUnitVendor#'
</cfquery>

<cfquery name="VendorAddress" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM vwOrganizationAddress
WHERE OrgUnit = '#GetHeader.OrgUnitVendor#'
AND   AddressType = 'Mail'
</cfquery>

<cfquery name="AddressInvoice" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM PurchaseAddress
WHERE PurchaseNo = '#URL.ID1#'
AND   AddressType = 'Invoice'
</cfquery>

<cfquery name="AddressShipping" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM PurchaseAddress
WHERE PurchaseNo = '#URL.ID1#'
AND   AddressType = 'Shipping'
</cfquery>

<cfquery name="GetAddressTransport" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM PurchaseAddress
	WHERE PurchaseNo = '#URL.ID1#'
	AND   AddressType = 'Transport'
</cfquery>

<cfquery name="PurchaseLines" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM PurchaseLine
	WHERE PurchaseNo = '#URL.ID1#'
</cfquery>

<cfquery name="GetFunding" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  F.PurchaseNo, PF.ProgramCode, PF.ProgramName, F.Fund, F.ObjectCode, O.Description, F.Amount
	FROM    PurchaseFunding F INNER JOIN
	        Program.dbo.Program PF ON F.ProgramCode = PF.ProgramCode INNER JOIN
	        Program.dbo.Ref_Object O ON F.ObjectCode = O.Code
	WHERE   F.PurchaseNO = '#URL.ID1#' 
</cfquery>

<cfquery name="GetClause" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM PurchaseClause
	WHERE PurchaseNo = '#URL.ID1#'
</cfquery>

<cfquery name="GetFunds" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM PurchaseAction
	WHERE PurchaseNo = '#URL.ID1#'
	AND ActionStatus = '2'
	ORDER BY Created DESC
</cfquery>

<cfquery name="GetApproval" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM PurchaseAction
	WHERE PurchaseNo = '#URL.ID1#'
	AND ActionStatus = '3'
	ORDER BY Created DESC
</cfquery>

<cfquery name="GetRequisition" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT O.OrgUnitName, O.Mission
FROM      PurchaseLine L INNER JOIN
          RequisitionLine R ON L.RequisitionNo = R.RequisitionNo INNER JOIN
          Organization.dbo.Organization O ON R.OrgUnit = O.OrgUnit
WHERE     L.PurchaseNo = '#URL.ID1#'
</cfquery>

 
<cfdocumentitem type="footer">
<cfoutput> 
	<table width="100%">
	    <tr><td align="center">
		<font size="1">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount# 
		</td></tr>
	</table>
</cfoutput>
</cfdocumentitem>

<cfdocumentSection marginTop="2.5" marginBottom="2">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfdocumentitem type="header"  evalAtPrint="true"> 
	 <cfoutput> 
	 <table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="gray" class="formpadding">
	 <tr>
	 	<td align="center" valign="center" width="70%">COMISION INTERNATICIONAL CONTRA LA IMPUNIDAD EN GUATEMALA</TD>
		<TD>AVISO IMPORTANTE<BR>
			Toda correspondencia, factura y embarque debe mostrar este numero</TD>
	 </tr>	
	 <tr>
	 	<td align="center">ORDEN DE COMPRA</td>
		<td>No. #GetHeader.PurchaseNo#</td>
	 </tr>
	 </table>
	 </cfoutput>
 </cfdocumentitem> 


<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" rules="cols">
<tr><td>
    <table width="100%" border="1" cellspacing="0" cellpadding="0" class="formpadding">
	   <tr><td width="40%">
	   
	   		<cfoutput>
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				<tr><td width="30%" valign="top">COMPRADOR:</TD>
				<td>COMISION INTERNACIONAL CONTRA LA IMPUNIDAD EN GUATEMALA</td></tr>
				<TR><TD>OFICINA:</TD>
					<td>#Buyer.OrgUnitName#</td>
				</TR>
				<TR><td valign="top">DIRECCION:</td>
			  		<td>#BuyerAddress.Address1#
						<cfif #BuyerAddress.Address2# neq "">
							<br>
							#BuyerAddress.Address2#
						</cfif>
						<br>
						#BuyerAddress.City# #BuyerAddress.PostalCode#
					</td>
				</tr>
				<TR><TD>TELEFONO:</TD>
					<td>#BuyerAddress.TelephoneNo#</td>
				</TR>
				<TR><TD>CONTACTO:</TD>
					<td>#BuyerAddress.Contact#</td>
				</TR>
   			</table>
			</cfoutput>
			</TD>
			<TD valign="top">
			<cfoutput>
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				<tr><td colspan="2">LUGAR DE ENTREGADA DE LOS BIENES:</TD>
				</tr>
				<tr><td></td></tr>
				<TR><td width="20%" valign="top">DIRECCION:</td>
			  		<td>#AddressShipping.Address1#
						<cfif #AddressShipping.Address2# neq "">
							<br>
							#AddressShipping.Address2#
						</cfif>
						<br>
						#AddressShipping.City# #AddressShipping.PostalCode#
					</td>
				</tr>
   			</table>
			</cfoutput>
			</TD>
		</tr>
			
	   <tr><td>
	   		<cfoutput>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				<TR><TD WIDTH="30%">VENDOR:</TD>
					<td>#Vendor.OrgUnitName#</td>
				</TR>
				<TR><td valign="top">DIRECCION:</td>
			  		<td>#VendorAddress.Address1#
						<cfif #VendorAddress.Address2# neq "">
							<br>
							#VendorAddress.Address2#
						</cfif>
						<br>
						#VendorAddress.City# #VendorAddress.PostalCode#
					</td>
				</tr>
				<TR><TD>TELEFONO:</TD>
					<td>#VendorAddress.TelephoneNo#</td>
				</TR>
				<TR><TD>FAX:</TD>
					<td>#VendorAddress.FaxNo#</td>
				</TR>
				<TR><TD>CONTACTO:</TD>
					<td>#VendorAddress.Contact#</td>
				</TR>
   			</table>
			</cfoutput>
			</TD>
   			<td valign="top" >
				<cfoutput>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
			  <tr><td>
				INSTRUCCIONES ESPECIALES:<BR><br>
				#GetHeader.Remarks#				
			</td></tr>
			</table>
			</cfoutput>
			</td>
		</TR>
		<cfoutput>
		<TR><td valign="top" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
			  <tr><td>
			CONDICIONES DE PAGO: El valor de los bienes ser cancelado #GetHeader.ConditionText#
			despu�s de la entrega de los bienes, previa inspecci�n de los mismos, y previa emisi�n 
			de la factura correspondiente.
			</td></tr>
			</table>
			<td valign="top" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
			  <tr><td>			
			FECHA DE ENTREGA: #dateformat(GetHeader.DeliveryDate, "mmmm d, yyyy")#
			</td></tr>
			</table>
			</td>
		</tr>
		</cfoutput>
	</table>	
	</td></tr>   

	<TR><TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	   		<td width="15%" align="center"><strong>ITEM No.</strong></td>
			<td width="25%" align="center"><strong>DESCRIPCION DE LOS BIENES</strong></TD>
			<td width="15%" align="center"><strong>UNIDAD</strong></td>
			<td width="15%" align="center"><strong>CANTIDAD</strong></td>
			<td width="15%" align="right"><strong>PRECIO UNITARIO&nbsp;&nbsp;</strong></td>
			<td width="15%" align="right"><strong>MONTO TOTAL&nbsp;&nbsp;</strong></td>
	   </tr>
	   <cfset cnt = 1>
	    <cfset subtotal = "0">
	    <cfset tax      = "0">
	    <cfset total    = "0">
	    <cfset currOrd  = "USD">
			
	   <cfoutput query="PurchaseLines">
	   
	    <cfset total     = total + OrderAmount>
	    <cfset tax       = tax + OrderAmountTax>
		<cfset subtotal  = subtotal + OrderAmountCost>
		<cfset currOrd   = Currency>	   
	   
	   <tr>
	   		<td valign="top" align="center">#cnt++#</td>
	   		<td valign="top">#OrderItem# #Remarks#</td>
	   		<td valign="top" align="center">#OrderUoM#</td>
	   		<td valign="top" align="center"><cfif Find(OrderUoM,"Each,U") neq 0>#NumberFormat(OrderQuantity,'______')#<cfelse>#NumberFormat(OrderQuantity,'______._')#</cfif></td>
	   		<td valign="top" align="right">#NumberFormat(OrderAmountCost/OrderQuantity,'_____.__')#&nbsp;&nbsp;</td>
	   		<td valign="top" align="right">#NumberFormat(OrderAmountCost,'__,____.__')#&nbsp;&nbsp;</td>
		</tr>
	   
	   </cfoutput>
	   
	   <cfoutput>
		<cf_NumberToText Amount="#subtotal#" Lang="ESP" Currency="Quetzales">
	   <tr><td colspan="3">MONTO TOTAL INCLUYE EL IMPUESTO AL VALOR AGREGADO -IVA- :#Ucase(TextAmount)#</td>
	   <TD align="right"><strong>MONTO TOTAL&nbsp;</strong></TD>
	   <TD COLSPAN="2" align="right"><strong>#NumberFormat(subtotal,'__,____.__')#&nbsp;&nbsp;</strong></TD>
	   </tr>
	   </cfoutput>
	</TABLE>
	</TD></TR>
	
</TABLE>	

</cfdocumentSection>

<cfset hdrCnt = 1>

<cfdocumentSection marginTop="2.5" marginBottom="2">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfdocumentitem type="header"  evalAtPrint="true"> 
	<cfif hdrcnt++ eq 1>
	 <cfoutput> 
	 <table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="gray" class="formpadding">
	 <tr>
	 	<td align="center" valign="center" width="70%">COMISION INTERNATICIONAL CONTRA LA IMPUNIDAD EN GUATEMALA</TD>
		<TD>AVISO IMPORTANTE<BR>
			Toda correspondencia, factura y embarque debe mostrar este numero</TD>
	 </tr>	
	 <tr>
	 	<td align="center">ORDEN DE COMPRA</td>
		<td>No. #GetHeader.PurchaseNo#</td>
	 </tr>
	 </table>
	 </cfoutput>
	 </cfif>
 </cfdocumentitem> 


<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" rules="ROWS">
<tr><td>
    <table width="98%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	<TR><TD WIDTH="25%">Funcionario que aprueba:</td>
		<td colspan="3"></td>
	</TR>
	<tr><td height="10"></td></tr>
	<tr><td align="Center" valign="bottom"><hr></td>
		<td align="Center" width="40%" valign="bottom"><hr></td>
		<td align="Center" width="25%" valign="bottom"><hr></td>
		<td align="Center" width="10%"><cfoutput>#dateformat(Now(), "mmmm d, yyyy")#</cfoutput></td>
	</tr>
	<tr><td align="Center" >(Nombre)</td>
		<td align="Center">(Cargo)</td>
		<td align="Center">(Firma)</td>
		<td align="Center">(Fecha)</td>
	</tr>
	</table>
</td></tr>
<tr><TD>
    <table width="98%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	<TR><td colspan="2" align="Center">LA ORDEN DE COMPRA ARRIBA INDICADA ES ACEPTADA</td></tr>
	<tr><td height="10"></td></tr>
	<TR><TD width="60%" align="center" valign="Bottom"><hr></TD>
		<td align="center" valign="bottom"><hr></td>
	</tr>	
	<TR><TD align="center">(Firma y sello del Proveedor)</TD>
		<td align="center">(Fecha)</td>
	</tr>	
	</table>
</td></tr>
</table>
	
<br>

<CFOUTPUT query="GetClause">

	<table width="90%" align="center">
	<tr><td>
	<font size="2" face="Trebuchet MS">
	#ClauseText#
	</font>
	</td></tr>
	</table>

	<cfdocumentitem type="pagebreak"></cfdocumentitem>

</CfOutput>
	
</cfdocumentsection>
	

