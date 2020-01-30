
<cfparam name="URL.filter" default="">

<cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase P
		WHERE  PurchaseNo ='#URL.Id1#'
		AND    PurchaseNo IN (SELECT PurchaseNo 
		                      FROM   PurchaseLine 
							  WHERE  PurchaseNo = P.PurchaseNo)
</cfquery>	

<cfquery name="POType" 
   	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM   Ref_OrderType 
		WHERE  Code  ='#PO.OrderType#'
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>

<cfif Parameter.InvoiceRequisition eq "0">

	<cfquery name="Lines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *,
					  (SELECT TOP 1 Objectid 
					   FROM   Organization.dbo.OrganizationObject 
					   WHERE  ObjectKeyValue4 = I.Invoiceid
					   AND    Operational     = 1) as WorkflowId,
					   
					  ( SELECT ISNULL(SUM(DocumentAmountMatched),0)
					   	FROM   InvoicePurchase
					   	WHERE  InvoiceId = I.InvoiceId
					   	AND    PurchaseNo ='#URL.ID1#'
					   ) as ChargedAmount	
					   				    
	        FROM      Invoice I, InvoicePurchase IP
			WHERE     I.InvoiceId = IP.InvoiceId
			AND       IP.PurchaseNO = '#URL.ID1#' 
									  
			<cfif url.filter neq "">
			AND   (
		          I.InvoiceNo   LIKE '%#url.filter#%' OR 
				  I.Description LIKE '%#url.filter#%' 		  
				  )
			</cfif>		
			ORDER BY documentDate
	</cfquery>  

<cfelse>
	
	<cfquery name="Lines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *,
					  (SELECT TOP 1 Objectid 
					   FROM   Organization.dbo.OrganizationObject 
					   WHERE  ObjectKeyValue4 = I.Invoiceid
					   AND    Operational     = 1) as WorkflowId,
					  (SELECT ISNULL(SUM(DocumentAmountMatched),0)
					   FROM   InvoicePurchase
					   WHERE  InvoiceId = I.InvoiceId
					   AND    PurchaseNo ='#URL.ID1#'
					   ) as ChargedAmount
					    
	        FROM      Invoice I
			WHERE     I.InvoiceId IN (SELECT InvoiceId 
			                          FROM   InvoicePurchase 
									  WHERE  PurchaseNo = '#URL.ID1#') 
									  
			<cfif url.filter neq "">
			AND   (
		          I.InvoiceNo   LIKE '%#url.filter#%' OR 
				  I.Description LIKE '%#url.filter#%' 		  
				  )
			</cfif>		
			ORDER BY documentDate
	</cfquery>  

</cfif>

<cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	  
	   <cfif url.mode neq "Print">			
			
			<tr><td colspan="11" height="20">	 
							
			<cfif Parameter.InvoiceRequisition eq "0">  <!--- or POType.InvoiceWorkflow eq "0" --->
			   <cfset mode = "po">			   
			   <cfinclude template="../../Invoice/InvoiceEntry/InvoiceEntryMatchHeader.cfm">							
			</cfif>
			
			</td></tr>			
			
			<tr><td height="1" colspan="11" class="line"></td></tr>  
			
			<TR class="labelmedium line">
	   <cfelse>
	          
			<TR class="labelmedium line" bgcolor="d2d2d2">
	   </cfif>					 	 	 

	   <td height="21" width="20"></td>
	   <cfif URL.Mode eq "Edit" and PO.ActionStatus eq "0">
	       <td width="2%">&nbsp;</td>
	   <cfelse>
	       <td width="2%">&nbsp;</td>
	   </cfif>
	   <td><cf_tl id="InvoiceNo"></td>
	   <td width="30%"><cf_tl id="Description"></td>
	   <td width="100" align="left"><cf_tl id="Date"></td>
	   <td width="80"><cf_tl id="Status"></td>
	   <td width="100"><cf_tl id="Officer"></td>
	   <td width="80" align="center"><cf_tl id="Entered"></td>
	   <td width="50" align="center"></td>
       <td width="100" align="right" style="padding-right:6px"><cf_tl id="On Invoice"></td>
	   <td width="100" align="right" style="padding-right:6px"><cf_tl id="PO Charged"></td>
	 </TR> 
									
		<cfif Lines.recordcount eq "0">

			 <tr><td height="25" colspan="11" align="center" class="labelmedium"><font color="gray"><cf_tl id="There are no records to show in this view"></td></tr>  
 
		<cfelse>
							
			<cfloop query="Lines">
										
			<tr class="labelmedium navigation_row line" style="height:20px">
									
				<td width="20" align="center">#CurrentRow#</td>
				
				<cfif URL.Mode eq "Edit" or URL.Mode eq "View">
								
			        <td width="3%" align="center">
					
						<cf_img icon="edit" onclick="invoiceedit('#invoiceid#')"> 
					
					</td>
					
				<cfelse>
				  <td></td>						
				</cfif> 
				
				<td width="180"><a href="javascript:invoiceedit('#invoiceid#')">#InvoiceNo#/#invoiceserialno#</a></td>
				<td width="30%">
				<cfif description eq "">---<cfelse>
					<cfif len(Description) gte "50">
					<a href="##" title="#Description#">#left(Description,50)#..</a>
					<cfelse>
					#Description#
					</cfif>
				</cfif></td>
				<td>#DateFormat(DocumentDate,CLIENT.DateFormatShow)#</td>
				<td>
				<cfif ActionStatus eq "0" and WorkFlowid eq ""><font color="0080FF"><cf_tl id="On Hold"></font>
				<cfelseif ActionStatus eq "0" and WorkFlowid neq ""><font color="green"><cf_tl id="In Process"></font>
				<cfelseif ActionStatus eq "9"><font color="FF0000"><cf_tl id="Cancelled">				
				<cfelse><cf_tl id="Posted">
				</cfif>
				</td>
				<td>#OfficerLastName#</td>
				<td align="center">#DateFormat(Created,CLIENT.DateFormatShow)#</td>
				<td align="center">#DocumentCurrency#</td>
				<td align="right" style="padding-right:5px">#NumberFormat(DocumentAmount,",.__")#</td>
				<td  align="right" style="padding-right:10px">#NumberFormat(ChargedAmount,",.__")#</td>
							
           	</tr>
			
			<cfif URL.sort eq "GL">
			
				<cfquery name="Check" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    * 
					FROM      TransactionHeader
					WHERE     ReferenceId = '#InvoiceId#'	
		  		</cfquery>	
				
				<cfif check.recordcount gte "1">			
							
					<cfquery name="SearchResult" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     vwGLTransaction
						WHERE    SourceId = '#InvoiceId#'
				       	ORDER BY TransactionDate, TransactionSerialNo		
			  		</cfquery>	
		   			
					<cfif SearchResult.recordcount gte "1">
			
					    <tr><td height="4"></td></tr></tr>
						
						<tr><td></td><td height="18" style="padding-left:5px" height="2" colspan="9" class="labelit"><cf_tl id="General Ledger">:</td></tr>		
										
						<tr><td></td><td colspan="11" height="100%" style="padding-left:10px">
						
							<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
					
							  <cfset pages = "0">
							  <cfset embed = "1">	
							  <cfinclude template = "../../../../Gledger/Application/Inquiry/TransactionListingLines.cfm"> 
							 
							</table>  
							
						</td>
						</tr>
												 
						<!--- show receipts for this PO --->
												 
						<cfquery name="Receipts" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    * 
								FROM      PurchaseLineReceipt
								WHERE     InvoiceIdMatched = '#InvoiceId#'	
					  	</cfquery>	
						 
						<cfset invr = InvoiceId>
																		 
						<cfloop query="Receipts">
						 						 
							 <cfquery name="SearchResult" 
								datasource="AppsLedger" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM     vwGLTransaction
									WHERE    ReferenceId = '#ReceiptId#'
									AND      SourceId <> '#invr#'
							       	ORDER BY TransactionDate, TransactionSerialNo		
						  	 </cfquery>	
							 
							 <cfif SearchResult.recordcount gte "1">
							 		
								 <tr><td></td>
								     <td height="20" colspan="11" class="labelit" style="padding-left:14px">Receipt Postings</td>
								 </tr>	
								 				 
								 <tr><td></td><td colspan="11" height="100%" style="padding-left:10px">
									 <table width="100%" cellspacing="0" cellpadding="0">
							
									  <cfset pages  = "0">
									  <cfset embed  = "1">
									  <cfset header = "0">
			
									  <cfinclude template="../../../../Gledger/Application/Inquiry/TransactionListingLines.cfm"> 
									 
									 </table>  
								 </td></tr>
							 
							 </cfif>
						 
						 </cfloop>						 
				
					</cfif>
				
				</cfif>
			
			</cfif>
			
			
						
		  </cfloop>
		
	</cfif>		
		
</table>

</cfoutput>	

<cfset ajaxonload("doHighlight")>