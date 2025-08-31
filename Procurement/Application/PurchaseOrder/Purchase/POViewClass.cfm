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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->


<cfparam name="URL.ID" default="0">
<cfparam name="URL.Mode" default="Edit">

<cfquery name="PurchaseClass" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  R.Code, 
	        R.Description, 
			PC.AmountPurchase, 
			PC.RequisitionNo
	FROM    PurchaseLineClass PC RIGHT OUTER JOIN
            Ref_PurchaseClass R ON PC.PurchaseClass = R.Code AND PC.RequisitionNo = '#URL.ID#'
	<cfif url.mode neq "View">		
	WHERE   R.SetAsDefault = 0		
	</cfif>
	ORDER BY Code		
</cfquery>

<cfquery name="Check" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  sum(AmountPurchase) as Total
	FROM    PurchaseLineClass 
	WHERE   RequisitionNo = '#URL.ID#'
</cfquery>

<cfif url.mode eq "View">
<table width="400" border="0" cellspacing="0" cellpadding="0" bgcolor="f2ffff" class="formpadding">
<cfelse>
<table  width="400" border="0" cellspacing="0" cellpadding="0" class="formpadding">
</cfif>

<cfoutput query="PurchaseClass">
	
	<tr class="labelmedium">
	<cfif url.mode eq "View">
	<td bgcolor="white"></td>
	</cfif>
	<td width="40" style="padding-right:5px">#Code#:</td>
	<td>
	<cfif url.mode eq "View">
		#NumberFormat(AmountPurchase,"_,_.__")#
	<cfelse>	
		<input type="text" 
		       size="14" 
			   class="amount regularxl" 
			   name="classamount" 
               id="classamount"
			   value="#numberFormat(AmountPurchase,',__.__')#" 
			   onChange="settotal()">
	</cfif>	
	</td>
	
	<td width="10%"><cf_tl id="Invoiced">:&nbsp;</td>
	<td>
			
	<cfquery name="Invoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  sum(AmountInvoiced) as Invoiced
		FROM    InvoicePurchaseClass
		WHERE   RequisitionNo = '#URL.ID#'	
		AND     PurchaseClass = '#code#'
	</cfquery>
	
	#NumberFormat(Invoice.Invoiced,"_,_.__")#
	
	</td>
	<td bgcolor="white"></td>
	</tr>

</cfoutput>	


</table>	
