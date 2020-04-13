
<table width="95%" align="center">
  
	  <tr class="noprint clsNoPrint">
	  <td colspan="2" align="center" height="20">
	  
	  <cfset url.mode = "view">
	  
	    <cfoutput>
	 
		<table cellspacing="0" cellpadding="0" width="100%" class="formpadding">
				
			<tr>				
			    <td>
				
				<div id="printTitle" style="display:none;"><cf_tl id="HARDCOPY General Ledger Transaction"></div>
				
				<cf_tl id="Print" var="1">
				<cf_button2 
	                id="printButton"
	                type="print" 
					mode="icon"
	                text="#lt_text#"
					height="21px"
					imageheight="25px"
					textColor="##808080"
					textSize="12px"
	                printTitle="##printTitle"
	                printContent=".printContent"
	                printCallback="$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;');">
					
				<!--- <cf_print mode="roundedbutton" label="screen print"> --->
				<!---source="#client.virtualdir#/Gledger/Application/Transaction/View/TransactionViewDetail.cfm?journal=#url.journal#&journalserialNo=#url.journalserialno#&summary=#url.summary#"--->
				
				</td>
						
		   <td align="right" height="20" width="200" class="labelmedium"><font color="808080"><cf_tl id="Hardcopy format">:&nbsp;</td>
			   <td class="labelmedium" width="130">
			  	  							   
			       <cfquery name="Document" 
		         	  datasource="AppsOrganization" 
	      			  username="#SESSION.login#" 
	        	  	  password="#SESSION.dbpw#">
	      			    SELECT * 
			       		FROM   Ref_EntityDocument 
	      				WHERE  EntityCode   = 'GLTransaction'
						AND    DocumentType = 'document'
	      			  </cfquery>
			   
			      <select name="printdocumentid" id="printdocumentid" style="width:200px" class="regularxl enterastab">
				 	
				   <option value="">-- <cf_tl id="Select"> --</option>	  
			       <cfloop query="Document">
				     <option value="#DocumentId#" <cfif DocumentId eq Transaction.PrintDocumentId>selected</cfif>>#DocumentCode# #DocumentDescription#</option>
				   </cfloop>
							  
				  </select>
			   			      
			   </td>
			   
			   <td width="130">
		 		 					
					<table class="formspacing"> 
			 
				     <tr>
					
					 <td style="padding-left:3px"></td>
					 <td>
					 <button onClick="present('mail')" type="button" class="button3">
					     <img src="#SESSION.root#/Images/Mail.png" alt="Send eMail" border="0" align="absmiddle" width="32" height="32">
					 </button>
					 </td>
					 <td>|</td>
					 <td>
					 <button onClick="present('pdf')" type="button" class="button3">
					    <img src="#SESSION.root#/Images/pdf.png" alt="Print" border="0" width="20" height="20" align="absmiddle">
					 </button>
					 </td>
					 <td>|</td>		
					 
					 </table>				
			
		       </td>
		   			
			   <td align="right">	
				
				   <table>
				   <tr><td>
				   <input type="radio" style="height:18;width:18" name="SummaryView" value="1" <cfif url.summary eq "1">checked</cfif> onClick="view('1')">
				   </td>
				   <td class="labelmedium" style="padding-left:2px;padding-right:8px"><cf_tl id="Standard view"></td>
				   <td style="padding-left:5px">
				   <input type="radio" style="height:18;width:18" name="SummaryView" value="0" <cfif url.summary eq "0">checked</cfif> onClick="view('0')">
				   </td>
				   <td class="labelmedium" style="padding-left:2px;padding-right:8px"><cf_tl id="Full view"></td>
				   
				   
					   <td style="padding-left:5px">
					   <input type="radio" style="height:18;width:18" name="SummaryView" value="0" <cfif url.summary eq "9">checked</cfif> onClick="view('9')">
					   </td>
					   <td class="labelmedium" style="padding-left:2px"><cf_tl id="Edit"></td>
				 
				   </table>
				   
				</td>
				
			</tr>
		</table>	
		
		</cfoutput>		
			
	  </td></tr>	
	  
  <style>
	   td.cellborder {
		border : 1px solid silver;	
	   } 	    
  </style>
      
  <tr>
    <td width="100%" colspan="2">
	
    <table border="0" cellpadding="0" width="100%" class="formpadding">
      <tr>
        <td width="25%" height="20" style="padding-left:3px" class="labelmedium"><cf_tl id="Journal">:</td>
        <td width="25%" style="padding-left:3px" class="labelmedium"><cf_tl id="SerialNo">:</td>
        <td width="25%" style="padding-left:3px" class="labelmedium"><cf_tl id="Source">:</td>
        <td width="25%" style="padding-left:3px" class="labelmedium">
		   <cfoutput query="Transaction">
			    <cfif TransactionSource is "InvoiceSeries">
					<cf_tl id="PurchaseNo">:
				<cfelseif TransactionSource is "WorkOrderSeries">
	     			<cf_tl id="InvoiceNo">:	
	    		<cfelse>
					<cf_tl id="Reference">:
					
		    	</cfif>
			</cfoutput>
		</td>
      </tr>
	    	  
	  <cfif Transaction.RecordStatus eq "9">
	    <cfset cl = "FED7CF">
	  <cfelseif Transaction.ActionStatus eq "1">
	    <cfset cl = "e5e5e5">
	  <cfelse>
	  	<cfset cl = "ffffaf">
	  </cfif>
	 
	 
      <tr>
        <td height="23" width="25%" style="font-size:19px;padding-left:3px;border:1px solid gray;font-weight:200" bgcolor="<cfoutput>#cl#</cfoutput>" class="cellborder labelmedium" align="center" ><CFOUTPUT query="Transaction">#TransactionCategory# [#Journal#]</b></font>
		<cfset jrn = Journal>
		</cfoutput></td>
		<td width="25%" style="font-size:19px;padding-left:3px;border:1px solid gray;font-weight:200" bgcolor="<cfoutput>#cl#</cfoutput>" class="cellborder labelmedium"  align="center" ><CFOUTPUT query="Transaction">#JournalSerialNo#</font></cfoutput>
		<cfif Transaction.RecordStatus eq "9"><b><cf_tl id="Voided"></cfif>
		</td>
        <td width="25%" style="padding-left:3px;border-top:1px solid gray" class="cellborder labelmedium" align="center" ><CFOUTPUT query="Transaction">#TransactionSource# <cfif Reference neq "">(#Reference#)</cfif></font></cfoutput></td>
        <td width="25%" style="padding-left:3px;border-top:1px solid gray" class="cellborder labelmedium" align="center" ><CFOUTPUT query="Transaction">
		
		<cfif JournalBatchNo neq "">#JournalBatchNo#/</cfif>
		
		<cfif access eq "EDIT" or access eq "ALL">
		
			<cfif TransactionSource is "PurchaseSeries" or TransactionCategory eq "Purchase">
		     <A HREF ="javascript:ProcPOEdit('#JournalTransactionNo#','','tab')">#JournalTransactionNo#</A>
			<cfelseif TransactionSource is "WorkOrderSeries">
			
			 <cfif TransactionSourceNo eq "Medical">
			 
			    <a href ="javascript:workorderview('#ReferenceId#','medical')">
			    <font color="0080C0">
				</a>
			 
			 <cfelse>		
			 			 
			 	 <cfif TransactionSourceNo neq "">							
				 
					 <cfquery name="getBatch" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT       *
						FROM         WarehouseBatch
						WHERE        BatchNo ='#TransactionSourceNo#'									
					</cfquery>	
					 
					 <cfif get.recordcount eq "1">
					 
					 	<a href="javascript:batch('#getBatch.BatchNo#')">#getBatch.BatchNo#</a>&nbsp;|
					 
					 </cfif>
				 				
				 </cfif>

				 <cfquery name="getWorkOrder" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT       WL.*
					FROM         ItemTransaction T , WorkOrder.dbo.WorkOrderLine WL
			    	WHERE        T.TransactionId = '#ReferenceId#'				
					AND          T.WorkOrderId   = WL.WorkOrderId
					AND          T.WorkOrderLine = WL.WorkOrderLine
				</cfquery>	
				
				<cfif getWorkOrder.workorderlineid neq "">
				
				      <A HREF ="javascript:editworkorderline('#getWorkOrder.WorkOrderLineId#')">#getWorkOrder.Source#</a>
					  
				<cfelse>		
									 			 			 	 
					  <A HREF ="javascript:workorderview('#TransactionSourceId#','generic')">#JournalTransactionNo#</a>
					  
				</cfif> 	
								
			 </cfif>			
			
			<cfelseif TransactionSource is "InsuranceSeries">
			
				<a href ="javascript:showclaim('#ReferenceId#','#Mission#')">#JournalTransactionNo#</a>
				
			<cfelseif TransactionCategory eq "Reservation">
			
			 	<a href ="javascript:ProcReqEdit('#JournalTransactionNo#','','tab')">#JournalTransactionNo#</a>
				
			<cfelseif TransactionSource is "WarehouseSeries">
							
				<cfquery name="getBatch" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT       *
					FROM         WarehouseBatch
					WHERE        BatchNo ='#TransactionSourceNo#'									
				</cfquery>	
					
				<a href="javascript:batch('#getBatch.BatchNo#')">#getBatch.BatchNo#</a>			 
				
			<cfelse>#JournalTransactionNo#</cfif> 
					
		<cfelse>
		
			#JournalTransactionNo#
		
		</cfif>		
		
		</cfoutput></td>
      </tr>
    </table>
    </td>
  </tr>  
  
  <tr>
  
   <td width="100%" colspan="2" height="39">
     <table border="0" cellpadding="0" width="100%">
      <tr>
        <td width="100" style="padding-left:3px" class="labelmedium"  bgcolor="fafafa"><cf_tl id="Transaction date">:</td>
		<td width="80" style="padding-left:3px" class="labelmedium"  bgcolor="fafafa"><cf_tl id="Transaction period">:</td>
        <td width="30%" colspan="2" style="padding-left:3px" class="labelmedium"  bgcolor="fafafa">
			<cfif operational eq "1" and Transaction.Reference eq "Invoice">
			<cf_tl id="InvoiceNo and Memo"> :
			<cfelse>
			<cf_tl id="Description">:
			</cfif>
		</td>
		
		<td colspan="3" bgcolor="fafafa" height="20">
		
			<cf_space spaces="85">
			<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			<tr>
		        <td width="24%" style="padding-left:3px" class="labelmedium"><cf_tl id="Fiscal">:</td>
	    	    <td width="38%" style="padding-left:3px" class="labelmedium"><cf_tl id="Amount">:</td>
				<cfif JournalList.TransactionCategory is "Payables" or 
			     	  JournalList.TransactionCategory is "DirectPayment" or 
				  	  JournalList.TransactionCategory is "Receivables" or				   
				  	  JournalList.TransactionCategory is "Advances">
		    	<td width="38%" style="padding-left:3px" class="labelmedium"><cf_tl id="Outstanding">:</font></td>
				</cfif>
			</tr>
			</table>       
			
		</td>
			
      </tr>	    
	  	  
	  <CFOUTPUT query="Transaction">
	  	  
      <tr>
        <td height="20" align="center" class="cellborder labelmedium">#DateFormat(TransactionDate, CLIENT.DateFormatShow)#</td>
		<td height="20" align="center" class="cellborder labelmedium">#TransactionPeriod#</td>
        <td width="30%" colspan="2" class="cellborder labelmedium" style="padding-left:2px">
		
		<cfif operational eq "1" and Reference eq "Invoice">
				
			<cfquery name="Invoice" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  Invoice 
				WHERE InvoiceId = '#ReferenceId#'
			</cfquery>
						
			<cfif access eq "EDIT" or access eq "ALL">								
			<a href="javascript:invoiceedit('#referenceid#')">#ReferenceNo# #Invoice.Description#</a>
			<cfelse>
			#ReferenceNo# #Invoice.Description#
			</cfif>
			
		<cfelseif operational eq "1" and Reference eq "Billing"  and TransactionSource is "WorkOrderSeries">	
				
			 <A HREF ="javascript:workorderview('#ReferenceId#')">
			 <font color="0080C0">#Reference# #ReferenceNo#</font>
			</a>
		
		<cfelseif operational eq "1" and ReferenceOrgUnit neq "">
				
			<!--- and Reference eq "Service Charge" --->
		
			<cfquery name="Org" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM  Organization
				WHERE OrgUnit = '#ReferenceOrgUnit#'
			</cfquery>
		 
		   <cfif access eq "EDIT" or access eq "ALL">				
		   
		   	   <!--- <a href="javascript:serviceedit('#referenceid#')"><font face="Calibri" size="2" color="0080FF">#Org.OrgUnitName# #Description#</a> --->
			   <cfif JournalList.TransactionCategory neq "Payment" and JournalList.TransactionCategory neq "DirectPayment" and ReferenceName neq "">
			   #Org.OrgUnitName#
			   </cfif>
			    #Description#
			   
		   <cfelse>
		   	   <cfif JournalList.TransactionCategory neq "Payment" and JournalList.TransactionCategory neq "DirectPayment" and ReferenceName neq "">	
			   #Org.OrgUnitName#
		   	   </cfif>
			    #Description#
		   </cfif>
		
		<cfelse>				
			
			#Description#
			
		</cfif>
		</td>
		
		<td class="cellborder" colspan="3">
		
			<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			<tr>
		        <td width="24%" align="center" bgcolor="D3E9F8" class="labelmedium" style="height:24px;padding-left:5px">#AccountPeriod#</b></font></td>
	    	    <td width="38%" class="labelmedium" align="right" style="padding-right:3px"><font size="2">#Currency#</font> #NumberFormat(Amount,',.__')#</font></td>
				<cfif JournalList.TransactionCategory is "Payables" or 
			      JournalList.TransactionCategory is "DirectPayment" or 
				  JournalList.TransactionCategory is "Receivables" or
				  JournalList.TransactionCategory is "Advances"> 
			  
			    		<cfif amountOutstanding neq "0">
						<td width="38%" align="right" bgcolor="FEE3DE" class="labelmedium" style="padding-left:7px;padding-right:4px;border-left:1px solid silver">						
						<font color="FF0000">#NumberFormat(AmountOutstanding,',.__')#
						</td>
						<cfelse>
						<td width="38%" align="right" style="padding-left:7px;padding-right:4px;border-left:1px solid silver" class="labelmedium">						
						<font color="00BB00"><cf_tl id="nihil">
						</td>
						</cfif>						
						
				
				</cfif>
			</tr>
			</table>
		
		</td>
		
      </tr>
	  	  
	  <tr class="line labelmedium">
	   <td width="20%" style="padding-left:3px"><cf_tl id="Document Date">:</td>      
       <td style="padding-left:3px" width="20%"><cf_tl id="Officer">:</td>
	   <td style="padding-left:3px" width="20%"><cf_tl id="Recorded">:</td>
	   <td style="padding-left:3px" width="20%"><cf_tl id="Reference">:</td>
	   <cfif ActionBankId neq "">
	   <td style="padding-left:3px" width="15%"><cf_tl id="Reconciliation"></td>
	   </cfif>
	   <td height="20" style="padding-left:3px" width="15%"><cf_tl id="Amount">:</td>		
      </tr>
	   
	   <tr class="labelmedium">
	    <td align="center">#dateformat(DocumentDate, CLIENT.DateFormatShow)#</td>    
        <td align="center">#OfficerFirstName# #OfficerLastName# (#OfficerUserId#)</b></td>
		<td align="center">#dateformat(created, CLIENT.DateFormatShow)# #timeformat(created, "HH:MM")#</td>
		<td align="center">
		
		<cfif ReferencePersonNo neq "">
		
			<cfquery name="Person" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM     Person
					WHERE    PersonNo     = '#ReferencePersonNo#' 
			</cfquery>
			
			<cfquery name="Applicant" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM     Applicant
					WHERE    PersonNo     = '#ReferencePersonNo#' 
			</cfquery>
			
			<cfif Person.recordcount eq "1">		
			
				<a href="javascript:EditPerson('#ReferencePersonNo#','','travel')">#ReferenceName#</a>
				
			<cfelseif Applicant.recordcount eq "1">
			
				<a href="javascript:ShowCandidate('#ReferencePersonNo#','','travel')">#ReferenceName#</a>
			
			<cfelse>
			
			#ReferenceName#
						
			</cfif>
		
		<cfelse>#ReferenceName#</cfif>
		
		</td>
		
		<cfif Transaction.ActionBankId neq "">
		
			<cfquery name="Bank" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM     Ref_BankAccount
				WHERE    BankId       = '#Transaction.ActionBankId#' 
			</cfquery>
	
			<td align="center">#Bank.BankName#</td>
		
		</cfif>
		
		<td height="23" align="right" style="padding-right:8px">#documentcurrency# #NumberFormat(DocumentAmount,',.__')#</td>		

      </tr>
	  </cfoutput>
	  	  
    </table>
    </td>
  </tr>
  
  
  <!--- show actions with regards to the header --->
        
  <cfquery name="Action" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   R.Code, 
			         R.Description, 
					 T.ActionId,
					 T.ActionMode,
					 T.ActionStatus,
					 T.ActionReference1,
					 T.ActionReference2,
					 T.ActionReference3,
					 T.ActionReference4,
					 T.ActionDate
			FROM     TransactionHeaderAction T, Ref_Action R
			WHERE    T.ActionCode      = R.Code
			AND      T.Journal         = '#Journal#'
			AND      T.JournalSerialNo = '#JournalSerialNo#'
			AND      R.Code = 'Invoice'
			ORDER BY R.Code, ActionDate DESC
 </cfquery>
   
 <cfoutput query="Action" group="Code">
  
	 <cfoutput>
	 
	 <tr><td colspan="2" height="20" bgcolor="f4f4f4">
	 <table cellspacing="0" width="100%" cellpadding="0" class="formspacing">
	 <tr class="labelmedium">	   
	    <td style="border:0px solid silver;padding-left:4px" width="20%">#Description#:<cf_space spaces="30"></td>
		<td align="center" width="90" style="background-color:ffffcf;border:1px solid silver;padding-left:3px;padding-right:3px">#dateformat(ActionDate,CLIENT.DateFormatShow)#</td>
		<td align="center" style="background-color:ffffcf;border:1px solid silver;padding-left:3px;padding-right:3px" width="20">#ActionStatus#</td>
		<td align="center" style="background-color:ffffcf;border:1px solid silver;padding-left:3px;padding-right:3px" width="20">#ActionMode#</td>
		<td align="center" style="background-color:ffffcf;border:1px solid silver;padding-left:3px;padding-right:3px" width="15%">#ActionReference1#</td>
		<td align="center" style="background-color:ffffcf;border:1px solid silver;padding-left:3px;padding-right:3px" width="15%">#ActionReference2#</td>
		<td align="center" style="background-color:ffffcf;border:1px solid silver;padding-left:3px;padding-right:3px" width="15%">#ActionReference3#</td>
		<td align="center" style="background-color:ffffcf;border:1px solid silver;padding-left:3px;padding-right:3px" width="15%">#ActionReference4#</td>
	  </tr>
	  
	  <cf_filelibraryCheck
			DocumentPath="LedgerAction"
			SubDirectory="#Journal#\#JournalSerialNo#" 
			Filter="#code#_#actionid#">	
					
	  <cfif files gte "1">
			
		  <tr>	
		    <td></td>
			<td colspan="7" width="80%">
					 			 
					<cf_filelibraryN
							DocumentPath="LedgerAction"
							SubDirectory="#Journal#\#JournalSerialNo#" 
							Filter="#code#_#ActionId#"
							Insert="no"
							color="ffffef"
							Remove="no"
							reload="true">		 				 
			
			</td>
		 
		 </tr>
	 
	 </cfif>
	 
	 </table>	 
	 
	 </td></tr>	 
	 
	 </cfoutput>
	 
 </cfoutput>
        	      
      
  <cfoutput query="Transaction">
    
  	  <cfif TransactionSource eq "WorkOrderSeries">
	  
	     <tr>
		    <td width="100%" colspan="2" height="39">
			
		    <table border="0" style="border:0px dotted silver" bordercolor="e4e4e4" width="100%">
		      <tr>
		        <td width="50%" height="20" class="labelmedium" bgcolor="fafafa" colspan="2" style="border-bottom:1px dotted silver;padding-left:5px">
    			<cf_tl id="Customer">:				
				</td>
		        <td width="50%" class="labelmedium" colspan="2" style="padding-left:2px;border-bottom:1px dotted silver" bgcolor="fafafa"><cf_tl id="Discount terms"></td>
		      </tr>
			  
		      <tr>
		        <td height="20" bgcolor="fafafa" width="25%" style="padding-left:15px;" class="labelmedium"><cf_tl id="Name">:</td>
		        <td width="25%" class="cellborder labelmedium" style="padding-left:5px">																	
					  <cfif referenceOrgUnit neq "0" and referenceOrgUnit neq ""><A HREF ="javascript:viewOrgUnit('#ReferenceOrgUnit#')"><font color="0080C0"></cfif>#ReferenceName#</a>			
				</td>				
		        <td width="25%" bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Days">:</td> 		
		        <td width="25%" class="cellborder labelmedium" style="padding-left:5px">#ActionDiscountDays#</b></td>
		      </tr>
		      <tr>
		        <td height="20" bgcolor="fafafa" width="25%" style="padding-left:15px" class="labelmedium"><cf_tl id="Terms">:</td>
				<td width="25%" class="cellborder labelmedium" style="padding-left:5px">#ActionDescription#</b></td>
				<td width="25%" bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Discount date">:</td>
		 		<td width="25%" class="cellborder labelmedium" style="padding-left:5px">#DateFormat(ActionDiscountDate, CLIENT.DateFormatShow)#</font></td> 		
		      </tr>
		      <tr>
		        <td height="20" bgcolor="fafafa" width="25%" style="padding-left:15px" class="labelmedium"><cf_tl id="Due date">:</td>
		        <td width="25%" class="cellborder labelmedium" style="padding-left:5px">#DateFormat(ActionBefore, CLIENT.DateFormatShow)#</b></td>		
		        <td width="25%" bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Discount"> %:</td>
		        <td width="25%" class="cellborder labelmedium" style="padding-left:5px"><cfif ActionDiscount gt 0>#NumberFormat(ActionDiscount*100,'__._')#%</cfif></b>
				</td>
		      </tr>
			  
			    <cf_customField 
				     mode="view" 
				     TopicClass="header"
				     journal="#URL.Journal#" 
					 journalserialno="#URL.JournalSerialNo#">
			  
			  </table>
		    </td>
		  </tr>
		  
	  
	  	 <cfif url.summary eq "0">
	  			
			<cfquery name="getMode" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
				SELECT   S.ServiceMode
				FROM     WorkOrder W INNER JOIN ServiceItem S ON W.ServiceItem = S.Code
				WHERE    W.WorkOrderId = '#referenceid#'			
			</cfquery>			
			
			<cfif getMode.ServiceMode eq "WorkOrder">
			
				<cf_dialogmaterial>
			
				<tr>
					<td colspan="2" align="center" height="39" style="border:0px solid silver;padding-left:10px;padding-right:5px">
					<cfset url.workorderid = referenceid>
					<cfinclude template="TransactionViewDetailWorkOrder.cfm"> 										
					</td>						
				</tr>			
			
			<cfelse>
				  
				<!--- get details from the lines to be changed --->
				
				<cfquery name="ChargeDetails" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				SELECT   u.Description AS UnitClass, 			         
						 s.Currency, 
						 s.TransactionAmount, 						 
						 w.Reference, 
						 p.PersonNo, 
						 p.IndexNo, 
						 p.LastName, 
						 p.FirstName
				FROM     TransactionHeaderWorkOrder AS s INNER JOIN
	                     WorkOrder.dbo.WorkOrderLine AS w ON s.WorkorderId = w.WorkOrderId AND s.WorkorderLine = w.WorkOrderLine INNER JOIN
	                     WorkOrder.dbo.Ref_UnitClass AS u ON s.UnitClass = u.Code LEFT OUTER JOIN
	                     Employee.dbo.Person AS p ON w.PersonNo = p.PersonNo
				WHERE    s.Journal         = '#Journal#'
				AND      s.JournalSerialNo = '#journalSerialNo#'	
				ORDER BY u.description		
				</cfquery>
				
				<cfif ChargeDetails.recordcount neq "0">
				
					<tr>
					    <td width="100%" colspan="2" height="39" style="border:0px solid silver;padding-left:10px;padding-right:5px">
							
							<cfif chargedetails.recordcount gt "8">
													
								<cf_divscroll height="200" style="padding-right:10px">
									<cfinclude template="TransactionViewDetailService.cfm"> 
								</cf_divscroll>						
								
							<cfelse>
							
							   <cfinclude template="TransactionViewDetailService.cfm">
							   
							</cfif>
												
							
						</td>
					</tr>		
				
				</cfif>		
				
			</cfif>	
				
		</cfif>		
		
	   <cfelseif TransactionSource is "SalesSeries">
		        
		  <tr>
		    <td width="100%" colspan="2" height="39">
			
		    <table border="0" bordercolor="e4e4e4" width="100%">
		      <tr>
		        <td width="50%" height="20" class="labelmedium" bgcolor="fafafa" colspan="2" style="border-bottom:1px dotted silver;padding-left:5px">
				<cfif ReferencePersonNo eq ""> 
					<cf_tl id="Transaction Reference">
				<cfelse>
					<cf_tl id="Employee">		
				</cfif>
				</td>
		        <td width="50%" class="labelmedium" colspan="2" style="padding-left:2px;border-bottom:1px dotted silver" bgcolor="fafafa"><cf_tl id="Terms"></td>
		      </tr>
			  
		      <tr>
		        <td height="20" bgcolor="fafafa" width="20%" style="padding-left:15px;" class="labelmedium"><cf_tl id="Name">:</td>
		        <td width="30%" class="cellborder labelmedium" style="padding-left:5px">				
				
				<cfif operational eq "1" and Reference eq "Invoice" and ReferenceId neq "">
				
					<cfquery name="Invoice" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM  Invoice 
							WHERE InvoiceId = '#ReferenceId#'
					</cfquery>
								
					<a href ="javascript:viewOrgUnit('#Invoice.OrgUnitVendor#')"><b>#ReferenceName#</b></a>
								
					<cfquery name="Update" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE TransactionHeader
							SET    ReferenceOrgUnit = '#Invoice.OrgUnitVendor#'
							WHERE  TransactionId    = '#TransactionId#'
					</cfquery>
				
				<cfelse>
						
					<cfif ReferencePersonNo neq ""> 
					
					  <cfquery name="getPerson" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT * 
						FROM   Person
						WHERE  PersonNo = '#ReferencePersonNo#'				
					  </cfquery>	
									
					  <A HREF ="javascript:EditPerson('#ReferencePersonNo#')"><font color="0080C0">#getPerson.FirstName# #getPerson.LastName# (#getPerson.Nationality#)</a>
					  
					<cfelseif ReferenceOrgUnit neq "">   
					
					  <A HREF ="javascript:viewOrgUnit('#ReferenceOrgUnit#')"><font color="0080C0">#ReferenceName#</a>
					  
					<cfelse>
					
					 #ReferenceName# 
					 
					</cfif>
				   
				</cfif>
				
				</td>
				
		        <td width="20%" bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Days">:</td> 		
		        <td width="30%" class="cellborder labelmedium" style="padding-left:5px">#ActionDiscountDays#</b></td>
		      </tr>
			  
		      <tr>
		        <td height="20" bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Document">:</td>
				
				  <cfif TransactionSourceId neq "">
				  
				 	 <cfquery name="getBatch" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT * 
						FROM   WarehouseBatch
						WHERE  BatchId = '#TransactionSourceId#'				
					  </cfquery>	
				
					<td class="cellborder labelmedium" style="padding-left:5px"><a href="javascript:batch('#getBatch.BatchNo#')">#getBatch.BatchNo#</a></td>
				
			     <cfelse>
				 				
					<td class="cellborder labelmedium" style="padding-left:5px">#JournalTransactionNo#</td>
								 
				 </cfif>					 
				 
				<td bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Discount date">:</td>
		 		<td class="cellborder labelmedium" style="padding-left:5px">#DateFormat(ActionDiscountDate, CLIENT.DateFormatShow)#</font></td> 		
		      </tr>
		      <tr>
		        <td height="20" bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Due date">:</td>
		        <td class="cellborder labelmedium" style="padding-left:5px">#DateFormat(ActionBefore, CLIENT.DateFormatShow)#</b></td>		
		        <td bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Discount"> %:</td>
		        <td class="cellborder labelmedium" style="padding-left:5px"><cfif ActionDiscount gt 0>#NumberFormat(ActionDiscount*100,'__._')#%</cfif></b>
				</td>
		      </tr>
			  
			    <cf_customField 
				     mode="view" 
				     TopicClass="header"
				     journal="#URL.Journal#" 
					 journalserialno="#URL.JournalSerialNo#">
			  
			  </table>
		    </td>
		  </tr>
		  <cfif operational eq "1" and Reference eq "Invoice">
		  
		  		<cfquery name="Par" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					    SELECT *
					    FROM Ref_ParameterMission
						WHERE Mission = '#Mission#' 
				 </cfquery>
		  
		        <cf_filelibraryCheck
						DocumentPath="#Par.InvoiceLibrary#"
						SubDirectory="#ReferenceId#" 
						Filter="">	
						
				<cfif files gte "1">
			  
				    <tr>
				        <td colspan="2" style="padding-left:3px" height="19" class="labelmedium"><cf_tl id="Attachment">:</td>		
				    </tr>
					<tr><td colspan="2" height="1" class="line"></td></tr>
				  
					<tr><td colspan="2">
					 
					<cf_filelibraryN
							DocumentPath="#Par.InvoiceLibrary#"
							SubDirectory="#ReferenceId#" 
							Filter=""
							Insert="no"
							Remove="no"
							reload="true">	
					  
					  </td></tr>		 
				  
				 </cfif>		 
				  
		  </cfif>	 					
				    
	  <cfelseif TransactionSource is "PurchaseSeries" 	        
	       or TransactionCategory is "Payables" 
		   or TransactionCategory is "Memorial"
		   or TransactionCategory is "DirectPayment">
		        
		  <tr>
		    <td width="100%" colspan="2" height="39">
			
		    <table border="0" style="border:0px dotted silver" bordercolor="e4e4e4" width="100%">
		      <tr>
		        <td width="50%" height="20" class="labelmedium" bgcolor="fafafa" colspan="2" style="border-bottom:1px dotted silver;padding-left:5px">
				<cfif ReferencePersonNo eq ""> 
				<cf_tl id="Transaction Reference">
				<cfelse>
				<cf_tl id="Employee">		
				</cfif>
				</td>
		        <td width="50%" class="labelmedium" colspan="2" style="padding-left:2px;border-bottom:1px dotted silver" bgcolor="fafafa"><cf_tl id="Payment discount terms"></td>
		      </tr>
			  
		      <tr>
		        <td height="20" bgcolor="fafafa" width="25%" style="padding-left:15px;" class="labelmedium"><cf_tl id="Name">:</td>
		        <td width="25%" class="cellborder labelmedium" style="padding-left:5px">				
				
				<cfif operational eq "1" and Reference eq "Invoice" and ReferenceId neq "">
				
					<cfquery name="Invoice" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM  Invoice 
							WHERE InvoiceId = '#ReferenceId#'
					</cfquery>
								
					<a href ="javascript:viewOrgUnit('#Invoice.OrgUnitVendor#')"><b>#ReferenceName#</b></a>
								
					<cfquery name="Update" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE TransactionHeader
							SET    ReferenceOrgUnit = '#Invoice.OrgUnitVendor#'
							WHERE  TransactionId    = '#TransactionId#'
					</cfquery>
				
				<cfelse>
						
					<cfif ReferencePersonNo neq ""> 
					
					  <cfquery name="getPerson" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						SELECT * 
						FROM   Person
						WHERE  PersonNo = '#ReferencePersonNo#'				
					  </cfquery>	
									
					  <A HREF ="javascript:EditPerson('#ReferencePersonNo#')"><font color="0080C0">#getPerson.FirstName# #getPerson.LastName# (#getPerson.Nationality#)</a>
					  
					<cfelseif ReferenceOrgUnit neq "">   
					
					  <A HREF ="javascript:viewOrgUnit('#ReferenceOrgUnit#')"><font color="0080C0">#ReferenceName#</a>
					  
					<cfelse>
					
					 #ReferenceName# 
					 
					</cfif>
				   
				</cfif>
				
				</td>
				
		        <td width="25%" bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Days">:</td> 		
		        <td width="25%" class="cellborder labelmedium" style="padding-left:5px">#ActionDiscountDays#</b></td>
		      </tr>
		      <tr>
		        <td height="20" bgcolor="fafafa" width="25%" style="padding-left:15px" class="labelmedium"><cf_tl id="Invoice">:</td>
				<td width="25%" class="cellborder labelmedium" style="padding-left:5px">#ReferenceNo#</b></td>
				<td width="25%" bgcolor="fafafa" style="padding-left:15px" class="labelmedium">Discount date:</td>
		 		<td width="25%" class="cellborder labelmedium" style="padding-left:5px">#DateFormat(ActionDiscountDate, CLIENT.DateFormatShow)#</font></td> 		
		      </tr>
		      <tr>
		        <td height="20" bgcolor="fafafa" width="25%" style="padding-left:15px" class="labelmedium"><cf_tl id="Due date">:</td>
		        <td width="25%" class="cellborder labelmedium" style="padding-left:5px">#DateFormat(ActionBefore, CLIENT.DateFormatShow)#</b></td>		
		        <td width="25%" bgcolor="fafafa" style="padding-left:15px" class="labelmedium"><cf_tl id="Discount"> %:</td>
		        <td width="25%" class="cellborder labelmedium" style="padding-left:5px"><cfif ActionDiscount gt 0>#NumberFormat(ActionDiscount*100,'__._')#%</cfif></b>
				</td>
		      </tr>
			  
			    <cf_customField 
				     mode="view" 
				     TopicClass="header"
				     journal="#URL.Journal#" 
					 journalserialno="#URL.JournalSerialNo#">



		        <cf_filelibraryCheck
						DocumentPath="GlTransaction"
						SubDirectory="#TransactionId#" 
						Filter="">	
						
				<cfif files gte "1">
			  
				    <tr>
				        <td colspan="2" style="padding-left:3px" height="19" class="labelmedium"><cf_tl id="Attachment">:</td>		
				    </tr>
					<tr><td colspan="2" height="1" class="line"></td></tr>
				  
					<tr><td colspan="2">
					 
					<cf_filelibraryN
							DocumentPath="GlTransaction"
							SubDirectory="#TransactionId#" 
							Filter=""
							Insert="no"
							Remove="no"
							reload="true">	
					  
					  </td></tr>		 
				  
				 </cfif>	
			  
			  </table>
		    </td>
		  </tr>
	  
		  <cfif operational eq "1" and Reference eq "Invoice">
		  
		  		<cfquery name="Par" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					    SELECT *
					    FROM Ref_ParameterMission
						WHERE Mission = '#Mission#' 
				 </cfquery>
		  
		        <cf_filelibraryCheck
						DocumentPath="#Par.InvoiceLibrary#"
						SubDirectory="#ReferenceId#" 
						Filter="">	
						
				<cfif files gte "1">
			  
				    <tr>
				        <td colspan="2" style="padding-left:3px" height="19" class="labelmedium"><cf_tl id="Attachment">:</td>		
				    </tr>
					<tr><td colspan="2" height="1" class="line"></td></tr>
				  
					<tr><td colspan="2">
					 
					<cf_filelibraryN
							DocumentPath="#Par.InvoiceLibrary#"
							SubDirectory="#ReferenceId#" 
							Filter=""
							Insert="no"
							Remove="no"
							reload="true">	
					  
					  </td></tr>		 
				  
				 </cfif>		 
				  
		  </cfif>	  	  
	      
	  </cfif>    
       
  </cfoutput>
 
  <tr class="NoPrint clsNoPrint">
    <td width="100%" height="20" colspan="2">
         <table width="100%" class="formpadding">
		 
		 <cfset adv = 0>		 
		 
		  <cfif Transaction.AmountOutstanding gt 0.05 and Transaction.recordStatus eq "1" and (access eq "EDIT" or Access eq "ALL")>
	        										  
	          <cfif Transaction.TransactionCategory eq "Payables">
			  			  				
				 <tr><td colspan="3" height="1" class="line"></td></tr>
			  	 <tr><td colspan="3" style="height:40px">
				 
				   <table cellspacing="0" cellpadding="0">
					<tr><td class="labelmedium">	
			  
			      <cfquery name="CurPeriod"
	               datasource="AppsLedger" 
	               username="#SESSION.login#" 
	               password="#SESSION.dbpw#">
	              	   SELECT *
		               FROM   Ref_ParameterMission
					   WHERE  Mission = '#Transaction.Mission#'
	              </cfquery>
				  			  			  
				  <cfoutput>
				   	
						<a href="javascript:ProcessTransaction('#Transaction.Mission#','#Transaction.OrgUnitOwner#','Payment','#CurPeriod.CurrentAccountPeriod#')">
						<font color="0080C0"><cf_tl id="Submit a Payment Order">
						</a>
								      
				  </cfoutput>
				  
				  </td>				  
				  
				  <cfif Transaction.amountOutstanding gt "0">
					
						<td style="padding-left:10px;padding-right:10px">|</td>
						
						<td class="labelmedium">				
											  
					  	<cfoutput>
					   		<a href="javascript:CorrectTransaction('#Transaction.Journal#','#Transaction.JournalSerialNo#','Payables')">
						    <font color="0080C0"><cf_tl id="Record a discount">
							</a>
					   	</cfoutput>		
												
						<!--- check process access --->											
										
					 	<cfquery name="checkadvances"
			               datasource="AppsLedger" 
			               username="#SESSION.login#" 
			               password="#SESSION.dbpw#">					
								SELECT    TOP 10 
										  TransactionId,JournalTransactionNo,OfficerLastName,
										  TransactionDate,currency,ABS(Amount) Amount, ABS(AmountOutstanding) as AmountOutstanding

								FROM      TransactionHeader H
								WHERE     Mission             = '#get.Mission#'
								AND       (ReferenceOrgUnit    = '#get.ReferenceOrgUnit#')
								AND       TransactionCategory = 'Advances'
								--AND     Currency            = '#get.Currency#' 
								AND       ABS(AmountOutstanding) > 0.05
								AND  	  ActionStatus != '9'
								AND  	  RecordStatus != '9'
						
						<!--- only of journals to which the user has edit/all access --->
						
							<cfif getAdministrator("#Transaction.Mission#") eq "0">
								AND       Journal IN (SELECT ClassParameter 
							                      FROM   Organization.dbo.OrganizationAuthorization 
												  WHERE  Role        = 'Accountant'
												  AND    Mission     = '#get.Mission#'
												  AND    UserAccount = '#session.acc#'
												  AND    AccessLevel IN ('1','2'))
							</cfif>
												
							<!--- advance received --->
							AND   EXISTS (
							         SELECT 'X'
							         FROM   TransactionLine
									 WHERE  Journal             = H.Journal
									 AND    JournalSerialNo     = H.JournalSerialNo
									 AND    TransactionSerialNo = '0'
									 AND    AmountDebit        > 0
									 )
										 
							ORDER BY TransactionDate
						</cfquery>

						<cfif checkadvances.recordcount gte "1">
							<td style="padding-left:10px;padding-right:10px">|</td>
							<td class="labelmedium">
							<a href="javascript:toggleobjectbox('offset')">
								<cf_tl id="Offset against advance">
								
							</a>
							</td>			
						</cfif>	
						
						<!----functionality for offsetting against advance ---->
						
					</cfif>
					
					</tr>
					
					</table>
					
					</td>
				  				  
				  </tr>
				  
				  <cfif checkadvances.recordcount gte "1">
				  
					  <tr id="offset" class="hide"><td colspan="3" style="padding-left:15px">							  	
						
							<table width="100%" cellspacing="0" cellpadding="0">				
						
							<tr><td>
							
								<cfform name="offsetform" id="offsetform">
																
								<table width="100%" class="formspacing">
									<tr class="labelmedium line">
										<td><cf_tl id="Transaction"></td>
										<td><cf_tl id="Officer"></td>
										<td><cf_tl id="Date"></td>
										<td><cf_tl id="Currency"></td>
										<td align="right"><cf_tl id="Amount"></td>	
										<td align="right"><cf_tl id="Balance"></td>
										<td align="right"><cf_tl id="postingdate"></td>
										<td align="right"><cf_tl id="Offset"></td>
									</tr>
									
									<cfset amt = get.AmountOutstanding>									

									<cfset indexadvance=0>
									
									<cfoutput query="CheckAdvances">

										<cfset indexadvance = indexadvance + 1>
									
									    <input type="hidden" name="Advances" value="#transactionid#">
									    
										<tr class="labelmedium" style="height:15px">
										 <td style="height:20px">#JournalTransactionNo#</td>
										 <td>#OfficerLastName#</td>
										 <td>#dateformat(TransactionDate,client.dateformatshow)#</td>
										 <td>#currency#</td>
										 <td align="right">#numberformat(Amount,',.__')#</td>
										 <td align="right">#numberformat(AmountOutstanding,',.__')#</td>
										 <td align= "right">
										 	<cf_intelliCalendarDate9
			    							      FieldName="postingdate_#indexadvance#" 				 
												  class="regularxl enterastab"
			    		      					  Default="#Dateformat(now(), CLIENT.DateFormatShow)#">	
										 </td>	
										 <td align="right">

										 <cfif CheckAdvances.currency neq get.currency>
										   <cf_exchangeRate currencyFrom = "#CheckAdvances.currency#" currencyTo = "#get.currency#">
										   <cfset erate = exc>
										<cfelse>
											<cfset erate = 1>   
										</cfif> 

										<cfset val = amt * erate>
										<cfif val gt amountoutstanding>
											<cfset val = amountoutstanding>
										<cfelse>	
											<cfset val = val>	
										</cfif>
										
										<cfset amt = amt - (val / erate)>
										 <!-----
										 <cfif amt gt amountOutstanding>										 	
											<cfset offset = amountoutstanding>
										 <cfelse>											    
										 	<cfset offset = amt>											
										 </cfif>
										 <cfset amt = amt - offset>	
										 
										 <input class="regularxl" value="#offset#" type="text" name="Offset_#left(TransactionId,8)#" style="width:80px;text-align:right" maxlength="20">
										 ----->

										 <input type="hidden" 
											 name="out_#left(TransactionId,8)#"											 
											 id="out_#left(TransactionId,8)#"
											 value="#amountOutstanding#" 
											 size="10" 
											 maxlength="12" 											
											 class="regularxl enterastab" 
											 style="background-color:ffffcf;width:96%;height:23px;text-align:right;padding-top:0px">				
										
										
										<input type="text" 
											 name="amt_#left(TransactionId,8)#"					
											 id="amt_#left(TransactionId,8)#"									 
											 value="#NumberFormat(val,'_,____.__')#" 
											 size="10" 
											 maxlength="12" 
											 onchange="recalcline('#left(TransactionId,8)#')"
											 class="regularxl enterastab" 
											 style="background-color:ffffcf;width:96%;height:23px;text-align:right;padding-top:0px">																						
							
										 </td>
										 
										 <td align="right">
										 
										 <cfif CheckAdvances.currency eq get.currency>
												
											<input type="text" 
												 name="exc_#left(TransactionId,8)#" 
												 id="exc_#left(TransactionId,8)#"
												 value="#NumberFormat(1,',._____')#" 
												 size="10" 								 
												 maxlength="10" 
												 readonly
												 tabindex="9999"
												 class="regularxl enterastab" 
												 style="background-color:eaeaea;text-align: right;padding-top:0px;width:92%;height:23px;">
											 
										<cfelse>
																
											 <input type="text" 
												 name="exc_#left(TransactionId,8)#" 
												 id="exc_#left(TransactionId,8)#"
												 value="#NumberFormat(erate,',._____')#" 
												 size="10" 			
												 onchange="recalcline('#left(TransactionId,8)#')"				 
												 tabindex="9999"
												 maxlength="10" 							 
												 class="regularxl enterastab" 
												 style="background-color:ffffcf;text-align: right;padding-top:0px;width:92%;height:23px;">
										 
										</cfif>
										
										 </td>
										 
										 <td align="right">
										 
										 										    
											<cfset offset = val/erate>																								
										 										 
										 	<input type="text" 
												 name="off_#left(TransactionId,8)#" 
												 id="off_#left(TransactionId,8)#"
												 value="#NumberFormat(offset,'_,____.__')#" 
												 size="10" 
												 readonly
												 tabindex="9999"
												 maxlength="12" 
												 class="regularxl enterastab" 							 
												 style="text-align: right;padding-top:0px;width:92%;height:23px;">										 
										 
										 </td>
										</tr>
									</cfoutput>	
									
									<tr><td colspan="7" align="center">
									<cfoutput>
									
									<cf_tl id="Apply Offset" var="voffset">
									
									<input onclick="ptoken.navigate('#session.root#/Gledger/Application/Transaction/Offset/APOffsetSubmit.cfm?journal=#get.Journal#&JournalSerialNo=#get.JournalSerialNo#','offsetprocess','','','POST','offsetform')" 
									   type="button" style="width:160px" class="button10g" id="Offsetapply" name="Offsetapply" value="#voffset#">
									</cfoutput> 
									</td>
									</tr>
									<tr><td ><div id="offsetprocess" name="offsetprocess"></div></td></tr>
									
								</table>
								
								</cfform>
							
							</td></tr>
						
							</table>
						
						</td></tr>
					
					</cfif>				  				  
				 				   
			   <cfelseif Transaction.TransactionCategory eq "Receivables">				      

			      <cfquery name="CurPeriod"
	               datasource="AppsLedger" 
	               username="#SESSION.login#" 
	               password="#SESSION.dbpw#">
		               SELECT *
	    	           FROM   Ref_ParameterMission
					   WHERE  Mission = '#Transaction.Mission#'
	              </cfquery>
			   
				  <tr><td colspan="3" height="1" class="line"></td></tr>
				  <tr><td colspan="3" style="padding-left:4px;height:20px" class="labelmedium">
				  				  
				    <table cellspacing="0" cellpadding="0">
					<tr>		

				  	<cfif Transaction.TransactionSource eq "SalesSeries">

					 	<cfquery name="getMode"
	               		datasource="AppsMaterials"
	               		username="#SESSION.login#"
	               		password="#SESSION.dbpw#">
							SELECT    w.SaleMode
							FROM      WarehouseBatch AS wb INNER JOIN
				                      Warehouse AS w ON wb.Warehouse = w.Warehouse
							WHERE     wb.BatchId = '#Transaction.TransactionSourceId#'
						</cfquery>
				  		<!--- Cash and carry with receivable mode --->
						
						<cfif getMode.salemode eq "3">
				  		
						<cfoutput>
						
						<cfif dateformat(now(),client.dateSQL) gt dateformat(transaction.created,client.dateSQL)> 
						
						<td class="labelmedium">				  				  		
				   			<a href="javascript:ProcessTransaction('#Transaction.Mission#','#Transaction.OrgUnitOwner#','Banking','#CurPeriod.CurrentAccountPeriod#','#Transaction.Journal#','#Transaction.JournalSerialNo#')">
					    	<cf_tl id="Record a settlement">
							</a>
				   		</td>
						
						<cfelse>
						
				  		<td class="labelmedium">				  		
				   			<a href="javascript:PosSettlement('#url.id#')">
					    	<cf_tl id="Record a settlement">
							</a>				   		
						</td>
						
						</cfif>
						
						<td style="padding-left:10px;padding-right:10px">|</td>
				  		<td class="labelmedium">				  		
				   			<a href="javascript:PrintReceivable('#url.id#')">
					    	<cf_tl id="Invoice">
							</a>				   		
						</td>
						<td style="padding-left:10px;padding-right:10px">|</td>						
						</cfoutput>		
						
						<cfelse>
						
						<td class="labelmedium">				  
				  		<cfoutput>
				   			<a href="javascript:ProcessTransaction('#Transaction.Mission#','#Transaction.OrgUnitOwner#','Banking','#CurPeriod.CurrentAccountPeriod#','#Transaction.Journal#','#Transaction.JournalSerialNo#')">
					    	<cf_tl id="Record a settlement">
							</a>
				   		</cfoutput>		
						</td>
						<td style="padding-left:10px;padding-right:10px">|</td>	
						
						
						</cfif>					

					<cfelse>
					
						<td class="labelmedium">				  
				  		<cfoutput>
				   			<a href="javascript:ProcessTransaction('#Transaction.Mission#','#Transaction.OrgUnitOwner#','Banking','#CurPeriod.CurrentAccountPeriod#','#Transaction.Journal#','#Transaction.JournalSerialNo#')">
					    	<cf_tl id="Record a settlement">
							</a>
				   		</cfoutput>		
						</td>
						<td style="padding-left:10px;padding-right:10px">|</td>	
						
					</cfif>						
					
					<cfif Transaction.amountOutstanding gt "0">
					
						<td class="labelmedium">				  
					  
					  	<cfoutput>
					   		<a href="javascript:CorrectTransaction('#Transaction.Journal#','#Transaction.JournalSerialNo#','Receivables')">
						    <cf_tl id="Record a discount">
							</a>
					   	</cfoutput>		
						
						</td>
					
					</cfif>
					
					<!--- check process access --->
				  	<cftransaction isolation="serializable">
					
					 <cfquery name="checkadvances"
		               datasource="AppsLedger" 
		               username="#SESSION.login#" 
		               password="#SESSION.dbpw#">					
						SELECT    TOP 10 								
								  TransactionId,JournalTransactionNo,OfficerLastName,
								  TransactionDate,currency,ABS(Amount) Amount, ABS(AmountOutstanding) as AmountOutstanding
						FROM      TransactionHeader H
						WHERE     Mission = '#get.Mission#'
						<cfif get.TransactionSource eq "SalesSeries">
						AND       (ReferenceOrgUnit    = '#get.ReferenceOrgUnit#' <cfif getBatch.CustomerId neq "">OR ReferenceId = '#getBatch.CustomerId#'</cfif>)
						<cfelseif  get.TransactionSource eq "AccountSeries" AND get.ReferenceId neq "">
						AND       ReferenceId = '#get.ReferenceId#'
						<cfelse>
						AND       ReferenceOrgUnit    = '#get.ReferenceOrgUnit#'
					 	</cfif>
						AND       TransactionCategory = 'Advances'
											
						<!--- extend the usage 
						AND       Currency = 'QTZ' 
						--->
																		
						AND       ABS(AmountOutstanding) > 0.05
						AND  	  ActionStatus != '9'
						AND  	  RecordStatus != '9'
						
						<!--- only of journals to which the user has edit/all access --->
						
						<cfif getAdministrator("#Transaction.Mission#") eq "0">
						AND       Journal IN (SELECT ClassParameter 
						                      FROM   Organization.dbo.OrganizationAuthorization 
											  WHERE  Role    = 'Accountant'
											  AND    Mission = '#get.Mission#'
											  AND    UserAccount = '#session.acc#'
											  AND    AccessLevel IN ('1','2'))
						</cfif>
												
						<!--- advance received --->
						AND   EXISTS (
						             SELECT 'X'
						             FROM   TransactionLine
									 WHERE  Journal             = H.Journal
									 AND    JournalSerialNo     = H.JournalSerialNo
									 AND    TransactionSerialNo = '0'
									 AND    AmountCredit        > 0
									 )
									 
						 									 
						ORDER BY TransactionDate					
					</cfquery>
					</cftransaction>
					
					<cfif checkadvances.recordcount gt "0">
						<td style="padding-left:10px;padding-right:10px">|</td>
						<td class="labelmedium">
						<a href="javascript:toggleobjectbox('offset')">
							<cf_tl id="Offset against advance">							
						</a>
						</td>					
					</cfif>					
					
					</tr>					
					
					</table>		   
					
				  </td>
				  </tr>		
				  
				  <cfif checkadvances.recordcount gt "0">
				  
					  <tr id="offset" class="hide"><td colspan="3">							  	
						
							<table width="100%" cellspacing="0" cellpadding="0">				
						
							<tr><td>
							
								<!---- <form name="offsetform" id="offsetform"> ---->
								<cfform name="offsetform" id="offsetform">
								
								<table width="100%" class="formspacing">
									<tr class="labelmedium line">
										<td><cf_tl id="Transaction"></td>
										<td><cf_tl id="Officer"></td>
										<td><cf_tl id="Date"></td>
										<td><cf_tl id="Journal"></td>
										<td><cf_tl id="Currency"></td>
										<td align="right"><cf_tl id="Amount"></td>	
										<td align="right"><cf_tl id="Balance"></td>
										<td colspan="4" align="right"><cf_tl id="Offset"></td>
									</tr>
									
									<tr class="labelmedium line">
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
										<td align="right"></td>	
										<td align="right"></td>			
										<td align="right"><cf_tl id="posting date"></td>									
										<td align="right"><cf_tl id="Amount"></td>
										<td align="right"><cf_tl id="Exchange"></td>
										<td align="right"><cf_tl id="Offset"></td>
									</tr>
									
									<cfset amt = get.AmountOutstanding>									
									<cfset indexadvance=0>


									<cfoutput query="CheckAdvances">
										<input type="hidden" name="Advances" id="Advances" value="#transactionid#">
									
									<cfset indexadvance = indexadvance + 1>
										<tr class="labelmedium">

										 <td style="height:25px">#JournalTransactionNo#</td>
										 <td>#OfficerLastName#</td>
										 
										 <td>#dateformat(TransactionDate,client.dateformatshow)#</td>
										 <td>#Journal#</td>
										 <td>#currency#</td>
										 <td align="right">#numberformat(Amount,',.__')#</td>
										 <td align="right">#numberformat(AmountOutstanding,',.__')#</td>
										 <td align="right">
										 
										 	<cf_intelliCalendarDate9
			    							      FieldName="postingdate_#indexadvance#" 				 
												  class="regularxl enterastab"
			    		      					  Default="#Dateformat(now(), CLIENT.DateFormatShow)#">	

										 <td align="right"> 
										 <cfif currency neq get.currency>
							   
										   <cf_exchangeRate currencyFrom = "#currency#" currencyTo = "#get.currency#">
										   <cfset erate = exc>
							   
										<cfelse>
							
											<cfset erate = 1>   
														
										</cfif> 
										
										<!--- --------available------ --->
																														
										<cfset val = amt * erate>
										<cfif val gt amountoutstanding>
											<cfset val = amountoutstanding>
										<cfelse>	
											<cfset val = val>	
										</cfif>
										
										<cfset amt = amt - (val / erate)>
																		
										<input type="hidden" 
											 name="out_#left(TransactionId,8)#"											 
											 id="out_#left(TransactionId,8)#"
											 value="#amountOutstanding#" 
											 size="10" 
											 maxlength="12" 											
											 class="regularxl enterastab" 
											 style="background-color:ffffcf;width:96%;height:23px;text-align:right;padding-top:0px">														
										
										<input type="text" 
											 name="amt_#left(TransactionId,8)#"					
											 id="amt_#left(TransactionId,8)#"									 
											 value="#NumberFormat(val,',.__')#" 
											 size="10" 
											 maxlength="12" 
											 onchange="recalcline('#left(TransactionId,8)#')"
											 class="regularxl enterastab" 
											 style="background-color:ffffcf;width:96%;height:23px;text-align:right;padding-top:0px">																						
							
										 </td>
										 
										 <td align="right">
										 
										 <cfif currency eq get.currency>
												
											<input type="text" 
												 name="exc_#left(TransactionId,8)#" 
												 id="exc_#left(TransactionId,8)#"
												 value="#NumberFormat(1,',._____')#" 
												 size="10" 								 
												 maxlength="10" 
												 readonly
												 tabindex="9999"
												 class="regularxl enterastab" 
												 style="background-color:eaeaea;text-align: right;padding-top:0px;width:92%;height:23px;">
											 
										<cfelse>
																
											 <input type="text" 
												 name="exc_#left(TransactionId,8)#" 
												 id="exc_#left(TransactionId,8)#"
												 value="#NumberFormat(erate,',._____')#" 
												 size="10" 			
												 onchange="recalcline('#left(TransactionId,8)#')"				 
												 tabindex="9999"
												 maxlength="10" 							 
												 class="regularxl enterastab" 
												 style="background-color:ffffcf;text-align: right;padding-top:0px;width:92%;height:23px;">
										 
										</cfif>
										
										 </td>
										 
										 <td align="right">
										 
										 										    
											<cfset offset = val/erate>																								
										 										 
										 	<input type="text" 
												 name="off_#left(TransactionId,8)#" 
												 id="off_#left(TransactionId,8)#"
												 value="#NumberFormat(offset,'_,____.__')#" 
												 size="10" 
												 readonly
												 tabindex="9999"
												 maxlength="12" 
												 class="regularxl enterastab" 							 
												 style="text-align: right;padding-top:0px;width:92%;height:23px;">										 
										 
										 </td>
										 
										</tr>
									</cfoutput>	
									
									<tr><td colspan="11" align="center" style="padding-top:5px;border-top:1px solid silver">
									<cfoutput>
									<cf_tl id="Apply Offset" var="off">
									<input onclick="ptoken.navigate('#session.root#/Gledger/Application/Transaction/Offset/AROffsetSubmit.cfm?journal=#get.Journal#&JournalSerialNo=#get.JournalSerialNo#','offsetprocess','','','POST','offsetform')" 
									   type="button" style="width:260px" class="button10g" id="Offsetapply" name="Offsetapply" value="#off#">
									</cfoutput> 
									</td>
									</tr>
									<tr><td><div id="offsetprocess" name="offsetprocess"></div></td></tr>
								</table>
								
								</cfform>
							
							</td></tr>
						
							</table>
						
						</td></tr>
					
					</cfif>
				     
				  
	          </cfif>			  
			 
        </cfif>		
		  
		  </td></tr>
        </table>
     </td>
</tr>  

<!--- -------------------------- --->
<!--- A. show the posting lines- --->
<!--- -------------------------- --->

<cfif URL.Show eq "show">

  <tr>
  <td width="100%" colspan="2" id="postinglines" style="padding:0px;">  
     
	     <cfdiv bind="url:TransactionViewPosting.cfm?journal=#url.journal#&JournalSerialno=#url.JournalSerialno#&mode=#url.mode#&summary=#url.summary#" id="content">	  	
	 
 </td>
 </tr>
 
</cfif>
  
</table>  

 