
<cfparam name="url.header"       default="1">
<cfparam name="url.presentation" default="0">

<cfif url.header eq "1">
  <cfset html = "Yes">  
<cfelse>
  <cfset html = "No">   
</cfif>  

<cf_screentop 
     scroll="No" html="#html#"
	 title="Receipt #url.id#" 
	 label="Receipt: <b>#URL.ID#</b>" 
	 banner="gray"
	 layout="webapp" 
	 jquery="yes"
	 line="no"
	 user="yes">	 
	 
<cf_dialogOrganization>
<cf_dialogProcurement>
<cf_dialogWorkOrder>
<cf_dialogMaterial>
<cf_calendarScript>

<cf_LedgerTransactionScript>

<cfparam name="URL.Id" default="#URL.Id#">
  
<cfquery name="Receipt" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Receipt
	 WHERE  ReceiptNo = '#URL.ID#'
</cfquery>

<cfif Receipt.recordcount neq "1">

	 <table align="center">
	 <tr class="line">
	 	<td align="center" style="padding:10px" colspan="2" class="labellarge"><font color="FF0000"><cf_tl id="This receipt document was cancelled"></td>
	 </tr>
	 </table>		

	<cfabort>

</cfif>

<cfset pen = "0">

<cfquery name="Parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Receipt.Mission#'
</cfquery>

<cfif Parameter.ReceiptTemplate eq "">
   <cfset tmp = "Procurement/Application/Receipt/ReceiptEntry/ReceiptPrint.cfm">
<cfelse>
   <cfset tmp = "#Parameter.ReceiptTemplate#">
</cfif>

<cfif Receipt.RequisitionNo eq "">
	
	<cfquery name="Rollback" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT DISTINCT PurchaseNo, Currency
		 FROM   PurchaseLine  
		 WHERE  RequisitionNo IN (SELECT RequisitionNo 
		                          FROM   PurchaseLineReceipt PR 
								  WHERE  ReceiptNo = '#URL.Id#')
	</cfquery>	

<cfelse>

	<cfquery name="Rollback" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT DISTINCT PurchaseNo, Currency
		 FROM   PurchaseLine
		 WHERE  RequisitionNo = '#Receipt.RequisitionNo#'		
	</cfquery>	

</cfif>

<cfif Rollback.PurchaseNo eq "">

	<table style="width:100%">			
	<tr>	
	<td align="center" colspan="2" style="padding-top:20px;height:42;font-size:28px;font-weight:200" class="labellarge"><cf_tl id="Receipt was removed"></td>
	</tr>
	</table>
	
	<cfabort>

</cfif>

