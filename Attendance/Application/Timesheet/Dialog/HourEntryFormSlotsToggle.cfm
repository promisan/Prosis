
<cfoutput>

	<input type= "checkbox" 							   
	   name    = "#url.id#" 
       id      = "#url.id#"
	   onclick = "setcolor()"
	   checked
	   value   = "#url.value#" 
	   style   = "cursor: pointer;">	
	 
	 <!---  inherit the payment of the hours
	 
	    <input type="hidden" 							   
		   name    = "pay_#fld#_#slot#" 
          id      = "pay_#fld#_#slot#"								  
		  value   = "#Preset.ActivityPayment#">	
		  
	--->	  

</cfoutput>		

<script>
	setcolor()
</script>					  