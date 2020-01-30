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
<cfset td01 = "border-right:1px solid b0b0b0; border-bottom:1px solid b0b0b0">
<cfset td02 = "border-bottom:1px solid b0b0b0">
<cfset td03 = "border-right:1px solid b0b0b0">
<cfset td04 = "border-top:1px solid b0b0b0">
<cfset td05 = "border-top:1px solid b0b0b0; border-left:1px solid b0b0b0; border-bottom:1px solid b0b0b0">
<cfset td06 = "border-top:1px solid b0b0b0; border-right:1px solid b0b0b0; border-bottom:1px solid b0b0b0">
<cfset td07 = "border-top:1px solid b0b0b0; border-bottom:1px solid b0b0b0">
<cfset td08 = "border-left:1px solid b0b0b0">
<cfset td09 = "border-left:1px solid b0b0b0; border-top:1px solid b0b0b0">
<cfset td10 = "border-right:1px solid b0b0b0; border-top:1px solid b0b0b0">

<cfset data10 = "font-family:Verdana;font-size:10pt;font-weight:Bold">
<cfset data08 = "font-family:Verdana;font-size:8pt">

<cfdocumentitem type="header"> 

	<cfoutput> 
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="gray" rules="cols">

	<tr>
	 	<td width="30%">
		<!---
			<table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
		 		<tr>
			 		<td align="left" width="25%"><font face="Verdana" size="+3"><b>#GetHeader.CustomerName# </b></font></td>			 		
		 		</tr>
		 		<tr>
			 		<td align="left" width="25%"><font face="Verdana" size="+1">#GetHeader.CustomerAddress#,#GetHeader.CustomerCity#,#GetHeader.CustomerPostalCode#</font></td>			 		
		 		</tr>
		 		<tr>
			 		<td align="left" width="25%"><font face="Verdana" size="+1">#GetHeader.CustomerPhoneNumber#</font></td>			 		
		 		</tr>

			</table>	
		--->	
			<table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
		 		<tr>
					<td><cf_ReportLogo></td>
			 		<td align="left" width="75%"><font face="Verdana" size="+3"><b>#GetMissionName.MissionName# </b></font></td>			 		
		 		</tr>
				
			</table>	

		</td>
	 	<!---
		<td width="40%" align="center"><cf_ReportLogo>

		</td>
		--->		
	 	<td width="30%">
			<table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
		 		<tr>
			 		<td align="right" width="75%"><font face="Verdana" size="+1"><b>#GetMissionAddress.Address#, #GetMissionAddress.AddressCity#, #GetMissionAddress.Country# </b></font></td>
		 		</tr>
		 		<tr>
			 		<td align="right" width="75%"><font face="Verdana" size="+1"><b>Phone: #GetMissionAddress.TelephoneNo#</b></font></td>
		 		</tr>
		 	</table>

		</td>		
	</tr>



	<tr>
	 	<td align="center" colspan="2"><br><font face="Verdana" size="+3" color="0D4e75"><b>Work Order Quotation</b></font></td>
	</tr>
	</table>
	</cfoutput>

 </cfdocumentitem> 
 
 <cfdocumentSection marginTop="2" marginBottom="2">
 
 <cfdocumentitem type="footer" evalAtPrint="true">

<cfoutput> 

	<table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
 		<tr>
	 		<td align="center" width="100%" style="#td04#"><font face="Verdana" >#GetHeader.MissionName#. #GetMissionAddress.Address#, #GetMissionAddress.AddressCity#, #GetMissionAddress.Country#. Phone: #GetMissionAddress.TelephoneNo#</font></td>			 		
 		</tr>
 		<tr>
	 		<td align="center" width="100%"><font face="Verdana" >#cgi.http_host# - #GetMissionAddress.eMailAddress#</font></td>			 		
 		</tr>

	</table>	
	
</cfoutput>

 </cfdocumentitem> 


