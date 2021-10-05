
<table style="width:100%" height="90">

<cfparam name="imageheight" default="80">
<cfparam name="imagewidth"  default="200">

<tr class="labelmedium"><td align="center">

<cfoutput>

    <cftry>
		<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\User\Signature">		
		<cfcatch></cfcatch>
	</cftry>
	
	<cftry>		
		<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\CFRStage\Signature">
		<cfcatch></cfcatch>
	</cftry>

	 <cfif FileExists("#SESSION.rootDocumentPath#\User\Signature\#account#.png")>	
	 
			<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			<cfset mid = oSecurity.gethash()/> 

	 		<cffile action="COPY" 
					source="#SESSION.rootDocumentPath#\User\Signature\#account#.png" 
  			    	destination="#SESSION.rootDocumentPath#\CFRStage\Signature\#account#.png" 
					nameconflict="OVERWRITE">
				 
				  <img src="#SESSION.root#/CFRStage/getFile.cfm?id=#account#.png&mode=Signature&mid=#mid#"
					     alt    = "Signature of #account#"
					     border = "0"
					     align  = "absmiddle"
	                     height = "#imageheight#" 
					     width  = "#imagewidth#">	     
			
	 <cfelseif FileExists("#SESSION.rootDocumentPath#\User\Signature\#account#.jpg")>
	 
	 		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			<cfset mid = oSecurity.gethash()/> 

     		<cffile action="COPY" 
					source="#SESSION.rootDocumentPath#\User\Signature\#account#.jpg" 
  			    	destination="#SESSION.rootDocumentPath#\CFRStage\Signature\#account#.jpg" nameconflict="OVERWRITE">
				 
				  <img src="#SESSION.root#/CFRStage/getFile.cfm?id=#account#.jpg&mode=Signature&mid=#mid#"
					     alt    = "Signature of #account#"
					     border = "0"
					     align  = "absmiddle"
	                     height = "#imageheight#" 
					     width  = "#imagewidth#">				 				
		 
  	 <cfelse>		
	 
	 No signature has been loaded
			  
	 </cfif>
	 
</cfoutput>	 	 
	 
</td></tr>

</table>	 
	 
