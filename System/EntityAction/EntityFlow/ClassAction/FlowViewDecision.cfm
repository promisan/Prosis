<cfoutput>

<cfquery name="Yes#lvl#" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *, '#prior#' as Parent
	 FROM     #tbl#
	 WHERE    ActionCode = '#GoToYES#' 
	 <cfif #PublishNo# eq "">	   
	   	    AND    EntityCode   = '#entityCode#' 
		    AND    EntityClass  = '#entityClass#'
	 <cfelse>
			AND    ActionPublishNo = '#publishNo#' 
	 </cfif>
	 AND      Operational = 1 
</cfquery>	

<cfquery name="No#lvl#" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *, '#prior#' as Parent
	 FROM     #tbl#
	 WHERE    ActionCode  = '#GoToNO#' 
	 <cfif #PublishNo# eq "">	   
	   	    AND    EntityCode   = '#entityCode#' 
		    AND    EntityClass  = '#entityClass#'
	 <cfelse>
			AND    ActionPublishNo = '#publishNo#' 
	 </cfif>
	 AND      Operational = 1
</cfquery>	

<cfquery name="YesNo#lvl#" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   ActionGoToYesLabel,ActionGoToNoLabel
	 FROM     #tbl#
	 WHERE    ActionCode  = '#Prior#' 
	 <cfif #PublishNo# eq "">	   
	   	    AND    EntityCode   = '#entityCode#' 
		    AND    EntityClass  = '#entityClass#'
	 <cfelse>
			AND    ActionPublishNo = '#publishNo#' 
	 </cfif>
	 AND      Operational = 1
</cfquery>	

<table width="100%">
<tr><td colspan="2" align="center">
	    <img src="#SESSION.root#/images/decision.jpg" alt="" border="0">
	</td></tr>
</table>	

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><cfset drag = drag + 1>
	
	    <td id="a#drag#"></td>
	    <td valign="top" align="center">				
							
			<input type="hidden" name="parent#lvl#" id="parent#lvl#" value="#prior#">
			<input type="hidden" name="action#drag#" id="action#drag#" value="#prior#">
		    <input type="hidden" name="type#drag#" id="type#drag#" value="Decision">
		    <input type="hidden" name="leg#drag#" id="leg#drag#" value="pos">
			
			<!--- check if step has a decision --->
			
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			 
			 <tr>
				
				 <td style="padding-left:2px; padding-right:2px" height="31px">
				   
						<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="green">
							<tr id="d#drag#">
							    <!--- background="#SESSION.root#/images/decisiongreen.jpg" --->
								<td align="center" id="bd#drag#" style="background-color:00C600;">
									<cfset Yeslabel = evaluate("YesNo#lvl#.ActionGoToYesLabel")>&nbsp;
					 				<b><cfif YesLabel neq "">#YesLabel#<cfelse>YES</cfif>
								</td>
								<cfif evaluate("Yes#lvl#.ActionDescription neq ''")>
								 <td width="17" align="center" background="#SESSION.root#/images/decisiongreen_end.jpg" bordercolor="808080" >
									<img src="#SESSION.root#/Images/Icon_expand.gif" alt="" 
									    id="branch#drag#Exp" border="0" class="hide" 
									    align="middle" style="cursor: pointer; "
										onClick="more('branch#drag#')">
														    
									<img src="#SESSION.root#/Images/Icon_collapse.gif" 
									    id="branch#drag#Min" alt=""  border="0" 
									    align="middle" class="show" style="cursor: pointer; line-height:3px"
										onClick="more('branch#drag#')">
				
								 </td>
								 </cfif>
							</tr>
						</table>
					
				 </td>
				 
				 
			 </tr>
				 				 
			 <tr>
				 <td height="10" align="center">
			    	<table border="0" cellspacing="0" cellpadding="0">
	   			 		<tr><td height="10" width="3" bgcolor="green"></td></tr>
			    	</table>
				 </td>
			 </tr>	
			 
						 	
			 <cfset tree  = "YES#lvl#">
			 <cfset branch = "regular">
			 <cfinclude template="FlowViewTree.cfm">	
					 
			 </table>
  	    </td>
		
		<td id="a#drag#"></td>		 
		<td valign="top">
		
	         <cfset drag = drag + 1>
			 												 												 
			 <input type="hidden" name="action#drag#" id="action#drag#" value="">
		     <input type="hidden" name="type#drag#" id="type#drag#"   value="Decision">
		     <input type="hidden" name="leg#drag#" id="leg#drag#"    value="neg">
			 
			 <script>
			 
			    if (window.parent#lvl#.value) {
			   	 window.action#drag#.value = window.parent#lvl#.value
				 }
				 
				else { 
				
					if (window.parent#lvl#[1].value) {					
					    window.action#drag#.value = window.parent#lvl#[1].value
				    } else {					
					    window.action#drag#.value = window.parent#lvl#[2].value
					}
			     }    					   
				
			 </script>
			 								 				 			 
			 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

				 <tr>

					 <td align="center" style="padding-left:1px; padding-right:1px" height="31px">
					   
							<table cellpadding="0" cellspacing="0" width="100%" height="100%">
								<tr id="d#drag#">
					 				<td align="center" id="bd#drag#" style="background-color:ff9797">
						 				<cfset Nolabel = evaluate("YesNo#lvl#.ActionGoToNoLabel")>&nbsp;
						 				<b><cfif NoLabel neq "">#NoLabel#<cfelse><cf_tl id="No"></cfif>
					 				</td>
									<cfif evaluate("No#lvl#.ActionDescription neq ''")>
									 <td width="17" align="center"  background="#SESSION.root#/images/decisionred_end.jpg" bordercolor="808080">
									 
										<img src="#SESSION.root#/Images/Icon_expand.gif" alt="" 
										    id="branch#drag#Exp" border="0" class="hide" 
										    align="middle" style="cursor: pointer;"
											onClick="more('branch#drag#')">
																    
										<img src="#SESSION.root#/Images/Icon_collapse.gif" alt="" 
										    id="branch#drag#Min"  border="0" class="show" 
										    align="middle" style="cursor: pointer;  line-height:3px"
											onClick="more('branch#drag#')">											
										
									 	
									 </td>
								 	</cfif>
								</tr>
							</table>
						
					</td>
				 </tr>
				 
				 <tr>
				 <td height="10" align="center">
			    	<table border="0" cellspacing="0" cellpadding="0">
	   			 		<tr><td height="10" width="3" bgcolor="red"></td></tr>
			    	</table>
				 </td>
				 </tr>			 
	 				 
				 <cfset tree = "NO#lvl#">
				 <cfset branch = "regular">
				 <cfinclude template="FlowViewTree.cfm">	
				
			 </table>
	    </td>
   </tr>
				
</table>

</cfoutput>