<cfquery name="PO" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT P.*, 
	        R.InvoiceWorkflow   AS ParameterInvoiceWorkflow, 
			R.EnableFinanceFlow AS ParameterEnabledFinanceFlow, 
			R.Tracking          AS ParameterTracking, 
	        R.ReceiptEntry      AS ParameterReceiptEntry,
			R.Description       AS OrderTypeDescription,
			Org.OrgUnitName
	 FROM   Purchase P, 
	        Ref_OrderType R, 
			Organization.dbo.Organization Org
	 WHERE  P.OrderType     = R.Code
	 AND    P.PurchaseNo    IN (#quotedValueList(Rollback.PurchaseNo)#)
	 AND    P.OrgUnitVendor = Org.OrgUnit	 
</cfquery>

<cfinvoke component="Service.Access"
	   Method="procRI"
	   OrgUnit="#PO.OrgUnit#"
	   OrderClass="#PO.OrderClass#"
	   ReturnVariable="ReceiptAccess">				  

<!--- determine if the user may edit this receipt : role and current status,
 if there is no workflow : determine --->
 
	

<cfquery name="Min" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT MIN(ActionStatus) as ActionStatus
	 FROM   PurchaseLineReceipt PR
	 WHERE  ReceiptNo = '#URL.Id#'
</cfquery>	

<cf_workflowenabled 
    mission="#po.mission#" 
    entitycode="ProcReceipt">
		
<cfif workflowenabled eq "1" 
     and Receipt.EntityClass neq "" 
	 and ReceiptAccess eq "ALL" 
	 and (min.ActionStatus eq "0" or receipt.actionStatus eq "0")>

	<cfset editmode = "Edit">

<cfelseif (workflowenabled eq "0" or (workflowenabled eq "1" and  Receipt.EntityClass eq ""))    
	 and ReceiptAccess eq "ALL" 
	 and (min.ActionStatus eq "0" or receipt.actionStatus eq "0")>	
	 
	 <cfset editmode = "Edit">
	
<cfelse>

	<cfset editmode = "View">	

</cfif>

<cfoutput>
	
<script language="JavaScript">

    function reload() {
	    Prosis.busy('yes')		
		fin = document.getElementById('financial').value		
	    ptoken.navigate('ReceiptEditCosting.cfm?#cgi.query_string#&editmode=#editmode#&presentation='+fin,'receiptcosts')						
	}

	function mail() {
		w = #CLIENT.width# - 100;
	  	h = #CLIENT.height# - 140;
	  	window.open("../../../../Tools/Mail/MailPrepare.cfm?Id=Mail&ID1=#URL.ID#&ID0=#tmp#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	}
		
	function print() {
		w = #CLIENT.width# - 100;
		h = #CLIENT.height# - 140;
		window.open("../../../../Tools/Mail/MailPrepare.cfm?Id=Print&ID1=#URL.ID#&ID0=#tmp#","_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
  	} 
	
	function newreceipt(id) {	
	   ptoken.open('../ReceiptEntry/LocatePurchaseView.cfm?mission=#receipt.mission#&receiptno='+id,'_self')
    }
	
	function receiptcost() {
	  ptoken.navigate('setReceiptTotal.cfm?mission=#receipt.mission#&receiptno=#URL.ID#','settotal')
	}
	
	function updateheader() {
		ptoken.navigate('ReceiptEditSubmitHeader.cfm?ID=#URL.ID#','process','','','POST','receipt')		
	}
	
	function workflowdrill(key,box,mode) {
		    
	    se = document.getElementById(box)		
		ex = document.getElementById("exp"+key)
		co = document.getElementById("col"+key)
			
		if (se.className == "hide") {		
		   se.className = "regular" 		   
		   co.className = "regular"
		   ex.className = "hide"			  		  
		   ColdFusion.navigate('ReceiptEditWorkflow.cfm?ajaxid='+key,key)	
   		  
		} else {  se.className = "hide"
		          ex.className = "regular"
		   	      co.className = "hide" 
	    } 	
	
	}		

</script>

</cfoutput>

<cfquery name="CustomFields" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_CustomFields
	<!---
	WHERE  HostSerialNo = '#CLIENT.HostNo#'
	--->
</cfquery>

<cfquery name="CheckLines" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PurchaseLineReceipt 
	 WHERE ReceiptNo    = '#Receipt.ReceiptNo#'
	 AND   ActionStatus <> '9'
</cfquery>
  
<cfform name="receipt" 
     action="ReceiptEditSubmit.cfm?EntryMode=#PO.ParameterReceiptEntry#&ID=#URL.ID#" method="POST">
  
<cfoutput>
	<input type="hidden" name="Mission" id="Mission" value="#PO.Mission#">
	<input type="hidden" name="Period"  id="Period"  value="#PO.Period#">	  
</cfoutput>
 
<cfoutput>

<table width="99%" height="98%" border="0" align="center">

	<tr class="hide"><td id="process"></td></tr>
  
	<cf_tl id="Close" var="1">
	
	<tr style="height:10px"><td style="padding-top:5px">
	
	<table style="width:100%">
			
	<tr>
	
	<td colspan="2" style="padding-left:20px;height:25;font-size:20px" class="labellarge"><cf_tl id="Shipment and Receipt Details"> #Receipt.ReceiptNo#</td>
		
	<td colspan="1" align="right" height="25" style="padding-right:4px">
	
	       <table>
		   <tr>	   
	
		   <td colspan="1" height="25" style="padding-left:2px">
							
		   <cfif editmode eq "Edit">
		
			  <cf_tl id="Add" var="1">
			  <input type="button" onClick="newreceipt('#Receipt.ReceiptNo#')" style="font-size:13px;height:25px;width:130" class="button10g" name="#lt_text#" id="#lt_text#"  value="#lt_text#">	
			
		   </cfif>	
	
		   </td>
	
		   <td align="right" style="padding-left:10px">
		
				<table>
				<tr class="labelmedium">
				<td style="padding-right:4px"><cf_tl id="Presentation">:</td>
				<td style="padding-right:5px">
				<select id="financial" onchange="reload()" class="regularxl">
				<option value="0" <cfif url.presentation eq "0">selected</cfif>><cf_tl id="Standard"></option>
				<option value="1" <cfif url.presentation eq "1">selected</cfif>><cf_tl id="Include Ledger"></option>
				<option value="9" <cfif url.presentation eq "9">selected</cfif>><cf_tl id="Summary"></option>
				</select>
				</td>				
				<td>|</td>				
				<td style="padding-left:4px">
		       			 
				<img src="#SESSION.root#/Images/mail.png"
			     alt="eMail Routing Slip Invoicing Procedures"
			     border="0"
				 height="32px"
				 width="32px"
			     align="bottom"
			     style="cursor: pointer;"
				 onClick="javascript:mail()">
				 
				</td>
				<td>|</td>	
				<td style="padding-left:4px;padding-right:8px"> 
			    
				<img src="#SESSION.root#/Images/print_gray.png" 
				 style="cursor:pointer; height:32px;" onclick="avascript:print()"
				 alt="Print" 
				 border="0" align="absmiddle">		
				 
				 </td></tr>
				</table>		
				
			</td>		   
			
			</tr>
			
		</table>	
				
	</td>		 
	
	</tr>	
	
	</table>
	</td>
	</tr>
	
	<cfif checkLines.recordcount eq "0">
		 
		 <tr class="line"><td align="center" style="padding:10px" colspan="2" class="labellarge"><font color="FF0000"><cf_tl id="This receipt document was cancelled"></td></tr>
		  
		 <cfquery name="CloseCurrent" 
		 datasource="AppsPurchase"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE Organization.dbo.OrganizationObject
			 SET    Operational = 0
			 WHERE  ObjectKeyValue1 = '#Receipt.ReceiptNo#'							 
		</cfquery>		
				
		<cfquery name="reset" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE Receipt 
			 SET    ActionStatus = '9'
			 WHERE  ReceiptNo    = '#Receipt.ReceiptNo#'
			 AND    ActionStatus <> '9'
		</cfquery>
	 
	</cfif>
	  
</cfoutput>

<tr><td style="height:100%;width:100%">

		<cf_divscroll>
	
		<table style="width:100%">
		  
		<cfinvoke component="Service.Access"
			   Method="procRI"
			   OrgUnit="#PO.OrgUnit#"
			   OrderClass="#PO.OrderClass#"
			   ReturnVariable="ReceiptAccess">	
			
		     <cfoutput>
			 
			 <cfset cl = "ffffff">
			 
			 <tr><td colspan="2" class="line"></td></tr>	  
				 
		  	 <tr><td colspan="2" style="padding-top:0px;padding-left:25px;padding-right:10px">
			 
			  <table width="100%" class="formpadding" border="0" cellspacing="0" cellpadding="0" bgcolor="#cl#" 
			      style="border-left:0px solid silver;border-right:0px solid silver; border-top:0px solid silver;padding:10px">
						  
			  <cfif PO.recordcount eq "1">  
			  	  
			  <tr class="labelmedium">
			    <td width="10%" style="padding-left:4px;"><cf_tl id="Purchase No">:</td>
				<td width="25%">
				
				<cfinvoke component = "Service.Access"  
					method           = "RoleAccess" 
					mission          = "#PO.Mission#" 
					Function         = "Procurement"				   
					returnvariable   = "access">
						   
			    <cfif Access eq "GRANTED">
				
					<a href="javascript:ProcPOEdit('#PO.PurchaseNo#','','tab')">#PO.PurchaseNo#</a>
					
				<cfelse>
				
					#PO.PurchaseNo#
					
				</cfif>
								
				<cfquery name="PurchaseHeader" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   Purchase
					WHERE  PurchaseNo = '#PO.Purchaseno#'
				</cfquery>
										
				<cfquery name="Parameter1" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_ParameterMission
					WHERE  Mission = '#PO.Mission#' 
				</cfquery>
				
				<cfif Parameter1.PurchaseCustomField neq "">
				
				: #evaluate("PurchaseHeader.Userdefined#Parameter1.PurchaseCustomField#")#
				
				</cfif>
				
				</td>
				<td width="150" style="padding-left:4px;"><cf_tl id="Order Type">:</td>
				<td width="250" style="">#PO.OrderTypeDescription#</td>
			  </tr>	
			  
			  <tr class="labelmedium">
			    <td style="padding-left:4px;"><cf_tl id="Vendor">:</td>
				<td>
				
				<cfif Access eq "GRANTED">
					<a href="javascript:viewOrgUnit('#PO.OrgUnitVendor#')">#PO.OrgUnitName#</a>
				<cfelse>
					#PO.OrgUnitName#
				</cfif>
						
				</td>
				<td style="padding-left:4px;"><cf_tl id="Order Date">:</td>
				<td style="">#DateFormat(PO.OrderDate,CLIENT.DateFormatShow)#</td>
			  </tr>		
			  
			  <cfelse>
			  
			  <tr class="labelmedium">
				  <td valign="top" style="padding-top:6px;padding-left:4px;"><cf_tl id="Vendor"></td>
				  <td colspan="3">
				  <table style="width:98%">
				  
					  <tr class="line labelmedium">
						  <td><cf_tl id="Name"></td>
						  <td><cf_tl id="PurchaseNo"></td>				 	  
						  <td><cf_tl id="Date"></td>		
						   <td><cf_tl id="Order type"></td>		
						  <td style="width:40"><cf_tl id="Lines"></td>
						  <td></td>
						  <td style="width:60" align="right"><cf_tl id="Receipt Cost"></td>  
						  
						  <td style="width:60" align="right"><cf_tl id="Tax"></td>  
						  <td style="width:80" align="right"><cf_tl id="Payable"></td>   
						  <td style="width:60" align="right"><cf_tl id="Cost">#application.basecurrency#</td> 
					  </tr>
				  
					  <cfloop query="PO">
					  
						  <cfquery name="ReceiptLine" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						  	SELECT     count(*) as Lines,
									   SUM(PLR.ReceiptAmountCost) AS Cost, 
									   SUM(PLR.ReceiptAmountBaseCost) AS CostBase,
							           SUM(PLR.ReceiptAmountTax) AS Tax, 
									   SUM(PLR.ReceiptAmount) AS Payable
							FROM       PurchaseLineReceipt AS PLR INNER JOIN
					                   PurchaseLine AS PL ON PLR.RequisitionNo = PL.RequisitionNo
							WHERE      PurchaseNo    = '#PurchaseNo#'				 
							AND        PLR.ReceiptNo = '#Receipt.ReceiptNo#' 
							AND        PLR.Currency  = '#Currency#' 
							AND        PLR.ActionStatus <> '9'
							GROUP BY PL.PurchaseNo, PLR.ReceiptNo
						  </cfquery>					  
						 			  
						  <cfinvoke component = "Service.Access"  
							method           = "RoleAccess" 
							mission          = "#Mission#" 
							Function         = "Procurement"				   
							returnvariable   = "access">	  
						
						  <tr class="line labelmedium">
							  <td>
							    <cfif Access eq "GRANTED">
								<a href="javascript:viewOrgUnit('#PO.OrgUnitVendor#')">#PO.OrgUnitName#</a>
								<cfelse>
								#PO.OrgUnitName#
								</cfif>
							  </td>
							  <td> 
							  <cfif Access eq "GRANTED">		
								<a href="javascript:ProcPOEdit('#PO.PurchaseNo#','','tab')">#PO.PurchaseNo#</a>
							  <cfelse>		
								#PO.PurchaseNo#			
							  </cfif>
							  </td>
							  			  
							  <td>#DateFormat(PO.OrderDate,CLIENT.DateFormatShow)#</td>		
							  <td>#PO.OrderTypeDescription#</td>						  
							  <td>#ReceiptLine.Lines#</td>
							  <td>#Currency#</td>
							  <td align="right">#numberformat(ReceiptLine.cost,",.__")#</td>  					  
							  <td align="right">#numberformat(ReceiptLine.tax,",.__")#</td>  
							  <td align="right">#numberformat(ReceiptLine.payable,",.__")#</td> 
							  <td align="right">#numberformat(ReceiptLine.costbase,",.__")#</td>  				  
						  </tr>
					  
					  </cfloop>
				  <tr></tr>
				  </table>
				  </td>
			  </tr>
			  	  
			  </cfif>
			  
			  <cf_verifyOperational module="WorkOrder" Warning="No">				
						
				<cfif Operational eq "1">
				
					<cfquery name="WorkOrder" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   DISTINCT W.Reference, WL.WorkOrderLine, WL.WorkOrderLineId, C.CustomerName
						FROM     PurchaseLine P INNER JOIN
				                 RequisitionLine R ON P.RequisitionNo = R.RequisitionNo INNER JOIN
				                 WorkOrder.dbo.WorkOrderLine WL ON R.WorkorderId = WL.WorkOrderId AND R.WorkOrderLine = WL.WorkOrderLine INNER JOIN
				                 WorkOrder.dbo.WorkOrder W ON WL.WorkOrderId = W.WorkOrderId INNER JOIN
				                 WorkOrder.dbo.Customer C ON W.CustomerId = C.CustomerId
						WHERE    P.PurchaseNo = '#PO.PurchaseNo#'		  
					</cfquery>
					
					<cfif workorder.recordcount gte "1">			
				  
				    <tr class="labelmedium" >
				    <td valign="top" style="padding-top:5px;padding-left:4px;"><cf_tl id="Workorder">:</td>
					<td colspan="3" style="">
					
					<table style="width:300" class="navigation_table">
					<cfloop query="workorder">
						<tr style="height:21px" class="labelmedium navigation_row">
							<td style=""><cf_img icon="edit" onclick="workorderlineopen('#workorderlineid#','#url.systemfunctionid#','#reference#')"></td>
							<td>#Reference#</td>
							<td>#Workorderline#</td>
							<td>#CustomerName#</td>					
						</tr>
					</cfloop>
					</table>
								
					</td>			
					</tr>		
								
					</cfif>
					
				</cfif>	
					  
			  <tr class="labelmedium">
			    <td style="padding-left:4px;"><cf_tl id="Packingslip No">:</td>
				<td>
					<cfif EditMode eq "edit">
						<input type="text" name="PackingSlipNo" id="PackingSlipNo" size="20" value="#Receipt.PackingslipNo#" class="regularxl enterastab" maxlength="20"></td>
					<cfelse>
					    <cfif Receipt.PackingslipNo eq "">--<cfelse>#Receipt.PackingslipNo#</cfif>
						
					</cfif>
				<td style="padding-left:4px" height="26"><cf_tl id="Transaction date">:</td>
				<td>
					<cfif EditMode eq "edit">
							<cf_intelliCalendarDate9
							 class="regularxl enterastab"
								FieldName="ReceiptDate" 
								Default="#Dateformat(Receipt.ReceiptDate, CLIENT.DateFormatShow)#"
								DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"
								AllowBlank="False">	
					 <cfelse>
						#Dateformat(Receipt.ReceiptDate, CLIENT.DateFormatShow)# #Receipt.OfficerFirstName# #Receipt.OfficerLastName# #DateFormat(Receipt.Created, CLIENT.DateFormatShow)#
					</cfif>		
				 </tr>
			  </tr>	
			  
			  <cfif CustomFields.ReceiptReference1 neq "" or CustomFields.ReceiptReference2 neq "">
			  
			  <tr class="labelmedium">
				<td style="height:30px;padding-left:4px;">#CustomFields.ReceiptReference1#:</td>
				<td>
				<cfif EditMode eq "edit">
					<input type="text" name="ReceiptReference1" id="ReceiptReference1" size="20" value="#Receipt.ReceiptReference1#" class="enterastab regularxl" maxlength="20">
				<cfelse>
				    <cfif Receipt.ReceiptReference1 eq "">--<cfelse>#Receipt.ReceiptReference1#</cfif>
					
				</cfif>
				</td>
				
			  	<td style="height:30px;padding-left:4px;">#CustomFields.ReceiptReference2#:</td>
				<td>
				<cfif EditMode eq "edit">
					<input type="text" name="ReceiptReference2" id="ReceiptReference2" size="20" value="#Receipt.ReceiptReference2#" class="enterastab regularxl" maxlength="20">
				<cfelse>
					<cfif Receipt.ReceiptReference2 eq "">--<cfelse>#Receipt.ReceiptReference2#</cfif>
				</cfif>
			  </tr>	
			  
			  </cfif>
			  
			  <cfif CustomFields.ReceiptReference3 neq "" or CustomFields.ReceiptReference4 neq "">	  
			  <tr class="labelmedium" >	
				<td style="height:30px;padding-left:4px;">#CustomFields.ReceiptReference3#:</td>
				<td>
				<cfif EditMode eq "edit">
					<input type="text" name="ReceiptReference3" id="ReceiptReference3" size="20" value="#Receipt.ReceiptReference3#" class="enterastab regularxl" maxlength="20">
				<cfelse>
					<cfif Receipt.ReceiptReference3 eq "">--<cfelse>#Receipt.ReceiptReference3#</cfif>
				</cfif>
			 	<td style="height:30px;padding-left:4px;" >#CustomFields.ReceiptReference4#:</td>
				<td>
				<cfif EditMode eq "edit">
					<input type="text" name="ReceiptReference4" id="ReceiptReference4" size="20" value="#Receipt.ReceiptReference4#" class="enterastab regularxl" maxlength="20">
				<cfelse>
					<cfif Receipt.ReceiptReference4 eq "">--<cfelse>#Receipt.ReceiptReference4#</cfif>
				</cfif>
			  </tr>
			  
			  </cfif>
			  
			  <cfquery name="Cost" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     ReceiptCost
					WHERE    ReceiptNo = '#Receipt.ReceiptNo#'				
			  </cfquery>
			  
			  <tr>	
				<td class="labelmedium" style="padding-left:4px;"><cf_tl id="Associated costs">:</td>
				<td colspan="3" class="labelmedium">
					<table>
					<tr class="labelmedium">
					<td>
						<cfif EditMode eq "edit">				
							<input type="text" name="CostDescription" value="#Cost.Description#" size="10" maxlength="50" class="regularxl">			
						<cfelse>
						    <cfif cost.Description eq "">--<cfelse>#Cost.Description#</cfif>			
						</cfif>
					</td>
								
					</tr>
					
					</table>
				</td>
			  </tr>	  
			  	  
			 <cfif EditMode eq "edit">	  
			  <tr>	
				<td class="labelmedium" valign="top" style="padding-left:4px;"><cf_tl id="Remarks">:</td>
				<td colspan="3" class="labelmedium" style="padding-left:0px">
					
					<textarea class="regular" 
					    style="height:40px;font-size:13px;padding:3px;font-size:14px;width:99%"				
						totlength="200" onkeyup="return ismaxlength(this)"	name="Receiptremarks">#Receipt.ReceiptRemarks#</textarea>				
				
				</td>
			  </tr>
			  <cfelseif receipt.receiptremarks neq "">
			  
			  <tr>	
				<td class="labelmedium" valign="top" style="padding-left:4px;"><cf_tl id="Remarks">:</td>
				<td colspan="3" class="labelmedium" style="padding-left:0px">
				   #Receipt.ReceiptRemarks#			
				</td>
			  </tr>
			  
			  </cfif>
			  
			  <tr class="labelmedium"><td style="padding-left:4px;"><cf_tl id="Attachments">:</td>
			  <td colspan="3" style="padding-left:0px;padding-right:20px">
		
			      <cfif EditMode eq "edit">	 		  
				  
					  <cf_filelibraryN
						DocumentPath   = "PurchaseReceipt"
						SubDirectory   = "#Receipt.AttachmentId#" 		
						Filter=""
						color="transparent"
						Insert="yes"
						Remove="yes"
						reload="true">		
					
				  <cfelse>
				  
					  <cf_filelibraryN
						DocumentPath   = "PurchaseReceipt"
						SubDirectory   = "#Receipt.AttachmentId#" 		
						Filter=""
						color="transparent"
						Insert="no"
						Remove="no"
						reload="true">		
				  		  
				  </cfif>	  
			  
			  </td></tr>	
			  
			  <cfif editmode eq "Edit">
			  
				   <tr><td colspan="4" class="line"></tr>
				  	  
				   <tr class="labelmedium">	
					  <td style="padding-left:4px;"> 	
					
						  <cf_tl id="Update" var="1">
						  <input type="button" onClick="updateheader()" style="font-size:13px;height:25px;width:130" class="button10g" name="#lt_text#" id="#lt_text#"  value="#lt_text#">				
			
						</td>			
								
					  	<td class="hide" id="process"></td>
								 	
				  </tr>
			  
			   </cfif>
			
			  </table>
			  </td>
			 </tr>   
			  
			</cfoutput>
			 
			<cf_wfActive entitycode="ProcReceipt" objectkeyvalue1="#Receipt.ReceiptNo#">	
			 
			<cfif url.presentation neq "9" and workflowenabled eq "0" or Receipt.EntityClass eq "" or wfstatus eq "open">		
				 	 
				 <tr>	 	 
				 <td style="padding-left:15px;padding-right:15px" colspan="2">		
				     <cfdiv bind="url:ReceiptEditCosting.cfm?#cgi.query_string#&editmode=#editmode#" id="receiptcosts">			 	 							 
				 </td>	
				 </tr>  	
				 
			    <tr class="hide"><td>
						<cfdiv bind="url:setReceiptTotal.cfm?mission=#receipt.mission#&receiptno=#receipt.receiptno#" id="settotal">	
						 </td>
				 </tr>			
		
			</cfif>
				 		 
			<cfif workflowenabled eq "1" and Receipt.EntityClass neq "">	
						 		 		 
				 <tr><td colspan="2" style="padding-left:10px;padding-right:10px">
				 
				  <cfoutput>
				 
				  <table width="98%" align="center" style="border:0px solid silver;padding:1px">
			  		  
					  <cfif wfstatus neq "open">			 
					     <cfset cl = "hide">
					  <cfelse>			 
					     <cfset cl = "regular"> 
					  </cfif>
				  
				      <tr><td colspan="2">
					 
					 	<table width="99%" align="center">
								  
						  <cfif wfstatus neq "open">
						  
								<tr class="labelmedium line">
								<td style="width:20px" onClick="workflowdrill('#Receipt.ReceiptNo#','workflow')">
								 
							    <img id="exp#Receipt.ReceiptNo#" 
								     class="regular" 
									 src="#SESSION.root#/Images/arrowright.gif" 
									 align="absmiddle" 							 
									 alt="Expand" 
									 height="9"
									 width="7"			
									 border="0"> 	
													 
								   <img id="col#Receipt.ReceiptNo#" 
								     class="hide" 
									 src="#SESSION.root#/Images/arrowdown.gif" 
									 align="absmiddle" 							 
									 height="10"
									 width="9"
									 alt="Hide" 			
									 border="0"> 
									 
								 </td>
								 <td style="width:100%;font-size:17px;padding-left:5px;cursor:pointer" class="labelmedium">
								 <a href="javascript:workflowdrill('#Receipt.ReceiptNo#','workflow')">Click here to view the Clearance Flow</a></td>
								 </tr>
												  
						  </cfif>
						  		  
						  <tr ><td class="#cl#" id="workflow" colspan="2">
						  				  
						  	<cfajaximport tags="cfdiv">
				    		<cf_ActionListingScript>
						    <cf_FileLibraryScript>
														   
						    <cfset wflnk = "ReceiptEditWorkflow.cfm">
								  
								  <input type="hidden" 
					        	  name="workflowlink_#Receipt.ReceiptNo#" 
		                          id="workflowlink_#Receipt.ReceiptNo#"
						          value="#wflnk#"> 
		
							 <cfif wfstatus eq "open">						 
							 
				    		 <cfdiv id="#Receipt.ReceiptNo#"  
							        bind="url:#wflnk#?ajaxid=#Receipt.ReceiptNo#"/>		 
									
							 <cfelse>
							 
							 <cfdiv id="#Receipt.ReceiptNo#"/>		
							 
							 </cfif>		
						 
							 </td>
						  </tr>
						 				 				  
						  <cfif wfstatus eq "closed">
						  
						     <tr>	 	 
							 <td style="padding-left:10px;padding-right:10px" colspan="2">					
							   <cfdiv bind="url:ReceiptEditCosting.cfm?#cgi.query_string#&editmode=#editmode#" id="receiptcosts">					 									   
							 </td>	
							 </tr>  
							 
						    <tr class="hide"><td>
								<cfdiv bind="url:setReceiptTotal.cfm?mission=#receipt.mission#&receiptno=#receipt.receiptno#" id="settotal">	
							 </td>
							 </tr>		
												 
						  </cfif>	 
						  
						
				
				 </table>
				 			 
				 </cfoutput>
				 		 		 
				 </td>
				 </tr>
				 
				 </table>
				 	
			 <cfelse>
			 	 
			 	<cfif checkLines.recordcount gt "0">
			 	 
				 	<cfif editmode eq "edit">
					
					 <tr><td colspan="2" align="center" style="height:40px;padding-left:10px;padding-top:5px;padding-right:10px">
					 
					     <cfoutput>
					  
					 	 <table width="98%" cellspacing="0" class="formpadding" cellpadding="0" align="center" style="padding-left:13px;border-top:0px solid silver">
						 
							<tr><td>
							<table cellspacing="0" cellpadding="0">
			  
							<tr>
								<td style="padding-left:4px">
									<cfset buttonlayout = {Label="Print Bar code", mode="silver", width="160px", color= "636334", iconheight= "15px", fontsize= "11px", paddingleft = "5px"}>
									
									<cf_print 
										buttonlayout="#buttonlayout#" 
										mode="roundedbutton" 
										source="#SESSION.root#/Warehouse/Inquiry/Print/ItemBarCode/ItemBarCodePrint.cfm?receiptno=#URL.Id#&mission=#Receipt.Mission#">
										
								</td>
								<td style="padding-left:4px">
								
									<cfif pen eq "1">		
									   			 		
										<cf_button2 
											mode        = "silver"
											label       = "Confirm" 
											id          = "Submit"
											width       = "110px"
											color       = "636334"
											fontsize    = "11px"
											type        = "submit">
											
								 	</cfif>
									
								</td>
								<td style="padding-left:4px">
									<cfif getAdministrator(receipt.mission) eq "1">
										
										<cf_button2 
											mode        = "silver"
											label       = "Purge" 
											onClick     = "ColdFusion.navigate('ReceiptDelete.cfm?receiptno=#Receipt.ReceiptNo#','purgebox')"
											id          = "Purge"
											width       = "110px" 
											color       = "636334"
											fontsize    = "11px">   
								 	</cfif>
								</td>
							</tr>
						</table>
						</td></tr>
						
						</table>
						
						 </cfoutput>
		
					 </td></tr>
					 
					 <tr><td id="purgebox"></td></tr>
					 			 
					</cfif> 
					
				</cfif>	
			 
			 </cfif>
			 
		</table>	 
		
	</cf_divscroll>

</td></tr>
</table>
	 
 </cfform>
 
 <cf_screenbottom layout="webapp">