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
	 <cfif PublishNo eq "">	   
   	    AND    EntityCode   = '#entityCode#' 
	    AND    EntityClass  = '#entityClass#'
     <cfelse>
		AND    ActionPublishNo = '#publishNo#' 
     </cfif>
	 AND      Operational = 1
</cfquery>	

<cfquery name="Scripts" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT   *
		FROM     #tbl#Script
		WHERE    1=1
		<cfif PublishNo eq "">	   
	    AND    EntityCode   = '#entityCode#' 
	    AND    EntityClass  = '#entityClass#'
	    <cfelse>
		AND    ActionPublishNo = '#publishNo#' 
	    </cfif>
		AND    ActionCode = '#Action.actioncode#'
		AND   (LEN(MethodScript) > 6 or DocumentId is not NULL)	
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
<cfif boxcolor neq "FF8000">
	<cfset boxcolor = "transparent"> 
</cfif>

<cfif Action.Recordcount gt "1">

<style>
	.clsFlowActionHighlight {
		background-color: ##FFFF00;
	}
</style>
	

	<cf_tableround  mode="flat" startcolor="E4E4E4" endcolor="E4E4E4" totalwidth="#w#" totalheight="#h*Action.Recordcount#">
	
	<table width="100%"
		       height="100%"		       
			   class="formpadding"
			   align="center">
	   
	  <tr><td align="center" class="labelit" bgcolor="silver"><cf_tl id="Concurrent"></td></tr>
	
		<cfset p   = "">
		<cfset tpe = "">
	  
		<cfloop query="Action">
		    
			<tr><td align="center">
			
			<cfif Action.ActionType eq "Decision">
			   <cfset boxcolor = "red">
			</cfif>
			
			<cfset drag = drag + 1>
			<!---width="#w-6#"--->
			<table width=""
		       height="#h-4#"
		       border="0"
		       cellspacing="0"
		       cellpadding="0"
			   id="d#drag#">		
			   			  		   
				<tr style="background-color:ffffaf">
				   <td height="1" style="padding-left:3px" class="labelit" width="40%" id="b#Action.ActionCode#">
				   
					<cfif (accessWorkflow eq "EDIT" or accessWorkflow eq "ALL")>			
					    <a style="color:black" href="javascript:stepedit('#Action.actionCode#','#URL.PublishNo#')">#Action.ActionCode#</a></td>
					<cfelse>
						#Action.ActionCode#</td>
					</cfif>
				   <td width="70"  id="y#Action.ActionCode#">
				    <!--- not needed anymore
				    <cfset pre = "Action.">
				    <cfinclude template="FlowViewDisplay.cfm">					 
					--->
				   </td>
				   <td align="right" width="30%" height="1" id="z#Action.ActionCode#">
				   <cfif URL.PublishNo neq "" or URL.Print eq "1">
				   <cfelse>
					  <img src="#SESSION.root#/images/canceln.jpg"
					  alt="" border="0" style="cursor: pointer;"
					  onclick="javascript:stepreset('#ActionCode#','Action','#ActionType#','#Action.ActionGoToYesLabel#','#Action.ActionGoToNoLabel#')">
				    </cfif> 	  
				   </td>
			   </tr>

			  <cfif (accessWorkflow eq "EDIT" or accessWorkflow eq "ALL") or url.scope eq "Object">
		   						
			   <tr style="cursor: pointer;" class="line labelit" 
				 onClick="stepinspect('#Action.ActionCode#','#URL.PublishNo#')">
				 <!---#Boxcolor#--->
			     <td colspan="3" align="center" bgcolor="#Boxcolor#" id="bd#drag#"> 				
			     <cfif Action.ActionType eq "Decision"><font color="FFFFFF"></cfif>
			   	  #ActionDescription#<cfif ActionReference neq ""><font size="1"><br>[#ActionReference#]</cfif>
			     </td>
			   </tr>
			   			   
			   <cfelse>
  
			   <tr>
			   	<!---#Boxcolor#--->
			     <td colspan="3" align="center" class="labelit" bgcolor="#Boxcolor#" id="bd#drag#">
			     <cfif Action.ActionType eq "Decision"><font color="FFFFFF"></cfif>
			   	   #ActionDescription#<cfif ActionReference neq ""><font size="1"><br>[#ActionReference#]</cfif>
			     </td>
			   </tr>
			  			   
			   </cfif>
			   
			    <input type="hidden" name="action#drag#" id="action#drag#" value="#ActionCode#">
				<input type="hidden" name="type#drag#" id="type#drag#" value="Action">
				<input type="hidden" name="leg#drag#" id="leg#drag#" value="">
			   
		    </table>
			
			</td></tr>
			
			<cfif Action.ActionType eq "Decision">
			<tr><td align="center" class="labelit">Decision node may not be scheduled concurrently</td></tr>
			</cfif>
						
		</cfloop>
	
		</table>
		</cf_tableround>

