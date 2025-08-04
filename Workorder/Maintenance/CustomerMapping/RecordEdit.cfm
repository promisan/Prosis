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
<cfif url.id1 eq "new">
	<cf_screentop height="100%" label="Customer Mapping" option="Add Customer Mapping" scroll="Yes" layout="webapp">
<cfelse>
	<cf_screentop height="100%" label="Customer Mapping" option="Maintaing Customer Mapping" scroll="Yes" layout="webapp" banner="yellow">
</cfif>

<cfquery name="get" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT	*
	FROM	stCustomerMapping
	<cfif url.id1 eq "new">WHERE 1 = 0<cfelse>WHERE TransactionId = '#url.id1#'</cfif> 	
	
</cfquery>

<table class="hide">
	<tr><td><iframe name="processEditCustomerMapping" id="processEditCustomerMapping" frameborder="0"></iframe></td></tr>
</table>

<cfform method="POST" action="RecordSubmit.cfm?id1=#url.id1#" name="frmEditCustomerMapping" target="processEditCustomerMapping">

<cfoutput>

<table width="80%" align="center">
	
	<tr><td height="30"></td></tr>
	
	<input type="Hidden" name="CustomerIdOld" id="CustomerIdOld" value="#get.CustomerId#">
<!--- 	<input type="Hidden" name="ServiceItemOld" id="ServiceItemOld" value="#get.ServiceItem#"> --->
	<input type="Hidden" name="MappingCodeOld" id="MappingCodeOld" value="#get.MappingCode#">
	<tr>
		<td width="25%" class="labelit">Customer:</td>
		<td>
			<cfquery name="getCustomers" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT	*
				FROM	Customer
				ORDER BY Mission, CustomerName
				
			</cfquery>
			
			<cfselect query="getCustomers" group="mission" name="CustomerId" 
						value="CustomerId" display="CustomerName" required="Yes" 
						message="Please, select a valid customer." queryposition="below" selected="#get.customerId#" class="regularxl">
				<option value="">
			</cfselect>		
		</td>
	</tr>

	<tr>
		<td class="labelit">Mapping Code:</td>
		<td><cfinput name="mappingCode" value="#get.mappingCode#" required="Yes" message="Please, enter a mapping code." maxlength="50" size="40" class="regularxl"> </td>
	</tr>
	<tr><td height="30"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>
		<td colspan="2" align="center">
			<input type="Submit" class="button10g" name="save" id="save" value="  Save  ">
		</td>
	</tr>
</table>

</cfoutput>

</cfform>