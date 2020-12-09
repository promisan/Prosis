
	
<cfparam name="Object.ObjectKeyValue1" default="">		  
<cfparam name="URL.ID1" default="#Object.ObjectKeyValue1#">	

<cfquery name="GetHeader" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Purchase P LEFT OUTER JOIN Ref_Condition R ON P.Condition = R.Code
	WHERE PurchaseNo = '#URL.ID1#'	
</cfquery>

<cfquery name="GetCustom" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_CustomFields
</cfquery>

<cfquery name="GetVendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   Organization
WHERE  OrgUnit = '#GetHeader.OrgUnitVendor#'
</cfquery>

<cfquery name="GetVendorAddress" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   vwOrganizationAddress
WHERE OrgUnit = '#GetHeader.OrgUnitVendor#'
AND   AddressType = 'Mail'
</cfquery>

<cfquery name="GetAddressInvoice" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   PurchaseAddress
WHERE  PurchaseNo = '#URL.ID1#'
AND    AddressType = 'Invoice'
</cfquery>

<cfquery name="GetAddressShipping" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   PurchaseAddress
WHERE  PurchaseNo = '#URL.ID1#'
AND    AddressType = 'Shipping'
</cfquery>

<cfquery name="GetAddressTransport" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  PurchaseAddress
	WHERE PurchaseNo = '#URL.ID1#'
	AND   AddressType = 'Transport'
</cfquery>

<cfquery name="GetLines" 
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
	SELECT    *
	FROM     PurchaseAction
	WHERE    PurchaseNo = '#URL.ID1#'
	AND      ActionStatus = '2'
	ORDER BY Created DESC
</cfquery>

<cfquery name="GetApproval" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     PurchaseAction
	WHERE    PurchaseNo = '#URL.ID1#'
	AND      ActionStatus = '3'
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

<cfset table0 = "border:0px solid b0b0b0">
<cfset table1 = "border:1px solid b0b0b0" >
<cfset td01 = "border-right:1px solid b0b0b0; border-bottom:1px solid b0b0b0">
<cfset td02 = "border-bottom:1px solid b0b0b0">
<cfset td03 = "border-right:1px solid b0b0b0">
<cfset data10 = "font-family:Verdana;font-size:10pt;font-weight:Bold">
<cfset data08 = "font-family:Verdana;font-size:8pt">

<cfdocumentitem type="header"> 

	 <cfoutput> 
	 <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" rules="cols">
	 <tr><td>
		 <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		 <tr>
			 <td align="center"><cf_reportlogo></td>
		 </tr>
		   <tr><td height="7">&nbsp;</td></tr>
		 <tr>
		    <td width="100%" align="center">
		    <b><font size="4" face="verdana">ORDER FOR EQUIPMENT, SUPPLIES OR SERVICES</td></tr>
		<tr>
		    <td width="100%" align="center" style="padding-top:5px">
		    <b><font size="4" face="verdana">#GetRequisition.Mission#</font></b>
		    </td>
		 </tr>
		 <tr>
		    <td width="100%" colspan="2" style="padding-top:5px" align="center" valign="middle"> 
			<b><font face="verdana" size="2">#dateformat(now(), "mmmm d, yyyy")#</font></b></td>
		 </tr>
		 </table>
	 </td></tr>
	 </table>
	 </cfoutput>

 </cfdocumentitem> 
 
