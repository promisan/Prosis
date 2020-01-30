
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- custom workflow form --->

<cfset actionform = 'MarkDown'>

<cfparam name="URL.dialog" default="0">

<cf_dialogProcurement>

<cfajaximport tags="cfform,cfdiv">

<cfparam name="url.invoiceid" default="">
<cfparam name="Object.ObjectKeyValue4" default="#URL.InvoiceId#">

<cfoutput>

	<script>
	
	var ptday  = new Array();
	var ptdisc  = new Array();
	var ptdisd  = new Array();
	
	<cfquery name="Terms" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_Terms 
	</cfquery>
	
	<cfloop query="Terms">
	   ptday[#Code#]   = "#PaymentDays#";
	   ptdisc[#Code#]  = "#Discount#";
	   ptdisd[#Code#]  = "#DiscountDays#";
	</cfloop>
	
	function terms(selected) {
	     document.getElementById('actiondiscount').value      = ptdisc[selected];
		 document.getElementById('actiondiscountdays').value  = ptdisd[selected];
		 document.getElementById('actiondays').value          = ptday[selected]; 
	}
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	
	function more(bx,act) {
	
	    icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById(bx)
			
		if (act=="show") {
		se.className  = "regular";
		icM.className = "regular";
	    icE.className = "hide";
		}
		else {
		se.className  = "hide";
	    icM.className = "hide";
	    icE.className = "regular";
		}
		}
		
	function purchaseselect(po,id) {     
	   ptoken.navigate('#session.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryMatchSelectPurchaseSubmit.cfm?purchaseno='+po+'&invoiceid='+id,'purchasefunding') 
	  }	
	  
	function hl(itm,fld){
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
		 
		 	 		 	
		 if (fld != false){		
			 itm.className = "highLight";
		 }else{		
		     itm.className = "regular";		
		 }
	  }
	
	</script>

</cfoutput>

<cfquery name="Inv" 
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     I.*, 
	           IC.DocumentAmount AS IncomingAmount,
			   IC.ExemptionPercentage,
			   IC.ExemptionAmount,
			   IC.InvoiceSeries,
			   IC.InvoiceIssued,
			   IC.InvoiceReference
	FROM       Invoice I INNER JOIN
    	       InvoiceIncoming IC ON I.Mission = IC.Mission 
			     AND I.OrgUnitOwner = IC.OrgUnitOwner 
				 AND I.OrgUnitVendor = IC.OrgUnitVendor AND 
	           I.InvoiceNo = IC.InvoiceNo
	WHERE      I.InvoiceId = '#Object.ObjectKeyValue4#'
</cfquery>	

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Currency
</cfquery>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Inv.Mission#' 
</cfquery>

<!--- the the mode --->

<cfquery name="PO" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   P.*, R.InvoiceWorkflow 
	FROM     InvoicePurchase IP INNER JOIN
	         Purchase P ON IP.PurchaseNo = P.PurchaseNo INNER JOIN
	         Ref_OrderType R ON P.OrderType = R.Code
	WHERE InvoiceId = '#Object.ObjectKeyValue4#'					  
</cfquery>

<cfquery name="Parameter1" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>

<table border="0"  
  cellpadding="0"   
  cellspacing="0"
  class="formpadding"     
  width="95%" 
  align="center">
  
   <cfif PO.PersonNo neq "">
  
	  	<tr>
	
		  <TD width="151" height="23" class="labelmedium"><cf_tl id="Invoice Issued">:</TD>
	      <td colspan="1" width="80%">		     
			   <cfinput type="Text" class="regularxl enterastab" name="invoiceissued" value="#Inv.InvoiceIssued#" required="No" size="40" maxlength="60"> 			
		  </td>
			  
		</tr>
		
		<tr>
	
		  <TD width="151" height="23" class="labelmedium"><cf_tl id="Issue Reference">:</TD>
	      <td colspan="1" width="80%">		     
			   <cfinput type="Text" class="regularxl enterastab" name="invoicereference" value="#Inv.InvoiceReference#" required="No" size="40" maxlength="60"> 			
		  </td>
			  
		</tr>
	
	<cfelse>
	
		<input type="hidden" name="invoiceissued"    value="">
		
		<tr>
	
		  <TD width="151" height="23" class="labelmedium"><cf_tl id="Reference">:</TD>
	      <td colspan="1" width="80%">		     
			   <cfinput type="Text" class="regularxl enterastab" name="invoicereference" value="#Inv.InvoiceReference#" required="No" size="40" maxlength="60"> 			
		  </td>
			  
		</tr>
		
		
	
	</cfif>
		
	<TR>

	  <TD width="151" height="23" class="labelmedium"><cf_tl id="Invoice No">:</TD>
      <td colspan="1" width="80%">		  
		  		   
		   <table>
		   <tr>
			  <td>	
			  		   
			   <cfinput type="Text" 
			       style="padding-left:3px;width:20px" 
				   class="regularxl enterastab" 
				   name="invoiceseries" 
				   value="#Inv.InvoiceSeries#" 
				   required="No" 
				   size="2" 
				   maxlength="10"> 
				   
			  </td>
			  <td style="padding-left:2px">
	
				   <cfinput type="Text" 
				      class="regularxl enterastab" 
					  name="invoiceno" 
					  value="#Inv.InvoiceNo#" 
					  message="Please enter an invoice no" 
					  required="Yes" 
					  size="15" maxlength="30"> 
			  
			  </td>
		  
		  </tr>
		  </table>
		  
		  </td>
		  
	</tr>
	
	<tr>
		 <td height="25" valign="top" style="padding-top:4px" class="labelmedium">
		 <cf_tl id="Journal">
		 </td>
		 <td style="padding-right:10px">
			<cfdiv id="postingJournalselect" 
			    bind="url:#session.root#/Procurement/Application/Invoice/InvoiceEntry/setJournal.cfm?mission=#inv.mission#&owner=#inv.orgunitowner#&currency=#inv.documentCurrency#&invoicejournal=#inv.journal#&purchaseNo=#PO.PurchaseNo#">				
			</cfdiv>
		 </td>
    </tr>
		  
	<tr class="xhide">	  
	      <td width="20%" class="labelmedium"><cf_tl id="Document date">:</td>
		  <td width="20%">
		  
			    <cf_calendarscript>
		  
		   	    <cf_intelliCalendarDate9
	    		      FieldName="documentdate" 
					  class="regularxl enterastab"
	    		      Default="#Dateformat(Inv.DocumentDate, CLIENT.DateFormatShow)#">		
					  
	  	 </td>
	</TR>	
									
<cfif Parameter.InvoiceRequisition eq "0">  
	 			
		 <tr>
			 
			 <td height="25" valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Purchase Order">:</td>		
			 
			 <td colspan="3" id="purchaseresult">	
			 
			 	<cfset url.invoiceid = Object.ObjectKeyValue4>
			    <cfinclude template="DocumentPurchase.cfm">
			 	
			
			</td>
			
		</tr>
				
         <cfoutput>

		 <tr><td height="23" class="labelmedium"></td>			
						
			<cfif url.invoiceid neq "">
									
					<td colspan="2" style="padding-left:0px;padding-right:10px">	
					
						<input type="button" 
						   class="button10g" 
						   style="width:320px;height:24px;font-size:13px;border-radius:2px" 
						   onclick="ptoken.navigate('#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryMatchSelectPurchase.cfm?purchaseno=#po.purchaseno#&invoiceid=#Object.ObjectKeyValue4#','purchasefunding')" 
						   value="ASSOCIATE different Purchase">
					</td>				
							
			</cfif>			
						
		</tr>	 
		
		<tr><td id="purchasefunding" colspan="4" style="padding-left:20px;padding-right:20px"></td></tr>		
				 
		 <tr>
		 
		 <td height="25" valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Amount Payable">:</td>	
		 <td class="labellarge" id="invoicetotal">#NumberFormat(Inv.DocumentAmount,",.__")#</td>		
		
		 <td class="hide">		
			
			 <cfinput type="hidden" 
				     name     = "documentamountpayable" 
					 id       = "documentamountpayable" 
					 class    = "regularxl" 
					 value    = "#NumberFormat(Inv.DocumentAmount,"____.__")#" 
					 message  = "Enter a valid amount" 
					 validate = "float" 
					 required = "Yes" 
					 size     = "15" 
					 style    = "text-align: right;">
				 
		 </td>
				
		 </tr>		 
		
	     </cfoutput>		 
				
		 <tr>
		    <td></td>
			<td height="26" colspan="3" class="labelit" style="padding-top:4px">
		 	   <font color="808080"><cf_tl id="Attention">:</font> <font color="0080C0"><cf_tl id="The [Amount Payable] may be set to a lower value as recorded in the [Amount on Invoice]" class="message">
			</td>
		 </tr>	 			
	
	<cfelse>
	
		<!--- matching through the purchase lines --->
		
		<cfset url.PurchaseNo = PO.PurchaseNo>
		
		<cfquery name="Total" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
					SELECT  SUM(DocumentAmountMatched) AS Amount
					FROM    InvoicePurchase IP
					WHERE   PurchaseNo = '#URL.PurchaseNo#'				
					AND     InvoiceId = '#Object.ObjectKeyValue4#'
		</cfquery>
						
		<!--- payable amount for this invoice --->
		
		<tr>
			<td width="181" class="labelmedium"><cf_tl id="Amount Payable">:</td>
			
			<td colspan="3" height="22" class="labellarge" id="totalsum">
			
			   <cfoutput>
			   <font size="2">#Inv.DocumentCurrency#</font>
			   </cfoutput>
			
				<cfif PO.PurchaseNo neq "">
			
					<cfoutput>
					#numberformat(Total.Amount,",__.__")#</font></b>
					</cfoutput>			
				
				<cfelse>
				
					<cfoutput>
					<font color="red">#numberformat(INV.DocumentAmount,",__.__")#</font></b>
					</cfoutput>		
								
				</cfif>
				
				<!--- added 1/1/2011 because of an apparent error by OICT --->
				<cfoutput>
				<input type="hidden" name="DocumentAmountPayable" id="DocumentAmountPayable" value="#INV.DocumentAmount#">
				</cfoutput>	
			
			</td>
			
		</tr>
				
		<!--- selected associated lines --->
		  	  
		<cfquery name="Detail" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  A.*, L.InvoiceId
		    FROM    InvoiceIncomingLine A LEFT OUTER JOIN InvoiceLine L ON A.InvoiceLineId =  L.InvoiceLineId AND L.InvoiceId = '#Inv.InvoiceId#'	
			WHERE   Mission       = '#Inv.Mission#'
			AND     OrgUnitOwner  = '#Inv.OrgUnitOwner#'
			AND     OrgUnitVendor = '#Inv.OrgUnitVendor#'
			AND     InvoiceNo     = '#Inv.InvoiceNo#'		
			AND     (
			         A.InvoiceLineId IN (SELECT InvoiceLineId 
			                             FROM   InvoiceLine 
									     WHERE  InvoiceId = '#Inv.InvoiceId#')
					 OR
					 A.InvoiceLineId NOT IN (SELECT InvoiceLineId 
			                                 FROM   InvoiceLine)	
					)				  			  
				
		</cfquery>
		
		
			
		<cfif detail.recordcount gte "1">
		
			<tr><td class="line" colspan="5"></td></tr>
  
		  	<tr>
			  <td></td>
			  <td colspan="4">
		 
			      <table width="600"		      
					   frame="void"		   
				       cellspacing="0"
				       cellpadding="0">
				  		
					<cfoutput query="Detail">
					
					<TR>					
					   <td width="30">
					   <input type="checkbox" onclick="calctotal('#inv.InvoiceId#','#detail.recordcount#')"
					          name="invoicelineid" id="invoicelineid" <cfif invoiceId neq "">checked</cfif> value="#invoicelineid#">
					   </td>				
					   <td style="height:20px;padding-left:4px;width:26px" class="labelmedium">#currentrow#.</td>			  
					   <td width="65%" class="labelmedium">#LineDescription#</td>			 
					   <td width="16%" class="labelmedium">#LineReference#</td>
					   <td align="right" class="labelmedium"><cfif lineAmount lt 0><font color="FF0000"></cfif>#numberformat(abs(LineAmount),",.__")#</td>			   			 
				    </TR>		
					
					<cf_filelibraryCheck
					    	DocumentURL="#Parameter.InvoiceLibrary#"
							DocumentPath="#Parameter.InvoiceLibrary#"
							SubDirectory="#invoicelineid#" 
							Filter="">	
					
					<cfif files gte "1">
											
						<tr>
						   <td colspan="5">
						   
								<cfset access = "view">					
								<cfset url.lineid = invoicelineid>
								<cfset url.mission = inv.mission>
								<cfinclude template="../../InvoiceEntry/InvoiceEntryLineAttachment.cfm">	
						</td>
						</tr>	
					
					</cfif>
					
					</cfoutput>
					  
			      </table>
			      
		      </td>
	       </tr>	  
   
	   </cfif>		
				
	   <tr> 		
		<input type="hidden" id="_requests" name="_requests" value="">				
		<cfset invoiceid = "#Object.ObjectKeyValue4#">				
		<cfset frame = "Void">			
	    <td colspan="4" style="border-left:2px solid silver;padding-left:14px;padding-right:14px" id="purchasefunding">								
			<cfinclude template="../../InvoiceEntry/InvoiceEntryMatchRequisitionScript.cfm">			
			<cfinclude template="../../InvoiceEntry/InvoiceEntryMatchRequisition.cfm">			
		</td> 						   
	   </tr>   
	
</cfif>		
 
<tr>
	   <td class="labelmedium"><cf_tl id="Payable due">:</td>		   
       <td>	 
		   
		   	<cf_calendarscript>    	  
			<cf_intelliCalendarDate9
		   		  FieldName="actionbefore" class="regularxl"
		    	  Default="#Dateformat(Inv.ActionBefore, CLIENT.DateFormatShow)#">		
			  
	   </td>	
		   
</tr>

<tr>		   	   	  
		   
	   <td class="labelmedium"><cf_tl id="Payment Terms">:</td>			
	   <td>  
   	   
		    <select name="actionterms" id="actionterms" onChange="terms(this.value)" class="regularxl">
			
   		      <option value=""></option>  
			  <cfoutput query="Terms">
     		   	  <option value="#Code#" <cfif Inv.ActionTerms eq "#Code#">selected</cfif>>#Description#</option>
         	  </cfoutput>  
			  	            
	        </select>	
			
			<cfoutput>
				<input type="hidden"   name="actiondays"         id="actiondays">	
				<input type="hidden"   name="actiondiscount"     id="actiondiscount"     value="#Inv.ActionDiscount#">	
				<input type="hidden"   name="actiondiscountdays" id="actiondiscountdays" value="#Inv.ActionDiscountDays#">	
			</cfoutput>
     		   
       </td>	
			   		   			   
</tr>    
			
<tr>	  
	   <td class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Comments on Invoice">:</td>
       <td colspan="3">	 
      	   <textarea style="width:98%;padding:3px;font-size:13px;height:60px" class="regular" name="Description"><cfoutput>#Inv.Description#</cfoutput></textarea>
	   </td>	
</TR>	
			
<cfoutput>
	<input name="Key4" id="Key4" type="hidden" value="#Object.ObjectKeyValue4#">
	<input name="savecustom" id="savecustom" type="hidden"  value="Procurement/Application/Invoice/Workflow/MarkDown/DocumentSubmit.cfm">
</cfoutput>
			
</table>
