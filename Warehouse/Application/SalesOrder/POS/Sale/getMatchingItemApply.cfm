

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