
<cfquery name="Vendors2" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT O.OrgUnit, O.OrgUnitCode,OrgUnitName
	
	FROM   Invoice I, 
	       Organization.dbo.Organization O
	
	WHERE  I.Mission = '#URL.Mission#'
	AND    I.Period = '#url.period#'
	AND    I.OrgUnitVendor = O.OrgUnit
		
	AND    InvoiceId NOT IN
	
                     (SELECT   InvoiceId
                       FROM    Invoice I INNER JOIN
                               stReconciliation R ON I.ReconciliationNo = R.reconciliationNo
                       WHERE   I.mission = '#URL.Mission#' 
					   AND     I.ActionStatus <> '9' 
					   AND     R.status = 'complete')
					   
	AND InvoiceId IN
			
			(
				SELECT    IP.InvoiceId
				FROM      PurchaseLine PL INNER JOIN
                          RequisitionLine RL ON PL.RequisitionNo = RL.RequisitionNo INNER JOIN
                          InvoicePurchase IP ON PL.RequisitionNo = IP.RequisitionNo 
				WHERE     RL.Mission = '#URL.Mission#' 
				AND       RL.ActionStatus <> '9'
			)		
			
		
	AND  I.ActionStatus in ('1','2') 
			
	AND  I.InvoiceId not IN 
			
					(
					SELECT     InvoiceId
					FROM       Invoice I
					WHERE      Mission = '#URL.Mission#'	
					AND        ActionStatus = '0' 
					
					AND        InvoiceId NOT IN
	                                    (
										 SELECT     ObjectKeyValue4
	                                     FROM       Organization.dbo.OrganizationObject
	                                     <!--- 
										 not needed makes it slow
										 WHERE      EntityCode = 'ProcInvoice'
										  --->
										)	
															    
									
					)
					
	AND  I.ActionStatus != '0'
						
	ORDER BY OrgUnitName  
	
</cfquery>

<cfquery name="Vendors3" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT P.PersonNo, P_1.IndexNo, P_1.LastName, P_1.FirstName
	FROM      Invoice I INNER JOIN
	          InvoicePurchase IP ON I.InvoiceId = IP.InvoiceId INNER JOIN
	          Purchase P ON IP.PurchaseNo = P.PurchaseNo INNER JOIN
	          Employee.dbo.Person P_1 ON P.PersonNo = P_1.PersonNo
	WHERE     I.OrgUnitVendor = 0 
	AND       I.Mission = '#url.mission#'
</cfquery>