<cfelse>		   
    
		<cfif Action.ActionType eq "Decision">
			<!---
			before it was just this
			<cfset bxdrag = "">
			--->
			<cfset drag = drag + 1>
			<cfset bxdrag = "d#drag#">
		
		<cfelse>
		
			<cfset drag = drag + 1>
			<cfset bxdrag = "d#drag#">
		
		</cfif>
		
		<cfif bxdrag eq "">
			<cfset bxdrag = "dragtable">
		</cfif>
		
		<cf_tableround id="#bxdrag#" mode="flat" startcolor="87D37C" endcolor="87D37C" totalwidth="#w#" totalheight="#h-10#">

		<cfif boxcolor eq "FF8000">
			<script>		 
				document.getElementById('#bxdrag#').style.height = '60px';
				document.getElementById('#bxdrag#').style.border = '5px solid FF8000' 
			</script>
		</cfif>  
		
		<table width="100%" height="100%" align="center">
							
			<cfif action.showasBranch eq "0" 
			       or action.actiontype eq "Action" 
				   or url.connector eq action.actionparent>
					    
				<tr class="labelmedium" style="background-color:##b0b0b080;height:15px;border-bottom:1px solid silver">
					<td width="50%" id="b#Action.ActionCode#" style="padding-left:2px;padding-top:1px;padding-bottom:1px">
					<cfif (accessWorkflow eq "EDIT" or accessWorkflow eq "ALL")>			
					    <a href="javascript:stepedit('#Action.actionCode#','#URL.PublishNo#')"><font color="000000">#Action.ActionCode#</a>
					<cfelse>
						#Action.ActionCode#
					</cfif>
					</td>
					
					<td align="right" id="y#Action.ActionCode#">
																	 
					</td>					
					
					<td align="right" id="z#Action.ActionCode#">
					
						<table cellspacing="0" cellpadding="0"><tr>
						
						<cfif Action.ActionType eq "Decision" and url.connector neq action.actionparent>
						  <cfif url.scope eq "Config">
						  <td style="padding-left:2px;padding-top:1px">
		   				  <img src="#SESSION.root#/images/flowblue.jpg" alt="" border="0" style="cursor: pointer;" onclick="javascript:openflow('#Action.ActionParent#')">
						  </td>
						  </cfif>
						  
						</cfif>
		
						<cfif URL.PublishNo neq "" or URL.Print eq "1">
						
						<cfelse>
						
						  <td style="padding-left:2px;padding-top:1px;padding-right:2px">
						  <img src="#SESSION.root#/images/canceln.jpg" alt="" 
						  border="0" style="cursor: pointer;" 
						  onclick="javascript:stepreset('#Action.ActionCode#','Action','#Action.ActionType#','#Action.ActionGoToYesLabel#','#Action.ActionGoToNoLabel#')">
						  </td>
						  
						 </cfif> 
						 
						 </tr>
						 
						 </table>
					 					 
					 </td>
				</tr>
								
				<cfif (accessWorkflow eq "EDIT" or accessWorkflow eq "ALL") or url.scope eq "Object">
								
					<cfif Action.ActionType eq "Decision">
			
						<tr style="cursor: pointer;" class="labelmedium" style="cursor: pointer;" 
						   onClick="stepinspect('#Action.ActionCode#','#URL.PublishNo#')">
						    <td colspan="3" style="word-wrap: break-word;font-size:12px" align="center" background="#SESSION.root#/images/decisionblue.jpg" id="b#Action.ActionCode#">
						    #Action.ActionDescription# 		
							<cfif Action.ActionReference neq ""><font size="1"><br>[#Action.ActionReference#]</cfif>					
						    </td>
						</tr>
					
					<cfelse>
														
						<tr style="cursor: pointer;" class="labelmedium"
							onClick="stepinspect('#Action.ActionCode#','#URL.PublishNo#')"
							 id="b#Action.ActionCode#">
							 <!---#Boxcolor#--->
						    <td colspan="3" align="center" bgcolor="#Boxcolor#" id="bd#drag#" style="word-wrap: break-word;;font-size:12px">
							#Action.ActionDescription#		
							<cfif Action.ActionReference neq ""><font size="1"><br>[#Action.ActionReference#]</cfif>	
						    </td>
							
							<input type="hidden" name="action#drag#" id="action#drag#" value="#Action.ActionCode#">
							<input type="hidden" name="type#drag#" id="type#drag#" value="Action">
							<input type="hidden" name="leg#drag#" id="leg#drag#" value="">
							
						</tr>
					
					</cfif>
					
				<cfelse>
	
					<cfif Action.ActionType eq "Decision">
							
						<tr>
						    <td colspan="3" class="labelit" align="center" style="word-wrap: break-word;" background="#SESSION.root#/images/decisionblue.jpg" id="b#Action.ActionCode#">
						    #Action.ActionDescription#
						    </td>
						</tr>
					
					<cfelse>
									
						<tr id="b#Action.ActionCode#">
						    <td colspan="3" class="labelit" align="center" style="word-wrap: break-word;" bgcolor="#Boxcolor#" id="bd#drag#">
							#Action.ActionDescription#
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
								<td colspan="3" align="right" class="labelit" bgcolor="FDDCAA" id="#Branch.ProcessActionCode##drag#">
								<cfif first eq "YES">
									<cfswitch expression="#Action.ActionGoTo#">
										<cfcase Value = '1'><img src="#SESSION.root#/images/SendDown.gif"  alt="" border="0" style="cursor: pointer;"></cfcase>
										<cfcase Value = '2'><img src="#SESSION.root#/images/SendUp.gif"    alt="" border="0" style="cursor: pointer;"></cfcase>
										<cfcase Value = '3'><img src="#SESSION.root#/images/SendRight.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
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
								<cfcase Value = '1'><img src="#SESSION.root#/images/SendDown.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
								<cfcase Value = '2'><img src="#SESSION.root#/images/SendUp.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
								<cfcase Value = '3'><img src="#SESSION.root#/images/SendRight.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
							</cfswitch> 					  
							</td>
						</tr>  
					</cfif> 	
				</cfif> 	
	
			<cfelse>
			
				<tr><td align="center" class="labelit">
				#Action.ActionCode#
				<a href="#SESSION.root#/System//EntityAction/EntityFlow/ClassAction/FlowView.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&Connector=#Action.ActionParent#">
					Linking pin		
				</a></td>
								
				</tr>
					
			</cfif>
			
			<cfif scripts.recordcount gte "0">
			
			<tr>
			<td style="padding:2px">			
				<table cellspacing="0" cellpadding="0">
				<tr>
				<cfif Check.DueEntityStatus neq "">						
							
					<td bgcolor="gray" align="center" class="labelit" style="height:15px;font-size:9px;color:white;width:20;border:1px solid gray">#Check.DueEntityStatus#</td>								
				</cfif>
				<cfloop query="scripts">			
				    <cfif method eq "due">
					<td bgcolor="FFFF00" align="center" class="labelit" style="height:15px;font-size:9px;color:white;width:20;border:1px solid gray">D</td>			
					</cfif>
					<cfif method eq "deny">
					<td bgcolor="red" align="center" class="labelit" style="height:15px;font-size:9px;color:white;width:20;border:1px solid gray">X</td>			
					</cfif>
					<cfif method eq "submission">
					<td bgcolor="green" align="center" class="labelit" style="height:15px;font-size:9px;color:white;width:20;border:1px solid gray">A</td>			
					</cfif>
					<cfif method eq "condition">
					<td bgcolor="white" align="center" class="labelit" style="height:15px;font-size:9px;color:white;width:20;border:1px solid gray">C</td>			
					</cfif>
				</cfloop>
				
				</tr>
				</table>	
			</td>
			</tr>
						
			</cfif>
						
	   </table>
	   </cf_tableround>

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
			
		<cfinclude template="FlowViewDecision.cfm">
		
	<cfelse>
	  	<cfset type = "Action">
		<cfinclude template="FlowViewAction.cfm">	
	</cfif>

</cfif>

</cfoutput>
