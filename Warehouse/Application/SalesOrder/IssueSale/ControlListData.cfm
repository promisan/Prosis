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
<table width="95%" height="100%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">


  <tr><td class="labelmedium" style="padding-top:10px">
<!--- 16/10/2015 find sale transactions, that do have a stock left in this warehouse as it was kept for the customer
, so the stock can be issued to the customer picking it up etc --->


- Customer buys, but will not take stuff home, so the sale is transfer to a distribution location -/-8  + 8 followed by a sale 2 as it is no longer your stock.
The transaction will then be handled based on the 2. distrubution = 2 from the location.

<br>

- This view contains a listing using ItemTransaction based on a dedicated warehouselocation.Distribution = 2 collection) and will show the record recorded against
it ItemTransactionCollection with the balance.

<br>

If the user obtains a line and click edit, a screenscreen will be shown on the balance and he/she can enter a quantity up to the balance. In the mobile we can allow for a signatue

<br>

- Opening will allow you to deplete +/+ until it reaches 0 

<br>

- The issuances of the stock will show in the same batch screen as -/- under the +/+


</td></tr>

<tr>

<td colspan="1" align="right" height="100%">

   <!--- <cfset url.currency      = form.currency>
   <cfset url.category      = form.category>
   <cfset url.selectiondate = form.selectiondate> 

   <cfinclude template="ControlListDataContent.cfm">
   
   --->
					
</td>

</tr>					
	
</table>

