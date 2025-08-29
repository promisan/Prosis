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
<cfquery name="getHeader" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   *
	FROM     Customer
	WHERE    CustomerId = '#url.customerid#'					
</cfquery>

<table>
<cfoutput query="getHeader">
<tr class="labelmedium2"><td><a href="javascript:editCustomer('#getHeader.customerid#')">#CustomerSerialNo#</a></td></tr>
<tr class="labelmedium2"><td>#CustomerName#</td></tr>
</cfoutput>
</table>

<cfquery name="setHeader" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	UPDATE   CustomerRequest
	SET      CustomerId = '#url.customerid#', 
	         CustomerMail = '#getHeader.eMailAddress#'
	WHERE    RequestNo = '#url.requestno#'				
</cfquery>

<cfoutput>

	<script>
		 document.getElementById('customermail').value = '#getHeader.eMailAddress#'
	</script>
	
</cfoutput>
