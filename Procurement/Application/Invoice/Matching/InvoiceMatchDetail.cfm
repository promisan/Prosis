<cfquery name="Invoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Invoice
		WHERE  InvoiceId = '#URL.ID#'
</cfquery>

<cfquery name="Post" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   TransactionHeader
		WHERE  ReferenceId = '#URL.ID#'
</cfquery>

<cfquery name="InvoiceIncoming" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   InvoiceIncoming
	WHERE  Mission = '#Invoice.Mission#'
	AND    OrgUnitOwner  = '#Invoice.OrgUnitOwner#'
	AND    OrgUnitVendor = '#Invoice.OrgUnitVendor#'
	AND    InvoiceNo     = '#Invoice.InvoiceNo#'
</cfquery>

<!--- we take the most likely purchase record --->

<cfquery name="Purchase" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT P.*
	FROM   InvoicePurchase IP, Purchase P
	WHERE  InvoiceId = '#URL.ID#'
	AND    IP.PurchaseNo = P.PurchaseNo
	ORDER BY AmountMatched DESC
</cfquery>

<cfquery name="Parameter1" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Invoice.Mission#' 
</cfquery>

<!--- posted or not --->

<cf_verifyOperational module = "Accounting" Warning   = "No">

<cfif operational eq "1">

	<cfquery name="GLCheck" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   TransactionHeader
		WHERE  ReferenceId = '#Invoice.InvoiceId#'
	</cfquery>
	
<cfelse>

	<cfset check.recordcount = "0">	

</cfif>

 <table width="100%">     
 
    <tr>
		<td class="labelmedium2" style="border:0px solid gray;padding-left:12px;padding-right:10px;height:40px;font-size:20px">
		<cf_tl id="Provider">
	</td>

	</tr> 
      
	<cfif Invoice.orgunitvendor neq "0">	
	   
	    <tr class="line labelmedium2">
	
		<!--- vendor invoice --->
		
		<cfquery name="OrgUnit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM Organization
			WHERE OrgUnit = '#Invoice.orgunitvendor#'
		</cfquery>				
		
	    <td colspan="1" style="min-width:160px;max-width:160;width:160;padding-left:13px"><cf_tl id="Vendor">/<cf_tl id="Contractor">:</td>
		<cfoutput>
			<td colspan="1" class="labelmedium2">				  
			  <a href="javascript:viewOrgUnit('#OrgUnit.OrgUnit#')">#OrgUnit.OrgUnitName#</a>
			   <input type="hidden" name="orgunit" id="orgunit" value="#OrgUnit.OrgUnit#"> 
			</td>
		</cfoutput>
		<cfset md = "org">
	
	<cfelse>
				
		<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM  Person
			WHERE PersonNo = '#InvoiceIncoming.PersonNo#' 
		</cfquery>	
		
		<tr class="line labelmedium2">
		<td colspan="1" style="min-width:160px;max-width:160;padding-left:13px"><cf_tl id="Employee">:</td>
		<cfoutput>
			<td colspan="1" class="labelmedium2">	
			  <a href="javascript:EditPerson('#Person.PersonNo#')">#Person.FirstName# #Person.LastName#</font></a>
			   <input type="hidden" name="orgunit" id="orgunit" value="0"> 
			   <input type="hidden" name="personno" id="personno" value="#Person.PersonNo#"> 
			   
			   <cfif InvoiceIncoming.InvoiceIssued neq "">
			   / #InvoiceIncoming.InvoiceIssued#
			   </cfif>
			</td>
		</cfoutput>		
		<cfset md = "per">	
	
	</cfif>

    <td width="100"><cf_tl id="Purchase">:</td>
    <td width="35%">
		<table border="0" cellspacing="0" cellpadding="0">
		 <tr style="height:18px" class="labelmedium2">
	    <cfoutput query="Purchase">
			<td style="padding-right:10px;border:0px solid silver">
			<a href="javascript:ProcPOEdit('#Purchaseno#','view')" title="Purchase Order">#PurchaseNo# <cfif Parameter1.PurchaseCustomField neq "">: #evaluate("Userdefined#Parameter1.PurchaseCustomField#")#</cfif></a></td>
			
		</cfoutput>
		</tr>	
		</table>
	</td>
