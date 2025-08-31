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
<!--- reset --->

<script>
	se = document.getElementsByName('returnbox')
	i=0
	while (se[i]) {
	   se[i].className = "hide"
	   i++
	}
</script>

<cfparam name="Form.selected" default="">

<cfquery name="getLines" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *,
	
	           T.TransactionQuantity*-1 as Shipped, 
			   (
			   SELECT SUM(TransactionQuantity) as Returned
               FROM   ItemTransaction
			   WHERE  ParentTransactionId = T.TransactionId 
			   AND    TransactionType = '3'
			   ) as Returned 
			   
	FROM      ItemTransaction T, ItemTransactionShipping S
	WHERE     T.Transactionid = S.TransactionId
	<cfif form.selected neq "">
	AND       T.TransactionId IN (#preservesinglequotes(Form.Selected)#) 	
	<cfelse>
	AND       1=0
	</cfif>
</cfquery>

<cfset cnt = 0>
<cfset amt = 0>
<cfset tax = 0>
<cfset qty = 0>

<cfoutput query="getLines">
	
	<cfif returned neq "">
		<cfset issued = shipped - returned>
	<cfelse>
		<cfset issued = shipped>
	</cfif>
	
	<cfparam name="Form.Quantity_#TransactionSerialNo#" default="0">
	
	<cfset q = evaluate("Form.Quantity_#TransactionSerialNo#")>
	
	<script>
		document.getElementById("box_#TransactionSerialNo#").className = "regular"
	</script>
			
	<cfif q neq "" and q neq "0">
		
		<cfif q lte issued>				
		
			<cfset cnt = cnt+1>	
			<cfset qty = q+qty>
			<cfset tax = tax + ((SalesTax/issued)*q)>
			<cfset amt = amt + ((SalesAmount/issued)*q)>
			
		<cfelse>
		
			<script>
				document.getElementById("Quantity_#TransactionSerialNo#").value = 0.00
			</script>	
		
		</cfif>
		
	</cfif>

</cfoutput>

<cfoutput>

	<table>
	<tr class="labelmedium">
		<td><cf_tl id="Selected">:</td>
		
		<td align="right" style="padding-left:4px">#cnt#</td>
		<td style="padding-left:14px"><cf_tl id="Quantity">:</td>
		
		<td style="padding-left:4px" align="right">#qty#</td>
		<td style="padding-left:14px"><cf_tl id="Credit Note">:</td>
		<td style="padding-left:4px" align="right">#numberformat(amt+tax,",__.__")#</td>
		
	</tr>
		
	</table>
	
</cfoutput>
