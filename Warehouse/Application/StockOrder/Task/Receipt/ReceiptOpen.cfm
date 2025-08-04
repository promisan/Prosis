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

<!--- redirect to the receipts --->

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfif URL.ID1 eq "Pending">

	<tr><td>
	<iframe src="#SESSION.root#/Procurement/Application/Receipt/ReceiptView/ReceiptViewListing.cfm?mission=#url.mission#&warehouse=#url.warehouse#&id=STA&id1=pending" 
	    width="100%" 
		height="100%" 
		scrolling="no" 
		frameborder="0"></iframe>
	</td></tr>

<cfelse>

	<tr><td>
	<iframe src="#SESSION.root#/Procurement/Application/Receipt/ReceiptView/ReceiptViewView.cfm?actionstatus=#url.actionstatus#&mission=#url.mission#&warehouse=#url.warehouse#&id=STA&id1=locate" 
	    width="100%" 
		height="100%" 
		scrolling="no" 
		frameborder="0"></iframe>
	</td></tr>

</cfif>

</table>

</cfoutput>