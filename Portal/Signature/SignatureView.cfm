
<table style="width:100%" height="90">

<cfparam name="imageheight" default="80">
<cfparam name="imagewidth"  default="200">

<tr class="labelmedium"><td align="center">

<cfoutput>

	 <cfif FileExists("#SESSION.rootDocumentPath#\User\Signature\#account#.png")>	
	 
	 		<cffile action="COPY" 
					source="#SESSION.rootDocumentPath#\User\Signature\#account#.png" 
  			    	destination="#SESSION.rootPath#\CFRStage\Signature\#account#.png" nameconflict="OVERWRITE">
				 
				  <cf_assignid> 
									 		
				  <img src="#SESSION.root#\CFRStage\Signature\#account#.png?id=#rowguid#"
					     alt="Signature of #account#"
					     border="0"
					     align="absmiddle"
	                     height="#imageheight#" 
					     width="#imagewidth#">		 		 
	     
			
	 <cfelseif FileExists("#SESSION.rootDocumentPath#\User\Signature\#account#.jpg")>
	 	 
				<cffile action="COPY" 
					source="#SESSION.rootDocumentPath#\User\Signature\#account#.jpg" 
  			    	destination="#SESSION.rootPath#\CFRStage\Signature\#account#.jpg" nameconflict="OVERWRITE">
				 
				  <cf_assignid> 
									 		
				  <img src="#SESSION.root#\CFRStage\Signature\#account#.jpg?id=#rowguid#"
					     alt="Signature of #account#"
					     border="0"
					     align="absmiddle"
	                     height="#imageheight#" 
					     width="#imagewidth#">
				
		 
  	 <cfelse>		
	 
	 No signature has been loaded
			  
	 </cfif>
	 
</cfoutput>	 	 
	 
</td></tr>

</table>	 
	 
