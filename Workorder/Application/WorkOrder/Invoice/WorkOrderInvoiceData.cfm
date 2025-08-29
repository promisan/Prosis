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
	<cfquery name="Init" 
		datasource="AppsInit">
		SELECT * 
		FROM   Parameter
		WHERE  HostName = '#cgi.http_host#'		
	</cfquery>
	
	<cfquery name="GetMissionName" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT *
		FROM Ref_Mission
		WHERE Mission IN (
			SELECT Mission 
			FROM WorkOrder.dbo.Workorder
			WHERE WorkOrderId ='#URL.ID1#')

	</cfquery>		
	
	<cfquery name="GetMissionAddress" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

		SELECT	Address, 
				AddressCity,
				Country,
				eMailAddress,
				TelephoneNo
		FROM System.dbo.Ref_Address R
		INNER JOIN OrganizationAddress A ON R.AddressId = A.AddressId
		WHERE A.OrgUnit in (		
			SELECT TOP 1 OrgUnit
			FROM Organization
			WHERE Mission IN (			
				SELECT Mission 
				FROM WorkOrder.dbo.Workorder
				WHERE WorkOrderId ='#URL.ID1#'			
							)
			ORDER BY HierarchyCode)

	</cfquery>		
	
	<cfquery name="GetHeader" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	C.CustomerName,
				A.Address as CustomerAddress,
				A.AddressCity as CustomerCity,
				A.AddressPostalCode as CustomerPostalCode,
				OA.TelephoneNo as CustomerPhoneNumber,
				OA.Contact,
				W.ActionStatus as WorkOrderStatus,
				W.Reference as WorkOrderReference,
				S.Code as ServiceItem,
				S.Description as ServiceItemDescription,				
				M.MissionName
		FROM WorkOrder W 
		INNER JOIN Customer C ON C.CustomerId = W.CustomerId
		INNER JOIN ServiceItem S ON S.Code = W.ServiceItem
		INNER JOIN Organization.dbo.Ref_Mission M ON M.Mission = W.Mission
		INNER JOIN Organization.dbo.Organization O ON O.Orgunit = C.OrgUnit
		LEFT OUTER JOIN Organization.dbo.OrganizationAddress OA ON OA.OrgUnit = O.OrgUnit
		LEFT OUTER JOIN System.dbo.Ref_Address A ON OA.AddressId = A.AddressId
	
		WHERE W.workorderid='#URL.ID1#'	
		
	</cfquery>		
	
	<cfquery name="WorkOrderLineItem" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT	C.CustomerName,
				I.Classification,
				I.ItemNo,
				I.ItemDescription,
				LI.UoM,
				LI.Quantity,
				LI.Currency,
				LI.SaleAmountIncome,
				LI.SaleAmountTax,
				LI.ActionStatus,
				U.UoMDescription,
				W.ActionStatus as WorkOrderStatus,
				W.Reference as WorkOrderReference,
				S.Code as ServiceItem,
				S.Description as ServiceItemDescription
		FROM WorkOrderLineitem LI
		INNER JOIN WorkOrderLine L ON LI.WorkOrderId = L.WorkOrderId AND LI.WorkOrderLine = L.WorkOrderLine
		INNER JOIN WorkOrder W ON W.WorkOrderId = L.WorkOrderId
		INNER JOIN Customer C ON C.CustomerId = W.CustomerId
		INNER JOIN Materials.dbo.Item I ON LI.ItemNo = I.ItemNo
		INNER JOIN Materials.dbo.ItemUoM U ON U.ItemNo = LI.ItemNo AND U.UoM = LI.UoM
		INNER JOIN ServiceItem S ON S.Code = W.ServiceItem
		WHERE LI.workorderid='#URL.ID1#'	

	</cfquery>	

<cfset table0 = "border:0px solid b0b0b0">
<cfset table1 = "border:1px solid b0b0b0" >
<cfset td01   = "border-right:1px solid b0b0b0; border-bottom:1px solid b0b0b0">
<cfset td02   = "border-bottom:1px solid b0b0b0">
<cfset td04   = "border-top:1px solid b0b0b0">
<cfset td05   = "border-top:1px solid b0b0b0; border-left:1px solid b0b0b0; border-bottom:1px solid b0b0b0">
<cfset td06   = "border-top:1px solid b0b0b0; border-right:1px solid b0b0b0; border-bottom:1px solid b0b0b0">
<cfset td08   = "border-left:1px solid b0b0b0">
<cfset td09   = "border-left:1px solid b0b0b0; border-top:1px solid b0b0b0">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfdocumentitem type="header" evalAtPrint="true"> 

	<cfoutput> 
		
		<table width="98%" align="center">
	 		<tr class="labelmedium">
				<td style="width:100px"><cf_ReportLogo></td>
		 		<td align="right" style="font-size:75px;font-weight:bold"><hl>Work Order Quotation</h1></td>			 		
	 		</tr>		
			<tr class="labelmedium">
				<td style="width:100px"></td>
		 		<td align="right" style="font-size:55px;font-weight:bold"><hl>#GetMissionName.MissionName#</td>			 		
	 		</tr>			
		</table>	

	</cfoutput>

 </cfdocumentitem> 
 