<cfdocumentSection marginTop="4" marginBottom="6">

 <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfdocumentitem type="footer" evalAtPrint="true">

 <cfoutput> 

	<cfif cfdocument.currentpagenumber eq "1">
	
	<table width="98%" style="#table1#" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	  <tr>
	    <td width="55%" height="58" valign="top" style="padding-left:5px;padding-top:5px">
			
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="formpadding">
			<tr>		
			  <td width="30%" height="15" valign="top"><font face="verdana" size="2">MAIL INVOICE TO:</font></td>		  
			  <td width="70%"> </td>
			</tr>
			<tr>
			  <td></td>
			  <td width="95%" height="10"><b><font face="verdana" size="2">
				#GetAddressInvoice.Address1#
				</font></b></td>
			  </tr>		  
			  <tr>
			   <td></td>
			    <td width="95%" height="10"><b><font face="verdana" size="2">
				#GetAddressInvoice.Address2#
				</font></b></td>
			  </tr>
			  <tr>
			  <td></td>
	            <td width="95%" height="10"><b><font face="verdana" size="2">
				#GetAddressInvoice.City# #GetAddressInvoice.PostalCode#
				</b></td>
	          </tr>
			  <tr>
			  <td></td>
	            <td width="95%" height="15"><b><font face="verdana" size="2">
				#GetAddressInvoice.TelephoneNo#
				</font></b></td>
	       </tr>		  
		</table>					
		</td>
		
		<td bgcolor="f4f4f4" style="#td02#">
	
			<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
				  <tr><td height="15" valign="top" colspan="2" style="padding-left:5px;padding-top:5px"><font face="verdana" size="2">GRAND TOTALS in #CurrOrd#</font></td></tr> 
			      <tr>
			        <td height="10"><b>&nbsp;<font face="verdana" size="2">Subtotal</font></b></td>
			        <td align="right">
					<b><font face="verdana" size="2">#NumberFormat(subtotal,'___,___.__')#</font></b></td>
			      </tr>
			      <tr>
			        <td height="10"><b>&nbsp;<font face="verdana" size="2">Tax</font></b></td>
			        <td align="right">
					<b><font face="verdana" size="2">#NumberFormat(tax,'__,____.__')#</font></b></td>
			       </td>
			      </tr>
			      <tr>
			        <td height="15"><b>&nbsp;<font face="verdana" size="2">Total</font></b></td>
			        <td align="right">
				    <b><font face="verdana" size="2">#NumberFormat(total,'_,_____.__')#</font></b></td>
			      </td>
			      </tr>
			</table>	
	
	    </td>
	  </tr>
			  
	  <tr> 

	  <!--- fin firma electronica--->
	   <td style="#td03#"></td>
	   
	   <td height="59" valign="top" style="padding-left:4px">
		
			<table border="0" cellpadding="0" cellspacing="0" class="formpadding">
			
			  <tr><td colspan="1" style="padding-left:5px;padding-top:5px"><font face="verdana" size="2">CONTRACTING OFFICER:</font></td></tr> 
			  
			  	<cfif GetApproval.OfficerUserId neq "">
			  		<font face="verdana" size="2">#SESSION.rootDocumentPath#\#GetApproval.Officeruserid#.jpg</font>
			  	</cfif>
			  	</td></tr>
			  
			  <tr>
				 <td height="100" align="center">
				  
				 <cfoutput>		  					
				 
							<cfif FileExists("#SESSION.rootDocumentPath#\User\Signature\#GetApproval.Officeruserid#.jpg")>		 
							 
						       <cftry>
							   		   
							       <cfimage 
									  action="RESIZE" 
									  source="#SESSION.rootDocumentPath#\User\Signature\#GetApproval.Officeruserid#.jpg" 
									  name="showimage" 
									  height="80" 
									  width="200">
									  
									  <cfimage action="WRITETOBROWSER" source="#showimage#">
									  
								<cfcatch>
								
								  <cf_assignid> 
														 		
								  <img src="#SESSION.rootDocument#\User\Signature\#GetApproval.Officeruserid#.jpg?id=#rowguid#"
									     alt="Signature of #account#"
									     width="200"
									     height="80"
									     border="0"
									     align="absmiddle">
								  			  
								</cfcatch>	  
								
								</cftry>
							 
					  	 <cfelse>		 
							 
							
						 </cfif>
						
				 </cfoutput>			
			    </td>
				 		  
		        <td height="21" align="center">
					<b><font size="2" face="verdana">
					#GetApproval.OfficerFirstName# #GetApproval.OfficerLastName# 
					<br> ( #Dateformat(GetApproval.Created, CLIENT.DateFormatShow)# )
				</td>
			  </tr>	
				
		     </table>
		</td>
		
	  </tr>
	  
	  </table>
	
	</cfif>
 
 		<table width="100%">
            <tr><td align="center">
			<font size="1">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount# 
			</td></tr>
	    </table>
		
  </cfoutput>
  
</cfdocumentitem>

<cfoutput>

<table width="94%" style="#table1#" cellspacing="0" cellpadding="0" align="center">
<tr>
    <td width="50%" valign="top" style="#td03#">
</cfoutput>	
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	   <tr>
            <td style="padding-left:5px" height="24" width="30%" valign="absmiddle"><font size="2" face="verdana">DATE OF ORDER:</td>
            <td style="padding-left:5px" height="24" width="70%" valign="absmiddle"><b><font size="2" face="verdana">
				<cfoutput query="GetHeader">
				<cfif OrderDate eq "">DRAFT<cfelse>#Dateformat(OrderDate, CLIENT.DateFormatShow)#</cfif>
				</cfoutput> 
                  </font></b></td>
      </tr>
<cfoutput>
	  <tr><td colspan="2" style="#td02#"></td></tr>
</cfoutput>	  	  
      <tr>
            <td style="padding-left:5px" height="24"><font face="verdana" size="2">
			<cfoutput query="GetCustom">#UCase(PurchaseReference1)#:</cfoutput>
			</font></td>
            <td style="padding-left:5px" height="24"><b><font face="verdana" size="2">
			<cfoutput query="GetHeader">#UserDefined1#</cfoutput>
			</font></b></td>
      </tr>
<cfoutput>	  	  
	  <tr><td colspan="2" style="#td02#"></td></tr>
</cfoutput>	  	  
      <tr>
            <td style="padding-left:5px" height="24"><font face="verdana" size="2">
			<cfoutput query="GetCustom">#UCase(PurchaseReference2)#:</cfoutput>
			</font></td>
            <td style="padding-left:5px" height="24"><b><font face="verdana" size="2">
			<cfoutput query="GetHeader">#UserDefined2#</cfoutput>
			</font></b></td>
      </tr>
<cfoutput>	  	  
	  <tr><td colspan="2" style="#td02#"></td></tr>
</cfoutput>	  	  
      <tr>
		  <td style="padding-left:5px" height="24" valign="top"><font face="verdana" size="2">VENDOR:</td>
		  
		  <td style="padding-left:5px" height="24"><b><font face="verdana" size="2">  
					<cfoutput query="GetVendor">#OrgUnitName#</cfoutput>
				<br><br>
					<cfoutput query="GetVendorAddress">#Address1#</cfoutput>
				<br><br>
					<cfoutput query="GetVendorAddress">#Address2#</cfoutput>
				<br><br>
					<cfoutput query="GetVendorAddress">#City# #PostalCode#</cfoutput>
				<br><br>
					<cfoutput query="GetVendorAddress">#TelephoneNo#</cfoutput>
           </td>
	  </tr>	
<cfoutput>	  	  
	  <tr><td colspan="2" style="#td02#"></td></tr>
</cfoutput>	  	  
      <tr>
            <td style="padding-left:5px" height="24"><font face="verdana" size="2">
			<cfoutput query="GetCustom">#UCase(PurchaseReference3)#:</cfoutput>
			</font></td>
            <td style="padding-left:5px" height="24"><b><font face="verdana" size="2">
			<cfoutput query="GetHeader">#UserDefined3#</cfoutput>
			</font></b></td>
      </tr>
<cfoutput>	  	  
	  <tr><td colspan="2" style="#td02#"></td></tr>
</cfoutput>	  	  
      <tr>
            <td style="padding-left:5px" height="24"><font face="verdana" size="2">DELIVERY DATE:</font></td>
            <td style="padding-left:5px" height="24"><b><font face="verdana" size="2">
			<cfoutput query="GetHeader">#Dateformat(DeliveryDate, "#CLIENT.DateFormatShow#")#</cfoutput>
			
			</font></b></td>
      </tr>
<cfoutput>	  	  
	  <tr><td colspan="2" style="#td02#"></td></tr>
</cfoutput>	  	  
      <tr>
            <td style="padding-left:5px" height="24"><font face="verdana" size="2">DISCOUNT 
            TERMS:</font></td>
            <td style="padding-left:5px" height="24""><font face="verdana" size="2">
             <cfoutput query="GetHeader"><b>#Description#</b></cfoutput>
			
			</font></b></td>
      </tr>
      
    </table>
    </td>
      	
    <td width="50%" valign="top">
	
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse" class="formpadding">
	 <tr>
            <td style="padding-left:5px" height="24" width="30%"><font size="2" face="verdana">ORDER NO:</font></td>
            <td width="70%"><b><font face="verdana" size="2">
			<cfoutput query="GetHeader">#PurchaseNo#</cfoutput>			
			</font></b></td>
     </tr>
<cfoutput>	 
	 <tr><td colspan="2" style="#td02#"></td></tr>
</cfoutput>	 
     <tr>
		  <td style="padding-left:5px" height="24"><font face="verdana" size="2">PURCHASE NO.:</font>
		  <td>  
			<cfoutput query="GetHeader"><b><font face="verdana" size="2">#UserDefined4#</font></b></cfoutput>
          </td>
	  </tr>	
<cfoutput>	  
	  <tr><td colspan="2" style="#td02#"></td></tr>
</cfoutput>	  
      <tr>
            <td valign="top" style="padding-left:5px;padding-top:5px;padding-right:20px" height="24"><font face="verdana" size="2">REQUISITIONER(S):</font></td>
            <td height="24">
				<table width="100%" cellspacing="0" cellpadding="0">
				<cfoutput query="GetRequisition">
				<tr><td>
	            <font size="2" face="verdana"><b>#OrgUnitName#</b></font>
				</td></tr>
				</cfoutput>
				</table> 
			</td>
      </tr>
<cfoutput>	  
	  <tr><td colspan="2" style="#td02#"></td></tr>	  	  
</cfoutput>	  
	  <tr>
		
		  <td height="100%" style="padding-left:5px;padding-top:4px" height="24" valign="top"><font face="verdana" size="2">DELIVERY:</font></td>
		  		  
		  <td>  
		  
		  		<cfoutput query="GetAddressShipping">
	
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
		            <tr>		   		   
		            <td width="95%" height="16"><b><font face="verdana" size="2">
					#Address1#
					</font></b></td>
		          </tr>
				  <cfif address2 neq "">
			          <tr>
					    <td width="95%" height="16"><b><font face="verdana" size="2">
						#Address2#
						</font></b></td>
			          </tr>
				  </cfif>
		          <tr>
				    <td width="95%" height="16"><b><font face="verdana" size="2">
					#City# #PostalCode#
					</b></td>
		          </tr>
		          <tr>
				    
		            <td width="95%" height="29"><b><font face="verdana" size="2">
					#TelephoneNo#
					</font></b></td>
		          </tr>
		        </table>
				
				</cfoutput>
           </td>
    </tr>
	  
	  </tr>
	  
    </table>
    </td>
  </tr>

<tr>  

	<td height="50" colspan="2" valign="top">
	
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <TR bgcolor="d2d2d2">
		<td height="20" align="center" style="padding-left:3px"><font face="verdana">No.</font></td>
	    <TD align="center"><font face="verdana">Fund</font></TD>
	    <TD align="center"><font face="verdana">Phase</font></TD>
	    <TD align="center"><font face="verdana">Object Code</font></TD>
	    <TD align="center"><font face="verdana">Description</font></TD>
	    <TD align="center"><font face="verdana">Currency</font></TD>
	    <TD align="right" style="padding-right:5px"><font face="verdana">Amount</font></TD>		
	</TR>
<cfoutput>

	<tr><td colspan="7" style="#td02#"></td></tr>
	
</cfoutput>			
		<cfif GetFunding.recordcount eq "0">

			 <tr><td colspan="7" height="40" align="center"><font color="0080FF"><b>None</td></tr>  
 
		<cfelse>
		<cfoutput>	
		<cfloop query="GetFunding">
						
			<tr>
						
				<td height="17" width="50" align="center"><font face="verdana">#CurrentRow#</font></td>
				<td align="center"><font face="verdana">#Fund#</font></td>
				<td align="center"><font face="verdana">#ProgramName#</font></td>
				<td align="center"><font face="verdana">#ObjectCode#</font></td>
				<td align="center"><font face="verdana">#Description#</font></td>
				<td align="center"><font face="verdana">USD</font></td>
				<td align="right" style="padding-right:5px"><font face="verdana">#NumberFormat(Amount,",__.__")#</font></td>
							
           	</tr>
			
			<cfif currentrow neq recordcount>
												
			<tr><td height="1" colspan="7" bgcolor="DFDFDF"></td></tr>
			
			</cfif>
						
		</cfloop>
		</cfoutput>	
		</cfif>
		
    </TABLE>
	</td>
</tr>  	  
  
<TR>

<td colspan="2" valign="top">

    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" class="formpadding">
	
	<tr bgcolor="d2d2d2">
      <td width="5%" style="padding-left:3px"><font face="verdana">No</font></td>
      <TD width="35%"><font face="verdana">Item or service</font></TD>
      <TD width="10%" align="right"><font face="verdana">Quantity</font></TD>
      <TD width="10%" align="center"><font face="verdana">Unit</font></TD>
	  <TD width="10%" align="center"><font face="verdana">Currency</font></TD>
      <TD width="15%" align="right"><font face="verdana">Unit Price</font></TD>
	  <TD width="15%" align="right" style="padding-right:10px"><font face="verdana">Amount</font></TD>
    </TR>
<cfoutput>
	<tr><td colspan="7" style="#td02#"></td></tr>
	
</cfoutput>	
    <cfset subtotal = "0">
    <cfset tax      = "0">
    <cfset total    = "0">
    <cfset currOrd  = "USD">
			
    <CFOUTPUT query="GetLines">
	    <cfset total     = total + OrderAmount>
	    <cfset tax       = tax + OrderAmountTax>
		<cfset subtotal  = subtotal + OrderAmountCost>
		<cfset currOrd   = Currency>
		   	
	    <TR bgcolor="<cfif CurrentRow Mod 2 eq 0>f4f4f4</cfif>">
	    <td height="20" style="padding-left:3px" align="left"><font face="verdana">#CurrentRow#</font></td>
	    <td align="left"><font face="verdana">#OrderItem# #Remarks#</font></td>
	    <TD align="right"><font face="verdana">#NumberFormat(OrderQuantity,'______._')#&nbsp;&nbsp;</font></TD>
	    <td align="center"><font face="verdana">#OrderUoM#</font></td>
	    <td align="center"><font face="verdana">#Currency#</font></td>
	    <td align="right"><font face="verdana">#NumberFormat(OrderAmountCost/OrderQuantity,'_____.__')#</font></td>
	    <td align="right" style="padding-right:10px"><font face="verdana">#NumberFormat(OrderAmountCost,'__,____.__')#</font></td>
	    </TR>
		
    </CFOUTPUT>
	
	<tr><td colspan="7" height="1" ></td></tr>
	</table>
	</td>
	
</TR>


	<cfquery name="qTotal" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    COUNT(*) As Docs,
				DocumentCurrency,
				SUM(DocumentAmount) as Total 
        FROM    Invoice
		WHERE   InvoiceId IN 
			(SELECT InvoiceId FROM InvoicePurchase WHERE PurchaseNO = '#URL.ID1#')
		GROUP BY  DocumentCurrency
		</cfquery>  
		
	<cfquery name="Lines" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
        FROM      Invoice
		WHERE      InvoiceId IN 
			(SELECT InvoiceId FROM InvoicePurchase WHERE PurchaseNO = '#URL.ID1#')
		order by documentDate
	</cfquery> 		

	<tr><td colspan="2" style="padding-left:10px"><b>Received Invoices</b></td></tr>
	
	<cf_tl id="REQ046" var="1">
	<cfset vReq046=#lt_text#>		
		
	<cfif qtotal.docs gt "1">
		
	<tr><td colspan="2">
	
		 <table width="100%" cellspacing="0" cellpadding="0" align="center" id="inv" class="formpadding">
		     <cfoutput query="qtotal">
		      <tr class="labelmedium">
			  <td width="30%" align="right">#vReq046#:&nbsp;</td>
			  <td width="15%"><b>#Docs#</td>
			  <td width="10%" align="right">Currency:&nbsp;</td>
			  <td width="15%"><b>#DocumentCurrency#</td>
			  <td width="20%" align="right">Amount Invoiced:&nbsp;</td>
			  <td><b>#NumberFormat(Total,",__.__")#</td>
			  </tr>
			  </cfoutput>
		</table>
		
	</td>
	</tr>	  
					
	</cfif>
				
	<tr>
	    <td colspan="2">
 	 	   <cfset URL.mode="print">
		   <cfset URL.sort="">
		   <cfinclude template="POViewInvoice.cfm"> 			
   	    </td>
	</tr>
	
</table>

</cfdocumentSection>

<!--- ------------- --->
<!--- print clauses --->
<!--- ------------- --->

<CFOUTPUT query="GetClause">
	
	<cfdocumentSection marginTop="4" marginBottom="2">
	
		<cfdocumentitem type="footer">
		 <table width="100%">
	        <tr><td align="center">
			<font size="1" face="verdana">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount# 
			</td></tr>
		</table>
		</cfdocumentItem>			
	
		<!--- <cfdocumentitem type="pagebreak"></cfdocumentitem> --->
	
		<table width="90%" align="center"><tr><td align="justify">
		<font size="2" face="verdana">
		#ClauseText#
		</font>
		</td></tr></table>
	
	</cfdocumentsection>
	
</cfoutput> 
