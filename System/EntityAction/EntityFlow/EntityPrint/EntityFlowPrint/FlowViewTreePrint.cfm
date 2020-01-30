<cfoutput>

	<!--- disabled not sure if needed
	<cfloop index="des" list="#Tree#" delimiters=",">
	<cfset des = tree>	
	--->
		
	<cfset actiondescription  = Evaluate("#Tree#.ActionDescription")>
	<cfset actionreference	  = Evaluate("#Tree#.ActionReference")>	
	<cfset parcode            = Evaluate("#Tree#.Parent")>
	<cfset link               = Evaluate("#Tree#.ActionCode")>
	<cfset type               = Evaluate("#Tree#.ActionType")>
	<cfset gotoYes            = Evaluate("#Tree#.ActionGoToYes")>
	<cfset gotoNo             = Evaluate("#Tree#.ActionGoToNo")>
		
	<!--- check if this code is already 
	shown in the display --->
	
	<cfquery name="Check" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     #tbl#
	 WHERE    ActionCode = '#link#' 
	 <cfif PublishNo neq "">	   
   	   	AND    ActionPublishNo = '#publishNo#' 
	 <cfelse>	
	    AND    EntityCode   = '#entityCode#' 
	    AND    EntityClass  = '#entityClass#' 	
     </cfif>
	 AND      Operational = 1
	</cfquery>	
		
	<cfset order = order + 1>
	
	<cfquery name="Reset" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE #tbl#
	 SET    ActionOrder = #Order#, 
	        ActionBranch = '#URL.Connector#'
	 WHERE  ActionCode  = '#link#'
	 <cfif PublishNo neq "">	   
     	AND    ActionPublishNo = '#publishNo#' 
	 <cfelse>
	     AND    EntityCode   = '#entityCode#' 
	     AND    EntityClass  = '#entityClass#'	
     </cfif>
	 AND ActionOrder is NULL
	</cfquery>	
	
    <cfquery name="Next" 
     datasource="AppsOrganization"
     username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   ActionCode, ActionDescription, ActionType, ActionGoTo <!--- , ActionSendBack --->
		 FROM     #tbl#
		 WHERE    ActionParent = '#link#' 
		 <cfif PublishNo eq "">	   
   	    	AND    EntityCode   = '#entityCode#' 
		    AND    EntityClass  = '#entityClass#'
		 <cfelse>
			AND    ActionPublishNo = '#publishNo#' 
		 </cfif>
		 AND      Operational = 1
		 
		UNION
		 SELECT   ActionCode, ActionDescription, ActionType, ActionGoTo <!--- , ActionSendBack --->
		 FROM     #tbl#
		 WHERE    ActionCode  = '#link#' 
		 <cfif PublishNo eq "">	   
   	    	AND    EntityCode   = '#entityCode#' 
		    AND    EntityClass  = '#entityClass#'
		 <cfelse>
			AND    ActionPublishNo = '#publishNo#' 
		 </cfif>
		 AND      Operational = 1 
		 
		 ORDER By ActionType <!--- <cfif #link# eq "0009">xxxx</cfif> --->
	</cfquery>	
	
	<!--- show connector after decision tree link --->
	
	<cfquery name="ShowLine" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   ActionCode, ActionDescription, ActionType
	 FROM     #tbl#
	 WHERE    ActionParent = '#link#' 
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
	   <cfset ht = h>			
	<cfelseif Type eq "Decision">	
	 <cfset boxcolor = "76CBD1"> <!--- return --->
	  <cfset ht = h>
	<cfelseif Check.ActionParent neq "">
	 <cfset boxcolor = "yellow"> <!--- return --->
	  <cfset ht = h>
	<cfelseif Next.Recordcount eq "0">
	 <cfset boxcolor = "E8E8E8">  
	<cfelseif ShowLine.Recordcount eq "0">
	 <cfset boxcolor = "E8E8E8">   
	<cfelseif ActionDescription eq ""> 
	  <cfset boxcolor = "E8E8E8">
	  <cfset ht = "10">
	<cfelse>
	 <cfset boxcolor = "white">
	  <cfset ht = "#h#"> 
	</cfif>
			
	<tr id="branch#drag#">
						
	<td align="center" valign="top" class="#branch#">
	
	<cfset val  = Evaluate("#Tree#.ActionCode")>
	<cfset sendback  = Evaluate("#Tree#.ActionGoTo")>
	
	<table width="100%"
       border="0"
       cellspacing="0"
       cellpadding="0"
	   bordercolor="808080"
	   class="formpadding">
	   
	   <tr><td align="center">
	  		 		 				 		 	  	     
	     <cfif ActionDescription eq "">
		
			 <table id="ad#drag#" width="45" height="40" align="center" border="1" bordercolor="808080">
		  	 <tr><td align="center" bgcolor="silver">				 
		     STOP 
			 			 			 							  
		 <cfelseif Check.ActionOrder neq "" and URL.Connector eq "INIT">
		 
		 	<!--- if box already is shown in flow, 
			   do not show again, except for subflows --->
		  		   
		     <table width="45"
		       height="40"
		       border="1"
			   align="center"
		       bordercolor="808080"
		       style="cursor: pointer;"			  
		       onClick="javascript:stepinspect('#val#','#PublishNo#')"
		       onMouseOver="javascript:showaction('#drag#','#val#','clsFlowActionHighlight labelit','clsFlowActionHighlight labelit')"
			   onMouseOut="javascript:showaction('#drag#','#val#','labelit','labelit')">
	   	  	 <tr>
			 <cfif type eq "Decision">
			     <td align="center" background="#SESSION.root#/Images/decisionblue.jpg"  id="#val##drag#">
			 <cfelse>
			     <td align="center" bgcolor="#Boxcolor#"  id="#val##drag#">
			 </cfif>
		     <b>Go to:<br></b>&nbsp;
 			 <cfif URL.Print eq "0">
			  <a href="##" title="#ActionDescription#">#val#</a> 			 
			  <cfelse>
			  	#val#
			 </cfif>	
			 <cfset link = "'#val#'">
				 
		 <cfelse>
						 
		     <cfset val  = Evaluate("#tree#.ActionCode")>
			 			 
			 <cfif type eq "Decision">
			 
			  <table width="#b#" height="40" align="center" cellspacing="0" cellpadding="0" border="1" bordercolor="808080"
					 style="cursor: pointer;">
			 
			 <cfelse>
			
					 <cfset drag = drag + 1>
					 <table width="#b#" id="d#drag#"  height="40" align="center" cellspacing="0" cellpadding="0" border="1" bordercolor="808080"
					 style="cursor: pointer;">
			 
			 </cfif>
			 
		  	 <cfif Check.ActionParent eq "">
			 	 <tr>
				  <td id="b#val#" class="top3n" width="40%">
				<cfif ((accessWorkflow eq "EDIT" or accessWorkflow eq "ALL") AND URL.Print eq "0")>
				    <a href="javascript:stepedit('#val#','#URL.PublishNo#')">&nbsp;#val#</a></td>
				<cfelse>
					&nbsp;#val#</td>
				</cfif>
				<td class="top3n" width="70" id="y#val#">
				
					<!--- empty spot ---> 
					
					</td>
				  
				  <td align="right" height="1" width="30%" class="top3n" id="z#val#" >

				  <cfif URL.PublishNo neq "" or URL.Print eq "1">
			      <cfelse>
				   <img src="#SESSION.root#/Images/canceln.jpg"
				  alt="" border="0" style="cursor: pointer;"
				  onclick="javascript:stepreset('#val#','Decision','#Type#','#Check.ActionGoToYesLabel#','#Check.ActionGoToNoLabel#')">
				  </cfif>
				  </td></tr>
				  			  
			</cfif>
			
			<cfif ((accessWorkflow eq "EDIT" or accessWorkflow eq "ALL") AND URL.Print eq "0")>
						
				<cfif type eq "Decision">
					
					 <tr style="cursor: pointer;" 
					  onClick="stepinspect('#val#','#URL.PublishNo#')">
				      <td colspan="3" align="center" id="bd#drag#" background="#SESSION.root#/Images/decisionblue.jpg">
					  #ActionDescription#<cfif ActionReference neq ""><br>- #ActionReference# -</cfif>
					  <cfset link = "'#val#'">
					  <cfset prior   = "#val#">
					 </td></tr>
					 			  									
				<cfelse>
								
					 <tr style="cursor: pointer;" 
					  onClick="stepinspect('#val#','#URL.PublishNo#')">
				      <td colspan="3" align="center" id="bd#drag#" bgcolor="#Boxcolor#">
					  #ActionDescription#<cfif ActionReference neq ""><br>- #ActionReference# -</cfif> 		   
					  <cfset link = "'#val#'">			
					  <input type="hidden" name="action#drag#" id="action#drag#" value="#val#">
					  <input type="hidden" name="type#drag#" id="type#drag#" value="Action">
					  <input type="hidden" name="leg#drag#" id="leg#drag#" value="">
					 </td></tr>
					  
				</cfif>  
					 
			<cfelse>
			
				<cfif type eq "Decision">
					
						 <tr>
					      <td colspan="3" align="center" background="#SESSION.root#/Images/decisionblue.jpg">
						  #ActionDescription#<cfif ActionReference neq ""><br>- #ActionReference# -</cfif> 	
						  <cfset link = "'#val#'">
						  <cfset prior   = "#val#">
						 </td></tr>
					 			  									
				<cfelse>
								
						 <tr>
					      <td colspan="3" align="center" id="bd#drag#" bgcolor="#Boxcolor#">
						  #ActionDescription#<cfif ActionReference neq ""><br>- #ActionReference# -</cfif> 		
						  <cfset link = "'#val#'">			
						  <input type="hidden" name="action#drag#" id="action#drag#" value="#val#">
						  <input type="hidden" name="type#drag#" id="type#drag#" value="Action">
						  <input type="hidden" name="leg#drag#" id="leg#drag#" value="">
						 </td></tr>
					  
				</cfif>  			
			
			</cfif>		 			  
		 
		 </cfif>
			
		<cfif sendback gte 1 and ((Check.ActionOrder eq "" and URL.Connector eq "INIT")
			or Check.ActionOrder neq "") >   <!--- don't show on go to squares --->
		
				<cfquery name="Branch" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT   ProcessActionCode
				 FROM     #tbl#Process
				 WHERE    ActionCode = '#val#' 
				 AND Operational = 1
				<cfif PublishNo neq "">	   
					AND    ActionPublishNo = '#publishNo#' 
				<cfelse>	
					AND    EntityCode   = '#entityCode#' 
					AND    EntityClass  = '#entityClass#' 	
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
								<cfswitch expression="#sendback#">
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
					<tr style="cursor: pointer;">
						<td colspan = "3" align="right" height="5" bgcolor="FDDCAA">
						<cfswitch expression="#Sendback#">
							<cfcase Value = '1'><img src="#SESSION.root#/Images/senddown.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
							<cfcase Value = '2'><img src="#SESSION.root#/Images/sendup.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
							<cfcase Value = '3'><img src="#SESSION.root#/Images/sendright.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
						</cfswitch> 					  
						</td>
					</tr>  
				</cfif> 	
				
		</cfif>

	     </table>
	   </td></tr>
	   	   
	   <cfif ActionDescription neq "" 
	       and Check.ActionParent eq "" 
		   and (check.ActionOrder eq "" or URL.Connector neq "INIT")>
	   	   	   		
		<cfif Next.recordcount gte "1">
				 
		   <cfif ShowLine.recordcount gt "0">
			   
		   <tr><td colspan="2">
				<table width="#b#" height="#l#" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
					<td width="49%" align="center"><td>
					<td width="2%" align="center" bgcolor="000000"><td>
					<td width="49%" align="center"><td>
					</tr>
				</table>
		   </td></tr>
		   
		   </cfif>
			
		   <tr><td colspan="2">
		   <cfset lvl = lvl+1>
		   <cfif Next.actionType eq "Action">
		   
			   <cfinclude template="FlowViewActionPrint.cfm">
		   <cfelse>		   
		        <cfinclude template="FlowViewDecisionPrint.cfm"> 
		   </cfif>	 
		   <cfset lvl = lvl-1>
		    </td></tr>
		 		   
		 </cfif>  
		   
	   </cfif>
	   
    </table>
	</td>
	</tr>
	
	<!---
	
	</cfloop>
	--->
	
</cfoutput>	