<cfoutput>
	<table width="98%" style="#table1#" cellspacing="0" cellpadding="0" align="center">
	 <tr>  
		<td height="50" colspan="2" valign="top">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
	
		    <TR >
				<td height="20" width="50%" align="left" style="#td01#"><font face="verdana" size="-1"><b>Quote No.:</b></font></td>
			    <TD align="left" width="50%" style="#td02#"><font face="verdana" size="-1">#DateFormat(now(),"dddd dd MMMM yyyy")#</font></TD>
			</TR>
		    <TR >
				<td height="20" width="50%" align="left" style="#td01#"><font face="verdana" size="-1"><b>Customer:</b>&nbsp;&nbsp;&nbsp;#GetHeader.CustomerName#</font></td>
			    <TD align="left" width="50%" style="#td02#"><font face="verdana" size="-1"><b>Contact:</b>&nbsp;&nbsp;&nbsp;#GetHeader.Contact#</font></TD>
			</TR>
		    <TR >
				<td height="20" width="50%" align="left" style="#td03#"><font face="verdana" size="-1"><b>Address:</b>&nbsp;&nbsp;&nbsp;#GetHeader.CustomerAddress#,#GetHeader.CustomerCity#</font></td>
			    <TD align="left" width="50%"><font face="verdana" size="-1"><b>Phone No.:</b>&nbsp;&nbsp;&nbsp;#GetHeader.CustomerPhoneNumber#</font></TD>
			</TR>

		</table>
	</tr>
	</table>
	
	<br><br>
	
	<table width="98%" cellspacing="0" cellpadding="0" align="center"  >
	 <tr>  
		<td height="50" colspan="2" valign="top">
		
	    <table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
	
	    <TR bgcolor="f4f4f4">
			<td height="20" width="10%" align="center" style="#td05#" style="#td03#"><font face="verdana">Code</font></td>
		    <TD align="center" width="30%" style="#td07#" style="#td03#"><font face="verdana">Description</font></TD>
		    <TD align="right" width="10%" style="#td07#" style="#td03#"><font face="verdana">Quantity</font></TD>
		    <TD align="center" width="8%" style="#td07#" style="#td03#"><font face="verdana">UoM</font></TD>	
		    <TD align="right" width="14%" style="#td07#" style="#td03#"><font face="verdana">Price</font></TD>
		    <TD align="right" width="14%" style="#td07#" style="#td03#"><font face="verdana">Tax</font></TD>
		    <TD align="right" width="14%" style="#td06#" ><font face="verdana">Total</font></TD>
		</TR>
		
		<cfset TTotal = 0>
		<cfset TTax = 0>
		<cfset TQuantity = 0>
		
		<cfloop query="WorkOrderLineItem">
			<cfset TTotal = TTotal + (SaleAmountIncome + SaleAmountTax) >
			<cfset TTax = TTax + SaleAmountTax>
			<cfset TQuantity = TQuantity + Quantity>

			<tr>
						
				<td height="17"  align="left"  style="#td08#" style="#td03#"><font face="verdana">#Classification#</font></td>
				<td align="left" style="#td03#"><font face="verdana">#ItemDescription#</font></td>
				<td align="right" style="#td03#"><font face="verdana">#NumberFormat(Quantity,",")#</font></td>
		    	<TD align="center" style="#td03#"><font face="verdana">#UoM#</font></TD>					
				<td align="right" style="#td03#"><font face="verdana">#NumberFormat(SaleAmountIncome,",__.__")#</font></td>
				<td align="right" style="#td03#"><font face="verdana">#NumberFormat(SaleAmountTax,",__.__")#</font></td>
				<td align="right"  style="#td03#"><font face="verdana">#NumberFormat(SaleAmountIncome + SaleAmountTax,",__.__")#</font></td>

           	</tr>		
		</cfloop>
			<tr>
				<td style="#td08#" style="#td03#"></td>
				<td style="#td03#"></td>
				<td style="#td03#"></td>
		    	<TD style="#td03#"></TD>					
				<td style="#td03#"></td>
				<td style="#td03#"></td>
				<td style="#td03#"></td>			
			</tr>
			<tr bgcolor="f4f4f4">
						
				<td height="17" width="50" align="right" colspan="6" style="#td09#"  style="#td03#"><font face="verdana"><b>Total</b></font></td>
<!----
				<td align="right" ><font face="verdana">#NumberFormat(TQuantity,",")#</font></td>
		    	<TD align="center" ></TD>					
				<td align="right" ></td>
				<td align="right" ><font face="verdana">#NumberFormat(TTax,",__.__")#</font></td>
--->				
				<td align="right" style="#td10#"  style="#td03#"><font face="verdana">#NumberFormat(TTotal,",__.__")#</font></td>

           	</tr>	
			<tr bgcolor="f4f4f4">						
				<td height="17" width="50" align="right" colspan="6"  style="#td09#"  style="#td03#"><font face="verdana"><b>Shipping</b></font></td>
				<td align="right"  style="#td10#"  style="#td03#"><font face="verdana">#NumberFormat(0,",__.__")#</font></td>
           	</tr>	

			<tr bgcolor="f4f4f4">						
				<td height="17" width="50" align="right" colspan="6"  style="#td05#"  style="#td03#"><font face="verdana"><b>Total</b></font></td>
				<td align="right"  style="#td06#"  style="#td03#"><font face="verdana">#NumberFormat(TTotal,",__.__")#</font></td>
           	</tr>	
			
	</table> 	

		
</cfoutput>

</cfdocumentSection>
