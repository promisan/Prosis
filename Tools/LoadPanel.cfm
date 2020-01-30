
<cfparam name="attributes.id"        default="left">
<cfparam name="attributes.var"       default="prg">
<cfparam name="attributes.template"  default="">
<cfparam name="attributes.condition" default="">

<cfoutput>

<script language="JavaScript1.2">

     #attributes.var# = setInterval('loadpanelcontent()', 1200) 		
	
   	 function loadpanelcontent() {		
	 	   
	    <cfif attributes.condition neq "">	   		
	 		window.#attributes.id#.open = "#attributes.template#?#attributes.condition#"			 		
		<cfelse>
			window.#attributes.id#.location = "#attributes.template#"		
		</cfif>
		
		clearInterval ( #attributes.var# )				
   	 }			 

</script>
				 
</cfoutput>				 