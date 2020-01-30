
<script>
	
	se = document.getElementsByName("transferperson")
	cnt = 0
	while (se[cnt]) {
	  se[cnt].className = "regular"
	  cnt++
	}  
	
	se = document.getElementsByName("transfercustomer")
	cnt = 0
	while (se[cnt]) {
	  se[cnt].className = "regular"
	  cnt++
	}  

</script>

<cfswitch expression="#url.mode#">
	
	<cfcase value="Person">
		
		<script>
		
			se = document.getElementsByName("transfercustomer")
			cnt = 0
			while (se[cnt]) {
			  se[cnt].className = "hide"
			  cnt++
			}  
		
		</script>
	
	</cfcase>

	<cfcase value="Customer">
	
		<script>
		
			se = document.getElementsByName("transferperson")
			cnt = 0
			while (se[cnt]) {
			  se[cnt].className = "hide"
			  cnt++
			}  
		
		</script>
	
	
	</cfcase>

</cfswitch>
