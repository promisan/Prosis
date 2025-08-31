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
<cfparam name="url.WorkOrderId"    default="">
<cfparam name="url.Mission"        default="">
<cfparam name="URL.id1"			   default="HSA-PO-1550">

<cfset tmp = "Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm">
<cfset tmp = "WorkOrder/Application/WorkOrder/Invoice/WorkOrderInvoiceData.cfm"> 
<cfset URL.id1 = url.workorderid>

<cfoutput>	

<table border="0" align="center" cellpadding="0"  cellspacing="0" width="100%" >
		<td>
	<input type="button" 
	     id="glprocess" 
		 class="button10g"
		 style="width:100px"
		 value="print"
		 onclick="ptoken.navigate('../../../../Tools/Mail/MailPrepare.cfm?templatepath=#tmp#&id=pdf&id1=#URL.WorkOrderId#','bshow')">

		</td>
	</tr>
	<tr>
		<td id="bshow"></td>
	<tr>

</table> 

	
<!--- 	<script>
<cfinclude template="#SESSION.root#/Tools/Mail/MailPrepare.cfm?templatepath=#tmp#&id=pdf&id1=#URL.WorkOrderId#">
		ColdFusion.navigate('#SESSION.root#/Tools/Mail/MailPrepare1.cfm?templatepath=#tmp#&id=pdf&id1=#URL.WorkOrderId#');

	</script> --->

	
</cfoutput>			