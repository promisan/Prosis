<cf_param name="url.acc" 			default="#session.acc#" type="string">
<cf_param name="url.width" 			default="54px"			type="string">
<cf_param name="url.height" 		default="44px"			type="string">
<cf_param name="url.destination" 	default="EmployeePhoto" type="string">
<cf_param name="url.style" 			default="" 				type="string">

<cfoutput>
						
	<cf_assignid>	
		
	<cfif FileExists("#SESSION.rootDocumentPath#\#url.destination#\#url.acc#.jpg") and url.acc neq "">		
		
		<img src="#SESSION.rootDocument#/#url.destination#/#url.acc#.jpg?random=#rowguid#"
			border="0px"
			style="display:block; cursor:pointer; height:#url.height#; width:#url.width#; #url.style#"
			align="absmiddle">
				
	<cfelse>		 
			
		<img src="#SESSION.root#/Images/Logos/no-picture-male.png" 
		    alt="Click here to add a Profile Picture" 
			title="Click here to add a Profile Picture" 
			border="0px" 
			align="absmiddle" 
			style="display:block; cursor:pointer; height:#url.height#; width:#url.width#; #url.style#">
		
	</cfif>	
		
</cfoutput>	