</tr>

<TR class="labelmedium2 line">
  
   <TD style="padding-left:13px"><cfif md eq "org">Invoice<cfelse>Document</cfif> No:</TD>
   <td colspan="1">	
      
	   <cfoutput><cfif InvoiceIncoming.InvoiceSeries neq "">#InvoiceIncoming.InvoiceSeries#-<cfelse></cfif>#Invoice.InvoiceNo#</cfoutput>	 
	   <cfif Invoice.ActionStatus eq "9"><font color="FF0000">(Voided)</font></cfif>
	   
   </td>
   <TD><cf_tl id="Invoice Date">:</TD>   
   <td colspan="1">	 
      
     <cfoutput>
  	 	#Dateformat(InvoiceIncoming.DocumentDate, CLIENT.DateFormatShow)#
   	 </cfoutput>	 
   		   
   </td>	
</TR>	

<cfoutput>

<TR> 

	<cfinvoke component="Service.Access"  
	  method="ProcApprover" 
	  orgunit="#Invoice.OrgUnitOwner#"  
	  returnvariable="accessreq">	
	  
      <td height="18" class="labelmedium2" style="padding-left:13px"><cf_tl id="Amount Original">:</td>
      <td colspan="1">	
      		
		  <table><tr class="labelmedium2">
		  <td>	
		  #InvoiceIncoming.DocumentCurrency# #NumberFormat(InvoiceIncoming.DocumentAmount,",.__")#
		  </td>

		  
		  <cfquery name="Other" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			     SELECT * 
			     FROM   Invoice
			     WHERE  Mission       = '#InvoiceIncoming.Mission#'
				   AND  OrgUnitVendor = '#InvoiceIncoming.OrgUnitVendor#'
				   AND  InvoiceNo     = '#InvoiceIncoming.InvoiceNo#'				   
			</cfquery>	
			
			<!--- --------------------------------------------- --->
			<!--- Allow for change only if there is one payable --->
			<!--- --------------------------------------------- --->
			
			<cfif Other.recordcount eq "1">
		  
			     <cfif Invoice.ActionStatus eq "0" and AccessReq eq "ALL">
				 				 		
					   <td style="padding-left:4px">
					   <cfoutput>
				          <img onclick="editincoming()" style="cursor:pointer" src="#SESSION.root#/images/edit.gif" height="11" width="11" alt="Edit amount" border="0">					  
					   </cfoutput>
					   
					   </td>
					   <cfoutput>
					   <td class="hide" id="refreshinvoice" onclick="Prosis.busy('yes');ptoken.navigate('InvoiceMatchDetail.cfm?id=#url.id#','invoicedetail')">
					   refresh
					   </td>
					   </cfoutput>						  
										  		
				 </cfif>
			 
			</cfif> 
			
			 </tr>
			</table>					
			 	  
     </td>
	 	 	
	 <td class="labelmedium2"><cf_tl id="Exempted">:</td>
	 <td class="labelmedium2">  
	 	<cfif Parameter1.TaxExemption eq "1" or InvoiceIncoming.ExemptionAmount neq "0">
			<font color="gray">
			#NumberFormat(InvoiceIncoming.ExemptionAmount,",.__")#
			<cfif InvoiceIncoming.ExemptionAmount neq "">
			&nbsp;Revised: #NumberFormat(InvoiceIncoming.DocumentAmount-InvoiceIncoming.ExemptionAmount,",.__")#
			</cfif>
			</font>
		<cfelse>
			<cf_tl id="N/A">
		</cfif>
	  </td> 
	 
</tr>

</cfoutput>

<!--- ------------- --->
<!--- ---DETAILS--- --->
<!--- ------------- --->
  	  
