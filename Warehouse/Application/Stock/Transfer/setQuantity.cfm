
<cfset mtr  = url.meter>
<cfset ini  = replace(url.initial,",","","ALL")>
<cfset fin  = replace(url.final,",","","ALL")> 

<cfoutput>
	
	<cftry>
		
		<cfset val = fin-ini>
			
		<script>
		
			document.getElementById('#url.field#').value = '#numberformat('#val#','__,__')#'	
			
			trfsave('#url.TransactionId#',document.getElementById('transferwarehouse#url.TransactionId#').value,document.getElementById('transferlocation#url.TransactionId#').value,'#mtr#','#ini#','#fin#','#val#',document.getElementById('transfermemo#url.TransactionId#').value,document.getElementById('itemuomid#url.TransactionId#').value,this.value,document.getElementById('transfermemo#url.TransactionId#').value,'',document.getElementById('transaction#url.TransactionId#_date').value,document.getElementById('transaction#url.TransactionId#_hour').value,document.getElementById('transaction#url.TransactionId#_minute').value)		
			
		</script>
		
		<cfcatch>
			
			<script>
				 alert('Invalid number')
			</script>
		
		</cfcatch>
	
	</cftry>

</cfoutput>