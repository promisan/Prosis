
<cfoutput>

<cfset vType = "accordion">
<cfset vHeight = "18">
<cfset vTogglerSize = "18">
<cfset vTextSize = "18">

<cf_layout type="#vType#">
	
	<!--- Step Due --->
	<cf_tl id="Step Due" var="1">
	<cf_layoutArea 
		id 		= "stepDue" 
		label 	= "#lt_text#"
		labelHeight = "#vHeight#"
		stateIconHeight = "#vTogglerSize#"
		labelFontSize = "#vTextSize#">
		
			<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
			<tr><td height="1"></td></tr>
			
			<tr><td colspan="2" height="20">
			<table width="100%" align="center">
			<tr>
				<td class="labelit">Execute stored procedure once this action becomes the next action</td>
				<td>&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="DueActorAuthenticate" id="DueActorAuthenticate" class="radiol" value="1" <cfif ScriptDue.ActorAuthenticate eq 1>checked</cfif>></td>		
				<td>&nbsp;</td>
				<td><img src="#SESSION.root#/images/authenticate.gif" alt="" align="absmiddle" border="0"></td>
				<td>&nbsp;</td>		
				<td class="labelit">Action Requires authentication</td>
			</tr>
			</table>
			
			</td></tr>
						
			<tr><td colspan="2" class="labelit"></td></tr>					
			
			<tr><td colspan="2" height="30" valign="top">	
			
				<table cellspacing="0" cellpadding="0" class="formpadding">
				
				<cfquery name="ObjectStatus" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM Ref_EntityStatus
					WHERE EntityCode  = '#URL.EntityCode#'			
				</cfquery>
				
				<tr>
				
				<td class="labelit">Database Alias:</td>
				
				<td>
				
				<cfset ds = "#ScriptDue.MethodDataSource#">
				<cfif ds eq "">
				 <cfset ds = "AppsOrganization">
				</cfif>
			
				<!--- Get "factory" --->
				<CFOBJECT ACTION="CREATE"
				TYPE="JAVA"
				CLASS="coldfusion.server.ServiceFactory"
				NAME="factory">
				
				<CFSET dsService=factory.getDataSourceService()>		
	
				<cfset dsNames = dsService.getNames()>
				<cfset ArraySort(dsnames, "textnocase")> 
			
				<select name="MethodDueDataSource" id="MethodDueDataSource" class="regularxl" style="width:200">
													
					<CFLOOP INDEX="i"
						FROM="1"
						TO="#ArrayLen(dsNames)#">
					
						<CFOUTPUT>
						<option value="#dsNames[i]#" <cfif ds eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
						</cfoutput>
					
					</cfloop>
					
				</select>
										
				</td>
				</tr>
				
				<tr>
				
				<td class="labelit">Preset Document status:&nbsp;</td>
				
				<td>
				<select name="DueEntityStatus" id="DueEntityStatus" class="regularxl" style="width:200">
					    <option value="">No status selected</option>
						<cfloop query="ObjectStatus">
					    	<option value="#EntityStatus#"
							 <cfif EntityStatus eq Get.DueEntityStatus>selected</cfif>>
							 #EntityStatus# #StatusDescription#
							 </option>
						</cfloop>
				</select>
				
				</td>
				</tr>
				
				<tr>
							
				<td class="labelit">Custom script:</td>	
				<td>
	
				<select name="MethodDue" id="MethodDue" class="regularxl" style="width:200">
					    <option value="">No script selected</option>
						<cfloop query="Script">
					    	<option value="#DocumentId#"
							 <cfif DocumentId eq ScriptDue.DocumentId>selected</cfif>>
							 #DocumentDescription#</option>
						</cfloop>
				</select>
				</td></tr>
				
				</table>	
				
			</td></tr>		
									
			<TR>
		    <td valign="top" class="labelit" height="10">Manual Script:</b> Use <b>@action, @object, @key1, @key2, @key3 and @key4</b> to refer to the object identification</td>
			</tr>
			<tr><td height="1"></td></tr>
			<tr>
		    <TD colspan="2" align="right" valign="top">		
		    	<textarea style="height:180px;width:100%;padding:3px;font-size:13px" class="regular" name="DueScript" id="DueScript"><cfoutput>#ScriptDue.MethodScript#</cfoutput></textarea>
			</TD>
			</TR>			
						
			<cfif FileExists("#SESSION.rootPath#\Tools\Process\EntityAction\#Get.ActionCode#_Deny.cfm")>
			   <tr><td height="2" colspan="2"><b>Attention:</b>&nbsp;<font color="CC3333"> Embedded deny stored procedure script \#Get.ActionCode#_Deny.cfm activated for this step.</font></td></tr>
			   <tr><td height="6"></td></tr>	
			</cfif>
			
			<tr><td align="center" colspan="2" height="30" valign="top">
								
				<cfif URL.PublishNo eq "">
				<input class="button10g" style="width:120px;;height:23px;" type="button" name="Delete" id="Delete" value="Remove" onClick="removeaction()">
				</cfif>
				
				<input class="button10g" 
				     type="button" style="width:120px;height:23px;"
					 onclick="saveform('3')" 
					 name="VerifyButton" 
					 id="VerifyButton"
					 value="Verify Scripts">
			
				<input class="button10g" style="width:120px;height:23px;" type="button" name="Update" id="Update" value="Update" onClick="savequick()">
				<cfparam name="url.action" default="flow">
					
			</td></tr>	
			
			</table>
		
	</cf_layoutArea>
		
	<!--- Condition --->
	<cf_tl id="Submission Condition" var="1">
	<cf_layoutArea 
		id 		= "submitCondition" 
		label 	= "#lt_text#"
		labelHeight = "#vHeight#"
		stateIconHeight = "#vTogglerSize#"
		labelFontSize = "#vTextSize#">
		
		<table width="97%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
		<tr><td height="5"></td></tr>		
		
		<TR>
		    <TD height="16" class="labelit" style="cursor:pointer" colspan="1"><cf_UIToolTip  tooltip="Turn-off/on the condition">Enable:</cf_UIToolTip></b></TD>
		    <TD>
		    	<table>
				<tr><td class="labelit">
			    <input type="radio" class="radiol" name="ConditionEnable" id="ConditionEnable" value="0" <cfif ScriptCondition.MethodEnabled eq "0">checked</cfif>> No
				<INPUT type="radio" class="radiol" name="ConditionEnable" id="ConditionEnable" value="1" <cfif ScriptCondition.MethodEnabled neq "0">checked</cfif>> Yes
				</td>
				</tr>
				</table>
			</TD>
		</TR>	
							
		<tr>
		<td height="16" class="labelit" style="cursor:pointer"><cf_UIToolTip  tooltip="Associate a Condition script which must return a variable to be declared under [Return Variable]">Condition Script:</cf_UIToolTip></td>
			<td>
            <table cellspacing="0" cellpadding="0">
			<tr><td>
			
				<select name="MethodCondition" id="MethodCondition" class="regularxl" onchange="toggle('scondition',this.value)">
					    <option value="">No script selected</option>
						<cfloop query="Script">
					    	<option value="#DocumentId#"
							 <cfif DocumentId eq ScriptCondition.DocumentId>selected</cfif>>
							 #DocumentDescription#</option>
						</cfloop>
				</select>
				
			</td>
			
			<cfif ScriptCondition.documentId eq "">
			  <cfset cl = "hide">
			<cfelse>
			  <cfset cl = "regular">  
			</cfif>
			
			<td style="padding-left:3px">
			
			 <img src="#SESSION.root#/Images/search.png"
			     alt="View script file"
			     name="scondition"
			     id="scondition"
			     width="25"
			     height="25"
			     border="0"
			     align="absmiddle"
			     class="#cl#"
			     style="cursor: pointer; border: 1pt solid gray;"
			     onClick="showscript(MethodCondition.value)"
			     onMouseOver="document.scondition.src='#SESSION.root#/Images/search.png'"
			     onMouseOut="document.scondition.src='#SESSION.root#/Images/search.png'">
				 
			</td>
			</tr>
			</table>
		</tr>	
		
		<tr>
			
			<td height="20" class="labelit">Script Alias:</td>
			
			<td>
			
			<cfset ds = "#ScriptCondition.MethodDataSource#">
			<cfif ds eq "">
			 <cfset ds = "AppsOrganization">
			</cfif>
		
			<!--- Get "factory" --->
			<CFOBJECT ACTION="CREATE"
			TYPE="JAVA"
			CLASS="coldfusion.server.ServiceFactory"
			NAME="factory">
			
			<CFSET dsService=factory.getDataSourceService()>		
			
			<cfset dsNames = dsService.getNames()>
			<cfset ArraySort(dsnames, "textnocase")> 
		
			<select name="MethodConditionDataSource" id="MethodConditionDataSource" class="regularxl" style="width:200">
												
				<CFLOOP INDEX="i"
					FROM="1"
					TO="#ArrayLen(dsNames)#">
				
					<CFOUTPUT>
					<option value="#dsNames[i]#" <cfif ds eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
					</cfoutput>
				
				</cfloop>
				
			</select>
									
			</td>
		</tr>	
				
		<TR>
	    <TD height="100%" class="labelit" valign="top" style="cursor:pointer"><cf_UIToolTip tooltip="Enter a valid SQL syntax which queries the database for a value to be used as a condition">SQL Query Script:</cf_UIToolTip></TD>
		<TD align="right">
	    	<textarea 
			 style="width:100%;height:110px;padding:3px;font-size:12px" 
			 class="regular" 			
			 name="ConditionScript" 
			 id="ConditionScript"><cfoutput>#Get.ConditionScript#</cfoutput></textarea>
		</TD>
		</TR>
		
		<tr><td height="1"></td></tr>
		<tr><td height="10" class="labelit" align="right"></td><td colspan="1" class="labelit">
		<cfif Get.ActionType eq "Action">
		Script is executed prior to submitting this workflow step (Complete or Agreed) 
		<cfelse>
		Executed prior to a positive decision. <b>Record the condition for a negative decision under workflow settings</b>!
		</cfif>
		<br>Use <b>@action, @object, @key1, @key2, @key3 and @key4</b> to refer to the object identification</td></tr>				
		<tr><td height="0"></td></tr>
			
		
		<TR>
	    <TD height="15" class="labelit" style="cursor:pointer;padding-right:10px"><cf_UIToolTip  tooltip="This is either a field or a variable return by the selected script">Return Variable:</cf_UIToolTip></TD>
	    <TD>
		<table><tr><td class="labelit">
		<cfinput class="regularxl" type="Text" value="#Get.ConditionField#"  name="ConditionField" required="No" size="30" maxlength="30">
		</td>
		 <TD height="15" class="labelit" style="padding-left:10px;cursor:pointer"><cf_UIToolTip  tooltip="Variable condition like [gte '4'] or [is 'No']">Operand & Value:</cf_UIToolTip></TD>
	    <TD>
		<cfinput class="regularxl" type="Text" value="#Get.ConditionValue#"  name="ConditionValue" required="No" size="10" maxlength="20">
		</TD>
		</tr></table>
		</TD>
		</TR>		
			
								
		<TR>
	    <TD height="15" class="labelit" style="cursor:pointer"><cf_UIToolTip  tooltip="Error Message to be shown to the user">Error message:</cf_UIToolTip></TD>
	    <TD>
		<cfinput class="regularxl" type="Text" value="#Get.ConditionMessage#"  name="ConditionMessage" required="No" size="50" maxlength="80">
		</TD>
		</TR>
		
		<tr><td align="center" colspan="2" height="30">
							
				<cfif URL.PublishNo eq "">
				<input class="button10g" style="width:120;height:23" type="button" name="Delete" id="Delete" value="Remove" onClick="removeaction()">
				</cfif>
				
				<input class="button10g" style="width:120;height:23" 
				     type="button" 
					 onclick="saveform('3')" 
					 name="VerifyButton" 
					 id="VerifyButton"
					 value="Verify Scripts">
			
				<input class="button10g" style="width:120;height:23" type="button" name="Update" id="Update" value="Update" onClick="savequick()">
				<cfparam name="url.action" default="flow">
					
			</td></tr>	
						
		</table>
	
	</cf_layoutArea>
	
	<!--- Decision --->
	<cfif Get.ActionType eq "Decision">
		<cf_tl id="Decision: Positive" var="1">
	<cfelse>
		<cf_tl id="Forward" var="1">
	</cfif>
	<cf_layoutArea 
		id 		= "decision" 
		label 	= "#lt_text#"
		labelHeight = "#vHeight#"
		stateIconHeight = "#vTogglerSize#"
		labelFontSize = "#vTextSize#">
		
		<table width="97%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
		<tr><td height="5"></td></tr>
							
		<cfif get.ActionType eq "Action">
		
		<TR>
		    <TD height="5" class="labelit" colspan="1">Enable submission:</b></TD>
		    <TD>
		    	<table>
				<tr><td class="regular">
			    <input type="radio" name="SubmissionEnable" id="SubmissionEnable" value="0" <cfif ScriptSubmission.MethodEnabled eq "0">checked</cfif>> No
				<INPUT type="radio" name="SubmissionEnable" id="SubmissionEnable" value="1" <cfif ScriptSubmission.MethodEnabled neq "0">checked</cfif>> Yes
				</td>
				<td>&nbsp;&nbsp;</td>
				<td>
					<input type="checkbox" class="radiol" name="SubmissionActorAuthenticate" id="SubmissionActorAuthenticate" value="1" <cfif ScriptSubmission.ActorAuthenticate eq "1"> checked</cfif>>
				</td>
				<td>&nbsp;</td>
				<td><img src="#SESSION.root#/images/authenticate.gif" alt="" align="absmiddle" border="0"></td>
				<td>&nbsp;</td>
				<td class="labelit">Action Requires authentication</td>
				</tr>
				</table>
			</TD>
			</TR>
			
		<cfelse>
		
			<TR>
		    <TD class="labelit" height="5" colspan="1">Enable Decision/Positive</b></TD>
		    <TD>
		    	<table>
				<tr><td class="labelit">
			    <input type="radio" class="radiol" name="SubmissionEnable" id="SubmissionEnable" value="0" <cfif ScriptSubmission.MethodEnabled eq "0">checked</cfif>> No
				<INPUT type="radio" class="radiol" name="SubmissionEnable" id="SubmissionEnable" value="1" <cfif ScriptSubmission.MethodEnabled neq "0">checked</cfif>> Yes
				</td>				
				<td>&nbsp;&nbsp;</td>
				<td>
					<input type="checkbox" class="radiol" name="SubmissionActorAuthenticate" id="SubmissionActorAuthenticate" value="1" <cfif ScriptSubmission.ActorAuthenticate eq "1">checked</cfif>>
				</td>
				<td>&nbsp;</td>
				<td><img src="#SESSION.root#/images/authenticate.gif" alt="" align="absmiddle" border="0"></td>
				<td>&nbsp;</td>
				<td class="labelit">Action Requires authentication</td>
				</tr>
				</table>
			</TD>
			</TR>
		
		</cfif>		
		
		
		
		<tr><td class="labelit" height="30">Script file:</td>
		    <TD>	
			<table><tr><td>		
			<select class="regularxl" name="MethodSubmission" id="MethodSubmission" width="200" onchange="toggle('ssubmission',this.value)">
				    <option value="">No script selected</option>
					<cfloop query="Script">
				    	<option value="#DocumentId#"
						 <cfif DocumentId eq ScriptSubmission.DocumentId>selected</cfif>>
						 #DocumentDescription#</option>
					</cfloop>
			</select>
			</td>
			
			<cfif ScriptSubmission.documentId eq "">
			  <cfset cl = "hide">
			<cfelse>
			  <cfset cl = "regular">  
			</cfif>
			
			<td style="padding-left:2px">
			
			 <img src="#SESSION.root#/Images/search.png"
			     alt="View script file"
			     name="scondition"
			     id="scondition"
			     width="25"
			     height="25"
			     border="0"
			     align="absmiddle"
			     class="#cl#"
			     style="cursor: pointer; border: 1pt solid gray;"
			     onClick="showscript(MethodSubmission.value)"
			     onMouseOver="document.scondition.src='#SESSION.root#/Images/search.png'"
			     onMouseOut="document.scondition.src='#SESSION.root#/Images/search.png'">
								 
			</td>
			
			</tr>
			</table>
		</td></tr>	
		
		<tr>
			
			<td class="labelit" height="5"><cf_UIToolTip tooltip="Select a database alias and an SQL script">Manual Script:</cf_UIToolTip></td>
			
			<td>
			
			<cfset ds = "#ScriptSubmission.MethodDataSource#">
			<cfif ds eq "">
			 <cfset ds = "AppsOrganization">
			</cfif>
		
			<!--- Get "factory" --->
			<CFOBJECT ACTION="CREATE"
			TYPE="JAVA"
			CLASS="coldfusion.server.ServiceFactory"
			NAME="factory">
			
			<CFSET dsService=factory.getDataSourceService()>		
			
			<cfset dsNames = dsService.getNames()>
			<cfset ArraySort(dsnames, "textnocase")> 
		
			<select class="regularxl" name="MethodSubmissionDataSource" id="MethodSubmissionDataSource">
												
				<CFLOOP INDEX="i"
					FROM="1"
					TO="#ArrayLen(dsNames)#">
				
					<CFOUTPUT>
					<option value="#dsNames[i]#" <cfif ds eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
					</cfoutput>
				
				</cfloop>
				
			</select>
									
			</td>
		</tr>
						
		<tr><td height="3"></td></tr>
		<tr>
	    <TD colspan="2" height="100%">
	    	<textarea style="width:100%;height:180px;padding:3px;font-size:13px" class="regular" name="SubmissionScript" id="SubmissionScript"><cfoutput>#ScriptSubmission.MethodScript#</cfoutput></textarea>
		</TD>
		</TR>
		
		<tr><td height="1"></td></tr>
		<tr><td height="15" class="labelit" colspan="2">Manual and/or script file is executed upon submitting this workflow step (Complete or Agreed) 
		<br>Use <b>@action, @object, @key1, @key2, @key3 and @key4</b> to refer to the object identification. Use <b>@acc, @last, @first</b> to refer to the actor.</td></tr>
					
		<cfif FileExists("#SESSION.rootPath#\Tools\Process\EntityAction\#Get.ActionCode#_Submit.cfm")>
		   <tr><td height="20" colspan="2" class="labelit"><b>Attention:</b>&nbsp;<font color="CC3333"> Embedded submission stored procedure script \#Get.ActionCode#_Submit.cfm activated for this step.</font></td></tr>
		</cfif>
		
		<tr><td align="center" colspan="2" height="30">
							
				<cfif URL.PublishNo eq "">
				<input class="button10g" style="width:120;height:23" type="button" name="Delete" id="Delete" value="Remove" onClick="removeaction()">
				</cfif>
				
				<input class="button10g" style="width:120;height:23" 
				     type="button" 
					 onclick="saveform('3')" 
					 name="VerifyButton" 
					 id="VerifyButton"
					 value="Verify Scripts">
			
				<input class="button10g" style="width:120;height:23" type="button" name="Update" id="Update" value="Update" onClick="savequick()">
				<cfparam name="url.action" default="flow">
					
			</td></tr>	
									
		</table>
		
	</cf_layoutArea>
	
	
	<cfif Get.ActionType eq "Decision">
	
		<!--- Negative --->
		<cf_tl id="Method: Deny" var="1">
		<cf_layoutArea 
			id 		= "negative" 
			label 	= "#lt_text#"
			labelHeight = "#vHeight#"
			stateIconHeight = "#vTogglerSize#"
			labelFontSize = "#vTextSize#">
				
			<table width="97%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
			<tr><td height="5"></td></tr>
									
			<tr>
												
			    <TD height="15" class="labelit" colspan="1">Enable Deny:</b></TD>
			    <TD>
			    	<table cellspacing="0" cellpadding="0">
					<tr><td class="regular">
				    <input type="radio" class="radiol" name="DenyEnable" id="DenyEnable" value="0" <cfif ScriptDeny.MethodEnabled eq "0">checked</cfif>> 
					</td>
					<td style="padding-left:2px" class="labelit">No</td>
					<td style="padding-left:4px">
					<INPUT type="radio" class="radiol" name="DenyEnable" id="DenyEnable" value="1" <cfif ScriptDeny.MethodEnabled neq "0">checked</cfif>> 
					</td>
					<td style="padding-left:2px" class="labelit">Yes</td>										
					
					<td  style="padding-left:7px">
						<input type="checkbox" class="radiol" name="DenyActorAuthenticate" id="DenyActorAuthenticate" value="1" <cfif ScriptDeny.ActorAuthenticate eq "1">checked</cfif>>
					</td>
					<td>&nbsp;</td>
					<td><img src="#SESSION.root#/images/authenticate.gif" alt="" align="absmiddle" border="0"></td>
					<td>&nbsp;</td>
					<td class="labelit">Action Requires authentication</td>
					
					</tr>						
					</table>
				</TD>	
			
			</tr>
			
											
			<tr>
			<td height="15" class="labelit">Script File:</b></td>
			<td>
			<table><tr><td>		
			<select class="regularxl" name="MethodDeny" id="MethodDeny">
				    <option value="">No script selected</option>
					<cfloop query="Script">
				    	<option value="#DocumentId#"
						 <cfif DocumentId eq ScriptDeny.DocumentId>selected</cfif>>
						 #DocumentDescription#</option>
					</cfloop>
			</select>
			</td>
			<td style="padding-left:2px">		
			 <img src="#SESSION.root#/Images/search.png"
			     alt="View script file"
			     name="scondition"
			     id="scondition"
			     width="26"
			     height="25"
			     border="0"
			     align="absmiddle"
			     class="#cl#"
			     style="cursor: pointer; border: 1pt solid gray;"
			     onClick="showscript(MethodDeny.value)"
			     onMouseOver="document.scondition.src='#SESSION.root#/Images/button.jpg'"
			     onMouseOut="document.scondition.src='#SESSION.root#/Images/contract.gif'">
			</td>	
			</tr>
			</table>				
			</TR>				
			
			<tr>
			
			<td height="5" class="labelit"><cf_UIToolTip tooltip="Select a database alias and record a valid SQL script">Manual Script:</cf_UIToolTip></td>
					
			<td>
			
			<cfset ds = "#ScriptDeny.MethodDataSource#">
			<cfif ds eq "">
			 <cfset ds = "AppsOrganization">
			</cfif>
		
			<!--- Get "factory" --->
			<CFOBJECT ACTION="CREATE"
			TYPE="JAVA"
			CLASS="coldfusion.server.ServiceFactory"
			NAME="factory">
			
			<CFSET dsService=factory.getDataSourceService()>		
			
			<cfset dsNames = dsService.getNames()>
			<cfset ArraySort(dsnames, "textnocase")> 
		
			<select class="regularxl" name="MethodDenyDataSource" id="MethodDenyDataSource" style="width:200;font:9px">
												
				<CFLOOP INDEX="i"
					FROM="1"
					TO="#ArrayLen(dsNames)#">
				
					<CFOUTPUT>
					<option value="#dsNames[i]#" <cfif ds eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
					</cfoutput>
				
				</cfloop>
				
			</select>
									
			</td>
		   </tr>						
			
			<tr>
		    <TD colspan="2" height="100%" align="right">
		    	<textarea style="width:100%;height:190px;padding:3px;font-size:13px" class="regular" name="DenyScript"><cfoutput>#ScriptDeny.MethodScript#</cfoutput></textarea>
			</TD>
			</TR>
					
			<tr><td height="1"></td></tr>
			<tr><td height="15" colspan="2" class="labelit">Manual script : Use <b>@action, @object, @key1, @key2, @key3 and @key4</b> to refer to the object identification. Use <b>@acc, @last, @first</b> to refer to the actor</td></tr>
			<tr><td height="1"></td></tr>		
				
			<cfif FileExists("#SESSION.rootPath#\Tools\Process\EntityAction\#Get.ActionCode#_Deny.cfm")>
			     <tr>
				    <td height="15" class="labelit" colspan="2"><b>Attention:</b>&nbsp;<font color="CC3333"> There is an embedded deny stored procedure script \#Get.ActionCode#_Deny.cfm activated for this step.</font></td>
				 </tr>			  
			</cfif>
			
			<tr><td align="center" colspan="2" height="30">
							
				<cfif URL.PublishNo eq "">
				<input class="button10g"  style="width:120;height:23" type="button" name="Delete" id="Delete" value="Remove" onClick="removeaction()">
				</cfif>
				
				<input class="button10g" 
				     type="button" 
					 onclick="saveform('3')" 
					 name="VerifyButton" 
					 id="VerifyButton"
					  style="width:120;height:23"
					 value="Verify Scripts">
			
				<input class="button10g"  style="width:120;height:23" type="button" name="Update" id="Update" value="Update" onClick="savequick()">
				<cfparam name="url.action" default="flow">
					
			</td></tr>	
			
			</table>
			
		</cf_layoutArea>					
				
	<cfelse>	

	 <input type="hidden" name="ResetEnable" id="ResetEnable" value="0">
	 <input type="hidden" name="ResetScript" id="ResetScript" value="">		
	 <input type="hidden" name="MethodDeny" id="MethodDeny" value="">				

	</cfif>
	
</cf_layout>							
			
			
</cfoutput>			
