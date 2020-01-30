<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfinvoke component = "Service.Access"  
   method           = "staffing" 
   mission          = "#URL.Mission#"
   mandate          = "#URL.Mandate#"
   returnvariable   = "mandateAccessStaffing">	
   
<cfinvoke component = "Service.Access"  
   method           = "position" 
   mission          = "#URL.Mission#"
   mandate          = "#URL.Mandate#"
   returnvariable   = "mandateAccessPosition">	   

<cfif mandateAccessStaffing eq "NONE" and mandateAccessPosition eq "NONE">

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

		<tr><td align="center" class="labelmedium" style="padding-top:40px"><font color="FF0000">You have no access to this staffing period.<br>Please contact your administrator</td></tr>
	
	</table>	

<cfelse>

    <!--- obtain a list of functions to be shown here --->

	<cfinvoke component = "Service.Authorization.Function"  
  			 method           = "AuthorisedFunctions" 
			 mode             = "View"			 
			 mission          = "#url.mission#" 
			 orgunit          = ""
   			 Role             = ""
			 SystemModule     = "'Staffing'"
			 FunctionClass    = "'Inquiry'"
			 MenuClass        = "'Action'"
			 Except           = "''"
   			 Anonymous        = ""
			 returnvariable   = "listaccess">	  
    
	<cfoutput>
	
		<script>
		
		 function personevent(sid) {
			  ptoken.open('#SESSION.root#/Staffing/Reporting/ActionLog/EventListing.cfm?systemfunctionid='+sid+'&mission=#url.mission#&mandateno=#url.mandate#','actionbox')		 
		 }
		 
		 function personassignment(sid) {
		      ptoken.open('#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionListContent.cfm?systemfunctionid='+sid+'&mode=assignment&ts='+new Date().getTime()+'&mission=#url.mission#&mandateno=#url.mandate#','actionbox')		 
		 }
		 
		  function personaction(sid) {
		      ptoken.open('#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionListContent.cfm?systemfunctionid='+sid+'&mode=other&ts='+new Date().getTime()+'&mission=#url.mission#&mandateno=#url.mandate#','actionbox')		 
		 }
		 
		</script>
			
	<table width="98%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0">
		 
	 <tr>
	   <td style="height:20px;padding-left:10px">
		   
		   <table cellspacing="0" cellpadding="0">
		   <tr>
		     
			   <cfloop query="listaccess"> 
				
					 <td name="actionlog#currentrow#" id="actionlog#currentrow#" style="padding-top3px" #stylescroll# 			  
						  onclick="submenu('actionlog','#currentrow#','#recordcount#');#scriptname#('#systemfunctionid#')">
						  			    
			  			<table border="0" style="cursor:pointer">
				  		<tr>							
						<td height="26" align="center" style="padding-top:4px"> 
						<cf_img icon="select">
						<!---
						<img align="absmiddle" src="#SESSION.root#/Images/Logos/Staffing/Position.png" height="18" width="18">
						--->
						</td>							
						<td align="center" style="padding-left:1px;padding-right:14px" class="labelmedium"><font color="0080C0">#FunctionName#<td>
						</tr>											
				  		</table>
							
					 </td>	
				 
				</cfloop> 
				 		   
		   </tr>	   
		   </table>
	   
	   </td>		 	 
	 </tr>
	 
	 </cfoutput>
	 	 
	 <tr>
	  <td height="100%" valign="top">	  
	     <!--- content box for the listing, putting it in an iframe makes it quicker --->	
	     <iframe name="actionbox" id="actionbox" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>	  
	  </td>
	 </tr>
					  
	</table>  
	
</cfif>	 