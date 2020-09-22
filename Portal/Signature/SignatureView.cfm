
<table width="250" height="90">

<cfparam name="imageheight" default="80">
<cfparam name="imagewidth"  default="200">

<tr><td align="center">

<cfoutput>

	 <cfif FileExists("#SESSION.rootDocumentPath#\User\Signature\#account#.png")>		 
		 
	       <cftry>
		   
		   	   <cfif url.mode neq "PDF">
		   
		       <cfimage 
				  action="RESIZE" 
				  source="#SESSION.rootDocumentPath#\User\Signature\#account#.png" 
				  name="showimage" 
				  height="#imageheight#" 
				  width="#imagewidth#">
				  
				  <cfimage action="WRITETOBROWSER" source="#showimage#">
				  
				<cfelse>
				
				  <cf_assignid> 
									 		
				  <img src="#SESSION.rootDocument#\User\Signature\#account#.png?id=#rowguid#"
					     alt="Signature of #account#"
					     border="0"
					     align="absmiddle"
	                     height="#imageheight#" 
					     width="#imagewidth#">				 
				 
				</cfif> 
				  
			<cfcatch>
			
			  <cf_assignid> 
									 		
			  <img src="#SESSION.rootDocument#\User\Signature\#account#.png?id=#rowguid#"
				     alt="Signature of #account#"
				     border="0"
				     align="absmiddle"
                     height="#imageheight#" 
				     width="#imagewidth#">
			  			  
			</cfcatch>	  
			
			</cftry>
			
	 <cfelseif FileExists("#SESSION.rootDocumentPath#\User\Signature\#account#.jpg")>	
	 
		 	<cftry>
			
		    	<cfif url.mode neq "PDF">
		   
			       <cfimage 
					  action="RESIZE" 
					  source="#SESSION.rootDocumentPath#\User\Signature\#account#.jpg" 
					  name="showimage" 
					  height="#imageheight#" 
					  width="#imagewidth#">
				  
				  <cfimage action="WRITETOBROWSER" source="#showimage#">
				  
				 <cfelse>
				 
				  <cf_assignid> 
									 		
				  <img src="#SESSION.rootDocument#\User\Signature\#account#.jpg?id=#rowguid#"
					     alt="Signature of #account#"
					     border="0"
					     align="absmiddle"
	                     height="#imageheight#" 
					     width="#imagewidth#">
				 
				 
				 </cfif>
				  
			<cfcatch>
			
			  <cf_assignid> 
									 		
			  <img src="#SESSION.rootDocument#\User\Signature\#account#.jpg?id=#rowguid#"
				     alt="Signature of #account#"
				     border="0"
				     align="absmiddle"
                     height="#imageheight#" 
				     width="#imagewidth#">
			  			  
			</cfcatch>	  
			
			</cftry>	
		 
  	 <cfelse>		 
			 
		  <b><img src="#SESSION.root#/Images/image-not-found.gif" alt="Not found" style="height: auto;width: #imagewidth#px;margin: auto;" border="0" align="absmiddle"></b>
			  
	 </cfif>
	 
</cfoutput>	 	 
	 
</td></tr>

</table>	 
	 
