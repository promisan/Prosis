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
<!--- ACCESS block --->    
	
            
   <table width="100%" cellspacing="0" cellpadding="0">
      
	   <tr><td>
	   
		   <table width="100%">
			    <tr><td align="center" width="30" height="25">
			    <cfoutput>
				<img src="#SESSION.root#/Images/Logos/System/ListCollapsed.png" height="27"
					id="accessExp" class="regular" style="cursor: pointer;" 
					onClick="more('access','show')">
					
					<img src="#SESSION.root#/Images/Logos/System/ListExpanded.png" height="27" 
					id="accessMin" class="hide" style="cursor: pointer;" 
					onClick="more('access','hide')">
				</cfoutput>	
				</td>
				<td><a href="javascript: more('access','show')">Grant access to this bucket</a></b></td>
				</tr>
		  </table>
	  
	  </td></tr>
	    
	 
	  <tr class="hide" id="access"><td>
	    
		  <table width="100%" cellspacing="0" cellpadding="0" >
		    	
		  <!--- read access --->	  
		  
		  	  <cfinvoke component="Service.AccessGlobal"  
	          method="global" 
		      role="AdminRoster" 
		      returnvariable="Access"
			  Parameter="#Function.Owner#">
			  
			  <cfoutput>			  
			 			  
				  <cfif Access eq "ALL" or Access eq "EDIT">
				  
					  <tr>
					  
					  <td width="8%" align="center">
					 					 				 
						<img src="#SESSION.root#/Images/Logos/System/ListCollapsed.png" height="27"
							id="0Exp" class="regular" style="cursor: pointer;" 
							onClick="access('#URL.IDFunction#','show','0')">
							
							<img src="#SESSION.root#/Images/Logos/System/ListExpanded.png" height="27"
							id="0Min" class="hide" style="cursor: pointer;" 
							onClick="access('#URL.IDFunction#','hide','0')">
							
							
						</td>
					  <td height="25"><a href="javascript: access('#URL.IDFunction#','show','0')"><cf_tl id="Read only"></a></td>
					  
					  </tr>		  
				      
					  <tr class="hide" id="0"><td colspan="2">
						<table width="100%" border="0">
							<iframe name="i0" id="i0" width="100%" height="50" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0"></iframe>
						</table> 
					  </td></tr>
					  
					  <tr><td height="1" colspan="2" bgcolor="silver"></td></tr>
					  <tr><td height="2" colspan="2"></td></tr> 
					  
					  
					   <tr>
					  
					  <td width="8%" align="center">
					  
					 				 
						<img src="#SESSION.root#/Images/Logos/System/ListCollapsed.png" height="27"
							id="0Exp" class="regular" style="cursor: pointer;" 
							onClick="access('#URL.IDFunction#','show','IN')">
							
							<img src="#SESSION.root#/Images/Logos/System/ListExpanded.png" height="27"
							id="0Min" class="hide" style="cursor: pointer;" 
							onClick="access('#URL.IDFunction#','hide','IN')">
							
							
						</td>
					  <td height="25"><a href="javascript: access('#URL.IDFunction#','show','IN')"><b>Manually Record Candidates</b></a></td>
					  
					  </tr>		  
				      
					  <tr class="hide" id="0"><td colspan="2">
						<table width="100%" border="0">
							<iframe name="i0" id="i0" width="100%" height="50" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0"></iframe>
						</table> 
					  </td></tr>
					  
					  <tr><td height="1" colspan="2" bgcolor="silver"></td></tr>
					  <tr><td height="2" colspan="2"></td></tr> 
					  
					  
					  
				  
				  </cfif>			  
							  
			  </cfoutput>
			  
			  				  
				  <cfquery name="OwnerStatus"
	          datasource="AppsSelection" 
	          username="#SESSION.login#" 
	          password="#SESSION.dbpw#">
	          SELECT * 
	     	  FROM Ref_StatusCode
	    	  WHERE Owner = '#Function.Owner#'
		      AND Id = 'Fun'
			  <!---
		      AND RosterAction = '1' --->
			  and Status != '0'
			  </cfquery>
			  
			  <cfoutput query="OwnerStatus">
			  			 			 			  
				  <cfinvoke component="Service.AccessGlobal"  
		          method="global" 
			      role="AdminRoster" 
			      returnvariable="Access"
				  Parameter="#Function.Owner#">
				  
				 				  				  
				  <cfif Access eq "ALL" or Access eq "EDIT">
				  
					  <tr>
					  
					  <td width="8%" align="center" height="25">
					  
						<img src="#SESSION.root#/Images/Logos/System/ListCollapsed.png" height="27" 
							id="#status#Exp" class="regular" style="cursor: pointer;" 
							onClick="access('#URL.IDFunction#','show','#Status#','#RosterAction#')">
							
							<img src="#SESSION.root#/Images/Logos/System/ListExpanded.png" height="27"
							id="#status#Min" class="hide" style="cursor: pointer;" 
							onClick="access('#URL.IDFunction#','hide','#Status#','#RosterAction#')">
														
						</td>
					  <td><a href="javascript: access('#URL.IDFunction#','show','#Status#','#RosterAction#')"><b>#Meaning#</b></a></td>
					  
					  </tr>		
					  				   
				      
					  <tr class="hide" id="#Status#"><td colspan="2">
					 	<table width="100%" border="0">
							<iframe name="i#Status#" id="i#Status#" width="100%" height="10" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0"></iframe>
						</table> 
					  </td>
					 
					  </tr>
					 					  
					  <cfif currentRow neq recordcount>
					  	<tr><td height="1" colspan="2" bgcolor="silver"></td></tr>
					  </cfif>
					  <tr><td height="2" colspan="2"></td></tr> 
					  				  
				  </cfif>
				  
				  				  
			  </cfoutput>
			  
	    </table>		
		
	  </td></tr>
	   <tr><td height="1" bgcolor="silver"></td></tr>
  </table>
  