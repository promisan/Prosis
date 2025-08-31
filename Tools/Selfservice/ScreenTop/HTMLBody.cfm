<!--
    Copyright © 2025 Promisan B.V.

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