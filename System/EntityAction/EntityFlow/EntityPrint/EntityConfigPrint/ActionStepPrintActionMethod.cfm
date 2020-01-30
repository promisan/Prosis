
<cfoutput>

<cfset ManualScriptExists = "No">

<table width="97%" cellspacing="0" cellpadding="0" align="center">		
	<tr><td height="6"></td></tr> 	
	<tr><td>Step Due</td></tr>
	<tr>
	<td>
		<cfquery name="ActionScript" 
			dbtype="query">
				SELECT *
				FROM Script
				Where DocumentId = '#ScriptDue.DocumentId#' 
		</cfquery>					
		
		<table width="97%" cellspacing="0" cellpadding="0" align="center">
				
			<tr><td width="30%" height="1"></td></tr>
			
			<tr><td>Execute stored procedure: </td>					
			<td><cfif ScriptDue.DocumentId neq "">#ActionScript.DocumentDescription#<cfelse>None</cfif></td>
			</tr>		
		</table>

		<table width="97%" cellspacing="0" cellpadding="0" align="center">
			
			<tr><td width="30%" height="1"></td></tr>			
			<tr><td valign="top">Manual Due Script: </td><td>
				<cfif ScriptDue.MethodScript neq "">
					#ScriptDue.MethodScript#
					<cfset ManualScriptExists = "Yes">
				<cfelse>
					None
				</cfif>
			</td></tr>		
			
			<cfif FileExists("#SESSION.rootPath#\Tools\Process\EntityAction\#GetAction.ActionCode#_Deny.cfm")>
			   <tr><td colspan="2"><b>Attention:</b>&nbsp;<font color="CC3333"> Embedded deny stored procedure script \#GetAction.ActionCode#_Deny.cfm activated for this step.</font></td></tr>
			   <tr><td height="6"></td></tr>	
			</cfif>
		
		</table>
	</td>
	</tr>
	
	<cfset Seperator = "6">
	
	<tr><td height="#Seperator#"></td></tr>			
		
	<tr><td>
		Submission Condition 
	</td></tr>

	<tr><td>       
	
		<cfif GetAction.ConditionScript eq "">
			<table width="97%" cellspacing="0" cellpadding="0" align="center">			
					<tr><td width="30%" height="1"></td></tr>			
					<tr><td>None</td></tr>		
			</table>
		<cfelse>
			<cfset ManualScriptExists = "Yes">
			<table width="97%" cellspacing="0" cellpadding="0" align="center">
					
				<tr><td width="30%" height="1"></td></tr>			
				
				<tr>
				<td valign="top" class="regular">Condition Script: </td>
				<td>#GetAction.ConditionScript#</td>
				</tr>		
				<tr><td height="2"></td></tr>
			
				<TR>
			    <TD class="regular">Condition field:</TD>
			    <TD>
				<cfif GetAction.ConditionField neq "">#GetAction.ConditionField#<cfelse>None</cfif>
				</TD>
				</TR>
				
				
				<TR>
			    <TD class="regular">Operand & Value:</TD>
			    <TD>
				<cfif GetAction.ConditionValue neq "">#GetAction.ConditionValue#<cfelse>None</cfif>
				</TD>
				</TR>
										
				<TR>
			    <TD class="regular">Error message:</TD>
			    <TD>
				<cfif GetAction.ConditionMessage neq "">#GetAction.ConditionMessage#<cfelse>None</cfif>		
				</TD>
				</TR>
				
				<tr><td height="1"></td></tr>
				<tr valign="top"><td>Note:</td><td>
				<cfif GetAction.ActionType eq "Action">
					Script is executed prior to submitting this workflow step (Complete or Agreed) 
				<cfelse>
					Executed prior to a positive decision. <b>Record the condition for a negative decision under workflow settings</b>!
				</cfif>
				</td></tr>
							
			</table>
		</cfif>	
	</td></tr>

	<tr><td height="#Seperator#"></td></tr>			

	<tr><td>
		<table width="97%" cellspacing="0" cellpadding="0" align="center">
		<tr><td width="30%"></td></tr>	
		
		<cfif GetAction.ActionType eq "Decision">
			<tr bgColor="CEFFCE"><td>
				Decision: #GetAction.ActionGoToYesLabel# 
			</td>
			<td>&nbsp;<cfif ActionYes.ActionType eq "Action">Action Step:<cfelse>Decision Step:</cfif>: #ActionYes.ActionCode# #ActionYes.ActionDescription#
			</td></tr>
		<cfelse>
			<tr><td>
			&nbsp;Forward
			</td></tr>
		</cfif>
		
		</table>
	</td></tr>
	
	<tr><td>       
	
		<cfquery name="ActionScript" 
				dbtype="query">
				SELECT *
				FROM Script
				Where DocumentId = '#ScriptSubmission.DocumentId#'
				</cfquery>					
		
		<table width="97%" cellspacing="0" cellpadding="0" align="center">
			<tr><td>
				<table width="97%" cellspacing="0" cellpadding="0" align="center">
						
					<tr><td width="30%">Script File: </td>					
					<td><cfif ScriptSubmission.DocumentId neq "">#ActionScript.DocumentDescription#<cfelse>None</cfif></td>
					</tr>		
					
					<cfif GetAction.ActionType eq "Action">
						<tr><td>Enable Submission: </td>					
						<td><cfif ScriptSubmission.MethodEnabled eq "1">Yes<cfelse>No</cfif></td>
						</tr>		
					</cfif>
					
				</table>
			</td></tr>
		</table>
	
	</td></tr>
	
	<tr><td>
		<cfif ScriptSubmission.MethodScript neq "">
			<cfset ManualScriptExists = "Yes">
			<table width="97%" cellspacing="0" cellpadding="0" align="center">
				
				<tr><td width="30%" height="1"></td></tr>			
				<tr><td valign="top">Manual Submission Script: </td><td>#ScriptSubmission.MethodScript#</td></tr>		
				
				<cfif FileExists("#SESSION.rootPath#\Tools\Process\EntityAction\#GetAction.ActionCode#_Deny.cfm")>
				   <tr><td colspan="2"><b>Attention:</b>&nbsp;<font color="CC3333"> Embedded deny stored procedure script \#GetAction.ActionCode#_Deny.cfm activated for this step.</font></td></tr>
				   <tr><td height="6"></td></tr>	
				</cfif>
			
				<tr><td height="1"></td></tr>
				<tr><td>Note:</td><td colspan="1">Manual and/or script file is executed upon submitting this workflow step (Complete or Agreed)</td></tr> 
				<tr><td height="1"></td></tr>
		
			</table>
		</cfif>
	</td></tr>			
	
	<cfif GetAction.ActionType eq "Decision">
	
	<tr><td height="#Seperator#"></td></tr>
	
	<tr><td>
		<table width="97%" cellspacing="0" cellpadding="0" align="center">
			<tr><td bgColor="FDDFDB" width="30%">
				Decision: #GetAction.ActionGoToNoLabel# 
			</td>
			<td bgColor="FDDFDB">&nbsp;<cfif ActionNo.ActionType eq "Action">Action Step:<cfelse>Decision Step:</cfif>: #ActionNo.ActionCode# #ActionNo.ActionDescription#
			</td></tr>
		</table>
	</td></tr>
	
	<tr><td>       
		
		
		<cfquery name="ActionScript" 
			dbtype="query">
			SELECT *
			FROM Script
			Where DocumentId = '#ScriptDeny.DocumentId#'
			</cfquery>					
	
		<table width="97%" cellspacing="0" cellpadding="0" align="center">
			<tr><td>
				<table width="97%" cellspacing="0" cellpadding="0" align="center">
						
					<tr><td height="1" width="30%"></td></tr>		
					
					<tr><td>Enable Deny Script: </td>					
					<td><cfif ScriptDeny.MethodEnabled eq "1">Yes</td>
						<tr><td>Script File: </td>					
						<td>	<cfif ScriptDeny.DocumentId eq "">#ActionScript.DocumentDescription#<cfelse>None</cfif></td>
					<cfelse>No</cfif></td>
					</tr>				
					
				</table>
			</td></tr>
		</table>
	</td></tr>
	
	<tr><td>
		<cfif ScriptDeny.MethodScript neq "">
			<cfset ManualScriptExists = "Yes">
			<table width="97%" cellspacing="0" cellpadding="0" align="center">
				
				<tr><td width="30%" height="1"></td></tr>			
				<tr><td valign="top">Manual Submission Deny Script: </td><td>#ScriptDeny.MethodScript#</td></tr>			
					
				<tr><td height="1"></td></tr>
				<tr valign="top"><td>Note:</td><td colspan="1">Manual and/or script file is executed upon submitting this workflow step (Denied) 
				</td></tr>
							
				<tr><td height="1"></td></tr>
			</table>
		</cfif>		
	</td></tr>   
	</cfif>
	
	<tr><td>
		<cfif ManualScriptExists eq "Yes">
			<table width="97%" cellspacing="0" cellpadding="0" align="center">			
				<tr valign="top"><td width="30%">Script Parameters:</td><td ><b>@action, @object, @key1, @key2, @key3 and @key4</b> to refer to the object identification</td></tr>
				<tr><td></td><td><b>@acc, @last, @first</b> to refer to the actor</td></tr>
			</table>	
		</cfif>
	</td></tr>
	
</table>	   

</cfoutput>			