<table width="100%"><tr><td width="100%"></td></tr></table>
<cf_divScroll>

	<table width="100%" align="center">
		
		<tr><td colspan="7" align="left" class="labellarge" style="padding-left:4px"><b><cfoutput>#url.mission#</cfoutput> Payable record</font></td></tr>
		<tr><td colspan="7" class="linedotted"></td></tr>
		<tr><td colspan="7">
		<table>
		<td height="25" align="left" class="labelmedium" style="padding-left:4px">Vendor:</td>
		<td align="left" height="25" colspan="6">
					<cfoutput>
		    	      <select name="Vendor2" id="Vendor2" size="1" class="regularxl"
	    	    	  onChange="ptoken.navigate('ReconcileViewInvoice.cfm?mission=#url.mission#&Period=#url.period#&vendorcode3=0&vendorcode2='+this.value,'invoicebox')">
					  
					   <option value="">None</option>				  
					  
					   <cfloop query="Vendors2">
	    	    	     <cfoutput>
						 <option value="#OrgUnit#"<cfif URL.vendorCode2 eq OrgUnit>selected</cfif>><cfif OrgUnitCode eq "">#OrgUnit#<cfelse>#OrgUnitCode#</cfif> - #OrgUnitName#</option>
						 </cfoutput>
				       </cfloop>	 
					   
	               </SELECT>	
				   
				   </cfoutput>
			</td>
		</tr>
			
	    <tr>
		   		<td height="25" align="left" class="labelmedium fixlength" style="padding-left:4px;padding-right:10px">Staff/Consultant:</td>
				<td colspan="6" align="left" >
					<cfoutput>
		    	    <SELECT name="Vendor3" id="Vendor3" class="regularxl"
					    size="1" style="color:black"
	    	    	    onChange="ptoken.navigate('ReconcileViewInvoice.cfm?mission=#url.mission#&Period=#url.period#&vendorcode2=0&vendorcode3='+this.value,'invoicebox')">
					   <option value="">None</option>
						 
					   <cfloop query="Vendors3">
					   	
						 <cfif Indexno neq "" and len(IndexNo) gte 6>
	    	    	    
						 <option value="#PersonNo#"<cfif URL.vendorCode3 eq PersonNo>selected</cfif>>
						 	#LastName# #FirstName# 
						 </option>
						 
						 </cfif>
						
				       </cfloop>	 
	               </SELECT>	
				   </cfoutput>
				   </td>
			
		 </tr>
		 </table>
		</td></tr>
					
		<tr><td colspan="7" style="padding-left:4px" class="labelsmall"><font color="gray">
			
				Below you will find a list of <cfoutput><b>#SESSION.welcome#</b></cfoutput> transactions that need your attention to be reconciliated with IMIS Transactions.			</i>
				
			<br></td></tr>
			
		<tr><td colspan="7" class="linedotted"></td></tr>	
		    
		<tr>
				<td width="10"></td>
				<td width="20"></td>
				<td class="labelit">TraNo</td>
				<td class="labelit">Invoice No</td>
				<td class="labelit">Invoice Date</td>			
				<td class="labelit">Officer</td>
				<td class="labelit">Amount</td>					
		</tr>	
			
		<tr><td colspan="7" class="linedotted"></td></tr>
			
			<cfquery name="Invoice" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT I.*, O.OrgUnitCode, OrgUnitName
				FROM   Invoice I LEFT OUTER JOIN Organization.dbo.Organization O ON
						I.OrgUnitVendor = O.OrgUnit
				WHERE  I.Mission = '#URL.Mission#'
				
				<cfif URL.VendorCode3 neq "0">
					AND    I.OrgUnitVendor = '0'
				</cfif>
							
				AND    InvoiceId not in
	                          (SELECT     InvoiceId
	                            FROM      Invoice I INNER JOIN
	                                      stReconciliation R ON I.ReconciliationNo = R.reconciliationNo
	                            WHERE     I.mission = '#URL.Mission#' AND I.ActionStatus <> '9' AND R.status = 'complete')
				
				AND  InvoiceId in
					(
						Select IP.InvoiceId
						FROM         PurchaseLine PL INNER JOIN
		                RequisitionLine RL ON PL.RequisitionNo = RL.RequisitionNo INNER JOIN
		                InvoicePurchase IP ON PL.RequisitionNo = IP.RequisitionNo 
						WHERE     (RL.Mission = '#URL.Mission#') AND (RL.ActionStatus <> '9')
					)			
				
										
				<cfif URL.VendorCode2 neq "0">
						AND OrgUnitVendor='#URL.VendorCode2#' 
				</cfif>	
				
				<cfif URL.VendorCode3 neq "0">
					AND InvoiceId in
					(
						SELECT   I.InvoiceId
						FROM         Invoice I INNER JOIN
		                      InvoicePurchase IP ON I.InvoiceId = IP.InvoiceId INNER JOIN
		                      Purchase P ON IP.PurchaseNo = P.PurchaseNo INNER JOIN
		                      Employee.dbo.Person P_1 ON P.PersonNo = P_1.PersonNo
						WHERE     (I.OrgUnitVendor = 0) AND (I.Mission = '#url.mission#')
						AND P_1.PersonNo = '#URL.VendorCode3#'
					)
				</cfif>
						
				AND I.ActionStatus in ('1','2') 
				
				AND I.InvoiceId not IN (
						SELECT   InvoiceId
						FROM     Invoice I
						WHERE    ActionStatus = '0'
						AND      InvoiceId NOT IN
		                               (SELECT  ObjectKeyValue4
		                                FROM    Organization.dbo.OrganizationObject)
									<!---  WHERE      EntityCode = 'ProcInvoice' --->
									
								 
						AND  Mission = '#URL.Mission#'
					)
				AND I.ActionStatus != '0'							
				ORDER BY I.DocumentDate
			</cfquery>
	
			<cfoutput query="Invoice">			
					
				<tr id="inv#currentrow#" onMouseOver= "document.getElementById('inv#currentrow#').className= 'highlight2'"
	   				onMouseOut = "document.getElementById('inv#currentrow#').className= 'regular'">
					
					<td class="labelit" style="padding-left:3px">#currentrow#.</td>	
					<td class="labelit"><input type="checkbox" class="radiol" name="invoiceselect" id="i#invoiceid#" value="'#InvoiceId#'" onclick="processinvoice()"></td>		
					<td class="labelit" align="center">#TransactionNo#</td>											
					<td class="labelit"><a href="javascript:invoiceedit('#Invoiceid#')"><font color="0080FF">#InvoiceNo#</a></td>
					<td class="labelit">#Dateformat(DocumentDate,CLIENT.DateFormatShow)#</td>						
					<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
					<td align="right" class="labelit">#NumberFormat(DocumentAmount, "__,__.__")#</td>	
															
				</tr>
									
			</cfoutput>
		
	</table>

</cf_divScroll>
