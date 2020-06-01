
<cfparam name="Attributes.container"   default="td">
<cfparam name="Attributes.name"        default="box">
<cfparam name="Attributes.item"        default="1">
<cfparam name="Attributes.innerbox"    default="content#attributes.name##attributes.item#">
<cfparam name="Attributes.class"       default="hide">
<cfparam name="Attributes.iframe"      default="">
<cfparam name="Attributes.template"    default="">

<cfif thisTag.ExecutionMode is "start">

	<cfoutput>
	
	<cfif attributes.container eq "div">
					
	<!--- container for listing and entry --->
	
	<div class="#attributes.class#"
	    id="#attributes.name##attributes.item#" 
		name="#attributes.name##attributes.item#">
		
	
		<div height="100%" width="100%" valign="top" style="overflow:hidden"
	       id="content#attributes.name##attributes.item#" 
		   name="content#attributes.name##attributes.item#">	
		   
	<cfelse>	
	
	<tr class="#attributes.class#"
	    id="#attributes.name##attributes.item#" 
		name="#attributes.name##attributes.item#">
								
		<!--- align="center" is giving issues in IE7-9 --->
							
	   <td height="100%" width="100%" valign="top" style="overflow:hidden"
	       id="content#attributes.name##attributes.item#" 
		   name="content#attributes.name##attributes.item#">	  
		   
	</cfif>	   
		
			   		   											
		   <cfif attributes.iframe neq "">
		   		   		   		   		   
		          <iframe name="#attributes.iframe#" 
				    id="#attributes.iframe#" 
				    width="100%" 
					style="overflow:hidden"
					src="#attributes.template#"
					height="100%" 										
					frameborder="0"></iframe>							
					
		   <cfelseif attributes.template neq "">
		   
		   		 <cf_divscroll overflowx="auto" style="width:100%">	
				 							 			   		
			           <cfinclude template="#attributes.template#">		
															
				 </cf_divscroll>
							
		   </cfif>
		  		   
	</cfoutput>	   
	   
<cfelse>

	<cfif attributes.container eq "div">
	
		</div></div>
		
	<cfelse>
	
	   </td>
	</tr>
	
	</cfif>	
	
	
	   
</cfif>
	 

