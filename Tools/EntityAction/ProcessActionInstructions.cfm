<cfif Action.ActionSpecification neq "">  	

	<cfset boxno = boxno+1>
	
	<cfif menumode eq "menu">
   
    <cf_menutab item  = "#boxno#" 
	       iconsrc    = "Workflow-Instructions.png" 
		   iconwidth  = "64" 		   				
		   iconheight = "64" 
		   name       = "Instructions">	
		   
	<cfelse>
	
	   <cf_menucontainer item="#boxno#">	
	   
		   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			    
				   <tr><td bgcolor="ffffcf" align="left" style="height:48px;padding-left:10px" class="labellarge">
				   <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/warning.gif" 
				   align="absmiddle" 
				   alt="" border="0"><b>&nbsp;
	   		   	   <cfswitch expression="#Client.LanguageId#">
					 <cfcase value="ENG">			   
				        The following action(s) will need to be performed before you Decide/Forward
					 </cfcase>
					 <cfcase value="ESP">		
						Las siguiente(s) accion(es) necesitan ser realizadas antes de que usted procese el paso.
					 </cfcase>		 
					</cfswitch>		   
				   
				   </td></tr>
				   <tr><td height="1" class="linedotted"></td></tr>
				  
				   <tr><td style="padding:10px">
				   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				      <td class="labelmedium">
				      <cfoutput>#Action.ActionSpecification#</cfoutput>
					  </td>
				   </table>
				   </td></tr>
				   <tr><td height="1" class="linedotted"></td></tr>
				   <tr><td height="5"></td></tr>
		   </table>
	   	   
	    </cf_menucontainer>	
	
	
	</cfif> 	   	
	
	<!---	
	<cflayoutarea 
         name   = "instructions"
         title  = "Instructions">	
	  
	   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		    
			   <tr><td bgcolor="ffffcf" align="left" style="height:48px;padding-left:10px" class="labellarge">
			   <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/warning.gif" 
			   align="absmiddle" 
			   alt="" border="0"><b>&nbsp;
   		   	   <cfswitch expression="#Client.LanguageId#">
				 <cfcase value="ENG">			   
			        The following action(s) will need to be performed before you Decide/Forward
				 </cfcase>
				 <cfcase value="ESP">		
					Las siguiente(s) accion(es) necesitan ser realizadas antes de que usted procese el paso.
				 </cfcase>		 
				</cfswitch>		   
			   
			   </td></tr>
			   <tr><td height="1" class="linedotted"></td></tr>
			  
			   <tr><td style="padding:10px">
			   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			      <td class="labelmedium">
			      <cfoutput>#Action.ActionSpecification#</cfoutput>
				  </td>
			   </table>
			   </td></tr>
			   <tr><td height="1" class="linedotted"></td></tr>
			   <tr><td height="5"></td></tr>
	   </table>
		
	</cflayoutarea>
	
	--->
				
</cfif>  