<cfquery name="Detail" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   InvoiceIncomingLine 
		WHERE  Mission = '#Invoice.Mission#'
		AND    OrgUnitOwner  = '#Invoice.OrgUnitOwner#'
		AND    OrgUnitVendor = '#Invoice.OrgUnitVendor#'
		AND    InvoiceNo = '#Invoice.InvoiceNo#'				 
		ORDER BY LineSerialNo		
	</cfquery>
	
	<cfif detail.recordcount gte "1">
  
  	<tr class="line">
	 	 
	  <td colspan="3">
	  
	  <table>
	  <tr>
	  <td width="30" valign="top" align="left">
		  <cfoutput><img src="#SESSION.root#/images/join.gif" alt="" border="0"></cfoutput>
	  </td>
	  <td width="93%">
	  
	      <table width="470" border="0" bgcolor="f5f5f5">
		  		
			<cfoutput query="Detail">
			
			<tr class="labelmedium2">							
			   <td height="19" width="26">#currentrow#.</td>			  
			   <td>#LineDescription#</td>			 
			   <td width="40">#LineReference#</td>	
			   <td align="right">#numberformat(LineAmount,",.__")#</td>			 
		    </tr>		
			
			<tr><td colspan="4">
					<cfset access = "view">					
					<cfset url.lineid = invoicelineid>
					<cfset url.mission = invoice.mission>
					<cfinclude template="../InvoiceEntry/InvoiceEntryLineAttachment.cfm">	
			</td></tr>	
			
			</cfoutput>
			  
	      </table>
		  
	  </td></tr>
	  </table>
	  </td>
   </tr>	  
   
</cfif>
			  
<!--- check if the invoice is paid again cancelled requisitions --->  
  
<tr>
<td class="labelmedium2" style="border:0px solid gray;padding-left:12px;padding-right:10px;height:40px;font-size:20px">
<cf_tl id="Amounts Payable">
</td>
<td colspan="3" style="padding-left:10px;padding-right:10px">
<cfinclude template="InvoiceMatchOther.cfm">
</td>
</tr>

<!---

<tr>
<td  class="labelmedium2" >
<cf_tl id="Posted to Journal">
</td>
<td colspan="3" style="padding-left:10px;padding-right:10px">
	<cfdiv id="postingJournalselect" >
		<cfset Url.Mission 			= purchase.mission>
		<cfset URL.Currency 		= purchase.currency>
		<cfset URL.PurchaseNo 		= purchase.PurchaseNo>
		<cfset URL.InvoiceJournal 	= Invoice.Journal> 
		<cfinclude template="../InvoiceEntry/setJournal.cfm">
	</cfdiv>
</td>
</tr>

--->
  
<cfif operational eq "1">	

	<cfquery name="Parameter" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#Invoice.Mission#'
	</cfquery>
	
<cfelse>

	<cfset Parameter.AdministrationLevel = "Tree">

</cfif>	

<cfif Parameter.AdministrationLevel eq "Tree">

	<cfoutput>
		<input type="hidden" name="Mission" id="Mission" value="#Invoice.Mission#"> 
		<input type="hidden" name="OrgUnitOwner" id="OrgUnitOwner" value="0"> 
	</cfoutput>

