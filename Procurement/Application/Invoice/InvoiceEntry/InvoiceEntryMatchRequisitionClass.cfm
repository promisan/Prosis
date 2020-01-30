<cfparam name="url.val" default="0">
<cfparam name="url.invoiceid" default="">
<cfparam name="url.requisitionno" default="">
<cfparam name="url.box" default="">

<cfset url.val = replace(url.val," ","","All")>

<cfif url.val eq "">
	 <cfabort>
	 
<cfelseif not LSIsNumeric(url.val)>
	
	<font color="FF0000"><cf_tl id="Error"> <cfoutput>#url.val#</cfoutput></font>
	<cfabort>
	 	
</cfif>	
							
	<cfquery name="qClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  R.*, IP.AmountInvoiced
		FROM    InvoicePurchaseClass IP RIGHT OUTER JOIN
              		Ref_PurchaseClass R ON IP.PurchaseClass = R.Code AND IP.RequisitionNo = '#url.RequisitionNo#' 
				<cfif url.invoiceId neq "">
		AND 	IP.InvoiceId = '#url.invoiceId#' 
				<cfelse>
		AND     IP.InvoiceId = '{00000000-0000-0000-0000-000000000000}'		
				</cfif>		
		WHERE     (R.SetAsDefault = 0)
	</cfquery>
	
	<table>
	
	<tr>
	
	<td class="labelit"><cf_tl id="Specify">:</td>
				
	<cfoutput query="qClass">
	
	   <td class="labelit" style="padding-left:4px">#Description#:</td> 
	   
	   <td style="padding:3px">
	 
	   <input type   = "Text" 
		   name      = "#url.box#_#Code#" 
		   id        = "#url.box#_#Code#"
		   style     = "text-align:right" 
		   class     = "regularxl" 
		   visible   = "Yes" 
		   value     = "#numberformat(AmountInvoiced,',__.__')#" 
		   size      = "8" 
		   maxlength = "15">
	   
	   </td>
	  	   			
	</cfoutput>
	
	</tr>
	
	</table>