<cfdocumentSection marginTop="2" marginBottom="2">
 
<cfdocumentitem type="footer" evalAtPrint="true">

<cfoutput> 

	<table width="100%" align="center">
 		<tr>
	 		<td align="center" width="100%">#GetHeader.MissionName#. #GetMissionAddress.Address#, #GetMissionAddress.AddressCity#, #GetMissionAddress.Country#. Phone: #GetMissionAddress.TelephoneNo#</font></td>			 		
 		</tr>
 		<tr>
	 		<td align="center" width="100%">#cgi.http_host# - #GetMissionAddress.eMailAddress#</td>			 		
 		</tr>

	</table>	
	
</cfoutput>

</cfdocumentitem> 

<cfoutput>

	<table width="98%" style="border:1px solid b0b0b0" align="center">
	 <tr>  
		<td height="50" colspan="2" valign="top">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
	
		    <TR >
				<td height="20" width="50%" align="left">Quote No.:</td>
			    <TD align="left" width="50%">#DateFormat(now(),"dddd dd MMMM yyyy")#</TD>
			</TR>
		    <TR >
				<td height="20" width="50%" align="left" style="#td01#">Customer:&nbsp;&nbsp;&nbsp;#GetHeader.CustomerName#</font></td>
			    <TD align="left" width="50%">Contact:&nbsp;&nbsp;&nbsp;#GetHeader.Contact#</TD>
			</TR>
		    <TR >
				<td height="20" width="50%" align="left">Address:&nbsp;&nbsp;&nbsp;#GetHeader.CustomerAddress#,#GetHeader.CustomerCity#</font></td>
			    <TD align="left" width="50%">Phone No.:&nbsp;&nbsp;&nbsp;#GetHeader.CustomerPhoneNumber#</TD>
			</TR>

		</table>
	</tr>
	</table>
		
	<table width="98%" cellspacing="0" cellpadding="0" align="center"  >
	 <tr>  
		<td height="50" colspan="2" valign="top">
		
	    <table width="100%" align="center">
	
	    <TR bgcolor="f4f4f4">
			<td height="20" width="10%"   align="center">Code</td>
		    <TD align="center" width="50%">Description</TD>
		    <TD align="right"  width="10%">Quantity</TD>
		    <TD align="center" width="8%">UoM</TD>	
		    <TD align="right"  width="10%">Price</TD>
		    <TD align="right"  width="10%">Tax</TD>
		    <TD align="right"  width="10%">Total</TD>
		</TR>
		
		<tr><td class="line" colspan="7"></td></tr>
		
		<cfset TTotal = 0>
		<cfset TTax = 0>
		<cfset TQuantity = 0>
		
		<cfloop query="WorkOrderLineItem">
			<cfset TTotal = TTotal + (SaleAmountIncome + SaleAmountTax) >
			<cfset TTax = TTax + SaleAmountTax>
			<cfset TQuantity = TQuantity + Quantity>

			<tr>
						
				<td height="17"  align="left">#Classification#</td>
				<td align="left">#ItemDescription#</td>
				<td align="right">#NumberFormat(Quantity,",")#</td>
		    	<TD align="center">#UoM#</TD>					
				<td align="right">#NumberFormat(SaleAmountIncome,",.__")#</td>
				<td align="right">#NumberFormat(SaleAmountTax,",.__")#</td>
				<td align="right">#NumberFormat(SaleAmountIncome + SaleAmountTax,",.__")#</td>

           	</tr>		
			
		</cfloop>
					
			<tr>
						
				<td height="17" width="50" align="right" colspan="5"><b>Total</b></td>
<!----
				<td align="right" ><font face="verdana">#NumberFormat(TQuantity,",")#</font></td>
		    	<TD align="center" ></TD>					
				<td align="right" ></td>
				<td align="right" ><font face="verdana">#NumberFormat(TTax,",__.__")#</font></td>
--->				
				<td align="right" colspan="2">#NumberFormat(TTotal,",.__")#</td>

           	</tr>	
			<tr>						
				<td height="17" width="50" align="right" colspan="5"><b>Shipping</td>
				<td align="right" colspan="2">#NumberFormat(0,",.__")#</td>
           	</tr>	

			<tr>						
				<td height="17" width="50" align="right" colspan="5"><b>Total</b></td>
				<td align="right" colspan="2">#NumberFormat(TTotal,",.__")#</td>
           	</tr>	
			
	</table> 	
		
</cfoutput>

</cfdocumentSection>
