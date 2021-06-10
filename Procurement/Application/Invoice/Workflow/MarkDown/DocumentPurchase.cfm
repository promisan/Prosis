<!--- the the mode --->
	
<cfquery name="PO" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   IP.*, P.*, R.InvoiceWorkflow 
	FROM     InvoicePurchase IP INNER JOIN
	         Purchase P ON IP.PurchaseNo = P.PurchaseNo INNER JOIN
	         Ref_OrderType R ON P.OrderType = R.Code
	WHERE    InvoiceId = '#url.invoiceid#'					  
</cfquery>


<cfquery name="Parameter1" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>

<!-- <cfform> -->
<table>

	<cfoutput query="PO">
	
			<cfif Parameter1.PurchaseCustomField neq "">
			   <cfset ref = evaluate("PO.UserDefined#Parameter1.PurchaseCustomField#")>
			<cfelse>
			   <cfset ref = "">
			</cfif>     
	
			<tr class="labelmedium">
					<td bgcolor="ffffff" style="border-bottom:1px solid d1d1d1;padding-left:10px"><a href="javascript:ProcPOEdit('#PurchaseNo#','view','tab')">#PurchaseNo# <cfif ref neq "">(#ref#)</cfif> <cf_space spaces="40"></a></td>
					<td bgcolor="ffffff" style="width:150px;border-bottom:1px solid d1d1d1;padding-left:20px;padding-right:5px" align="right">#numberformat(documentamountmatched,',.__')#</td>
					<td style="width:150px;border:1px solid silver;padding-left:10px;padding-right:5px" align="right">
					
					<cfinput type="Text" 
					     name     = "Purchase_#purchaseserialno#" 
						 id       = "Purchase_#purchaseserialno#" 
						 class    = "regularxl" 
						 value    = "#NumberFormat(documentamountmatched,".__")#" 
						 message  = "Enter a valid amount" 
						 validate = "float" 
						 onchange = "ptoken.navigate('#session.root#/procurement/application/Invoice/WorkFlow/Markdown/setTotal.cfm','invoicetotal','','','POST','forminvoice')	"
						 required = "Yes" 
						 size     = "10" 
						 style    = "font-size:16px;border:0px solid silver;text-align: right;">								
					
					</td>
			</tr>
	
	</cfoutput>
	 						
</table>	

<cfoutput>
 <input type="hidden" name="selectedpurchase" value="#valueList(PO.PurchaseSerialNo)#">
 </cfoutput>

<!-- </cfform> -->