<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.tax" default="0">
<cfparam name="url.documentamount" default="0">

<cfif not LSIsNumeric(url.documentamount)>
  <table>
	<tr><td>- <cf_tl id="Incorrect amount entered">:<cfoutput>#url.DocumentAmount#</cfoutput></td></tr>
  </table>
  <cfabort>
</cfif>  

<cfif not LSIsNumeric(url.tax)>
  <table>
  	<tr><td>- <cf_tl id="Incorrect tax entered">:<cfoutput>#url.tax#</cfoutput></td></tr>
  </table>
  <cfabort>
</cfif>  

<cfset doc = replace(url.documentamount,',','',"ALL")>
<cfset tax = replace(url.tax,',','',"ALL")>

<cfset amt = doc*100/(100+tax)>
<cfset dif = doc - amt>

<cfoutput>

		<input type="Text"
	      name="ExemptionAmount"
		  id="ExemptionAmount"
	      message="Enter a valid amount"
	      validate="float"
	      required="Yes"
	      value="#numberformat(dif,'__,__.__')#"
	      readonly		 
	      size="15"
	      maxlength="15"
		  class="enterastab regularxl"
	      style="text-align:right;padding-right:2px" >
		  		  
		  
	<script>
	    if (document.getElementById('payable')) {
		ColdFusion.navigate('#SESSION.root#/procurement/application/invoice/InvoiceEntry/InvoicePayable.cfm?documentamount=#url.documentamount#&tax=#url.tax#&tag=#url.tag#','payable')
		}
	</script>		  
		  
</cfoutput>		  