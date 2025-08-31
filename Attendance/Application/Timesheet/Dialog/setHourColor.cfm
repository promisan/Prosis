<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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