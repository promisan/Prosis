
 <table width="100%" cellspacing="0" cellpadding="0">
 
   <tr><td height="5"></td></tr>
		  
  	  <cfinvoke component="Service.AccessGlobal"  
         method="global" 
      	 role="AdminRoster" 
      	 returnvariable="Access"
	  	 Parameter="#url.Owner#">
		 			  
	  <cfoutput>			  
	 			  
		  <cfif Access eq "ALL" or Access eq "EDIT">
		  
			  <tr>
			  
			  <td width="8%" align="center" style="padding-left:4px;padding-right:4px">
			 				 
				<img src="#SESSION.root#/Images/ct_collapsed.gif" alt="" 
					id="0Exp" border="0" class="regular" 
					align="middle" style="cursor: pointer;" 
					onClick="access('#URL.IDFunction#','0','0','#url.source#')">
					
					<img src="#SESSION.root#/Images/ct_expanded.gif" 
					id="0Min" alt="" border="0" 
					align="middle" class="hide" style="cursor: pointer;" 
					onClick="access('#URL.IDFunction#','0','0','#url.source#')">
										
				</td>
			  <td height="25" class="labelmedium"><a href="javascript: access('#URL.IDFunction#','0','0')">Read only</b></a></td>
			  
			  </tr>		  
		      
			  <tr class="hide" id="0"><td colspan="2">
			     <cfdiv id="i0">									
			  </td></tr>
			  
			  <tr><td height="1" colspan="2" class="linedotted"></td></tr>
			  <tr><td height="2" colspan="2"></td></tr> 
			  
			  <cfif url.source eq "manual">				  
							  
			  <tr>
			  
			  <td width="8%" align="center" style="padding-left:4px;padding-right:4px">
			 				 
				<img src="#SESSION.root#/Images/ct_collapsed.gif" alt="" 
					id="INExp" border="0" class="regular" 
					align="middle" style="cursor: pointer;" 
					onClick="access('#URL.IDFunction#','IN','0','#url.source#')">
					
					<img src="#SESSION.root#/Images/ct_expanded.gif" 
					id="INMin" alt="" border="0" 
					align="middle" class="hide" style="cursor: pointer;" 
					onClick="access('#URL.IDFunction#','IN','0','#url.source#')">					
					
			  </td>
			  
			  <td height="25" class="labelmedium"><a href="javascript: access('#URL.IDFunction#','IN','0','#url.source#')">Manually Record Candidates</b></a></td>
			  
			  </tr>		  
		      
			  <tr class="hide" id="IN"><td colspan="2">
			     <cfdiv id="iIN">									
			  </td></tr>
			  
			  <tr><td height="1" colspan="2" class="linedotted"></td></tr>
			  <tr><td height="2" colspan="2"></td></tr> 
			  
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
				  
					  <tr>
					  
					  <td width="8%" align="center" height="25" style="padding-left:4px;padding-right:4px"> 
					  
						<img src="#SESSION.root#/Images/ct_collapsed.gif" alt="" 
							id="#accesslevel#Exp" border="0" class="regular" 
							align="absmiddle" style="cursor: pointer;" 
							onClick="access('#URL.IDFunction#','#accesslevel#','1','#url.source#')">
							
							<img src="#SESSION.root#/Images/ct_expanded.gif" 
							id="#accesslevel#Min" alt="" border="0" 
							align="absmiddle" class="hide" style="cursor: pointer;" 
							onClick="access('#URL.IDFunction#','#accesslevel#','1','#url.source#')">
							
					  </td>
					  <td class="labelmedium">
					  	<a href="javascript: access('#URL.IDFunction#','#Accesslevel#','1','#url.source#')">#accessLabel[accesslevel+1]#</a>
					  </td>					  
					  </tr>						  				   
				      
					  <tr class="hide" id="#AccessLevel#">
					  	<td colspan="2"><cfdiv id="i#accesslevel#"></td>		 
					  </tr>			 					  
					  
					  <tr><td height="1" colspan="2" class="linedotted"></td></tr>			  
					 
										  				  
				  </cfif>
			  
			  </cfif>			  
			  				  
		  </cfloop>
	  
	  </cfoutput>
			  
 </table>		