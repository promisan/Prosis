
<cfoutput>

<cfif url.transactiontype eq "8" or url.TransactionType eq "6">

	<script language="JavaScript">	
	
	 ColdFusion.navigate('../Transaction/getTransferSelect.cfm?warehouse=#url.warehouse#&location=#url.location#','locationtransferbox')		
	
	 se = document.getElementsByName("box2")	 
	 cnt = 0		 
	 while (se[cnt]) {
	    se[cnt].className = "hide"
		cnt++
	 }
			 		 
	 se = document.getElementsByName("box8")
	 cnt = 0
	 while (se[cnt]) {
	    se[cnt].className = "regular"
		cnt++
	 }
	 
		 
 	</script>			


<cfelse>
			
	<script language="JavaScript">			
		
	 se = document.getElementsByName("box8")
	 cnt = 0
	 while (se[cnt]) {
	    se[cnt].className = "hide"
		cnt++
	 }
	 		 
	 se = document.getElementsByName("box2")
	 cnt = 0
	 while (se[cnt]) {
	    se[cnt].className = "regular"
		cnt++
	 }
		 
 	</script>			
	
</cfif>	
	
</cfoutput>	

