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

<cfset Today = "#now()#">
		  
<cfquery name="GetHeader" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT P.*, R.Description as ConditionText
FROM Purchase P, Ref_Condition R
WHERE PurchaseNo = '#URL.ID1#'
AND P.Condition = R.Code
</cfquery>

<cfquery name="GetNOG" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  TOP 1 I.DocumentItemValue as NOG
FROM    OrganizationObjectInformation I INNER JOIN OrganizationObject O 
			ON I.ObjectId = O.ObjectId 
		INNER JOIN Purchase.dbo.RequisitionLine RL 
			ON O.ObjectKeyValue1 = RL.JobNo 
		INNER JOIN Purchase.dbo.PurchaseLine PL
			ON RL.RequisitionNo = PL.RequisitionNo
WHERE I.DocumentDescription = 'NOG' 
AND PL.PurchaseNo = '#URL.ID1#'
</cfquery>

<cfquery name="GetWFType" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  TOP 1 E.EntityClassName
FROM    Ref_EntityClass E INNER JOIN OrganizationObject O 
			ON E.EntityCode = O.EntityCode AND E.EntityClass=O.EntityClass
		INNER JOIN Purchase.dbo.RequisitionLine RL 
			ON O.ObjectKeyValue1 = RL.JobNo 
		INNER JOIN Purchase.dbo.PurchaseLine PL
			ON RL.RequisitionNo = PL.RequisitionNo
WHERE PL.PurchaseNo = '#URL.ID1#'  
</cfquery>

<cfquery name="job" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Top 1 J.*
	    FROM Job J INNER JOIN Purchase.dbo.RequisitionLine RL 
			ON J.JobNo = RL.JobNo 
		INNER JOIN Purchase.dbo.PurchaseLine PL
			ON RL.RequisitionNo = PL.RequisitionNo
		WHERE PL.PurchaseNo = '#URL.ID1#'
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
FROM  vwOrganizationAddress
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
FROM   vwOrganizationAddress
WHERE  OrgUnit = '#GetHeader.OrgUnitVendor#'
AND    AddressType = 'Mail'
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
	<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" >
	    <tr><td align="center">
		<font size="1">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount# 
		</td></tr>
	</table>
</cfoutput>
</cfdocumentitem>

<cfdocumentSection marginTop="1.3" marginBottom="1">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfdocumentitem type="header"> 
	 <cfoutput> 
	 <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" >
	 <tr><td width="70%">
			 <table width="97%" border="1" cellspacing="0" cellpadding="0" bgcolor="DADADA" class="formpadding">
			 <tr>
			 	<td align="center"><font size="2"><strong>SIGES - ORDEN DE COMPRA</strong></FONT></TD>
			 </tr>	
			 </table>
		 </td>
		 <td>
			 <table width="97%" border="1" cellspacing="0" cellpadding="0" align="right" class="formpadding">
			 <tr>
			 	<td align="center"><font size="2"><strong>OC No.: #GetHeader.PurchaseNo#</strong></FONT></TD>
			 </tr>	
			 </table>
		 </td>
	 </tr>
	 </table>
	 </cfoutput>
 </cfdocumentitem> 

<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center">
<tr><td>
	<cfoutput>
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	   <tr><td width="15%" align="right"><strong>Lugar y Fecha:</strong></td>
	   		<td width="70%">#BuyerAddress.City# - Guatemala, #Day(Today)# de #UCase(MonthAsString(Month(Today)))# DEL #Year(Today)#</td>
			<td>NIT: </td>
		</tr>	
	   <tr><td align="right"><strong>Instituci�n:</strong></td>
	   		<td style="border: thin solid Silver;">SUPERINTENDENCIA DE ADMINISTRACION TRIBUTARIA -SAT-</td>
			<td style="border: thin solid Silver;">NOG: #GetNog.NOG#</td>
		</tr>	
	   <tr><td align="right"><strong>Unidad Compradora:</strong></td>
	   		<td colspan="2" style="border: thin solid Silver;">#Buyer.OrgUnitName#</td>
		</tr>	
		
	</TABLE>
	</cfoutput>
	</TD></TR>
	
</TABLE>	
<br>
<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center">
<tr><td>
	<cfoutput>
    <table width="100%" border="0" cellspacing="0" cellpadding="" class="formpadding">
	   <tr><td width="15%" align="right"><strong>Se�or Proveedor:</strong></td>
	   		<td colspan="5" >#Vendor.OrgUnitName#</td>			
			<td width="15%">NIT: </td>
		</tr>	
	   <tr><td align="right"><strong>Domicilio Comercial:</strong></td>
	   		<td colspan="6">#VendorAddress.Address1#
						<cfif #VendorAddress.Address2# neq "">
							, #VendorAddress.Address2#
						</cfif>
						,#VendorAddress.City# #VendorAddress.PostalCode#
			</td>			
    	</tr>	
	   <tr><td align="right"><strong>Tel�fono:</strong></td>
	   		<td width="15%">#VendorAddress.TelephoneNo#</td>
			<td align="right"><strong>Fax:</strong></td>
	   		<td width="15%">#VendorAddress.FaxNo#</td>
			<td align="right"><strong>E-mail:</strong></td>
	   		<td colspan="2">#VendorAddress.emailAddress#</td>
		</tr>	
	   <tr><td align="right"><strong>S�rvse Entregar A:</strong></td>
	   		<td colspan="6"><cfif AddressShipping.Contact neq "">#AddressShipping.Contact#<cfelse>#Buyer.OrgUnitName#</cfif></td>
		</tr>	
	   <tr><td align="right"><strong>Con Domicilio:</strong></td>
	   		<td colspan="6">#AddressShipping.Address1#
						<cfif #AddressShipping.Address2# neq "">
							, #AddressShipping.Address2#
						</cfif>
						,#AddressShipping.City# #AddressShipping.PostalCode#</td>
		</tr>	
	</TABLE>
	</cfoutput>
	</TD></TR>
	
