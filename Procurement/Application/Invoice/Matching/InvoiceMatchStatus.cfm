
<cfparam name="Form.linesselect" default="'{00000000-0000-0000-0000-000000000000}'">

<cfquery name="Invoice" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Invoice
	WHERE  InvoiceId = '#URL.ID#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Invoice.Mission#' 
</cfquery>

<!--- undo association --->

<cfquery name="SetReceipt" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    UPDATE  PurchaseLineReceipt
	SET     InvoiceIdMatched = NULL, 
	        ActionStatus = '1'
	WHERE   InvoiceIdMatched = '#URL.ID#'	
</cfquery>	

<!--- associate --->

<cfquery name="SetReceipt" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    UPDATE  PurchaseLineReceipt
	SET     InvoiceIdMatched = '#URL.ID#', 
	        ActionStatus = '2'
	WHERE   ReceiptId IN (#preservesinglequotes(form.linesselect)#)  
</cfquery>

<cfquery name="GetLines" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    PurchaseLineReceipt 
	WHERE   ReceiptId IN (#preserveSingleQuotes(form.linesselect)#)  		
</cfquery>

<cfset amt = 0>
<cfset inv = 0>

<cfloop query="GetLines">

	<cfquery name="Receipt" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM   PurchaseLineReceipt 
		WHERE  ReceiptId = '#receiptId#'
	</cfquery>
		
	<cfif Receipt.Currency eq Invoice.DocumentCurrency>
	
	   <cfset amt = amt+Receipt.ReceiptAmount>
	   <cfset inv = inv+Receipt.InvoiceAmount>
	  
	<cfelse>
			
		<cf_exchangerate datasource   = "AppsPurchase" 
		                 currencyFrom = "#Receipt.Currency#" 
						 currencyTo   = "#Invoice.DocumentCurrency#">
					
		<cfset amt = amt+(Receipt.ReceiptAmount/exc)> 
		<cfset inv = inv+(Receipt.InvoiceAmount/exc)> 
			
	</cfif>

</cfloop>

<cfif GetLines.recordcount gte "1">

    <!--- percentage difference between matched and invoice --->
	<!--- 10/110 = 10% --->
	
	<cfset amt_dif =  abs(amt-Invoice.DocumentAmount)>
	<cfset amt_idif  = abs(inv-Invoice.DocumentAmount)>
	<cfif Invoice.DocumentAmount lte 0>
		<cfset Invoice.DocumentAmount = 1>
	</cfif>
	<cfset perc_dif  = abs((amt-Invoice.DocumentAmount)/Invoice.DocumentAmount)>
	<cfset perc_idif = abs((inv-Invoice.DocumentAmount)/Invoice.DocumentAmount)>
			
	<!--- percentage or amount allowed --->
			
	<cfset perc_all = Parameter.InvoiceMatchDifference/100> 	
	
	<cfif Parameter.InvoiceMatchPriceActual eq "0">
	
		<cfif perc_dif lte perc_all or amt_dif lte Parameter.InvoiceMatchDifferenceAmount>
		
		       <cfset acceptable = "Yes">
				
			   <script language="JavaScript">	
				{
					frm  = document.getElementById("Save");
					frm.className = "button10g"
				}	
			   </script>
			   
		<cfelse>
				
				<cfset acceptable = "No">
				
				<!--- undo association --->
				
				<cfif url.action eq "Initial">
				
					<cfquery name="SetReceipt" 
					    datasource="AppsPurchase" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
					    UPDATE  PurchaseLineReceipt
						SET     InvoiceIdMatched = NULL
						WHERE   InvoiceIdMatched = '#URL.ID#'			
					</cfquery>	
				
				</cfif>
			
			   <script language="JavaScript">		
					{			   
						frm  = document.getElementById("Save");
						frm.className = "hide"
					}			
				</script>
		      
		</cfif>	   
		
	<cfelse>	
		   
			<cfif perc_idif lte perc_all or amt_idif lte Parameter.InvoiceMatchDifferenceAmount>
			
			       <cfset acceptable = "Yes">
					
				   <script language="JavaScript">	
					{						
						frm  = document.getElementById("Save");
						frm.className = "button10g"				
					}	
				   </script>	   
			
			<cfelse>
			
					<cfset acceptable = "No">
					
					<!--- undo association --->
					
					<cfif url.action eq "Initial">
					
						<cfquery name="SetReceipt" 
						    datasource="AppsPurchase" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
						    UPDATE  PurchaseLineReceipt
							SET     InvoiceIdMatched = NULL
							WHERE   InvoiceIdMatched = '#URL.ID#'			
						</cfquery>	
					
					</cfif>
				
				   <script language="JavaScript">		
					{			   
						frm  = document.getElementById("Save");
						frm.className = "hide"
					}			
					</script>
				      
			</cfif>
			
	</cfif>	
	
<cfelse>	
	
		<cfset acceptable = "No">
					
        <script language="JavaScript">
			{
			frm  = document.getElementById("Save");
			frm.className = "hide"
			}
		</script>
		
</cfif>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr><td valign="top" style="padding-left:12px">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
		<tr bgcolor="DDFBE2" class="labelmedium line">
		
		  <cfoutput>
		  
			  <td width="100" height="21" align="center" style="padding-left:20px"><cf_tl id="Payable">:</td>
			  <td><b>#NumberFormat(Invoice.DocumentAmount,",.__")#</td>			  
			  <td style="width:20%;padding-left:10px"><cf_tl id="Matched lines">:</td>
			  <td>[#getLines.recordcount#]</td>  
			  <td>  
				 <cfif amt neq ""><b>#NumberFormat(amt,"__,__.__")#<cfelse>0.00</cfif>      
			  </td>
			  <td style="width:80">	 
				<cf_tl id="Balance">: 
			  </td>
			  <td>	        
				 <cfif abs(Invoice.DocumentAmount-amt) gt "0.05"><font color="green"></cfif>	 
			  	 #NumberFormat(Invoice.DocumentAmount-amt,",.__")# 
				 <cfif amt gte "1">
				 (#numberformat(Invoice.DocumentAmount*100/amt,"._")#%)
				 </cfif>
				  	    
			  </td>
			  <cfif Parameter.InvoiceMatchPriceActual gte "1">
				<td><b><cf_tl id="On invoice"></td>
				<td style="padding-left:5px"> 
					 <cfif amt neq "">#NumberFormat(inv,"__,__.__")#<cfelse>0.00</cfif>   
				     -> <font size="1"><cf_tl id="Balance"></font>:        
					 <cfif abs(Invoice.DocumentAmount-inv) gt "0.05"><font color="red"></cfif>	 
				  	 #NumberFormat(Invoice.DocumentAmount-inv,"__,__.__")#  	   
				</td>     
			  </cfif>
			  <td align="right"> 
			     
			   	 <cf_tl id="Posting">   
				  <b> 
			     <cfif acceptable eq "Yes">
				  <font size="3" color="008000">: <cf_tl id="Yes">
				 <cfelse>
				  <font size="3" color="FF0000">: <cf_tl id="No">
				 </cfif>	  	  
			   </td>    
			   <td width="30"></td> 
		   
		  </cfoutput>
		  
		</tr>
		</table>
		
	</td>
	</tr>
	<tr><td height="3"></td></tr>
	<tr><td height="27" colspan="2" align="right"></td></tr>

</table>
