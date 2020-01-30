
<!--- set time --->

<cfif url.schedule eq "600" or url.schedule eq "900" or url.schedule eq "3600">

	<script>
	 se = document.getElementsByName('endtimebox')
	 i = 0
	 while (se[i]) {
	 	se[i].className = "labelmedium"
		i++
	 }	
	 </script>
	 
<cfelse>

  <script>
	 se = document.getElementsByName('endtimebox')
	 i = 0
	 while (se[i]) {
	 	se[i].className = "hide"
		i++
	 }	
	 </script>	

</cfif> 