<cfelse>

	<cfoutput>
		<input type="hidden" name="Mission" id="Mission" value="#Invoice.Mission#"> 
		<input type="hidden" name="OrgUnitOwner" id="OrgUnitOwner" value="#Invoice.OrgUnitOwner#"> 
	</cfoutput>
  
 </cfif>
    			
  <TR class="line labelmedium2">
     
   <TD style="padding-left:33px"><cf_tl id="Transaction date">:</td>
   
   <td>	 
   
   	 <cfoutput>
   
     <table cellspacing="0" cellpadding="0">
	 <tr><td class="labelmedium2">#Dateformat(Invoice.DocumentDate, CLIENT.DateFormatShow)#</td>
	 <td style="padding-left:24px" class="labelmedium2"><cf_tl id="Date Due">:</td>
	 <td style="padding-left:7px" class="labelmedium2">
	    <cfif Invoice.ActionBefore gte now()>
		#Dateformat(Invoice.ActionBefore, CLIENT.DateFormatShow)#
		<cfelse>
	 	<font color="FF0000">#Dateformat(Invoice.ActionBefore, CLIENT.DateFormatShow)#</font>
		</cfif>
	 </td>
	 	 
	 </tr></table>
	 
	 </cfoutput>
	   
   </td>	
   
    <td class="labelmedium2"><cf_tl id="Terms">:</td>
             <td colspan="1" class="labelmedium2">	 
	   		
		     <cfoutput>
			 
				 <cfquery name="Term" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * 
					FROM   Ref_Terms 
					WHERE  Code = '#Invoice.ActionTerms#'
				 </cfquery>
			 
			     <cfif Term.Description eq "">N/A<cfelse>#Term.Description#</cfif>
			 				 
			 <cfif Term.DiscountDays gte "1">
			 (#Dateformat(Invoice.ActionDiscountDate, CLIENT.DateFormatShow)#)			 
			 </cfif>
			 
			 </cfoutput>
		     		   
       </td>	
   
  </TR>	
   
  <TR class="line"> 
     	 	 	
	<cfinvoke component="Service.Access"  
	  method="ProcApprover" 
	  orgunit="#Invoice.OrgUnitOwner#"  
	  returnvariable="accessreq">	
	 
     <td class="labelmedium2" style="padding-left:33px"><cf_tl id="Amount">:</TD>
	 
     <td colspan="1" class="labelmedium2">
		   
		   <table cellspacing="0" cellpadding="0">		   
		       
		      <tr>
		   
		       <cfif parameter1.InvoiceRequisition eq "1">
				  
				   <cfquery name="checkmatch" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT    ISNULL(SUM(DocumentAmountMatched),0) AS Total
					FROM      InvoicePurchase
					WHERE     InvoiceId = '#url.id#'
				   </cfquery>					   			   
				   
				   <cfif abs(checkmatch.total-Invoice.DocumentAmount) gte 0.03>
				   
				     <cfset diff = abs(checkmatch.total-Invoice.DocumentAmount)>

  				     <cfset documententrystatus = "0">
					 <td bgcolor="FF0000" class="labelmedium2" style="font-size:24px;border:1px solid black;padding-left:6px;padding-right:6px">				  
				  	  <cfoutput>
					  	<font color="FFFFFF">#Invoice.DocumentCurrency#&nbsp;#NumberFormat(Invoice.DocumentAmount,",.__")#&nbsp;&nbsp;&nbsp;<cf_tl id="Difference">&nbsp;#NumberFormat(diff,",__.__")#
					  </cfoutput>				 
					  </td> 	 
					 
				   <cfelse>
				   
				   	 <td class="labelmedium2" style="font-size:27px">				  
				  	  <cfoutput><font size="3">#Invoice.DocumentCurrency#</font>&nbsp; #NumberFormat(Invoice.DocumentAmount,",.__")#</cfoutput>				 
					 </td> 	 		 
				  					 
				   </cfif>
				   
				<cfelse>
				
					 <td class="labelmedium2" style="font-size:25px">				  
				  	  <cfoutput><font size="3">#Invoice.DocumentCurrency#</font>&nbsp; #NumberFormat(Invoice.DocumentAmount,",.__")#</cfoutput>				 
					 </td> 	    
				   
				</cfif>  
		   			     		      				  
				  <td class="labelmedium2" style="padding-left:10px">	
				 			 	
				    									  					 
				   <cfif Invoice.ActionStatus eq "0" and (Post.recordcount eq "0" or getAdministrator("*") eq "1") and (session.acc eq Invoice.OfficerUserId or AccessReq eq "ALL")>
				  
				       <cfoutput>
					   
				       		<img onclick="edit()" 
							     style="cursor:pointer" 
								 src="#SESSION.root#/images/edit.gif" 
								 height="14" 
								 width="14" 
								 alt="Edit Payable amount" 
								 border="0">					  
								 
					   </cfoutput>
				  </cfif>
				  
				  </td>
				  
				  <cfparam name="html" default="No">
				  
				   <cfoutput>
					   <td class="hide" id="refreshamount" onclick="Prosis.busy('yes');ptoken.location('InvoiceMatch.cfm?html=#html#&id=#url.id#')">
					   <cf_tl id="refresh">
					   </td>
				   </cfoutput>			
				  
			  </tr>				  
			  
			</table>			
	  </td>
	   
	  <!--- posted ---> 
	  
	  <cfif GLCheck.recordcount eq "1">
	
	     <TD class="labelmedium2"><cf_tl id="Posted Amount">:</TD>
	     <td colspan="1" class="labelmedium2">	
		 <cfoutput>
		      <a href="javascript:ShowTransaction('#GLCheck.Journal#','#GLCheck.JournalSerialNo#','1','tab','z','z')">
			  <font color="2894FF">
		 	  #GLCheck.DocumentCurrency# #NumberFormat(GLCheck.DocumentAmount,",.__")#&nbsp;
			  </font>
			  </a>
		  </cfoutput>	  
		  </td>	  
		  
	  <cfelse>
	  
	   <td class="labelmedium2"><cf_tl id="Period">:</td>
	   <td colspan="1" class="labelmedium2"><cfoutput>#Invoice.Period#</cfoutput></td>	  
	  		  		
	  </cfif>		   
	   
   </tr>  
   
   <!--- --------------------- --->
   <!--- Currently ONLY for UN --->
   <!--- --------------------- --->
   
   <cfif Invoice.ReconciliationNo neq "">
   
	   <cfquery name="Reconcile" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   stReconciliation
			WHERE  ReconciliationNo = '#Invoice.ReconciliationNo#'
		</cfquery>
   
        <cfoutput>
		
	       <tr class="line">	  
		       <TD height="20" style="padding-left:33px" class="labelmedium2"><cf_tl id="Reconciliation">:</TD>
	              <td colspan="1" class="labelmedium2">	 
	    	       	  <font color="FF8040">#dateformat(Reconcile.Created,CLIENT.DateFormatShow)#	  
	   		   </td>	
			   <cfif Reconcile.OfficerLastName neq "">
				   <td class="labelmedium2"><cf_tl id="Officer">:</td>
				   <td class="labelmedium2">#Reconcile.OfficerFirstName# #Reconcile.OfficerLastName#</td>
			   </cfif>			   
		   </TR>
		   
		   <cfif Invoice.Mission eq "OICT" or Invoice.Mission eq "CMP">
		   
			   <tr><td></td><td colspan="3">
			   
			    <cfquery name="IMISDetail" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    R.DocumentCode, R.DocumentId1, R.InvoiceNo, R.Currency, R.DocumentAmount
					FROM      stReconciliationIMIS AS I INNER JOIN
					          stLedgerIMIS AS R ON I.TransactionSerialNo = R.TransactionSerialNo
					WHERE     I.ReconciliationNo = '#Invoice.ReconciliationNo#'
					AND       (R.documentamount >= '#Invoice.DocumentAmount-0.5#' and R.documentamount <= '#Invoice.DocumentAmount+0.5#')
				</cfquery>
				
				<table width="60%" bgcolor="ffffcf" style="border:1px dotted silver" cellspacing="0" cellpadding="0" class="formpadding">
				
				<cfif IMISDetail.recordcount eq "0">
				
					<cfquery name="IMISDetail" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    R.DocumentCode, R.DocumentId1, R.InvoiceNo, R.Currency, R.DocumentAmount
						FROM      stReconciliationIMIS AS I INNER JOIN
						          stLedgerIMIS AS R ON I.TransactionSerialNo = R.TransactionSerialNo
						WHERE     I.ReconciliationNo = '#Invoice.ReconciliationNo#'
					</cfquery>
					
					<tr><td colspan="4" class="labelmedium2" bgcolor="ffffcf" align="center">Invoice was reconciled clustered with other payables</td></tr>				
				
				</cfif>
								
				<cfloop query="IMISdetail">
					<tr class="labelmedium2">
					   <td style="padding-left:2px">#DocumentCode#</td>
					   <td>#DocumentId1#</td>
					   <td>#InvoiceNo#</td>			   
					   <td align="right" style="padding-right:2px">#Currency# #numberformat(documentamount,",.__")#</td>
					</tr>   
				</cfloop>
				</table>
			   
			   </td></tr>
		  
		   </cfif>	   
		   
		</cfoutput>	
		
	</cfif>	
	
	<cfquery name="Cancelled" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
     SELECT  RL.*
     FROM    Invoice AS I INNER JOIN
             InvoicePurchase IP ON I.InvoiceId = IP.InvoiceId INNER JOIN
             Purchase P ON IP.PurchaseNo = P.PurchaseNo INNER JOIN
             RequisitionLine RL ON IP.RequisitionNo = RL.RequisitionNo
	 WHERE   RL.ActionStatus != '3' 
	 AND     I.InvoiceId = '#Invoice.Invoiceid#'
   </cfquery>
   
   <cfif cancelled.recordcount gte "1">
   
   <tr class="line"><td height="25" colspan="4" align="center" class="labelmedium2" bgcolor="FCD8A7">Alert: invoice mapped against obligation lines which have been disabled. <b>Contact your administrator.</td></tr>
   
   <tr><td colspan="4" style="padding-left:33px">
   <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
   
	   <cfoutput query="cancelled">
	   
	   	 <tr id="#requisitionno#_1" bgcolor="ffffdf" class="labelmedium2">
			
			   <td rowspan="2" align="left"></td>
	    	   <td>&nbsp;</td>		  
			   <td>#RequestDescription#</td>
			   <td><i>#OfficerLastName#</i></td>
	    	   <td align="right">#RequestQuantity#</td>
			   <td align="center">#QuantityUoM#</td>
			   <td align="right">#NumberFormat(RequestCostprice,",.__")#</td>
			   <td align="right" style="padding-right:5px">#NumberFormat(RequestAmountBase,",.__")#</td>			   
			   <td rowspan="2" align="center" valign="middle">			   
				   <cf_img icon="edit" onClick="javascript:ProcReqEdit('#requisitionno#','dialog');">			 									   
			   </td>
			   
			</tr>
			
	   </cfoutput>
	   
   </table>
   
   </td></tr>
      
   </cfif>
			  
    <cfif parameter1.InvoicePostingMode eq "1">		  
				 	 
		<!--- funding --->		
		
		<tr class="line"><td valign="top" class="labelmedium2" style="border-right:0px solid silver;padding-left:33px;padding-top:5px"><cf_tl id="Budget Charge"> :</td>		
			<td colspan="3" id="funding" valign="top" style="padding-left:4px;padding-top:5px">
				<cfinclude template="InvoiceMatchFunding.cfm">
			</td>
		</tr>	
						
	</cfif>	
	
	<!--- check invoices --->
	  
	<cfif Invoice.Description neq "">
 							  	   
		  <cfoutput>
	       <tr class="line labelmedium2">	  
		       <td style="padding-left:33px"><cf_tl id="memo">:</td>
	           <td colspan="3">#Invoice.Description#</td>	
		   </TR>
		   </cfoutput>	
			
	  </cfif>
		
	 <cfset url.mission = Invoice.Mission>		
	  	 			 		   
	  <tr class="line" style="height:30px">
	        <td style="padding-left:33px;padding-top:6px" valign="top" class="labelmedium2"><cf_tl id="Orginal invoice attachments">:</td>
			<td colspan="3" id="attach">
			   <cfset access = AccessReq>
			   <cfinclude template="../InvoiceEntry/InvoiceEntryAttachment.cfm">						
		    </td>
	  </tr>
	
	  <cfif accessreq eq "Edit">
		<tr class="line">
		    <td></td>
			<td colspan="3" class="labelmedium2">Attach related documents such an invoice original etc.</td>
		</tr>
	  </cfif>
		 
		 <tr><td height="5"></td></tr> 
			
 </table>
 
 <cfoutput>
 
 	<cfif Invoice.actionstatus eq "1">
	
		<script>
		 try {
		  se = document.getElementsByName("selected")
		  cnt = 0
		  while (se[cnt]) {
		    se[cnt].className = "hide"
			cnt++
		  }	} catch(e) {}
		</script>
	
	<cfelse>
	
		<script>
		 try {
		  se = document.getElementsByName("selected")
		  cnt = 0
		  while (se[cnt]) {
		      se[cnt].className = ""
			  cnt++
		  }	} catch(e) {}
		</script>		
	
	</cfif>	
		
   
 <script>
 	 Prosis.busy('no');
	 // labelling
     try {
 	 finlabel('INV','#url.id#','Invoice','#Invoice.mission#','#Invoice.DocumentCurrency#','#Invoice.DocumentAmount#','Yes','Purchase.dbo.RequisitionLineFunding','Multiple','98')
	 } catch(e) {}
 </script>
 
 </cfoutput>
 