</TABLE>	
	
<br>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr><td>
<cfoutput>
<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" class="formpadding">
   <tr><td width="85%" valign="Top"><strong>Descripci�n:</strong><br><br>
   #Job.Description#
   </td>
   <td valign="top"><strong>M�todo de Compra</strong><br><br>
   #GetWFType.EntityClassName#
   </td>
</TABLE>
</cfoutput>
<td></tr>
</table>

<br>

<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	<tr><td>
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			<tr><td><strong><u>Otros Datos</u></strong></td></tr>
			<tr><td><strong>Referencia No.:</strong></td></tr>
			<tr><td><strong>Fecha Entrega:
				<cfif GetHeader.DeliveryDate neq "">
				</strong>#Day(GetHeader.DeliveryDate)# de #UCase(MonthAsString(Month(GetHeader.DeliveryDate)))# DEL #Year(GetHeader.DeliveryDate)#
				</cfif>
			</td></tr>
		</table>
	</cfoutput>
	</td></tr>
	<tr><td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<TR><TD height="10"></TD></TR>
		<TR><TD>
			<table width="96%" border="1" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td width="10%">No. de Pedido</td>
				<td width="5%">C�digo Articulo</td>
				<td width="5%">Rengl�n</td>
				<td width="50%">Descripci�n Detallada del Bien y/o Servicio y/o Activos Fijos</td>
				<td width="5%" align="center">Unidad de Medida</td>
				<td width="5%" align="center">Cantidad</td>
				<td width="20%" colspan="2">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr><td align="Center">Precio</td></tr>
					<tr><td>
						<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
						<tr><td width="50%" align="center">Unitario Q.</td>
						<td align="center">Total Q.</td>
						</table>
					</td></tr>	
					</table>
				</td>
			</tr>
			</TABLE>	
		</td></tr>	
		<TR><TD height="5"></TD></TR>		
				
		    <cfset subtotal = "0">
		    <cfset tax      = "0">
		    <cfset total    = "0">
			
			<cfoutput query="PurchaseLines">
		    <cfset total     = total + OrderAmount>
		    <cfset tax       = tax + OrderAmountTax>
			<cfset subtotal  = subtotal + OrderAmountCost>

			<tr><td>
			<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">			
			<TR>
				<td width="10%" valign="top">#RequisitionNo#</td>
				<td width="5%" valign="top" ></td>
				<td width="5%" valign="top" ></td>
				<td width="50%" valign="top" >#OrderItem# #Remarks#</td>
				<td width="5%" valign="top" align="center">#OrderUoM#</td>
				<td width="5%" valign="top" align="center">#OrderQuantity#</td>
		   		<td width="10%" valign="top" align="right">#NumberFormat(OrderAmountCost/OrderQuantity,'_____.__')#&nbsp;&nbsp;</td>
		   		<td width="10%" valign="top" align="right">#NumberFormat(OrderAmountCost,'__,____.__')#&nbsp;&nbsp;</td>
				</td>
			</tr>	
			</table>
			</cfoutput>
		</td></tr>	

		<TR><TD height="5"></TD></TR>
		<tr><td colspan="8">
			<cfoutput>
			<table width="96%" border="1" cellspacing="0" cellpadding="0" align="center">
			<tr><td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			<TR><td width="15%" align="Right"><strong>Total:</strong></td>
				<cf_NumberToText Amount="#subtotal#" Lang="ESP" Currency="Quetzales">
				<td width="75%">#Ucase(TextAmount)#</td>
			    <TD align="right"><strong>#NumberFormat(subtotal,'__,____.__')#&nbsp;&nbsp;</strong></TD>
			</tr>	
			</table>
			</td></tr>
			</table>
			</cfoutput>
		</td></tr>	
		<TR><TD height="10"></TD></TR>
		</table>	
	</TD></TR>
	<tr><td>
		<table width="100%" border="0" cellspacing="10" cellpadding="0" align="center">
		<tr><td align = "Center" height="50" style="border: thin solid Silver;">&nbsp;</td>
			<td align = "Center" height="50" style="border: thin solid Silver;">&nbsp;</td>
			<td align = "Center" height="50" style="border: thin solid Silver;">&nbsp;</td>
		</TR>
		</table>		
	</td></tr>
	
</TABLE>	

</cfdocumentsection>
	

