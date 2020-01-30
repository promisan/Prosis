
<cfparam name="form.action" default="">
<cfparam name="form.actioncode" default="">

<cfif form.actioncode neq "0">
	
	<cfquery name="action" 
	  	datasource="AppsEmployee" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">
	      SELECT *			 
		  FROM   Ref_WorkActivity
		  WHERE  ActionCode = '#form.actioncode#'	 
	</cfquery>

	<cfset color = action.actionColor>

<cfelse>
	
	<cfquery name="action" 
	  	datasource="AppsEmployee" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">
	      SELECT *			 
		  FROM   Ref_WorkAction
		  WHERE  ActionClass = '#form.actionclass#'
		  AND    Operational = 1
	</cfquery>

	<cfset color = action.viewColor>

</cfif>

<cfoutput>
							
	<script language="JavaScript">

		  cnt = 0		  
		  while (cnt != 24) {
		  
		       slot= 0		  		   		   
			   while (slot != 4) {			 			 			   
			     slot++
				 try { 				 
				       se = document.getElementById('option_'+cnt+'_'+slot)				  
					   op = document.getElementById('slot_'+cnt+'_'+slot)					  
		        	   if (op.checked == true) {					 
				           se.style.backgroundColor = '#color#' 
						   } else {
						   se.style.backgroundColor = "transparent" 
						   }						   
			      } catch(e) {}  					 
			    }	
			cnt++;	  				
		  }	
		  
	</script>	   

</cfoutput>	