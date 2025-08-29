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
 <table width="100%" class="navigation_table">
 		  
  	  <cfinvoke component="Service.AccessGlobal"  
         method="global" 
      	 role="AdminRoster" 
      	 returnvariable="Access"
	  	 Parameter="#url.Owner#">
		 			  
	  <cfoutput>			  
	 			  
		  <cfif Access eq "ALL" or Access eq "EDIT">
		  
			  <tr class="line labelmedium2 navigation_row" style="height:35px" onClick="access('#URL.IDFunction#','0','0','#url.source#')">
			  
			  <td style="padding-left:4px;padding-right:4px">
			 				 
				<img src="#SESSION.root#/Images/Logos/System/ListCollapsed.png" 
					id="0Exp" class="regular" style="cursor: pointer;" height="22">
					
					<img src="#SESSION.root#/Images/Logos/System/ListExpanded.png" 
					id="0Min" class="hide" style="cursor: pointer;" height="22">
										
			  </td>
			  <td style="width:100%;font-size:18px;"><cf_tl id="Read only"></a></td>			  
			  </tr>		  
		      
			  <tr class="hide" id="0"><td colspan="2" id="i0"></td></tr>			  
			  <cfif url.source eq "manual">				  
							  
			  <tr class="line labelmedium2 navigation_row" style="height:35px" onClick="access('#URL.IDFunction#','IN','0','#url.source#')">
			  
			  <td style="padding-left:4px;padding-right:4px">
			 				 
				<img src="#SESSION.root#/Images/Logos/System/ListCollapsed.png" alt="" 
					id="INExp" class="regular" style="cursor: pointer;" height="22">
					
					<img src="#SESSION.root#/Images/Logos/System/ListExpanded.png" 
					id="INMin" class="hide" style="cursor: pointer;" height="22">					
					
			  </td>			  
			  <td style="width:100%;font-size:18px;">Manually Record Candidates</td>
			  
			  </tr>		  
		      
			  <tr class="hide" id="IN"><td colspan="2" id="iIN"></td></tr>
			  			  
			  </cfif>
			  			  
		  </cfif>			  
					  
	  </cfoutput>		
		  
	  <cfquery name="AccessLevels" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT 	*
			 FROM 		Ref_AuthorizationRole 		
			 WHERE 		Role = 'RosterClear' 
	  </cfquery>
	  
	  <cfquery name="OwnerStatus"
         datasource="AppsSelection" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
          SELECT * 
     	  FROM   Ref_StatusCode
    	  WHERE  Owner = '#url.Owner#'
	      AND    Id    = 'Fun'
	 	 <!--- AND RosterAction = '1' --->
	      AND    Status != '0'
	  </cfquery>
	  
	  <cfset accessLabel = ListToArray(AccessLevels.accesslevelLabelList)>
		
	  <cfoutput>
	  
	    <cfinvoke component="Service.AccessGlobal"  
          method="global" 
	      role="AdminRoster" 
	      returnvariable="Access"
		  Parameter="#url.Owner#">		
	  		
		  <cfloop index="accesslevel" from="0" to="#AccessLevels.accesslevels-1#">
		  	
		      <cfif accesslevel gt "0">		  			 	
					  
				   <!--- check if this access level handles the preroster status --->
				   	  
				  <cfquery name="checkStatus"
			         datasource="AppsSelection" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
					 SELECT   TOP 1 PreRosterStatus
				     FROM     Ref_StatusCodeProcess A INNER JOIN
		                      Ref_StatusCode R ON A.Owner = R.Owner AND A.Id = R.Id AND A.StatusTo = R.Status
					 WHERE    A.Owner    = '#url.Owner#' 
					 AND      A.Id       = 'FUN'					 
					 AND      A.AccessLevel = '#accesslevel#'
					 AND      A.Process = 'Process' 
					 ORDER BY PreRosterStatus DESC
				 </cfquery>	 			 
				
				 									 				  				  
				  <cfif Access eq "ALL" or (Access eq "EDIT" and checkstatus.PrerosterStatus eq "0")>
				  
					  <tr class="line labelmedium2 navigation_row" style="height:35px" onClick="access('#URL.IDFunction#','#accesslevel#','1','#url.source#')">					  
					  <td style="padding-left:4px;padding-right:4px"> 
					  
						<img src="#SESSION.root#/Images/Logos/System/ListCollapsed.png" alt="" 
							id="#accesslevel#Exp" class="regular" style="cursor: pointer;" height="22">
							
							<img src="#SESSION.root#/Images/Logos/System/ListExpanded.png" 
							id="#accesslevel#Min" class="hide" style="cursor: pointer;" height="22">
							
					  </td>
					  <td style="width:100%;font-size:18px;">#accessLabel[accesslevel+1]#</a></td>					  
					  </tr>						  				   
				      
					  <tr class="hide" id="#AccessLevel#"><td colspan="2" id="i#accesslevel#"></td></tr>			 					     					 
										  				  
				  </cfif>
			  
			  </cfif>			  
			  				  
		  </cfloop>
	  
	  </cfoutput>
			  
 </table>		
 
 <cfset ajaxOnLoad("doHighlight")>