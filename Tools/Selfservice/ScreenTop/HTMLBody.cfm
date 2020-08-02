<cfoutput>

	<cfif attributes.html eq "No">		
										
		<cfif attributes.bgimage eq "">		
										
			<body leftmargin="#attributes.margin#" 
				  topmargin="#attributes.margin#" 
				  rightmargin="#attributes.margin#" 
				  bottommargin="#attributes.margin#"  	
				  style="<cfif attributes.overflow eq 'hidden'>overflow: hidden;</cfif>" 
				  onLoad="<cfif attributes.validateSession eq 'Yes'>sessionvalidatestart();</cfif><cfif attributes.focuson eq 'window'>window.focus()<cfelseif attributes.focuson neq 'none'>document.getElementById('#attributes.focuson#').focus()</cfif>">
			
			<cfelse>	  
			
			<body background="<cfoutput>#attributes.bgimage#</cfoutput>"
				  style="overflow-x: hidden;<cfoutput>#attributes.bstyle#</cfoutput>"				 
				  leftmargin="#attributes.margin#" 
				  topmargin="#attributes.margin#" 				 
				  rightmargin="#attributes.margin#" 
				  bottommargin="#attributes.margin#" 																		 
				  onLoad="<cfif attributes.validateSession eq 'Yes'>sessionvalidatestart();</cfif><cfif attributes.focuson eq 'window'>window.focus()<cfelseif attributes.focuson neq 'none'>document.getElementById('#attributes.focuson#').focus()</cfif>">
			
		</cfif>	
	
	<cfelseif attributes.html eq "Yes">	
					
			<body bgcolor="<cfif attributes.layout eq 'InnerBox'>#attributes.color#<cfelse>d0d0d0</cfif>" 
				  leftmargin="0" 
				  topmargin="0" 				 
				  rightmargin="0" 
				  bottommargin="0"		
				  onBlur="<cfif attributes.blur eq 'yes'>parent.window.close()</cfif>"		   														
				  style="<cfif attributes.overflow eq 'hidden'>overflow: hidden;</cfif>" 
				  onLoad="<cfif attributes.validateSession eq 'Yes'>sessionvalidatestart();</cfif><cfif attributes.focuson eq 'window'>window.focus()<cfelseif attributes.focuson neq 'none'>document.getElementById('#attributes.focuson#').focus()</cfif>">					 
				  
	<cfelse>
	
			<body leftmargin="0" 
				  topmargin="0" 				 
				  rightmargin="0" 
				  bottommargin="0"		
				  onBlur="<cfif attributes.blur eq 'yes'>parent.window.close()</cfif>"			   														
				  style="<cfif attributes.overflow eq 'hidden'>overflow: hidden;</cfif>" 
				  onLoad="<cfif attributes.validateSession eq 'Yes'>sessionvalidatestart();</cfif><cfif attributes.focuson eq 'window'>window.focus()<cfelseif attributes.focuson neq 'none'>document.getElementById('#attributes.focuson#').focus()</cfif>">					 				  
				 
	</cfif>
	
</cfoutput>		