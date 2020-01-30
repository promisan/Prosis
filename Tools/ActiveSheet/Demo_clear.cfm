<!--- test ajax --->

<cfoutput>

<!--- clear --->

	<script> 
	<cfloop index="row" from="1" to="34">
	
	    <cfloop index="lin" from="1" to="34">
				
			se = document.getElementById('cell_#row#_#lin#')	
			if (se) {
			if (se.innerHTML != "") {
			  se.innerHTML = "" 
			  se.className = "default"
			}  
			}
		
		</cfloop>
	
	</cfloop>
</script>


</cfoutput>