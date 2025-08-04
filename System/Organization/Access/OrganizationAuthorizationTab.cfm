<!--
    Copyright © 2025 Promisan

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

<cf_menuScript>
<cfajaximport tags="cfform">

<cfoutput>

<table width="98%" height="100%" align="center">

<tr><td>

	  <table border="0" align="center" cellspacing="0" cellpadding="0">		
	  
	  <tr>
	  
			 <cfset ht = "64">
			 <cfset wd = "64">
					 		 
			<cfinvoke component = "Service.Access"  
			    method          = "useradmin" 
			    role            = "'AdminUser'"
			    returnvariable  = "access">	
			 
			  <cfset itm = 0>		  
			  
			  <cfif access neq "NONE">
			 
			  <cfset itm = itm+1>			    
			  <cf_menutab item  = "#itm#" 
				   iconsrc    = "Logos/System/Global.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   name       = "Global and Tree Level"
				   source     = "OrganizationAuthorizationTabDetail.cfm?scope=global">		
				   
			  </cfif>	   
					  
			  <cfset itm = itm+1>			    
				  
			  <cf_menutab item  = "#itm#" 
			      iconsrc    = "Logos/System/Tree.png" 
				  iconwidth  = "#wd#" 
				  iconheight = "#ht#" 
				  targetitem = "1"
				  name       = "Tree and Unit Level"
				  source     = "OrganizationAuthorizationTabDetail.cfm?scope=tree">		
				  
			  <cfif access eq "EDIT" or access eq "ALL"> 	  
				  
				  <cfset itm = itm+1>	  
					  
				  <cf_menutab item = "#itm#" 
				      iconsrc    = "Logos/System/Roles.png" 
					  iconwidth  = "#wd#" 
					  iconheight = "#ht#" 
					  targetitem = "1"
					  name       = "System Roles"
					  source     = "OrganizationAuthorizationTabDetail.cfm?scope=system">					  		  	
				  
			   </cfif>	  
				  
			  <cfset itm = itm+1>	  
				  
			  <cf_menutab item = "#itm#" 
			      iconsrc    = "Logos/System/Maintain.png" 
				  iconwidth  = "#wd#" 
				  iconheight = "#ht#" 
				  targetitem = "2"
				  name       = "Utilities">			
				  
			  <td width="10%"></td>	  
								  
	  </tr> 
	  
	  </table>
  
  </td></tr>
       
  <cf_menucontainer item="1" class="regular"/>  
  
  <cf_menucontainer item="2" class="hide" html="top">
  
		<table width="100%" class="formpadding" cellspacing="0" cellpadding="0">
		<tr><td style="padding-left:20px" width="260" class="labelmedium">Initialise role configuration:</td>
		    <td width="30" id="init" height=35"></td>
		    <td>
			<input type="button" name="initme" id="initme" value="Start" class="button10g" onclick="refresh()">
			</td>
			<td id="init"></td>
			<td width="70%"></td>
		</td></tr>
		</table>	  
  
  <cf_menucontainer html="bottom">
    
</table>  

<script>
    document.getElementById('menu1').click()
</script>	

</cfoutput>