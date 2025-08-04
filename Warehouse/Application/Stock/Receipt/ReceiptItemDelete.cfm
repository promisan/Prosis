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

<cfquery name="removeItem"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		UPDATE	Receipt#URL.Warehouse#_#SESSION.acc#
		SET		Selected = '0',
				TransferWarehouse = null,
				TransferLocation = null,
				TransferQuantity = Quantity,
				TransferItemNo = null,
				TransferUoM = null,
				TransferMemo = null
		WHERE   TransactionId = #url.id#
		
</cfquery>

<cfoutput>
	<script>
		ptoken.navigate('#SESSION.root#/warehouse/application/stock/receipt/StockreceiptProcessView.cfm?mission=#url.mission#&warehouse=#url.warehouse#','contentbox1');
	</script>
</cfoutput>