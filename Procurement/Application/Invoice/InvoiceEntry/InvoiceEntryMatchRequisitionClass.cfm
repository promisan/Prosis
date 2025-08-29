<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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