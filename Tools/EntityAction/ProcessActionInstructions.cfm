<cfif Action.ActionSpecification neq "">  	

	<cfset boxno = boxno+1>
	
	<cfif menumode eq "menu">	
	
	<cfif boxno eq "1">
		   <cfset cl = "highlight">
	   <cfelse>
	   	   <cfset cl = "regular">	   
	   </cfif>
	   
    <cf_menutab item  = "#boxno#" 
	       iconsrc    = "Workflow-Instructions.png" 
		   iconwidth  = "#wd#" 	
		   class      = "#cl#"		   				
		   iconheight = "#ht#" 
		   name       = "Instructions">	
		   
	<cfelse>
			
	   <cf_menucontainer item="#boxno#">	
	   
	   	   <table width="100%" align="center" class="formpadding">
		   <tr><td style="padding:5px">
	   	   
		   <table width="100%" align="center" class="formpadding">
			    				
				   <tr><td bgcolor="DF7000" align="left" style="color:white;border:1px solid gray;height:33px;font-size:16px;padding-left:10px" class="labelmedium">				  
				   				   
	   		   	   <cfswitch expression="#Client.LanguageId#">
					 <cfcase value="ENG">			   
				        The following action(s) will need to be performed before you Decide/Forward
					 </cfcase>
					 <cfcase value="ESP">		
						Las siguiente(s) accion(es) necesitan ser realizadas antes de que usted procese el paso.
					 </cfcase>		 
					</cfswitch>		   
				   
				   </td></tr>
				   <tr><td height="1" class="line"></td></tr>
				  
				   <tr><td style="padding:10px">
				   <table width="100%" border="0" align="center" class="formpadding">
				      <td class="labelmedium" style="padding:14px">
				      <cfoutput>#Action.ActionSpecification#</cfoutput>
					  </td>
				   </table>
				   </td></tr>
				   <tr><td height="1" class="line"></td></tr>
				   <tr><td height="5"></td></tr>
		   </table>
		   
		   </td></tr>
		   
		   <tr>
				 <td align="right" height="25" style="padding-top:3px;padding-right:20px">						 					 
										   
				   <cfset nextbox = boxno+1>
					 <cfoutput>			   					   					   					   					 		 
					    <input type = "button" 
						class       = "button10g" 
						style       = "width:210px;height:29px;font-size:14px;"						
						value       = "Next" 
						onclick     = "document.getElementById('menu#nextbox#').click()">
					</cfoutput>  				
										
				 </td>
			 </tr>
		   
		   </table>
	   	   
	    </cf_menucontainer>		
	
	</cfif> 	   		
					
</cfif>  