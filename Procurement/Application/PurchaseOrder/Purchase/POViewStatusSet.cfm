
<cfparam name="url.st" default="2">

<cfquery name="Lines" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
			SELECT   H.Journal,
			         H.JournalSerialNo,
					 H.JournalTransactionNo, 
			         H.Description, 
					 H.Reference, 
					 H.TransactionId,
					 H.TransactionDate, 
					 TL.Currency, 
					 TL.AmountDebit, 
					 TL.AmountCredit, 
					 TL.GLAccount,
					 H.ReferenceName, 
					 H.ReferenceNo,
					 H.ActionStatus,
					 H.OfficerFirstName,
					 H.OfficerLastName
			FROM     TransactionHeader H INNER JOIN
			         TransactionLine TL ON H.Journal = TL.Journal AND H.JournalSerialNo = TL.JournalSerialNo
			WHERE    H.Reference   = 'Advance' 
			AND      H.ReferenceNo = '#URL.ID1#' 
			AND      TL.TransactionSerialNo != '0'
			ORDER BY H.TransactionDate
</cfquery>

<cfquery name="Invoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    * 
    FROM      Invoice
	WHERE     InvoiceId IN (SELECT InvoiceId
	                        FROM   InvoicePurchase 
							WHERE  PurchaseNo = '#URL.ID1#')
	AND       ActionStatus != '9'
	ORDER BY  DocumentDate
</cfquery>  

<cfoutput>

<table width="100%">

<tr>

<td style="height:25px;padding-left:6px">

	<table cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr>
				
	<td onClick="javascript: st('2')" style="cursor: pointer;padding-left:6px">
	    <input type="radio" class="radiol" name="StatusAction" id="StatusAction" value="2" <cfif url.st eq "2">checked</cfif>>
	</td>
	<td class="labelmedium" style="padding-left:3px;padding-right:3px">	
		<cfif url.st eq "2"><b></cfif><cf_tl id="Pending"></b>
	</td>
	
	<!--- cancel PO only allowed if there are no invoices recorded --->
	
	<cfif Lines.recordcount eq "0" and Invoice.recordcount eq "0">		
		
		<td onClick="javascript: st('0')" style="cursor: pointer;padding-left:6px">
		    <input type="radio" class="radiol" name="StatusAction" id="StatusAction" value="0" <cfif url.st eq "0">checked</cfif> ><cfif url.st eq "0"><b></cfif>
		</td>
		<td class="labelmedium" style="padding-left:3px;padding-right:3px">		
			<cf_tl id="Cancel Order">
		</td>
		
		<cfif url.st eq "0">
		
			<td><img src="#SESSION.root#/Images/light_red1.gif" alt="" name="img0_des" border="0" align="absmiddle"></td>						  
			<td align="left" style="padding-left:5px;padding-right:5px">
			      <input type="button" name="Approval" id="Approval" value="Submit" class="button10s" style="height:20px;width:100" onClick="return ask('0')">
			</td>
		
		</cfif>
	
		<td class="labelmedium" onClick="javascript: st('1')" style="cursor: pointer;padding-left:6px"> 
	    	<input type="radio" class="radiol" name="StatusAction" id="StatusAction" value="1" <cfif url.st eq "1">checked</cfif>></td>
			<td class="labelmedium" style="padding-left:3px;padding-right:3px">				
			<cfif url.st eq "1"><b></cfif><cf_tl id="Return  buyer"></b>
			</td>
			
	
	</cfif>	
	
	<cfif url.st eq "1">
	
		<td><img src="#SESSION.root#/Images/light_red1.gif" alt="" name="img0_des" border="0" align="absmiddle"></td>						  
		<td align="left">
		      <input type="button" name="Approval" id="Approval" style="width:100" value="Submit" class="button10g" onClick="return ask('1')">
		</td>
	 
	</cfif>
	
	<td class="labelmedium" onClick="javascript: st('3')" style="cursor: pointer;padding-left:6px"> 
	     <input type="radio" class="radiol" name="StatusAction" id="StatusAction" value="3" <cfif url.st eq "3">checked</cfif>>
		 </td>
		 <td class="labelmedium" style="padding-left:3px;padding-right:3px">		
			<cfif url.st eq "3"><b></cfif><cf_tl id="Issue Obligation"></b>
		</td>
		 
		
	</td>	
	
	<cfif url.st eq "3">
	
		  <td align="right" style="padding-left:4px;padding-right:4px>
		  	  <img src="#SESSION.root#/Images/light_green1.gif" alt="" name="img0_des" border="0" align="absmiddle">
		  </td>						  
		  <td align="left" style="padding-left:10px">
		      <input type="button" name="Approval" id="Approval" style="padding-left:5px;padding-right:5px;width:100" value="Submit" class="button10g" onClick="return ask('3')">
		  </td>
		  	 
	</cfif>
	
	</tr>
	
	</table>	 

</td>
</tr>

</table>

</cfoutput> 