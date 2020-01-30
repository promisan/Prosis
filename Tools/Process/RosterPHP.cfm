
<!--- End Prosis template framework --->
<cfparam name="Attributes.DisplayType"   default="Button">
<cfparam name="Attributes.DisplayText"   default="Print PHP">
<cfparam name="Attributes.Format"        default="Document">
<cfparam name="Attributes.RosterList"    default="">
<cfparam name="Attributes.Image"         default="#SESSION.root#/Images/pdf_button.png">
<cfparam name="Attributes.ButtonWidth"   default="21">
<cfparam name="Attributes.ButtonHeight"  default="21">
<cfparam name="Attributes.Class"         default="">
<cfparam name="Attributes.Style"         default="">
<cfparam name="Attributes.Owner"         default="">
<cfparam name="Attributes.Script"        default="1">
<cfparam name="Attributes.IDFunction"    default="1">


<cfquery name="Owner" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  TOP 1 *
	FROM   Ref_ParameterOwner
	<cfif Attributes.Owner neq "">
	WHERE  Owner = '#Attributes.Owner#'
	</cfif>
</cfquery>

<cfif DirectoryExists("#SESSION.rootpath#\CFRStage\User\#SESSION.acc#")>

       <!--- skip--->				
	   
<cfelse>  	
						  
      <cfdirectory 
		  action   = "CREATE" 
	      directory= "#SESSION.rootpath#\CFRStage\User\#SESSION.acc#">
				  
</cfif>

<cfif Owner.PathHistoryProfile eq "">
	<cfset path = "Roster/PHP/PDF/PHP_Combined_List.cfm">
<cfelse>
    <cfset path = "Custom/#Owner.PathHistoryProfile#">
</cfif>

<cfif Owner.recordcount eq "0">

	PHP not available
	
<cfelse>

	<cfoutput>
			
		<cfif Attributes.RosterList neq "">
		
		    <cfif attributes.script eq "1">
						
				<cf_ajaxrequest>
						
				<script language="JavaScript">
				
					function printingPHP(roster,format,script) {
									
						document.getElementById("php_"+script).className = "hide"
						document.getElementById("wait_"+script).className = "regular"
																						
						url = "#SESSION.root#/#path#?IDFunction=#Attributes.IDFunction#&PHP_Roster_List="+roster+"&FileNo="+script	
																						
				 		AjaxRequest.get({			
				        'url':url,    	    
						'onSuccess':function(req) { 	
						 document.getElementById("php_"+script).className = "regular"
						 document.getElementById("wait_"+script).className = "hide"
					  	 window.open("#SESSION.root#/cfrstage/user/#SESSION.acc#/php_"+script+".pdf?IDFunction=#Attributes.IDFunction#&ts="+new Date().getTime(),"php_"+script, "location=no, toolbar=no, scrollbars=yes, resizable=yes")
						
		           	  },					
			    	    'onError':function(req) { 	
						 document.getElementById("wait_"+script).className = "hide"
						 alert("An error has occurred upon preparing this PHP. A notification email was sent to the administrator.")}	
			    	     });	
								
					 }
			
				</script>
			
			</cfif>
			
			<table width="100%">
			
			<tr><td class="hide" align="center" id="wait_#attributes.script#">
					
					<img src="#SESSION.root#/Images/wait.gif" 
					  alt="Please wait for PHP to be generated" 
					  width="19" 
					  height="19" 
					  border="0" 
					  align="absmiddle">
					
			</td>
			</tr>
			
			<tr>
			
			<td id="php_#attributes.script#">
					
				<cfdiv id="detail_#attributes.script#">		
			
				<cfif Attributes.DisplayType eq "Button">
				
				   <input style="#Attributes.Style#" 
				   type    = "button" 
				   style   =  "width:#Attributes.ButtonWidth#;height=#Attributes.ButtonHeight#;#Attributes.Style#"
				   name    = "Edit" 
				   id      = "Edit"
				   type    = "button"
				   value   = "#Attributes.DisplayText#" 
				   class   = "#Attributes.Class#" 
				   onClick = "printingPHP('#Attributes.RosterList#','#Attributes.Format#','#Attributes.script#')">	
				   
				<cfelseif Attributes.DisplayType eq "Graphic">
						
					  <table><tr><td class="labelit">		  
			  		  <a href="javacript:printingPHP('#Attributes.RosterList#','#Attributes.Format#','#Attributes.script#')">
				      <font color="6688aa">#Attributes.DisplayText#</font>
					  </a>
					  </td>
					  <td>
				     
				      <button title   =  "PHP" 
						      class   =  "#Attributes.Class#"
							  type    =  "button"
			                  onClick =  "printingPHP('#Attributes.RosterList#','#Attributes.Format#','#Attributes.script#')"
						      style   =  "width:#Attributes.ButtonWidth#;height=#Attributes.ButtonHeight#;#Attributes.Style#">
						 
						 	  <img src     = "#Attributes.Image#"
						    	   alt     = "Personal History Profile" 						
							       border  = "0" 
								   align   = "absmiddle" 
							       style   = "#Attributes.Style#">
						
				      </button>
				  
				      </td></tr></table>	
				  
				 <cfelse>
				 
				 	 <table><tr><td class="labelit">	
				      
					  <a href="javascript:printingPHP('#Attributes.RosterList#','#Attributes.Format#','#Attributes.script#')">
				      	<font color="6688aa">#Attributes.DisplayText#</font>
					  </a>
					  
					  </td>
					  <td>		  
					  					  
					  									 
				      <button title   =  "PHP" 
							  class   =  "button3"
							  type    =  "button"
				              onClick =  "printingPHP('#Attributes.RosterList#','#Attributes.Format#','#Attributes.script#')">
				
							   <img src     = "#Attributes.Image#"			    
						        alt     = "Personal History Profile" 
						        border  = "0" 
							    align   = "absmiddle" 
						        style   = "#Attributes.Style#">				
								
				      </button>		 
					  
					   </td></tr>
					   </table>		
					
				 </cfif>
			 
			 	</cfdiv>
			 
			 </td></tr>
			 
		 </table>
			  
		</cfif>
		
	</cfoutput>

</cfif>