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
<cfoutput>

<table width="100%" align="center">

		<tr bgcolor="f4f4f4">
		 <td class="topn" height="30" style="padding:4px" colspan="2">
			<img src="#SESSION.root#/images/logos/workorder/userfrom.png" align="absmiddle" height="30" width="30" alt="" border="0">
			<font size="3">FROM:</font>
		</td></tr>
		<tr><td colspan="2" class="line" height="1"></td></tr>
		<tr><td height="5"></td></tr>
		
		<cfquery name="Customer" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT  *
		     FROM    Customer
			 <cfif LineCustomer.CustomerFrom neq "">
			 WHERE   CustomerId = '#LineCustomer.CustomerFrom#'		
			 <cfelse>
			 WHERE 1=0
			 </cfif>
		</cfquery>
		
		<tr id="transfercustomer" class="#clc#">
			<td width="80" height="100%" class="labelit" style="padding:4px">Customer:</td>
			<td style="padding:4px" class="labelit">#Customer.CustomerName#</td>
		</tr>
								
		<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    Person
				WHERE   PersonNo = '#User.personNoFrom#'	
		</cfquery>		
		
		<tr id="transferperson" class="#clp#">
			<td width="80" height="100%" class="labelit" style="padding:4px">User/Contact:</td>
			<td style="padding:4px" class="labelit">
			<cfif Person.LastName eq ""><font color="FF0000">Service was not assigned</font>
			<cfelse><a href="javascript:EditPerson('#Person.PersonNo#')"><font color="0080FF">#Person.FirstName# #Person.LastName#
			</cfif></a>
			</td>
		</tr>		
		<tr id="transferperson" class="#clp#">
			<td height="100%" class="labelit" style="padding:4px">IndexNo:</td>
			<td class="labelit" style="padding:4px">#Person.IndexNo#</td>
		</tr>		
		<tr id="transferperson" class="#clp#">
			<td height="100%" class="labelit" style="padding:4px">Gender:</td>
			<td class="labelit" style="padding:4px">#Person.Gender#</td>
		</tr>		
		<tr id="transferperson" class="#clp#">
			<td height="100%" class="labelit" style="padding:4px">Nationality:</td>
			<td style="padding:4px">#Person.Nationality#</td>
		</tr>
</table>

</cfoutput>