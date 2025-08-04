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


<script>	
    try {
	date   = document.getElementById('transaction_date');
	hour   = document.getElementById('Transaction_hour');
	minu   = document.getElementById('Transaction_minute');
	disc   = document.getElementById('Discount');
	sche   = document.getElementById('PriceSchedule');		
	reqn   = document.getElementById('RequestNo');																													
	ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/Sale/addItem.cfm?RequestNo='+reqn.value+'&warehouse=#url.warehouse#&customerid=#form.customeridselect#&customeridinvoice=#form.customerinvoiceidselect#&currency=#form.currency#&SalesPersonNo=#form.SalesPersonNo#&ItemUomId=#get.ItemUoMid#&Transactionlot=#lot#&priceschedule='+sche.value+'&discount='+disc.value+'&date='+date.value+'&hour='+hour.value+'&minu='+minu.value,'salelines');
	} catch(e) { alert('Select customer')}
</script>