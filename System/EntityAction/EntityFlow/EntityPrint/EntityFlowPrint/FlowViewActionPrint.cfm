<cfoutput>

<cfquery name="Action" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   * 
 FROM     #tbl#
 WHERE    ActionParent IN (#preserveSingleQuotes(link)#)
 <cfif PublishNo eq "">	   
   	    AND    EntityCode   = '#entityCode#' 
	    AND    EntityClass  = '#entityClass#'
 <cfelse>
		AND    ActionPublishNo = '#publishNo#' 
 </cfif>
 AND      Operational = 1 
 ORDER By ActionType 
</cfquery>	

<cfif Action.Recordcount eq "0">
  <cfexit method="EXITTEMPLATE">
</cfif>

<cfset link = "">

<cfloop query="Action">

    <cfset order = order + 1>
		
	<cfquery name="Reset" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE   #tbl#
	 SET      ActionBranch = '#URL.Connector#',
	          ActionOrder  = #Order#
	 WHERE    ActionCode = '#Action.ActionCode#'
	 <cfif PublishNo neq "">	   
       AND  ActionPublishNo = '#publishNo#' 
	 <cfelse>
	    AND    EntityCode   = '#entityCode#' 
	    AND    EntityClass  = '#entityClass#'  
	</cfif>
	
	</cfquery>		
		
	<cfif link eq "">
	    <cfset link = "'#Action.ActionCode#'">
	<cfelse>
		<cfset link = link&",'#Action.ActionCode#'">
	</cfif>	
	
</cfloop>	

<cfquery name="Check" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     #tbl#
	 WHERE    ActionParent IN (#preserveSingleQuotes(link)#) 
	 <cfif #PublishNo# eq "">	   
   	    AND    EntityCode   = '#entityCode#' 
	    AND    EntityClass  = '#entityClass#'
     <cfelse>
		AND    ActionPublishNo = '#publishNo#' 
     </cfif>
	 AND      Operational = 1
</cfquery>	

<cfif URL.ActionNoShow eq Action.ActionCode>
  <cfset boxcolor = "FF8000">
<cfelseif Action.ActionType eq "Decision">
  <cfset boxcolor = "76CBD1">  
<cfelseif Check.recordcount eq "0">
  <cfset boxcolor = "silver">
<cfelse>
  <cfset boxcolor = "white">
</cfif>

<!--- concurrent actions --->

<cfif Action.Recordcount gt "1">

	<table width="#w#"
       height="#h*Action.Recordcount#"
       border="0"
       cellspacing="0"
       cellpadding="0"
	   align="center"
	   class="formpadding"
       bordercolor="808080"
       bgcolor="C9C994">
	   
	  <tr><td align="center" bgcolor="C9C994">&nbsp;<b>Concurrent</td></tr>
	
		<cfset p   = "">
		<cfset tpe = "">
	  
		<cfloop query="Action">
		    
			<tr><td align="center">
			
			<cfif Action.ActionType eq "Decision">
			   <cfset boxcolor = "red">
			</cfif>
			
			<cfset drag = drag + 1>
			
			<table width="#w-6#"
		       height="#h-4#"
		       border="1"
		       cellspacing="0"
		       cellpadding="0"
			   id="d#drag#"
		       bordercolor="808080">		   
			  		   
				<tr>
				   <td height="1" class="top3n" width="40%"  id="b#Action.ActionCode#">
					<cfif ((accessWorkflow eq "EDIT" or accessWorkflow eq "ALL") AND URL.Print eq "0")>			
					    <a href="javascript:stepedit('#Action.actionCode#','#URL.PublishNo#')">&nbsp;#Action.ActionCode#</a></td>
					<cfelse>
						&nbsp;#Action.ActionCode#</td>
					</cfif>
				   <td class="top3n" width="70"  id="y#Action.ActionCode#">
				   </td>
				   <td align="right" width="30%" height="1" class="top3n"  id="z#Action.ActionCode#">
				   <cfif URL.PublishNo neq "" or URL.Print eq "1">
				   <cfelse>
					  <img src="#SESSION.root#/Images/canceln.jpg"
					  alt="" border="0" style="cursor: pointer;"
					  onclick="javascript:stepreset('#ActionCode#','Action','#ActionType#','#Action.ActionGoToYesLabel#','#Action.ActionGoToNoLabel#')">
				    </cfif> 	  
				   </td>
			   </tr>
			   
			  <cfif (accessWorkflow eq "EDIT" or accessWorkflow eq "ALL")>
		   
			   <tr style="cursor: pointer;" 
				 onClick="stepinspect('#Action.ActionCode#','#URL.PublishNo#')">
			     <td colspan="3" align="center" bgcolor="#Boxcolor#" id="bd#drag#">
			     <cfif Action.ActionType eq "Decision"><font color="FFFFFF"></cfif>
			   	   #ActionDescription#<cfif ActionReference neq ""><br>- #ActionReference# -</cfif>
			     </td>
			   </tr>
			   			   
			   <cfelse>
					   
			   <tr>
			     <td colspan="3" align="center" bgcolor="#Boxcolor#" id="bd#drag#">
			     <cfif Action.ActionType eq "Decision"><font color="FFFFFF"></cfif>
			   	   #ActionDescription#<cfif ActionReference neq ""><br>- #ActionReference# -</cfif>
			     </td>
			   </tr>
			  			   
			   </cfif>
			   
			<cfif URL.Print eq "0">
			    <input type="hidden" name="action#drag#" id="action#drag#" value="#ActionCode#">
				<input type="hidden" name="type#drag#" id="type#drag#" value="Action">
				<input type="hidden" name="leg#drag#" id="leg#drag#" value="">
			</cfif>	
			   
		    </table>
			
			</td></tr>
			
			<cfif Action.ActionType eq "Decision">
			<tr><td align="center">Decision node may not be scheduled concurrently</td></tr>
			</cfif>
						
		</cfloop>
	
		</table>

<cfelse>		   
    
		<cfif Action.ActionType eq "Decision">
							
			<table width="#w#" height="#h-10#" border="1" align="center" bordercolor="gray" 
			cellspacing="0" cellpadding="0">						
		
		<cfelse>
		
			<cfset drag = drag + 1>
			<table width="#w#" height="#h-10#" border="1" align="center" bordercolor="gray" 
			cellspacing="0" cellpadding="0" id="d#drag#">
		
		</cfif>
				
		<cfif action.showasBranch eq "0" 
		       or action.actiontype eq "Action" 
			   or url.connector eq action.actionparent>
				    
			<tr>
				<td class="top3n" width="40%" id="b#Action.ActionCode#">
				<cfif ((accessWorkflow eq "EDIT" or accessWorkflow eq "ALL") and URL.Print eq "0")>			
				    <a href="javascript:stepedit('#Action.actionCode#','#URL.PublishNo#')">&nbsp;#Action.ActionCode#</a></td>
				<cfelse>
					&nbsp;#Action.ActionCode#</td>
				</cfif>
				
				<td class="top3n" width="70" id="y#Action.ActionCode#">
				<!--- emtpty spot --->					
					 
				</td>
				<td height="1" width="30%" align="right" class="top3n" id="z#Action.ActionCode#">
				<cfif Action.ActionType eq "Decision" and url.connector neq action.actionparent>
   				  <img src="#SESSION.root#/Images/flowblue.jpg" alt="" 
				  border="0" style="cursor: pointer;" 
				  onclick="javascript:openflow('#Action.ActionParent#')">
				</cfif>

				<cfif URL.PublishNo neq "" or URL.Print eq "1">
				<cfelse>
				  <img src="#SESSION.root#/Images/canceln.jpg" alt="" 
				  border="0" style="cursor: pointer;" 
				  onclick="javascript:stepreset('#Action.ActionCode#','Action','#Action.ActionType#','#Action.ActionGoToYesLabel#','#Action.ActionGoToNoLabel#')">
				 </cfif> 
				 </td>
			</tr>
			
			<cfif ((accessWorkflow eq "EDIT" or accessWorkflow eq "ALL") AND URL.Print eq "0")>
							
				<cfif Action.ActionType eq "Decision">
						
					<tr style="cursor: pointer;" 
					   onClick="stepinspect('#Action.ActionCode#','#URL.PublishNo#')">
					    <td colspan="3" align="center" background="#SESSION.root#/Images/decisionblue.jpg" id="b#Action.ActionCode#">
					    #Action.ActionDescription#<cfif Action.ActionReference neq ""><br>- #Action.ActionReference# -</cfif>
						
					    </td>
					</tr>
				
				<cfelse>
								
					<tr style="cursor: pointer;" 
						onClick="stepinspect('#Action.ActionCode#','#URL.PublishNo#')"
						 id="b#Action.ActionCode#">
					    <td colspan="3" align="center" bgcolor="#Boxcolor#" id="bd#drag#">
					    #Action.ActionDescription#<cfif Action.ActionReference neq ""><br>- #Action.ActionReference# -</cfif>
						
					    </td>
						
						<input type="hidden" name="action#drag#" id="action#drag#" value="#Action.ActionCode#">
						<input type="hidden" name="type#drag#" id="type#drag#" value="Action">
						<input type="hidden" name="leg#drag#" id="leg#drag#" value="">
						
					</tr>
				
				</cfif>
				
			<cfelse>

				<cfif Action.ActionType eq "Decision">
						
					<tr>
					    <td colspan="3" align="center" background="#SESSION.root#/Images/decisionblue.jpg" id="b#Action.ActionCode#">
					    #Action.ActionDescription#<cfif Action.ActionReference neq ""><br>- #Action.ActionReference# -</cfif>
					    </td>
					</tr>
				
				<cfelse>
								
					<tr id="b#Action.ActionCode#">
					    <td colspan="3" align="center" bgcolor="#Boxcolor#" id="bd#drag#">
					    #Action.ActionDescription#<cfif Action.ActionReference neq ""><br>- #Action.ActionReference# -</cfif>
					    </td>
						
						<input type="hidden" name="action#drag#" id="action#drag#" value="#Action.ActionCode#">
						<input type="hidden" name="type#drag#" id="type#drag#" value="Action">
						<input type="hidden" name="leg#drag#" id="leg#drag#" value="">
						
					</tr>
				
				</cfif>
				
			</cfif>	
			
			<cfif Action.ActionGoTo gte 1> 
			
				<cfquery name="Branch" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT   ProcessActionCode
				 FROM     #tbl#Process
				 WHERE    ActionCode = '#Action.ActionCode#' 
				 AND Operational = 1
				 <cfif PublishNo eq "">	   
				   	    AND    EntityCode   = '#entityCode#' 
					    AND    EntityClass  = '#entityClass#'
				 <cfelse>
						AND    ActionPublishNo = '#publishNo#' 
				 </cfif>
				</cfquery>			
							
				<cfif Branch.RecordCount gt 0> 
					<cfset first = "YES">
					<cfloop query="Branch">
						<tr style="cursor: pointer;" 
					    onMouseOver="javascript:showaction('#drag#','#Branch.ProcessActionCode#','clsFlowActionHighlight labelit','clsFlowActionHighlight labelit')"
						onMouseOut="javascript:showaction('#drag#','#Branch.ProcessActionCode#','labelit','labelit')">
							<td colspan="3" align="right" bgcolor="FDDCAA" id="#Branch.ProcessActionCode##drag#">
							<cfif first eq "YES">
								<cfswitch expression="#Action.ActionGoTo#">
									<cfcase Value = '1'><img src="#SESSION.root#/Images/senddown.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
									<cfcase Value = '2'><img src="#SESSION.root#/Images/sendup.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
									<cfcase Value = '3'><img src="#SESSION.root#/Images/sendright.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
								</cfswitch>
								<cfset First = "NO">
							</cfif>
							<font size="1">#Branch.ProcessActionCode#</font>
							</td>
						</tr> 
					</cfloop>
				<cfelse>		
					<tr>
						<td colspan = "3" align="right" height="5" bgcolor="FDDCAA">
						<cfswitch expression="#Action.ActionGoTo#">
							<cfcase Value = '1'><img src="#SESSION.root#/Images/senddown.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
							<cfcase Value = '2'><img src="#SESSION.root#/Images/sendup.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
							<cfcase Value = '3'><img src="#SESSION.root#/Images/sendright.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
						</cfswitch> 					  
						</td>
					</tr>  
				</cfif> 	
			</cfif> 	

		<cfelse>
		
			<tr><td align="center">
			#Action.ActionCode#
			<cfif URL.Print eq "0">
			<a href="#SESSION.root#/System//EntityAction/EntityFlow/ClassAction/FlowView.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&Connector=#Action.ActionParent#">
				Linking pin		
			</a>
			<cfelse>
				Linking pin		
			</cfif>	
			</td></tr>
				
		</cfif>
					
   </table>

</cfif>

<cfif action.showasBranch eq "0" or 
	action.actiontype eq "Action"
	or url.connector eq action.actionparent>
	
	<!--- spacing between boxes --->
	
	<cfif Check.recordcount gte "1">
	
			<table width="#w#" height="#l#" border="0" align="center">
				<tr>
				<td width="49%" align="center"></td>
				<td width="3px" align="center" bgcolor="000000"></td>
				<td width="49%" align="center"></td>
				</tr>
			</table>
		
	</cfif>
			
	<cfif Action.ActionType eq "Decision">
	
		<cfset type    = "Decision">
		<cfset GoToYES = Action.ActionGoToYES>
		<cfset GoToNO  = Action.ActionGoToNO>
		<cfset prior   = Action.ActionCode>
			
		<cfinclude template="FlowViewDecisionPrint.cfm">
		
	<cfelse>
	  	<cfset type = "Action">
		<cfinclude template="FlowViewActionPrint.cfm">	
	</cfif>

</cfif>

</cfoutput>
