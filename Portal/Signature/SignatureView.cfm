
<table width="250" height="90">

<tr><td align="center">

<cfoutput>

	 <cfif FileExists("#SESSION.rootDocumentPath#\User\Signature\#account#.png")>		 
		 
	       <cftry>
		   
		   	   <cfif url.mode neq "PDF">
		   
		       <cfimage 
				  action="RESIZE" 
				  source="#SESSION.rootDocumentPath#\User\Signature\#account#.png" 
				  name="showimage" 
				  height="80" 
				  width="200">
				  
				  <cfimage action="WRITETOBROWSER" source="#showimage#">
				  
				<cfelse>
				
				  <cf_assignid> 
									 		
				  <img src="#SESSION.rootDocument#\User\Signature\#account#.png?id=#rowguid#"
					     alt="Signature of #account#"
					     border="0"
					     align="absmiddle"
	                     height="80" 
					     width="200">				 
				 
				</cfif> 
				  
			<cfcatch>
			
			  <cf_assignid> 
									 		
			  <img src="#SESSION.rootDocument#\User\Signature\#account#.png?id=#rowguid#"
				     alt="Signature of #account#"
				     border="0"
				     align="absmiddle"
                     height="80" 
				     width="200">
			  			  
			</cfcatch>	  
			
			</cftry>
			
	 <cfelseif FileExists("#SESSION.rootDocumentPath#\User\Signature\#account#.jpg")>	
	 
		 	<cftry>
			
		    	<cfif url.mode neq "PDF">
		   
			       <cfimage 
					  action="RESIZE" 
					  source="#SESSION.rootDocumentPath#\User\Signature\#account#.jpg" 
					  name="showimage" 
					  height="80" 
					  width="200">
				  
				  <cfimage action="WRITETOBROWSER" source="#showimage#">
				  
				 <cfelse>
				 
				  <cf_assignid> 
									 		
				  <img src="#SESSION.rootDocument#\User\Signature\#account#.jpg?id=#rowguid#"
					     alt="Signature of #account#"
					     border="0"
					     align="absmiddle"
	                     height="80" 
					     width="200">
				 
				 
				 </cfif>
				  
			<cfcatch>
			
			  <cf_assignid> 
									 		
			  <img src="#SESSION.rootDocument#\User\Signature\#account#.jpg?id=#rowguid#"
				     alt="Signature of #account#"
				     border="0"
				     align="absmiddle"
                     height="80" 
				     width="200">
			  			  
			</cfcatch>	  
			
			</cftry>	
		 
  	 <cfelse>		 
			 
		  <b><img src="#SESSION.root#/Images/image-not-found.gif" alt="Not found" style="height: auto;width: 200px;margin: auto;" border="0" align="absmiddle"></b>
			  
	 </cfif>
	 
</cfoutput>	 	 
	 
</td></tr>

</table>	 
	 
