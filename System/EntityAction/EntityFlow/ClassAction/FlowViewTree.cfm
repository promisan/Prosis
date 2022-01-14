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
	 UPDATE   #tbl#
	 SET      ActionOrder = #Order#, 
	          ActionBranch = '#URL.Connector#'
	 WHERE    ActionCode  = '#link#'
	 <cfif PublishNo neq "">	   
     	AND   ActionPublishNo = '#publishNo#' 
	 <cfelse>
	     AND  EntityCode   = '#entityCode#' 
	     AND  EntityClass  = '#entityClass#'	
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
    	
	<cfset val  = Evaluate("#Tree#.ActionCode")>
	<cfset sendback  = Evaluate("#Tree#.ActionGoTo")>	
  	
	<cfif URL.ActionNoShow eq val>
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
	
	<cfif boxcolor neq "FF8000">
		<cfset boxcolor = "transparent"> 
	</cfif>

	<tr id="branch#drag#">
						
	<td align="center" valign="top" class="#branch#">
	
	<table width="100%" class="formpadding">
	   
	   <tr><td align="center">	  
	   
	  		
		<cfif ActionDescription eq "" and val eq "">	
			<cfset mw = "50">	
			<cfset startcolor = "E8E6E6">
			<cfset endcolor = "E8E6E6">
		<cfelseif Check.ActionOrder neq "" and URL.Connector eq "INIT">
			<cfset mw = "70">
			<cfset startcolor = "64D9B0">
			<cfset endcolor = "64D9B0">
		<cfelse>
			<cfset mw = "140" >
			<cfset startcolor = "FC9A5D">
			<cfset endcolor = "FC9A5D">
		</cfif>
		
		<cfif boxcolor eq "FF8000">
			<cfset na = "#boxcolor#">
		<cfelse>
			<cfset na = "">
		</cfif>
		
	   <cf_tableround id="nwftable#na#" mode="flat" startcolor="#startcolor#" endcolor="#endcolor#" totalwidth="#mw#" totalheight="40">
	   
	    <cfif boxcolor eq "FF8000">
			<script>		 
				document.getElementById('nwftable#na#').style.height = '60px';
				document.getElementById('nwftable#na#').style.border = '5px solid FF8000' 
			</script>
		</cfif> 
		
	   <table width="100%" height="100%"><tr><td>
	  		 		 				 		 	  	     
	     <cfif ActionDescription eq "">

			 <table id="ad#drag#"  height="100%" align="center">
		  	 <tr><td align="center" bgcolor="transparent" style="width:170px;padding-top:2px;padding-bottom:2px">STOP 
			 			 			 							  
		 <cfelseif Check.ActionOrder neq "" and URL.Connector eq "INIT">
		 
		 	<!--- if box already is shown in flow, 
			   do not show again, except for subflows --->
		  		   
		     <table height="100%" align="center" style="width:170px"
		       style="cursor: pointer;"			  
		       onClick="stepinspect('#val#','#PublishNo#')"
		       onMouseOver="showaction('#drag#','#val#','clsFlowActionHighlight labelit','clsFlowActionHighlight labelit')"
			   onMouseOut="showaction('#drag#','#val#','labelit','labelit')">
			   			   
	   	  	   <tr class="labelmedium">
				 <cfif type eq "Decision">
				     <td align="center" style="padding-top:2px;padding-bottom:2px" background="#SESSION.root#/images/decisionblue.jpg"  id="#val##drag#">
				 <cfelse>
				     <td align="center" style="padding-top:2px;padding-bottom:2px" bgcolor="#Boxcolor#" id="#val##drag#">
				 </cfif>
			     <b>Go to: </b>&nbsp;  <a href="##" title="#ActionDescription#">#val#</a> <cfset link = "'#val#'">
				 
		 <cfelse>
						 
		     <cfset val  = Evaluate("#tree#.ActionCode")>
			 			 
			 <cfif type eq "Decision">			 		
			  		<table width="100%" height="100%" align="center" style="width:170px;cursor: pointer;">		 
			 <cfelse>
					<cfset drag = drag + 1>
					<table width="100%" id="d#drag#"  height="100%" style="width:170px;cursor: pointer;">			 
			 </cfif>
			 			 
			 <!---			 
		  	 <cfif Check.ActionParent eq "">
			 --->
			 			 
			 	<tr style="height:20px;background-color:##80008050" class="fixlengthlist">
				
				<td id="b#val#" class="labelit" width="70%" style="padding-left:4px">
				
					<cfif (accessWorkflow eq "EDIT" or accessWorkflow eq "ALL")>			
					    <a href="javascript:stepedit('#val#','#URL.PublishNo#')"><font color="000000">#val#</font></a>
					<cfelse>
						#val#
					</cfif>
				</td>
				
				<td class="labelit" width="1%" align="right" id="y#val#">
				<!---
				 <cfif ActionReference neq "">
				 	<font face="Calibri" size="2">
				 		<cfif len(ActionReference) gt 9>
							#left(ActionReference,7)#...
						<cfelse>
							#ActionReference#
						</cfif>
					</font>
					</cfif>	
					--->
				</td>
				  
				<td align="right" width="16px" id="z#val#" style="padding-right:4px">
									
				  <cfif URL.PublishNo neq "" or URL.Print eq "1">
				  
			      <cfelse>
				  
					   <img src="#SESSION.root#/images/canceln.jpg"
					   align="right" style="display:block"
						  alt="" border="0" style="cursor: pointer;"
						  onclick="javascript:stepreset('#val#','Decision','#Type#','#Check.ActionGoToYesLabel#','#Check.ActionGoToNoLabel#')">
				  </cfif>
				  
				 </td>
				
				</tr>
			
			<!---	  			  
			</cfif>
			--->
			
			<cfif (accessWorkflow eq "EDIT" or accessWorkflow eq "ALL")>
						
				<cfif type eq "Decision">
					
					 <tr class="labelit fixlengthlist" style="font-size:15px;cursor: pointer;" onClick="stepinspect('#val#','#URL.PublishNo#')">
					 
				      <td style="padding-top:2px;padding-bottom:2px" colspan="3" align="center" id="bd#drag#" background="#SESSION.root#/images/decisionblue.jpg">
					  #ActionDescription# 
					  <cfif ActionReference neq ""><font size="1"><br>[#ActionReference#]</cfif>	
					  <cfset link   = "'#val#'">
					  <cfset prior  = "#val#">
					  
					 </td>
					 
					 </tr>
					 			  									
				<cfelse>
								
					 <tr class="labelmedium fixlengthlist" style="font-size:15px;cursor: pointer;" onClick="stepinspect('#val#','#URL.PublishNo#')">
				      <td style="max-width:150px;padding-top:2px;padding-bottom:2px" class="fixlength" title="#actiondescription#" colspan="3" align="center" id="bd#drag#" bgcolor="#Boxcolor#">
					  #ActionDescription# 						  
					  <cfif ActionReference neq ""><font size="1"><br>[#ActionReference#]</cfif>		 
					  <cfset link = "'#val#'">			
					  <input type="hidden" name="action#drag#" id="action#drag#" value="#val#">
					  <input type="hidden" name="type#drag#" id="type#drag#" value="Action">
					  <input type="hidden" name="leg#drag#" id="leg#drag#" value="">
					 </td></tr>
					  
				</cfif>  
					 
			<cfelse>
			
				<cfif type eq "Decision">
					
						 <tr class="labelit fixlengthlist" style="font-size:15px;cursor: pointer;" >
					      <td style="padding-top:2px;padding-bottom:2px" colspan="3" align="center" background="#SESSION.root#/images/decisionblue.jpg">
						  #ActionDescription# 	
						  <cfset link = "'#val#'">
						  <cfset prior   = "#val#">
						 </td></tr>
					 			  									
				<cfelse>
								
						 <tr class="labelit fixlengthlist" style="font-size:15px;cursor: pointer;" >
					      <td style="padding-top:2px;padding-bottom:2px" colspan="3" align="center" id="bd#drag#" bgcolor="#Boxcolor#">
						  #ActionDescription#		
						  <cfset link = "'#val#'">			
						  <input type="hidden" name="action#drag#" id="action#drag#" value="#val#">
						  <input type="hidden" name="type#drag#"   id="type#drag#"   value="Action">
						  <input type="hidden" name="leg#drag#"    id="leg#drag#"    value="">
						 </td></tr>
					  
				</cfif>  			
			
			</cfif>		 			  
		 
		 </cfif>
		
			<!---	
			<cfif sendback gte 1 and Check.ActionOrder neq "" and URL.Connector eq "INIT">   <!--- don't show on go to squares --->
			--->	
			
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
					    onMouseOver="javascript:showaction('#drag#','#Branch.ProcessActionCode#','clsFlowActionHighlight labelmedium','clsFlowActionHighlight labelmedium')"
						onMouseOut="javascript:showaction('#drag#','#Branch.ProcessActionCode#','labelit','labelmedium')">
							<td colspan="3" style="height:15px;padding-right:4px" class="labelmedium" align="right" bgcolor="FDDCAA" id="#Branch.ProcessActionCode##drag#">
							<cfif first eq "YES">
								<cfswitch expression="#sendback#">
									<cfcase Value = '1'><img src="#SESSION.root#/images/SendDown.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
									<cfcase Value = '2'><img src="#SESSION.root#/images/SendUp.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
									<cfcase Value = '3'><img src="#SESSION.root#/images/SendRight.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
								</cfswitch>
								<cfset First = "NO">
							</cfif>
							#Branch.ProcessActionCode#
							</td>
						</tr> 
					</cfloop>
				<cfelse>		
					<tr style="cursor: pointer;">
						<td colspan = "3" style="height:20px" align="right" height="5" bgcolor="FDDCAA">
						<cfswitch expression="#Sendback#">
							<cfcase Value = '1'><img src="#SESSION.root#/images/SendDown.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
							<cfcase Value = '2'><img src="#SESSION.root#/images/SendUp.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
							<cfcase Value = '3'><img src="#SESSION.root#/images/SendRight.gif" alt="" border="0" style="cursor: pointer;"></cfcase>
						</cfswitch> 					  
						</td>
					</tr>  
				</cfif> 	
				
		</cfif>

	     </table>
		 
		 </td></tr>
		 
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
			AND    ActionCode = '#val#'
			AND (LEN(MethodScript) > 6 or DocumentId is not NULL)	
		</cfquery>	
				 
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
			
		   <tr><td colspan="2" style="padding-left:4px;padding-right:4px">
		   <cfset lvl = lvl+1>
		   <cfif Next.actionType eq "Action"> 		   
			    <cfinclude template="FlowViewAction.cfm">				
		   <cfelse>		   		  
		        <cfinclude template="FlowViewDecision.cfm"> 
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