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

<cfinclude template="InitParam.cfm">

<cfset dr = "">

<cf_dialogProcurement>

<table width="100%" border="1" frame="void" bordercolor="silver" height="100%" align="center" border="0">

<td id="reconcile" style="border: 1px dotted Gray;" colspan="2" height="40"><cfinclude template="ReconcileResult.cfm"></td></tr>

<form name="formreconcile" id="formreconcile">
	<tr>
	  <td valign="top">
  		<cfinclude template="ReconcileViewInvoice.cfm">
      </td>
	  <td id="ledger" valign="top">
  		<cfinclude template="ReconcileViewLedger.cfm">
	  </td>
	</tr>
</form>

<tr>

</table>

