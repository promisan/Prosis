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
	    <img src="#SESSION.root#/Images/decision.jpg" alt="" border="0">
	</td></tr>
</table>	

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="808080">
	
	<tr><cfset drag = drag + 1>
	
	    <td id="a#drag#"></td>
	    <td valign="top" align="center">				

		<cfif URL.Print eq "0">
			<input type="hidden" name="parent#lvl#" id="parent#lvl#" value="#prior#">
			<input type="hidden" name="action#drag#" id="action#drag#" value="#prior#">
		    <input type="hidden" name="type#drag#" id="type#drag#" value="Decision">
		    <input type="hidden" name="leg#drag#" id="leg#drag#" value="pos">
		</cfif>								
			
			<!--- check if step has a decision --->
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			 
			 <tr id="d#drag#" height="17">
			 				
				<!--- background="#SESSION.root#/Images/decisiongreen.jpg" --->
				 <td align="center"id="bd#drag#" style="background-color:00C600;"  bordercolor="808080" style="border: 1px solid;">
					 <cfset Yeslabel = evaluate("YesNo#lvl#.ActionGoToYesLabel")>
					 <b><cfif YesLabel neq "">#YesLabel#<cfelse>YES</cfif>
				 </td>
				 
				 <cfif evaluate("Yes#lvl#.ActionDescription neq ''")>
				 <td width="17" align="center" background="#SESSION.root#/Images/decisiongreen_end.jpg" bordercolor="808080" style="border: 1px solid;">
					<img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
					    id="branch#drag#Exp" border="0" class="hide" 
					    align="middle" style="cursor: pointer;"
						onClick="more('branch#drag#')">
										    
					<img src="#SESSION.root#/Images/icon_collapse.gif" 
					    id="branch#drag#Min" alt=""  border="0" 
					    align="middle" class="show" style="cursor: pointer;"
						onClick="more('branch#drag#')">

				 </td>
				 </cfif>
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
			 <cfinclude template="FlowViewTreePrint.cfm">	
					 
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
			 
			 <table width="100%" border="0" cellspacing="0" cellpadding="0">

				 <tr id="d#drag#" height="17">

					 <td align="center" id="bd#drag#" bordercolor="808080" style="background-color:ff9797;border: 1px solid;">
						 <cfset Nolabel = evaluate("YesNo#lvl#.ActionGoToNoLabel")>
						 <b><cfif NoLabel neq "">#NoLabel#<cfelse>NO</cfif>
					 </td>
					 				
				 <cfif evaluate("No#lvl#.ActionDescription neq ''")>
					 <td width="17" align="center"  background="#SESSION.root#/Images/decisionred_end.jpg" bordercolor="808080" style="border: 1px solid;">
						<img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
						    id="branch#drag#Exp" border="0" class="hide" 
						    align="middle" style="cursor: pointer;"
							onClick="more('branch#drag#')">
												    
						<img src="#SESSION.root#/Images/icon_collapse.gif" alt="" 
						    id="branch#drag#Min"  border="0" class="show" 
						    align="middle" style="cursor: pointer;"
							onClick="more('branch#drag#')">
					 </td>
				 </cfif>
				 
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
				 <cfinclude template="FlowViewTreePrint.cfm">	
				
			 </table>
	    </td>
   </tr>
				
</table>

</cfoutput>
